//
//  QuestionViewController.swift
//  GorsemTanirim
//
//  Created by Koray Gültürk on 23/09/14.
//  Copyright (c) 2014 At. All rights reserved.
//

import UIKit
import CoreData
import QuartzCore

class QuestionViewController: UIViewController
{
    internal var selectedCategoryQuestions = [Person]()
    
    var questionModel:QuestionModel = QuestionModel()
    var buttonsLabelTextField = []

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
        self.imageView.clipsToBounds = true;
        
        questionModel.setQuestionList(selectedCategoryQuestions)
        
        setQuestion()
    }
    
    func setQuestion()
    {
        var i:Int = 0
        var people:Array = questionModel.getAnswers()
        
        let imageData = questionModel.getQuestion().image
        imageView.image = UIImage(data: imageData)
        
        for person in people
        {
            if i == 0
            {
                a1.setTitle(person.name, forState: UIControlState.Normal)
            }
            if i == 1
            {
                a2.setTitle(person.name, forState: UIControlState.Normal)
            }
            if i == 2
            {
                a3.setTitle(person.name, forState: UIControlState.Normal)
            }
            
            i++
        }
    }
    @IBAction func a1ButtonClicked(sender: AnyObject)
    {
        let str = a1.titleLabel?.text
        answerSelected(str!)
    }

    @IBAction func a2ButtonClicked(sender: AnyObject)
    {
        let str = a2.titleLabel?.text
        answerSelected(str!)
    }
    
    @IBAction func a3ButtonClicked(sender: AnyObject)
    {
        let str = a3.titleLabel?.text
        answerSelected(str!)
    }
    
    func answerSelected(answer:String)
    {
        if questionModel.checkAnswer(answer) == true
        {
            questionModel.nextQuestion()
            
            if questionModel.questionID == selectedCategoryQuestions.count
            {
                showFinishScene()
                
                return
            }
            
            setQuestion()
        }
        else
        {
            showFinishScene()
        }
    }
    
    func showFinishScene()
    {
        let finishViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FinishViewController") as FinishViewController
        self.navigationController?.pushViewController(finishViewController, animated: true)
    }
    
    func moveBugLeft() {
        UIView.animateWithDuration(1.0,
            delay: 0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.viewContainer.center = CGPoint(x: -self.view.frame.size.width, y:self.view.frame.origin.y)
            },
            completion: { finished in
                println("Moved left!")
        })
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
 }
