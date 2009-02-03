class Subscriber < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :lists, :through => :subscriptions

  has_many :writings, :class_name => 'Message', :foreign_key => 'subscriber_id', :dependent => :destroy
  
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :if => :saving_password?
  validates_confirmation_of :password
  
  attr_accessible :name, :email, :password, :password_confirmation
  
  attr_accessor :password, :saving_password
  before_save :prepare_password, :if => :saving_password?
  
  named_scope :active, :conditions => { :disabled => false }
  named_scope :disabled, :conditions => { :disabled => true }
  
  # Login with email address
  def self.authenticate(login, pass)
    user = find_by_email(login)
    return user if user && user.matching_password?(pass)
  end
  
  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end
  
  private
  
  def prepare_password
    self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
    self.password_hash = encrypt_password(password)
  end
  
  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, password_salt].join)
  end
  
  def saving_password?
    saving_password || new_record?
  end
  
end
