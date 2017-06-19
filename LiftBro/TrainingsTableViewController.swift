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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        print("viewdidload")
     // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       updateUI()
        print("viewwillload")
    }
    
    
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Training>?
    
    private func updateUI()
    {   if let context = container?.viewContext {
        let request: NSFetchRequest<Training> = Training.fetchRequest()
        let selector = #selector(NSString.caseInsensitiveCompare(_:))
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false, selector: selector)]
        request.fetchLimit = 10
        fetchedResultsController = NSFetchedResultsController<Training>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "month",
            cacheName: nil
        )
        try? fetchedResultsController?.performFetch()
        
        
        tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "training", for: indexPath)
        if let training = fetchedResultsController?.object(at: indexPath) {
            cell.detailTextLabel?.text =  training.getUserFriendlydate()
            cell.textLabel?.text = training.getAllExerciceTypes()
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "New Training" {
            if let VC = segue.destination as? ExercisesTableViewController {
                    
                VC.training = Training(context: (container?.viewContext)!)
                VC.training?.date = Date.random() as NSDate?
                VC.isNewTraining = true
               
                        //try? container?.viewContext.save()
                 
                           }
        }
        
        if segue.identifier == "Existing Training" {
            if let VC = segue.destination as? ExercisesTableViewController {
                
                
                if let cell = sender as? UITableViewCell{
                    
                    let indexPath = tableView.indexPath(for: cell)
                    VC.training = fetchedResultsController?.object(at: indexPath!)}
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
