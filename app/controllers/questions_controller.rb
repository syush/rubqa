class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @count = @question.answers.count
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      PrivatePub.publish_to "/questions", question:@question
      redirect_to @question, notice: 'Your question is successfully created'
    else
      render :new
    end
  end

  def update
    if (user_signed_in? && current_user.id == @question.user_id)
      respond_to do |format|
        if @question.update(question_params)
          format.html { redirect_to @question, notice: 'Your question was successfully updated' }
          format.json { render json: {question:@question} }
        else
          format.html { redirect_to @question, alert: 'The question was not updated' }
          format.json { render json: @question.errors.full_messages, status: :unprocessable_entity }
        end
      end
    else
      redirect_to @question, alert: 'You attempted an unauthorized action'
    end
  end

  def destroy
    if (user_signed_in? && current_user.id == @question.user_id)
      @question.destroy
      redirect_to questions_path, notice: 'The question was successfully deleted'
    else
      redirect_to questions_path, alert: 'You attempted an unauthorized action'
    end
  end

  private

  # comment
  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end

end