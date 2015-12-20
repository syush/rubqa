class AnswersController < ApplicationController

  before_action :authenticate_user!

  def new
    @question = Question.find(params[:question_id])
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  private

  # comment
  def answer_params
    params.require(:answer).permit(:body)
  end


end
