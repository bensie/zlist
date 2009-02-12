class List < ActiveRecord::Base
  # Associations: has_many associations expect a foreign_key of list_id in
  # the associated column.  In the case of has_many :through, there is a join
  # table in the middle (subscriptions) that allows both the list to have many subscribers,
  # and subscribers can be subscribe to more than one list.
  
  has_many :subscriptions, :dependent => :destroy
  has_many :subscribers, :through => :subscriptions, :source => :author, :uniq => true
  has_many :topics
  
  named_scope :public, :conditions => { :private => false }
  named_scope :private, :conditions => { :private => true }

  # Make sure that the following fields are not nil or blank
  validates_presence_of :name, :short_name
  
  # For security, we specify the columns that are safe to allow mass assignment in web forms.
  # So in our controller it's safe to do a List.create(params[:list]), and we don't have to
  # worry about someone trying to manipulate other columns in the DB that they shouldn't.
  # For example, if we had a boolean admin column in the "lists" table, someone could manufacture
  # their own form and set the admin value to "1".  This ensures that can't happen.  The only way
  # to set these attributes is by doing something like:
  # list = List.build(params[:list])
  # list.admin = true
  # list.save  
  attr_accessible :name, :description, :short_name, :subscriber_ids, :private
  
  # Here we are creating a virtual attribute, so it is an attribute of the List class that's available
  # to any list, but it does not actually have a column in the database.  Instead, it is appending our
  # selected domain name to the "short_name" attribute, which is a database attribute.
  def email
    short_name + "@" + APP_CONFIG[:email_domain]
  end

  # Shortcut to get domain of the list.  
  # For now, this will just be a shortcut to the app config, but in later versions might be different
  def domain
    APP_CONFIG[:email_domain]
  end
  
end
