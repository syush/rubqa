class AnswersController < ApplicationController

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  private

  # comment
  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

end
