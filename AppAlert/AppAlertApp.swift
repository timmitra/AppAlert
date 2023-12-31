//
//  AppAlertApp.swift
//  AppAlert
//
//  Created by Tim Mitra on 2023-12-31.
//

import SwiftUI

@main
struct AppAlertApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            .onAppear{
              print(AlertService.appVersion)
              print(AlertService.osVersion)
              print(AlertService.cachesLocation)
              print(AlertService.userDefaultsLocation)
            }
        }
    }
}
