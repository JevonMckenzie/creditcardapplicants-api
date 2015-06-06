require_relative 'rack_test_helper'

describe 'Tests on saving in the database' do

  before do
    CreditCard.all
  end

  it 'should return status 201 ' do
    req_header = {'CONTENT_TYPE'=>'application/json'}
    req_body = {
      expiration_date: '2014/09/22',
      owner: 'Amon',
      number: '4539075978941247',
      credit_network: 'Visa'
      }.to_json
    post '/api/v1/credit_card', req_body, req_header
    last_response.status.must_equal 201
  end
end
