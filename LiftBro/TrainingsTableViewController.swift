//
//  TrainingsTableViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 6/5/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit
import CoreData

class TrainingsTableViewController: FetchedResultsTableViewController {

    let defaults = UserDefaults.standard
       let container = AppDelegate.container
    let context = AppDelegate.container.viewContext
    static var todaysTraining : Training?
    static var currentColor: UIColor?

    var firstLoad = false;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        firstLoad = true
       // deleteData()
        
       if !areExercisesImported() {
        
            importInitialExercises()
       }
        getAllExercisesfromRepository()
        getOrCreateTodaysTraining()
        updateUI()
     
             // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func getOrCreateTodaysTraining()->(){
    
        guard TrainingsTableViewController.todaysTraining != nil else {
            
            let request: NSFetchRequest<Training> = Training.fetchRequest()
            request.predicate = NSPredicate(format: "(%@ < date) AND (date <= %@)", argumentArray: [Calendar.current.startOfDay(for: Date()), Date()])
            let trainings = try? context.fetch(request)
            
            if trainings?.count == 0 {
        
                TrainingsTableViewController.todaysTraining = Training(context:context)
                TrainingsTableViewController.todaysTraining?.date = Date() as NSDate //Date.randomWithinDaysBeforeToday(5) as NSDate?
            }
            else {
        
                TrainingsTableViewController.todaysTraining = (trainings?[0])! as Training
            }
            return
        }
    }
    
    func getAllExercisesfromRepository() -> (){
    
        guard AppDelegate.exerciseDict.count > 0 else {
            
            let request : NSFetchRequest<ExerciseCategory> = ExerciseCategory.fetchRequest()
            let categories = try? context.fetch(request)
        
            for item in categories!{
        
                let request : NSFetchRequest<ExerciseType> = ExerciseType.fetchRequest()
                request.predicate = NSPredicate(format: "category = %@", item)
                let types = try? context.fetch(request)
                AppDelegate.exerciseDict[item] = types
            }
            return
        }
    }
    func deleteData() -> (){
    
        let request : NSFetchRequest<Training> = Training.fetchRequest()
        let categories = try? context.fetch(request)
        
        for item in categories!{
        
           context.delete(item)
            try? context.save()
        }
    }
    
    func areExercisesImported () -> Bool{
        
        if defaults.string(forKey: "areExercisesImported") != nil{
            
            return true
        }
        return false
    }
    
    func importInitialExercises ()->() {
        
        let url = Bundle.main.url(forResource: "ExerciseInitial", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        let initialExercises = try? JSONSerialization.jsonObject(with: data!) as! [String:[String]]
        for exercise in initialExercises!{
            
            let category = ExerciseCategory(context: context)
            category.name = exercise.key
            
            for item in exercise.value{
            
                let type = ExerciseType(context: context)
                type.name = item
                type.category = category
            }
        }
        
        try? context.save()
        defaults.set(true, forKey: "areExercisesImported")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if firstLoad == false {
            
            updateUI()
        }
        firstLoad = false
    }
    
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Training>?
    
    fileprivate func updateUI(){
        
        let request: NSFetchRequest<Training> = Training.fetchRequest()
        let selector = #selector(NSDate.compare(_:))
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false, selector: selector)]
        request.fetchLimit = 10
        request.predicate = NSPredicate(format: "exercises.@count > 0")
        fetchedResultsController = NSFetchedResultsController<Training>(
            
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "month",
            cacheName: nil
        )
        try? fetchedResultsController?.performFetch()
            
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "training", for: indexPath)
        if let training = fetchedResultsController?.object(at: indexPath) {
           
            
            cell.detailTextLabel?.text =  training.getUserFriendlydate()
            cell.textLabel?.text = training.getAllExerciceCategories()
            TrainingsTableViewController.currentColor = cell.backgroundColor
            
        }
        return cell
    }

    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let headerText = UILabel()
        headerText.textColor = .black
        headerText.font = UIFont(name: "Avenir-Book", size: 12.0)
        headerText.textAlignment = .right
        headerText.text = fetchedResultsController?.sections?[section].name
        headerText.backgroundColor = tableView.backgroundColor

        return headerText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "New Training" {
            
            if let VC = segue.destination as? AddExerciseTableViewController {
                    
                VC.training = TrainingsTableViewController.todaysTraining
            }
        }
        
        if segue.identifier == "Existing Training" {
            
            if let VC = segue.destination as? ExercisesTableViewController {
                
                if let cell = sender as? UITableViewCell{
                    
                    let indexPath = tableView.indexPath(for: cell)
                    let currentTraining = (fetchedResultsController?.object(at: indexPath!))! as Training
                    VC.training = currentTraining
                    VC.title = currentTraining.getUserFriendlydate()
                    
                }
            }
        }
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
      return (fetchedResultsController?.sections!.count)!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return (fetchedResultsController?.sections![sectionIndex].numberOfObjects)!
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
     
        return fetchedResultsController?.sections?[section].name
        
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
