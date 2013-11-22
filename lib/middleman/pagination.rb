require "middleman-core"
require "ostruct"
require "middleman/pagination/version"
require "middleman/pagination/configuration"
require "middleman/pagination/extension_context"
require "middleman/pagination/manipulated_resources"
require "middleman/pagination/pageable"
require "middleman/pagination/pageable_context"
require "middleman/pagination/index_page"
require "middleman/pagination/index_path"
require "middleman/pagination/in_page_context"
require "middleman/pagination/extension"

::Middleman::Extensions.register(:pagination, ::Middleman::Pagination::Extension)