module ForumsHelper
  def forum_name(forum)
    forum.name.nil? || forum.name.blank? ? _("Forum #%{id}") % {:id => forum.id} : forum.name
  end
end
