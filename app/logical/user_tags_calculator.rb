# frozen_string_literal: true

class UserTagsCalculator
  CACHE_DURATION = 1.day
  TAG_COUNT = 6

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def cache_key
    "user-tags-#{user.name}"
  end

  def tags
    Cache.get(cache_key, CACHE_DURATION) do
      calculate_tags
    end
  end

  def calculate_tags
    post_query = PostQuery.normalize("user:#{user.name}", current_user: user)
    favorite_query = PostQuery.normalize("fav:#{user.name}", current_user: user)
    post_tags = RelatedTagCalculator.new(post_query, search_sample_size: 100_000, tag_sample_size: 1000).frequent_tags_for_search
    grouped_post_tags = post_tags.group_by(&:category).transform_values { |v| v.map { |tag| tag.tag }.take(TAG_COUNT) }
    favorite_tags = RelatedTagCalculator.new(favorite_query, search_sample_size: 100_000, tag_sample_size: 1000).frequent_tags_for_search
    favorite_tags = favorite_tags.group_by(&:category).transform_values { |v| v.map { |tag| tag.tag }.take(TAG_COUNT) }

    { post_tags: post_tags.take(6), favorite_tags:, grouped_post_tags: }
  end
end
