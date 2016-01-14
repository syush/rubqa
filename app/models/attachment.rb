class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader
  belongs_to :attachable, polymorphic: true

  def file_name
    file.try(:file).try(:filename)
  end
end
