module QuestionsControllerHelper

  def is_best?(answer)
    answer.question.best_answer_id == answer.id
  end

  def sorted_answers(question)
    @question.best_answer ?
        [@question.best_answer] + (@question.answers - [@question.best_answer])
    : @question.answers
  end

end
