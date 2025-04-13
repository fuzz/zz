# frozen_string_literal: true
# typed: false

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'zz'

require 'minitest/autorun'
require 'fileutils'

module TestHelpers
  def setup_test_environment
    # Create a temporary directory for tests
    @test_dir = File.expand_path('../tmp/test_zz_dir', __dir__)
    FileUtils.rm_rf(@test_dir) if Dir.exist?(@test_dir)
    FileUtils.mkdir_p(@test_dir)

    # Set environment variable for tests
    @original_zz_dir = ENV.fetch('ZZ_DIR', nil)
    ENV['ZZ_DIR'] = @test_dir
  end

  def teardown_test_environment
    # Clean up test directory
    FileUtils.rm_rf(@test_dir) if Dir.exist?(@test_dir)

    # Restore environment variable
    if @original_zz_dir
      ENV['ZZ_DIR'] = @original_zz_dir
    else
      ENV.delete('ZZ_DIR')
    end
  end
end
