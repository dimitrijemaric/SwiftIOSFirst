//
//  CloneTrainingTableViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 7/7/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit

protocol PassChosenExercisesDelegate: class{

    func didChose(exercises chosenExercises: [ExerciseType])
}

class CloneTrainingTableViewController: UITableViewController, ExerciseRemovedDelegate {

    
    deinit {
        print("deinit clone")
    }
    
   
    
    @IBAction func cloneTraining(_ sender: UIBarButtonItem) {
        
        exercisesDelegate?.didChose(exercises: exercisesToClone!)
       
        _ = self.navigationController?.popViewController(animated: false)
    
    }
    @IBAction func cancelCloning(_ sender: UIBarButtonItem) {
        
        _ = self.navigationController?.popViewController(animated: false)
    }
   
    weak var context = AppDelegate.container.viewContext

    weak var training : Training?
   
    weak var exercisesDelegate: PassChosenExercisesDelegate? 
    
    var exercisesToClone:[ExerciseType]?


   
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exercisesToClone!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exercise To Clone", for: indexPath)

        // Configure the cell...

        if let cloneCell = cell as? CloneTrainingTableViewCell{
            
            cloneCell.exerciseDelegate = self
            cloneCell.exerciseName = exercisesToClone?[indexPath.row]
          
            return cloneCell
        }
        return cell
    }

    func didRemove(exercise: ExerciseType) {
        exercisesToClone = exercisesToClone?.filter{$0 != exercise}
    }

   
    

}
