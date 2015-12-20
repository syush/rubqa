class AnswersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_answer, only: [:edit, :update, :destroy]

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

  def load_answer
    @answer = Answer.find(params[:id])
  end


end
