class Subscription < ActiveRecord::Base
  # This is the table that exists between a list and a subscriber, allowing
  # their connection to have a state.  We could, for example, add a "disabled"
  # boolean to this column to give us the ability to temporarily disable a
  # user's subscription to a list without deleting it.
  belongs_to :list
  belongs_to :subscriber
end
