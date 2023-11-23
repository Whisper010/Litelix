//
//  RecommendationPoster.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 21/11/23.
//

import SwiftUI

struct RecommendationPoster: View {
    
    let media: Media?
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        if let media = media {
            
            
                        ZStack{
                            NavigationLink(destination: MediaDetailView(media: media)){
                                AsyncImage(url: media.posterURL){ image in
                                    image
                                        .resizable()
                                        .frame(width: screenWidth * 0.85 , height: screenHeight * 0.55)
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    
                                    
                                }placeholder: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10.0).fill(Color.black)
                                            .frame(width: screenWidth * 0.85,
                                                   height: screenHeight * 0.55)
                                        ProgressView()
                                            .frame(width: screenWidth * 0.85,
                                                   height: screenHeight * 0.55)
                                    }
                                }
                            }.accessibilityLabel(media.titleName )
                            VStack(spacing: 8){
                                Spacer()
                                HStack{
                                    Text(media.titleName)
                                        .font(.title)
                                        .fontWeight(.heavy)
                                        .multilineTextAlignment(.center)
                                        .shadow(radius: 5)
                                    
                                    
                                } .padding([.leading,.trailing])
                                HStack {
                                    ForEach(media.genreNames, id : \.self){ genreName in
                                        Text(genreName)
                                    }
                                    
                                }.fontWeight(.medium)
                                HStack(){
                                    
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
                    
                   
        }
        
    }
}

#Preview {
    RecommendationPoster(media: MediaViewModel.preview)
}
