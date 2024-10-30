#!/usr/bin/env ruby

require_relative "base"

asset_id = ARGV[0].to_i
descending = ARGV[1] == 'true' # If true, sorts in descending order; otherwise, ascending.
sort_order = descending ? :desc : :asc

assets = asset_id > 0 ? MediaAsset.where("id > ?", asset_id).order(id: sort_order) : MediaAsset.all.order(id: sort_order)

puts asset_id > 0 ? "Processing assets with IDs greater than ##{asset_id}." : "No valid ID provided. Processing all assets."

File.open('failed_thumbnail_files.txt', 'a') do |log_file|
  assets.find_each do |asset|
    next if asset.variant("720x720").open_file
    begin
      asset.original.open_file! do |original_file|
        # Attempt to distribute files
        asset.distribute_files!(original_file, variants: asset.variants.without(asset.original))
        puts "##{asset.id} asset thumbnails regenerated"
      end
    rescue Errno::ENOENT => e
      error_message = "Error: Unable to open original file for Asset ##{asset.id}: #{e.message}. Skipping regeneration."
      puts error_message
      log_file.puts(error_message)
    rescue StandardError => e
      error_message = "An unexpected error occurred while processing Asset ##{asset.id}: #{e.message}. Skipping regeneration."
      puts error_message
      log_file.puts(error_message)
    end
  end
end
