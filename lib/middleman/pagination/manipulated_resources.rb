module Middleman
  module Pagination
    class ManipulatedResources
      attr_reader :context, :original_resources

      def initialize(context, resources)
        @context = context
        @original_resources = resources
      end

      def resource_list
        original_resources + new_resources
      end

      private

      def new_resources
        context.configuration.map do |pageable|
          pageable.new_resources(context, original_resources)
        end.flatten
      end
    end
  end
end