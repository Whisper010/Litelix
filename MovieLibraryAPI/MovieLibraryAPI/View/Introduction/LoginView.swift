//
//  LoginView.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 17/11/23.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    
    @Environment(\.modelContext)  var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var isLearnMoreClicked: Bool = false

    
    
    @State var attributedString: AttributedString = ""
    @State var attributedStringSecondary: AttributedString = ""
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let widthFactor = 0.72
    
    @State var login: String = ""
    @State var password: String = ""
    
    private var isButtonEnabled: Bool {
        
        return !login.isEmpty && !password.isEmpty ? true : false
    }
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @AppStorage("userId") var userId: Int = 0
    
    @Query var users: [User]
    
    var body: some View {
        NavigationStack{
           
            ZStack{
               
                Color(hex: 0x161616)
                VStack(spacing: screenHeight * 0.02){
                    TextField("Email or phone number", text: $login)
                        .textFieldStyle(CredentialsFieldStyle())
                        .frame(width: screenWidth*widthFactor)
                        
                    
                    TextField("Password", text: $password)
                        .textFieldStyle(CredentialsFieldStyle())
                        .frame(width: screenWidth*widthFactor)
                        
                    
                    Button(action: {
                       SignIn(userName: login, password: password)
                    }, label: {
                        Text("Sign in")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: screenWidth * widthFactor, maxHeight: screenHeight * 0.044)
                            .background(Color(hex: 0xD22F27))
                            .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    }).disabled(!isButtonEnabled)
                        .opacity(!isButtonEnabled ? 0.5 : 1)
                    Text("Recover Password")
                    
                    
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            Text(attributedString)
                                .frame(width: geometry.size.width,alignment: .center)
                                .overlay{
                                    Button(action: {
                                        isLearnMoreClicked.toggle()
                                        attributedString = "Sign in protected by Google reCAPTCHA to\nensure you're not a bot."
                                        
                                    }, label: {
                                        Text("Learn more.")
                                            .fontWeight(.bold)
                                            
                                        
                                        
                                    }).offset(CGSize(width:  geometry.size.width*0.174, height: geometry.size.height*0.25 ))
                                        .opacity(isLearnMoreClicked ? 0 : 1)
                                }
                            
                            

                            
                        }
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .font(.caption2)
                        //
                    }.frame(height: screenHeight*0.032)
                        
                    if isLearnMoreClicked {
                        Text(attributedStringSecondary)
                            .frame(maxWidth: screenWidth * 0.6)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .font(.caption2)
                        
                    }
                        
                    
//                    Toggle("Enable Button", isOn: $isButtonEnabled)
                    
                }
                
              
            }
            .toolbar{
                
                ToolbarItem(placement: .principal){
                    Text("Litelix")
                        .font(.title)
                        .foregroundStyle(Color(hex: 0xD22F27))
                        .fontWeight(.heavy)
                    
                }
                ToolbarItemGroup(placement:.topBarTrailing){
                    Text("Help")
                        .fontWeight(.bold)
                        .font(.footnote)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        dismiss()
                    }label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .tint(.white)
                    }
                }
            }
            .onAppear{
                Task{
                    addUsers()
                    setupAttributedString()
                    
                }
               
            }
            
        }
      
    }
    
    func SignIn(userName: String, password: String ){
        for user in users {
               if user.userName == userName && user.password == password {
                   isLoggedIn = true
                   userId = user.id
                   break
               }
           }
    }
    
    func addUsers(){
        let users = UserViewModel().users
        for user in users{
            modelContext.insert(user)
        }
    }
    
    func setupAttributedString(){
        attributedString = AttributedString("Sign in protected by Google reCAPTCHA to\nensure you're not a bot. Learn More")
        
        if let range = attributedString.range(of: "Learn More") {
            // attributedString[range].link = URL(string: "https://www.hackingwithswift.com")!
            
            attributedString[range].foregroundColor = .clear
        }
        
        attributedStringSecondary = AttributedString("The information collected by Google reCAPTCHA is subject to the Google Privacy Policy and Terms of Service, and is used for providing, maintaining and improving the reCAPTCHA service and for general security purposes (it is not used for personalised advertising by Google).")
        
        if let range = attributedStringSecondary.range(of: "Privacy Policy") {
            
             attributedStringSecondary[range].link = URL(string: "https://policies.google.com/privacy")!
        }
        
        if let range = attributedStringSecondary.range(of: "Terms of Service") {
            
             attributedStringSecondary[range].link = URL(string: "https://policies.google.com/privacy")!
        }
        
    
    }
}



struct CredentialsFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View{ 
        configuration
            .font(.subheadline)
            .padding(10)
            .background(
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color(hex:0x333333))
            )
            .tint(.white)
        
        
    }
}


#Preview {
    LoginView()
}
