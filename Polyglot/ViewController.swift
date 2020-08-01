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
    var words = [String]()
    private var dataSource: WordsDataSource?

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
            
            //Assign the DataSource and the TableDelegate to WordsDataSource
            self.dataSource = WordsDataSource(self.words)
            self.tableView.dataSource = self.dataSource
            self.tableView.delegate = self.dataSource
            
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
    
    func insertFlashcard(first: String, second: String) {
        //Make sure the TextFields arent empty
        guard first.count > 0 && second.count > 0 else {
            return
        }
        
        //Create a new index for the word
        let newIndexPath = IndexPath(row: words.count, section: 0)
        
        //Update the DataSource array of words
        words.append("\(first)::\(second)")
        self.dataSource?.updateItems(words)
        
        //Insert the word in the row
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        self.dataSource?.saveWords()
    }
    
    @objc func startTest() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Test") as? TestViewController else {
            return
        }
        
        vc.words = words
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

