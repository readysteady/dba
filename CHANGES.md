# 2.1.0

* Fixed arity check for commands with optional arguments

* Added support for .jsonl extension to dump and load commands

* Added support for .ndjson extension to dump and load commands


# 2.0.0

* **Required ruby version is now 2.5.0**

* Fixed diff command

* Added select command

* The indexes command now shows which indexes are unique

* The schema command now shows which columns have array types

* The postgres database is now used by default; use `.env` or `config/database.yml` to specify a different database name


# 1.1.0

* Fixed sample command for postgres

* Added dump command for dumping data to CSV, LDJSON, or YAML

* Added load command for loading data from CSV, LDJSON, or YAML


# 1.0.0

* First version!
