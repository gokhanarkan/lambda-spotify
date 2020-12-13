require "base64"
require 'net/http'
require 'net/https'
require 'json'


def encode_base64(client_id, client_secret)
  "Basic #{Base64.strict_encode64("#{client_id}:#{client_secret}")}"
end


def authorize_url(client_id)
  "https://accounts.spotify.com/authorize?client_id=#{client_id}&response_type=code&redirect_uri=http%3A%2F%2Flocalhost:4567&scope=user-read-currently-playing%20user-top-read%20user-read-recently-played"
end


def open_browser(url)
  system("open", url)
  puts "\nIf the browser didn't start, use this url: #{url}"
end


def refresh_token(authorization, data)
  # Client
  uri = URI('https://accounts.spotify.com/api/token')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  body = URI.encode_www_form(data)

  # Request
  req =  Net::HTTP::Post.new(uri)
  req.add_field "Authorization", authorization
  req.add_field "Content-Type", "application/x-www-form-urlencoded; charset=utf-8"
  req.body = body

  #  Fetch
  res = http.request(req)
  unless res.code == "200"
    raise StandardError.new "The authorization code is not accepted."
  end
  token = JSON.parse(res.body)
  token['refresh_token']
rescue StandardError => e
  puts "\nHTTP Request failed (#{e.message})"
  false
end


def command_line
  puts "\nWelcome to the Spotify Refresh Token retriever."
  puts "This has no relation with Golden or Labrador retrievers."

  puts "\nLet's start. First, enter your Client ID"
  client_id = gets.chomp

  puts "\nNow your Client Secret."
  client_secret = gets.chomp

  authorization = encode_base64(client_id, client_secret)

  url = authorize_url(client_id)
  puts "\nInitiating app authorization, check your favourite web browser."

  open_browser(url)

  puts "\nPaste the redirected url after authorising the app in your browser."

  callback = gets.chomp
  code = callback.split('?code=')[1]

  unless code
    puts "\nCode is not available. Please restart the process."
    puts "Also, don't forget to add the redirect uri (http://localhost:4567) to your application."
    exit
  end

  data = {
    grant_type: "authorization_code",
    code: code,
    redirect_uri: "http://localhost:4567"
  }

  token = refresh_token(authorization, data)
  if token
    puts "\nHere is your refresh token!"
    puts token
  end
  exit
end


command_line
