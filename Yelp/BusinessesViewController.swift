//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate {
    
    var businesses: [Business]!
    @IBOutlet weak var tabelView: UITableView!
    var searchBar : UISearchBar?
    var filteredBusinesses : [Business]!
    var isMoreData = false
    var loadingMoreView : InfiniteScrollActivityView?
    var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        tabelView.rowHeight = UITableViewAutomaticDimension
        tabelView.estimatedRowHeight = 120
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tabelView.contentSize.height, width: tabelView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView?.isHidden = true
        tabelView.addSubview(loadingMoreView!)
        
        var inset = tabelView.contentInset
        inset.bottom += InfiniteScrollActivityView.defaultHeight
        tabelView.contentInset = inset
        
        searchBar = UISearchBar()
        searchBar?.sizeToFit()
        searchBar?.backgroundColor = UIColor(red:0.83, green:0.00, blue:0.00, alpha:1.0)
        navigationItem.titleView = searchBar
        searchBar?.delegate = self
        searchBar?.placeholder = "type resturant name"
        
        Business.searchWithTerm(term: "", offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            self.tabelView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }
        )
        
        //Example of Yelp search with more search options specified
//         Business.searchWithTerm(term: "Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
//         self.businesses = businesses
//         
//         for business in businesses {
//         print(business.name!)
//         print(business.address!)
//         }
//         }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if filteredBusinesses != nil{
            return filteredBusinesses.count
        }
        else if businesses != nil{
            return businesses.count
        }
        else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = filteredBusinesses[indexPath.row]
        
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredBusinesses is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter { (item: Business) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let businessName = item.name!
            return businessName.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tabelView.reloadData()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        if(!isMoreData){
            //totoal content in UIScrollView
            let scrollViewContentHeight = tabelView.contentSize.height
            //calculate the position of one screen length before the bottom of result
            let scrollOffsetThreshold = scrollViewContentHeight - tabelView.bounds.size.height
        
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tabelView.isDragging){
                self.isMoreData = true
                
                //uodate position of loading more view indicator
                let frame = CGRect(x: 0, y: tabelView.contentSize.height, width: tabelView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView?.startAnimating()
                
                //strart load mor data
                loadMoreData()
            }
        
        }
    }
    
    public func loadMoreData(){
        offset += 5
        Business.searchWithTerm(term: "", offset: offset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.filteredBusinesses = businesses
            //update flag
            self.isMoreData = false
            //stop infinite scroll animation
            self.loadingMoreView?.stopAnimating()
            
            self.tabelView.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }
        )
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
