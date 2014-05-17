class BasicPredicate < ActiveRecord::Base
  belongs_to :rule
  has_many :parameters
end
