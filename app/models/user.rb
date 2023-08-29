class User < ApplicationRecord
     validates :name, presence: true
     validates :email, presence: true, uniqueness:true
      
     has_many :trader


     serialize :nickname, Array


     include BCrypt

     after_create :generate_token

     def generate_token 
          self.token =  SecureRandom.base64[0..32]
          self.save
     end


     def password
          @password ||= Password.new(password_hash)
     end

     def password=(new_password)
          @password = Password.create(new_password)
          self.password_hash = @password
     end

     def admin
          arr = self.name.split('_')
          if arr.include?("admin")
               self.is_admin = true
          end
          self.is_trader= false
     end

     def check?
          self.is_admin == true
     end

     def trader?
          self.is_trader == true
     end
end
