class Purpose
  attr_accessor :name, :params

  def initialize params
    check params \
      && build_name(parse_name(params)) \
      && build_params(parse_params(params))
  end

  def print solutions
    decorate( substitution( solutions ))
  end

  def decide
    solutions = []
    solutions += find_facts.each_with_object([]) do |fact, s|
      s << fact.constants_hash
    end

    solutions += find_rules.map do |rule|
      hash = solutions_to_hash( compatible_solutions( predicate_solutions( rule )))
      hash.count > 1 ? inner_join( hash ) : [hash]
    end
    good_solutions( solutions.flatten )
  end

  private

  def predicate_solutions rule
    rule.predicates.map do |predicate|
      predicate_params = hash_params_to_hash_numbers_params predicate.parameters_hash
      resulting_params = hash_params_to_hash_numbers_params(rule.resulting_predicate.parameters_hash).invert

      Purpose.new(predicate.to_s.gsub(' ', '')).decide.map do |solutions|
        solutions.inject({}) do |result, solution|
          result[ resulting_params[ predicate_params[solution.first] ] ] = solution.last
          result
        end
      end
    end
  end

  def substitution solutions
    solutions.flat_map do |solution|
      params.inject({}) do |h, p|
        h[p.first] = solution[p.last.first]
        h
      end
    end
  end

  def good_solutions solutions
    solutions.uniq.select do |solution|
      params.values.map{|indexes| indexes.flat_map{|index| solution[index]}.uniq.size == 1}.all?
    end
  end

  def hash_params_to_hash_numbers_params hash
    hash.inject({}){|h, p| p.last.each{|n| h[n] = p.first}; h}
  end

  def decorate solutions
    solutions.map do |s|
      params.map{|p| "#{p.first} = #{s[p.first]}"}.join(', ')
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

  def solutions_to_hash solutions
    solutions.flatten.inject({}) do |h, s|
      s.each do |key, value|
        h[key] ||= []
        h[key] << value
      end
      h
    end
  end

  def inner_join hash
    values = hash.inject([]){|s, v| key, value = v; s.empty? ? s = [*value] : s.product(value)}.map{|s| s.flatten}
    values.map(){|r| r.map.with_index{|e, i| [i, e]}.inject({}){|r, e| k, v = e; r[k] = v; r}}
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
