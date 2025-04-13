# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require 'thor'

module Zz
  # Command line interface for Zz
  class CLI < Thor
    extend T::Sig

    # Fix for Thor deprecation warning
    def self.exit_on_failure?
      true
    end

    desc 'create TEXT', 'Create a new note with the given text'
    sig { params(text: T.nilable(String)).returns(T.untyped) }
    def create(text = nil)
      if text
        # Text provided as argument
        process_content(text)
      elsif !$stdin.tty?
        # Text piped from stdin
        process_content($stdin.read)
      else
        # No text, open editor
        content = open_editor
        process_content(content) if content
      end
    end

    default_task :create

    private

    sig { params(content: String).returns(T.untyped) }
    def process_content(content)
      return if content.nil? || content.strip.empty?

      config = Config.new
      note = Note.new(content, config)

      if note.save
        puts "Note saved to: #{note.filepath}"
      else
        exit 1
      end
    end

    sig { returns(T.nilable(String)) }
    def open_editor
      editor = ENV['EDITOR'] || 'vim'
      temp_file = "/tmp/zz_#{Time.now.to_i}.md"

      # Open editor and wait for it to close
      system("#{editor} #{temp_file}")

      if File.exist?(temp_file)
        content = File.read(temp_file)
        File.unlink(temp_file)
        return content
      end

      nil
    end
  end
end
