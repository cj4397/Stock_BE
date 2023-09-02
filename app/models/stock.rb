class Stock < ApplicationRecord
    validates :name, presence: true, uniqueness: { scope: :trader_id }
    validates :currency, presence: true
    validates :amount, presence: true
    # validates :volume, presence: true
    validates :symbol, presence: true
    # validates :percent_change, presence: true


    belongs_to :trader , optional:true


  end




