years = [2015, 2016, 2017, 2018, 2019, 2020]
names = []

years.each do |year|
  files = Dir["images/#{year}/*.jpg"]
  files.each do |file|
    m = file.match /\d{2}-(?<name>.+)\.jpg/
    names << m[:name]
  end
end


# out
names.uniq!
names.sort!
names.each { |n| puts n }
