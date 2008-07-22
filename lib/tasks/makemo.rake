require 'gettext/utils'

namespace :i18n do
  desc "Create mo-files for i18n" 
  task :makemo do
    GetText.create_mofiles(true, "po", "locale")
  end
end