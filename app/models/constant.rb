class Constant < ActiveRecord::Base
  belongs_to :fact

  def to_s
    name
  end
end
