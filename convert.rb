require 'kramdown'
require 'fileutils'
require 'securerandom'
require 'json'
require 'erb'
require 'front_matter_parser'
require 'kramdown-parser-gfm'

class Block
  attr_reader :id

  TEMPLATE = <<~DOC.chomp
  <p><%= title %></p>
  DOC

  def initialize(content)
    @id = SecureRandom.hex(10)
    @content = content
  end

  def raw
    @content
  end

  def to_html
    ERB.new(TEMPLATE).result(OpenStruct.new(attributes).instance_eval { binding })
  end

  def type
    @type ||= extract_type
  end

  def attributes
    @attributes ||= extract_attributes
  end

  private

  def extract_type
    @content.scan(/\[block:([\w\-]+)\]/).last.first
  end

  def extract_attributes
    JSON.parse(@content.scan(/\[block\:[a-z\-]+\]([^\[]*)\[\/block\]/).last.first)
  end
end

class BlockParser
  BLOCK_REGEX = /(\[block\:[a-z\-]+\][^\[]*\[\/block\])/mix.freeze

  def initialize(content)
    @content = content
  end

  def call
    @content.scan(BLOCK_REGEX).collect do |cont|
      Block.new(cont.first)
    end
  end
end

class ReadmeFile
  def initialize(file)
    @file = FrontMatterParser::Parser.parse_file(file)
    @meta = @file.front_matter
    @content = @file.content
  end

  def to_html
    output = @content.gsub(/#([^#\ ])/, '# \1')

    blocks.each do |block|
      output.sub!(block.raw, block.to_html)
    end

    Kramdown::Document.new(output, input: 'GFM').to_html
  end

  def blocks
    BlockParser.new(@content).call
  end
end

def run
  Dir.glob("**/*.md") do |my_text_file|
    export_file_path = File.join("exports", my_text_file.sub('.md', '.html'))

    dirname = File.dirname(export_file_path)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    File.open(export_file_path, "w") do |io|
      io.write Kramdown::Document.new('').to_html
    end
  end
end

# run
