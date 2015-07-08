/**
* COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute
* these sample programs in any form without payment to IBM® for the purposes of developing, using, marketing or distributing
* application programs conforming to the application programming interface for the operating platform for which the sample code is written.
* Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES,
* EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY,
* FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE.
* IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
*/

import UIKit
import IBMMobileFirstPlatformFoundation

class MasterViewController: UITableViewController, WLDelegate {
    
    @IBOutlet var spinner: UIActivityIndicatorView!

    var items = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        WLClient.sharedInstance().wlConnectWithDelegate(self)
    }
    
    func onSuccess(response: WLResponse!) {
        NSLog("\nConnection Success: %@", response.responseText)
        self.refresh()
    }
    
    func onFailure(response: WLFailResponse!) {
        NSLog("\nConnection Failure: %@", response.errorMsg)
    }
    
    func update(items: NSArray) -> Void{
        self.items = items
        self.tableView.reloadData()
        self.spinner.stopAnimating()
        self.refreshControl?.endRefreshing()
    }
    
    func refresh() -> Void{
        self.spinner.startAnimating()
        
        let url = NSURL(string: "/adapters/StarterApplicationAdapter/getEngadgetFeeds")!
        let request = WLResourceRequest(URL: url, method: WLHttpMethodGet)
        request.sendWithCompletionHandler { (response: WLResponse!, error: NSError!) -> Void in
            if (error != nil) {
                NSLog("Invocation Failure: ", error.description)
            } else {
                self.update(response.responseJSON["items"] as! NSArray)
            }
        }
    }

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let item = self.items[indexPath.row] as! NSDictionary
        cell.textLabel?.text = item.objectForKey("title") as? String
        cell.detailTextLabel?.text = item.objectForKey("pubDate") as? String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail"){
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let item = self.items[indexPath.row] as! NSDictionary
            let destinationVC = segue.destinationViewController as? DetailViewController
            destinationVC?.setDetail(item)
        }
    }
    

}
