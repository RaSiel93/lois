class Rule < ActiveRecord::Base
  has_many :predicates, dependent: :destroy
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
    resulting_predicate.to_s + " <- " + predicates.to_a.join('; ') + "."
  end

  private

  def build_resulting_predicate params
    ResultingPredicate.new(rule: self).build(params).try :save
  end

  def build_predicates params
    params.map do |param|
      Predicate.new(rule: self).build(param).try :save
    end
  end

  def parse_resulting_predicate params
    params[/^\w*\(.*\)(?=<-)/]
  end

  def parse_predicates params
    params[/(?<=-)\w[\w]*\(.*\)/].split(';')
  end

  def check params
    params[/^\w[\w]*\(\w*[,\w]*\)<-\w[\w]*\(\w*[,\w*]*\)[;\w[\w]*\(\w*[,\w]*\)]*/]
  end
end
