//
//  SignInView.swift
//  coRat
//
//  Created by Yuki-OHMORI on 2023/08/28.
//

import SwiftUI
import Foundation
import PDFKit
import FirebaseAuth
import FirebaseFirestore

struct SignInView: View {
    @State var gender = ""
    @State var dateOfBirth:Date =  Calendar.current.date(from: DateComponents(year: 1990, month: 1, day: 1))!
    @State var socialAttribute=""
    @State var signInState = false
    let genderArray = ["Female","Male","Other"]
    let socialAttributeArray = [
        "Company employee",
        "Civil servant",
        "Self-employed",
        "Company officer",
        "Freelance",
        "Housewife",
        "Elementary school student",
        "Junior high school student",
        "High school student",
        "College or university student",
        "Graduate student",
        "Part-time job",
        "Unemployed"
    ]
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("Sign in")
                Form{
                    Section{
                        Picker(selection: $gender, label: Text("Enter your gender")){
                            ForEach(0 ..< genderArray.count){num in
                                Text(self.genderArray[num]).tag(num)
                            }
                        }
                        DatePicker("Pick your date of birth",selection: $dateOfBirth,displayedComponents: .date)
                        //個人情報{生年月日，社会的属性，住所}
                        //同意
                        Picker(selection: $socialAttribute, label: Text("Enter your gender")){
                            ForEach(0 ..< socialAttributeArray.count){num in
                                Text(self.socialAttributeArray[num]).tag(num)
                            }
                        }
                    }
                    Section{
                        Button(action: {
                            let user = Auth.auth().currentUser
                            if let user = user{
                                let uid = user.uid
                                Firestore.firestore().collection("user").document(uid).setData(["uid":uid,"dateOfBirth":dateOfBirth,"gender":gender,"socialAttribute":socialAttribute])
                                signInState = true
                            }
                        }){
                            Text("Sign in")
                            NavigationLink(destination: ContentView(),isActive:$signInState){}
                        }
                    }
                }
            }
        }
    }
    
    struct SignInView_Previews: PreviewProvider {
        static var previews: some View {
            SignInView()
        }
    }
}
