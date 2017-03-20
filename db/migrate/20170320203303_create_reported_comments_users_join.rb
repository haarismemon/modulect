class CreateReportedCommentsUsersJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :reported_comments_users, :id => false do |t|
      t.integer "comment_id"
      t.integer "user_id"
    end

    add_index("reported_comments_users", ["comment_id", "user_id"])
  end
end
