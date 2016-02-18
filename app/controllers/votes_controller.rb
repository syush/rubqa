class VotesController < ApplicationController

  before_action :authenticate_user!
  before_action :load_vote, only: :destroy

  authorize_resource

  def create
    @votable = params[:answer_id] ? Answer.find(params[:answer_id]) : Question.find(params[:question_id])
    if current_user.id != @votable.user_id
      @vote = Vote.new(vote_params)
      @vote.votable = @votable
      @vote.user_id = current_user.id
      unless @vote.save
        redirect_to @votable, alert: 'Unable to vote'
      end
    else
      redirect_to @votable, alert: "You can't vote for your own votable item"
    end
  end

  def destroy
    @votable = @vote.votable
    unless @vote.destroy
      redirect_to @votable, alert: 'Unable to remove vote'
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
