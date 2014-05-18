class Rule < ActiveRecord::Base
  has_many :predicates
  has_one :resulting_predicate

  def build params
    check(params) \
      && build_resulting_predicate(parse_resulting_predicate(params)) \
      && build_predicates(parse_predicates(params)) \
      ? self : nil
  end

  def predicates
    super.where.not(id: resulting_predicate)
  end

  def to_s
    resulting_predicate.to_s + " -> " + predicates.to_a.join('; ') + "."
  end

  private

  def build_resulting_predicate params
    resulting_predicate = ResultingPredicate.new(rule: self)
    resulting_predicate.build(params)
    resulting_predicate.save ? self : nil
  end

  def build_predicates params
    params.map do |param|
      predicate = Predicate.new(rule: self)
      predicate.build(param)
      return nil unless predicate.save
    end
  end

  def parse_resulting_predicate params
    params[/^\w*\(.*\)(?=->)/]
  end

  def parse_predicates params
    params[/(?<=>)\w[\w]*\(.*\)/].split(';')
  end

  def check params
    params[/^\w[\w]*\(\w*[,\w]*\)->\w[\w]*\(\w*[,\w*]*\)[;\w[\w]*\(\w*[,\w]*\)]*/]
  end
end
