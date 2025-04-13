# frozen_string_literal: true
# typed: false

require 'test_helper'
require 'stringio'

class TestCLI < Minitest::Test
  include TestHelpers

  def setup
    setup_test_environment
    @original_stdin = $stdin
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  def teardown
    teardown_test_environment
    $stdin = @original_stdin
    $stdout = @original_stdout
  end

  def test_cli_with_text_argument
    cli = Zz::CLI.new
    cli.default('Hello', 'world', 'this', 'is', 'a', 'test')

    output = $stdout.string
    assert_match(/Note saved to:/, output)

    # Extract file path from output
    file_path = output.split('Note saved to: ').last.strip
    assert File.exist?(file_path)
    assert_equal 'Hello world this is a test', File.read(file_path)
  end
end
