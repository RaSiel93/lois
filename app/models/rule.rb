class Rule < ActiveRecord::Base
  has_many :predicates
  has_one :resulting_predicate

  def build params
    if check params
      resulting_predicate = ResultingPredicate.new(rule: self).build(params[/^\w*\(.*\)(?=->)/])
      return nil unless resulting_predicate.save
      params[/(?<=>)[ ]*\w[\w]*\(.*\)/].split(';').map(&:strip).map do |param|
        predicate = Predicate.new(rule: self).build(param)
        return nil unless predicate.save
      end
    end
    self
  end

  def predicates
    super.where.not(id: resulting_predicate)
  end

  def to_s
    resulting_predicate.to_s + " -> " + predicates.to_a.join('; ') + "."
  end

  private

  def check params
    params[/^\w[\w]*\(\w*[,[ ]*\w]*\)->\w[\w]*\(\w*[,[ ]*\w*]*\)[;[ ]*\w[\w]*\(\w*[,[ ]*\w]*\)]*/]
  end
end
