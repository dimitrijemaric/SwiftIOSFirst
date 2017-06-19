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
            updateUI()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Exercise>?
    
    public var training : Training? {
    
        didSet{
            
            updateUI()
        }
        
    }
    public var isNewTraining : Bool = false
    
    private func updateUI()
    {   if let context = container?.viewContext {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let selector = #selector(NSString.caseInsensitiveCompare(_:))
        request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: false, selector: selector)]
        request.predicate = NSPredicate(format: "training = %@", training!)
        request.fetchLimit = 40
        fetchedResultsController = NSFetchedResultsController<Exercise>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "type",
            cacheName: nil
        )
        try? fetchedResultsController?.performFetch()
        
        
        tableView.reloadData()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "training exercise", for: indexPath)

        
        if let exercise = fetchedResultsController?.object(at: indexPath) {
             cell.textLabel?.text = exercise.name
            cell.detailTextLabel?.text = "Volume: " + String(exercise.getExerciseVolume())
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
