require 'spec_helper'

module Middleman
  module Pagination
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
            resource = double(:resource, is_recipe?: false).as_null_object
            resource.stub_chain(:data, :pagination) { pagination_data }
            resource
          }

          let(:recipe) {
            double(:resource, is_recipe?: true).as_null_object
          }

          let(:resource_list) {
            resources = []
            7.times { resources << recipe }
            resources << pagination_index
          }

          it "adds new index pages" do
            expect(resource_list).to have(8).pages
            expect(context.configuration).to be_a(Configuration)
            manipulator = described_class.new(context, resource_list)
            expect(manipulator.resource_list).to have(11).pages
          end
        end
      end
    end
  end
end