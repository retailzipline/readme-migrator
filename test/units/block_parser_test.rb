require 'minitest/autorun'
require_relative '../../convert.rb'

class BlockParserTest < Minitest::Test
  def test_should_extract_multiple_blocks_from_content
    blocks = BlockParser.new(load_markdown_fixture('multiple_blocks.md')).call

    assert_equal 2, blocks.length
    blocks.each do |block|
      assert block.is_a?(Block)
    end
  end

  private

  def load_markdown_fixture(name)
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', 'markdown', name))
  end
end
