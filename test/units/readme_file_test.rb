require 'minitest/autorun'
require_relative '../../src/readme-migrator'

class ReadmeFileTest < Minitest::Test
  def test_should_convert_a_readme_file_to_html
    expectation = load_readme_fixture('basic.html')
    readme = ReadmeFile.new(readme_fixture_path('basic.md'))

    assert_equal expectation, readme.to_html
  end

  private

  def readme_fixture_path(name)
    File.join(File.dirname(__FILE__), '..', 'fixtures', 'readme', name)
  end

  def load_readme_fixture(name)
    File.read(readme_fixture_path(name))
  end
end
