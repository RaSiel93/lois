class BasicPredicate < ActiveRecord::Base
  belongs_to :rule
  has_many :parameters, dependent: :destroy

  def build params
    check(params) \
      && build_name(parse_name(params)) \
      && build_parameters(parse_parameters(params)) \
      ? self : nil
  end

  def to_s
    name + '(' + parameters.to_a.join(', ') + ')'
  end

  def parameters_hash
    parameters.map(&:name).map.with_index.inject({}) do |h, p|
      key, val = p
      h[key] ||= []
      h[key] << val
      h
    end
  end

  def count_params
    parameters.count
  end

  private

  def build_name params
    self.name = params
  end

  def build_parameters params
    params.map do |p|
      Parameter.new(name: p, basic_predicate: self).try :save
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
