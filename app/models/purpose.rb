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

    solutions += find_rules.map do |rule|
      solutions_deep = rule.predicates.map() do |predicate|
        s = Purpose.new(predicate.to_s.gsub(' ', '')).decide

        pp = hash_params_to_hash_numbers_params predicate.parameters_hash
        par = hash_params_to_hash_numbers_params(rule.resulting_predicate.parameters_hash).invert

        s.map do |ss|
          ss.inject({}) do |h, sss|
            h[ par[ pp[sss.first] ] ] = sss.last
            h
          end
        end
      end
      solutions_deep.flatten
      # solutions_deep.each_with_object([]) do |sd, sol|
      #   sol << Hash[[*sd.map.with_index]].invert
      # end
    end
    #substitution
    good_solutions( solutions.flatten )
  end

  def good_solutions solutions
    solutions.select do |solution|
      params.values.map{|indexes| indexes.flat_map{|index| solution[index]}.uniq.size == 1}.all?
    end
  end


  # def substitution solutions
  #   solutions.map do |s|
  #     params.inject({}) do |h, p|
  #       key, value = p
  #       h[key] = s[value.first]
  #       h
  #     end
  #   end
  # end


  def substitution solutions
    solutions.flat_map do |solution|
      params.inject({}) do |h, p|
        h[p.first] = solution[p.last.first]
        h
      end
    end
  end

  def print solutions
    decorate( substitution( solutions ))
  end

  def hash_params_to_hash_numbers_params hash
    hash.inject({}){|h, p| p.last.each{|n| h[n] = p.first}; h}
  end

  def decorate solutions
    solutions.map do |s|
      params.map{|p| "#{p.first} -> #{s[p.first]}"}.join(', ')
    end
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
