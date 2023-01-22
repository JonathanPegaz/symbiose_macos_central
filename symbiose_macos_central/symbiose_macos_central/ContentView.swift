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

    func checkIfReady() {
        
        if BLEmac1.connectedPeripheral == nil {
            return;
        }
        
        if BLEmac3.connectedPeripheral == nil {
            return;
        }
        
        if BLEesp1.connectedPeripheral == nil {
            return;
        }
        
        if BLEesp2.connectedPeripheral == nil {
            return;
        }
        
        if BLEesp2_3.connectedPeripheral == nil {
            return;
        }
        
        bleController.active = true
        step = StepState.waitingStartMapping
        
    }

    var body: some View {
        
        VStack {
            CustomVideoPlayer(player: videoManager.player)
                .edgesIgnoringSafeArea(.all)
                .onAppear(){
                    bleController.load()
                }
        }
        
        // action on connected
        .onChange(of: BLEmac1.connectedPeripheral) { newValue in
            if let p = newValue {
                checkIfReady()
                BLEmac1.sendString(str: "reset")
                BLEmac1.listen { r in
                    print(r)
                }
            }
        }
        .onChange(of: BLEmac3.connectedPeripheral) { newValue in
            if let p = newValue{
                checkIfReady()
                BLEmac3.sendString(str: "reset")
                BLEmac3.listen { r in
                    print(r)
                }
            }
        }
        .onChange(of: BLEesp1.connectedPeripheral, perform: { newValue in
            if let p = newValue{
                checkIfReady()
                BLEesp1.sendString(str: "reset")
                BLEesp1.listen { r in
                    print(r)
                }
            }
        })
        .onChange(of: BLEesp2.connectedPeripheral) { newValue in
            if let p = newValue{
                checkIfReady()
                BLEesp2.listen { r in
                    print(r)
                }
            }
        }
        .onChange(of: BLEesp2_3.connectedPeripheral) { newValue in
            if let p = newValue{
                checkIfReady()
                BLEesp2_3.sendString(str: "reset")
                BLEesp2_3.listen { r in
                    print(r)
                }
            }
        }
        
        // start bluetooth connection
        .onChange(of: bleController.active) { newValue in
            SharedToyBox.instance.searchForBoltsNamed(["SB-92B2"]) { err in
                if err == nil && newValue == false {
                    
                    spheroSensorController.load()
                    
                    BLEmac1.startScann()
                    BLEmac3.startScann()
                    
                    BLEesp1.startScann()
                    BLEesp2.startScann()
                    BLEesp2_3.startScann()
                }
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
            // ---------------
            case StepState.reset:
                print("step \(newValue) : reset")
                // reset all app
                bleController.active = false
                
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
                
            case StepState.waitingMappingEndAct1:
                print("step \(newValue) : waiting for start mapping end act 1")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startMappingEndAct1:
                print("step \(newValue) : mapping end act 1")
                // start mapping
                BLEesp1.sendString(str: "end")
                videoManager.changeStep(step: 2)
                
                
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
                BLEesp1.sendString(str: "next_act")
                BLEesp2_3.sendString(str: "runningAct2")
                
            case StepState.waitingEndAct2:
                print("step \(newValue) : waiting for act 2 end")
                
            case StepState.waitingMappingEndAct2:
                print("step \(newValue) : waiting for start mapping end act 2")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startMappingEndAct2:
                print("step \(newValue) : mapping end act 2")
                // start mapping
                BLEesp2_3.sendString(str: "endact2")
                videoManager.changeStep(step: 3)
                
                
            // ---------------
            // act 3 block
            // ---------------
            case StepState.waitingStartAct3:
                print("step \(newValue) : waiting for start act 3")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startAct3:
                print("step \(newValue) : start act 3")
                // start led
                BLEesp1.sendString(str: "next_act_2")
                BLEesp2_3.sendString(str: "runningAct3")
                // start activity 3
                BLEmac3.sendString(str: "start")
                
            case StepState.waitingEndAct3:
                print("step \(newValue) : waiting for act 3 end")
                
            case StepState.waitingMappingEndAct3:
                print("step \(newValue) : waiting for start mapping end act 3")
                // waiting for sphero checked
                isWaitingForNext = true
                
            case StepState.startMappingEndAct3:
                print("step \(newValue) : mapping end act 3")
                // start mapping
                BLEesp2_3.sendString(str: "endact3")
                videoManager.changeStep(step: 4)
                
                
            // ---------------
            // end block
            // ---------------
            case StepState.end:
                BLEesp1.sendString(str: "next_act_3")
                print("end")
                // #code ...
                
            }
            
        })
        
        // manage video mapping
        .onChange(of: videoManager.currentTime) { newValue in
            
            if (newValue > 4 && step == StepState.startMappingEndAct1) {
                step = StepState.waitingStartAct1
            }
            
            if (newValue > 12 && step == StepState.startMappingEndAct2) {
                step = StepState.waitingStartAct2
            }
            
            if (newValue > 19 && step == StepState.startMappingEndAct3) {
                step = StepState.waitingStartAct3
            }
        }
        
        // get end of activity
        .onChange(of: BLEmac1.mac1value, perform: { newValue in
            if (newValue == "endact1") {
                step = StepState.waitingMappingEndAct1
            }
        })
        .onChange(of: BLEesp2.esp2value) { newValue in
            if (newValue == "endact2") {
                step = StepState.waitingMappingEndAct2
            }
        }
        .onChange(of: BLEmac3.mac3value, perform: { newValue in
            if (newValue == "endact3") {
                step = StepState.waitingMappingEndAct3
            }
        })
        
        // act 2 rfid
        .onChange(of: BLEesp2.rfid1) { newValue in
            SharedToyBox.instance.bolt!.drawMatrix(fillFrom: Pixel(x: 0, y: 0), to: Pixel(x: 7, y: 2), color: .red)
        }.onChange(of: BLEesp2.rfid2) { newValue in
            SharedToyBox.instance.bolt!.drawMatrix(fillFrom: Pixel(x: 0, y: 3), to: Pixel(x: 7, y: 5), color: .blue)
        }.onChange(of: BLEesp2.rfid3) { newValue in
            SharedToyBox.instance.bolt!.drawMatrix(fillFrom: Pixel(x: 0, y: 6), to: Pixel(x: 7, y: 7), color: .green)
        }
        
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
