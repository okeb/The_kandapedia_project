# frozen_string_literal: true

Mjml.setup do |config|
  config.template_language = :erb # :erb (@default), :slim, :haml, or any other you are using

  # Default is `false` (errors suppressed), set to `true` to enable error raising
  config.raise_render_exception = true

  # Optimize the size of your emails
  config.beautify = false
  config.minify = true

  # Render MJML templates with errors
  # config.validation_level = 'soft'

  config.mjml_binary_version_supported = '4.'
end
