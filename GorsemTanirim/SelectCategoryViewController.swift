//
//  SelectCategoryViewController.swift
//  GorsemTanirim
//
//  Created by Koray Gültürk on 22/09/14.
//  Copyright (c) 2014 At. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SelectCategoryViewController:UITableViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    let cellIdentifier = "cellIdentifier"
    var categories = [String]()
    var people = [AnyObject]()
    var _fetchedResultsController: NSFetchedResultsController? = nil
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        people = getPeople()
        
        for var i = 0; i < people.count; i++
        {
            var person = people[i] as NSManagedObject
            let categoryName:String = person.valueForKey("categoryName") as String
            
            if find(categories, categoryName) == nil
            {
                categories.append(categoryName)
            }
        }
       
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    
        var bgView:UIImageView = UIImageView(image: UIImage(named: "bg.png"))
        bgView.frame = self.tableView.frame;
        self.tableView.backgroundView = bgView
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func getPeople() -> Array<Person>
    {
        let appDelegete:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context:NSManagedObjectContext = appDelegete.managedObjectContext!
        
        var request:NSFetchRequest = NSFetchRequest(entityName:"Person")
        
        var result = context.executeFetchRequest(request, error: nil)
        var people = [Person]()
        
        for person in result as [Person]
        {
            var p:Person = person
            people.append(p)
        }
        
        return people
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var  cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var bgView:UIImageView = UIImageView(image: UIImage(named: "categoryItemBg.png"))
        cell.backgroundView = bgView
        cell.backgroundColor = UIColor(white: 0, alpha: 0)
        cell.textLabel.text = self.categories[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var selectedCategories = [Person]()

        for var i = 0; i < people.count; i++
        {
            var person = people[i] as Person
            let categoryName:String = person.categoryName
            
            if categoryName == self.categories[indexPath.row]
            {
                selectedCategories.append(person)
            }
        }
        
        let questionViewController = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionViewController") as QuestionViewController
        questionViewController.selectedCategoryQuestions = selectedCategories
        self.navigationController?.pushViewController(questionViewController, animated: true)
        
    }
}