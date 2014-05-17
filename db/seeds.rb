Rule.delete_all
rules = []
rand(8).times do
  rules << Rule.create
end

Predicate.delete_all
predicates = rules.each_with_object([]) do |r, p|
  rand(3).times do
    p << Predicate.create(name: ('A'..'Z').to_a.sample, rule: r)
  end
  ResultingPredicate.create(name: ('A'..'Z').to_a.sample, rule: r)
end

Parameter.delete_all
parameters = predicates.each_with_object([]) do |pr, p|
  rand(4).times do
    p << Parameter.create(name: ('a'..'z').to_a.sample, basic_predicate: pr)
  end
end

Fact.delete_all
facts = []
rand(20).times do
  facts << Fact.create(name: ('A'..'Z').to_a.sample)
end

Constant.delete_all
constants = facts.each_with_object([]) do |f, p|
  rand(4).times do
    p << Constant.create(name: ('a'..'z').to_a.sample, fact: f)
  end
end
