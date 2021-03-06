//
//  SettingsTableViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 7/25/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, PassChosenUnitDelegate, UITextFieldDelegate {

    
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        weightIncrement.text = "\(defaults.double(forKey: "weightIncrement"))"
        repsIncrement.text = "\(defaults.integer(forKey: "repsIncrement"))"
        durationIncrement.text = "\(defaults.double(forKey: "durationIncrement"))"
       unitLabel.text = "\(defaults.string(forKey: "measureUnit")!)"
        
        weightIncrement.delegate = self
        repsIncrement.delegate = self
        durationIncrement.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @IBOutlet weak var repsIncrement: UITextField!

    @IBOutlet weak var unitLabel: UILabel!
    
    @IBAction func weightIncrementChanged(_ sender: UITextField) {
        defaults.set(Double(sender.text!), forKey: "weightIncrement")
    }
    
    @IBAction func repsIncrementChanged(_ sender: UITextField) {
        defaults.set(Double(sender.text!), forKey: "repsIncrement")

    }
    @IBAction func durationIncrementChanged(_ sender: UITextField) {
        defaults.set(Double(sender.text!), forKey: "durationIncrement")

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func unwindToSettingsMenu(segue: UIStoryboardSegue){
    
        //
    }
    
    
    
    @IBOutlet weak var weightIncrement: UITextField!
    
    
    @IBOutlet weak var durationIncrement: UITextField!
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
        return 5
    }
    
    func didChose(measureUnit unit: String) {
        unitLabel.text = unit
        defaults.set(unit, forKey:"measureUnit")
        tableView.reloadData()
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "Choose Measure Unit"{
        
            if let vcMUnit = segue.destination as? MeasuringUnitTableViewController{
            
                vcMUnit.unitOptionDelegate = self
                vcMUnit.navigationItem.hidesBackButton = true
               
                vcMUnit.modalPresentationStyle = .custom
            }
        }
        
        
        
    }
    

}
