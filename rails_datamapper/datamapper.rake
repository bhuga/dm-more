namespace :db do

  desc "Perform automigration"
  task :automigrate => :environment do
    ::DataMapper.auto_migrate!
  end

  desc "Perform non destructive automigration"
  task :autoupgrade => :environment do
    ::DataMapper.auto_upgrade!
  end

  namespace :migrate do
    task :load => :environment do
      gem 'dm-migrations'
      FileList["db/migrations/*.rb"].each do |migration|
        load migration
      end
    end

    desc "Migrate up using migrations"
    task :up, :version, :needs => :load do |t, args|
      version = args[:version]
      migrate_up!(version)
    end

    desc "Migrate down using migrations"
    task :down, :version, :needs => :load do |t, args|
      version = args[:version]
      migrate_down!(version)
    end
  end

  desc "Migrate the database to the latest version"
  task :migrate => 'db:migrate:up'

  namespace :session do
    desc "Creates sessions table (for DataMapperStore::Session)"
    task :create => :environment do
      DataMapperStore::Session.auto_upgrade!
    end

    desc "Clears the sessions table (for DataMapperStore::Session)"
    task :clear => :environment do
      DataMapperStore::Session.destroy!
    end
  end

end
