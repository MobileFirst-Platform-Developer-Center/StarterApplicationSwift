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

class DetailViewController: UIViewController, UIWebViewDelegate {
    
    var detailItem = [:]
    
    @IBOutlet weak var webView: UIWebView!

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        self.title = self.detailItem["title"] as? String
        
        let url = self.detailItem.objectForKey("link") as! String
        let myUrl = NSURL(string: url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        let request = NSURLRequest(URL: myUrl)
        self.webView.loadRequest(request)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    
    func setDetail(newDetailItem: NSDictionary) -> Void{
        if (self.detailItem != newDetailItem){
            self.detailItem = newDetailItem
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
