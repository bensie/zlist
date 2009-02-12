require 'digest/sha1'
class Topic < ActiveRecord::Base
  belongs_to :list
  has_many :messages
  
  before_create :generate_key
  
  private
  
  def generate_key
    self.key = Digest::SHA1.hexdigest([Time.now, rand].join).to(10)
  end
end
