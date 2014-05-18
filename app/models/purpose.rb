class Purpose
  attr_accessor :name, :params

  def initialize params
    check params \
      && build_name(parse_name(params)) \
      && build_params(parse_params(params))
  end

  def decide
    solutions = []
    solutions += find_facts.each_with_object([]) do |fact, s|
      s << fact.constants_hash
    end
    # solutions += find_rules.each_with_object([]) do |rule, sol|
    #   solutions_deep = rule.predicates.each_with_object([]) do |predicat, sd|
    #     sd << Purpose.new(predicat.to_s).decide
    #   end
    #   solutions_deep.join.each_with_object([]) do |sd, sol|
    #     sol << Hash[[*sd.map.with_index]].invert
    #   end
    # end
    substitution solutions
  end

  private

  def build_name params
    self.name = params
  end

  def build_params params
    self.params = params
  end

  def parse_name params
    params[/^\w*(?=\()/]
  end

  def parse_params params
    [*params[/(?<=\().*(?=\))/].split(',').map.with_index].inject({}) do |h, p|
      key, val = p
      h[key] ||= []
      h[key] << val
      h
    end
  end

  def check params
    params[/^\w[\w]*\(\w[,\w*]*\)$/]
  end

  def count_params
    params.values.flatten.count
  end

  def find_facts
    Fact.where(name: name).each_with_object([]) do |f, r|
      if f.constants.count == count_params && check_constants(f.constants_hash)
        r << f
      end
    end
  end

  def check_constants constants
    params.values.each do |v|
      return nil if v.map{|i| constants[i]}.uniq.count != 1
    end
  end

  def find_rules
    rules = ResultingPredicate.where(name: name).each_with_object([]) do |r, rules|
      rules << r.rule
    end
  end

  def substitution solutions
    solutions.map.with_index do |s, i|
      params.map{|p| "#{p.first} -> #{s[p.last.first]}"}.join(', ')
    end
  end
end
