//
//  RecommendationPoster.swift
//  Litelix
//
//  Created by Linar Zinatullin on 21/11/23.
//

import SwiftUI

struct RecommendationPoster: View {
    
    let media: Media?
    
    var allowGesture: Bool
    
    @EnvironmentObject var observer: PageObserver
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var opacity = 1.0
    
    var widthFactor : Double {
        let aspectRatio = Double(screenHeight/screenWidth)
        if aspectRatio >= 19.0/9 && aspectRatio <= 19.6/9{
            return 0.85
        }else if aspectRatio >= 15.0/9 && aspectRatio <= 17.0/9{
            return 0.8
        }
        return 0.85
    }
    var heightFactor: Double {
        let aspectRatio = Double(screenHeight/screenWidth)
        if aspectRatio >= 19.0/9 && aspectRatio <= 19.6/9{
            return 0.55
        }else if aspectRatio >= 15.0/9 && aspectRatio <= 17.0/9{
            return 0.55
        }
        return 0.7
    }
    
    @State var start = Date.now
    @State var imageOpacity: Double = 0.0
    
    var body: some View {
        
        
        if let media = media {
            
            ZStack {
                
                NavigationLink(destination: MediaDetailView(media: media)){
                    
                        AsyncImage(url: media.posterURL){ image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))

                        }placeholder: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10.0).fill(Color.black)
                                ProgressView()
                                
                            }.frame(width: screenWidth * widthFactor, height: screenHeight * heightFactor)
                        }
                        
                        
                        
                        .gesture( allowGesture ?
                                  dragPageGesture(observer: observer)
                                  : nil
                        )
                       
                        
                }
                .frame(width: screenWidth * widthFactor, height: screenHeight * heightFactor)
               
                .accessibilityLabel(media.titleName )
                
                VStack(spacing: 8){
                    Spacer()
                    HStack{
                        Text(media.titleName)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .multilineTextAlignment(.center)
                            .shadow(radius: 5)
                            .clipped()
                        
                    }
                    .padding([.leading,.trailing])
                    .frame(width: screenWidth * widthFactor)
                    .gesture(allowGesture ?
                             dragPageGesture(observer: observer)
                             : nil)
                    HStack {
                        ForEach(media.genreNames, id : \.self){ genreName in
                            Text(genreName)
                        }
                        
                        
                    }
                    .frame(width: screenWidth * widthFactor)
                    .fontWeight(.medium)
                    .gesture(
                        allowGesture ?
                        dragPageGesture(observer: observer)
                        : nil
                    )
                    
                    HStack{
                        
                        Button(action: {}, label: {
                            HStack{
                                Text("Play")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.black)
                                
                                Image(systemName: "play.fill")
                                    .foregroundStyle(Color.black)
                            }
                        })
                        .frame(width: screenWidth * 0.32, height: screenHeight * 0.05)
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        
                        
                        Button(action: {print("Play Button Tapped")}, label: {
                            HStack{
                                Text("My List")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Image(systemName: "plus")
                                    .fontWeight(.bold)
                                
                            }
                            
                        })
                        .frame(width: screenWidth * 0.35, height: screenHeight * 0.05)
                        .background(Color.brighten(hex:0x000000, percentage: 0.2).opacity(0.9))
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        
                    }.padding(.bottom)
                    
                    
                }.tint(.white)
                
            }
            .onAppear{
                observer.size = CGSize(width:screenWidth * widthFactor , height: screenHeight * heightFactor)
            }
           
        }
        
        
    }
    
}

extension View {
    func dragPageGesture(observer: PageObserver) -> some Gesture {
        DragGesture()
            .onChanged{ value in
                let treshhold: Double = 300
                
                if value.translation.width < 0 && observer.currentPage != observer.numberOfPages - 1 {
                    observer.direction = .left
                    observer.dragX = Float(value.translation.width)
                } else if value.translation.width > 0 && observer.currentPage != 0{
                    observer.direction = .right
                    observer.dragX = Float(value.translation.width)
                }
                
                
            }
            .onEnded{ value in
                let treshhold: Float = 200
                let distance = abs(observer.dragX)
                //
                
                if observer.direction == .left && observer.currentPage != observer.numberOfPages - 1 && distance > treshhold  {
                    withAnimation(.easeInOut){
                        observer.dragX = -Float(observer.size.width)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        observer.direction = .none
                        observer.currentPage += 1
                      
                            observer.dragX = 0.0
                        
                    }
                    
                    
                } else
                if observer.direction == .left && observer.currentPage != observer.numberOfPages-1 && distance <= treshhold{
                    withAnimation(.easeInOut){
                        observer.dragX = 0.0
                    }
                    
                }
                
                if observer.direction == .right && observer.currentPage != 0 && distance > treshhold {
                    
                    withAnimation(.easeInOut){
                        observer.dragX = Float(observer.size.width)

                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        observer.direction = .none
                        observer.currentPage -= 1
                            observer.dragX = 0.0
                        
                    }
                    
                    
                    
                }else if observer.direction == .right && observer.currentPage != 0 && distance <= treshhold{
                    withAnimation(.easeInOut) {
                        observer.dragX = 0.001
                    }
                    
                }
                
                
            }
        
            
        
        
    }
}

#Preview {
    RecommendationPoster(media: MediaViewModel.preview, allowGesture: true)
}
