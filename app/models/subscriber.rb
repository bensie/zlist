class Subscriber < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :lists, :through => :subscriptions

  has_many :writings, :class_name => 'Message', :foreign_key => 'subscriber_id'
  
  validates_uniqueness_of :email
  
  attr_accessible :name, :email
end
