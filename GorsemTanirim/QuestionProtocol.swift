import Foundation

protocol QuestionProtocol
{
    var questionID:Int { get set }
    var questions:Array <Person> { get set }
    var question: String { get set }
    var answers: Array <Person> { get set }
    var level:Int { get set }
    var person:Person? { get set }
    
    func getQuestion() -> Person
    func setQuestion(data:Person)
    func checkAnswer(answer:String) -> Bool
    func setQuestionList(questions:Array<Person>)
    func nextQuestion()
    func getAnswers() -> Array<Person>
    func setAnswers()
    
}