//
//  VenueDetailsViewController.swift
//  Candystore
//
//  Created by Marsel Xhaxho on 17/10/2016.
//  Copyright © 2016 max@dev. All rights reserved.
//

import UIKit


class VenueDetailsViewController: UIViewController {

    // MARK: - Properties
    var venue: FSVenueDTO! {
        didSet {
            //If its the same object assigned
            if (venue != nil &&
                oldValue != nil &&
                venue.id == oldValue.id) {
                return;
            }
            self.refreshUI()
        }
    }
    
    var venueDetails: FSVeuneDetailsDTO! {
        didSet (newValue) {
            self.refreshDetails()
        }
    }
    
    var venueDetailsDataTask: URLSessionDataTask!
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var venueImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var venueActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var ratingActivityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.resetUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Functions
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
    
    func resetUI() {
        self.venueImageView.image = nil
        self.titleLabel.text = nil
        self.addressLabel.text = nil
        self.categoryLabel.text = nil
        self.ratingLabel.text = ""
        self.venueActivityIndicator.startAnimating()
        self.ratingActivityIndicator.startAnimating()
    }
    
    func cancelRequestIfNeeded() {
        if (self.venueDetailsDataTask != nil &&
            self.venueDetailsDataTask.state == URLSessionDataTask.State.running) {
            self.venueDetailsDataTask.cancel()
            self.venueDetailsDataTask = nil
        }
    }
    
    func refreshUI() {
        resetUI()
        if (self.venue != nil) {
            self.titleLabel.text = self.venue.name
            self.addressLabel.text = self.venue.location.address
            if (self.venue.categories.count > 0) {
                self.categoryLabel.text = (self.venue.categories.first as! FSVenueCategoryDTO).name
            }else {
                self.categoryLabel.text = nil
            }
            self.cancelRequestIfNeeded()
            self.venueDetailsDataTask = NetworkManager.shared().fetchVenueDetails(self.venue.id, completion:
                { (venueDetails, err) in
                    if (err != nil) {
                        self.venueActivityIndicator.stopAnimating()
                        print("error getting venue details " + err!.localizedDescription)
                        return
                    }
                    self.venueDetails = venueDetails!
            })
        }
    }

    func refreshDetails() {
        if (self.venueDetails != nil) {
            self.ratingActivityIndicator.stopAnimating()
            if (self.venueDetails.rating != nil) {
                self.ratingLabel.text = String(format: "%.1f", self.venueDetails.rating.doubleValue)
            }else {
                self.ratingLabel.text = "-"
            }
            if (self.venueDetails.photos.count.intValue > 0){
                let group = self.venueDetails.photos.groups.first as! FSPhotosGroupDTO
                let item = group.items.first as! FSPhotoItem
                let url = self.urlForVenuePhoto(prefix: item.prefix, suffix: item.suffix)
                self.venueImageView.sd_setImage(with: URL(string: url), completed: {
                    (image, err, cacheType, url) in
                    self.venueActivityIndicator.stopAnimating()
                    if (err != nil) {
                        print("error loading image " + err!.localizedDescription)
                    }
                })
            }else {
                self.venueActivityIndicator.stopAnimating()
            }
        }
    }
    
    func urlForVenuePhoto(prefix: String, suffix: String) -> String {
        let screenSize = UIScreen.main.calculateScreenSize();
        if screenSize == .screen_5_5 {
            return FSUtils.urlForPhoto(prefix: prefix, resolution: 500, suffix: suffix)
        }
        return FSUtils.urlForPhoto(prefix: prefix, resolution: 300, suffix: suffix)
    }
    
}
