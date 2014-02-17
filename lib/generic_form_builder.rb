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
      options ||= {}
      return super(field, *args) if options[:default_builder]
      note   = content_tag(:span, options[:note], :class => 'note') if options[:note]
      button = ' '+content_tag(:button, content_tag(:span, options[:button])) if options[:button]

      html_options = {}

      if any_errors?(field)
        errors = ' '+content_tag(:span, errors_text(field), :class => "error")
        html_options.merge!('class' => 'errors')
      end

      content_tag(:p, label(field, "#{options[:label] || field.to_s.humanize}#{errors}".try(:html_safe)) + note + super(field, options, *args) + button.try(:html_safe), html_options)
    end
  end

  def select(field, collection, options = {}, html_options = {})
    return super if options[:default_builder]
    label_text = options[:label] || field.to_s.humanize
    note       = content_tag(:span, options[:note], :class => 'note') if options[:note]
    content_tag(:p, label(field, "#{label_text} #{errors_text(field)}") + note + super)
  end

  def collection_select(field, collection, value_method, name_method, options = {}, html_options = {})
    return super(field, collection, value_method, name_method) if options[:default_builder]
    label_text = options[:label] || field.to_s.humanize
    note       = content_tag(:span, options[:note], :class => 'note') if options[:note]
    content_tag(:p, label(field, "#{label_text} #{errors_text(field)}") + note + super(field, collection, value_method, name_method))
  end

  def check_box(field, options = {})
    return super if options[:default_builder]
    label_text = options[:label] || field.to_s.humanize
    content_tag(:p, label(field, super + " #{label_text} #{errors_text(field)}", :class => 'checkbox'))
  end

  def radio_button(field, value, options = {})
    return super if options[:default_builder]
    label_text = options.delete(:label) || field.to_s.humanize
    tag_type = options.delete(:tag_type) || :li
    content_tag(tag_type, label("#{field}_#{value.to_s.downcase.gsub(' ', '_')}", super + " #{label_text} #{errors_text(field)}", :class => 'radio', :onclick => ""))
  end

  def buttons(options = {})
    buttons  = content_tag(:button, content_tag(:span, options[:submit_text] || 'Save'), :type => 'submit')
    buttons << link_to('Cancel', options[:cancel_link], :class => 'cancel button') if options[:cancel_link]

    content_tag(:div, buttons, :class => 'actions')
  end

protected

  def any_errors?(field)
    @object and @object.errors and @object.errors[field] and @object.errors[field].any?
  end

  def errors_text(field)
    return '' unless any_errors?(field)
    @object.errors[field].join(' and ')
  end

end
