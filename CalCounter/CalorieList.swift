//
//  CalorieList.swift
//  CalCounter
//
//  Created by Kristopher Schrieken on 9/28/19.
//  Copyright © 2019 Kristopher Schrieken. All rights reserved.
//

import Foundation

class CalorieList {
    
    var food: String
    var calories: Int
    
    // initialize the cells
    public init(food: String, calories: Int) {
        
        self.food = food;
        self.calories = calories;
        
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
