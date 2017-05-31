//
//  BusinessesDetailViewController.swift
//  Yelp
//
//  Created by Chengjiu Hong on 5/30/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    var address: String!
    var name : String!
    var review : String!
    var resturantImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        addressLabel.text = address
        reviewLabel.text = review
        imageView.image = resturantImage

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

}
