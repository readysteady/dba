# dba

Ruby command line tool for working with development databases.


## Installation

    $ gem install dba

Note: you may also need to install the pg, mysql2, or sqlite3 gems unless you
already have them in your environment.

You can connect to any database supported by [sequel](https://rubygems.org/gems/sequel).


## Usage

    $ dba
    Usage: dba COMMAND

      dba diff URL
      dba dump TABLE EXTENSION
      dba edit TABLE IDENTIFIER
      dba find TABLE IDENTIFIER
      dba indexes [TABLE]
      dba pull TABLE URL
      dba sample TABLE [COLUMN]
      dba schema [TABLE]
      dba tables 


## ERROR: could not find database

In order to determine which database to connect to dba checks `.env` for a
`DATABASE_URL` variable, `config/database.yml` for your Rails development
database config, postgres on localhost (if it's running), and the current
working directory for any `.sqlite3` files.

If your development database does not match any of these criteria please
open a pull request or issue describing your development database setup,
but first make sure you're running the command from the correct directory.
