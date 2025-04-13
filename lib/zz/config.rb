# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require 'fileutils'

module Zz
  # Manages configuration and directory settings
  class Config
    extend T::Sig

    sig { returns(String) }
    attr_reader :zz_dir

    sig { void }
    def initialize
      @zz_dir = T.let(determine_zz_dir, String)
      ensure_directory_exists(@zz_dir)
    end

    private

    sig { returns(String) }
    def determine_zz_dir
      ENV['ZZ_DIR'] || File.join(ENV['HOME'] || '~', 'Zarchive')
    end

    sig { params(dir: String).void }
    def ensure_directory_exists(dir)
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
    end
  end
end
