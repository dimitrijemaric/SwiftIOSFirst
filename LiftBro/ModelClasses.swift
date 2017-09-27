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


public extension Date{

    func getUserFriendlyDate()->String{
    
        let components = Calendar.current.compare(self , to: Date(), toGranularity: .day)
        
        if components.rawValue == 0 {return "today"}
        else if components.rawValue == 1 {return "yesterday"}
        else if components.rawValue == 2 {return "2 days ago"}
        else if components.rawValue == 3 {return "3 days ago"}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: self)
    
    }
      
}


