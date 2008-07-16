desc "Update pot/po files to match new version." 

namespace :i18n do
  task :updatepo do
    APP_TEXT_DOMAIN = "insoshi" 
    APP_VERSION     = "insoshi 1.0" 
    GetText.update_pofiles(APP_TEXT_DOMAIN,
                           Dir.glob("{app,lib}/**/*.{rb,rhtml}"),
    APP_VERSION)
  end
end