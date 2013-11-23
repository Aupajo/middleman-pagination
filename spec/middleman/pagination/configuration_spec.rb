require 'spec_helper'

describe Middleman::Pagination::Configuration do
  describe "#pageable" do
    it "accepts a name and a block" do
      config = described_class.new
      expect {
        config.pageable_resource(:key) { }
      }.not_to raise_error
    end
  end

  describe "#each" do
    it "yields each pageable object" do
      config = described_class.new
      block = lambda {}
      config.pageable_resource(:recipes)

      collected = []
      
      config.each do |pageable|
        collected << pageable.name
      end

      expect(collected).to eql([:recipes])
    end
  end
end