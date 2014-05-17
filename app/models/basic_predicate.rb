class BasicPredicate < ActiveRecord::Base
  belongs_to :rule
  has_many :parameters

  def to_s
    name + '(' + parameters.to_a.join(', ') + ')'
  end
end
