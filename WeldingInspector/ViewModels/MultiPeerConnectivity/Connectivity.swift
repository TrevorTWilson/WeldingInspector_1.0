//
//  Connectivity.swift
//  WeldingInspector
//
//  Created by trevor wilson on 2024-03-24.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

class MultipeerConnectivityManager: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    var mainViewModel: MainViewModel
    
    private let serviceType = "Send-Weld"
    
    var isDiscoverable: Bool = false {
        didSet {
            startAdvertising()
        }
    }
    
    
    
    var session: MCSession!
    var peerID: MCPeerID!
    var advertiser: MCNearbyServiceAdvertiser!
    var browser: MCNearbyServiceBrowser!
    
    @Published var peerList: [MCPeerID] = []
    @Published var recievedInvite: Bool = false
    @Published var recievedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    

    init(mainViewModel: MainViewModel) {
           self.mainViewModel = mainViewModel
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
//        // Usage example to send WeldNumber object to a specific peer
//        let weldNumberToSend = WeldingInspector.Job.WeldingProcedure.Welder.WeldNumber(/* Initialize with your data */)
//        let targetPeer = /* Specify the target peer MCPeerID */
//        sendWeldNumberToPeer(weldNumber: weldNumberToSend, toPeer: targetPeer)
        do {
            let jsonData = try JSONEncoder().encode(weldNumber)
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
            print("\(session.connectedPeers)")
            
        @unknown default:
            // Handle any unknown future states
            print("Unknown state for Peer \(peerID.displayName)")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            // Deserialize the received Data into a JSON object (Dictionary or suitable Codable type)
            let decoder = JSONDecoder()
            let receivedObject = try decoder.decode(WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers.self, from: data)
            
            // Handle the received JSON object
            print("Received JSON object from \(peerID.displayName): \(receivedObject)")
            
            // Process the received JSON object as needed
            
        } catch {
            print("Error decoding JSON object: \(error)")
            // Handle any decoding errors here
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
           }
       }

}





