require 'rails_helper'

RSpec.describe "Users", type: :request do

    before do
        User.create(
        name: "name",
        email: "user_email.com",
        password: "password")
      end
  
    describe 'POST user#create' do

      before do
        post '/user', params: {
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

      it 'gives error for duplicate user' do
        post '/user', params: {
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

      it 'sign in user' do
         post '/user/signin', params: {
                email: "user_email.com",
                password: "password"
        }

          expect(response).to have_http_status :ok
          json_response = JSON.parse(response.body)
          expect(json_response.keys).to match_array(["user", "token"])
      end

      it 'wrong password' do
         post '/user/signin', params: {
                email: "user_email.com",
                password: "new_password"
        }

          expect(response).to have_http_status(400)
          expect(JSON.parse(response.body)).to eq ({"message"=>"Wrong password"})
      end

      it 'wrong/invalid email' do
         post '/user/signin', params: {
                email: "user.com",
                password: "new_password"
        }

          expect(response).to have_http_status(400)
          expect(JSON.parse(response.body)).to eq ({"message"=>"no such email is registered"})
      end
    end

    describe "PUT user#update" do
      
      it "edits the user data" do
        put '/user/profile', params: {
               email: "user_email.com",
                user:{
                  name:"new_name",
                  email:"user_email.com",
                  password:"password"
                }
        }
        expect(response).to have_http_status :ok
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(["user", "token"])
      end

      it "user data fails" do
        put '/user/profile', params: {
                email: "user_email.com",
                user:{
                  name:"new_name",
                  email:"",
                  password:"password"
                }
        }
        expect(response).to have_http_status(400)
          expect(JSON.parse(response.body)).to eq ({"message"=>"Edit failed"})
      end

      it "wrong/invalid email" do
        put '/user/profile', params: {
                email: "email.com",
                user:{
                  name:"new_name",
                  email:"",
                  password:"password"
                }
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq ({"message"=>"no such email is registered"})
      end
    end

    describe "DELETE user#destroy" do
      it "delete the user data" do
        delete '/user/delete', params: {
               email: "user_email.com",
        }
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq ({"message"=>"destroyed"})
      end
       it "wrong/invalid email" do
        delete '/user/delete', params: {
                email: "email.com",
        }
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)).to eq ({"message"=>"no such email is registered"})
      end
    end


end
