class List < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions
  has_many :topics
  
  validates_presence_of :name
  
  after_update :save_subscribers
  
  attr_accessible :name, :description, :subscribers
  
  def subscribers=(subscribers)
    
    # Handle new subscribers
    if subscribers[:new_subscribers].present?
      subscribers[:new_subscribers].each do |data|
        subscribers.build(data) if data[:email].present?
      end
    end
    
    # Handle existing subscribers
    subscribers.reject(&:new_record?).each do |data|
      attributes = subscribers[:existing_subscribers][data.id.to_s]
      if attributes && attributes[:email].present?
        data.attributes = attributes
      else
        subscriptions.delete(data)
      end
    end 
  end
  
  private
  
  def save_subscribers
    subscribers.each do |s|
      s.save(false)
    end
  end
end
