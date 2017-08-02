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
    
    
    public let months : [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "Nov", "Dec"]
    
    let context = AppDelegate.container.viewContext
    
    public var month : String
    {
        if date == nil {return ""}
        let monthIndex =  Calendar.current.component(.month, from: (date as? Date)!)
        let year = String(Calendar.current.component(.year, from: (date as? Date)!))
        //year = year.substring(from:year.index(year.endIndex, offsetBy:-2))
        return months[monthIndex - 1] + " " + year
    
    }

    
    public func isExerciseAlreadyAddedInTraining(_ type: ExerciseType) -> Bool{
        
        let alltypesInCurrentTraining = self.retrieveExercises().map{$0.type}
        
        let typeOccurences = alltypesInCurrentTraining.filter{$0 == type}
        
        if typeOccurences.count == 0{
            
            return false
        }
        return true
    }
    
    public func retrieveExercises() -> [Exercise]{
    
        let request :NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "training=%@", self)
        let exs = try? context.fetch(request)
        return exs!
    }
    
    
    public func getUserFriendlydate() -> String {
    
        let components = Calendar.current.compare(date as! Date, to: Date(), toGranularity: .day)
        
        if date == nil {return ""}
        else if components.rawValue == 0 {return "today"}
        else if components.rawValue == 1 {return "yesterday"}
        else if components.rawValue == 2 {return "2 days ago"}
        else if components.rawValue == 3 {return "3 days ago"}
        print("\(components.rawValue)")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date as! Date)
        /*(from: date as! Date, dateStyle: .short, timeStyle: .none)*/
        
    }

    public var friendlyDate : String {
        
        let components = Calendar.current.compare(date as! Date, to: Date(), toGranularity: .day)
        
        if date == nil {return ""}
        else if components.rawValue == 0 {return "today"}
        else if components.rawValue == 1 {return "yesterday"}
        else if components.rawValue == 2 {return "2 days ago"}
        else if components.rawValue == 3 {return "3 days ago"}
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date as! Date)    }
    
    public func removeDuplicates<T: Hashable> (from sourceList: Array<T>) -> Set<T> {
    
        var resultList = Set<T>()
            
        for item in sourceList{
                
            resultList.insert(item)
        }
        
       return resultList
    }
    
    public func getAllExerciceCategories()->String{
        
        if exercises != nil{
            
            let exerciseSet = exercises as! Set<Exercise>
            let exercise_categories : [String] = exerciseSet.map{
                
                ($0.category?.name)!
            }
            
            return removeDuplicates(from: exercise_categories).joined(separator: ",")
        }
            
        else {return "No exercises performed yet."}
    }

}

