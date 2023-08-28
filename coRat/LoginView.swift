//
//  Login.swift
//  coRat
//
//  Created by Yuki-OHMORI on 2023/08/27.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var mailAddress = ""
    @State private var password = ""
    @State private var loginState = false
    @State private var signInState = false
    @State private var errorMessage = ""
    var body: some View {
        NavigationStack{
            VStack{
                Text("Login/Sign in")
                Text(errorMessage)
                Form{
                    Section{
                        TextField("MailAddress", text: $mailAddress)
                        SecureField("Password", text: $password)
                    }
                    Section{
                        Button(action:{
                            Auth.auth().signIn(withEmail: mailAddress, password: password)
                            if Auth.auth().currentUser != nil{
                                loginState = true
                            }else{
                                loginState = false
                                errorMessage = "Login failed."
                            }
                        }){
                            Text("Login")
                            NavigationLink(destination: ContentView(), isActive: $loginState){}
                        }
                        Button(action:{
                            Auth.auth().createUser(withEmail: mailAddress, password: password){ result, error in
                                if let user = result?.user {
                                    signInState = true
                                }else{
                                    signInState = false
                                    errorMessage = "Sign-in failed."
                                }
                            }
                        }){
                            Text("Sign in ")
                            NavigationLink(destination: SignInView(), isActive: $signInState){}
                        }
                    }
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
