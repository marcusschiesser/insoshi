
# required for i18n
require 'gettext/rails'
require 'will_paginate'

module ActionView
  class Base
    delegate :file_exists?, :to => :finder unless respond_to?(:file_exists?)
  end
end

module WillPaginate
  module ViewHelpers
    alias :_will_paginate :will_paginate
    # add i18n labels to the will_paginate method
    # (we dont change the global WillPaginate::ViewHelpers.pagination_options as
    #  each request may be for another language)
    def will_paginate(collection = nil, options = {})
      _will_paginate(collection, options.symbolize_keys.reverse_merge({
        :prev_label => _('&laquo; Previous'),
        :next_label => _('Next &raquo;') }) )
    end
  end
end