//
//  Training.swift
//  LiftBro
//
//  Created by Ari Gold on 6/5/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import Foundation
import CoreData



public class Training : NSManagedObject {
    
    
    
    
    
    public var month : Int
    {
        if date == nil {return 123}
        return Calendar.current.component(.month, from: (date as? Date)!)
    }

    public func getUserFriendlydate() -> String {
    
        if date == nil {return "test"}
        return DateFormatter.localizedString(from: date as! Date, dateStyle: .medium, timeStyle: .none)
        
    }


    
    public func getAllExerciceTypes()->String{
        if exercises != nil{
        let exerciseSet = exercises as! Set<Exercise>
        let exercise_types = exerciseSet.map{
            String(describing: $0.type?.name)
            }
        
        return exercise_types.joined(separator: ",")
        }
        else {return "Chest, Triceps, Legs"}
}

}

