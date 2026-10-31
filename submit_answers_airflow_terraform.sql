-- Elimane DIALLO — RED-401. Re-running updates only this lab's answers.
USE ROLE SYSADMIN;
USE WAREHOUSE REDGRAVE_WH;
MERGE INTO REDGRAVE.LAB.ANSWERS AS target
USING (
  SELECT 'RED-401' AS lab, column1::VARCHAR AS question, column2::VARCHAR AS answer
  FROM VALUES
  ('NAME', 'Elimane DIALLO'),
  ('Q1', 'The first INSERT committed its row before the simulated crash. Airflow retried the whole task, so the second INSERT appended another row for the same sales date.'),
  ('Q2', 'MERGE matches the sales_date business key and updates an existing row instead of appending another one, making repeated execution for the same date idempotent; it does not remove pre-existing INSERT duplicates.'),
  ('Q3', 'The 06:00 Europe/London run on 5 August publishes 4 August, because the command receives the logical run date minus one day and only publishes a completed day.'),
  ('Q4', 'After manually changing REDGRAVE_TF_BI_WH to SMALL, terraform plan detected warehouse_size SMALL -> XSMALL: 0 to add, 1 to change, 0 to destroy. I applied that reviewed correction and the final plan reported No changes.'),
  ('Q5', 'Remote state gives CI and every team member one shared, durable record of managed resources. Locking prevents simultaneous operations from racing and corrupting or overwriting that state.'),
  ('REPO_URL', 'https://github.com/Elimane29/red401-airflow-terraform')
) AS source ON target.lab = source.lab AND target.question = source.question
WHEN MATCHED THEN UPDATE SET target.answer = source.answer, target.submitted_at = CURRENT_TIMESTAMP()
WHEN NOT MATCHED THEN INSERT (lab, question, answer, submitted_at)
VALUES (source.lab, source.question, source.answer, CURRENT_TIMESTAMP());
SELECT question, answer FROM REDGRAVE.LAB.ANSWERS WHERE lab = 'RED-401' ORDER BY question;
