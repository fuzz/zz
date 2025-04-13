# frozen_string_literal: true
# typed: false

require 'test_helper'

class TestZz < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Zz::VERSION
  end
end
