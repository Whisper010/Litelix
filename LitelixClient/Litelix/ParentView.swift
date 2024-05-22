//
//  ParentView.swift
//  Litelix
//
//  Created by Linar Zinatullin on 20/11/23.
//

import SwiftUI

struct ParentView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State var viewLoading = true
    
    var body: some View {
        
        
        if isLoggedIn {
            ZStack{
                TabView{
                    
                    HomeView()
                        .tabItem {
                            VStack{
                                Image(systemName: "house")
                                Text("Home")
                            }
                            
                        }
                    NewHotView()
                        .tabItem {
                            VStack{
                                Image(systemName: "play.rectangle.on.rectangle.fill")
                                Text("New & Hot")
                            }
                            
                        }
                    MyLitelix()
                        .tabItem {
                            VStack{
                                Image(systemName: "square.fill")
                                Text("My Litelix")
                            }
                            
                        }
                    
                }
                .tint(.white)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
                        viewLoading = false
                    }
                }
                if viewLoading{
                    Color.black.ignoresSafeArea()
                    ProgressView()
                        .frame(width: 500,height: 500)
                        
                        
                }
                
            }
            
        } else {
           Intro()
       }
        
    }
}



#Preview {
    ParentView()
}
