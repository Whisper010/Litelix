//
//  MyLitelix.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 22/11/23.
//

import SwiftUI
import SwiftData

struct MyLitelix: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @Query var users: [User]
    
    @AppStorage("userId") var userId: Int = 0
    
    @State private var showingMenu = false
    
    var currentUser: User? {
       return users.first{ $0.id == userId}
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Image(currentUser?.icon ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.2)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    Text(currentUser?.userName ?? "")
                    
                    Button(action: {}, label: {
                        HStack{
                            Image(systemName: "bell.circle.fill")
                                .resizable()
                                .foregroundStyle(.white, .red)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth * 0.08)
                                
                            
                            Text("Downloads")
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                        
                        }.tint(.white)
                            .padding()
                    })
                    
                    Button(action: {}, label: {
                        HStack{
                            Image(systemName: "arrow.down.to.line.circle.fill")
                                .resizable()
                                .foregroundStyle(.white, Color.brighten(hex:0x241571,percentage: 0.25))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: screenWidth * 0.08)
                                
                            
                            Text("Notifications")
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                        
                        }.tint(.white)
                            .padding()
                    })
                }
                .sheet(isPresented: $showingMenu){
                    VStack {
                        Spacer()
                        MenuView()
                    }
                    
                    .presentationDetents([.height(screenHeight * 0.35)])
                        .presentationBackground(.clear)
                        .ignoresSafeArea(edges: .bottom)
                        
                        
                
                        
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Text("For You")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding()
                    
                }
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button(action: {showingMenu.toggle()}, label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth * 0.06)
                            
                            
                    })
                    .tint(.white)
                }
            }
        }
        
    }
}

struct MenuView: View {
    @Environment(\.dismiss) var dismiss
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    var body: some View {
        
            VStack(spacing: screenHeight * 0.035){
                
                HStack{
                    Button(action: {
                        // Handle "Manage Profiles" action
                    }, label: {
                        HStack{
                            Image(systemName: "highlighter")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: screenWidth * 0.07)
                                .foregroundStyle(.white,.clear)
                                .fontWeight(.heavy)
                            
                            Text("Manage Profiles")
                                .padding(.leading)
                            
                           
                        }
                        
                    })
                    Spacer()
                    Button(action: {dismiss()}, label: {
                       Image(systemName: "multiply.circle.fill")
                            .resizable()
                            .foregroundStyle(.white, .black.opacity(0.5))
                            .aspectRatio(contentMode: .fit)
                            .frame(height: screenWidth * 0.07)
                            
                    })
                }
                
                Button(action: {
                    // Handle "App Settings" action
                }, label: {
                    HStack{
                        Image(systemName: "gearshape")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth * 0.07)
                            .fontWeight(.medium)
                        
                        
                        Text("App Settings")
                            .padding(.leading)
                        Spacer()
                    }
                    
                })
                
                Button(action: {
                    // Handle "Account" action
                }, label: {
                    HStack{
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.07)
                            
                            
                            .fontWeight(.medium)
                        
                        Text("Account")
                            .padding(.leading)
                        Spacer()
                    }
                    
                })
                Button(action: {
                    // Handle "Help" action
                }, label: {
                    HStack{
                        
                        Image(systemName: "questionmark.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: screenWidth * 0.07)
                            .fontWeight(.medium)
   
                        
                        Text("Help")
                            .padding(.leading)
                        
                        Spacer()
                    }
                })
                
                Button(action: {
                    isLoggedIn = false
                }, label: {
                    HStack{
                        VStack(alignment: .trailing){
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: screenWidth * 0.07)
                                .fontWeight(.medium)
                                .offset(CGSize(width: screenWidth * 0.01, height: 0))
                        }
                        
                        
                            
                        
                        Text("Sign Out")
                            .padding(.leading)
                        Spacer()
                    }
                })
                Spacer()
            }
            .padding()
            .font(.title3)
            .fontWeight(.bold)
            .tint(.white)
            .frame(maxWidth: .infinity)
            .background(Color.brighten(hex: 0x000000,percentage: 0.15))
            .cornerRadius(10.0 )
            .foregroundColor(.white)
        
        
    }
}

#Preview {
    MyLitelix()
}
