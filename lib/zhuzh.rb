# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require_relative 'zhuzh/version'
require_relative 'zhuzh/config'
require_relative 'zhuzh/note'
require_relative 'zhuzh/cli'

module Zhuzh
  class Error < StandardError; end

  # Common utility methods for Zhuhz
  module Utils
    extend T::Sig

    # Creates a directory and its parent directories if they don't exist
    sig { params(dir: String).void }
    def self.ensure_directory_exists(dir)
      FileUtils.mkdir_p(dir)
    end
  end
end
