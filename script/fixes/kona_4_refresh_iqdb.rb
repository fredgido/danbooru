#!/usr/bin/env ruby

require_relative "base"

post_id = ARGV[0].to_i
descending = ARGV[1] == 'true' # If true, sorts in descending order; otherwise, ascending.
sort_order = descending ? :desc : :asc

puts post_id > 0 ? "Processing posts with IDs greater than ##{post_id}." : "No valid ID provided. Processing all posts."

File.open('failed_iqdb_files.txt', 'a') do |log_file|
  Post.all.where("id > ?", post_id ? post_id : 0).order(id: sort_order).find_each do |post|
    begin
      if post.asset.variant("720x720").open_file.nil?
        puts "did not find file for ##{asset.id}"
        next
      end
      IqdbClient.new.add_post(post)
      puts "##{post.id} post iqdb regenerated"
    rescue Errno::ENOENT => e
      error_message = "Error: Unable to open original file for Post ##{post.id}: #{e.message}. Skipping post iqdb regeneration."
      puts error_message
      log_file.puts(error_message)
    rescue StandardError => e
      error_message = "An unexpected error occurred while processing Post ##{post.id}: #{e.message}. Skipping post iqdb regeneration."
      puts error_message
      log_file.puts(error_message)
    end
  end
end
