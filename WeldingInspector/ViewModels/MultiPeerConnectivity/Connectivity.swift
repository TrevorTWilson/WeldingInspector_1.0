//
//  Connectivity.swift
//  WeldingInspector
//
//  Created by Trevor Wilson on 2024-03-24.
//

import Foundation
import MultipeerConnectivity

class MultipeerConnectivityManager: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    
    private let serviceType = "Send-Weld"
    
    var isDiscoverable: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.startAdvertising()
           }
        }
    }
    
    var session: MCSession!
    var peerID: MCPeerID!
    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    
    @Published var connectedList: [MCPeerID] = []
    @Published var peerList: [MCPeerID] = []
    @Published var recievedInvite: Bool = false
    @Published var recievedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    @Published var receivedWeldData: Bool = false
    @Published var receivedProcedureData: Bool = false
    @Published var receivedWelderData: Bool = false
    
    var weldToSend: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    var procedureToSend: WeldingInspector.Job.WeldingProcedure?
    
    var receivedWeld: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    var receivedProcedure: WeldingInspector.Job.WeldingProcedure?
    var receivedWelder: WeldingInspector.Job.WeldingProcedure.Welder?

    override init() {
           
           super.init()
           
           peerID = MCPeerID(displayName: UIDevice.current.name)
           session = MCSession(peer: peerID)
           advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
           browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
           
           session.delegate = self
           advertiser.delegate = self
           browser.delegate = self
       }
    
    // Start advertising as a host
    func startAdvertising() {
        if isDiscoverable {
            advertiser.startAdvertisingPeer()
            print("Discoverable")
        } else {
            advertiser.stopAdvertisingPeer()
            print("Hidden")
        }
    }

    
    // Start browsing for peers
    func startBrowsing() {
        browser.startBrowsingForPeers()
        print("Start Browsing")
    }
    
    // Stop browsing for peers
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        print("Stop Browsing")
    }
    
    
    // Send data to a peer with a WeldNumber payload
    func sendWeldNumberToPeer(weldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers, toPeer peer: MCPeerID) {

        do {
            let jsonData = try JSONEncoder().encode(weldNumber)
            try session.send(jsonData, toPeers: [peer], with: .reliable)
        } catch {
            print("Error sending WeldNumber data to peer: \(error.localizedDescription)")
        }
    }
    
    func sendWeldingProceduretoPeer(weldProcedure: WeldingInspector.Job.WeldingProcedure, toPeer peer: MCPeerID) {

        do {
            let jsonData = try JSONEncoder().encode(weldProcedure)
            try session.send(jsonData, toPeers: [peer], with: .reliable)
        } catch {
            print("Error sending WeldNumber data to peer: \(error.localizedDescription)")
        }
    }
    
    // Method in MultipeerConnectivityManager to send an invitation with context
    func sendInvitationToPeer(peer: MCPeerID, withContext context: Data?) {
        print("Sent Invitation")
        print("Peer: \(peer.displayName)---Session: \(String(describing: session))---Contect: \(String(describing: context))")
        browser.invitePeer(peer, to: session, withContext: context, timeout: 30)
    }

    // Method in MultipeerConnectivityManager to handle sending data after the connection is established
    func sendWeldNumberAfterConnection(weldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers, toPeer peer: MCPeerID) {
        do {
            let jsonData = try JSONEncoder().encode(weldNumber)
            try session.send(jsonData, toPeers: [peer], with: .reliable)
        } catch {
            print("Error sending WeldNumber data to peer: \(error.localizedDescription)")
        }
    }

    
    // MARK: - MCSessionDelegate Methods
    
    // Implement MCSessionDelegate methods here
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("Peer \(peerID.displayName) is not connected.")
            // Handle the case when a peer is not connected
        case .connecting:
            print("Peer \(peerID.displayName) is connecting.")
            // Handle the case when a peer is in the process of connecting
        case .connected:
            print("Peer \(peerID.displayName) is connected.")
            // Handle the case when a peer is connected
            DispatchQueue.main.async {
                self.connectedList.append(peerID)
            }
            print("\(session.connectedPeers)")
  
        @unknown default:
            // Handle any unknown future states
            print("Unknown state for Peer \(peerID.displayName)")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let decoder = JSONDecoder()
        
        if let receivedWeldNumbersObject = try? decoder.decode(WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.self, from: data) {
            // Handle the received WeldNumbers object
            print("Received WeldNumbers object from \(peerID.displayName): \(receivedWeldNumbersObject)")
            receivedWeld = receivedWeldNumbersObject
            receivedWeldData = true
            
        } else if let receivedWeldProcedureObject = try? decoder.decode(WeldingInspector.Job.WeldingProcedure.self, from: data) {
            // Handle the received WeldingProcedure object
            print("Received WeldingProcedure object from \(peerID.displayName): \(receivedWeldProcedureObject)")
            receivedProcedure = receivedWeldProcedureObject
            receivedProcedureData = true
            
        } else if let receivedWelderObject = try? decoder.decode(WeldingInspector.Job.WeldingProcedure.Welder.self, from: data) {
            // Handle the received WeldingProcedure object
            print("Received Welder object from \(peerID.displayName): \(receivedWelderObject)")
            receivedWelder = receivedWelderObject
            receivedWelderData = true
            
        }else {
            print("Received JSON object does not match the expected types.")
            // Handle the case where the received object does not match expected types
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Not Used
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Not Used
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Not Used
    }
    // MARK: - MCNearbyServiceAdvertiserDelegate Methods

    // Implement MCNearbyServiceAdvertiserDelegate methods here
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        // Functionality to show the alert in the SwiftUI view
        DispatchQueue.main.async {
            print("Received Invitation")
            self.recievedInviteFrom = peerID
            self.invitationHandler = invitationHandler
            self.recievedInvite = true
        }
    }

    // MARK: - MCNearbyServiceBrowserDelegate Methods
    
    // Implement MCNearbyServiceBrowserDelegate methods here
      func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
          
          // Update the peerList with the discovered peer
          DispatchQueue.main.async {
              // Check if the peerID is not already in the peerList before adding it
              if !self.peerList.contains(peerID) {
                  self.peerList.append(peerID)
                  print("Found peer: \(peerID.displayName)")
              }

          }
      }


    // Implement MCNearbyServiceBrowserDelegate methods here
       func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
           // Handle the scenario when a peer is lost or no longer available
           print("Lost peer: \(peerID.displayName)")

           // Update the peerList by removing the lost peer
           DispatchQueue.main.async {
               if let index = self.peerList.firstIndex(of: peerID) {
                   self.peerList.remove(at: index)
               }
               if let index = self.connectedList.firstIndex(of: peerID) {
                   self.connectedList.remove(at: index)
               }
           }
       }

}





