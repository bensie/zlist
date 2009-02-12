require 'digest/sha1'
class Subscriber < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :lists, :through => :subscriptions, :uniq => true

  has_many :writings, :class_name => 'Message', :foreign_key => 'subscriber_id', :dependent => :destroy
  
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :if => :saving_password?
  validates_presence_of :name
  validates_confirmation_of :password
  
  attr_accessible :name, :email, :password, :password_confirmation
  
  attr_accessor :password, :saving_password
  before_save :prepare_password, :if => :saving_password?
  before_create :generate_public_key
  
  named_scope :active, :conditions => { :disabled => false }, :order => :name
  named_scope :disabled, :conditions => { :disabled => true }, :order => :name
  
  # Search based on 'name' parameter
  named_scope :search, lambda { |name| { :conditions => ["subscribers.name LIKE ?", "%" + name + "%"], :order => :name }}
  
  # Login with email address
  def self.authenticate(login, pass)
    user = find_by_email(login)
    return user if user && user.matching_password?(pass)
  end
  
  def matching_password?(pass)
    self.password_hash == encrypt_password(pass) && login_permitted?
  end
  
  def login_permitted?
    self.password_hash.present?
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
    saving_password
  end
  
  def generate_public_key
    self.public_key = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
  
end
