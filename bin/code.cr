#!/usr/bin/env crystal

require "../src/code/parser"

input = ARGV.join(" ")
input = File.read(input) if File.exists?(input)
pp Code::Parser.parse(input)
