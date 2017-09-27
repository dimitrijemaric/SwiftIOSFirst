//
//  CloneTrainingTableViewCell.swift
//  LiftBro
//
//  Created by Ari Gold on 7/8/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit


protocol ExerciseRemovedDelegate: class{

    func didRemove(exercise: ExerciseType)
}

class CloneTrainingTableViewCell: UITableViewCell {
    
    weak var exerciseName: ExerciseType? {
    
        didSet{
        
            exerciseLabel.text = exerciseName?.name
        }
    }
    
    weak var exerciseDelegate: ExerciseRemovedDelegate?
    
    
    @IBOutlet weak var exerciseLabel: UILabel!

    
    @IBAction func switchMoved(_ sender: UISwitch) {
        
        if !sender.isOn{
        
            exerciseDelegate?.didRemove(exercise: exerciseName!)
        }
        
    }
}
