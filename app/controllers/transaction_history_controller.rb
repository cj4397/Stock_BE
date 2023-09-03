class TransactionHistoryController < ApplicationController
  



    require 'json'


    def create
        @trader= Trader.find_by_name(params[:trader])

        if @trader
             @available=@trader.stock.find_by_name(params[:name])
            if @available
                @item=Stock.find_by_id(@available.id)

                 @calculator=SmrCalculator.new(
                        params[:amount],
                        params[:invest],
                        params[:sell],
                        @item,
                        @available
                    )

                if @stock=@item.update(
                    :amount =>@calculator.amount, 
                    :asset => @calculator.add_asset,
                )

                     @data={
                        :name => @trader.name,
                        :invest => @calculator.invest,
                        :bought => @calculator.asset
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
                @calculator=SmrCalculator.new(
                    params[:amount],
                    params[:invest],
                    params[:sell],
                    @item,
                    @available
                )

                @stock=Stock.new(
                :name => params[:name], 
                :currency => params[:currency], 
                :amount => @calculator.invest, 
                :symbol => params[:symbol],
                :asset => @calculator.asset,
                :trader_id => @trader.id
                )
                 if @stock.save
                        @data={
                            :name => @trader.name,
                            :invest => @calculator.invest,
                            :bought => @calculator.asset
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
         @item=Stock.find_by_id(@available.id)
         
         if @trader
             @available=@trader.stock.find_by_name(params[:name])
            if @available
                @item=Stock.find_by_id(@available.id)

                    @calculator=SmrCalculator.new(
                        params[:amount],
                        params[:invest],
                        params[:sell],
                        @item,
                        @available
                    )

                if @item.asset > params[:sell]
                
                    if @item.update(
                            :amount => @calculator.total_invest, 
                            :asset => @calculator.sub_asset
                    )
                        @data={
                            :name => @trader.name,
                            :invest => @calculator.sell_amount,
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
                           render json: {message:'history is saved', trader:@trader}
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
                            :invest => @calculator.total_invest,
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
                           render json: {trader:@trader}
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
