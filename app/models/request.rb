class Request < ApplicationRecord
    validates :nickname, presence: true, uniqueness:true
    validates :email, presence: true


    def trader?
          self.approved == true
     end
end
