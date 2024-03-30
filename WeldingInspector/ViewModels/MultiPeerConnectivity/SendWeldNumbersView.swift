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
    var selectedWeldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers?
    
    @State private var selectedPeer: MCPeerID?
    
    public init(isPresented: Binding<Bool>, selectedWeldNumber: WeldingInspector.Job.WeldingProcedure.Welder.WeldNumbers? = nil) {
        self._isPresented = isPresented
        self.selectedWeldNumber = selectedWeldNumber
    }
    
    var body: some View {
        VStack {
            Text("Select a Peer to Send WeldNumbers:")
            Spacer()
            if multipeerManager.peerList.isEmpty {
                Text("None available")
            } else {
                List(multipeerManager.peerList, id: \.displayName) { peer in
                    Button(action: {
                        selectedPeer = peer
                    }) {
                        Text(peer.displayName)
                    }
                }
            }
            Spacer()
            if let selectedPeer = selectedPeer {
                if let weldNumber = multipeerManager.weldToSend {
                    // Button code in SendWeldNumbersView
                    Button("Send Invitation to \(selectedPeer.displayName)") {
                       // let weldNumberData = try? JSONEncoder().encode(weldNumber)
                        DispatchQueue.main.async {
                            
                            multipeerManager.sendInvitationToPeer(peer: selectedPeer, withContext: nil)
                            isPresented = false
                        }
                    }

                } else {
                    Text("Please select a WeldNumber to send.")
                }
            }

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
}

struct SendWeldNumbersView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isPresented: Bool = true
        SendWeldNumbersView(isPresented: $isPresented)
            .environmentObject(MainViewModel())
            .environmentObject(MultipeerConnectivityManager())
    }
}

