//
//  AlertService.swift
//  AppAlert
//
//  Created by Tim Mitra on 2023-12-31.
//

import UIKit

@Observable
class AlertService {
  struct Message: Codable {
    struct Link: Codable {
      let title: String
      let url: String
    }
    var id: Int = 0
    var bundleId: String = ""
    var title: String = ""
    var text: String = ""
    var confirmLabel: String = ""
    // use these optionals to check against versions
    var appVersions: [String]?
    var osVersions: [String]?
    var link: Link? // optional so you can use when needed.
  }
  
  let jsonURL: String
  let bundleIdentifier = Bundle.main.bundleIdentifier!
  var message = Message()
  var showMessage = false
  static var appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
  static var osVersion = UIDevice.current.systemVersion
  
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
    guard message.id > lastMessageId else { return }
    if let osVersions = message.osVersions {
      guard osVersions.contains(Self.osVersion) else { return }
    }
    if let appVersions = message.appVersions {
      guard appVersions.contains(Self.appVersion) else { return }
    }
    showMessage.toggle()
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
