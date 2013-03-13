require 'spec_helper'

describe "Url" do
  context "when given all the correct parameters" do
    it "creates a new URL" do
      Url.create(original: "http://test.com", shortened: "AAAAAAA")
      url = Url.find_by_original("http://test.com")
      expect(url.original).to eq "http://test.com"
    end

    it "doesn't create a new URL when URL already exists" do
      2.times { Url.create(original: "http://test.com", shortened: "AAAAAAA") }
      urls = Url.where(original: "http://test.com")
      expect(urls.count).to eq 1
    end
  end

  context "when not given all parameters" do
    it "doesn't create a new URL when shortened url is not present" do
      expect(Url.create(original: "http://test.com").valid?).to eq false
    end

    it "doesn't create a new URL when url is not present" do
      expect(Url.create(shortened: "AAAAAAAA").valid?).to eq false
    end

    it "doesn't create a new URL none of the parameters is given" do
      expect(Url.create().valid?).to eq false
    end
  end
end