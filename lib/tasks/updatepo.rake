require 'gettext/utils'

namespace :i18n do
  desc "Update pot/po files to match new version." 
  task :updatepo do
    APP_TEXT_DOMAIN = "insoshi" 
    APP_VERSION     = "insoshi 1.0" 
    GetText.update_pofiles(APP_TEXT_DOMAIN,
                           Dir.glob("{app,lib,config}/**/*.{rb,rhtml,erb}"),
    APP_VERSION)
  end
end