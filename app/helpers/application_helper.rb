module ApplicationHelper
  # @param [Object] date
  # @param [Symbol] format
  def timeago(date, format: :short)
    return if date.blank?

    content = I18n.l(date, format: format)

    tag.time(content,
             title: content,
             data: {
               controller: 'timeago',
               timeago_datetime_value: date.iso8601,
               timeago_refresh_interval_value: 60_000,
               timeago_add_suffix_value: true,
               timeago_include_seconds_value: true
             })
  end
end
