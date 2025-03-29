require 'rspec'
require_relative '../free_slots'

RSpec.describe "calculate_free_slot" do
  let(:date) { Date.new(2022, 8, 1) }
  let(:work_start) { Time.new(date.year, date.month, date.day, WORK_START_TIME, 0, 0) }
  let(:work_end)   { Time.new(date.year, date.month, date.day, WORK_END_TIME, 0, 0) }

  context "general constraints" do
    it "does not return any slot starting before 09:00" do
      busy_slots = []
      free_slots = calculate_free_slots(date, busy_slots)
      free_slots.each do |slot|
        expect(slot[:start]).to be >= work_start
      end
    end

    it "does not return any slot ending after 18:00" do
      busy_slots = []
      free_slots = calculate_free_slots(date, busy_slots)
      free_slots.each do |slot|
        expect(slot[:end]).to be <= work_end
      end
    end

    it "returns slots that are exactly one hour long" do
      busy_slots = []
      free_slots = calculate_free_slots(date, busy_slots)
      free_slots.each do |slot|
        expect(slot[:end] - slot[:start]).to eq(3600)
      end
    end
  end

  context "with busy slots" do
    it "ensures free slots do not overlap busy periods" do
      busy_slots = [
        { start: Time.new(date.year, date.month, date.day, 9, 0, 0),
          end:   Time.new(date.year, date.month, date.day, 11, 0, 0) }
      ]
      free_slots = calculate_free_slots(date, busy_slots)
      free_slots.each do |slot|
        expect(slot[:start]).to be >= Time.new(date.year, date.month, date.day, 11, 0, 0)
      end
    end
  end

  context "when the entire workday is busy" do
    it "returns an empty array" do
      busy_slots = [
        { start: Time.new(date.year, date.month, date.day, 9, 0, 0),
          end:   Time.new(date.year, date.month, date.day, 18, 0, 0) }
      ]
      free_slots = calculate_free_slots(date, busy_slots)
      expect(free_slots).to be_empty
    end
  end
end
