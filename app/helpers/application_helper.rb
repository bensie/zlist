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
  
  # Focus keyboard entry on a particular form field
  def focus_field(dom_id)
    script = "
<script type=\"text/javascript\">
//<![CDATA[
  Event.observe(window, \"load\", function() { $(\"#{dom_id}\").focus() });
//]]>
</script>"
  end
end
