class Topic < ActiveRecord::Base
  belongs_to :list
  has_many :messages
end
