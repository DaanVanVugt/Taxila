# frozen_string_literal: true

class ChatgptService < LlmService
  require 'openai'
  def initialize
    api_key = ENV.fetch('GPT_API_KEY', nil)
    @client = OpenAI::Client.new(access_token: api_key)
    @params = {
      # max_tokens: 50,
      # model: 'gpt-3.5-turbo-1106',
      model: TeSS::Config.llm_scraper.model_version,
      temperature: 0.7
    }
  end

  def run(content)
    call(content).dig('choices', 0, 'message', 'content')
  end

  def call(prompt)
    params = @params.merge(
      {
        messages: [{ role: 'user', content: prompt }]
      }
    )
    @client.chat(parameters: params)
  end
end
