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
import CoreLocation

struct SignInView: View {
    @State var gender = ""
    @State var dateOfBirth:Date =  Calendar.current.date(from: DateComponents(year: 1990, month: 1, day: 1))!
    @State var socialAttribute=""
    @State var signInState = false
    @State var errorMassege = ""
    @State var address = 0
    @State var country = "Japan"
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
                Text(errorMassege)
                Form{
                    Section{
                        VStack{
                            Picker(selection: $gender, label: Text("Enter your gender")){
                                ForEach(genderArray, id: \.self){ item in
                                    Text(item)
                                }
                            }
                            DatePicker("Pick your date of birth",selection: $dateOfBirth,displayedComponents: .date)
                            //個人情報{生年月日，社会的属性，住所}
                            //同意
                            Picker(selection: $socialAttribute, label: Text("Enter your gender")){
                                ForEach(socialAttributeArray, id: \.self){ item in
                                    Text(item)
                                }
                            }
                            Text("If you live in Japan,Enter your ZIP Code")
                            TextField("",value:$address,format:.number).keyboardType(.numberPad)
                            Text("If you don't live in Japan Pick country you live in")
                            TextField("",text:$country)
                        }
                    }
                    Section{
                        Button(action: {
                            let user = Auth.auth().currentUser
                            if gender != "" && socialAttribute != ""{
                                if let user = user{
                                    let uid = user.uid
                                    Firestore.firestore().collection("user").document(uid).setData(["uid":uid,"dateOfBirth":dateOfBirth,"gender":gender,"socialAttribute":socialAttribute])
                                    signInState = true
                                }
                            }else{}
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
