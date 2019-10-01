//
//  CalorieList.swift
//  CalCounter
//
//  Created by Kristopher Schrieken on 9/28/19.
//  Copyright © 2019 Kristopher Schrieken. All rights reserved.
//

import Foundation

class CalorieList: NSObject, NSCoding {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("food")
    
    var food: String
    var calories: Int
    
    // initialize the cells
    public init(food: String, calories: Int) {
        
        self.food = food;
        self.calories = calories;
        
    }
    
    required  init?(coder aDecoder: NSCoder)
    {
        // Try to unserialize the "title" variable
        if let food = aDecoder.decodeObject(forKey: "food") as? String
        {
            self.food = food
        }
        else
        {
            // no food key
            return nil
        }

        // Check if the key "done" exists, since decodeBool() always succeeds
        if let calories = aDecoder.decodeObject(forKey: "calories") as? Int
        {
            self.calories = calories
        }
        else
        {
            // no calorie key
            return nil
        }
        
    }

    func encode(with aCoder: NSCoder)
    {
        // Store the objects into the coder object
        aCoder.encode(self.food, forKey: "food")
        aCoder.encode(self.calories, forKey: "calories")
    }
    
    
}

extension CalorieList {
    
    public class func getExampleData() -> [CalorieList] {
        
        return [
            CalorieList( food: "Pizza", calories: 200 ),
            CalorieList( food: "Chocolate", calories: 150),
            CalorieList( food: "Mango", calories: 120 )
        ]
    }
}

