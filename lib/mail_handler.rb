#!/usr/bin/ruby
require 'net/http'
require 'uri'
require 'yaml'

SUCCESS = 0
TEMPORARY_FAIL = 75
UNAVAILABLE = 69

ENV['RAILS_ENV'] ||= 'production'
mail_handler_config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/mail_handler.yml'))
target_url = mail_handler_config[ENV['RAILS_ENV']]

result = Net::HTTP.post_form(URI.parse(target_url), {'email' => STDIN.read})

if result.is_a?(Net::HTTPSuccess)
  case result.body
  when '250'
    exit(SUCCESS)
  when '550'
    exit(UNAVAILABLE)
  end
end
exit(TEMPORARY_FAIL)