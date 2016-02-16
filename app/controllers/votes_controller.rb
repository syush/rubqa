class VotesController < ApplicationController

  before_action :authenticate_user!
  before_action :load_vote, only: :destroy

  authorize_resource

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
      redirect_to @answer.question, alert: "You can't vote for your own answer"
    end
  end

  def destroy
    @answer = @vote.answer
    unless @vote.destroy
      redirect_to @answer.question, alert: 'Unable to remove vote'
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:vote_value)
  end

  def load_vote
    @vote = Vote.find(params[:id])
  end

end
