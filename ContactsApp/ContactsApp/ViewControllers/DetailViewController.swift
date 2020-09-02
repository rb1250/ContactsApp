//
//  DetailViewController.swift
//  Created by Ruchika Bokadia on 31/08/20.
//


import UIKit

// MARK: - Detail View Controller

class DetailViewController: UIViewController {
    
    var contactViewModel: ContactViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.alpha = 0.0
        
        // #1 - Define a closure (completion block) INSTANCE for updating a UIImageView
        // once an image downloads. Added capture list to prevent retain cycles.
        
        let imageCompletionClosure = { [unowned self] ( imageData: NSData ) -> Void in
            
            // #2 - Download occurs on background thread, but UI update
            // MUST occur on the main thread.
            DispatchQueue.main.async {
                
                // #3 - Animate the appearance of the contact image.
                UIView.animate(withDuration: 1.0, animations: {
                    self.imageView.alpha = 1.0
                    self.imageView?.image = UIImage(data: imageData as Data)
                    self.view.setNeedsDisplay()
                })
                
                // #4 - Stop and hide the activity spinner as the
                // image has finished downloading
                self.activitySpinner.stopAnimating()
                
            } // end DispatchQueue.main.async
            
        } // end let imageCompletionClosure...
        
        // #5 - Start and show the activity spinner as the
        // image is about to start downloading in background.
        activitySpinner.startAnimating()
        
        // #6 - Update the UI with info from the contact object
        // the user chose to inspect.
        titleLabel.text = contactViewModel?.formalName
        subtitleLabel.text = contactViewModel?.commonName
        updatedLabel.text = contactViewModel?.dateUpdated
        descriptionTextView.attributedText = contactViewModel?.textDescription
        
        // #7 - Start image downloading in background.
//        contactViewModel?.download(completionHanlder: imageCompletionClosure)
        
    } // end func viewDidLoad
    
    // print deallocation to make sure closure isn't
    // causing a retain cycle
    deinit {
       print("Class instance deinitialized")
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        // #8 - make sure UITextView shows beginning
        // of contact object description
        self.descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

} // end class DetailViewController
