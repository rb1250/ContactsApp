//
//  VC-Extension+TableViewDelegate.swift
//  MVVM2
//
//  Created by Ruchika Bokadia on 31/08/20.
//

 


import Foundation

import UIKit

// MARK: - UITableView Delegate

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

