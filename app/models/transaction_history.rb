class TransactionHistory < ApplicationRecord
    # serialize :trader, Array
    # serialize :stock, Array


    belongs_to :trader

end
