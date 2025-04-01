require 'base64'
require 'json'
require 'openai'
require_relative 'config'

class AI
  def initialize
    @client = OpenAI::Client.new(
      access_token: ENV.fetch('OPENAI_API_KEY_YIP')
    )
  end

  def analyse_image_update_keywords(image_path)
    existing_keywords = load_keywords
    base64_image = encode_image(image_path)

    response = get_response_from_api(existing_keywords, base64_image)

    output = response.dig('choices', 0, 'message', 'tool_calls', 0, 'function', 'arguments')
    output_object = JSON.parse(output)

    # Write these fields to file
    year = File.dirname(image_path).split('/')[1]
    output = "#{Config.ai_analysis_directory}/#{year}/#{File.basename(image_path, '.jpg')}.json"
    File.write(output, JSON.pretty_generate(output_object))

    # Take the union of new keywords and existing keywords then save
    keywords = output_object['keywords'] | existing_keywords
    save_keywords(keywords)
  end

  private

  # Function to encode image as Base64
  def encode_image(image_path)
    Base64.strict_encode64(File.read(image_path))
  end

  def load_keywords
    JSON.parse(File.read(Config.keywords_path))
  end

  def save_keywords(keywords)
    keywords.sort!
    File.write(Config.keywords_path, JSON.pretty_generate(keywords))
  end

  # rubocop:disable Layout/LineLength
  def prompt(existing_keywords)
    'Please provide: ' \
      '1. A concise image description (max 200 words).' \
      "2. 5-10 keywords, reusing relevant ones from the provided list and adding new ones if necessary: #{existing_keywords.join(', ')}." \
      '3. A limerick (5 lines).' \
      'Return output in JSON format with fields "description", "keywords" and "poem".'
  end
  # rubocop:enable Layout/LineLength

  # rubocop:disable Metrics/MethodLength
  def get_response_from_api(keywords, base64_image)
    @client.chat(
      parameters: {
        model:           'gpt-4-turbo',
        response_format: { type: 'json_object' },
        messages:        [{
          role:    'user',
          content: [
            { type: 'text', text: prompt(keywords) },
            { type: 'image_url', image_url: { url: "data:image/jpeg;base64,#{base64_image}" } }
          ]
        }],
        temperature:     0.2, # define level of creativity
        tools:           [{ type: 'function', function: function_schema }],
        tool_choice:     'required'
      }
    )
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def function_schema
    {
      name:        'analyse_image',
      description: 'Creates a description, a limerick and 5 to 10 keywords for a given image.',
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
  end
  # rubocop:enable Metrics/MethodLength
end
