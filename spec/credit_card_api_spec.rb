require 'json'

require_relative 'rack_test_helper.rb'
require_relative '../app.rb'

include Rack::Test::Methods

def app
  CreditCardAPI
end

describe 'Root route' do
  it 'should return a message that the service is available' do
    get '/'
    # must be 2xx or 3xx
    assert_includes(200..399, last_response.status)
    # body can't be empty
    refute_empty(last_response.body)
  end
end

describe 'Validation route' do
  it 'should return a JSON containing card numbers and validation state' do
    cards = [
      {
        number: '4024097178888052',
        valid: false
      },
      {
        number: '4916603231464963',
        valid: true
      }
    ]
    cards.each do |card|
      get '/api/v1/credit_card/validate', card_number: card[:number]
      # must be 2xx or 3xx
      assert_includes(200..399, last_response.status)
      # body should be correct in format
      resp = JSON.parse last_response.body
      assert_equal(resp['card'], card[:number])
      assert_equal(resp['validated'], card[:valid])
    end
  end
end

describe 'Saving Credit Cards' do
  it 'should return status 201' do
    req_header = { 'content-type': 'application/json' }
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

describe 'All credit cards' do
  it 'should return all credit cards' do
    # clean up database
    CreditCard.delete_all

    cards = [
      {
        number: '4024097178888052', # invalid
        expiration_date: '',
        owner: '',
        credit_network: ''
      },
      {
        number: '4916603231464963', # valid
        expiration_date: '',
        owner: '',
        credit_network: ''
      },
      {
        number: '4916603231464963' # valid
        # missing values
      }
    ]

    req_header = { 'content-type': 'application/json' }

    cards.each do |card|
      post '/api/v1/credit_card', card.to_json, req_header
    end

    get '/api/v1/credit_card/all'
    resp = JSON.parse last_response.body
    assert_equal(resp.class, Array)
    assert_equal(resp.length, 2)
    resp.each do |card|
      assert_equal(card['number'], '4916603231464963')
    end
  end
end
