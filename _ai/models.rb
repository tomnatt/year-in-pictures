require 'base64'
require 'json'
require 'openai'

client = OpenAI::Client.new(
  access_token: ENV.fetch('OPENAI_API_KEY_YIP'),
  log_errors:   true
)

models = client.models.list['data']
# out = output.sort_by { |_key, value| value }.to_h

out = models.sort_by { |model| model['created'] }
# out = models.sort_by(&:created)

puts JSON.pretty_generate(out)

# puts models.first
