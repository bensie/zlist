#!/usr/local/env ruby

# Usage from Postfix:
# /etc/aliases:
# rails_mailer: "|/path/to/app/lib/mail_handler.rb http://www.example.com/emails 298cc9dceb1f3cac91fef8b42be624c07843fc8e"
# Email is passed via STDIN, first argument is URL, second argument is server auth key

require 'rest_client'

SUCCESS = 0
TEMPORARY_FAIL = 75
UNAVAILABLE = 69

target_url = ARGV[0] || "http://localhost/emails"
server_key = ARGV[1] || ""

params = { :key => server_key, :email => STDIN.read }

result = RestClient.post target_url, params

exit(SUCCESS)
