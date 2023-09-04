require 'rails_helper'

RSpec.describe "Stock", type: :request do
   describe "GET stock#create_market_stocks" do
        it "supplies stocks" do
            get '/market'

            expect(response).to have_http_status :ok
            json_response = JSON.parse(response.body)
            expect(json_response.keys).to match_array(["low", "mid", "high"])
        end
   end
   
end
