//
//  AddExerciseTableViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 6/14/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit
import CoreData

class AddExerciseTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }

    
    
    deinit {
        print("deinit add")
    }
    
    @IBAction func addSelectedExercises(_ sender: UIBarButtonItem) {
        
        for ce in chosenExercises{
            
            if !(training?.isExerciseAlreadyAddedInTraining(ce))!{
                    
                let exercise = Exercise(context: context!)
                exercise.type = ce
                exercise.category = ce.category
                exercise.training = training
            }
        }
        
        try? context?.save()
        
        if cameFromRoot{
        
            _ = self.navigationController?.popToRootViewController(animated: false)
        }
        else{
        
            _ = self.navigationController?.popViewController(animated: false)
        }
    
    }
    var cameFromRoot = false
    
    weak var training : Training?


    weak var selectedCellcolor : UIColor?
    
    weak var context  = AppDelegate.container.viewContext

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
       return AppDelegate.exerciseDict.count
    
    }
    let exerciseCategories = AppDelegate.exerciseCategories
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return AppDelegate.exerciseDict[exerciseCategories[section]]!.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerText = UILabel()
        headerText.textColor = .black
        headerText.font = UIFont(name: "Avenir-Book", size: 12.0)
        headerText.textAlignment = .right
        headerText.text = exerciseCategories[section].name
        headerText.backgroundColor = tableView.backgroundColor
        
        return headerText
    }
    
    
    var chosenExercises : [ExerciseType] = []
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "static exercise", for: indexPath)

        cell.backgroundColor = selectedCellcolor
        cell.accessoryType = .checkmark
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        cell.textLabel?.text = AppDelegate.exerciseDict[exerciseCategories[indexPath.section]]?[indexPath.row].name
        
        cell.tag = indexPath.section
        
        let type = ExerciseType.Retrieve(from: (cell.textLabel?.text)!)
        
        if !(training?.isExerciseAlreadyAddedInTraining(type))!{
            
            chosenExercises.append(type)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "static exercise", for: indexPath)
        
        cell.textLabel?.text = AppDelegate.exerciseDict[exerciseCategories[indexPath.section]]?[indexPath.row].name
        
        cell.tag = indexPath.section
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return exerciseCategories[section].name
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
    
    var selectedCells : [String] = []
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "Add Exercises To Training"{
        
            if let vcExs = segue.destination as? ExercisesTableViewController{
            
                for ce in chosenExercises{
                
                    let exercise = Exercise(context: context!)
                    exercise.type = ce
                    exercise.category = ce.category
                    exercise.training = training
                    vcExs.exercises.append(exercise)
                }
                
                try? context?.save()
                vcExs.training = self.training
            }
        }
        
        if segue.identifier == "Add New Set"{
            
            if let vcSet = segue.destination as? CreateSetViewController{
            
                let newExercise = Exercise(context: context!)
               
                newExercise.training = self.training
                
                if let sourceCell = sender as? UITableViewCell{
                
                    newExercise.name = sourceCell.textLabel?.text
                    newExercise.category = exerciseCategories[sourceCell.tag]
                    newExercise.type = AppDelegate.exerciseDict[exerciseCategories[sourceCell.tag]]?.filter{$0.name == sourceCell.textLabel?.text}[0]
                    
                    vcSet.currentExercise = newExercise
                    if exerciseCategories[sourceCell.tag].name == "Cardio" {
                        
                        vcSet.currentExercise?.isDurationExercise = true
                    }
                    vcSet.title = sourceCell.textLabel?.text
                }
            }
        }
       
    }
}
