class Purpose
  attr_accessor :id, :name, :variables
  @@visited_predicates = {}

  def initialize predicate = nil
    if predicate.present?
      self.id = predicate.id
      self.name = predicate.name
      self.variables = predicate.position_parameters
    end
  end
  def build params
    if check_params( params )
      self.name = params[/^\w*(?=\()/]
      self.variables = Hash[[*params[/(?<=\().*(?=\))/].split(',').map.with_index{|p, i| [i, p]}]]
    end
  end

  def decide
    substitution_to_values( filter_solutions( find_solutions ))
  end

  def print solutions
    solutions.map{|s| s.map{|p| k, v = p; !constant?(k) ? "#{k} = #{s[k]}" : nil}.compact.join(', ')}
  end

  private

  def find_solutions
    @@visited_predicates[id] ||= 0
    @@visited_predicates[id] += 1
    solutions = []
    solutions += solutions_from_facts
    solutions += solutions_from_rules if @@visited_predicates[id] < 2
    p solutions
    @@visited_predicates[id] -= 1
    solutions.compact.uniq
  end

  def solutions_from_facts
    find_facts.map{|fact, s| fact.position_constants}
  end
  def substitution_to_values solutions
    solutions.map{|s| s.inject({}){|h, p| k, v = p; h[variables[k]] = s[k]; h}}
  end
  def substitution_to_value solution
    variables.inject({}){|h, p| k, v = p; h[v] ||= []; h[v] << solution[k]; h}
  end
  def substitution_to_positions solutions, variables
    solutions.map{|s| s.inject({}){|h, p| k, v = p; h[k] ||= []; h[k] = solution[v]; h}}
  end

  def solutions_from_rules
    find_rules.flat_map do |rule|
      solutions = inner_join( compatible_solutions( predicate_solutions( rule ).compact ))
      pp = rule.resulting_predicate.position_parameters.invert
      solutions.map{|s| s.inject({}){|h, p| k, v = p; h[pp[k]] = v if pp[k].present?; h}}
    end
  end
  def predicate_solutions rule
    rule.predicates.map do |p|
      Purpose.new(p).decide
    end
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

  def inner_join solutions
    return solutions.flatten if solutions.size == 1
    hash = solutions_to_hash(solutions)
    values = hash.inject([]){|s, v| key, value = v; s.empty? ? s = [*value] : s.product(value)}.map{|s| s.flatten}
    values.map{|v| Hash[*hash.keys.zip(v).flatten]}
  end

  def filter_solutions solutions
    solutions.select{|s| substitution_to_value(s).all?{|k, v| constant?( k ) ? k == v.first : v.uniq.size == 1 }}
  end

  def find_facts
    Fact.where(name: name).each_with_object([]) do |f, r|
      r << f if f.constants.count == variables.count
    end
  end
  def find_rules
    Rule.select() do |rule|
      rule.resulting_predicate.name == name && rule.resulting_predicate.parameters.count == variables.count
    end
  end

  def check_params params
    params[/^\w[\w]*\(\w[,\w*]*\)$/]
  end
  def constant? variable
    variable == variable.downcase
  end




  def hash_params_to_hash_numbers_params hash
    hash.inject({}){|h, p| p.last.each{|n| h[n] = p.first}; h}
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
end
