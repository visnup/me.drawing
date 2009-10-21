require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'activerecord'
require 'json'

#
# models
#
configure do
  ActiveRecord::Base.establish_connection :adapter => 'sqlite3',
    :database => 'db/development.sqlite3'
end

class Drawing < ActiveRecord::Base
  serialize :points
end

class Post < ActiveRecord::Base
  default_scope :order => 'created_at desc'
end

#
# controllers
#
get '/' do
  @posts = Post.all
  haml :index
end

get '/stylesheet.css' do
  sass :stylesheet
end

get '/drawings' do
  Drawing.all.to_json
end

post '/drawings' do
  drawing = Drawing.create :points => params[:points].map {|p| p.split(',') }
  drawing.to_json
end

post '/posts' do
  post = Post.create :body => params[:body]
  post.to_json
end


#
# views
#
__END__
@@ stylesheet
body, input, textarea
  :font 32pt palatino
input[type=submit], button
  :border-radius 3px
  :border solid 1px #999
  :background-color #ccc

canvas
  :position absolute
  :top 0px
  :left 0px
  :z-index 1

form
  :z-index 2
  textarea
    :width 40%
    :height 4em

@@ layout
%html
  %head
    %title= 'visnu pitiyanuvath'
    %script{ :type => 'text/javascript', :src => 'http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js' }
    %link{ :rel => 'stylesheet', :type => 'text/css', :media => 'all', :href => '/stylesheet.css' }
  %body
    = yield

@@ index
%h1 visnu
%form{ :action => '/posts' }
  %textarea{ :name => 'body' }
  %input{ :type => 'submit', :value => 'Add' }
- @posts.each do |p|
  .post
    .minor= p.created_at
    %p= p.body
%script{ :type => 'text/javascript', :src => '/javascripts/application.js' }
