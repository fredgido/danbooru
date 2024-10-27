#!/usr/bin/env ruby

require_relative "base"

CurrentUser.user = User.system

asset_id = ARGV[0].to_i

File.open('failed_media_metadata_files.txt', 'a') do |log_file|

MediaAsset.active.where("id > ?", asset_id).find_each do |asset|
    begin
      variant = asset.variant(:original)
      media_file = variant.open_file
      if asset.variant("720x720").open_file.nil?
        puts " did not find file for ##{asset.id}"
        next
      end


      asset.file = media_file # Setting `file` updates the metadata if it's different.
      asset.media_metadata.file = media_file
      asset.post.assign_attributes(image_width: asset.image_width, image_height: asset.image_height, file_ext: asset.file_ext, file_size: asset.file_size) if asset.post.present?

      old = asset.media_metadata.metadata_was.to_h
      new = asset.media_metadata.metadata.to_h
      metadata_changes = { added_metadata: (new.to_a - old.to_a).to_h, removed_metadata: (old.to_a - new.to_a).to_h }.compact_blank
      puts ({ id: asset.id, **asset.changes, **metadata_changes }).to_json

      # Set media_metadata's ID to match asset's ID before saving if it doesn't already have an ID
      asset.media_metadata.id = asset.id if asset.media_metadata.new_record? || asset.media_metadata.id.nil?

      asset.post.save! if asset.post&.changed?
      asset.save! if asset.changed?
      asset.media_metadata.save! if asset.media_metadata.changed?
      # asset.media_metadata.update!(id: asset.id) if asset.media_metadata.id != asset.id

      media_file.close
      puts "##{asset.id} media pixel hash regenerated"
    rescue Errno::ENOENT => e
      error_message = "Error: Unable to open original file for Asset ##{asset.id}: #{e.message}. Skipping media metadata regeneration."
      puts error_message
      log_file.puts(error_message)
    rescue StandardError => e
      error_message = "An unexpected error occurred while processing Asset ##{asset.id}: #{e.message}. Skipping media metadata regeneration."
      puts error_message
      log_file.puts(error_message)
    end
  end
end
