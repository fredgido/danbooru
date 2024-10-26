#!/usr/bin/env ruby

require_relative "base"

DIRECTORY = ENV.fetch("DIRECTORY", "inlines")

def process_file(file_path)
  file_name = File.basename(file_path)
  file_md5 = Digest::MD5.file(file_path).hexdigest
  file_created_at = File.birthtime(file_path) # Gets creation time
  file_modified_at = File.mtime(file_path) # Gets last modification time
  media_asset = MediaAsset.find_by(md5: file_md5)
  return if media_asset

  uploaded_file = MediaAsset.upload!(File.open(file_path), role: "attachment")
  media_asset = MediaAsset.find_by(md5: file_md5)
  if media_asset.nil?
    puts({ error: "Upload failed, media asset not found", file_path: file_path }.to_json)
    return
  end

  media_asset.update!(created_at: file_created_at, updated_at: file_modified_at)

  puts "Saved inline pic with id ##{profile_picture}."

  puts({ file_path: file_path, file_md5: file_md5, profile_picture: profile_picture }.to_json)
rescue StandardError => e
  ActiveRecord::Base.connection_pool.release_connection
  puts({ error: e.message, file: file_path }.to_json)
end

Dir.glob("#{DIRECTORY}/*").each do |file_path|
  next unless File.file?(file_path) # Ensure it's a file
  process_file(file_path)
end
