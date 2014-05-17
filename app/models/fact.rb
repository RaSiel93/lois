class Fact < ActiveRecord::Base
  has_many :constants

  def to_s
    name + '(' + constants.to_a.join(', ') + ').'
  end
end
