//
//  ParentView.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 20/11/23.
//

import SwiftUI

struct ParentView: View {
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        
        if isLoggedIn {
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
                                
                            Text("My LiteLix")
                        }
                        
                    }
            }.tint(.white)
        } else {
           Intro()
       }
        
    }
}



#Preview {
    ParentView()
}
