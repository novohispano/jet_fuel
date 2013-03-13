require 'spec_helper'

describe "User" do
  context "when given all the correct parameters" do
    it "creates a new user" do
      User.create(email: "tester@test.com", password_hash: "AAAAAAA", password_salt: "BBBB")
      user = User.find_by_email("tester@test.com")
      expect(user.email).to eq "tester@test.com"
    end

    it "doesn't create a new user when user already exists" do
      2.times { User.create(email: "tester@test.com", password_hash: "AAAAAAA", password_salt: "BBBB") }
      users = User.where(email: "tester@test.com")
      expect(users.count).to eq 1
    end
  end

  context "when not given all parameters" do
    it "doesn't create a new user when password_hash is not present" do
      expect(User.create(email: "tester@test.com", password_salt: "BBBB").valid?).to eq false
    end

    it "doesn't create a new user when email is not present" do
      expect(User.create(password_hash: "AAAAAAAA", password_salt: "BBBB").valid?).to eq false
    end

    it "doesn't create a new user when password_salt is not present" do
      expect(User.create(email: "tester@test.com", password_hash: "AAAAAAAA").valid?).to eq false
    end

    it "doesn't create a new user none of the parameters is given" do
      expect(User.create().valid?).to eq false
    end
  end
end