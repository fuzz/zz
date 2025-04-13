# frozen_string_literal: true
# typed: false

require 'test_helper'

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

  def test_uses_home_directory_when_zz_dir_not_set
    # Remove ZZ_DIR from environment
    ENV.delete('ZZ_DIR')

    config = Zz::Config.new
    expected_dir = File.join(ENV['HOME'] || '~', 'Zarchive')
    assert_equal expected_dir, config.zz_dir

    # Clean up any created directory
    FileUtils.rm_rf(expected_dir) if Dir.exist?(expected_dir) && expected_dir.include?('Zarchive')
  end
end
