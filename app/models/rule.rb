class Rule < ActiveRecord::Base
  has_many :predicates
  has_one :resulting_predicate


  def predicates
    super.where.not(id: resulting_predicate)
  end

  def to_s
    resulting_predicate.to_s + " -> " + predicates.to_a.join('; ') + "."
  end
end
