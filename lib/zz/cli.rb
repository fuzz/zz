# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'

module Zz
  # Command line interface for Zz
  class CLI
    extend T::Sig

    sig { params(args: T::Array[String]).returns(Integer) }
    def self.start(args)
      new.run(args)
    end

    sig { params(args: T::Array[String]).returns(Integer) }
    def run(args)
      content = if args.empty?
                  if !$stdin.tty?
                    # Text piped from stdin
                    $stdin.read
                  else
                    # No text, open editor
                    open_editor
                  end
                else
                  # Combine all arguments as note text
                  args.join(" ")
                end
      
      process_content(content) ? 0 : 1
    end

    private

    sig { params(content: T.nilable(String)).returns(T::Boolean) }
    def process_content(content)
      return false if content.nil? || content.strip.empty?

      config = Config.new
      note = Note.new(content, config)
      
      if note.save
        puts note.filepath
        true
      else
        false
      end
    end

    sig { returns(T.nilable(String)) }
    def open_editor
      editor = ENV["EDITOR"] || "vim"
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