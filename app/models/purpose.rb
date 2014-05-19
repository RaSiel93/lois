class Purpose
  attr_accessor :name, :params, :visited

  def initialize params, attr_params = {}
    self.visited = attr_params[:visited]
    check params \
      && build_name(parse_name(params)) \
      && build_params(parse_params(params))
  end

  def print solutions
    decorate( filter_for_constants( solutions ))
  end

  def decide
    solutions = []
    solutions += solutions_from_facts
    solutions += solutions_from_rules unless visited?
    filter_solutions solutions
  end

  private

  def decorate solutions
    solutions.map do |s|
      params.map{|p| p.first != p.first.downcase ? "#{p.first} = #{s[p.first]}" : nil}.compact.join(', ')
    end
  end

  def filter_solutions solutions
    solutions.compact!
    solutions.uniq!
    correct_solutions solutions
  end
  def correct_solutions solutions
    solutions.select do |solution|
      params.values.map{|indexes| indexes.flat_map{|index| solution[index]}.uniq.size == 1}.all?
    end
  end

  def filter_for_constants solutions
    solutions.select{|s| s.map{|k, v| k == k.downcase ? k == v : true}.all?}
  end

  def solutions_from_facts
    find_facts.map{|fact, s| substitution fact.constants_hash}
  end

  def solutions_from_rules
    find_rules.flat_map do |rule|
      solutions = inner_join( compatible_solutions( predicate_solutions( rule )))
      schema = params.inject({}){|h, p| k, v = p; h[rule.resulting_predicate.parameters_position[v.first]] = k; h}
      solutions.map{|s| h = {}; schema.each{|sch| h[sch.last] = s[sch.first]}; h}
    end
  end

  def predicate_solutions rule
    rule.predicates.map do |predicate|
      #predicate_params = hash_params_to_hash_numbers_params predicate.parameters_hash
      #resulting_params = hash_params_to_hash_numbers_params(rule.resulting_predicate.parameters_hash).invert
      visited = name == predicate.name && count_params == predicate.count_params
      Purpose.new(predicate.to_s.gsub(' ', ''), {visited: visited}).decide
    end
  end

  def inner_join solutions
    return solutions if solutions.size == 1
    hash = solutions_to_hash(solutions)
    values = hash.inject([]){|s, v| key, value = v; s.empty? ? s = [*value] : s.product(value)}.map{|s| s.flatten}
    values.map{|v| Hash[*hash.keys.zip(v).flatten]}
  end



  def substitution solution
    params.inject({}){|h, p| h[p.first] = solution[p.last.first]; h}
  end


  def hash_params_to_hash_numbers_params hash
    hash.inject({}){|h, p| p.last.each{|n| h[n] = p.first}; h}
  end

  def compatible_solutions solutions
    solutions.map{|ps| ps.select{|s| compatible_solution?(s, solutions)}}
  end

  def compatible_solution? solution, solutions
    solutions.map{|ps| ps.any?{|s| compatable_solutions?(s, solution)}}.all?
  end

  def compatable_solutions? s1, s2
    s1.merge(s2){|key, v1, v2| v1 == v2}.values.all?
  end

  def solutions_to_hash solutions
    solutions.flatten.inject({}) do |h, s|
      s.each do |key, value|
        h[key] ||= []
        h[key] << value if !h[key].include?(value)
      end
      h
    end
  end

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

  def visited?
    self.visited
  end

  def check params
    params[/^\w[\w]*\(\w[,\w*]*\)$/]
  end

  def count_params
    params.values.flatten.count
  end

  def find_facts
    Fact.where(name: name).each_with_object([]) do |f, r|
      r << f if f.constants.count == count_params && check_constants(f.constants_hash)
    end
  end

  def check_constants constants
    params.values.each do |v|
      return nil if v.map{|i| constants[i]}.uniq.count != 1
    end
  end

  def find_rules
    Rule.select() do |rule|
      rule.resulting_predicate.name == name && rule.resulting_predicate.parameters.count == count_params
    end
  end
end
