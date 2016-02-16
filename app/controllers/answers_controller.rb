class AnswersController < ApplicationController

  include ApplicationHelper

  before_action :authenticate_user!
  before_action :load_answer, only: [:show, :edit, :update, :destroy, :select_as_best]

  def show
    redirect_to @answer.question
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user
    @answer.save
  end

  def update
    if (i_am_author_of(@answer))
      respond_to do |format|
        if @answer.update(answer_params)
          PrivatePub.publish_to "/questions/#{@answer.question.id}/answers", answer:@answer, action:'update'
          format.html { redirect_to @answer.question, notice: 'Your answer was successfully updated' }
          format.json { render json: {body:@answer.body} }
        else
          format.html { redirect_to @answer.question, alert: 'The answer was not updated' }
          format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
        end
      end
    else
      redirect_to @answer.question, alert: 'You attempted and unauthorized action'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if (i_am_author_of(@answer))
      @answer.destroy
      @count = @answer.question.answers.count
    else
      redirect_to @answer.question, alert: 'You attempted and unauthorized action'
    end
  end

  def select_as_best
    @question = @answer.question
    @old_best = @question.best_answer
    if (i_am_author_of(@question))
      unless @question.set_best_answer_and_save(@answer)
        redirect_to @question, alert: 'The best answer selection was not successful'
      end
    else
      redirect_to @question, alert: 'You attempted and unauthorized action'
    end
    @answer.reload
    @old_best.try(:reload)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end


end
