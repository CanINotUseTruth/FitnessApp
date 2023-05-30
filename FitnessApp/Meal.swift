//
//  Meal.swift
//  FitnessApp
//
//  Created by Sonny on 27/5/2023.
//

//import Foundation
//
//struct Meal {
//    var name: String
//    var food: [Food]?
//
////    static func == (lhs: Meal, rhs: Meal) -> Bool {
////        return lhs.name == rhs.name
////    }
////    func hash(into hasher: inout Hasher) {
////        hasher.combine(name)
////    }
//}
//
//struct MealHeaders {
//    var type: String
//}
//
////
////  Meal.swift
////  FitnessApp
////
////  Created by Sonny on 27/5/2023.
////
import Foundation

struct Meal {
    var category: String
    var name: String
    var calories: Int?
}
