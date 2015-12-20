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

  def destroy
    @answer = Answer.find(params[:id])
    if (user_signed_in? && current_user == @answer.user)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'The answer was successfully deleted'
    else
      redirect_to question_path(@answer.question), alert: 'You attempted an unauthorized action'
    end
  end

  private

  # comment
  def answer_params
    params.require(:answer).permit(:body)
  end


end
