class Api::V1::ProfilesController < Api::V1::BaseController

  authorize_resource class: User

  def me
    render json: current_resource_owner
  end

  def index
    @other_users = User.where.not(id: current_resource_owner.id)
    if @other_users.size > 1
      render json: @other_users
    end
  end

end