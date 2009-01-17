class List < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions
  has_many :topics
  
  validates_presence_of :name, :short_name
    
  attr_accessible :name, :description, :short_name, :subscriber_ids
  
  def email
    short_name + "@" + APP_CONFIG[:email_domain]
  end
  
end
