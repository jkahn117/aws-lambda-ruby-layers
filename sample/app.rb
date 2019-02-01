require 'httparty'
require 'shared'

def lambda_handler(event:, context:)
  p ENV['GEM_PATH']
  
  begin
    response = HTTParty.get('http://checkip.amazonaws.com/')
  rescue HTTParty::Error => error
    puts error.inspect
    raise error
  end
  
  build_response(response.code, response.body)
end
