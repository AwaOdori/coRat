//
//  ContentView.swift
//  coRat
//
//  Created by Yuki-OHMORI on 2023/08/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack {
                NavigationLink(destination: LoginView()){
                    Text("Hello")
                    
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
