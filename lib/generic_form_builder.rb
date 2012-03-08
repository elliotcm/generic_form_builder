class GenericFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper, ActionView::Helpers::UrlHelper

  %w[
    text_field
    password_field
    text_area
    email_field
    file_field
    number_field
  ].each do |method|
    define_method(method.to_sym) do |field, *args|
      options, *args = args
      options ||= {:label => field.to_s.humanize}
      note   = content_tag(:span, options[:note], :class => 'note') if options[:note]
      button = ' '+content_tag(:button, content_tag(:span, options[:button])) if options[:button]
      errors = ' '+@object.errors[field].join(' and ') if @object.errors[field].any?
      content_tag(:p, label(field, "#{options[:label]}#{errors}") + note + super(field, options, *args) + button.try(:html_safe))
    end
  end

  def select(field, collection, options = {}, html_options = {})
    label_text = options[:label] || field.to_s.humanize
    content_tag(:p, label(field, "#{label_text} #{errors_text(field)}") + super)
  end

  def collection_select(field, collection, value_method, name_method, options = {}, html_options = {})
    label_text = options[:label] || field.to_s.humanize
    content_tag(:p, label(field, "#{label_text} #{errors_text(field)}") + super(field, collection, value_method, name_method))
  end

  def check_box(field, options = {})
    label_text = options[:label] || field.to_s.humanize
    content_tag(:p, label(field, super + " #{label_text} #{errors_text(field)}", :class => 'checkbox'))
  end

  def radio_button(field, value, options = {})
    label_text = options.delete(:label) || field.to_s.humanize
    options[:tag_type] ||= :li
    content_tag(options[:tag_type], label(field, super + " #{label_text} #{errors_text(field)}"))
  end

  def buttons(options = {})
    buttons  = content_tag(:button, content_tag(:span, options[:submit_text] || 'Save'), :type => 'submit')
    buttons << link_to('Cancel', options[:cancel_link], :class => 'cancel button') if options[:cancel_link]

    content_tag(:div, buttons, :class => 'actions')
  end

protected

  def errors_text(field)
    return '' if @object.errors[field].empty?
    @object.errors[field]
  end

end
