class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_answer, only: [:edit, :update, :destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user
    @answer.save
  end

  def edit
  end

  def update
    if (user_signed_in? && current_user.id == @answer.user_id)
      if @answer.update(answer_params)
        redirect_to @answer.question, notice: 'Your answer was successfully updated'
      else
        render :edit
      end
    else
      redirect_to @answer.question, alert: 'You attempted and unauthorized action'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if (user_signed_in? && current_user.id == @answer.user_id)
      @answer.destroy
      @count = @answer.question.answers.count
    else
      redirect_to @answer.question, alert: 'You attempted and unauthorized action'
    end
  end

  private

  # comment
  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end


end
