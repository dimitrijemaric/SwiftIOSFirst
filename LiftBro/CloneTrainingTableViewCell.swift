//
//  CloneTrainingTableViewCell.swift
//  LiftBro
//
//  Created by Ari Gold on 7/8/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit

class CloneTrainingTableViewCell: UITableViewCell {
    
    var exerciseName: Exercise? {
    
        didSet{
        
            exerciseLabel.text = exerciseName?.type?.name
        }
    }
    
    @IBOutlet weak var exerciseLabel: UILabel!

    
    @IBAction func switchMoved(_ sender: UISwitch) {
        
        CloneTrainingTableViewController.chosenExercises[exerciseName!] = sender.isOn
        
    }
}
