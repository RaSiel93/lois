class BasicPredicate < ActiveRecord::Base
  belongs_to :rule
  has_many :parameters

  def build params
    check(params) && build_name(parse_name(params)) && build_parameters(parse_parameters(params)) ? self : nil
  end

  def to_s
    name + '(' + parameters.to_a.join(', ') + ')'
  end

  private

  def build_name params
    self.name = params
  end

  def build_parameters params
    params.map do |p|
      parameter = Parameter.new(name: p, basic_predicate: self)
      return nil unless parameter.save
    end
  end

  def parse_name params
    params[/^\w*(?=\()/]
  end

  def parse_parameters params
    params[/(?<=\().*(?=\))/].split(/,/)
  end

  def check params
    params[/^\w[\w]*\(\w[\w]*[,\w[\w]*]*\)$/]
  end
end
