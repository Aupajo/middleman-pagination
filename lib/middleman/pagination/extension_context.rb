module Middleman
  module Pagination
    class ExtensionContext
      def initialize(extension)
        @extension = extension
      end
      
      def configuration
        @configuration ||= Configuration.new
      end

      def app
        @extension.app
      end

      def sitemap
        app.sitemap
      end
    end
  end
end