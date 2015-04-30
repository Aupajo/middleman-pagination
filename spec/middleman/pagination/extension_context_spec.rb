require 'spec_helper'

describe Middleman::Pagination::ExtensionContext do
  describe "#app" do
    it "returns the extension's app" do
      app_one, app_two = double, double
      extension = double(app: app_one)

      context = described_class.new(extension)
      expect(context.app).to be(app_one)

      allow(extension).to receive(:app) { app_two }
      expect(context.app).to be(app_two)
    end
  end

  describe "#configuration" do
    it "returns a configuration object" do
      context = described_class.new(double)
      expect(context.configuration).to be_a(Middleman::Pagination::Configuration)
    end
  end

  shared_examples_for "a method delegated to the app" do
    it "return's the app's method" do
      app = double(method_name => :delegated)
      extension = double(app: app)
      context = described_class.new(extension)
      expect(context.send(method_name)).to be(:delegated)
    end
  end

  describe "#sitemap" do
    let(:method_name) { :sitemap }
    it_should_behave_like "a method delegated to the app"
  end

  describe "#sitemap" do
    let(:method_name) { :data }
    it_should_behave_like "a method delegated to the app"
  end

  describe "#index_file" do
    let(:method_name) { :index_file }
    it_should_behave_like "a method delegated to the app"
  end
end
