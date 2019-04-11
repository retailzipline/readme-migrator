require 'minitest/autorun'
require_relative '../../convert.rb'

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

  def test_should_return_correct_html_for_the_block
    block = Block.new(load_block_fixture('embed.md'))
    html = "<a href=\"https://google.com\">Meet Google Drive</a>"

    assert_equal html, block.to_html
  end

  private

  def load_block_fixture(name)
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'blocks', name))
  end
end
