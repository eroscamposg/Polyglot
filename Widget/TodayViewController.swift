//
//  TodayViewController.swift
//  Widget
//
//  Created by Eros Campos on 7/31/20.
//  Copyright © 2020 Eros Campos. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    
    var words = [String]()
    var cellIdentifier = "WordCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded

        //After adding App Groups in Signing & Capabilities tab
        if let defaults = UserDefaults(suiteName: Constants.groupName) {
            if let savedWords = defaults.object(forKey: "Words") as? [String] {
                words = savedWords
            }
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
          self.preferredContentSize = maxSize;
        }
        else {
          self.preferredContentSize = CGSize(width: 0, height: 440);
        }

    }
    
    //MARK: - Table View Delegates
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
        
        //Change BG color
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView!.backgroundColor = UIColor(white: 1, alpha: 0.20)
        
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

    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
