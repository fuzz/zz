# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'

module Zhuzh
  extend T::Sig

  VERSION = T.let('0.1.0', String)
end
