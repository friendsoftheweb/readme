# Template script for copying a database from Heroku.
#
# Modify the `heroku_app_name` to suit the project.
#
# Intended to be used to download a stating or production set of data either to allow 
# developing a feature in the context of real data, or to closely test a data set.
namespace "data" do
  # Downloads and imports the production database.
  desc "Load a set of staging data based on the live site"
  task "import_production_database" => ["environment", "redis_check"] do

    heroku_app_name = "ADD HEROKU APP NAME"
    db_backup_path = Rails.root.join("tmp/latest.dump")

    Bundler.with_clean_env do
      system("heroku pg:backups:download --app #{heroku_app_name} --output #{db_backup_path}")
    end
    if $?.to_i != 0
      puts "Failed to download database backup from heroku."
      exit 1
    end

    system("bin/rake db:drop")
    if $?.to_i != 0
      puts "Failed to drop database. You may have an open connection."
      exit 1
    end

    # This may be redundant in Rails 5 where it should be safe to check the exit code of
    # the db:drop task.
    system("bin/rake db:version")
    if $?.to_i == 0
      puts "Failed to drop the database. Checking the database version should fail after dropping."
      exit 1
    end

    system("bin/rake db:create")
    if $?.to_i != 0
      puts "Failed to create a new database."
      exit 1
    end

    database = Rails.configuration.database_configuration[Rails.env]["database"]

    system("pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{database} #{db_backup_path}")

    File.delete(db_backup_path)

    puts "Production Database Copied"
  end
end
