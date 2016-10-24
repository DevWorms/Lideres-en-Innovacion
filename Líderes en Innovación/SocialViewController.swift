//
//  SocialViewController.swift
//  Líderes en Innovación
//
//  Created by Emmanuel Valentín Granados López on 12/10/16.
//  Copyright © 2016 Emmanuel Valentín Granados López. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        self.webView.loadRequest(NSURLRequest(url: NSURL(string: "https://twitter.com/comunidadeli/with_replies") as! URL) as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @IBAction func forwardAction(_ sender: AnyObject) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @IBAction func stopAction(_ sender: AnyObject) {
        webView.stopLoading()
    }
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        webView.reload()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        self.navigationTitle.title = webView.stringByEvaluatingJavaScript(from: "document.title")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
