require 'rails_helper'

RSpec.describe "Users", type: :request do

    before do
        User.create(
        name: "name",
        email: "user_email.com",
        password: "password"
      )
    end
  
    describe 'POST user#create' do

      before do
        post '/create', params: {
          user:{
                name:"new_user",
                email: "new_user_email.com",
                password: "newpassword"
            }
        }
      end

      it 'creates new user' do
        expect(response).to have_http_status :ok
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(["user", "token"])
      end

      it 'creates new admin' do
            post '/create', params: {
                user:{
                      name:"user_admin",
                      email: "admin_email.com",
                      password: "password"
                  }
            }
            expect(response).to have_http_status :ok
            json_response = JSON.parse(response.body)
            expect(json_response.keys).to match_array(["user", "token", "admin"])
      end

      it 'gives error for duplicate user' do
        post '/create', params: {
          user:{
                name:"user",
                email: "new_user_email.com",
                password: "newpassword"
              }
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq ({"message"=>"Email invalid/duplicated"})
      end



    end

    describe "POST user#signin" do
      before do
        User.create(
        name: "name_admin",
        email: "admin_email.com",
        password: "password",
        is_admin: true)
      end

      it 'sign in user' do
         post '/sign-in', params: {
                email: "user_email.com",
                password: "password"
        }

          expect(response).to have_http_status :ok
          json_response = JSON.parse(response.body)
          expect(json_response.keys).to match_array(["user", "token"])
      end

      it 'sign in admin' do
        
            post '/sign-in', params: {
                email: "admin_email.com",
                password: "password"
            }
            expect(response).to have_http_status :ok
            json_response = JSON.parse(response.body)
            expect(json_response.keys).to match_array(["user", "token", "admin"])
      end

      it 'wrong password' do
         post '/sign-in', params: {
                email: "user_email.com",
                password: "new_password"
        }

          expect(response).to have_http_status(400)
          expect(JSON.parse(response.body)).to eq ({"message"=>"Wrong password"})
      end

      it 'wrong/invalid email' do
         post '/sign-in', params: {
                email: "user.com",
                password: "new_password"
        }

          expect(response).to have_http_status(400)
          expect(JSON.parse(response.body)).to eq ({"message"=>"no such email is registered"})
      end
    end


    describe "POST user#transaction" do
      
      it "it verify admin and gives trader data" do
        post '/create', params: {
          user:{
                name:"new_admin",
                email: "email.com",
                password: "password"
            }
        }
        json_response = JSON.parse(response.body)
        token=json_response['token']
      
        post '/transactions', params: {
          token:token
        }  

        expect(response).to have_http_status :ok
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(["transaction"])
      end

      it "ivalid admin token" do 
         post '/transactions', params: {
          token:'321a32sd4f56s4adf5'
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq ({"error"=>"invalid token"})
      end

      it "not admin" do 
         post '/create', params: {
          user:{
                name:"new_user",
                email: "email.com",
                password: "password"
            }
        }
        json_response = JSON.parse(response.body)
        token=json_response['token']
      
        post '/transactions', params: {
          token:token
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq ({"error"=>"unauthorized"})
      end

    end

    describe "POST user#admin" do

        it "shows requests" do
          post '/create', params: {
            user:{
                  name:"new_admin",
                  email: "email.com",
                  password: "password"
              }
          }
          json_response = JSON.parse(response.body)
          token=json_response['token']
        
          post '/admin', params: {
            token:token
          }
          expect(response).to have_http_status :ok
          json_response = JSON.parse(response.body)
          expect(json_response.keys).to match_array(["users", "request"])
        end

    end

    describe "PUT user#admin_confirm" do

      before do
        post '/create', params: {
            user:{
                  name:"new_user",
                  email: "useremail.com",
                  password: "password"
              }
          }
          json_response = JSON.parse(response.body)
          token=json_response['token']

        post '/request', params:{
                token: token,
                nickname:"name"
        }
      end

      it "admin confirms and create trader" do
        
        
          post '/create', params: {
            user:{
                  name:"new_admin",
                  email: "email.com",
                  password: "password"
              }
          }
          json_response = JSON.parse(response.body)
          token=json_response['token']
        
          put '/admin/confirm', params: {
            token:token,
            email:"useremail.com",
            nickname:"name"
          } 
        
         
          # expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to eq ({"message"=>"Trader successfully registered"})
      end
    end


end
