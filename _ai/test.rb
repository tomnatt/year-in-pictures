require 'ruby_llm'

require 'sqlite3'
require 'yaml'
require_relative '_lib/config'

def output_filename(pic)
  "#{File.basename(pic, '.jpg')}.yml"
end

def year_from_path(pic)
  File.dirname(pic).split('/').last
end

def month_from_filename(pic)
  m = File.basename(pic, '.jpg').split('-').first.to_i
  Date::MONTHNAMES[m]
end

image_path = 'images/2025'

pics = Dir["#{image_path}/*.jpg"]
pics.each do |pic|
  output_file = output_filename(pic)
  year = year_from_path(pic)
  month = month_from_filename(pic)

  puts pic
  puts "output file: #{output_file}"
  puts "year:        #{year}"
  puts "month:       #{month}"
  puts "\n"
end

# The AI bit

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch('OPENAI_API_KEY_YIP')
end

prompt = 'Please defi'

Please can you describe this photograph in around 200 words.

prompt = 'Create a square thumbnail from the provided image,
tightly cropped around the focal point. Center the thumbnail
on the area of highest visual interest (such as a face, subject,
or key object) while preserving balance and clarity.'

# chat = RubyLLM.chat
# image = RubyLLM.paint

# response = chat.ask "What's the difference between attr_reader and attr_accessor?"
# thumbnail = RubyLLM.paint prompt, with: { image: image_path }
# thumbnail.save('myfile.png')

# puts response.content

# Generate an image
# image = RubyLLM.paint('a sausage dressed in brightly coloured spandex jumping over a wall while running away from a dog, in a cartoon style')
# image.save("myfile.png")

