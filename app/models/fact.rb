class Fact < ActiveRecord::Base
  has_many :constants, dependent: :destroy

  def build params
    check(params) \
      && build_name(parse_name(params)) \
      && build_constants(parse_constants(params)) \
      ? self : nil
  end

  def position_constants
    Hash[[*constants.map(&:name).map.with_index{|c, i| [i, c]}]]
  end

  def to_s
    name + '(' + constants.to_a.join(', ') + ').'
  end

  private

  def build_name params
    self.name = params
  end

  def parse_name params
    params[/^\w*(?=\()/]
  end

  def build_constants params
    params.map do |param|
      Constant.new(fact: self, name: param).try :save
    end
  end

  def parse_constants params
    params[/(?<=\().*(?=\))/].split(',')
  end

  def check params
    params[/\w[\w]*\(\w*[,\w*]*\)$/]
  end
end
