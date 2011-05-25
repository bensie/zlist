class List < ActiveRecord::Base

  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :order => :name, :through => :subscriptions, :uniq => true
  has_many :topics, :dependent => :destroy
  
  default_scope :order => :name
  
  scope :public, :conditions => { :private => false }
  scope :private, :conditions => { :private => true }

  validates_presence_of :name, :short_name
  
  before_create :set_default_subject_prefix
 
  attr_accessible :name, :description, :short_name, :subscriber_ids, :private, :subject_prefix,
                  :send_replies_to, :message_footer, :permitted_to_post, :archive_disabled, :disabled

  def email
    short_name + "@" + ENV['email_domain']
  end

  def domain
    ENV['email_domain']
  end
  
  private
  
  def after_initialize
    if @new_record
      self.send_replies_to ||= "Subscribers"
      self.message_footer ||= "None"
      self.permitted_to_post ||= "Subscribers"
    end
  end
  
  def set_default_subject_prefix
    self.subject_prefix ||= '[' + name + ']'
  end
  
end
