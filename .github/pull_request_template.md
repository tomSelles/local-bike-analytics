## What
<!-- What does this PR change? -->

## Why
<!-- Business or technical reason -->

## How to test
<!-- Commands to reproduce -->

## Result
<!-- e.g. dbt build output: PASS=.. ERROR=0 -->

## Review checklist
- [ ] `dbt build` passes locally (Docker): ERROR=0
- [ ] New/changed models have tests (unique, not_null, relationships…)
- [ ] Models and columns documented in YAML
- [ ] No secrets committed (keys, profiles with credentials, .env)
- [ ] BigQuery cost under control (no `SELECT *` on large tables, partition filters)
- [ ] README updated if behaviour or setup changed
