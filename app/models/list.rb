class List < ActiveRecord::Base

  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :uniq => true
  has_many :topics, :dependent => :destroy
  
  named_scope :public, :conditions => { :private => false }
  named_scope :private, :conditions => { :private => true }

  validates_presence_of :name, :short_name
  
  before_create :set_default_subject_prefix
 
  attr_accessible :name, :description, :short_name, :subscriber_ids, :private, :subject_prefix

  def email
    short_name + "@" + APP_CONFIG[:email_domain]
  end

  def domain
    APP_CONFIG[:email_domain]
  end
  
  private
  
  def set_default_subject_prefix
    self.subject_prefix ||= '[' + name + ']'
  end
  
end
