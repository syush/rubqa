class AttachmentsController < ApplicationController

  include ApplicationHelper

  def destroy
    @attachment = Attachment.find(params[:id])
    if (i_am_author_of(@attachment.attachable))
      @attachment.destroy
    end
    redirect_to @attachment.attachable
  end

end
