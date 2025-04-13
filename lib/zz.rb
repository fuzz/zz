# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require_relative 'zz/version'
require_relative 'zz/config'
require_relative 'zz/note'
require_relative 'zz/cli'

module Zz
  class Error < StandardError; end

  # Common utility methods for Zz
  module Utils
    extend T::Sig

    # Creates a directory and its parent directories if they don't exist
    sig { params(dir: String).void }
    def self.ensure_directory_exists(dir)
      FileUtils.mkdir_p(dir)
    end
  end
end
