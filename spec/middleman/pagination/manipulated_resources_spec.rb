require 'spec_helper'

module Middleman::Pagination
  describe ManipulatedResources do
    let(:context) { double(:context, configuration: configuration).as_null_object }
    let(:configuration) { Configuration.new }
    let(:resource_list) { [] }

    describe "#initialize" do
      it "accepts a context and a resource list" do
        expect { described_class.new(context, resource_list) }.not_to raise_error
      end
    end

    describe "#resource_list" do
      context "with an empty configuration" do
        it "returns resources without modification" do
          manipulated = described_class.new(context, resource_list)
          expect(manipulated.resource_list).to eql(resource_list)
        end
      end

      context "with a pageable configuration and an pagination index" do
        let(:configuration) {
          config = Configuration.new
          config.pageable(:recipes, &:is_recipe?)
          config
        }

        let(:pagination_index) {
          pagination_data = double(for: 'recipes', per_page: 2)
          resource = double(:resource, path: 'index.html', is_recipe?: false, ignored?: false).as_null_object
          resource.stub_chain(:data, pagination: pagination_data)
          resource
        }

        let(:resource_list) {
          [pagination_index] +
          7.times.map do |n|
            double(:resource, path: "recipe-#{n}.html", is_recipe?: true, ignored?: false).as_null_object
          end
        }

        it "adds new index pages" do
          expect(resource_list).to have(8).pages
          manipulated = described_class.new(context, resource_list)
          expect(manipulated.resource_list).to have(11).pages
        end
      end
    end
  end
end