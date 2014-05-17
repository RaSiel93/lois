class Rule < ActiveRecord::Base
  has_many :predicates
  has_one :resulting_predicate
end
