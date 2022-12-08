require 'bundler'
Bundler.require


module LivingCostCalc

    class App < Sinatra::Base

        # global settings
        configure do
          set :root, File.dirname(__FILE__)
          set :public_folder, 'public'

          register Sinatra::ActiveRecordExtension
        end

        # development settings
        configure :development do
            register Sinatra::Reloader
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

        get '/start' do 
            erb :start
        end

        get '/results' do
            city = params[:city]
            country = params[:country]

            # if country or city names have spaces, process accordingly
            esc_city = ERB::Util.url_encode(country) # e.g. "St Louis" becomes 'St%20Louis'
            esc_country = ERB::Util.url_encode(country) # e.g. "United States" becomes 'United%20States'

            url = URI("https://cost-of-living-prices-by-city-country.p.rapidapi.com/get-city?city=#{esc_city}&country=#{esc_country}")

            conn = Faraday.new(
                url: url,
                headers: {
                    'X-RapidAPI-Key' => '52a3a4490bmshac37ccdf458e04bp1ce661jsn996259ac3268',
                    'X-RapidAPI-Host' => 'cost-of-living-prices-by-city-country.p.rapidapi.com'
                }
              )

            response = conn.get

            @code = response.status
            @results = response.body
            
            erb :results 
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

