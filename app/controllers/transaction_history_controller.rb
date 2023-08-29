class TransactionHistoryController < ApplicationController
  



    require 'json'


    def create
        @trader= Trader.find_by_name(params[:trader])
        @available=@trader.stock.find_by_name(params[:name])
        @asset=(params[:invest].fdiv(params[:amount])).round(3)

        if @trader
            if @available
                @item=Stock.find_by_id(@available.id)
                if @stock=@item.update(
                    :amount => ((@item.asset + @asset) * params[:amount]), 
                    :percent_change => params[:percent_change],
                    :asset => (@available.asset.to_f + @asset).round(3),
                )

                     @data={
                        :name => @trader.name,
                        :invest => (@asset * params[:amount]),
                        :bought => @asset
                    }
                    @history=TransactionHistory.new(
                        :trader_info => @data.to_json,
                        :stock_info => {
                            :name=>  params[:name], 
                            :currency=> params[:currency], 
                            :amount=> params[:amount], 
                            :volume=> params[:volume], 
                            :symbol=> params[:symbol],
                            :percent_change=> params[:percent_change]
                            
                        }.to_json,
                        :trader_id => @trader.id
                    )
               
                    if @history.save
                        render json: { trader:Trader.all}
                    else
                        render json: {error:'history is not ssaved',history:TransactionHistory.all, trader:@trader}, status:400
                    end
                    
                else
                     render json:{error:'stock not saved', trader:@trader}, status:400
                end



            else
                @stock=Stock.new(
                :name => params[:name], 
                :currency => params[:currency], 
                :amount => (@asset * params[:amount]), 
              
                :symbol => params[:symbol],
           
                :asset => @asset,
                :trader_id => @trader.id
                )
                 if @stock.save
                        @data={
                            :name => @trader.name,
                            :invest => (@asset * params[:amount]),
                            :bought => @asset
                        }
                        @history=TransactionHistory.new(
                            :trader_info => @data.to_json,
                            :stock_info => {
                                :name=>  params[:name], 
                                :currency=> params[:currency], 
                                :amount=> params[:amount], 
                                :volume=> params[:volume], 
                                :symbol=> params[:symbol],
                                :percent_change=> params[:percent_change]
                                
                            }.to_json,
                            :trader_id => @trader.id
                        )
                        if @history.save
                            render json: { trader:Trader.all}
                        else
                            render json: {error:'history is not ssaved',history:TransactionHistory.all, trader:@trader}, status:400
                        end
                     
                 else
                    render json:{error:'stock not saved', trader:@trader}, status:400
                 end
            end

        else
            render json: {error:'trader not found'}, status:400
        end

         
    end

    def sell
         @trader= Trader.find_by_name(params[:trader])
         @available=@trader.stock.find_by_name(params[:name])
         @money=(params[:amount]*params[:sell])
         
         if @trader
            if @available
                @item=Stock.find_by_id(@available.id)
                if @item.asset > params[:sell]
                    @result= (@item.asset - params[:sell]).round(3)
                    if @item.update(
                            :amount => (@result * params[:amount]), 
                            :volume => params[:volume], 
                            :percent_change => params[:percent_change],
                            :asset => @result
                    )
                        @data={
                            :name => @trader.name,
                            :invest => @money,
                            :bought => -(params[:sell])
                        }
                        @history=TransactionHistory.new(
                            :trader_info => @data.to_json,
                            :stock_info => {
                                :name=>  params[:name], 
                                :currency=> params[:currency], 
                                :amount=> params[:amount], 
                                :volume=> params[:volume], 
                                :symbol=> params[:symbol],
                                :percent_change=> params[:percent_change]
                                
                            }.to_json,
                            :trader_id => @trader.id
                        )
                        if @history.save
                           render json: {money:(params[:amount]*params[:sell])}
                        else
                            render json: {error:'history is not ssaved',history:TransactionHistory.all, trader:@trader}, status:400
                        end
                    else
                        render json: {message:'stock edit failed'}
                    end
                    
                   
                elsif @item.asset == params[:sell]
                    if @item.destroy
                        @data={
                            :name => @trader.name,
                            :invest => (params[:amount]*params[:sell]),
                            :bought => -(params[:sell])
                        }
                        @history=TransactionHistory.new(
                            :trader_info => @data.to_json,
                            :stock_info => {
                                :name=>  params[:name], 
                                :currency=> params[:currency], 
                                :amount=> params[:amount], 
                                :volume=> params[:volume], 
                                :symbol=> params[:symbol],
                                :percent_change=> params[:percent_change]
                                
                            }.to_json,
                            :trader_id => @trader.id
                        )
                        if @history.save
                           render json: {money:(params[:amount]*params[:sell])}
                        else
                            render json: {error:'history is not ssaved',history:TransactionHistory.all, trader:@trader}, status:400
                        end
                    else
                        render json: {message:"delete failed"}, status:400
                    end
                else
                    render json: {message:"invalid parameters"}
                end

            else
                render json:{error:'no such stock is available', trader:@trader}, status:400
            end
         else
             render json: {error:'trader not found'}, status:400
         end
    end

   



   

   
end
