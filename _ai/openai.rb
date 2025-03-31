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

function_schema =
  {
    name:        'analyse_image',
    description: 'Creates a description and a limerick from a given image and creates 5 to 10 keywords for that image.',
    parameters:  {
      type:       'object',
      properties: {
        description: {
          type:        'string',
          description: 'Description of the image.'
        },
        keywords:    {
          type:        'array',
          items:       {
            type: 'string'
          },
          minItems:    5,
          maxItems:    10,
          description: 'A list of relevant keywords (between 5 and 10).'
        },
        poem:        {
          type:        'string',
          description: 'The created poem.'
        }
      },
      required:   %w[description keywords poem]
    }
  }

data_filepath = '_ai/data'

images = ['images/2025/02-tim_blair.jpg', 'images/2025/02-sheena.jpg', 'images/2025/02-tom.jpg']
# images = ['images/2025/02-tim_blair.jpg']

images.each do |image|
  # Load keywords
  keywords_file = "#{data_filepath}/keywords.json"
  existing_keywords = JSON.parse(File.read(keywords_file))

  base64_image = encode_image(image)
  prompt = 'Please provide: ' \
           '1. A concise image description (max 200 words).' \
           "2. 5-10 keywords, reusing relevant ones from the provided list and adding new ones if necessary: #{existing_keywords.join(', ')}." \
           '3. A limerick (5 lines).' \
           'Return output in JSON format with fields "description", "keywords" and "poem".'

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
      temperature:     0.2, # define level of creativity
      tools:           [{ type: 'function', function: function_schema }],
      tool_choice:     'required'
    }
  )

  output = response.dig('choices', 0, 'message', 'tool_calls', 0, 'function', 'arguments')
  output_object = JSON.parse(output)

  puts image
  puts "\n"

  puts 'Description:'
  puts output_object['description']
  puts "\n"

  puts 'Poem:'
  puts output_object['poem']
  puts "\n"

  puts 'Keywords:'
  puts output_object['keywords']
  output_object['keywords'].each_with_index do |keyword, index|
    puts "#{index}: #{keyword}"
  end
  puts "\n"
  puts "\n"

  # Write these fields to file
  output = "#{data_filepath}/#{File.basename(image, '.jpg')}.json"
  File.write(output, JSON.pretty_generate(output_object))

  # Write out keywords
  keywords = output_object['keywords'] | existing_keywords
  keywords.sort!

  File.write(keywords_file, JSON.pretty_generate(keywords))
end
