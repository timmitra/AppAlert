//
//  ContentView.swift
//  AppAlert
//
//  Created by Tim Mitra on 2023-12-31.
//

import SwiftUI

struct ContentView: View {
  @State private var alertService = AlertService(
    "https://timmitra.github.io/AppAlert/messages.json"
  )
  var body: some View {
    VStack {
      Image(systemName: "globe")
      .imageScale(.large)
      .foregroundStyle(.tint)
      Text("Hello, world!")
      .alert(
        alertService.message.title,
        isPresented: $alertService.showMessage
      ) {
        Button(alertService.message.confirmLabel) {
        }
      } message: {
        Text(alertService.message.text)
        }
    }
    .padding()
    // use task not onAppear since it's async
    .task {
      await alertService.showAlertIfNecessary()
    }
  }
}

#Preview {
    ContentView()
}
