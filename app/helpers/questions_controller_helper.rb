module QuestionsControllerHelper

  def is_best?(answer)
    answer.question.best_answer_id == answer.id
  end

end
