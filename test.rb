require 'ruby_llm'

require 'sqlite3'
require 'yaml'
require_relative '_lib/config'

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch('OPENAI_API_KEY_YIP')
end

prompt = 'Create a square thumbnail from the provided image,
tightly cropped around the focal point. Center the thumbnail
on the area of highest visual interest (such as a face, subject,
or key object) while preserving balance and clarity.'

# chat = RubyLLM.chat
# image = RubyLLM.paint

# response = chat.ask "What's the difference between attr_reader and attr_accessor?"
image_path = '/home/myst/Dropbox/pictures/year in pictures/2025/originals/02-tim_blair.jpg'
thumbnail = RubyLLM.paint prompt, with: { image: image_path }
thumbnail.save('myfile.png')

# puts response.content

# Generate an image
# image = RubyLLM.paint('a sausage dressed in brightly coloured spandex jumping over a wall while running away from a dog, in a cartoon style')
# image.save("myfile.png")
