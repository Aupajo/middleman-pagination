require 'spec_helper'

describe Middleman::Pagination::ExtensionContext do
  describe "#app" do
    it "returns the extension's app" do
      app = double
      extension = double(app: app)
      context = described_class.new(extension)
      expect(context.app).to be(app)
    end
  end

  describe "#configuration" do
    it "returns a configuration object" do
      context = described_class.new(double)
      expect(context.configuration).to be_a(Middleman::Pagination::Configuration)
    end
  end

  describe "#sitemap" do
    it "returns the app's sitemap" do
      app = double(sitemap: :delegated)
      extension = double(app: app)
      context = described_class.new(extension)
      expect(context.sitemap).to be(:delegated)
    end
  end
end