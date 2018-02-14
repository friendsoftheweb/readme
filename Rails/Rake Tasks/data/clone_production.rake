namespace "data" do
  # For testing in a realistic environment, this task copies the production database and
  # assets. It may take some time.
  #
  # Personal user information is deleted or randomized.
  #
  # For convenience, a new admin user is inserted into the copied database.
  desc "Load a set of staging data based on the live site"
  task "clone_production" => [
    "environment",
    "redis_check",
    "data:import_production_database",
    "data:anonymize",
    "data:create_admin_user"
  ]
end
