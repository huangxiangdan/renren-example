require 'rubygems'
require 'sinatra'
require 'omniauth-renren'
require 'renren'

use Rack::Session::Cookie
#you can use your api_key and api_secret
Renren::Config.api_key = "bd84a1264b674b8c946c3effe1048779"
Renren::Config.api_secret = "4ba014c9c2d94affad726ab99aee1b7f"

use OmniAuth::Builder do
  provider :Renren, Renren::Config.api_key, Renren::Config.api_secret
end

get '/' do
  unless session["token"]
    redirect "/auth/renren"
  else 
    base = Renren::Base.new(session["token"])
    #for more renren API, visit http://wiki.dev.renren.com/wiki/API
    "friend_ids:#{base.call_method(:method => 'friends.get').join(';')}"
  end
end

get '/auth/:name/callback' do
  #for more information about request.env['omniauth.auth'], 
  #you can visit https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  puts request.env['omniauth.auth'].inspect
  session["token"] = request.env['omniauth.auth']['credentials']['token']
  redirect "/"
end