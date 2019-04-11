require 'minitest/autorun'
require_relative '../../src/readme-migrator'

class BlockTest < Minitest::Test
  def test_should_extract_the_correct_type
    block = Block.new(load_block_fixture('embed.md'))
    assert_equal 'embed', block.type
  end

  def test_should_return_the_raw_content
    content = load_block_fixture('embed.md')
    block = Block.new(content)

    assert_equal content, block.raw
  end

  def test_should_have_an_id
    content = load_block_fixture('embed.md')
    block = Block.new(content)

    assert block.id
  end

  %w[
    api-header
    callout
    embed
    html
    image
    parameters
  ].each do |type|
    define_method("test_should_parse_#{type}_block") do
      expectation = load_block_fixture("#{type}.html").chomp
      block = Block.new(load_block_fixture("#{type}.md"))

      assert_equal expectation, block.to_html
    end
  end

  private

  def load_block_fixture(name)
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'blocks', name))
  end
end
