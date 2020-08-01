//
//  WordsDataSource.swift
//  Polyglot
//
//  Created by Eros Campos on 7/31/20.
//  Copyright © 2020 Eros Campos. All rights reserved.
//

import UIKit

class WordsDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifier: String = "WordCell"
    private var words: [String]
    
    init(_ words: [String]) {
        self.words = words
    }
    
    //MARK: - Table View Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let word = words[indexPath.row]
        
        let split = word.components(separatedBy: "::")
        
        cell.textLabel?.text = split[0]
        
        cell.detailTextLabel?.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        //Remove a Word
        words.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveWords()
    }

    func saveWords() {
        //Save in the Group App UserDefaults
        if let defaults = UserDefaults(suiteName: Constants.groupName){
            defaults.set(words, forKey: "Words")
        }
    }
    
    func updateItems(_ words: [String]) {
        self.words = words
    }
}
