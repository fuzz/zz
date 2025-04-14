# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require 'fileutils'

module Zhuzh
  # Manages configuration and directory settings
  class Config
    extend T::Sig

    sig { returns(String) }
    attr_reader :zz_dir

    sig { void }
    def initialize
      @zz_dir = T.let(determine_zz_dir, String)
      Zhuzh::Utils.ensure_directory_exists(@zz_dir)
    end

    private

    sig { returns(String) }
    def determine_zz_dir
      ENV['ZZ_DIR'] || File.join(Dir.home, 'Zarchive')
    end
  end
end
