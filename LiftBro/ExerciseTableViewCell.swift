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

    
    let defaults = UserDefaults.standard
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var exercise : Exercise? {
    
        didSet{
        
            exerciseLabel.text = exercise?.type?.name
            let sets = (exercise?.sets)!
            var setsMapped : [String] = []
            
            if exercise?.type?.hasDuration == false{
                
                let volume = String(exercise!.getExerciseVolume())
                volumeLabel.text = "Volume: \(volume)" + defaults.string(forKey: "measureUnit")!
                setsMapped = sets.map{set in
            
                    return "\((set as! ExerciseSet).reps)x\((set as! ExerciseSet).weight)" + defaults.string(forKey: "measureUnit")!
                }
            }
            else {
            
                setsMapped = sets.map{set in
                    
                    return "\((set as! ExerciseSet).duration) minutes"
                }
            }
            setsLabel.text = setsMapped.count > 0 ? setsMapped.joined(separator: ", ") : "No sets performed."

        }
    }
    
    @IBOutlet weak var exerciseLabel: UILabel!
    
    
    @IBOutlet weak var volumeLabel: UILabel!
    

    @IBOutlet weak var setsLabel: UILabel!
}
