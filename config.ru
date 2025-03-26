# setting up a Rack-compatible server
require 'rack'
require 'json'
require_relative 'controllers/posts'
require_relative 'controllers/comments'
require_relative 'controllers/file_export'

class MyAPI
  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    case request.path
    when '/posts'
      handle_posts(request, response)
    when '/posts/export'
      handle_export(response)
    when %r{/posts/([^/]+)/comments$}
      handle_comments(request, response, $1) # Capture post ID from URL
    when %r{/posts/([^/]+)/comments/([^/]+)$}
      handle_comment_by_id(request, response, $1, $2) # Capture post_id & comment_id from URL
    when %r{/posts/([^/]+)$}
      handle_post_by_id(request, response, $1) # Capture post ID from URL
    else
      response.status = 404
      response.write({ error: 'Not Found' }.to_json)
    end

    response.finish
  end

  private

  def handle_posts(request, response)
    case request.request_method
    when 'GET'
      posts = Posts.get_posts
      response.write(posts.to_json)
    when 'POST'
      data = JSON.parse(request.body.read)
      post = Posts.create_post(data["title"], data["content"], data["author"], data["tags"])
      response.write(post.to_json)
    else
      response.status = 405
      response.write({ error: 'Method Not Allowed' }.to_json)
    end
  end

  def handle_post_by_id(request, response, post_id)
    case request.request_method
    when 'GET'
      post = Posts.get_posts.find { |p| p["id"] == post_id }
      if post
        response.write(post.to_json)
      else
        response.status = 404
        response.write({ error: 'Post not found' }.to_json)
      end

    when 'PATCH'
      data = JSON.parse(request.body.read)
      updated_post = Posts.update_post(post_id, data)
      if updated_post[:error]
        response.status = 400
        response.write(updated_post.to_json)
      else
        response.write(updated_post.to_json)
      end

    when 'DELETE'
      result = Posts.delete_post(post_id)
      if result[:error]
        response.status = 404
        response.write(result.to_json)
      else
        response.status = 200
        response.write(result.to_json)
      end

    else
      response.status = 405
      response.write({ error: 'Method Not Allowed' }.to_json)
    end
  end

  def handle_comments(request, response, post_id)
    case request.request_method
    when 'GET'
      comments = Comments.get_comments(post_id)
      response.write(comments.to_json)
    when 'POST'
      data = JSON.parse(request.body.read)
      comment = Comments.add_comment(post_id, data["author"], data["content"])
      response.write(comment.to_json)
    else
      response.status = 405
      response.write({ error: 'Method Not Allowed' }.to_json)
    end
  end

  def handle_comment_by_id(request, response, post_id, comment_id)
    case request.request_method
    when 'DELETE'
      result = Comments.delete_comment(post_id, comment_id)
      if result[:error]
        response.status = 404
        response.write(result.to_json)
      else
        response.status = 200
        response.write(result.to_json)
      end
    else
      response.status = 405
      response.write({ error: 'Method Not Allowed' }.to_json)
    end
  end

  def handle_export(response)
    file = Exporter.export_posts
    response.write({ file: file }.to_json)
  end
end

run MyAPI.new
