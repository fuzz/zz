# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require_relative 'zz/version'
require_relative 'zz/config'
require_relative 'zz/note'
require_relative 'zz/cli'

module Zz
  class Error < StandardError; end
end
