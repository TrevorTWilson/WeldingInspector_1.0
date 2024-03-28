//
//  RecievedInvite.swift
//  WeldingInspector
//
//  Created by trevor wilson on 2024-03-26.
//

import SwiftUI

struct RecievedInvite: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var multipeerManager: MultipeerConnectivityManager
    
    @Binding var showRecievedInvite: Bool
    
    var body: some View {
        let name = multipeerManager.recievedInviteFrom?.displayName ?? "Unknown"
        
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            
            VStack {
                Text("\(name)")
                    .font(.title)
                    .foregroundColor(.white)
                
                Text(" would like to send you a weld")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text("Would you like to proceed?")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                HStack {
                    Button("Accept") {
                        if let invitationHandler = multipeerManager.invitationHandler {
                            multipeerManager.invitationHandler!(true, multipeerManager.session)
                        }
                        multipeerManager.recievedInvite = false
                        showRecievedInvite = false
                    }
                    .foregroundColor(.white)
                    .padding()

                    
                    Button("Reject") {
                        if let invitationHandler = multipeerManager.invitationHandler {
                            invitationHandler(false, multipeerManager.session)
                        }
                        multipeerManager.recievedInvite = false
                        showRecievedInvite = false
                    }
                    .foregroundColor(.white)
                    .padding()

                }
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(40)
        }
    }
}

struct RecievedInvite_Previews: PreviewProvider {
    @State static var showRecievedInvite = true
    static var previews: some View {
        let mainViewModel = MainViewModel()
        let multipeerManager = MultipeerConnectivityManager(mainViewModel: mainViewModel)
        
        return RecievedInvite(showRecievedInvite: $showRecievedInvite)
            .environmentObject(mainViewModel)
            .environmentObject(multipeerManager)
    }
}



