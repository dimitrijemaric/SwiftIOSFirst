//
//  CreateSetViewController.swift
//  LiftBro
//
//  Created by Ari Gold on 6/19/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import UIKit
import CoreData



class CreateSetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        updateSetCreationView()
        updateSetsTable()
        repsField.delegate = self
        WeightField.delegate = self
        durationField.delegate = self
        noteField.delegate = self
        
    }
    
    var noteFieldLimit = 15
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let enteredCharSet = CharacterSet(charactersIn: string)
        let allowedChars = CharacterSet.decimalDigits
        
        if (textField == repsField){
            
            return allowedChars.isSuperset(of: enteredCharSet) || !enteredCharSet.contains(".")
        }
        else if (textField == WeightField || textField == durationField)
        {
      
            return allowedChars.isSuperset(of: enteredCharSet)
   
        }
        else if (textField == noteField){
            
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= noteFieldLimit
            
        }
        
        return false
    }
    @IBAction func repsFieldChanged(_ sender: UITextField) {
        
                repsStepper.value = Double(sender.text!)!
            }
   
    @IBAction func durationFieldChanged(_ sender: UITextField) {
        
        durationStepper.value = Double(sender.text!)!
    }
    
    @IBAction func weightFieldChanged(_ sender: UITextField) {
        
        weightStepper.value = Double(sender.text!)!
    }
    
    @IBOutlet weak var repsStepper: UIStepper!
  
    @IBOutlet weak var weightStepper: UIStepper!

    @IBOutlet weak var durationStepper: UIStepper!
    
    
    
    @IBOutlet weak var repsField: UITextField!
    
    @IBOutlet weak var durationField: UITextField!
    
    @IBOutlet weak var WeightField: UITextField!
    
    

    
    
    
    @IBAction func weightStepperChanged(_ sender: UIStepper) {
        WeightField.text = String(Double(weightStepper.value))
        
    }
    
    @IBAction func repsStepperChanged(_ sender: UIStepper) {
            repsField.text = String(Int16(repsStepper.value))
            }
    
    @IBAction func durationStepperChanged(_ sender: UIStepper) {
        durationField.text = String(Double(durationStepper.value))
    }
    
    
    
    
    
    
    var currentExercise: Exercise?{
        
        didSet{self.title = currentExercise!.name}
    }
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<ExerciseSet>?
    
    func updateSetCreationView(){
    
        if (currentExercise?.isDurationExercise == true) {
            
         
        }
    }
    
    func updateSetsTable() {
    
        let request: NSFetchRequest<ExerciseSet> = ExerciseSet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.predicate = NSPredicate(format: "exercise.type.name = %@", (currentExercise?.type?.name)!)
        request.fetchLimit = 20
        fetchedResultsController = NSFetchedResultsController<ExerciseSet>(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "exercise.training.friendlyDate",
            cacheName: nil
        )
        try? fetchedResultsController?.performFetch()
        tableview.reloadData()
    }
    
    //core data
    
     let container = AppDelegate.container
    
     var context :  NSManagedObjectContext {
        
        return container.viewContext
    }
    
    
    
    
    //actions and outlets
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var noteField: UITextField!
    
    @IBAction func SaveSet(_ sender: UIButton) {
        
        
        if repsField.text != nil && repsField.text != "" && Int16(repsField.text!)! > 0 {
        
        let newSet = ExerciseSet(context: context)
        newSet.weight = Double(WeightField.text!)!
        newSet.reps = Int16(repsField.text!)!
        newSet.level = noteField.text!
        newSet.exercise = self.currentExercise
        
        if (isToday(date: (currentExercise?.training?.date)!)){
            
            newSet.date = currentExercise?.training?.date
        }
        else {
        
            newSet.date = Date() as NSDate?
        }
        try? context.save()
        print ("\(newSet.exercise?.training?.date)")
        updateSetsTable()
        }
    }

    func isToday(date:NSDate) -> Bool{
    
        if date as Date > Calendar.current.startOfDay(for: Date()) {return true}
        return false
    }
    
    @IBAction func ShowExerciseHistory(_ sender: UIButton) {
    }
    
    @IBAction func RepsStepperChanged(_ sender: UIStepper) {
    }
    @IBAction func WeightStepperChanged(_ sender: UIStepper) {
    }
        
    
    
    
    
    
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    /*
    
    fileprivate var fetchedResultsController: NSFetchedResultsController<Exercise>?
    
    
    
    fileprivate func updateSetUI()
    {
        let setRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest() as! NSFetchRequest<Exercise>
        let selector = #selector(NSString.caseInsensitiveCompare(_:))
        setRequest.sortDescriptors = [NSSortDescriptor(key: "training.date", ascending: false, selector: selector)]
        setRequest.predicate = NSPredicate(format: "name = %@", "")
        setRequest.fetchLimit = 10
        
        
        
        
        fetchedResultsController = NSFetchedResultsController<Exercise>(
            fetchRequest: setRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "training.date",
            cacheName: nil
        )
        
        try? fetchedResultsController?.performFetch()
        
        
        tableView.reloadData()
        
        
    }
    

    
    
    
    
    
    */
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let sectionCount = (fetchedResultsController?.sections!.count)!
       return sectionCount
       
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (fetchedResultsController?.sections![sectionIndex].numberOfObjects)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return fetchedResultsController?.sections?[section].name
        
        
    }
    
    
  
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        
        let headerText = UILabel()
        headerText.textColor = .black
        headerText.font = UIFont(name: "Avenir-Book", size: 12.0)
        headerText.textAlignment = .right
        headerText.text = fetchedResultsController?.sections?[section].name
        headerText.backgroundColor = tableview.backgroundColor
        
        
        return headerText
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercise set", for: indexPath)
        if let set = fetchedResultsController?.object(at: indexPath){
            
            cell.textLabel?.text = "\(set.weight)kg x \(set.reps)"
            cell.detailTextLabel?.text = set.level ?? ""
        }
        return cell
    }
    
    
    //fetched results delegate methods
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableview.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        switch type {
        case .insert: tableview.insertSections([sectionIndex], with: .fade)
        case .delete: tableview.deleteSections([sectionIndex], with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            tableview.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableview.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableview.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableview.deleteRows(at: [indexPath!], with: .fade)
            tableview.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableview.endUpdates()
    }

    
    

}
