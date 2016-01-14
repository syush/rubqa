class Attachment < ActiveRecord::Base
  mount_uploader :file, FileUploader
  belongs_to :question

  def file_name
    file.try(:file).try(:filename)
  end
end
