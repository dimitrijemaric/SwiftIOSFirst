//
//  ModelClasses.swift
//  LiftBro
//
//  Created by Ari Gold on 6/12/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import Foundation
import CoreData

public class ExerciseType : NSManagedObject{

    
    static let context = AppDelegate.container.viewContext
    class func Retrieve (from name: String) -> ExerciseType{
    
        let request : NSFetchRequest<ExerciseType> = ExerciseType.fetchRequest()
        request.predicate = NSPredicate(format: "name=%@", name)
        let types = try? context.fetch(request)
        return types![0]
    }
}
public class ExerciseCategory : NSManagedObject{}


