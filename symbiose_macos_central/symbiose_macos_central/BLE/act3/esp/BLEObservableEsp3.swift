//
//  BLEObservable.swift
//  SwiftUI_BLE
//
//  Created by Al on 26/10/2022.
//

import Foundation
import CoreBluetooth

class BLEObservableEsp3:ObservableObject{
    
    enum ConnectionState {
        case disconnected,connecting,discovering,ready
    }
    
    @Published var periphList:[Periph] = []
    @Published var connectedPeripheral:Periph? = nil
    @Published var connectionState:ConnectionState = .disconnected
    @Published var dataReceived:[DataReceived] = []
        
    @Published var esp3value: String = ""
    
    init(){
        _ = BLEManagerEsp3.instance
    }
    
    func startScann(){
        BLEManagerEsp3.instance.scan { p,s in
            let periph = Periph(blePeriph: p,name: s)
            
            if periph.name == "esp_led_3"{
                self.connectTo(p: periph)
                self.stopScann()
            }
            
        }
    }
    
    func stopScann(){
        BLEManagerEsp3.instance.stopScan()
    }
    
    func connectTo(p:Periph){
        connectionState = .connecting
        BLEManagerEsp3.instance.connectPeripheral(p.blePeriph) { cbPeriph in
            self.connectionState = .discovering
            BLEManagerEsp3.instance.discoverPeripheral(cbPeriph) { cbPeriphh in
                self.connectionState = .ready
                self.connectedPeripheral = p
            }
        }
        BLEManagerEsp3.instance.didDisconnectPeripheral { cbPeriph in
            if self.connectedPeripheral?.blePeriph == cbPeriph{
                self.connectionState = .disconnected
                self.connectedPeripheral = nil
            }
        }
    }
    
    func disconnectFrom(p:Periph){
        
        BLEManagerEsp3.instance.disconnectPeripheral(p.blePeriph) { cbPeriph in
            if self.connectedPeripheral?.blePeriph == cbPeriph{
                self.connectionState = .disconnected
                self.connectedPeripheral = nil
            }
        }
        
    }
    
    func sendString(str:String){
        
        let dataFromString = str.data(using: .utf8)!
        
        BLEManagerEsp3.instance.sendData(data: dataFromString) { c in
            
        }
    }
    
    func sendData(){
        let d = [UInt8]([0x00,0x01,0x02])
        let data = Data(d)
        let dataFromString = String("Toto").data(using: .utf8)
        
        BLEManagerEsp3.instance.sendData(data: data) { c in
            
        }
    }
    
    func readData(){
        BLEManagerEsp3.instance.readData()
    }
    
    func listen(c:((String)->())){
        
        BLEManagerEsp3.instance.listenForMessages { data in
            
            if let d = data{
                if let str = String(data: d, encoding: .utf8) {
                    print(str)
                    self.esp3value = str
                }
            }

        }
        
    }
    
}
