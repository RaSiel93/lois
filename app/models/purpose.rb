class Purpose
  attr_accessor :name, :params

  def initialize params
    if check params
      self.name = params[/^\w*(?=\()/]
      self.params = Hash[[*params[/(?<=\().*(?=\))/].split(',').map(&:strip).map.with_index]].invert
    end
  end

  def decide
    solutions = []
    solutions += find_facts.each_with_object([]) do |fact, s|
      s << Hash[[*fact.constants.map.with_index]].invert
    end
    solutions += find_rules.each_with_object([]) do |rule, sol|
      solutions_deep = rule.predicates.each_with_object([]) do |predicat, sd|
        sd << Purpose.new(predicat.to_s).decide
      end
      solutions_deep.join.each_with_object([]) do |sd, sol|
        sol << Hash[[*sd.map.with_index]].invert
      end
    end
    substitution solutions
  end

  private
  def substitution solutions
    solutions.map.with_index do |s, i|
      s.map{|i, c| "#{params[i]} -> #{c.name}"}
    end
  end

  def check params
    params[/^\w[\w]*\(\w[,[ ]*\w]*\)$/]
  end

  def find_facts
    Fact.where(name: name).each_with_object([]) do |f, r|
      r << f if f.constants.count == params.count
    end
  end

  def find_rules
    rules = ResultingPredicate.where(name: name).each_with_object([]) do |r, rules|
      rules << r.rule if r.parameters.count == params.count
    end
  end
end
