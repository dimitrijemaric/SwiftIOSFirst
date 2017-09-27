//
//  FullHistoryTableViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 8/14/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit
import CoreData

class FullHistoryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDataSource()
        tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    deinit {
        print("deinit fullhistory")
    }
    
    let defaults = UserDefaults.standard
    var isDurationExercise = false
    
   
    weak var fetchedResultsController : NSFetchedResultsController<ExerciseSet>?
    
   
    // MARK: - Table view data source

    
    func updateDataSource(){
    
        fetchedResultsController?.fetchRequest.fetchLimit = 10000
        try? fetchedResultsController?.performFetch()
   
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       
        let sectionCount = (fetchedResultsController?.sections!.count)!
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (fetchedResultsController?.sections![sectionIndex].numberOfObjects)!
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
           return fetchedResultsController?.sections?[section].name
        
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercise set full", for: indexPath)
        if let set = fetchedResultsController?.object(at: indexPath){
            if isDurationExercise == false{
                
                cell.textLabel?.text = "\(set.weight)" + defaults.string(forKey: "measureUnit")! + "s "  + "x \(set.reps)"
                
            }
            else{
                
                cell.textLabel?.text = "\(set.duration) minutes"
            }
            cell.detailTextLabel?.text = set.level ?? ""
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
