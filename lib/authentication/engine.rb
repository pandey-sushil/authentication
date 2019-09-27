module Authentication
  class Engine < ::Rails::Engine
    isolate_namespace Authentication

    # autoload lib folder
    config.autoload_paths << File.expand_path("../../lib", __FILE__)

    ## make rspec & factory girl default for testing env
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_bot
      g.assets false
      g.helper false
    end

    ## load engines db/migration to application
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    ## Load custom directories
    initializer :load_directories, after: :load_config_initializers do |app|
      Authentication.load_dir.each { |dir|
        Dir["#{root.to_s + dir}/*.rb"].each {|file|
           require_relative file
        }
      }
    end

  end
end
