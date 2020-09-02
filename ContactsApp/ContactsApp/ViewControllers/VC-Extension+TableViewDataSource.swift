//
//  VC-Extension+TableViewDataSource.swift
//  Created by Ruchika Bokadia on 31/08/20.
//


import Foundation

import UIKit

// MARK: - UITableView Data Source


extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         let carKey = contactectionTitles[section]
           if let carValues = contactDictionary[carKey] {
               return carValues.count
           }
               
           return 0
    }
    
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let carKey = contactectionTitles[indexPath.section]
          if let carValues = contactDictionary[carKey] {
                    
            tableViewCell?.imageView?.image = UIImage(named: carValues[indexPath.row])
            tableViewCell?.textLabel?.text = carValues[indexPath.row]
            tableViewCell?.detailTextLabel?.text = carValues[indexPath.row]
         }
        
        return tableViewCell!
    }
    
      func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
       
        return contactIndexTitles.firstIndex(of: title)!
    }

//    - (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//    {
//        return contactIndexTitles indexOfObject:title];
//    }
    
} // end extension ViewController : UITableViewDataSource
