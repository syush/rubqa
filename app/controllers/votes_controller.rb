class VotesController < ApplicationController

  before_action :authenticate_user!

  def create
    @answer = Answer.find(params[:answer_id])
    if current_user.id != @answer.user_id
      @vote = Vote.new(vote_params)
      @vote.answer = @answer
      @vote.user_id = current_user.id
      unless @vote.save
        redirect_to @answer.question, alert: 'Unable to vote'
      end
    else
      redirect_to @answer.question, alert: 'You have already voted here'
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    if current_user.id == @vote.user_id
      unless @vote.destroy
        redirect_to @answer.question, alert: 'Unable to remove vote'
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:vote_value)
  end

end
