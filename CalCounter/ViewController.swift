//
//  ViewController.swift
//  CalCounter
//
//  Created by Kristopher Schrieken on 9/28/19.
//  Copyright © 2019 Kristopher Schrieken. All rights reserved.
//


import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var totalCalories = 0;
    
    private var foodList: [CalorieList] = []
    
    @IBOutlet weak var calCounter: UITableView!
    
    @IBOutlet weak var calLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
         return foodList.count
     }

    // go through calorie list to put into cells
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell = calCounter.dequeueReusableCell(withIdentifier: "food_item", for: indexPath)

        if indexPath.row < foodList.count
        {
            let item = foodList[indexPath.row]
            cell.textLabel?.text = item.food
            
            let cals = "\(item.calories)"
            cell.detailTextLabel?.text = cals
            
        }

        return cell
     }
    
    // remove cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < foodList.count
        {
            foodList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
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
                        self.updateTracker()
                    }
                }))
                
                self.present( alert2, animated: true, completion: nil )
                
            }
        }))
        
        // Present the alert to the user
        self.present( alert1, animated: true, completion: nil )
      
    }

    // updates foodList array with new food item
    private func addFood( food: String, calories: Int )
    {
        // The index of the new item will be the current item count
        let newIndex = foodList.count

        // Create new item and add it to the todo items list
        foodList.append(CalorieList(food: food, calories: calories))

        // Tell the table view a new row has been created
        calCounter.insertRows( at: [IndexPath(row: newIndex, section: 0)], with: .top )
    }
    
    // updates the calorie tracker
    private func updateTracker() {
        
        calLabel.text = "\(totalCalories)" + "/2000 Daily Calories"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
       self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButton(_:)))
     
    }


}

