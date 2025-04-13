# frozen_string_literal: true
# typed: false

require 'test_helper'
require 'tmpdir'

class TestConfig < Minitest::Test
  include TestHelpers

  def setup
    setup_test_environment
  end

  def teardown
    teardown_test_environment
  end

  def test_uses_zz_dir_from_env
    config = Zz::Config.new

    assert_equal @test_dir, config.zz_dir
  end

  def test_creates_directory_if_not_exists
    # Delete the directory to test creation
    FileUtils.rm_rf(@test_dir)

    refute Dir.exist?(@test_dir)

    # Creating config should create the directory
    Zz::Config.new

    assert Dir.exist?(@test_dir)
  end

  def test_mkdir_p_idempotence
    test_dir = File.join(Dir.tmpdir, "zz_test_#{Time.now.to_i}")

    # First create the directory
    Zz::Utils.ensure_directory_exists(test_dir)

    assert Dir.exist?(test_dir), 'Directory should exist after first mkdir_p'

    # Then try to create it again - should not raise an error
    assert_silent do
      Zz::Utils.ensure_directory_exists(test_dir)
    end

    # Cleanup
    FileUtils.rm_rf(test_dir)
  end
end
