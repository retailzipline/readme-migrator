#!/usr/bin/env ruby

require 'fileutils'
require_relative './src/readme-migrator'

Dir.glob("casper/v1.0/**/*.md") do |my_text_file|
  export_file_path = File.join("exports", my_text_file.sub('casper/v1.0/', '').sub('.md', '.html'))

  dirname = File.dirname(export_file_path)
  unless File.directory?(dirname)
    FileUtils.mkdir_p(dirname)
  end

  File.open(export_file_path, "w") do |io|
    puts my_text_file
    io.write ReadmeFile.new(my_text_file).to_html
  end
end

# run
