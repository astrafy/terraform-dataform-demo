locals {
  branch = var.env == "prd" ? "main" : var.env
}

resource "google_workflows_workflow" "dataform" {
  project         = module.project.project_id
  name            = "dataform_workflow"
  region          = "europe-west1"
  description     = "Trigger dataform workflow"
  service_account = google_service_account.workflow_dataform.id
  call_log_level  = "LOG_ERRORS_ONLY"

  source_contents = <<-EOF
main:
    params: [args]
    steps:
    - init:
        assign:
          - date: $${default(map.get(args, "date"), text.substring(time.format(sys.now() - 86400), 0, 10))} # Yesterday's date in format YYYY-MM-DD
          - project_id: ${module.project.project_id}
          - git_commitish: $${default(map.get(args, "git_commitish"), "${local.branch}")}
          - dataform_region: europe-west1
          - dataform_repository_name: ${google_dataform_repository.dataform_repository.name}
          - dataform_repository_id: ${google_dataform_repository.dataform_repository.id}
          - dataform_api_version: v1beta1
          - dataform_tags: $${default(map.get(args, "dataform_tags"), [])}
          - dataform_targets: $${default(map.get(args, "dataform_targets"), [])}
          - dataform_service_account: ${google_service_account.dataform_runner.email}
          - include_dependencies: $${default(map.get(args, "include_dependencies"), false)}
          - include_dependents: $${default(map.get(args, "include_dependents"), false)}
          - fully_refresh_incremental_tables: $${default(map.get(args, "fully_refresh_incremental_tables"), false)}
          - wait_for_dataform_status_check: $${default(map.get(args, "wait_for_dataform_status_check"), true)}
          - compile_only: $${default(map.get(args, "compile_only"), false)}
    - createCompilationResult:
        try:
            call: http.post
            args:
                url: $${"https://dataform.googleapis.com/" + dataform_api_version + "/" + dataform_repository_id + "/compilationResults"}
                auth:
                    type: OAuth2
                body:
                    git_commitish: $${git_commitish}
                    codeCompilationConfig:
                        vars: { "date": "$${date}" }
                        defaultDatabase: $${project_id}
            result: compilationResult
        retry:
            maxRetries: 2
            interval: 10s
    - earlyStopBeforeDataformWorkflowInvocation:
        switch:
            - condition: $${"compilationErrors" in compilationResult.body}
              raise:
                  message: $${"Error while compiling Dataform repository :" + " " +  compilationResult.body.name}
                  compilationErrors: $${compilationResult.body.compilationErrors}
            - condition: $${compile_only}
              return: "Dataform compilation successfully done. No errors found."
    - createWorkflowInvocation:
        call: http.post
        args:
            url: $${"https://dataform.googleapis.com/" + dataform_api_version + "/" + dataform_repository_id + "/workflowInvocations"}
            auth:
                type: OAuth2
            body:
                compilationResult: $${compilationResult.body.name}
                invocationConfig:
                    includedTags:
                    - $${dataform_tags}
                    includedTargets:
                    - $${dataform_targets}
                    transitiveDependenciesIncluded: $${include_dependencies}
                    transitiveDependentsIncluded: $${include_dependents}
                    fullyRefreshIncrementalTablesEnabled: $${fully_refresh_incremental_tables}
                    serviceAccount: $${dataform_service_account}
        result: workflowInvocation
    - earlyStopBeforeDataformStatusCheck:
        switch:
            - condition: $${not wait_for_dataform_status_check}
              return: $${"Dataform workflow invocation successfully created :" + " " + workflowInvocation.body.name}
    - getInvocationResult:
        call: http.get
        args:
            url:  $${"https://dataform.googleapis.com/" + dataform_api_version + "/" + workflowInvocation.body.name}
            auth:
                type: OAuth2
        result: invocationResult
    - waitForResult:
        call: sys.sleep
        args:
            seconds: 10
        next: checkInvocationResult
    - checkInvocationResult:
        switch:
            - condition: $${invocationResult.body.state == "RUNNING"}
              next: getInvocationResult
            - condition: $${invocationResult.body.state == "SUCCEEDED"}
              return: $${"Dataform workflow invocation finished with status 'succeeded' :" + " " + invocationResult.body.name}
            - condition: $${invocationResult.body.state == "CANCELLED" or invocationResult.body.state == "FAILED" or invocationResult.body.state == "CANCELING"}
              steps:
                - raiseException:
                    raise: $${"Error while running Dataform workflow :" + " " +  invocationResult.body.name + " " + invocationResult.body.state}
EOF
}
