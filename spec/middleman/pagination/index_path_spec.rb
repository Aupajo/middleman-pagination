require 'spec_helper'

module Middleman::Pagination
  describe IndexPath do

    describe "#to_s" do
      let(:ext_context) { double(index_file: 'index.html') }

      context "when the page num is 0" do
        it "raises an error" do
          expect {
            IndexPath.new(ext_context, 'original.html', 0)
          }.to raise_error
        end
      end

      context "when the page num is 1" do
        it "returns the original path" do
          path = IndexPath.new(ext_context, 'original.html', 1)
          expect(path.to_s).to eql('original.html')
        end
      end

      context "when the page num is greater than 1" do
        it "returns a path including the page number" do
          path = IndexPath.new(ext_context, 'original.html', 2)
          expect(path.to_s).to eql('original/pages/2.html')
        end

        it "allows the path format to be changed" do
          path = IndexPath.new(ext_context, 'original.html', 2, 'index/at/:num/list')
          expect(path.to_s).to eql('original/index/at/2/list.html')
        end
      end
      
    end

  end
end