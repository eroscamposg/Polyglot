//
//  ViewController.swift
//  Polyglot
//
//  Created by Eros Campos on 7/31/20.
//  Copyright © 2020 Eros Campos. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    //Tranlations dictionary
    let cellIdentifier: String = "WordCell"
    var words = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    //MARK: - Initial Setup
    func initialSetup() {
        if let defaults = UserDefaults(suiteName: Constants.groupName){
            if let savedWords = defaults.object(forKey: "Words") as? [String] {
                words = savedWords
            } else {
                saveInitialValues(to: defaults)
            }
                        
            //Style configuration
            let titleAtributes = [NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter", size: 22)!]
            
            navigationController?.navigationBar.titleTextAttributes = titleAtributes
            title = "POLYGLOT"
            
            //Test configuration
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(startTest))
            
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "End Test", style: .plain, target: nil, action: nil)
        }
    }
    
    func saveInitialValues(to defaults: UserDefaults) {
        words.append("bear::l'ours")
        words.append("camel::le chameau")
        words.append("cow::la vache")
        words.append("fox::le renard")
        words.append("goat::la chèvre")
        words.append("monkey::le singe")
        words.append("pig::le cochon")
        words.append("rabbit::le lapin")
        words.append("sheep::le mouton")
        defaults.set(words, forKey: "Words")
    }

    
        
    //MARK: - Table View Delegate and DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return words.count
        }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            let word = words[indexPath.row]
            
            let split = word.components(separatedBy: "::")
            
            cell.textLabel?.text = split[0]
            
            cell.detailTextLabel?.text = ""
            
            return cell
        }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.detailTextLabel?.text == "" {
                    let word = words[indexPath.row]
                    let split = word.components(separatedBy: "::")
                    cell.detailTextLabel?.text = split[1]
                } else {
                    cell.detailTextLabel?.text = ""
                }
            }
        }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit", handler: { action, view, completion in
            //Create our alert controller
            let ac = UIAlertController(title: "Edit word", message: nil, preferredStyle: .alert)
            
            //Add two text fields, one for English and one for French
            ac.addTextField(configurationHandler: { textField in
                textField.text = self.words[indexPath.row].components(separatedBy: "::")[0]
            })
            
            ac.addTextField(configurationHandler: { textField in
                textField.text = self.words[indexPath.row].components(separatedBy: "::")[1]
            })
            
            //Create an "Add Word" button that submits the user's input
            let submitAction = UIAlertAction(title: "Finish", style: .default, handler: { [unowned self, ac] (action: UIAlertAction!) in
                
                //Pull out the English and French words, or an empty string if there was a problem
                let firstWord = ac.textFields?[0].text ?? ""
                let secondWord = ac.textFields?[1].text ?? ""
                
                self.editFlashcard(first: firstWord, second: secondWord, indexPath: indexPath)
            })
            
            //Add the submit action, plus a cancel button
            ac.addAction(submitAction)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        
            //Present the alert controller to the user
            self.present(ac, animated: true)
            completion(true)
        })
                
        edit.image = UIImage(systemName: "pencil")
        
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: { action, view, completion in
            self.words.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveWords()
            completion(true)
        })
        
        delete.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
        
    //MARK: - Custom Functions
    //Start adding new words
    @IBAction func addNewWord(_ sender: UIBarButtonItem) {
        //Create our alert controller
        let ac = UIAlertController(title: "Add new word", message: nil, preferredStyle: .alert)
        
        //Add two text fields, one for English and one for French
        ac.addTextField(configurationHandler: { textField in
            textField.placeholder = "English"
        })
        
        ac.addTextField(configurationHandler: { textField in
            textField.placeholder = "French"
        })
        
        //Create an "Add Word" button that submits the user's input
        let submitAction = UIAlertAction(title: "Add Word", style: .default, handler: { [unowned self, ac] (action: UIAlertAction!) in
            
            //Pull out the English and French words, or an empty string if there was a problem
            let firstWord = ac.textFields?[0].text ?? ""
            let secondWord = ac.textFields?[1].text ?? ""
            
            //Submit the English and French word to the insertFlashcard() method
            self.insertFlashcard(first: firstWord, second: secondWord)
        })
        
        //Add the submit action, plus a cancel button
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        //Present the alert controller to the user
        present(ac, animated: true)
    }
    
    @objc func startTest() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Test") as? TestViewController else {
            return
        }
        
        vc.words = words
        navigationController?.pushViewController(vc, animated: true)
    }

    func saveWords() {
        //Save in the Group App UserDefaults
        if let defaults = UserDefaults(suiteName: Constants.groupName){
            defaults.set(words, forKey: "Words")
        }
    }

    //MARK: - Flashcard Functions
    func insertFlashcard(first: String, second: String) {
        //Make sure the TextFields arent empty
        guard first.count > 0 && second.count > 0 else {
            return
        }
        
        //Create a new index for the word
        let newIndexPath = IndexPath(row: words.count, section: 0)
        
        words.append("\(first)::\(second)")
        
        //Insert the word in the row
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        self.saveWords()
    }
    
    func editFlashcard(first: String, second: String, indexPath: IndexPath) {
        //Make sure the TextFields arent empty
        guard first.count > 0 && second.count > 0 else {
            return
        }
        
        words[indexPath.row] = "\(first)::\(second)"
        self.saveWords()
        tableView.reloadData()
    }
    
}

