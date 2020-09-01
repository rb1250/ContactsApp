//
//  ViewController.swift
//  MVVM2
//
//  Created by Andrew L. Jaffee on 5/12/18.
//
/*
 
 Copyright (c) 2017-2018 Andrew L. Jaffee, microIT Infrastructure, LLC, and
 iosbrain.com.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 NOTE: As this code makes URL references to NASA images, if you make use of
 those URLs, you MUST abide by NASA's image guidelines pursuant to
 https://www.nasa.gov/multimedia/guidelines/index.html
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import UIKit
import Contacts

// MARK: - View Controller

var messierModel = [MessierDataModel]()
var carsDictionary = [String: [String]]()
var carSectionTitles = [String]()



class ViewController: UIViewController {
            
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // #1 - The UITableViewDataSource and
        // UITableViewDelegate protocols are not
        // adopted in extensions.
        tableView.delegate = self
        tableView.dataSource = self
        
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)

        // 2
        if authorizationStatus == .notDetermined {
          // 3
          store.requestAccess(for: .contacts) { [weak self] didAuthorize,
          error in
            if didAuthorize {
               self?.retrieveContacts(from: store)
            }
          }
        } else if authorizationStatus == .authorized {
            retrieveContacts(from: store)
        }
        
        
    }
    
     func retrieveContacts(from store: CNContactStore) {
       let containerId = store.defaultContainerIdentifier()
       let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
       // 4
       let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                          CNContactFamilyNameKey as CNKeyDescriptor,
                          CNContactImageDataAvailableKey as
                          CNKeyDescriptor,
                          CNContactImageDataKey as CNKeyDescriptor]

      

       // 5
        do {
          let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
          print(contacts)
           
            for i in 0..<contacts.count{
                
                let formalName = contacts[i].givenName
                let commonName = contacts[i].familyName
                let date = updatedDate(month: 10, day: 19, year: 2017)
                
                let dataModel = MessierDataModel(formalName: formalName, commonName: commonName, pageLink: "", imageLink: "", updateDate: date, description: "", thumbnail: "")
                
               
                
                messierModel.append(dataModel)

                
            }
            // 1
               for contact in messierModel {
                
                print(contact)
                let carKey = String(contact.formalName.prefix(1))
                       if var carValues = carsDictionary[carKey] {
                        carValues.append(contact.formalName)
                           carsDictionary[carKey] = carValues
                       } else {
                        
//                        var arr = data.
//                            yourString: String = (arr as AnyObject).description
                        carsDictionary[carKey] = [contact.formalName as String]
                        
                       }
               }
               
               // 2
               carSectionTitles = [String](carsDictionary.keys)
               carSectionTitles = carSectionTitles.sorted(by: { $0 < $1 })
            
            print(messierViewModel)
            
        } catch {
          // something went wrong
          print(error) // there always is a "free" error variable inside of a catch block
        }
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" {
            
            if let destinationViewController = segue.destination as? DetailViewController
            {
                let indexPath = self.tableView.indexPathForSelectedRow!
                let index = indexPath.row
           
                destinationViewController.messierViewModel = MessierViewModel(messierDataModel: messierModel[index])
                
            }
        }
        
    }

}

extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return carSectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         let carKey = carSectionTitles[section]
           if let carValues = carsDictionary[carKey] {
               return carValues.count
           }
               
           return 0
    }
    
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return carSectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let carKey = carSectionTitles[indexPath.section]
          if let carValues = carsDictionary[carKey] {
                    
            tableViewCell?.imageView?.image = UIImage(named: carValues[indexPath.row])
            tableViewCell?.textLabel?.text = carValues[indexPath.row]
            tableViewCell?.detailTextLabel?.text = carValues[indexPath.row]
         }
        
        return tableViewCell!
    }
    
      func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return carSectionTitles
    }
    
    
} // end extension ViewController : UITableViewDataSource

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
