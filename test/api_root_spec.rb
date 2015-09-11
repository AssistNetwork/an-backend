require_relative 'test_helper'

describe AN::V1 do
  it "responds to '/api' with its version" do
    get('/api').json['version'].must_equal 'v1'
  end

  it "responds to '/api' with its environment" do
    get('/api').json['environment'].must_equal 'test'
  end
end
