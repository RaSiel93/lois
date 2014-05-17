class BasicPredicate < ActiveRecord::Base
  belongs_to :rule
  has_many :parameters

  def build params
    if check params
      self.name = params[/^\w*(?=\()/]
      params[/(?<=\()\w*(?=\))/].split(/,/).map(&:strip).map do |p|
        parameter = Parameter.new(name: p, basic_predicate: self)
        return nil unless parameter.save
      end
    end
    self
  end

  def to_s
    name + '(' + parameters.to_a.join(', ') + ')'
  end

  private

  def check params
    params[/^\w[\w]*\(\w[\w]*[,[ ]*\w[\w]*]*\)$/]
  end
end
