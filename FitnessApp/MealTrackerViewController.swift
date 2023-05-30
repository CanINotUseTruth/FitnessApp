//
//  MealTrackerViewController.swift
//  FitnessApp
//
//  Created by Sonny on 26/5/2023.
//s

import UIKit

class MealTableViewController: UITableViewController {
    
    // setup variables
    var meals: [String: [Meal]] = [:]
    var mealSections: [String] = []
    var totalCalories: Int = 0
    var calorieGoal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMeal()
        addCalorieGoalSection()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return mealSections.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Calorie goal section has only 1 row
        } else {
            let sectionTitle = mealSections[section - 1]
            return meals[sectionTitle]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // Calorie goal section
            let cell = tableView.dequeueReusableCell(withIdentifier: "calorieGoalCell", for: indexPath)
            cell.textLabel?.text = "Calorie Goal"
            if let goal = calorieGoal {
                let remainingCalories = max(goal - totalCalories, 0)
                cell.detailTextLabel?.text = "\(remainingCalories) calories left"
            } else {
                cell.detailTextLabel?.text = "Not Set"
            }
            return cell
        } else {
            // Meal sections
            let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
            let sectionTitle = mealSections[indexPath.section - 1]
            if let mealsInSection = meals[sectionTitle], indexPath.row < mealsInSection.count {
                let meal = mealsInSection[indexPath.row]
                cell.textLabel?.text = meal.name
                cell.detailTextLabel?.text = meal.calories
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil // No header for calorie goal section
        } else {
            return mealSections[section - 1]
        }
    }
    
    public func addMeal() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addMealButtonPressed)
        )
    }
    
    @objc func addMealButtonPressed() {
        let alertController = UIAlertController(title: "Add Meal", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Meal Category"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Meal Name"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Calories"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let mealCategory = alertController.textFields?.first?.text,
                  let mealName = alertController.textFields?[1].text,
                  let caloriesString = alertController.textFields?.last?.text,
                  let calories = Int(caloriesString)
            else {
                return
            }
            self?.addNewMeal(category: mealCategory, name: mealName, calories: calories)
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    func addNewMeal(category: String, name: String, calories: Int) {
        let newMeal = Meal(category: category, name: name, calories: "\(calories) calories")
        
        if let existingSectionIndex = mealSections.firstIndex(of: category) {
            let sectionTitle = mealSections[existingSectionIndex]
            meals[sectionTitle]?.append(newMeal)
        } else {
            if var existingMeals = meals[category] {
                existingMeals.append(newMeal)
                meals[category] = existingMeals
            } else {
                meals[category] = [newMeal]
                mealSections.append(category)
            }
        }
        
        totalCalories += calories
        tableView.reloadData()
        print("Total Calories: \(totalCalories)")
    }
    
    func addCalorieGoalSection() {
        let alertController = UIAlertController(title: "Set Calorie Goal", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Calorie Goal:"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Set", style: .default) { [weak self] _ in
            guard let calorieGoalString = alertController.textFields?.first?.text,
                  let calorieGoal = Int(calorieGoalString)
            else {
                return
            }
            self?.setCalorieGoal(calorieGoal)
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setCalorieGoal(_ goal: Int) {
        calorieGoal = goal
        tableView.reloadData()
        print("Calorie Goal set: \(goal) calories")
    }
}
