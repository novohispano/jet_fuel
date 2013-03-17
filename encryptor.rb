class Encryptor
  def self.key_generator
    (0..8).collect{ (65 + rand(26)).chr }.join.downcase
  end
end