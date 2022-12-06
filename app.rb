require 'bundler'
Bundler.require

module LivingCostCalc

    class App < Sinatra::Base

        register Sinatra::ActiveRecordExtension

        # global settings
        configure do
          set :root, File.dirname(__FILE__)
          set :public_folder, 'public'
        end

        # database settings
        set :database_file, 'config/database.yml'

        # require all models
        Dir.glob('./lib/*.rb') do |model|
          require model
        end

        get '/'  do 
            erb :index
        end

        # partials

        helpers do
            # define the navbar partial
            def partial(navbar)
              erb(navbar, layout: false)
            end
        end

    end

end

