//
//  ViewController.swift
//  CalCounter
//
//  Created by Kristopher Schrieken on 9/28/19.
//  Copyright © 2019 Kristopher Schrieken. All rights reserved.
//


import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var totalCalories = 0
    
    private var savedTC: [NSManagedObject] = []
    
    private var foodList: [NSManagedObject] = []
    
    @IBOutlet weak var calCounter: UITableView!
    
    @IBOutlet weak var calLabel: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
         return foodList.count
     }

    // go through calorie list to put into cells
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        
        let item = foodList[ indexPath.row ]
        let cell = calCounter.dequeueReusableCell(withIdentifier: "food_item", for: indexPath)

        cell.textLabel?.text = item.value(forKeyPath: "food") as? String
        
        let cals = item.value(forKeyPath: "calories") as? Int
        cell.detailTextLabel?.text = "\(cals ?? 0)"
        return cell
        
     }
    
    // remove cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < foodList.count
        {
            let removedCals = foodList[ indexPath.row ].value(forKeyPath:"calories") as? Int ?? 0
            totalCalories -= removedCals
            foodList.remove(at: indexPath.row)
            self.deleteData( row: indexPath.row )
            calCounter.deleteRows(at: [indexPath], with: .top)
            self.updateTotalCalories()
            self.updateTracker()
        }
    }
    
    // when + button is pressed new cell is created to add food and calories
    @objc func didTapAddItemButton(_ sender: UIBarButtonItem)
    {
        
        // to get name of food
        let alert1 = UIAlertController(
            title: "Food Item",
            message: "Insert name of food eaten",
            preferredStyle: .alert)

        // Add a text field to the alert for the new item's title
        alert1.addTextField(configurationHandler: nil)

        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert1.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Add a "Submit" button to the alert.
        alert1.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            if let item = alert1.textFields?[0].text
            {
                var calories = 0
                let food = item
                
                // to get calories
                let alert2 = UIAlertController(
                    title: "Calories",
                    message: "Insert calories consumed",
                    preferredStyle: .alert)

                // Add a text field to the alert for the new item's title
                alert2.addTextField(configurationHandler: nil)

                // Add a "cancel" button to the alert. This one doesn't need a handler
                alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

                // Add a "Submit" button to the alert.
                alert2.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
                    if let cals = alert2.textFields?[0].text
                    {
                        calories = Int(cals) ?? 0
                        self.addFood(food: food, calories: calories)
                        self.totalCalories += calories
                        self.updateTotalCalories()
                        self.updateTracker()
                    }
                }))
                
                self.present( alert2, animated: true, completion: nil )
                
            }
        }))
        
        // Present the alert to the user
        self.present( alert1, animated: true, completion: nil )
      
    }
    
    @objc private func didTapDelete( _ sender: UIBarButtonItem ) {
        
        let alert = UIAlertController(
            title: "Reset Counter?",
            message: "",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil ))
        
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
             
            self.foodList.removeAll()
            self.deleteAllData()
            self.calCounter.reloadData()
            self.totalCalories = 0
            self.updateTotalCalories()
            self.updateTracker()
            
        }))
        
        self.present( alert, animated: true, completion: nil )
        
    }

    // updates foodList array with new food item
    private func addFood( food: String, calories: Int )
    {
        // saving data to core data
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let entity =
          NSEntityDescription.entity(forEntityName: "CalorieList",
                                     in: managedContext)!
        
        let list = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // add food and calories
        list.setValue(food, forKeyPath: "food")
        list.setValue(calories, forKeyPath: "calories")
        
        // save to core data
        do {
            
          try managedContext.save()
          foodList.append(list)
            
        } catch let error as NSError {
            
          print("Could not save. \(error), \(error.userInfo)")
            
        }
     
        calCounter.reloadData()
    }
    
    // updates the calorie tracker
    private func updateTracker() {
        
        calLabel.text = "\(totalCalories)" + "/2000 Daily Calories"
        
    }
    
    func deleteData(row: Int) {
        
      // saving data to core data
         guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return
         }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CalorieList")
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            
            let itemToDelete = data[ row ]
            
            managedContext.delete( itemToDelete )
            
            do {
                
                try managedContext.save()
                
            } catch{
                
                print( "Didn't Save" )
                
            }
            
        } catch {
            print( "Couldn't fetch " )
        }
        
    }
    
    func deleteAllData() {
        
        // saving data to core data
        guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
                return
        }
              
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CalorieList")
              
        do {
            let data = try managedContext.fetch(fetchRequest)
                
            for itemToDelete in data {
                
            managedContext.delete( itemToDelete )
                    
            }
            do {
                      
                try managedContext.save()
                      
            } catch{
                      
                print( "Didn't Save." )
                      
            }
        } catch {
            
          print( "Couldn't fetch " )
            
        }
        
    }
    
    // save the initial total calories at start of app
    func saveTotalCalories() {
  
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
        }
               
               
        let managedContext = appDelegate.persistentContainer.viewContext
               
        let entity = NSEntityDescription.entity(forEntityName: "TotalCalories", in: managedContext)!
               
        let list = NSManagedObject(entity: entity, insertInto: managedContext)
                
        // add calories to data
        list.setValue(totalCalories, forKeyPath: "total")
        
        do {
             try managedContext.save()
           } catch let error as NSError {
             print("Could not save. \(error), \(error.userInfo)")
           }
        
    }
    
    func updateTotalCalories() {
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TotalCalories")
        do {
            let data = try managedContext.fetch(fetchRequest)
            
            let update = data[0]
            update.setValue( totalCalories, forKeyPath: "total")
            do {
                
                try managedContext.save()
                } catch let error as NSError {
                  print("Could not save. \(error), \(error.userInfo)")
                }
            
        } catch {
            print( "Couldn't fetch" )
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButton(_:)))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(ViewController.didTapDelete(_:)))
        
        self.saveTotalCalories()
     
    }
    
 override func viewWillAppear(_ animated: Bool) {
   super.viewWillAppear(animated)
   
   
   guard let appDelegate =
     UIApplication.shared.delegate as? AppDelegate else {
       return
   }
   
   let managedContext = appDelegate.persistentContainer.viewContext
   
   
   let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CalorieList")
   let fR = NSFetchRequest<NSManagedObject>(entityName: "TotalCalories")
   
   do {
    
     foodList = try managedContext.fetch(fetchRequest)
     savedTC = try managedContext.fetch(fR)
     totalCalories = savedTC[0].value( forKeyPath: "total" ) as? Int ?? 0
     updateTracker()
    
   } catch let error as NSError {
     print("Could not fetch. \(error), \(error.userInfo)")
   }
    
 }

} // end of class

