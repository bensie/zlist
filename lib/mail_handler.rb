#!/usr/bin/env ruby

# This file accepts a raw e-mail from STDIN and sends it to rails

require 'net/http'
require 'uri'
require 'yaml'

SUCCESS = 0
TEMPORARY_FAIL = 75
UNAVAILABLE = 69

# Detect via command line in the future
debug = true

DEFAULT_TARGET = "http://localhost/emails"

# For now, we'll hard code if no environment is detected
#ENV['RAILS_ENV'] ||= 'production'
if( ENV['RAILS_ENV'] )
  mail_handler_config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/app_config.yml'))[RAILS_ENV].symbolize_keys
  target_url = mail_handler_config[:email_target_url]
else
  target_url = DEFAULT_TARGET
end


# Break this out so we can add Accept header for XML later
url = URI.parse(target_url)
request = Net::HTTP::Post.new(url.path)
request.set_form_data( {'key' => 'abcdefg', 'email' => STDIN.read}, '&' )
request['accept'] = "text/xml"

if(debug)
  puts "--Target URL: #{target_url}--"
  puts "Request Body--"
  print request.body
  puts "--Request Body"
end
result = Net::HTTP.new(url.host, url.port).start { |http| http.request(request) }

if result.is_a?(Net::HTTPSuccess)
  print result.body if debug
  case result.body
  when '250'
    exit(SUCCESS)
  when '550'
    exit(UNAVAILABLE)
  end
else
  puts "Not a HTTP Success" if debug
  print result.body if debug
end
exit(TEMPORARY_FAIL)
