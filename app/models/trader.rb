class Trader < ApplicationRecord
    validates :name, presence: true,uniqueness: true
    has_many :stock
    has_many :transaction_history
    belongs_to :user

end
