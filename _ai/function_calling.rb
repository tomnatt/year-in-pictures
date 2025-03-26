require 'base64'
require 'openai'

# require 'ruby_llm'

# Define the function schema
function_schema = {
  name:        'generate_keywords',
  description: 'Generate descriptive keywords for an image.',
  parameters:  {
    type:       'object',
    properties: {
      keywords: {
        type:        'array',
        items:       { type: 'string' },
        description: 'A list of keywords describing the image.'
      }
    },
    required:   ['keywords']
  }
}

client = OpenAI::Client.new(
  access_token: ENV.fetch('OPENAI_API_KEY_YIP'),
  log_errors:   true
)

# Function to encode image as Base64
def encode_image(image_path)
  Base64.strict_encode64(File.read(image_path))
end

prompt = <<PROMPT
  Please describe the image and provide a list of between 5 and 10
  relevant keywords in JSON format with the following structure:
  { "description": "<description here>", "keywords": ["keyword1",
   "keyword2", "keyword3", ...] }"
PROMPT

image_path = 'images/2025/02-tim_blair.jpg'
base64_image = encode_image(image_path)

# Call OpenAI API for both image description and keyword generation
response = client.chat(
  parameters: {
    model: "gpt-4-turbo",
    messages: [
      {
        role: "user",
        content: prompt
      }
    ],
    images: [{ content: base64_image, type: "image/jpeg" }]
  }
)

# response = chat.ask(prompt, with: { image: image_path })
puts response.inspect

# Extract the content of the response
json_response = JSON.parse(response['choices'].first['message']['content'])
# json_response = JSON.parse(response.dig('choices', 0, 'message', 'content'))

description = json_response['description']
keywords = json_response['keywords']

puts description
puts keywords
