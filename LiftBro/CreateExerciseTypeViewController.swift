//
//  CreateExerciseTypeViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 7/14/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit
import CoreData

class CreateExerciseTypeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit create exercise")
    }
    
    var category = "" {
    
        didSet{
        
            let request : NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
            request.predicate = NSPredicate(format: "name=%@", category)
            var results = try? context.fetch(request)
            exerciseCategory = results?[0]
            
            
            
        }
    }
    
    weak var exerciseCategory : ExerciseCategory?
    
    let container = AppDelegate.container
    let context = AppDelegate.container.viewContext

    @IBOutlet weak var exerciseNameField: UITextField!
    @IBOutlet weak var durationSwitch: UISwitch!
    
    @IBAction func saveNewExercise(_ sender: UIButton) {
     
        if (exerciseNameField.text != nil){
            
            let exerciseType = ExerciseType(context: context)
            exerciseType.name = exerciseNameField.text
            exerciseType.category = exerciseCategory
            if durationSwitch.isOn{
                
                exerciseType.hasDuration = true
            }
            try? context.save()
            AppDelegate.exerciseDict[exerciseCategory!]?.append(exerciseType)
            
            _ = self.navigationController?.popViewController(animated: false)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Save Exercise"{
        
            if (exerciseNameField.text != nil){
                
                let exerciseType = ExerciseType(context: context)
                exerciseType.name = exerciseNameField.text
                exerciseType.category = exerciseCategory
                if durationSwitch.isOn{
                
                    exerciseType.hasDuration = true
                }
                try? context.save()
            
                if let VC = segue.destination as? AddExerciseTableViewController {
                
                    VC.training = TrainingsTableViewController.todaysTraining
                }
            }
            
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if exerciseNameField.text == nil || exerciseNameField.text == ""{
        
            return false
        }
        return true
    }

}
