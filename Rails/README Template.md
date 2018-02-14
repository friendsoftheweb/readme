# Project Name

## Project Setup & Development

### Prerequisites

- Ruby 2.3.1 ([rbenv versions](https://github.com/rbenv/rbenv))
- [Bundler](http://bundler.io) (`gem install bundler`)
- PostgreSQL ([Postgres.app](http://postgresapp.com))
- [Node](https://nodejs.org/en/)
- [Yarn](https://yarnpkg.com/)
- Redis


### Setup

- Clone this repository

- Navigate to the project directory in the terminal and run

```shell
    bin/setup
```

The setup script will:

- install dependencies
- create a database (if needed)
- create default configuration files
- add test data (if no data existed)

It is safe to re-run the setup script to update things as well. It will not overwrite any modifications or replace the database.

The node version is not locked in any way. If if `yarn` fails, check you have Node and Yarn installed and up to date.
