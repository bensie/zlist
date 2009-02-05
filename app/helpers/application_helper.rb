module ApplicationHelper
  # Helper method for toggling an AJAX checkbox, assumes you can mass-assign the value to the resource
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
