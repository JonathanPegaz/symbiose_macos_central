//
//  ContentView.swift
//  symbiose_macos_central
//
//  Created by Jonathan Pegaz on 17/01/2023.
//

import SwiftUI

enum StepState: Int {
    
    case reset = 0
    case waitingStartMapping = 1
    case startMapping = 2
    
    case waitingStartAct1 = 3
    case startAct1 = 4
    case waitingEndAct1 = 5
    case waitingMappingEndAct1 = 6
    case startMappingEndAct1 = 7
    
    case waitingStartAct2 = 8
    case startAct2 = 9
    case waitingEndAct2 = 10
    case waitingMappingEndAct2 = 11
    case startMappingEndAct2 = 12
        
    case waitingStartAct3 = 13
    case startAct3 = 14
    case waitingEndAct3 = 15
    case waitingMappingEndAct3 = 16
    case startMappingEndAct3 = 17
    
    case end = 18
    
}

struct ContentView: View {
    
    @StateObject var spheroSensorController: SpheroSensorControl = SpheroSensorControl()
    
    @StateObject var videoManager = VideoManager()
    
    @StateObject var bleController : BLEController = BLEController()
    
    @StateObject var BLEmac1 = BLEObservableMac1()
    @StateObject var BLEmac3 = BLEObservableMac3()
    @StateObject var BLEesp1:BLEObservableEsp1 = BLEObservableEsp1()
    @StateObject var BLEesp2:BLEObservableEsp2 = BLEObservableEsp2()
    @StateObject var BLEesp2_3:BLEObservableEsp2_3 = BLEObservableEsp2_3()
    
    @State var step:StepState = StepState.reset
    @State var isWaitingForNext:Bool = false


    var body: some View {
        
        VStack {
            CustomVideoPlayer(player: videoManager.player)
                .edgesIgnoringSafeArea(.all)
                .onAppear(){
                    bleController.load()
                }
        }
        
        // change step with sphero checking
        .onChange(of: spheroSensorController.isShaking, perform: { newValue in
            if (newValue == true) {
                if(isWaitingForNext && step.rawValue < StepState.end.rawValue) {
                    step = StepState(rawValue: step.rawValue + 1)!
                }
            }
        })
        
        // step for activities
        .onChange(of: step, perform: { newValue in
            
            switch newValue {
                    
            // ---------------
            // start block
            case StepState.reset:
                print("step \(newValue) : reset")
                // reset all app
                // #code ...
                
            case StepState.waitingStartMapping:
                print("step \(newValue) : waiting for start mapping")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startMapping:
                print("step \(newValue) : start mapping")
                // start mapping
                videoManager.changeStep(step: 1)
                // if mapping is looping, next step
                // #code ...
                
                
            // ---------------
            // act 1 block
            // ---------------
            case StepState.waitingStartAct1:
                print("step \(newValue) : waiting for start act 1")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startAct1:
                print("step \(newValue) : start act 1")
                // start led
                BLEesp1.sendString(str: "running")
                // start activity 1
                BLEmac1.sendString(str: "start")
                
            case StepState.waitingEndAct1:
                print("step \(newValue) : waiting for act 1 end")
                // read response from act 1
                // #code ...
                
            case StepState.waitingMappingEndAct1:
                print("step \(newValue) : waiting for start mapping end act 1")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startMappingEndAct1:
                print("step \(newValue) : mapping end act 1")
                // start mapping
                videoManager.changeStep(step: 2)
                // if mapping is looping, next step
                // #code ...
                
                
            // ---------------
            // act 2 block
            // ---------------
            case StepState.waitingStartAct2:
                print("step \(newValue) : waiting for start act 2")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startAct2:
                print("step \(newValue) : start act 2")
                // start led
                BLEesp2_3.sendString(str: "runningAct2")
                // start activity 2
                // #code ...
                
            case StepState.waitingEndAct2:
                print("step \(newValue) : waiting for act 2 end")
                // read response from act 2
                
            case StepState.waitingMappingEndAct2:
                print("step \(newValue) : waiting for start mapping end act 2")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startMappingEndAct2:
                print("step \(newValue) : mapping end act 2")
                // start mapping
                videoManager.changeStep(step: 3)
                // if mapping is looping, next step
                // #code ...
                
                
            // ---------------
            // act 3 block
            // ---------------
            case StepState.waitingStartAct3:
                print("step \(newValue) : waiting for start act 3")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startAct3:
                print("step \(newValue) : start act 3")
                // start activity 3
                // #code ...
                // start led
                // #code ...
                
            case StepState.waitingEndAct3:
                print("step \(newValue) : waiting for act 3 end")
                // read response from act 3
                
            case StepState.waitingMappingEndAct3:
                print("step \(newValue) : waiting for start mapping end act 3")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startMappingEndAct3:
                print("step \(newValue) : mapping end act 3")
                // start mapping
                videoManager.changeStep(step: 4)
                // if mapping is looping, next step
                // #code ...
                
            // ---------------
            // end block
            // ---------------
            case StepState.end:
                print("end")
                // #code ...
                
            }
            
        })
        
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
