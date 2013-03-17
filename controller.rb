class Controller
  def self.url_shortener(original_url)
    if Url.exists?(original: original_url)
      @url = Url.where(original: original_url).first
      erb :url_success
    else
      random_url = Encryptor.key_generator
      @url = Url.create(original: original_url, shortened: random_url)
      erb :url_success
    end
  end

  def self.register(clear_password, email)
    if email != ""
      if User.exists?(email: email)
        erb :user_error
      else
        salt = Encryptor.key_generator
        password_signer = Digest::HMAC.new(salt, Digest::SHA1)
        salted_password = password_signer.hexdigest(clear_password)

        @user = User.create(email: email, password_hash: salted_password, password_salt: salt)
        erb :user_success
      end
    else
      "You didn't give us a username"
    end
  end
end