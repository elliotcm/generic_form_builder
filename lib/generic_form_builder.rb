class GenericFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper, ActionView::Helpers::UrlHelper

  STANDARD_FIELDS = %w[
    text_field
    password_field
    text_area
    email_field
    file_field
    number_field
    date_field
  ].freeze

  STANDARD_FIELDS.each do |method|
    define_method(method.to_sym) do |field, *args|
      options, *args = args
      options ||= {}
      return super(field, *args) if options[:default_builder]
      note   = note_html(options[:note])
      button = ' '+content_tag(:button, content_tag(:span, options[:button])) if options[:button]

      wrapper_html_options = options.delete(:wrapper_html_options) || {}

      if any_errors?(field)
        wrapper_html_options.merge!('class' => 'errors')
      end

      content_tag(:p,
        label(field, "#{options[:label] || field.to_s.humanize} #{errors_text(field)}".try(:html_safe)) +
        note +
        super(field, options, *args) +
        button.try(:html_safe),
      wrapper_html_options)
    end
  end

  def select(field, collection, options = {}, html_options = {})
    return super if options[:default_builder]
    label_text = options[:label] || field.to_s.humanize
    note       = note_html(options[:note])
    p_html_options = {}
    if any_errors?(field)
      p_html_options.merge!('class' => 'errors')
    end
    content_tag(:p, label(field, "#{label_text} #{errors_text(field)}".try(:html_safe)) + note + super, p_html_options)
  end

  def collection_select(field, collection, value_method, name_method, options = {}, html_options = {})
    return super(field, collection, value_method, name_method) if options[:default_builder]
    label_text = options[:label] || field.to_s.humanize
    note       = note_html(options[:note])
    content_tag(:p, label(field, "#{label_text} #{errors_text(field)}".try(:html_safe)) + note + super(field, collection, value_method, name_method))
  end

  def check_box(field, options = {})
    return super if options[:default_builder]
    label_text = options[:label] || field.to_s.humanize
    note       = note_html(options[:note])
    content_tag(:p, label(field, super + " #{label_text} #{errors_text(field)}".try(:html_safe) + note, :class => 'checkbox'))
  end

  def radio_button(field, value, options = {})
    return super if options[:default_builder]
    label_text = options.delete(:label) || field.to_s.humanize
    tag_type = options.delete(:tag_type) || :li
    content_tag(tag_type, label("#{field}_#{value.to_s.downcase.gsub(' ', '_')}", super + " #{label_text} #{errors_text(field)}".try(:html_safe), :class => 'radio', :onclick => ""))
  end

  def buttons(options = {})
    options = {
      cancel_class: ["cancel", "button"],
      wrapper_class: ["actions"]
    }.merge(options)

    buttons  = content_tag(:button,
                  content_tag(:span, options[:submit_text] || 'Save'),
                  type: 'submit',
                  class: options[:button_class]
                )
    buttons << link_to('Cancel', options[:cancel_link], class: options[:cancel_class]) if options[:cancel_link]

    content_tag(:div, buttons, class: options[:wrapper_class])
  end

protected

  def any_errors?(field)
    @object and @object.errors and @object.errors[field] and @object.errors[field].any?
  end

  def errors_text(field)
    return '' unless any_errors?(field)
    content_tag(:span, @object.errors[field].join(' and '), :class => "error")
  end

  def note_html(note)
    return unless note

    if note.is_a?(Hash)
      note_text = note.fetch(:text)
      options = note.except(:text)
    else
      note_text = note
    end

    content_tag(:span, note_text, :class => (options[:class] || 'note'))
  end

end
