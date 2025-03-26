require 'json'
require 'securerandom'

class DataManager
  POSTS_FILE = 'data/posts.json'
  COMMENTS_FILE = 'data/comments.json'
  VISITS_FILE = 'data/visits.json'

  # When defining class methods, self. is used in the method name.
  # File is from a built in ruby module, provides mtds for handling and interacting with files.
  def self.load_data(file)
    File.exist?(file) ? JSON.parse(File.read(file)) : []
  end

  # JSON is from the json gem. pretty_generate: It generates a nicely formatted and indented JSON string
  def self.save_data(file, data)
    File.write(file, JSON.pretty_generate(data))
  end

  def self.all_posts
    load_data(POSTS_FILE)
  end

  def self.all_comments
    load_data(COMMENTS_FILE)
  end

  def self.all_visits
    load_data(VISITS_FILE)
  end
end
