# Helpers added to this module are available in both controllers and views.
module SharedHelper
  include GetText
  
  def current_person?(person)
    logged_in? and person == current_person
  end
  
  # Return true if a person is connected to (or is) the current person
  def connected_to?(person)
    current_person?(person) or Connection.connected?(person, current_person)
  end
  
  NMINUTES = /^(\d+) minutes?$/
  NHOURS   = /^about (\d+) hours?$/
  NDAYS = /^(\d+) days?$/
  NMONTHS  = /^(\d+) months?$/
  NYEARS  = /^over (\d+) years?$/
  # this constant is needed so the rake task i18n:updatepo finds these strings
  MESSAGESS = [N_('less than 5 seconds ago'), N_('less than 10 seconds ago'), N_('less than 20 seconds ago'),
               N_('half a minute ago'), N_('less than a minute ago'), N_('about 1 month ago'),
               N_('about 1 year ago')]

  # we need this helper as in some languages (e.g. German) the grammar changes
  # if an 'ago' is added 
  def time_ago_with_ago(time)
    msg = distance_of_time_in_words_without_locale(time, Time.now, false)
    case msg
      when NMINUTES 
        n_("one minute ago", "%{minutes} minutes ago", $1.to_i) % {:minutes => $1}
      when NHOURS 
        n_("about one hour ago", "about %{hours} hours ago", $1.to_i) % {:hours => $1}
      when NDAYS 
        n_("one day ago", "%{days} days ago", $1.to_i) % {:days => $1}
      when NMONTHS 
        n_("one month ago", "%{months} months ago", $1.to_i) % {:months => $1}
      when NYEARS 
        n_("over one year ago", "over %{years} years ago", $1.to_i) % {:years => $1}
      else
        _(msg << " ago")
    end
  end
  
  def locale_image_tag(image)
    local_image = "locale/"<<Locale.get<<"/"<<image
    path = "public/images/" << local_image
    if File.exists?(path)
      image_tag(local_image)
    else
      image_tag(image)
    end
  end

end
