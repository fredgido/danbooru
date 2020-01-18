class ModerationReport < ApplicationRecord
  belongs_to :model, polymorphic: true
  belongs_to_creator

  scope :user, -> { where(model_type: "User") }
  scope :comment, -> { where(model_type: "Comment") }
  scope :forum_post, -> { where(model_type: "ForumPost") }

  def forum_topic_title
    "Reports requiring moderation"
  end

  def forum_topic_body
    "This topic deals with moderation events as reported by Builders. Reports can be filed against users, comments, or forum posts."
  end

  def forum_topic
    topic = ForumTopic.find_by_title(forum_topic_title)
    if topic.nil?
      topic = CurrentUser.as_system do
        ForumTopic.create(title: forum_topic_title, category_id: 0, min_level: User::Levels::MODERATOR, original_post_attributes: {body: forum_topic_body})
      end
    end
    topic
  end

  def forum_post_message
    messages = ["[b]Submitted by:[/b] @#{creator.name}"]
    case model_type
    when "User"
      messages << "[b]Submitted against:[/b] @#{model.name}"
    when "Comment"
      messages << "[b]Submitted against[/b]: comment ##{model_id}"
    when "ForumPost"
      messages << "[b]Submitted against[/b]: forum ##{model_id}"
    end
    messages << ""
    messages << "[quote]"
    messages << "[b]Reason:[/b]"
    messages << ""
    messages << reason
    messages << "[/quote]"
    messages.join("\n")
  end

  def create_forum_post!
    updater = ForumUpdater.new(forum_topic)
    updater.update(forum_post_message)
  end

  def self.search(params)
    q = super
    q = q.search_attributes(params, :model_type, :model_id, :creator_id)

    q.apply_default_order(params)
  end
end
