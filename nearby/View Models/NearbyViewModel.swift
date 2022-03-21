//
//  NearbyViewModel.swift
//  nearby
//
//  Created by NanduV on 18/03/22.
//

import Foundation

class NearbyViewModel{
    var messageMgr: GNSMessageManager?
    var publication: GNSPublication?
    var subscription: GNSSubscription?
    
    func checkPermisiion() {
        GNSMessageManager.setDebugLoggingEnabled(true)
        let nearbyPermission = GNSPermission(changedHandler: { (granted: Bool) in
          // Update the UI here
            print(granted)
        })
        
    }
    
    func initNearbyApi(){
        
        messageMgr = GNSMessageManager(apiKey: Constants.NearbyInfo.apiKey,
          paramsBlock: {(params: GNSMessageManagerParams?) -> Void in
            guard let params = params else { return }

            // This is called when microphone permission is enabled or disabled by the user.
            params.microphonePermissionErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if microphone use is allowed")
              }
            }
            // This is called when Bluetooth permission is enabled or disabled by the user.
            params.bluetoothPermissionErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if Bluetooth use is allowed")
              }
            }
            // This is called when Bluetooth is powered on or off by the user.
            params.bluetoothPowerErrorHandler = { hasError in
              if (hasError) {
                print("Nearby works better if Bluetooth is turned on")
              }
            }
        })
    }
    
    func publishMsg(){
        let pubMessage: GNSMessage = GNSMessage(content: Constants.NearbyInfo.msgString.data(using: .utf8,
          allowLossyConversion: true))
        publication = messageMgr?.publication(with: pubMessage)
    }
    
    func subscribeMsg() {
        subscription = messageMgr?.subscription(messageFoundHandler: {[unowned self] (message: GNSMessage?) -> Void in
            guard let message = message else { return }
            let msg = (String(data: message.content, encoding:.utf8))
            postLocalNotification(data: msg!)
          }, messageLostHandler: {[unowned self](message: GNSMessage?) -> Void in
            guard let message = message else { return }
              print("message recived\(String(data: message.content, encoding:.utf8))")
          })
      }
    
    func postLocalNotification(data: String) {
        NotificationCenter.default.post(name: .nearbyUpdate, object:Constants.notificationName.myObject , userInfo: [Constants.notificationName.nearbyViewController: data])
    }
}
