require 'rails_helper'

RSpec.describe User, type: :model do
  describe "create_nanny_or_family" do
    let(:user) {
      User.new(name: "Bob",
        email: "user#{rand(100000)}@mydomain.com",
        password: "password",
        password_confirmation: "password"
        ) }

    it "create a Nanny record when default type is nanny" do
      user.default_type = "nanny"
      expect {
        user.save!
      }.to change(Nanny, :count).by(1)
    end

    xit "create a Family record when default type is family" do
      user.default_type = "family"
      expect {
        user.save!
      }.to change(Family, :count).by(1)
    end

    it "raise error when the default type is invalid string" do
      user.default_type = "invalid"
      expect {
        user.create_nanny_or_family
      }.to raise_error(StandardError)
    end

  end
end
