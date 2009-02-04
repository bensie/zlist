# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def toggle_value(object)
    remote_function(
      :url => url_for(object),
      :method => :put,
      :before => "Element.show('spinner-#{object.id})",
      :complete => "Element.hide('spinner-#{object.id})",
      :with => "this.name + '=' + this.checked"
    )
  end
end
