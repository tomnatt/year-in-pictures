require 'json'

keywords_groups = [
                    { keywords: ['foo', 'bar'] },
                    { keywords: ['apple', 'orange'] },
                    { keywords: ['word', 'soup'] }
                  ]

data_filepath = '_ai/data'

keywords_groups.each do |nk|
  # Write out keywords
  keywords_file = "#{data_filepath}/keywords.json"
  existing_keywords = JSON.parse(File.read(keywords_file))

  new_keywords = nk[:keywords]

  puts new_keywords.inspect
  puts existing_keywords.inspect

  keywords = new_keywords | existing_keywords
  keywords.sort!

  File.write(keywords_file, JSON.pretty_generate(keywords))
end
