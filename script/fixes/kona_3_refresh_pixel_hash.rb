#!/usr/bin/env ruby

require_relative "base"

asset_id = ARGV[0].to_i
descending = ARGV[1] == 'true' # If true, sorts in descending order; otherwise, ascending.
sort_order = descending ? :desc : :asc

assets = MediaAsset.where(" pixel_hash = '00000000-0000-0000-0000-000000000000'::uuid ").order(id: sort_order)

puts asset_id > 0 ? "Processing assets with IDs greater than ##{asset_id}." : "No valid ID provided. Processing all assets."

File.open('failed_pixel_hash_files.txt', 'a') do |log_file|
  assets.find_each do |asset|
    begin
      if asset.variant("720x720").open_file.nil?
        puts " did not find file for ##{asset.id}"
        next
      end
      asset.original.open_file! do |original_file|
        asset.update!(pixel_hash: MediaFile.open(original_file).pixel_hash)
        puts "##{asset.id} media pixel hash regenerated"
      end
    rescue Errno::ENOENT => e
      error_message = "Error: Unable to open original file for Asset ##{asset.id}: #{e.message}. Skipping pixel hash regeneration."
      puts error_message
      log_file.puts(error_message)
    rescue StandardError => e
      error_message = "An unexpected error occurred while processing Asset ##{asset.id}: #{e.message}. Skipping pixel hash regeneration."
      puts error_message
      log_file.puts(error_message)
    end
  end
end
