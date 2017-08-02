//
//  CloneTrainingTableViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 7/7/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit

class CloneTrainingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func cloneTraining(_ sender: UIBarButtonItem) {
        
        var createdExercises : [Exercise] = []
        
        training = TrainingsTableViewController.todaysTraining
        
        for ex in CloneTrainingTableViewController.chosenExercises{
            
            if ex.value == true && !training!.isExerciseAlreadyAddedInTraining(ex.key.type!){
                
                let exercise = Exercise(context: context)
                exercise.training = training
                exercise.type = ex.key.type
                exercise.category = ex.key.category
                createdExercises.append(exercise)
            }
        }
        try? context.save()
        
        
        for vc in (self.navigationController?.viewControllers)!{
        
            if vc is ExercisesTableViewController{
            
                if let vcEx = vc as? ExercisesTableViewController{
                
                    vcEx.training = self.training
                    vcEx.exercises = createdExercises
                }
            }
        }
        self.navigationController?.popViewController(animated: false)
        
        
    }
    @IBAction func cancelCloning(_ sender: UIBarButtonItem) {
        
        if let nc = self.navigationController{
            
            nc.popViewController(animated: false)
        }
    }
    let container = AppDelegate.container
    let context = AppDelegate.container.viewContext

    var training : Training?
    static var chosenExercises : [Exercise:Bool] = [:]
    
    
    var exercisesToClone:[Exercise]? {
    
        didSet{
        
            for ex in exercisesToClone!{
            
                CloneTrainingTableViewController.chosenExercises[ex] = true
            }
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
 
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
            
            cloneCell.exerciseName = exercisesToClone?[indexPath.row]
            return cloneCell
        }
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Back To Exercise List"{
        
            if let vcEx = segue.destination as? ExercisesTableViewController{
            
                var createdExercises : [Exercise] = []
                        
                training = TrainingsTableViewController.todaysTraining
                
                for ex in CloneTrainingTableViewController.chosenExercises{
                    
                    if ex.value == true && !training!.isExerciseAlreadyAddedInTraining(ex.key.type!){
                        
                        let exercise = Exercise(context: context)
                        exercise.training = training
                        exercise.type = ex.key.type
                        exercise.category = ex.key.category
                        createdExercises.append(exercise)
                    }
                }
                try? context.save()

                vcEx.training = self.training
                vcEx.exercises = createdExercises
                vcEx.navigationItem.setHidesBackButton(true, animated: false)
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
