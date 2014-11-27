//
//  FinishViewController.swift
//  GorsemTanirim
//
//  Created by Koray Gültürk on 28/09/14.
//  Copyright (c) 2014 At. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController
{
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        scoreLabel.text = String(Score.getInstance.score)
        
        self.navigationController?.navigationBar.hidden = true
    }

    @IBAction func playAgain(sender: AnyObject)
    {
        Score.getInstance.score = 0
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
