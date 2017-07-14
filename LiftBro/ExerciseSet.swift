//
//  ExerciseSet.swift
//  LiftBro
//
//  Created by Ari Gold on 7/10/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import CoreData
import Foundation

public class ExerciseSet: NSManagedObject {
    
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
        
        return dateFormatter.string(from: date as! Date)
    }

}
