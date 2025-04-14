# Zhuzh

A tool for easily creating and managing markdown notes.

## Installation

```bash
gem install zhuzh
```

## Usage

### Basic Usage

Open your editor:
```bash
zz
```

When you save and close the editor, the note will be automatically saved.

### Add a note directly:

```bash
zz "This is my super important note I need to write it quick before I forget"
```

### Pipe/redirect content to zz:

```bash
cat blog_post.txt | zz
```

or

```bash
zz < blog_post.txt
```

### Configuration

By default, notes are stored in `$HOME/Zarchive`. You can change this by setting the `ZZ_DIR` environment variable:

```bash
export ZZ_DIR="$HOME/my_notes"
```

### Note Organization

Notes are organized based on their content:
- The first word becomes the subdirectory name
- Words 2-5 are used in the filename, followed by a timestamp
- For example, if you start a note with "Project ideas for tomorrow", it will be saved as `$ZZ_DIR/project/ideas_for_tomorrow_TIMESTAMP.md`

## Neovim Integration

Add this to your Neovim configuration:

```vim
" Save current buffer with Zhuzh
function! SaveToZhuzh()
  let output = system('zz', join(getline(1, '$'), "\n"))
  echo "Saved to: " . trim(output)
endfunction
command! Zz call SaveToZhuzh()
```

Then you can use `:Zz` to save the current buffer as a Zhuzh note.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
