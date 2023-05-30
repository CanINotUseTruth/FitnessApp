//
//  MealTrackerViewController.swift
//  FitnessApp
//
//  Created by Sonny on 26/5/2023.


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
                if let calories = meal.calories {
                    cell.detailTextLabel?.text = "\(calories) calories"
                } else {
                    cell.detailTextLabel?.text = "Unknown"
                }
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
                self?.showInvalidInputAlert {
                    self?.addMealButtonPressed()
                }
                return
            }
            self?.addNewMeal(category: mealCategory, name: mealName, calories: calories)
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    func addNewMeal(category: String, name: String, calories: Int) {
        // to make inputs case insensitive and eliminate any trailing/leading whitespace
        let cleanedCategory = category.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let newMeal = Meal(category: cleanedCategory, name: name, calories: calories)
        
        if let existingSectionIndex = mealSections.firstIndex(where: { $0.lowercased() == cleanedCategory }) {
            let sectionTitle = mealSections[existingSectionIndex]
            meals[sectionTitle]?.append(newMeal)
        } else {
            if var existingMeals = meals[cleanedCategory] {
                existingMeals.append(newMeal)
                meals[cleanedCategory] = existingMeals
            } else {
                meals[cleanedCategory] = [newMeal]
                mealSections.append(cleanedCategory)
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
                self?.showInvalidInputAlert {
                    self?.addCalorieGoalSection()
                }
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
    
    func showInvalidInputAlert(completion: (() -> Void)?) {
        let alertController = UIAlertController(title: "Invalid Input", message: "Please enter valid inputs.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Calorie goal section, allow editing
            editCalorieGoal()
        } else {
            // Meal sections, allow editing
            let sectionTitle = mealSections[indexPath.section - 1]
            if let mealsInSection = meals[sectionTitle], indexPath.row < mealsInSection.count {
                let meal = mealsInSection[indexPath.row]
                editMeal(meal)
            }
        }
    }
    
    func editMeal(_ meal: Meal) {
        let alertController = UIAlertController(title: "Edit Meal", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = meal.category
        }
        
        alertController.addTextField { textField in
            textField.text = meal.name
        }
        
        alertController.addTextField { textField in
            if let calories = meal.calories {
                textField.text = "\(calories)"
            }
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let mealCategory = alertController.textFields?.first?.text,
                  let mealName = alertController.textFields?[1].text,
                  let caloriesString = alertController.textFields?.last?.text,
                  let calories = Int(caloriesString)
            else {
                self?.showInvalidInputAlert(completion: nil)
                return
            }
            self?.updateMeal(meal, category: mealCategory, name: mealName, calories: calories)
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateMeal(_ meal: Meal, category: String, name: String, calories: Int) {
        // Remove the meal from the previous category
        if let sectionIndex = mealSections.firstIndex(where: { $0.lowercased() == meal.category.lowercased() }),
           let mealsInSection = meals[meal.category],
           let mealIndex = mealsInSection.firstIndex(where: { $0.name == meal.name }) {
            meals[meal.category]?.remove(at: mealIndex)
            if meals[meal.category]?.isEmpty == true {
                meals[meal.category] = nil
                mealSections.remove(at: sectionIndex)
            }
        }
        
        // Add the updated meal
        let cleanedCategory = category.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let updatedMeal = Meal(category: cleanedCategory, name: name, calories: calories)
        
        if let existingSectionIndex = mealSections.firstIndex(where: { $0.lowercased() == cleanedCategory }) {
            let sectionTitle = mealSections[existingSectionIndex]
            meals[sectionTitle]?.append(updatedMeal)
        } else {
            if var existingMeals = meals[cleanedCategory] {
                existingMeals.append(updatedMeal)
                meals[cleanedCategory] = existingMeals
            } else {
                meals[cleanedCategory] = [updatedMeal]
                mealSections.append(cleanedCategory)
            }
        }
        
        // Update total calories
        totalCalories -= meal.calories ?? 0
        totalCalories += calories
        
        tableView.reloadData()
        print("Total Calories: \(totalCalories)")
    }
    
    func editCalorieGoal() {
        let alertController = UIAlertController(title: "Edit Calorie Goal", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            if let goal = self.calorieGoal {
                textField.text = "\(goal)"
            }
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let calorieGoalString = alertController.textFields?.first?.text,
                  let calorieGoal = Int(calorieGoalString)
            else {
                self?.showInvalidInputAlert(completion: nil)
                return
            }
            self?.updateCalorieGoal(calorieGoal)
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateCalorieGoal(_ goal: Int) {
        calorieGoal = goal
        tableView.reloadData()
        print("Calorie Goal set: \(goal) calories")
    }
}
