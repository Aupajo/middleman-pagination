require 'spec_helper'

describe Middleman::Pagination::Configuration do
  describe "#pageable" do
    it "accepts a name and a block" do
      config = described_class.new
      expect {
        config.pageable(:key) { }
      }.not_to raise_error
    end
  end

  describe "#each" do
    it "yields each pageable object" do
      config = described_class.new
      block = lambda {}
      config.pageable(:recipes, &block)

      collected = []
      
      config.each do |pageable|
        collected << [pageable.name, pageable.block]
      end

      expect(collected).to eql([[:recipes, block]])
    end
  end

  context "with instance_eval" do
    it "acts appropriately" do
      config = described_class.new

      config.instance_eval do
        pageable(:recipes) { :ok }
      end

      result = nil
      
      config.each do |pageable|
        result = pageable.block.call
      end

      expect(result).to be(:ok)
    end
  end
end