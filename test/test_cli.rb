# frozen_string_literal: true
# typed: false

require 'test_helper'
require 'stringio'
require 'tempfile'
require 'open3'

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
    cli.send(:process_content, 'Hello world this is a test')

    output = $stdout.string

    assert_match(%r{/}, output, 'Output should be just a path')

    # Extract file path from output
    file_path = output.strip

    assert_path_exists file_path, "File should exist at path: #{file_path}"
    assert_equal "Hello world this is a test\n", File.read(file_path), 'File content should match with added newline'
  end

  # Test bin/zz with command-line argument
  def test_binary_with_command_line_argument
    test_content = 'Test note from command line'
    output, status = Open3.capture2("#{File.dirname(__FILE__)}/../bin/zz", test_content)

    assert_equal 0, status.exitstatus, 'Command should exit successfully'
    file_path = output.strip

    assert_path_exists file_path, "File should exist at path: #{file_path}"
    assert_equal "#{test_content}\n", File.read(file_path), 'File content should match with added newline'
  end

  # Test bin/zz with stdin input
  def test_binary_with_stdin_input
    test_content = 'Test note from stdin'

    # Create a temp file to simulate stdin
    temp_file = Tempfile.new('stdin_test')
    temp_file.write(test_content)
    temp_file.close

    # Use shell redirection to pipe content to zz
    cmd = "cat #{temp_file.path} | #{File.dirname(__FILE__)}/../bin/zz"
    output, status = Open3.capture2(cmd)

    assert_equal 0, status.exitstatus, 'Command should exit successfully'
    file_path = output.strip

    assert_path_exists file_path, "File should exist at path: #{file_path}"
    assert_equal "#{test_content}\n", File.read(file_path), 'File content should match input with added newline'

    temp_file.unlink
  end
end
