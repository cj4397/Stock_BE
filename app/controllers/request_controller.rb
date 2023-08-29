class RequestController < ApplicationController
def user_request
        @user = User.find_by_token(params[:token])
        if @user
           
            @request=Request.new(
                :nickname => params[:nickname],
                :email => @user.email,
                :approved => false
            )
            if @request.save
                    render json: 'Sent', status: 200
            else
                    render json: {message: "Request failed"},status:400
            end
        else
            render json: {message: "no such User is registered"},status:400
        end
    
    
end

   
end
