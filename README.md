# TD5 — RED-401 Airflow and Terraform

Elimane DIALLO

## Pipeline
`ingest_orders -> dbt_build -> publish_daily_sales`, every day at 06:00 Europe/London.

The first publication deliberately crashes after writing. With INSERT, retrying appends another row. The final DAG uses two retries and MERGE, so replaying the same sales date is idempotent. A run on day D publishes D-1. The August backfill uses logical dates 2–8 August to publish 1–7 August.

The supplied `redgrave-dbt:1.0.0` image contains dbt but no project. The `dbt/` folder supplies the course project, models, tests and audit hook. The DAG mounts this folder read-only, with build artifacts and logs in `/tmp`. Set the DBT mount source in the DAG to the absolute path of your local `dbt/` folder.

## Run Airflow
Load `redgrave-ingest:1.0.0` and `redgrave-dbt:1.0.0` locally. Copy `airflow/.env.example` to `.env`, enter the Snowflake login name and key directory plus Postgres credentials, then run `docker compose up --build` from `airflow/`. The RSA key is mounted read-only and is never included in the images.

Backfill from `airflow/`:
```powershell
docker compose exec airflow airflow backfill create --dag-id redgrave_daily --from-date 2026-08-02 --to-date 2026-08-08
```
The deliberately injected first-attempt failure remains enabled for the lab. Keep the existing INSERT duplicates as evidence; do not run a MERGE replay for their date.

## Terraform
`terraform/` declares REDGRAVE_TF.MARTS, two XSMALL warehouses with auto-suspend after 60 seconds, the analyst role and six grants. SYSADMIN creates objects; SECURITYADMIN manages roles/grants.

Copy `terraform.tfvars.example` to `terraform.tfvars`, use the Snowflake login name and local private-key path, then:
```powershell
$env:AWS_EC2_METADATA_DISABLED = 'true'
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
terraform apply
```
Disabling EC2 metadata discovery avoids unnecessary cloud credential discovery; authentication uses the explicit Snowflake RSA key.

The drift exercise manually changes the BI warehouse to SMALL, checks that Terraform proposes SMALL -> XSMALL, and restores the declared size. Do not destroy the lab objects before grading.

## CI and submission
`.github/workflows/terraform-plan.yml` plans Terraform changes on pull requests. Repository Actions secrets are SF_ORGANIZATION_NAME, SF_ACCOUNT_NAME, SF_USER and SF_PRIVATE_KEY. A fresh CI runner has no shared Terraform state and therefore proposes creation; `backend.tf.example` documents remote state for team use. Close the demonstration PR without merging.

Run `verify_results.sql` in Snowflake, and submit `submit_answers_airflow_terraform.sql` in REDGRAVE.LAB.ANSWERS. The instructor checks database evidence and the repository URL.

Source files are provided individually. Keys, credentials, local Terraform state, plan binaries, Docker image archives and generated dbt artifacts are excluded.
