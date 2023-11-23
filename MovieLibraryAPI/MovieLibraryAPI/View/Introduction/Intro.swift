//
//  Intro.swift
//  Litelix
//
//  Created by Linar Zinatullin on 16/11/23.
//

import SwiftUI

struct Intro: View {
    
    let viewModel = IntroViewModel()
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        
        
        NavigationStack{
            TabView{
                ForEach(viewModel.intros){ intro in
                    IntroCard(intro: intro)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .onAppear{
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(hex: 0xD22F27))
            }
            
            
            ZStack{
                
                NavigationLink(destination: LoginView()){
                    Text("SIGN IN")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: screenWidth * 0.9, maxHeight: screenHeight * 0.044)
                        .background(Color(hex: 0xD22F27))
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                }
            }
            
            
            .toolbar{
                
                ToolbarItem(placement: .topBarLeading){
                    Text("Litelix")
                        .foregroundStyle(Color(hex: 0xD22F27))
                        .fontWeight(.heavy)
                }
                ToolbarItemGroup(placement:.topBarTrailing){
                    Text("Privacy")
                        .fontWeight(.bold)
                        .font(.footnote)
                        .opacity(0.9)
                    Text("Help")
                        .fontWeight(.bold)
                        .font(.footnote)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            
            
            
        }
        
        
        
        
    }
}

struct IntroCard: View{
    
    let intro: IntroModel
    
    var body: some View{
        VStack(spacing: 20){
            
            Image(intro.Image)
                .resizable()
                .frame(maxWidth: 300,maxHeight: 300)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .accessibilityLabel("Image of \(intro.Image)")
            
            Text(intro.Text.Mainline)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            
            Text(intro.Text.SubLine)
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
           
            
        }
    }
}

struct IntroModel: Identifiable{
    let id = UUID()
    let Image: String
    let Text: (Mainline: String, SubLine: String)
    
}

struct IntroViewModel{
    let intros: [IntroModel] = [
        IntroModel(Image: "watchEverywhere", Text: (Mainline: "Watch\neverywhere", SubLine: "Stream on your phone, tablet,\nlaptop and TV.")),
        IntroModel(Image: "payBox", Text: (Mainline: "There's a plan\nfor every fan", SubLine: "Small price. Big Entertainment\n")),
        IntroModel(Image: "cancelOnline", Text: (Mainline: "Cancel online\nanytime", SubLine: "Join today, no reason to wait.\n")),
        IntroModel(Image: "", Text: (Mainline: "How do i watch", SubLine: "Members that subscribe to\nLitelix can watch here in the\napp."))
    ]
}

#Preview {
    Intro()
}
