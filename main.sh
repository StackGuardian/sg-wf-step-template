#!/usr/bin/env bash

set -e

# Helper functions for logging
# These functions provide consistent logging formats across workflow execution
log_date() {
  printf "[%s]" "$(date +'%Y-%m-%dT%H:%M:%S%z')"
}

# Error logging with red color and exit
err() {
  printf "\n--- ERROR ---"
  printf "\n\u001b[38;5;196m%s" "$1" >&2
  printf "\n_____________\n"
  exit 1
}

# Success/info logging with green color
info() {
  printf "\n--- INFO ---"
  printf "\n\u001b[32m%s" "$1"
  printf "\n____________\n"
}

# Debug logging for detailed execution flow
debug() {
  printf "\n[SG_DEBUG] %s\n" "$1"
}

# Warning logging with yellow color
warn() {
  printf "\n--- WARNING ---"
  printf "\n\u001b[33m%s\u001b[0m" "$1"
  printf "\n_______________\n"
}

# Command execution logging
print_cmd() {
  printf "\n--- COMMAND ---"
  printf "\n\u001b[33m%s" "$1"
  printf "\n_______________\n"
}

# Parse input variables from StackGuardian workflow environment
# StackGuardian injects these environment variables during workflow execution:
# - SG_MOUNTED_IAC_SOURCE_CODE_DIR: Directory where source code is mounted from a Version Control System
# - BASE64_WORKFLOW_STEP_INPUT_VARIABLES: Base64 encoded workflow step parameters provided in the Workflow Steps tab of the Workflow Settings
# - SG_MOUNTED_ARTIFACTS_DIR: Directory for storing workflow artifacts/outputs, which is then persisted and will become available in the following runs
# - BASE64_IAC_INPUT_VARIABLES: Base64 encoded infrastructure variables provided in the Source and Parameters tab of the Workflow Settings
# For a complete list of environment variables, see:
# https://docs.stackguardian.io/docs/deploy/workflows/workflow_components/deployment_enviornment/#stackguardian-environment-variables
parse_variables() {
  workingDir="${SG_MOUNTED_IAC_SOURCE_CODE_DIR}"
  workflowStepInputParams=$(echo "${BASE64_WORKFLOW_STEP_INPUT_VARIABLES}" | base64 -d -i -)
  mountedArtifactsDir="${SG_MOUNTED_ARTIFACTS_DIR}"
  workflowIACInputVariables=$(echo "${BASE64_IAC_INPUT_VARIABLES}" | base64 -d -i -)
}

# Process and validate workflow input parameters
# Demonstrates how to extract and validate parameters defined in workflow step schema
process_workflow_inputs() {
  # Extract parameters from input JSON using jq
  # These parameters are defined in the workflow step schema (schemas/input.json) and provide the SG noCode form when using this workflow step
  stringField=$(echo "${workflowStepInputParams}" | jq -r '.stringField')
  enumField=$(echo "${workflowStepInputParams}" | jq -r '.enumField')
  numberField=$(echo "${workflowStepInputParams}" | jq -r '.numberField')
  booleanField=$(echo "${workflowStepInputParams}" | jq -r '.booleanField')
  additionalParams=$(echo "${workflowStepInputParams}" | jq -r '.additionalParams')

  # Validate required parameters as defined in schema
  [[ -z "${stringField}" ]] && err "String field is required but not provided"
  [[ -z "${enumField}" ]] && err "Enum field is required but not provided"
  [[ -z "${numberField}" ]] && err "Number field is required but not provided"
}

# Demonstrate how to capture and store workflow outputs and facts
# StackGuardian uses these outputs for workflow orchestration and auditing
save_outputs_and_workflow_facts() {
  local outputsFile="${mountedArtifactsDir}/sg.outputs.json"
  local factsFile="${mountedArtifactsDir}/sg.workflow_run_facts.json"

  # Example output data - can be used by subsequent workflow steps
  local outputs='{
    "exampleOutput": {
      "value": "Sample output value",
      "type": "string"
    }
  }'

  # Save outputs to StackGuardian artifacts directory
  echo "${outputs}" > "${outputsFile}"
  debug "Saved outputs to ${outputsFile}"

  # Example workflow facts for audit and tracking
  local facts='{
    "exampleFacts": {
      "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
      "status": "success"
    }
  }'

  # Save workflow facts to StackGuardian artifacts directory which is then persisted and can be found under the Artifacts section of the workflow
  echo "${facts}" > "${factsFile}"
  debug "Saved workflow facts to ${factsFile}"
}

# Main workflow execution demonstrating the complete workflow lifecycle
main() {
  # Parse environment variables injected by StackGuardian
  parse_variables
  
  # Process and validate workflow inputs from schema
  process_workflow_inputs

  # Example workflow execution
  info "Starting example workflow step"
  
  # Demonstrate access to mounted code and artifacts
  debug "Processing workflow step with inputs:"
  debug "Working directory: ${workingDir}"
  debug "Artifacts directory: ${mountedArtifactsDir}"

  # Example command execution with logging
  print_cmd "echo 'Executing example command'"
  echo "Executing example command"

  # Capture workflow outputs and facts
  save_outputs_and_workflow_facts

  info "Workflow step completed successfully"
}

main "$@"
