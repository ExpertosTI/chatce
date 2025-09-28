#!/usr/bin/env ruby
# Usage: ruby scripts/brand_replace.rb
# This script does a focused, non-destructive replacement of user-facing
# occurrences of "Chatwoot" -> "CHATCE" and related domain examples within
# the frontend code (app/javascript). It avoids touching license/legal files
# and server-side ruby files.

require 'fileutils'

require 'optparse'

ROOT = File.expand_path('..', __dir__)
FRONTEND_TARGET_DIRS = [
  'app/javascript/widget',
  'app/javascript/dashboard',
  'app/javascript/survey',
  'app/javascript/shared',
  'app/javascript/sdk'
]

SERVER_TARGET_DIRS = [
  'app',
  'enterprise'
]

# patterns: array of [regex, replacement]
PATTERNS = [
  # Focus on user-facing occurrences (capitalized) by default. Be conservative with
  # replacements to avoid touching internal variable names or identifiers.
  [/\bChatwoot\b/, 'CHATCE'],
  [/chatwoot\.help/, 'chatce.help'],
  [/app\.chatwoot\.com/, 'app.chatce.com'],
  [/https?:\/\/www\.chatwoot\.com/, 'https://final.renace.tech'],
  [/https?:\/\/chatwoot\.com/, 'https://final.renace.tech']
]

options = {
  dry_run: false,
  include_server: false,
  apply: false,
  apply_server: false,
  show_snippets: false,
  limit: nil
}

OptionParser.new do |opts|
  opts.banner = "Usage: ruby scripts/brand_replace.rb [--dry-run] [--include-server] [--apply] [--apply-server] [--show-snippets] [--limit N]"
  opts.on('--dry-run', 'Do not write files; only list files that would be changed') do
    options[:dry_run] = true
  end

  opts.on('--include-server', 'Include server-side paths (app/ and enterprise/) in the search (no write unless --apply-server)') do
    options[:include_server] = true
  end

  opts.on('--apply', 'Actually write changes for frontend targets (must be explicit)') do
    options[:apply] = true
  end

  opts.on('--apply-server', 'Actually write changes for server targets (dangerous; requires explicit consent)') do
    options[:apply_server] = true
  end

  opts.on('--show-snippets', 'Show one matching snippet (with line number) per file in the preview') do
    options[:show_snippets] = true
  end

  opts.on('--limit N', Integer, 'Limit number of files displayed in the preview') do |n|
    options[:limit] = n
  end
end.parse!

files_changed = []

targets = FRONTEND_TARGET_DIRS.dup
if options[:include_server]
  targets.concat(SERVER_TARGET_DIRS)
end

targets.each do |dir|
  path = File.join(ROOT, dir)
  next unless Dir.exist?(path)

  Dir.glob(File.join(path, '**', '*.*')).each do |file|
    next unless File.file?(file)
    next unless file =~ /\.(json|js|vue|jsx|ts|tsx|erb|yml|yaml|liquid|md)$/

    content = File.read(file)
    new_content = content.dup

    PATTERNS.each do |pat, repl|
      new_content.gsub!(pat, repl)
    end

    if new_content != content
      files_changed << file

      # show a small snippet if requested
      if options[:show_snippets]
        puts "---\nFile: #{file}"
        line = content.split("\n").find_index { |l| PATTERNS.any? { |pat, _| l =~ pat } }
        if line
          start_line = [0, line - 2].max
          snippet = content.split("\n")[start_line, 5].map.with_index(start_line) { |l, i| sprintf("%4d: %s", i + 1, l) }.join("\n")
          puts snippet
        end
      end

      # decide whether to write changes
      should_write = false
      if !options[:dry_run]
        if FRONTEND_TARGET_DIRS.any? { |d| file.start_with?(File.join(ROOT, d)) }
          should_write = options[:apply]
        elsif SERVER_TARGET_DIRS.any? { |d| file.start_with?(File.join(ROOT, d)) }
          should_write = options[:apply_server]
        end
      end

      if should_write
        File.write(file, new_content)
      end
    end
  end
end

if options[:dry_run]
  puts "Dry run - files that would be updated: #{files_changed.length}"
else
  puts "Files matched: #{files_changed.length}"
end

limit = options[:limit]
files_changed = files_changed.first(limit) if limit
files_changed.each { |f| puts f }
