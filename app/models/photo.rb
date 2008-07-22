# == Schema Information
# Schema version: 26
#
# Table name: photos
#
#  id           :integer(11)     not null, primary key
#  person_id    :integer(11)     
#  parent_id    :integer(11)     
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer(11)     
#  width        :integer(11)     
#  height       :integer(11)     
#  primary      :boolean(1)      
#  created_at   :datetime        
#  updated_at   :datetime        
#

class Photo < ActiveRecord::Base
  include ActivityLogger
  UPLOAD_LIMIT = 5 # megabytes
  
  belongs_to :person
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => UPLOAD_LIMIT.megabytes,
                 :min_size => 1,
                 :resize_to => '240>',
                 :thumbnails => { :thumbnail    => '72>',
                                  :icon         => '36>',
                                  :bounded_icon => '36x36>' }
  
  has_many :activities, :foreign_key => "item_id", :dependent => :destroy
    
  after_save :log_activity
                 
  # Override the crappy default AttachmentFu error messages.
  def validate
    if filename.nil?
      errors.add_to_base(_("You must choose a file to upload"))
    else
      # Images should only be GIF, JPEG, or PNG
      enum = attachment_options[:content_type]
      unless enum.nil? || enum.include?(send(:content_type))
        errors.add_to_base(_("You can only upload images (GIF, JPEG, or PNG)"))
      end
      # Images should be less than UPLOAD_LIMIT MB.
      enum = attachment_options[:size]
      unless enum.nil? || enum.include?(send(:size))
        msg = _("Images should be smaller than %{limit} MB") % {:limit => UPLOAD_LIMIT}
        errors.add_to_base(msg)
      end
    end
  end
  
  def log_activity
    if self.primary?
      activity = Activity.create!(:item => self, :person => self.person)
      add_activities(:activity => activity, :person => self.person)
    end
  end

end
