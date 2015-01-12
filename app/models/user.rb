class User < ActiveRecord::Base
  before_create :encrypt_password

  validates :email,    :presence =>true, :uniqueness=>true
  validates :email,     format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :name,     :presence =>true, :uniqueness=>true
  validates :profile,  :presence =>true
  validates :password, :presence =>true, :length => { :minimum => 5, :maximum => 40 }, :confirmation => true

  PROFILES = [ Constants::STATUS[:SALA1], Constants::STATUS[:SALA2] ]

  def self.md5(text)
    Digest::MD5.hexdigest(text)
  end

  def encrypt_password
    if password.present?
      self.password = Digest::MD5.hexdigest(self.password)
    end
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    user if user && user.password == md5(password)
  end

  def admin?
    self.role == 'admin'
  end

  def room1?
    self.profile == Constants::STATUS[:SALA1]
  end

  def room2?
    self.profile == Constants::STATUS[:SALA2]
  end

  def can_access?(obj)
    return true if self.room1? && (obj.new_record? || obj.status == Constants::STATUS[:SALA1])
    return true if self.room1? && obj.status == Constants::STATUS[:PRODUCAO]
    return true if self.room2? && obj.status == Constants::STATUS[:SALA2]
  end

  private

  def generate_digest_token
    Digest::SHA1.hexdigest(SecureRandom.base64)
  end
end
