class List < ActiveRecord::Base

  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :order => :name, :through => :subscriptions, :uniq => true
  has_many :topics, :dependent => :destroy

  default_scope :order => :name

  scope :public, :conditions => { :private => false }
  scope :private, :conditions => { :private => true }

  validates_presence_of :name, :short_name

  before_validation :set_defaults, on: :create

  attr_accessible :name, :description, :short_name, :subscriber_ids, :private, :subject_prefix,
                  :send_replies_to, :message_footer, :permitted_to_post, :archive_disabled, :disabled

  def email
    short_name + "@" + ENV['EMAIL_DOMAIN']
  end

  def domain
    ENV['EMAIL_DOMAIN']
  end

  private

  def set_defaults
    self.subject_prefix ||= '[' + name + ']'
    self.send_replies_to ||= "Subscribers"
    self.message_footer ||= "None"
    self.permitted_to_post ||= "Subscribers"
  end

end
