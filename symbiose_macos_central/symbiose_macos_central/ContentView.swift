//
//  ContentView.swift
//  symbiose_macos_central
//
//  Created by Jonathan Pegaz on 17/01/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var spheroSensorController: SpheroSensorControl = SpheroSensorControl()
    
    @StateObject var videoManager = VideoManager()
    
    @StateObject var bleController : BLEController = BLEController()
    
    @StateObject var BLEmac1 = BLEObservableMac1()
    @StateObject var BLEmac3 = BLEObservableMac3()
    @StateObject var BLEesp1:BLEObservableEsp1 = BLEObservableEsp1()
    @StateObject var BLEesp2:BLEObservableEsp2 = BLEObservableEsp2()
    @StateObject var BLEesp2_3:BLEObservableEsp2_3 = BLEObservableEsp2_3()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
