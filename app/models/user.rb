class User < ActiveRecord::Base

  has_many :statistics

  # new columns need to be added here to be writable through mass assignment
  attr_accessible :email, :name, :password, :password_confirmation

  attr_accessor :password
  before_save :prepare_password

  validates_presence_of :email
  validates_presence_of :name
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => 'incorrect format of email'
  #validates_format_of :phone, :with => /\A[0-9]{11}\z/
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4

  scope :not_admin, -> { where('email <> "admin@admin.com"') }

  def self.authenticate(email, pass)
    user = find_by_email(email)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def is_admin?
    email == 'admin@admin.com'
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
