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
        render json:{low:@low,mid:@mid,high:@high }
    end

    

    def update_stock
        @stocks = Net::HTTP.get(URI.parse('https://phisix-api4.appspot.com/stocks.json'))
        @x=JSON.parse(@stocks)
        @stock=@x["stock"]
        @stock.each do |x|
            @item=Stock.find_by_name(x["name"])
            if @item.trader_id.nil? 
                @item.update(
                    :amount => x["price"]["amount"],
                    :volume => x["volume"], 
                    :percent_change => x["percent_change"],
                    
                )
                @item.save
            else
                @item.update(
                    :amount => x["price"]["amount"],
                    :volume => x["volume"], 
                    :percent_change => x["percent_change"],
                )
                @item.save
            end
         end
         render json:{market:Market.all, stock:Stock.all}
    end





    private 

    def stock_params
        params.require(:stock).permit(:name, :currency, :amount, :volume, :symbol, :percent_change, :asset)
    end
end
