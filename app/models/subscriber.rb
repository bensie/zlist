class Subscriber < ActiveRecord::Base
  has_many :subscriptions, :dependent => :destroy
  has_many :lists, :through => :subscriptions
  
  validates_uniqueness_of :email
  
  attr_accessible :name, :email
end
