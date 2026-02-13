//
//  CommonTnCPrivacyVC.swift
//  DoDoo
//
//  Created by Rajesh Banka on 27/10/22.
//

import UIKit
import WebKit


protocol CommonTnCDelegate {
    
    func acceptedTnC()
}

class CommonTnCPrivacyVC: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var termsNconditionDelegate: CommonTnCDelegate?
    
    //MARK: - LIFE CYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.loadHTMLString()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        webView.stopLoading()
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "...")
        webView.navigationDelegate = nil
        webView.scrollView.delegate = nil
        webView = nil
    }
    
    //MARK: - LOAD WEBVIEW
    
    func loadHTMLString() -> Void {
        
        if let url = Bundle.main.url(forResource: "terms_conditions", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }
    
    
    //MARK: - ACTIONS
    @IBAction func okButtonClicked(sender : UIButton){
        
        termsNconditionDelegate?.acceptedTnC()
        self.dismiss(animated: true)
    }
    
    //MARK: - Delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        Utility.shared.stopLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        Utility.shared.stopLoader()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        Utility.shared.startLoader()
    }
}
