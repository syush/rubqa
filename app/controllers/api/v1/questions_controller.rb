class Api::V1::QuestionsController < Api::V1::BaseController

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: Question.find(params[:id])
  end

end