class StockController < ApplicationController
    
    require 'net/http'


    def create_market_stocks 
        @stocks = Net::HTTP.get(URI.parse('https://phisix-api4.appspot.com/stocks.json'))
        @x=JSON.parse(@stocks)
        @stock=@x["stock"]
        @low=[]
        @mid=[]
        @high=[]
        @stock.each do |x|
            if x["price"]["amount"] <= 50
                @low.push(x)
            elsif x["price"]["amount"] >= 50 && x["price"]["amount"] <= 100
                @mid.push(x)
            else
                @high.push(x)
            end
        end
        render json:{low:{
            name:"Low Market",
            details:"For Start-Up Businesses",
            stock: @low,
        },
            mid:{
            name:"Mid Market",
            details:"For Rising Businesses",
            stock: @mid,
        },
            high:{
            name:"High Market",
            details:"For Big and Known Businesses",
            stock: @high,
        }, }
    end

    

   

end
