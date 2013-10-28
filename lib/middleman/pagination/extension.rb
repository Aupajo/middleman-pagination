require "middleman-core/extensions"

module Middleman
  module Pagination
    class Extension < Middleman::Extension
      def initialize(app, options = {}, &block)
        @context = ExtensionContext.new(self)
        super
      end

      def manipulate_resource_list(resources)
        mainpulated = ManipulatedResources.new(@context, resources)
        mainpulated.resource_list
      end

      def setup_options(options, &block)
        @context.configuration.instance_eval(&block)
      end
    end
  end
end