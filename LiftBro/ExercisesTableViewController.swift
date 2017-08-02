//
//  ExercisesTableViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 6/5/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit
import CoreData

class ExercisesTableViewController: FetchedResultsTableViewController {

    override func viewDidLoad() {
      
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewUpdated = false
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    var viewUpdated = false
    
    @IBAction func startTrainingCloning(_ sender: UIBarButtonItem) {
        
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "clone training"))!, animated: false)
    }
    @IBOutlet weak var cloneTrainingButton: UIBarButtonItem!
    var container: NSPersistentContainer? = AppDelegate.container
    var context = AppDelegate.container.viewContext
    
   
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Exercise>?
    
    public var training : Training? {
    
        didSet{
            if training?.date as! Date > Calendar.current.startOfDay(for: Date()){
                cloneTrainingButton.isEnabled = false
            }
          
          updateUI()
        }
        
    }
    public var isNewTraining : Bool = false
    
    private func updateUI() {
        
        if viewUpdated == false{
        
            viewUpdated = true
            if let context = container?.viewContext {
                
                let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
                let selector = #selector(NSString.caseInsensitiveCompare(_:))
                request.sortDescriptors = [NSSortDescriptor(key: "category.name", ascending: false, selector: selector)]
                request.predicate = NSPredicate(format: "training = %@", training!)
                request.fetchLimit = 40
                fetchedResultsController = NSFetchedResultsController<Exercise>(
                    
                    fetchRequest: request,
                    managedObjectContext: context,
                    sectionNameKeyPath: "category.name",
                    cacheName: nil
        )
                
        try? fetchedResultsController?.performFetch()
        
        tableView.reloadData()
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
        
        let test = (fetchedResultsController?.sections!.count)!
        
        return (fetchedResultsController?.sections!.count)!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (fetchedResultsController?.sections![sectionIndex].numberOfObjects)!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return fetchedResultsController?.sections?[section].name
        
        
    }

    var exercises : [Exercise] = []
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerText = UILabel()
        headerText.textColor = .black
        headerText.font = UIFont(name: "Avenir-Book", size: 12.0)
        headerText.textAlignment = .right
        headerText.text = fetchedResultsController?.sections?[section].name
        headerText.backgroundColor = tableView.backgroundColor
        
        
        return headerText
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "training exercise", for: indexPath)
        if let exercise = fetchedResultsController?.object(at: indexPath) {
            
            /*cell.textLabel?.text = exercise.type?.name
            let volume = String(exercise.getExerciseVolume())
            cell.detailTextLabel?.text = "Volume: \(volume)kg"*/
           
            exercises.append(exercise)
            
            if let exerciseCell = cell as? ExerciseTableViewCell{
            
                exerciseCell.exercise = exercise
                exerciseCell.tag = exercises.index(of: exercise)!
                
                if (!anySetPerformed(for: exercise)){
                    
                    exerciseCell.backgroundColor = self.navigationController?.navigationBar.barTintColor
                }
                else {
                    
                    exerciseCell.backgroundColor = TrainingsTableViewController.currentColor
                }
            }
            
            
        }
        return cell
    }
    func anySetPerformed(for exercise: Exercise)->Bool{
    
        let request : NSFetchRequest<ExerciseSet> = ExerciseSet.fetchRequest()
        request.predicate = NSPredicate(format: "exercise=%@", exercise)
        let results = try? context.fetch(request)
        if (results?.count)!>0 {return true}
        else {return false}
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
        
        if segue.identifier == "Show All Sets"{
            
            if let vcSet = segue.destination as? SetsTableViewController{
                
                if let sourceCell = sender as? UITableViewCell{
                    
                    vcSet.sets = Array((exercises[sourceCell.tag].sets)! as! Set<ExerciseSet>)
                }
            }
        }
        
        else if segue.identifier == "Add Exercises To Training"{
        
            if let vcEx = segue.destination as? AddExerciseTableViewController{
            
                vcEx.training = self.training
            }
        }
        
        
        
        else if segue.identifier == "Add Set To Exercise"{
        
            if let vcSet = segue.destination as? CreateSetViewController{
            
                if let sourceCell = sender as? UITableViewCell{
                    
                    vcSet.currentExercise = exercises[sourceCell.tag]
                }

            }
        }
        
        else if segue.identifier == "Clone Training"{
        
            if let vcClone = segue.destination as? CloneTrainingTableViewController{
            
                vcClone.exercisesToClone = exercises
            }
                
        }
    }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    

}
