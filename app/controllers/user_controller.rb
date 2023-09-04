class UserController < ApplicationController
    before_action :check_auth, only: [:admin, :admin_confirm, :admin_checker, :transaction]


    def transaction
        render json:{transaction:TransactionHistory.all}
    end

    def admin
        @request=Request.where(:approved => false)
        render json: {users:Trader.all, request:@request}
    end

    def admin_confirm
        @user = User.find_by_email(params[:email])
        @request=Request.find_by_nickname(params[:nickname])
        if @user

            if !@user.trader?
                @user.update(:is_trader => true) 
            end

            @request.update(:approved => true)

            @trader=Trader.create(
                :name => params[:nickname], 
                :user_id => @user.id
            )
           
            if @trader.save 
                # @user.save
                # @request.save
                render json: {message: "Trader successfully registered"}, status:200
            else
                render json: {message: "Edit failed"},status:400
            end
        else
            render json: {message: "no such email is registered", email:params[:email]},status:400
        end
    end

    def trader
        @user=User.find_by_token(params[:token])
        if @user
            render json: {trader:@user.trader}
        else
            render json: {message:'No such user is found'}, status:400
        end
    end

    def create
            @user = User.new(user_params)
            @user.password = params[:password] 
            @user.admin 

            if  @user.save
                
                    if @user.check?
                        render json: { user:@user.name, token: @user.token, admin:true}, status: 200
                    else
                      
                        UserMailer.with(user: @user).welcome_email.deliver_now
                        render json: { user:@user.name, token: @user.token}, status: 200
                     
                    end
               
            else
                render json:{ message: "Email invalid/duplicated"}, status: 400
            end 
    
    end


    def signin
        @user = User.find_by_email(params[:email])
        if @user
            if @user.password == params[:password]
                if @user.check?
                    render json: { user:@user.name, token: @user.token, admin:true}, status: 200
                else
                    render json: { user:@user.name, token: @user.token}, status: 200
                end
            else
                render json: {message:'Wrong password'}, status: 400
            end
        else
            render json: {message:'no such email is registered'}, status: 400
        end
    end


    # def update
    #     @user = User.find_by_email(params[:email])
    #     if @user
    #         if @user.update(user_params)
    #             render json: { user:@user.name, token: @user.token}, status: 200
    #         else
    #             render json: {message: "Edit failed"},status:400
    #         end
    #     else
    #         render json: {message: "no such email is registered"},status:400
    #     end
    # end


    # def delete
    #     @user = User.find_by_email(params[:email])
    #     if @user
    #          @user.destroy
    #         render json: {message:"destroyed"}, status:200
    #     else
    #         render json: {message: "no such email is registered"}, status:400
    #     end
    # end

private
    def check_auth
        @user=User.find_by_token(params[:token])
        if @user
            unless @user.check?
                render json: {error:"unauthorized"}, status:400
            end
        else
            render json: {error:"invalid token"}, status:400
        end

    end


    def user_params
        params.require(:user).permit(:name, :email, :password)
    end
end
