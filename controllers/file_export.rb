require 'zip'
require 'fileutils'

class Exporter
  def self.export_posts
    posts = DataManager.all_posts
    export_dir = "exports"
    FileUtils.mkdir_p(export_dir)

    posts.each do |post|
      content = "# #{post["title"]}\n\n" +
            "Author: #{post["author"]}\n" +
            "Date: #{post["date"]}\n\n" +
            "## Content\n" +
            "#{post["content"]}\n"
      File.write("#{export_dir}/#{post["id"]}.md", content)
    end

    zip_filename = "posts_export.zip"
    Zip::File.open(zip_filename, Zip::File::CREATE) do |zipfile|
      Dir["#{export_dir}/*"].each do |file|
        zipfile.add(File.basename(file), file)
      end
    end

    FileUtils.rm_rf(export_dir)
    zip_filename
  end
end
