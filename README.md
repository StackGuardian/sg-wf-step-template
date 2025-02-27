# StackGuardian Workflow Step Template

## Overview

This template demonstrates how to create your custom StackGuardian workflow step. Good documentation helps users understand how to configure and use your workflow step effectively through the SG noCode interface. For more details on creating workflow steps, see the [StackGuardian documentation](https://docs.stackguardian.io/docs/develop/library/workflow_step/).

## Best Practice for Documentation Structure

### Prerequisites 

Start by explaining any prerequisites including authentication requirements etc. needed before using your workflow step. For example:

- Required cloud provider credentials
- Required environment variables
- Dependencies that must be installed
- Permissions needed

Include links to relevant setup documentation when possible.

### Configuration Options

Document all configuration parameters that users can set through the SG noCode form. For each parameter:

1. Use clear section headers for each parameter defined in the SG noCode schema defined in schemas/input.json
2. Include:
   - Description of what the parameter does
   - Data type (string, number, boolean, etc)
   - Whether it's required
   - Valid options/values
   - Example values
   - Any dependencies on other parameters

## Configuring a StackGuardian Workflow

To create a workflow using this step, you can use the StackGuardian Workflow as Code feature. For more details on configuring workflows as code, refer to the [official documentation](https://docs.stackguardian.io/docs/deploy/workflows/create_workflow/json/#using-workflow-as-code).

### Example Workflow Configuration

```json
```json
{
  "Approvers": [],
  "DeploymentPlatformConfig": [
    {
      "config": {
        "integrationId": "/integrations/cloud-connector"
      },
      "kind": "CLOUD_PROVIDER_KIND"
    }
  ],
  "WfType": "CUSTOM",
  "EnvironmentVariables": [
    {
      "config": {
        "textValue": "example-value",
        "varName": "ENV_VAR_NAME"
      },
      "kind": "PLAIN_TEXT"
    }
  ],
  "VCSConfig": {
    "iacVCSConfig": {
      "useMarketplaceTemplate": false,
      "customSource": {
        "sourceConfigDestKind": "VCS_PROVIDER",
        "config": {
          "includeSubModule": false,
          "ref": "main",
          "gitCoreAutoCRLF": false,
          "auth": "/integrations/vcs-provider",
          "workingDir": "",
          "repo": "https://vcs-provider.com/example-repo",
          "isPrivate": true
        }
      }
    },
    "iacInputData": {
      "schemaType": "RAW_JSON",
      "data": {
        "exampleKey": "exampleValue"
      }
    }
  },
  "Tags": [],
  "UserJobCPU": 512,
  "UserJobMemory": 1024,
  "RunnerConstraints": {
    "type": "shared"
  },
  "Description": "Example workflow for deploying with a custom workflow step",
  "ResourceName": "example-resource-name",
  "WfStepsConfig": [
    {
      "name": "custom-wf-step",
      "mountPoints": [],
      "wfStepTemplateId": "/stackguardian/example-wf-step:version",
      "wfStepInputData": {
        "schemaType": "FORM_JSONSCHEMA",
        "data": {
          "key": "value"
        }
      },
      "approval": false,
      "timeout": 2100
    }
  ]
}
```
```

This JSON payload defines a workflow that runs using a custom workflow step template. It includes:
- **Approvers**: List of users who need to approve the workflow.
- **Deployment platform configuration**: Defines a Cloud Connector.
- **Environment variables**: Specifies environment variables required for the workflow.
- **VCS configuration**: Links the workflow to a Git repository using a VCS Connector.
- **Runner constraints**: Specifies the type of runner to use: shared or private.
- **Workflow steps**: Configures the workflow step with necessary parameters.

To get started with using this template, register on StackGuardian and create an organization, visit the [StackGuardian documentation](https://docs.stackguardian.io/docs/getting-started/setup/).
