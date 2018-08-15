# (Project Name)

(A Description of the Project)

If you have any problems setting up or running the project, please file an
issue.

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


#### Staging Data

A sample set of staging data for testing and development can be created with:

```shell
bin/rake data:stage
```

or the production data can be duplicated to your local environment with:

```shell
bin/rake data:clone_production
```

Note the copied data with have sensitive information such as passwords scrubbed
or randomized.

To run this: 

- Heroku CLI must be installed with appropriate permissions.
- Postgres must be running.
- Prodocution git remote must exist.


### Running

Postgres must be running.

In the project directory, run:

```shell
bin/foreman start --procfile Procfile.local
```


### Updating

After pulling changes or switching branches, run:

```shell
bin/update
```


### Deploying

```shell
bin/deploy
```


### Running Tests

Ruby Tests: 

```shell
bin/rspec
```

Javascript Tests:

```shell
yarn run test:watch
```
