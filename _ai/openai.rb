require 'base64'
require 'json'
require 'openai'

client = OpenAI::Client.new(
  access_token: ENV.fetch('OPENAI_API_KEY_YIP'),
  log_errors:   true
)

# Function to encode image as Base64
def encode_image(image_path)
  Base64.strict_encode64(File.read(image_path))
end

# function_schema = <<FS
# {
#   'name': 'analyze_image',
#   'description': 'Analyzes an image and returns a structured response with a description and keywords.',
#   'parameters': {
#     'type': 'object',
#     'properties': {
#       'description': {
#         'type': 'string',
#         'description': 'A detailed description of the image.'
#       },
#       'keywords': {
#         'type': 'array',
#         'items': {
#           'type': 'string'
#         },
#         'minItems': 5,
#         'maxItems': 10,
#         'description': 'A list of relevant keywords (between 5 and 10).'
#       }
#     },
#     'required': ['description', 'keywords']
#   }
# }
# FS

function_schema =
  {
    name:        'do_poetry',
    description: 'Creates a description and a limerick from a given image and creates 5 to 10 keywords for that image.',
    parameters:  {
      type:       'object',
      properties: {
        description: {
          type:        'string',
          description: 'Description of the image.'
        },
        poem:        {
          type:        'string',
          description: 'The created poem.'
        },
        keywords:    {
          type:        'array',
          items:       {
            type: 'string'
          },
          minItems:    5,
          maxItems:    10,
          description: 'A list of relevant keywords (between 5 and 10).'
        }
      },
      required:   %w[description poem keywords]
    }
  }

prompt = 'Please can you write a description of this image using up to 400 words, ' \
         'then write a limeric using this image as inspiration ' \
         'and list some keywords for the image with output in JSON format.'

image_paths = ['images/2025/02-tim_blair.jpg', 'images/2025/02-sheena.jpg', 'images/2025/02-tom.jpg']
base64_image = encode_image(image_paths[1])

response = client.chat(
  parameters: {
    model:           'gpt-4-turbo',
    # model:           'chatgpt-4o-latest', # Does not support function schemas yet
    # model: 'gpt-4.5-preview', # Updated to use GPT-4.5
    response_format: { type: 'json_object' },
    messages:        [{
      role:    'user',
      content: [
        { type: 'text', text: prompt },
        { type: 'image_url', image_url: { url: "data:image/jpeg;base64,#{base64_image}" } }
      ]
    }],
    temperature:     1, # define level of creativity
    tools:           [{ type: 'function', function: function_schema }],
    tool_choice:     'required'
  }
)

# output = response.dig('choices', 0, 'message', 'content')
output = response.dig('choices', 0, 'message')
puts JSON.pretty_generate(output)

puts "\n"

output = response.dig('choices', 0, 'message', 'tool_calls', 0, 'function', 'arguments')
output_object = JSON.parse(output)

puts 'Description:'
puts output_object['description']
puts "\n"

puts 'Poem:'
puts output_object['poem']
puts "\n"

puts 'Keywords:'
puts output_object['keywords']
