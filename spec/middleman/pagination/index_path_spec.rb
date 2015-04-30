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

        it "supports a custom path format" do
          path = IndexPath.new(ext_context, 'original.html', 2, 'index/at/:num/list')
          expect(path.to_s).to eql('original/index/at/2/list.html')
        end

        it "preserves the original file extension" do
          path = IndexPath.new(ext_context, 'original.htm', 2)
          expect(path.to_s).to eql('original/pages/2.htm')
        end

        it "takes index files into account" do
          allow(ext_context).to receive(:index_file) { 'index.html' }
          path = IndexPath.new(ext_context, 'original/index.html', 2)
          expect(path.to_s).to eql('original/pages/2.html')
        end

        it "preserves the index file extension" do
          allow(ext_context).to receive(:index_file) { 'index.htm' }
          path = IndexPath.new(ext_context, 'original/index.htm', 2)
          expect(path.to_s).to eql('original/pages/2.htm')
        end
      end

    end

  end
end
