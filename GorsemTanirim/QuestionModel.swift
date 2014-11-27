import Foundation

class QuestionModel : QuestionProtocol
{
    var questionID:Int = 0
    var questions = [Person]()
    var question:String = ""
    var answers = [Person]()
    var level = 0
    var person:Person?
    
    var cloneQuestions = [Person]()
    
    init()
    {
        
    }
    
    func setQuestionList(questions: Array<Person>)
    {
        self.questions = questions
        
        setQuestion(self.questions[questionID])
    }
    
    func setQuestion(data: Person)
    {
        self.person = data;
        
        self.answers = []
        cloneQuestions = questions
        
        setAnswers()
    }
    
    func getQuestion() -> Person
    {
        return person!
    }
    
    func setAnswers()
    {
        answers.append(person!)
        
        self.cloneQuestions.removeAtIndex(questionID)
        
        answers.append(self.getRandomAnswer())
        answers.append(self.getRandomAnswer())
    }
    
    func getRandomAnswer() -> Person
    {
        let randomIndex = Int(arc4random_uniform(UInt32(self.cloneQuestions.count)))
        
        var person = self.cloneQuestions[randomIndex] as Person
        println("person : \(person.name)")
        self.cloneQuestions.removeAtIndex(randomIndex)
        
        return person
    }
    
    func getAnswers() -> Array<Person>
    {
        self.answers.shuffle()
        
        return self.answers
    }
    
    func checkAnswer(answer: String) -> Bool
    {
        if person?.name == answer
        {
            return true
        }
       
        return false
    }
    
    func nextQuestion()
    {
        Score.getInstance.score += 100;
        
        questionID++
        
        if questionID < questions.count
        {
            setQuestion(self.questions[questionID])
        }
    }
}

extension Array
    {
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}