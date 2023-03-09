#!/usr/bin/env crystal

p Time.utc
before = Time.utc
require "../src/code/parser"

input = ARGV.join(" ")
input = File.read(input) if File.exists?(input)
pp Code::Parser.parse(input)
after = Time.utc

puts after - before
