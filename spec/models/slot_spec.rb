require 'rails_helper'

RSpec.describe Slot, type: :model do

  let(:user) { User.create!(name: FFaker::Name.name, email: rand(1000).to_s+FFaker::Internet.email, password: "password", password_confirmation:"password", default_type:"nanny") }
  let(:nanny) { user.nanny }

  let(:user_2) { User.create(name: FFaker::Name.name, email: rand(1000).to_s+FFaker::Internet.email, password: "password", password_confirmation:"password", default_type:"family") }
  let(:family) { user_2.family }

  describe "validations" do
    context "start_time" do
      it "cannot be less than Time.now (ie - in the past)" do
        slot = Slot.new(nanny:nanny, start_time: Time.now - 3.days, end_time: Time.now - 1.days )
        expect(slot.valid?).to eq(false)
        expect(slot.errors[:start_time].empty?).to eq(false)
      end

      it "should be greater than Time.now + START BUFFER" do
        start = Time.now + Slot::START_BUFFER - 5.minutes
        endt = Time.now + 1.days
        slot = Slot.new(start_time: start , end_time: endt, nanny: nanny)

        expect(slot.valid?).to eq(false)
        expect(slot.errors[:start_time].empty?).to eq(false)
      end
    end

    context "end_time" do
      it "should be greater than start time" do
        start = Time.now + Slot::START_BUFFER + 5.minutes
        endt = start - 3.minutes
        slot = Slot.new(start_time: start , end_time: endt, nanny: nanny)

        expect(slot.valid?).to eq(false)
        expect(slot.errors[:end_time].empty?).to eq(false)
      end
    end

    context "overlaping slots" do
      let(:slot_1) { Slot.create!(nanny: nanny, start_time: 3.days.from_now, end_time: 6.days.from_now) }

      # Assume that END > START for all tests below.
      # Hence condtion must be checked prior to this test.
      it "END2 > START1" do
        slot_1
        slot_2 = Slot.new(nanny: nanny, start_time: 4.days.from_now, end_time: 10.days.from_now)
        expect(slot_2.valid?).to eq(false)
        expect(slot_2.errors[:start_time]).to eq(["you already have a slot booked in this time period"])
      end

      it "START2 < START1 AND END2 < END1" do
        slot_1
        slot_2 = Slot.new(nanny: nanny, start_time: 4.days.from_now, end_time: 5.days.from_now)
        expect(slot_2.valid?).to eq(false)
        expect(slot_2.errors[:start_time]).to eq(["you already have a slot booked in this time period"])
      end

      it "START2 < END1" do
        slot_1
        slot_2 = Slot.new(nanny: nanny, start_time: 1.days.from_now, end_time: 5.days.from_now)
        expect(slot_2.valid?).to eq(false)
        expect(slot_2.errors[:start_time]).to eq(["you already have a slot booked in this time period"])
      end

      it "be valid when the slots dont overlap" do
        slot_1
        slot_2 = Slot.new(nanny: nanny, start_time: 10.days.from_now, end_time: 15.days.from_now)
        expect(slot_2.valid?).to eq(true)
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

  describe "reserve_for" do
    let(:slot) {Slot.create!(start_time: 3.days.from_now, end_time: 5.days.from_now, nanny: nanny)}

    it "changes the family_id to the family" do
      slot.reserve_for(family)
      slot.reload
      expect(slot.family_id).to eq(family.id)
    end

    it "raise error if the family id is already set" do
      slot.reserve_for(family)
      expect{
        slot.reserve_for(family)
        }.to raise_error(StandardError)
    end
  end
end
