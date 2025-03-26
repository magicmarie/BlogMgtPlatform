require_relative '../data_manager'
require_relative '../validators'

class Comments
  def self.add_comment(post_id, author, content)
    comments = DataManager.all_comments

    new_comment = {
      id: SecureRandom.uuid,
      postId: post_id,
      author: author,
      content: content,
      date: Time.now.utc.iso8601
    }

    validation = CommentSchema.call(new_comment)
    return { error: validation.errors.to_h } unless validation.success?

    comments << new_comment
    DataManager.save_data(DataManager::COMMENTS_FILE, comments)
    new_comment
  end

  def self.get_comments(post_id)
    DataManager.all_comments.select { |c| c["postId"] == post_id }
  end

  def self.delete_comment(post_id, comment_id)
    posts = DataManager.all_posts
    post = posts.find { |p| p["id"] == post_id }
    return { error: "Post not found" } unless post

    comments = DataManager.all_comments
    filtered_comments = comments.reject { |c| c["id"] == comment_id && c["postId"] == post_id }

    if comments.length == filtered_comments.length
      { error: "Comment not found" }
    else
      DataManager.save_data(DataManager::COMMENTS_FILE, filtered_comments)
      { message: "Comment deleted successfully" }
    end
  end
end
