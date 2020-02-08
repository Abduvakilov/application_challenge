require 'sinatra'

get '/' do
  send_file "api_response.json"
end