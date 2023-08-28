//
//  ContentView.swift
//  coRat
//
//  Created by Yuki-OHMORI on 2023/08/27.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack {
                NavigationLink(destination: LoginView()){
                    Text("Login")
                }
                Button(action:{
                    do {
                        try Auth.auth().signOut()
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)}
                }){
                        Text("Logout")
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
