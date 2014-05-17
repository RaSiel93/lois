class Parameter < ActiveRecord::Base
  belongs_to :basic_predicate

  def to_s
    name
  end
end
