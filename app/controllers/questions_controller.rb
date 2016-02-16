class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    3.times { @answer.attachments.build }
    @count = @question.answers.count
  end

  def new
    @question = Question.new
    3.times { @question.attachments.build }
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      PrivatePub.publish_to "/questions", question:@question, action:'create'
      redirect_to @question, notice: 'Your question is successfully created'
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        PrivatePub.publish_to "/questions", question:@question, action:'update'
        format.html { redirect_to @question, notice: 'Your question was successfully updated' }
        format.json { render json: {question:@question} }
      else
        format.html { redirect_to @question, alert: 'The question was not updated' }
        format.json { render json: @question.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question.destroy
    PrivatePub.publish_to "/questions", question_id:@question.id, action:'destroy'
    redirect_to questions_path, notice: 'The question was successfully deleted'
  end

  private

  # comment
  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    @question = Question.find(params[:id])
  end

end