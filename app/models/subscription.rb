class Subscription < ActiveRecord::Base
  belongs_to :list
  belongs_to :subscriber
end
