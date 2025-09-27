#!/usr/bin/env ruby
# Usage: ruby scripts/brand_replace.rb
# This script does a focused, non-destructive replacement of user-facing
# occurrences of "Chatwoot" -> "CHATCE" and related domain examples within
# the frontend code (app/javascript). It avoids touching license/legal files
# and server-side ruby files.

require 'fileutils'

ROOT = File.expand_path('..', __dir__)
TARGET_DIRS = [
  'app/javascript/widget',
  'app/javascript/dashboard',
  'app/javascript/survey',
  'app/javascript/shared',
  'app/javascript/sdk'
]

# patterns: array of [regex, replacement]
PATTERNS = [
  [/\bChatwoot\b/, 'CHATCE'],
  [/chatwoot\.help/, 'chatce.help'],
  [/app\.chatwoot\.com/, 'app.chatce.com'],
  [/https?:\/\/www\.chatwoot\.com/, 'https://final.renace.tech'],
  [/https?:\/\/chatwoot\.com/, 'https://final.renace.tech']
]

files_changed = []

TARGET_DIRS.each do |dir|
  path = File.join(ROOT, dir)
  next unless Dir.exist?(path)

  Dir.glob(File.join(path, '**', '*.*')).each do |file|
    next unless File.file?(file)
    # limit to text files we expect (json, js, vue, spec.js, story.vue)
    next unless file =~ /\.(json|js|vue|jsx|ts|tsx)$/

    content = File.read(file)
    new_content = content.dup

    PATTERNS.each do |pat, repl|
      new_content.gsub!(pat, repl)
    end

    if new_content != content
      File.write(file, new_content)
      files_changed << file
    end
  end
end

puts "Files updated: #{files_changed.length}"
files_changed.each { |f| puts f }
