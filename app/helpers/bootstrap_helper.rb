module BootstrapHelper

  def bs_text_field(form, field, label, options = {})
    required = options.delete(:required) ? "required" : nil
    hint = options.delete(:hint)
    output  = %(<div class="clearfix">)
    output += form.label(field, label, class: required)
    output += %(<div class="input">)
    output += form.text_field(field, options)
    output += %(<span class="help-block">#{hint}</span>) if hint
    output += %(</div>)
    output += %(</div>)
    return output.html_safe
  end

  def bs_password_field(form, field, label, options = {})
    required = options.delete(:required) ? "required" : nil
    hint = options.delete(:hint)
    output  = %(<div class="clearfix">)
    output += form.label(field, label, class: required)
    output += %(<div class="input">)
    output += form.password_field(field, options)
    output += %(<span class="help-block">#{hint}</span>) if hint
    output += %(</div>)
    output += %(</div>)
    return output.html_safe
  end

  def bs_text_area(form, field, label, options = {})
    required = options.delete(:required) ? "required" : nil
    hint = options.delete(:hint)
    output  = %(<div class="clearfix">)
    output += form.label(field, label, class: required)
    output += %(<div class="input">)
    output += form.text_area(field, options.merge(rows: options[:rows] || 10))
    output += %(<span class="help-block">#{hint}</span>) if hint
    output += %(</div>)
    output += %(</div>)
    return output.html_safe
  end

  def bs_check_box_block(label = nil, &block)
    output  = %(<div class="clearfix">\n)
    output += %(  <label>#{label}</label>\n) if label
    output += %(  <div class="input">\n)
    output += %(    <ul class="inputs-list">\n)
    output +=         capture(&block)
    output += %(    </ul>\n)
    output += %(  </div>\n)
    output += %(</div>)
    return output.html_safe
  end

  def bs_check_box(form, field, label, options = {})
    required = options.delete(:required) ? "required" : nil
    hint = options.delete(:hint)
    output  = %(<li>\n)
    output += %(  <label for="#{form.object_name}_#{field}">\n)
    output += %(    #{form.check_box(field, options)}\n)
    output += %(    <span class="#{required}">#{label}</span>\n)
    output += %(    <span class="help-block">#{hint}</span>\n) if hint
    output += %(  </label>\n)
    output += %(</li>\n)
    return output.html_safe
  end

  def bs_select(form, field, label, choices, options = {}, html_options = {})
    required = html_options.delete(:required) ? "required" : nil
    hint = html_options.delete(:hint)
    output  = %(<div class="clearfix">)
    output += form.label(field, label, class: required)
    output += %(<div class="input">)
    output += form.select(field, choices, options, html_options)
    output += %(<span class="help-block">#{hint}</span>) if hint
    output += %(</div>)
    output += %(</div>)
    return output.html_safe
  end

end
