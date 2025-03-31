require 'json'

data_filepath = '_ai/data'
keywords_file = "#{data_filepath}/keywords.json"
existing_keywords = JSON.parse(File.read(keywords_file))

out = "These are the keywords: #{existing_keywords.join(', ')}"

puts out
