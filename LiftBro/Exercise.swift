//
//  Exercise.swift
//  LiftBro
//
//  Created by Ari Gold on 6/5/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import Foundation
import CoreData


public class Exercise : NSManagedObject
{

    
    public static let ExerciseList = ["Biceps","Chest","Legs","Triceps","Shoulders","Back","Forearms",
    "Neck","Abs","Cardio","Custom"]
    
    public static let ExerciseDict = ["Biceps":["Dumbell Curl", "Cable Curl", "Scott Bench Curl"], "Chest":["Benchpress", "Pushups"], "Legs":["Squats", "Lunges"], "Triceps":["Overhead extension", "Standing Cable Extension"], "Shoulders":["Smith Extension", "Dumbell Lateral Raise"], "Back":["Pullups", "Lat Machine Wide Pull"], "Forearms":["Dumbell Curl"], "Neck":["Cable Pull"], "Abs" : ["SitUps","Plank"], "Cardio":["Threadmill", "Eliptical", "Bicycle"], "Custom":["Jumping Jacks"]]
    
    public func getExerciseVolume () -> Double {
        
        var sum : Double = 0.0
        
       if let brigdedset = sets as? Set<ExerciseSet>
       {
        for set in brigdedset {
            sum += set.weight * Double(set.reps)
        }
        }
        
        
        return Double(sum)
    }
    
    var isDurationExercise = false
}

public enum ExerciseTypes

{

    case Biceps
    case Chest
    case Legs
    case Triceps
    case Shoulders
    case Back
    case Forearms
    case Neck
    case Abs
    case Cardio
    case Custom
    

}



