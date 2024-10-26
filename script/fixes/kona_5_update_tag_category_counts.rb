#!/usr/bin/env ruby

require_relative "base"

post_id = ARGV[0].to_i

puts post_id > 0 ? "Processing posts with IDs greater than ##{post_id}." : "No valid ID provided. Processing all posts."

File.open('failed_update_tag_category_counts!_files.txt', 'a') do |log_file|
  Post.all.where("id > ?", post_id ? post_id : 0).find_each do |post|
    begin
      post.update_tag_category_counts!
      post.save!
      puts "##{post.id} post category counts regenerated"
    rescue Errno::ENOENT => e
      error_message = "Error: Unable to open original file for Post ##{post.id}: #{e.message}. Skipping post update_tag_category_counts!."
      puts error_message
      log_file.puts(error_message)
    rescue StandardError => e
      error_message = "An unexpected error occurred while processing Post ##{post.id}: #{e.message}. Skipping post update_tag_category_counts!."
      puts error_message
      log_file.puts(error_message)
    end
  end
end
