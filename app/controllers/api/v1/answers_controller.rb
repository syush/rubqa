class Api::V1::AnswersController < Api::V1::BaseController

  before_action :load_answer, only: :show

  authorize_resource

  def index
    @question = Question.find(params[:question_id])
    render json: @question.answers
  end

  def show
    render json: @answer
  end

  protected

  def load_answer
    @answer = Answer.find(params[:id])
  end


end