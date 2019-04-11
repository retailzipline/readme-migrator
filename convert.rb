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
    ERB.new(template).result(OpenStruct.new(attributes).instance_eval { binding })
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
    attrs = JSON.parse(@content.scan(/\[block\:[a-z\-]+\]([^\[]*)\[\/block\]/).last.first)
    attrs['permalink'] ||= parameterize(attrs['title'] || '')
    attrs
  end

  def template
    File.read(File.join(File.dirname(__FILE__), 'src', 'templates', "#{type}.erb")).chomp
  end

  def parameterize(string, sep = '-')
    # replace accented chars with their ascii equivalents
    parameterized_string = string.dup
    # Turn unwanted chars into the separator
    parameterized_string.gsub!(/[^a-z0-9\-_]+/i, sep)
    unless sep.nil? || sep.empty?
      re_sep = Regexp.escape(sep)
      # No more than one of the separator in a row.
      parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
      # Remove leading/trailing separator.
      parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/, '')
    end
    parameterized_string.downcase
  end
end

class BlockParser
  BLOCK_REGEX = /(\[block\:[a-z\-]+\].*?\[\/block\])/mix.freeze

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
    output = @content
      .gsub(/#([^#\ ])/, '# \1')
      .gsub(/^\-([^\-\ ])/, '- \1')

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
