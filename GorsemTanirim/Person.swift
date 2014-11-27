//
//  Person.swift
//  GorsemTanirim
//
//  Created by Koray Gültürk on 19/09/14.
//  Copyright (c) 2014 At. All rights reserved.
//

import UIKit
import CoreData

@objc (Person)
class Person: NSManagedObject
{
    @NSManaged var name:String
    @NSManaged var categoryName:String
    @NSManaged var categoryID:Float
    @NSManaged var level:Float
    @NSManaged var image:NSData
}
