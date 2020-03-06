require 'securerandom'
require 'json'
require 'erb'
require 'yaml'
require 'front_matter_parser'
require 'kramdown'
require 'kramdown-parser-gfm'

class Block
  def initialize(content)
    @content = content
  end

  def raw
    @content
  end

  def to_html
    ERB.new(template, nil, '-').result(OpenStruct.new(attributes).instance_eval { binding }).chomp
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
    attrs = JSON.parse(@content.scan(/\[block\:[a-z\-]+\](.*?)\[\/block\]/mix).last.first)
    attrs['permalink'] ||= parameterize(attrs['title'] || '')
    attrs
  end

  def template
    File.read(File.join(File.dirname(__FILE__), 'templates', "#{type}.erb")).chomp
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
  attr_reader :front_matter

  def initialize(file)
    @file = FrontMatterParser::Parser.parse_file(file)
    @front_matter = @file.front_matter
    @front_matter['path'] = File.dirname(file)
    @content = @file.content
  end

  def to_html
    output = @content

    blocks.each do |block|
      output.sub!(block.raw, block.to_html)
    end

    # Fix headers that are missing a space between the # and the first character
    output.gsub!(/^(#+)([^#\ ])/, '\1 \2')
    # Fix list items that don't have a space between the hyphen and the first character
    output.gsub!(/^\-([^\-\ ])/, '- \1')

    # [
    #   frontmatter_output,
    #   Kramdown::Document.new(output, input: 'GFM').to_html
    # ].join("\n")

    Kramdown::Document.new(output, input: 'GFM').to_html
  end

  def updated_frontmatter
    {
      id: nil,
      locale: 'en',
      distribution_list_id: nil,
      security_role_id: nil,
      parent_id: nil,
      visit_count: 0
    }.merge(front_matter).compact.map { |key, v| [key.to_s, v] }.to_h
  end

  def frontmatter_output
    "#{YAML.dump(updated_frontmatter)}---"
  end

  def blocks
    BlockParser.new(@content).call
  end
end
