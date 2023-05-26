//
//  MealTrackerViewController.swift
//  FitnessApp
//
//  Created by Sonny on 26/5/2023.
//

import UIKit

class MealTableViewController: UITableViewController {
    var meals: [String: [Meal]] = [:]
    var mealSections: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpHeaders()
        addMeal()
    }

    func setUpHeaders() {
        mealSections = ["Breakfast", "Lunch", "Dinner"]
        for section in mealSections {
            meals[section] = []
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mealSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = mealSections[section]
        return meals[sectionTitle]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath)
        let sectionTitle = mealSections[indexPath.section]
        if let mealsInSection = meals[sectionTitle], indexPath.row < mealsInSection.count {
            let meal = mealsInSection[indexPath.row]
            cell.textLabel?.text = meal.name
            cell.detailTextLabel?.text = meal.calories
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mealSections[section]
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
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let mealCategory = alertController.textFields?.first?.text,
                  let mealName = alertController.textFields?[1].text,
                  let calories = alertController.textFields?.last?.text
            else {
                return
            }
            self?.addNewMeal(category: mealCategory, name: mealName, calories: calories)
        })

        present(alertController, animated: true, completion: nil)
    }

    func addNewMeal(category: String, name: String, calories: String) {
        let newMeal = Meal(category: category, name: name, calories: String(calories + " calories"))

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

        tableView.reloadData()
    }
}



