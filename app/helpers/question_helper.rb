module QuestionHelper
  def author_id_of(question)
    question.user.id
  end
end
