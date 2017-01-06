require 'rails_helper'

RSpec.describe Slot, type: :model do
  describe "validations" do
    context "start_time" do
      it "cannot be less than Time.now (ie - in the past)" do
        slot = Slot.new(start_time: Time.now - 3.days, end_time: Time.now - 1.days )
        expect(slot.valid?).to eq(false)
        expect(slot.errors[:start_time].empty?).to eq(false)
      end

      it "should be greater than Time.now + START BUFFER" do
        start = Time.now + Slot::START_BUFFER - 5.minutes
        endt = Time.now + 1.days
        slot = Slot.new(start_time: start , end_time: endt)

        expect(slot.valid?).to eq(false)
        expect(slot.errors[:start_time].empty?).to eq(false)
      end
    end

    context "end_time" do
      it "should be greater than start time" do
        start = Time.now + Slot::START_BUFFER + 5.minutes
        endt = start - 3.minutes
        slot = Slot.new(start_time: start , end_time: endt)

        expect(slot.valid?).to eq(false)
        expect(slot.errors[:end_time].empty?).to eq(false)
      end
    end
  end

  describe "can_change_start_time?" do
    it "true when family id is not set" do
      slot = Slot.new
      expect(slot.can_change_start_time?).to eq(true)
    end

    it "false when family id is set" do
      slot = Slot.new(family_id: 43)
      expect(slot.can_change_start_time?).to eq(false)
    end
  end
end
