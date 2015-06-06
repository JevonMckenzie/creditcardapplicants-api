require 'rbnacl/libsodium'
require 'jwt'
require 'pony'

module CreditCardAPIHelper
  class Registration
    attr_accessor :username, :email, :password, :fullname, :address, :dob

    def initialize(user_hash)
      @username = user_hash['username'] || user_hash[:username]
      @email = user_hash['email'] || user_hash[:email]
      @password = user_hash['password'] || user_hash[:password]
      @fullname = user_hash['fullname'] || user_hash[:fullname]
      @address = user_hash['address'] || user_hash[:address]
      @dob = user_hash['dob'] || user_hash[:dob]
    end

    def complete?
      (username && username.length > 0) &&
      (email && email.length > 0) &&
      (password && password.length > 0) &&
      (fullname && fullname.length > 0) &&
      (address && address.length > 0) &&
      (dob && dob.length > 0)
    end
  end

  def random_simple(max=nil, seed=nil)
    req_params = { max: max, seed: seed }
    op = Operation.new(operation: 'random_simple',
                       parameters: req_params.to_json)
    op.save

    seed ||= Random.new_seed
    randomizer = Random.new(seed)
    result = max ? randomizer.rand(max) : randomizer.rand

    { random: result, seed: seed,
      notes: 'Simple PRNG not for secure use' }
  end

  def email_registration_verification(registration)
    payload = {username: registration.username, email: registration.email,
               password: registration.password, fullname: registration.fullname,
               address: registration.address, dob: registration.dob}
    token = JWT.encode payload, ENV['MSG_KEY'], 'HS256'
    verification = encrypt_message(token)
    Pony.mail(to: registration.email,
              subject: "Your Credit Card Account is Ready",
              html_body: registration_email(verification))
  end

  def registration_email(token)
    verification_url = "#{request.base_url}/sign_up?token=#{token}"
    "<H1>Credit Card Registration Received<H1>" \
    "<p>Please <a href=\"#{verification_url}\">click here</a> to validate " \
    "your email and activate your account</p>"
  end

  def encrypt_message(message)
    key = Base64.urlsafe_decode64(ENV['MSG_KEY'])
    secret_box = RbNaCl::SecretBox.new(key)
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
    nonce_s = Base64.urlsafe_encode64(nonce)
    message_enc = secret_box.encrypt(nonce, message.to_s)
    message_enc_s = Base64.urlsafe_encode64(message_enc)
    Base64.urlsafe_encode64({'message'=>message_enc_s, 'nonce'=>nonce_s}.to_json)
  end

  def decrypt_message(secret_message)
    key = Base64.urlsafe_decode64(ENV['MSG_KEY'])
    secret_box = RbNaCl::SecretBox.new(key)
    message_h = JSON.parse(Base64.urlsafe_decode64(secret_message))
    message_enc = Base64.urlsafe_decode64(message_h['message'])
    nonce = Base64.urlsafe_decode64(message_h['nonce'])
    message = secret_box.decrypt(nonce, message_enc)
  rescue
    raise "INVALID ENCRYPTED MESSAGE"
  end

  def create_account_with_registration(registration)
    new_user = User.new(username: registration.username, email: registration.email, password: registration.password, fullname: registration.fullname, address: registration.address, dob: registration.dob)
    new_user.save ? login_user(new_user) : fail('Could not create new user')
  end

  def create_user_with_encrypted_token(token_enc)
    token = decrypt_message(token_enc)
    payload = (JWT.decode token, ENV['MSG_KEY']).first
    reg = Registration.new(payload)
    create_account_with_registration(reg)
  end

  def login_user(user)
    payload = {user_id: user.id}
    token = JWT.encode payload, ENV['MSG_KEY'], 'HS256'
    session[:auth_token] = token
    redirect '/'
  end

  def find_user_by_token(token)
    return nil unless token
    decoded_token = JWT.decode token, ENV['MSG_KEY'], true
    payload = decoded_token.first
    logger.info "PAYLOAD: #{payload}"
    User.find_by_id(payload["user_id"])
  end
end
