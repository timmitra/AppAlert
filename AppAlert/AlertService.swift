//
//  AlertService.swift
//  AppAlert
//
//  Created by Tim Mitra on 2023-12-31.
//

import Foundation

@Observable
class AlertService {
  struct Message: Codable {
    var id: Int = 0
    var bundleId: String = ""
    var title: String = ""
    var text: String = ""
    var confirmLabel: String = ""
  }
  
  let jsonURL: String
  let bundleIdentifier = Bundle.main.bundleIdentifier!
  var message = Message()
  var showMessage = false
  
  var lastMessageId: Int {
    get {
      UserDefaults.standard.integer(forKey: "lastMessageId")
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: "lastMessageId")
    }
  }
  
  init(_ jsonURL: String) {
    self.jsonURL = jsonURL
  }
  
  func fetchMessage() async {
    do {
      let (data, _) = try await URLSession.shared.data(from: URL(string: jsonURL)!)
      if let message = try JSONDecoder().decode([Message].self, from: data).first(where: {$0.bundleId == bundleIdentifier}) {
        self.message = message /* message that we just decoded and unwrapped */
      }
    } catch {
      print("Could not decode")
    }
  }
  
  func showAlertIfNecessary() async {
    await fetchMessage()
    // check if new message
    if message.id > lastMessageId {
      showMessage = true
    }
    lastMessageId = message.id // update the stored message.id
  }
}

/*
 https://timmitra.github.io/AppAlert/messages.json
 
 [
   {
     "id" : 1,
     "bundleId" : "com.it-guy.AppAlert",
     "title" : "App Alert",
     "text" : "Warning: There is a bug in the application that I am working on...",
     "confirmLabel" : "OK"
   }
 ]
 */
