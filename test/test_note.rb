# frozen_string_literal: true
# typed: false

require 'test_helper'

class TestNote < Minitest::Test
  include TestHelpers

  def setup
    setup_test_environment
    @config = Zz::Config.new
  end

  def teardown
    teardown_test_environment
  end

  def test_save_creates_file_with_correct_path
    content = 'Hello world this is a test'
    note = Zz::Note.new(content, @config)
    assert note.save

    # Filepath should include the first word as directory and words 2-5 in filename
    assert_match(%r{hello/world_this_is_a_.*\.md$}, note.filepath)

    # File should exist and contain the content
    assert File.exist?(note.filepath)
    assert_equal content, File.read(note.filepath)
  end

  def test_handles_less_than_five_words
    content = 'Hello world'
    note = Zz::Note.new(content, @config)
    assert note.save

    assert_match(%r{hello/world_.*\.md$}, note.filepath)
    assert File.exist?(note.filepath)
  end

  def test_handles_empty_content
    content = ''
    note = Zz::Note.new(content, @config)
    assert note.save

    assert_match(%r{blank/blank_.*\.md$}, note.filepath)
    assert File.exist?(note.filepath)
  end

  def test_strips_yaml_frontmatter
    content = "---\ntitle: Test\n---\nHello world this is a test"
    note = Zz::Note.new(content, @config)
    assert note.save

    assert_match(%r{hello/world_this_is_a_.*\.md$}, note.filepath)
    assert File.exist?(note.filepath)
  end

  def test_handles_filename_conflict
    # Ensure clean test environment
    FileUtils.rm_rf(File.join(@test_dir, 'hello'))
    FileUtils.mkdir_p(File.join(@test_dir, 'hello'))

    # Save original method
    original_now_method = Time.method(:now)

    begin
      # Create a fixed timestamp for testing
      fixed_time = Time.new(2025, 4, 13, 0, 1, 34)

      # Mock Time.now to return the fixed timestamp
      Time.define_singleton_method(:now) do
        fixed_time
      end

      # Create a note
      content = 'Hello world this is a test'
      note1 = Zz::Note.new(content, @config)
      assert note1.save

      # Create another note with the same content (should get different filename)
      note2 = Zz::Note.new(content, @config)
      assert note2.save

      # Check the actual filepaths
      assert_match(%r{hello/world_this_is_a_2025-04-13-00-01-34\.md$}, note1.filepath)
      assert_match(%r{hello/world_this_is_a_1_2025-04-13-00-01-34\.md$}, note2.filepath)
      assert File.exist?(note1.filepath)
      assert File.exist?(note2.filepath)
    ensure
      # Properly restore Time.now
      Time.singleton_class.send(:remove_method, :now) if Time.singleton_methods.include?(:now)
      Time.define_singleton_method(:now, original_now_method)
    end
  end

  def test_normalizes_path_components
    content = 'UPPER-case! With@special#chars and spaces'
    note = Zz::Note.new(content, @config)
    assert note.save

    assert_match(%r{uppercase/withspecialchars_and_spaces_.*\.md$}, note.filepath)
    assert File.exist?(note.filepath)
  end
end
