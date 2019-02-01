require 'json'

def build_response(statusCode, body)
  {
    statusCode: statusCode,
    body: {
      message: "Go Ruby with Layers!",
      location: body
    }.to_json
  }
end