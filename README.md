# TF-STATE-VERSIONS-DEMO

## Hypothesys

* A terraform project cannot reference a remote statefile (`terraform_remote_state`) for a project that has been upgraded using a newer version of the `terraform` binary.
* Terraform operations will fail if executed using a `terraform` binary that is older than the version of the statefile.

## Experiment

```
#################################
# CREATE RESOURCES WITH 0.11.7  #
#################################

╰─ cd 0.11.14/

╰─ tfenv use 0.11.7
[INFO] Switching to v0.11.7
[INFO] Switching completed

╰─ terraform --version
Terraform v0.11.7
+ provider.aws v2.58.0

Your version of Terraform is out of date! The latest version
is 0.12.24. You can update by downloading from www.terraform.io/downloads.html

╰─ terraform apply
...

aws_ebs_volume.volume: Creation complete after 11s (ID: vol-064567dec7d1b97da)

Outputs:
volume_id = vol-064567dec7d1b97da

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

#################################
#     REFERENCE WITH 0.11.7     #
#################################

╰─ cd ../0.11.7

╰─ terraform apply
data.terraform_remote_state.volume_state: Refreshing state...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

volume_id = vol-064567dec7d1b97da

#################################
#    UPGRADE STATE TO 0.11.14   #
#################################

╰─ cd ../0.11.14

╰─ tfenv use 0.11.14
[INFO] Switching to v0.11.14
[INFO] Switching completed

╰─ terraform apply
aws_ebs_volume.volume: Refreshing state... (ID: vol-064567dec7d1b97da)

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

volume_id = vol-064567dec7d1b97da

#################################
#     SWITCH BACK TO 0.11.7     #
#################################

╰─ cd ../0.11.7

╰─ tfenv use 0.11.7
[INFO] Switching to v0.11.7
[INFO] Switching completed

╰─ terraform --version
Terraform v0.11.7
+ provider.aws v2.58.0
...

╰─ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.terraform_remote_state.volume_state: Refreshing state...

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.

╰─ terraform apply
data.terraform_remote_state.volume_state: Refreshing state...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

volume_id = vol-064567dec7d1b97da

#################################
#      TRY PLAN WITH 0.11.7     #
#################################

╰─ cd ../0.11.14

╰─ terraform plan

Error:
Terraform doesn't allow running any operations against a state
that was written by a future Terraform version. The state is
reporting it is written by Terraform '0.11.14'

Please run at least that version of Terraform to continue.

```

## Results

* References (via `terraform_remote_state`) to a statefile that has been upgraded can still be read by an older terraform binary.
* A statefile that has been upgraded is incompatible with an older binary (for operations like `plan` and `apply`).