/**
* Copyright 2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        
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
            let indexPath = self.tableView.indexPathForSelectedRow!
            let item = self.items[indexPath.row] as! NSDictionary
            let destinationVC = segue.destinationViewController as? DetailViewController
            destinationVC?.setDetail(item)
        }
    }
    

}
