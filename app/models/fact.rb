class Fact < ActiveRecord::Base
  has_many :constants

  def constants_hash
    Hash[[*constants.map(&:name).map.with_index{|c, i| [i, c]}]]
  end

  def to_s
    name + '(' + constants.to_a.join(', ') + ').'
  end
end
