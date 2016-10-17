//
//  VenueDetailsViewController.swift
//  Candystore
//
//  Created by Marsel Xhaxho on 17/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

import UIKit

class VenueDetailsViewController: UIViewController {

    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //Mark: - Functions
    func setup() {
        self.setupTitleLabel()
        self.setupRatingLabel()
    }
    
    func setupTitleLabel() {
        let screenSize = UIScreen.main.calculateScreenSize();
        switch(screenSize) {
        case .screen_3_5:
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18);
            break
        case .screen_4:
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 18);
            break
        case .screen_4_7:
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 23);
            break
        case .screen_5_5:
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 23);
            break
        }
    }
    
    func setupRatingLabel() {
        self.ratingLabel.layer.borderColor = UIColor.bordeauxLight().cgColor
    }

}
