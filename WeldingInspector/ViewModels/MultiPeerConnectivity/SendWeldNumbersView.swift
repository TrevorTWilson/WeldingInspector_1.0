//
//  SendWeldNumbersView.swift
//  WeldingInspector
//
//  Created by trevor wilson on 2024-03-25.
//

import SwiftUI
import MultipeerConnectivity

struct SendWeldNumbersView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var multipeerManager: MultipeerConnectivityManager
    
    @Binding var isPresented: Bool
    
    @State private var selectedPeer: MCPeerID?
    @State private var isSendingInvitation = false
    @State private var isSendingData = false

    
    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            Text("Connected Peers")
            if !multipeerManager.connectedList.isEmpty {
                List(multipeerManager.connectedList, id:\.displayName) { peer in
                    Text("\(peer.displayName)")
                }
            } else {
                Text("No Peers Connected")
            }
            if !multipeerManager.connectedList.isEmpty {
                if isSendingData {
                    ProgressView("Sending Data...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Button("Send Weld to peers") {
                        handleWeldToSend()
                    }
                    .buttonStyle(BorderedBlueButtonStyle())
                }
            }
            Spacer()
            Text("Available Peers for Connection:")
            if multipeerManager.peerList.isEmpty {
                Text("None available")
            } else {
                List(multipeerManager.peerList, id: \.displayName) { peer in
                    if !multipeerManager.connectedList.contains(peer) {
                        Button(action: {
                            selectedPeer = peer
                        }) {
                            Text(peer.displayName)
                        }
                    }
                }
            }
            Spacer()
            if let selectedPeer = selectedPeer {
                
                if isSendingInvitation {
                    ProgressView("Sending Invitation...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Button("Send Invitation to \(selectedPeer.displayName)") {
                        sendInvitation(selectedPeer: selectedPeer)
                    }
                    .buttonStyle(BorderedBlueButtonStyle())
                }

            }
            Button("Cancel") {
                isPresented = false
            }
            .buttonStyle(BorderedBlueButtonStyle())
        }
        .onAppear(){
            
            multipeerManager.startBrowsing()
            multipeerManager.isTransmiting = true
        }
        .onDisappear() {
            multipeerManager.stopBrowsing()
        }
        .padding()
    }
    
    func sendInvitation(selectedPeer: MCPeerID) {
        isSendingInvitation = true // Show progress animation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulating a delay for demonstration
            multipeerManager.sendInvitationToPeer(peer: selectedPeer, withContext: nil)
            self.selectedPeer = nil
            
            // Hide progress animation after sending the invitation
            withAnimation {
                isSendingInvitation = false
            }
        }
    }

    
    func handleWeldToSend() {
        if !multipeerManager.connectedList.isEmpty {
            sendWeldNumbers()
        }
    }
    
    func sendWeldNumbers() {
        isSendingData = true
        
        if let unwrappedWeldNumber = multipeerManager.weldToSend {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                for peer in multipeerManager.connectedList {
                    multipeerManager.sendWeldNumberToPeer(weldNumber: unwrappedWeldNumber, toPeer: peer)
                }
                withAnimation {
                    isSendingInvitation = false
                }
                isPresented = false
            }
        }
    }
    
    struct BorderedBlueButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .foregroundColor(.blue)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }

}



struct SendWeldNumbersView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented: Bool = true
        SendWeldNumbersView(isPresented: $isPresented)
            .environmentObject(MainViewModel())
            .environmentObject(MultipeerConnectivityManager())
    }
}

