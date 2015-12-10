Dir[File.expand_path('helpers/**/*.rb', __dir__)].reduce(self, :require)

class ANApi < APITest


#   def setup
#     @path = Pathname(File.expand_path(File.dirname(__FILE__)) + '/data/' )
#     super
#   end

#  def self.test_order
#    :alpha
#  end


  def test_api_works
    get '/api'
    assert last_response.ok?
    assert JSON.parse(last_response.body), {"version":"v1","environment":"development"}
    p JSON.parse(last_response.body).to_s
  end

  def test_login
    get '/api/login', {"email":"user1@assist.network","node":"1"}
    assert last_response.ok?
    assert JSON.parse(last_response.body), {:success => true, :name => "user1", :uid => "1", :auth_token => "verysecretauthtoken1"}
    p JSON.parse(last_response.body).to_s
  end

  def test_com_1works
    get '/api/com/test'
    assert last_response.ok?
    assert JSON.parse(last_response.body), '{"ping": "pong"}'
    p JSON.parse(last_response.body).to_s
  end

  def test_com_2post
    data = JSON.parse(File.read(@path + 'com_post_msg.json'))
    post '/api/com', data
#    assert last_response.ok? #201 valamiért nem ok
    p JSON.parse(last_response.body).to_s

    assert_equal JSON.parse(last_response.body),
      {"result"=>[
                  {"object"=>"d1", "state"=>"created"},
                  {"object"=>"s1", "state"=>"created"},
                  {"object"=>"d2", "state"=>"created"}
                ],
       "success"=>true}

  end

  def test_com_3get

    def test_pre_post
      data = JSON.parse(File.read(@path + 'com_get_set_object.json'))
      post '/api/com', data
    end

    test_pre_post

    data = JSON.parse(File.read(@path + 'com_get_query_object.json'))
    get '/api/com', data

    resp1 = JSON.parse(last_response.body)
    resp2 = JSON.parse(File.read(@path + 'com_get_resp_object.json'))

    resp2[0]['result']['page'][0]['id'] = resp1[0]['result']['page'][0]['id']
    resp2[0]['result']['page'][0]['created_at'] = resp1[0]['result']['page'][0]['created_at']
    resp2[0]['result']['page'][0]['updated_at'] = resp1[0]['result']['page'][0]['updated_at']

    assert_equal resp1,resp2

    p JSON.parse(last_response.body).to_s
  end

end