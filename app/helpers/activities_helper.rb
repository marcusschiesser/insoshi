module ActivitiesHelper

  # Given an activity, return a message for the feed for the activity's class.
  def feed_message(activity)
    person = activity.person
    case activity_type(activity)
    when "BlogPost"
      post = activity.item
      blog = post.blog
      view_blog = blog_link(_("View %s's blog") % h(person.name), blog)
      (_("%{person} made a blog post titled %{title}.") % {:person => person_link(person),
        :title => post_link(blog, post)}) << "<br /> #{view_blog}."
    when "Comment"
      parent = activity.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "BlogPost"
        post = activity.item.commentable
        blog = post.blog
        _("%{person} made a comment to %{someone}'s blog post %{post}.") % {:person => person_link(person),
           :someone => person_link(blog.person),
           :post => post_link(blog, post)}
      when "Person"
        _("%{person} commented on %{wall}.") % {:person => person_link(activity.item.commenter),
          :wall => wall(activity)}
      end
    when "Connection"
      _("%{person1} and %{person2} have connected.") % {:person1 => person_link(activity.item.person),
        :person2 => person_link(activity.item.contact)}
    when "ForumPost"
      post = activity.item
      _("%{person} made a post on the forum topic %{topic}.") % {:person => person_link(person),
        :topic => topic_link(post.topic)}
    when "Topic"
      _("%{person} created the new discussion topic %{topic}.") % {:person => person_link(person), 
        :topic => topic_link(activity.item)}
    when "Photo"
      _("%{person}'s profile picture has changed.") % {:person => person_link(person)}
    when "Person"
      _("%{person}'s description has changed.") % {:person => person_link(person)}
    else
      # TODO: make this a more graceful falure (?).
      raise "Invalid activity type #{activity_type(activity).inspect}"
    end
  end
  
  def minifeed_message(activity)
    person = activity.person
    case activity_type(activity)
    when "BlogPost"
      post = activity.item
      blog = post.blog
      _("%{person} made a %{post}.") % {:person => person_link(person), :post => post_link(_("new blog post"), blog, post)}
    when "Comment"
      parent = activity.item.commentable
      parent_type = parent.class.to_s
      case parent_type
      when "BlogPost"
        post = activity.item.commentable
        blog = post.blog
        _("%{person} made a comment on %{someone}'s %{post}.") % {:person => person_link(person),
           :someone => person_link(blog.person),
           :post => post_link(_("blog post"), post.blog, post)}
      when "Person"
        _("%{person} commented on %{wall}.") % {:person => person_link(activity.item.commenter),
          :wall => wall(activity)}
      end
    when "Connection"
      _("%{person1} and %{person2} have connected.") % {:person1 => person_link(person),
        :person2 => person_link(activity.item.contact)}
    when "ForumPost"
      topic = activity.item.topic
      # TODO: deep link this to the post
      _("%{person} made a %{post}.") % {:person => person_link(person),
        :post => topic_link(_("forum post"), topic)}
    when "Topic"
      _("%{person} created a %{topic}.") % {:person => person_link(person), 
        :topic => topic_link(_("new discussion topic"), activity.item)}
    when "Photo"
      _("%{person}'s profile picture has changed.") % {:person => person_link(person)}
    when "Person"
      _("%{person}'s description has changed.") % {:person => person_link(person)}
    else
      raise "Invalid activity type #{activity_type(activity).inspect}"
    end
  end
  
  # Given an activity, return the right icon.
  def feed_icon(activity)
    img = case activity_type(activity)
            when "BlogPost"
              "blog.gif"
            when "Comment"
              parent_type = activity.item.commentable.class.to_s
              case parent_type
              when "BlogPost"
                "comment.gif"
              when "Person"
                "signal.gif"
              end
            when "Connection"
              "switch.gif"
            when "ForumPost"
              "new.gif"
            when "Topic"
              "add.gif"
            when "Photo"
              "camera.gif"
            when "Person"
                "edit.gif"
            else
              # TODO: make this a more graceful falure (?).
              raise "Invalid activity type #{activity_type(activity).inspect}"
            end
    image_tag("icons/#{img}", :class => "icon")
  end
  
  def someones(person, commenter, link = true)
    link ? "#{person_link(person)}'s" : "#{h person.name}'s"
  end
  
  def blog_link(text, blog)
    link_to(text, blog_path(blog))
  end
  
  def post_link(text, blog, post = nil)
    if post.nil?
      post = blog
      blog = text
      text = post.title
    end
    link_to(text, blog_post_path(blog, post))
  end
  
  def topic_link(text, topic = nil)
    if topic.nil?
      topic = text
      text = topic.name
    end
    link_to(text, forum_topic_path(topic.forum, topic))
  end

  # Return a link to the wall.
  def wall(activity)
    commenter = activity.person
    person = activity.item.commentable
    link_to(_("%{person}'s wall") % {:person => h(person.name)},
            person_path(person, :anchor => "wall"))
  end
  
  private
  
    # Return the type of activity.
    # We switch on the class.to_s because the class itself is quite long
    # (due to ActiveRecord).
    def activity_type(activity)
      activity.item.class.to_s      
    end
end
