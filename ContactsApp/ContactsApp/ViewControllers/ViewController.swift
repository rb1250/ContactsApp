//
//  ViewController.swift
//  Created by Ruchika Bokadia on 31/08/20.
//


import UIKit
import Contacts

// MARK: - View Controller

var contactModel = [ContactDataModel]()
var contactDictionary = [String: [String]]()
var contactectionTitles = [String]()
var contactIndexTitles = [String]();




class ViewController: UIViewController {
            
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // #1 - The UITableViewDataSource and
        // UITableViewDelegate protocols are not
        // adopted in extensions.
        tableView.delegate = self
        tableView.dataSource = self
        
        contactIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L","M", "N", "O", "P", "Q", "R", "S", "T","U","V", "W","X", "Y","Z"]
        
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
                
                let dataModel = ContactDataModel(formalName: formalName, commonName: commonName, pageLink: "", imageLink: "", updateDate: date, description: "", thumbnail: "")
                
               
                
                contactModel.append(dataModel)

                
            }
            // 1
               for contact in contactModel {
                
                print(contact)
                let carKey = String(contact.formalName.prefix(1))
                       if var carValues = contactDictionary[carKey] {
                        carValues.append(contact.commonName)
                           contactDictionary[carKey] = carValues
                       } else {
                        
//                        var arr = data.
//                            yourString: String = (arr as AnyObject).description
                        contactDictionary[carKey] = [contact.formalName as String]
                        
                       }
               }
               
               // 2
               contactectionTitles = [String](contactDictionary.keys)
               contactectionTitles = contactectionTitles.sorted(by: { $0 < $1 })
            
            print(contactViewModel)
            
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
           
                destinationViewController.contactViewModel = ContactViewModel(contactDataModel: contactModel[index])
                
            }
        }
        
    }

}

