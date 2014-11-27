//
//  CategoriesDataOBJ.swift
//  GorsemTanirim
//
//  Created by Koray Gültürk on 21/09/14.
//  Copyright (c) 2014 At. All rights reserved.
//

import UIKit
import CoreData

@objc (CategoriesDataOBJ)
class CategoriesDataOBJ: NSManagedObject
{
    @NSManaged var categoriesJsonString:String
}
