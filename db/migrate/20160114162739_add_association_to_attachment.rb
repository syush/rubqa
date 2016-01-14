class AddAssociationToAttachment < ActiveRecord::Migration
  def change
    add_belongs_to :attachments, :question, index:true
  end
end
