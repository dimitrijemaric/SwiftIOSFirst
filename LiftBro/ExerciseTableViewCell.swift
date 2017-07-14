//
//  ExerciseTableViewCell.swift
//  LiftBro
//
//  Created by Ari Gold on 6/5/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var exercise : Exercise? {
    
        didSet{
        
            exerciseLabel.text = exercise?.type?.name
            let volume = String(exercise!.getExerciseVolume())
            volumeLabel.text = "Volume: \(volume)kg"
            let sets = (exercise?.sets)!
            let setsMapped = sets.map{set in
            
                    return "\((set as! ExerciseSet).reps)x\((set as! ExerciseSet).weight)kg"
            }
            setsLabel.text = setsMapped.count > 0 ? setsMapped.joined(separator: ", ") : "No sets performed."
        }
    }
    
    @IBOutlet weak var exerciseLabel: UILabel!
    
    
    @IBOutlet weak var volumeLabel: UILabel!
    

    @IBOutlet weak var setsLabel: UILabel!
}
