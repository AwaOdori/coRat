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
    @State var addressEroor = false
    @State var addressAlert = false
    @State var errorMassege = ""
    @State var zipCord = 0
    @State var address = ""
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
    let geocoder = CLGeocoder()
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
                            TextField("",value:$zipCord,format:.number).keyboardType(.numberPad)
                            Text("If you don't live in Japan Pick country you live in")
                            TextField("",text:$country)
                        }
                    }
                    Section{
                        VStack{
                            Button(action: {
                                let user = Auth.auth().currentUser
                                if gender != "" && socialAttribute != ""{
                                    if let user = user{
                                        let uid = user.uid
                                        Firestore.firestore().collection("user").document(uid).setData(["uid":uid,"dateOfBirth":dateOfBirth,"gender":gender,"socialAttribute":socialAttribute])
                                        geocoder.geocodeAddressString("\(zipCord)", completionHandler: {(placemarks, error) -> Void in if error != nil{
                                            addressEroor = true
                                        }
                                            if let placemark = placemarks?.first{
                                                address = "\(placemark.administrativeArea)\(placemark.locality)\(placemark.subLocality)"
                                                addressAlert = true
                                            }
                                        })
                                    }
                                }else{
                                    errorMassege = "Please enter information!!"
                                }
                            }){
                                Text("Sign in")
                                NavigationLink(destination: ContentView(),isActive:$signInState){}
                            }.alert(title:Text("error"),message:Text("The address could not be correctly queried from the zip code. Please check your internet connection and zip code."), isPresented: $addressEroor)
                                .alert(title:Text("confirmation"),message:Text("Is \(address) your correct address?"),isPresented: $addressAlert, primaryButton: .default(Text("OK"){
                                    signInState = true
                                }),secondaryButton: .cancel(Text("Cancel"){addressAlert = false}))
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
