class User < ActiveRecord::Base

  has_many :statistics

  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :phone, :password, :password_confirmation

  attr_accessor :password
  before_save :prepare_password

  validates_presence_of :username
  validates_uniqueness_of :username, :phone
  validates_format_of :username, :with => /\A[a-z]{4,20}\z/, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :phone, :with => /\A[0-9]{11}\z/
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4

  scope :not_admin, -> { where('username <> "admin"') }

  def self.authenticate(login, pass)
    user = find_by_username(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def is_admin?
    username == 'admin'
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end
