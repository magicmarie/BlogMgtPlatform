require_relative '../data_manager'
require_relative '../validators'

class Posts
  def self.create_post(title, content, author, tags, bookmarked = false)
    posts = DataManager.all_posts

    new_post = {
      id: SecureRandom.uuid,
      title: title,
      content: content,
      author: author,
      tags: tags,
      date: Time.now.utc.iso8601,
      bookmarked: bookmarked
    }

    validation = PostSchema.call(new_post)
    return { error: validation.errors.to_h } unless validation.success?

    posts << new_post
    DataManager.save_data(DataManager::POSTS_FILE, posts)
    new_post
  end

  def self.get_posts(page = 1, per_page = 15)
    posts = DataManager.all_posts.sort_by { |p| p["date"] }.reverse
    posts.each_slice(per_page).to_a[page - 1] || []
  end

  def self.update_post(id, updates)
    posts = DataManager.all_posts
    post = posts.find { |p| p["id"] == id }
    return { error: "Post not found" } unless post

    updates.each { |k, v| post[k.to_s] = v if post.key?(k.to_s) }

    validation = PostSchema.call(post)
    return { error: validation.errors.to_h } unless validation.success?

    DataManager.save_data(DataManager::POSTS_FILE, posts)
    post
  end

  def self.delete_post(id)
    posts = DataManager.all_posts
    filtered_posts = posts.reject { |p| p["id"] == id }

    if posts.length == filtered_posts.length
      { error: "Post not found" }
    else
      DataManager.save_data(DataManager::POSTS_FILE, filtered_posts)
      { message: "Post deleted successfully" }
    end
  end

  def self.update_post(id, updates)
    posts = DataManager.all_posts
    post = posts.find { |p| p["id"] == id }
    return { error: "Post not found" } unless post

    updates.each do |key, value|
      if post.key?(key)
        post[key] = value
      else
        return { error: "Invalid field: #{key}" }
      end
    end

    # Validation after update
    validation = PostSchema.call(post)
    return { error: validation.errors.to_h } unless validation.success?

    DataManager.save_data(DataManager::POSTS_FILE, posts)
    post
  end
end
