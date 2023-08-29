class Stock < ApplicationRecord
    validates :name, presence: true, uniqueness: { scope: :trader_id }
    validates :currency, presence: true
    validates :amount, presence: true
    # validates :volume, presence: true
    validates :symbol, presence: true
    # validates :percent_change, presence: true


    belongs_to :trader , optional:true

    # after_create :create_transac

    def random_asset
        rand(1..20)
    end

# def create_transac

# end


end
