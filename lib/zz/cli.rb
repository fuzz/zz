# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require 'thor'

module Zz
  # Command line interface for Zz
  class CLI < Thor
    extend T::Sig

    desc 'default', 'Create a new note (default)'
    sig { params(args: T.untyped).returns(T.untyped) }
    def default(*args)
      content = if !args.empty?
                  # Text provided as argument
                  args.join(' ')
                elsif !$stdin.tty?
                  # Text piped from stdin
                  $stdin.read
                else
                  # No text, open editor
                  open_editor
                end

      return if content.nil? || content.strip.empty?

      config = Config.new
      note = Note.new(content, config)

      if note.save
        puts "Note saved to: #{note.filepath}"
      else
        exit 1
      end
    end

    default_task :default

    private

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
