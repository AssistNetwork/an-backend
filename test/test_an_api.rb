Dir[File.expand_path('helpers/**/*.rb', __dir__)].reduce(self, :require)

class ANApi < APITest

  def test_api_works
    get '/api'
    assert last_response.ok?
    assert JSON.parse(last_response.body), '{"version":"v1","environment":"development"}'
    p JSON.parse(last_response.body).to_s
  end

  def test_com_works
    get '/api/com/test'
    assert last_response.ok?
    assert JSON.parse(last_response.body), '{"ping": "pong"}'
    p JSON.parse(last_response.body).to_s
  end

  def test_com_post
    path = Pathname(File.expand_path(File.dirname(__FILE__)) + '/data/' )
    data = JSON.parse(File.read(path + 'ancom.json'))
    post '/api/com', data
#    assert last_response.ok? #201 valamiért nem ok
    assert JSON.parse(last_response.body), '{"result":"[{:object=>"d1", :success=>true}, {:object=>"s1", :success=>true}, {:object=>"d2", :success=>true}]","success":true}'
    p JSON.parse(last_response.body).to_s
  end

end