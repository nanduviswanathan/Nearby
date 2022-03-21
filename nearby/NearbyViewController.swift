//
//  NearByViewController.swift
//  iOS POC
//
//  Created by NanduV on 10/03/22.
//

import Foundation
import  UIKit

class ViewController: UIViewController{


    var nearbyVM: NearbyViewModel?


    @IBOutlet weak var msglabel: UILabel!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
  
        nearbyVM = NearbyViewModel()
        nearbyVM?.checkPermisiion()
        nearbyVM?.initNearbyApi()
        NotificationCenter.default.addObserver(self, selector: #selector(showRecivedMessage), name: .nearbyUpdate, object: nil)

    }

    @IBAction func didTapSendButton(_ sender: UIButton) {
        print("send")
        nearbyVM?.publishMsg()
    }
    @IBAction func didTapReciveButton(_ sender: UIButton) {
        print("recived")
        nearbyVM?.subscribeMsg()
    }
    
    
    
    func ShowRecivedMsg(msg: String){
        
        presentAlertWithTitle(title: nil, message: msg, options: Constants.AlertOptions.okButton) { (option) in
               print("option: \(option)")
               switch(option) {
                   case Constants.AlertOptions.okButton:
                       break
                   default:
                       break
               }
           }
    }
    
    // update ui
    @objc func showRecivedMessage(notification: Notification) {
        let value = notification.userInfo?[Constants.notificationName.nearbyViewController] as? String
        ShowRecivedMsg(msg: value!)
    }
    
}
