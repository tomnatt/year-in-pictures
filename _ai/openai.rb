require 'json'
require 'openai'

client = OpenAI::Client.new(
  access_token: ENV.fetch('OPENAI_API_KEY_YIP'),
  log_errors:   true
)

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
    description: 'Creates a limerick poem from a given theme and lists 2 to 5 keywords from it.',
    parameters:  {
      type:       'object',
      properties: {
        poem:     {
          type:        'string',
          description: 'The created poem.'
        },
        keywords: {
          type:        'array',
          items:       {
            type: 'string'
          },
          minItems:    2,
          maxItems:    5,
          description: 'A list of relevant keywords (between 2 and 5).'
        }
      },
      required:   %w[poem keywords]
    }
  }

prompt = 'Please can you write a limeric about a swan and list some keywords from it with output in JSON format'

response = client.chat(
  parameters: {
    model:           'gpt-4-turbo',
    response_format: { type: 'json_object' },
    messages:        [{ role: 'user', content: prompt }],
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

puts output_object['poem']
puts output_object['keywords']
