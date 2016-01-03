class VotesController < ApplicationController

  before_action :authenticate_user!, :load_answer

  def create
    @vote = Vote.new
    @vote.answer = @answer
    @vote.user_id = current_user.id
    @vote.vote_value = params[:vote_value]
    unless @vote.save
      redirect_to @answer.question, alert: 'Unable to vote'
    end

  end

  def destroy

  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

end
