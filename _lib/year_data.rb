require 'singleton'

class YearData
  include Singleton

  @data = nil

  def initialize
    @data = {}
  end

  def year(y)
    load_year_data(y) unless @data.key?(y)

    @data[y]
  end

  def load_year_data(y)
    @data[y] = YAML.load_file("images/#{y}/_data.yml")['pictures']
  end
end
