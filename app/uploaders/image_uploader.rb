require "image_processing/mini_magick"

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick
  
  plugin :processing
  plugin :versions
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :remove_invalid
  # plugin :delete_promoted
  plugin :delete_raw, storages: [:store]
  
  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/gif]
    validate_max_size 2*1024*1024, message: "les images ne doivent pas dépasser 2MB (maximum)"
    validate_extension_inclusion %w[jpg jpeg png gif]
  end
  
  process(:store) do |io|
    versions = {original: io}
    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)
      # versions[:avatar] = pipeline.resize_to_fill!(64, 64)
      versions[:large] = pipeline.resize_to_limit!(1200, 1200)
      versions[:medium] = pipeline.resize_to_limit!(720, 720)
      versions[:small] = pipeline.resize_to_limit!(360, 360)
    end
    versions
  end
  
  def generate_location(io, context = {})
    if [:original, nil].include? context[:version]
      @filename = File.basename(extract_filename(io).to_s, '.*')
    end
    
    extension = ".#{io.extension}" if io.is_a?(UploadedFile) && io.extension
    extension ||= File.extname(extract_filename(io).to_s).downcase
    version = context[:version] === :original ? '' : "_#{context[:version]}"
    uniqid = "-#{generate_uid(io)}"
    directory = context[:record].class.name.downcase.pluralize
    
    "#{directory}/#{@filename}#{uniqid}#{version}#{extension}"
  end
end