module ApplicationHelper
  # @param [Object] date
  # @param [Symbol] format
  def timeago(date, format: :long)
    return if date.blank?

    # content = I18n.l(date, format: 'MM/dd/yyyy, h:mm a') # short en-US
    # content = I18n.l(date, format: 'dd/MM/y, HH:mm') # short fr-FR
    content = I18n.l(date, format: 'd MMMM y à HH:mm:ss z', locale: :fr) # long fr-FR
    # byebug  
    # content = I18n.l(date, format: 'MMMM do, y at h:mm:ss a z') # long en-US

    tag.time(content,
             title: content,
             data: {
               controller: 'timeago',
               timeago_datetime_value: date.iso8601,
               timeago_refresh_interval_value: 60_000,
               timeago_add_suffix_value: false,
               timeago_include_seconds_value: true,
               timeago_locale: 'fr'
             })
  end
end
