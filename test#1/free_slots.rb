#!/usr/bin/env ruby
require 'json'
require 'time'
require 'date'

WORK_START_TIME = 9
WORK_END_TIME   = 18
INTERVAL        = 3600

def calculate_free_slots(date, busy_slots)
  free_slots = []
  work_start = Time.new(date.year, date.month, date.day, WORK_START_TIME, 0, 0)
  work_end   = Time.new(date.year, date.month, date.day, WORK_END_TIME, 0, 0)
  current_time = work_start

  busy_slots.each do |slot|
    while (current_time + INTERVAL) <= slot[:start]
      free_slots << { start: current_time, end: current_time + INTERVAL }
      current_time += INTERVAL
    end
    current_time = slot[:end] if slot[:end] > current_time
  end

  while (current_time + INTERVAL) <= work_end
    free_slots << { start: current_time, end: current_time + INTERVAL }
    current_time += INTERVAL
  end

  free_slots
end

if ARGV.empty?
  puts "Usage: #{__FILE__} <filename>"
  exit
elsif ARGV.length > 1
  puts "Too many arguments"
  exit
end

file = ARGV[0]

begin
  json_data = File.read(file)
  data = JSON.parse(json_data)

  busy_slots = data.map do |slot|
    { start: Time.parse(slot["start"]), end: Time.parse(slot["end"]) }
  end

  grouped_slots = busy_slots.group_by { |slot| slot[:start].to_date }
  all_free_slots = []

  grouped_slots.each do |date, slots|
    free_slots = calculate_free_slots(date, slots)
    all_free_slots.concat(free_slots)
  end

  puts JSON.pretty_generate(all_free_slots)
rescue Errno::ENOENT
  puts "File not found"
rescue JSON::ParserError
  puts "Invalid JSON"
end
