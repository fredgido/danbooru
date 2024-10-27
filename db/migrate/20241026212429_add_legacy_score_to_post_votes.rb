class AddLegacyScoreToPostVotes < ActiveRecord::Migration[6.1]
  def change
    add_column :post_votes, :legacy_score, :smallint, null: true
  end
end
