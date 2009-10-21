require 'me'
require 'test/unit'
require 'rack/test'

set :environment, :test

class MeTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app; Sinatra::Application end

  def test_index
    get '/'
    assert last_response.ok?
  end
end
