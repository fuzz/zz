# frozen_string_literal: true
# typed: strict

require 'sorbet-runtime'
require 'fileutils'
require 'time'

module Zz
  # Handles creation and storage of notes
  class Note
    extend T::Sig

    sig { returns(String) }
    attr_reader :content, :filepath

    sig { params(content: String, config: Zz::Config).void }
    def initialize(content, config)
      # Add trailing newline if not present for command line input
      @content = T.let(content.end_with?("\n") ? content : "#{content}\n", String)
      @config = T.let(config, Zz::Config)
      @filepath = T.let(generate_filepath, String)
    end

    sig { returns(T::Boolean) }
    def save
      Zz::Utils.ensure_directory_exists(File.dirname(@filepath))
      File.write(@filepath, @content)
      true
    rescue StandardError => e
      warn "Error saving note: #{e.message}"
      false
    end

    private

    sig { returns(String) }
    def generate_filepath
      text = strip_frontmatter(@content)
      words = text.strip.split(/\s+/)

      dir_name = extract_directory_name(words)
      file_base = extract_file_base(words)
      timestamp = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
      base_path = File.join(@config.zz_dir, dir_name)

      create_unique_filepath(base_path, file_base, timestamp)
    end

    sig { params(words: T::Array[String]).returns(String) }
    def extract_directory_name(words)
      words.empty? ? 'blank' : normalize_path_component(T.must(words[0]))
    end

    sig { params(words: T::Array[String]).returns(String) }
    def extract_file_base(words)
      file_words = words[1..4]&.compact || []
      if file_words.empty?
        'blank'
      else
        file_words.map { |w| normalize_path_component(w) }.join('_')
      end
    end

    sig { params(base_path: String, file_base: String, timestamp: String).returns(String) }
    def create_unique_filepath(base_path, file_base, timestamp)
      file_path = File.join(base_path, "#{file_base}_#{timestamp}.md")

      counter = 1
      while File.exist?(file_path)
        file_path = File.join(base_path, "#{file_base}_#{counter}_#{timestamp}.md")
        counter += 1
      end

      file_path
    end

    sig { params(text: String).returns(String) }
    def strip_frontmatter(text)
      if text.start_with?("---\n")
        # Ignore everything between the first and second "---"
        parts = text.split("---\n", 3)
        return parts[2] || '' if parts.size >= 3
      end
      text
    end

    sig { params(component: String).returns(String) }
    def normalize_path_component(component)
      # Convert to lowercase, remove non-alphanumeric chars, replace spaces with underscore
      normalized = component.downcase.gsub(/[^a-z0-9\s]/, '').gsub(/\s+/, '_')
      # Truncate to avoid filesystem issues
      T.must(normalized[0..63])
    end
  end
end
