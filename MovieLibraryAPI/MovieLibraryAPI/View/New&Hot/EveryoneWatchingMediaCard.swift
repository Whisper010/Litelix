//
//  EveryoneWatchingMediaCard.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 22/11/23.
//

import SwiftUI

struct EveryoneWatchingMediaCard: View {
    
    let media: Media
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let widthFactor = 0.8
    let heightFactor = 0.2
    
    var body: some View {
        
        VStack{
            ZStack{
                
                AsyncImage(url: media.backdropURL){ image in
                    image
                        .resizable()
                        .frame(width: screenWidth * widthFactor,height: screenHeight * heightFactor)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
                } placeholder: {
                    ZStack{
                        Rectangle().fill(Color.gray)
                            .frame(width: screenWidth * widthFactor,height: screenHeight * heightFactor)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        ProgressView()
                            .frame(width: screenWidth * widthFactor,height: screenHeight * heightFactor)
                        
                    }
                    
                }
                VStack(){
                    HStack{
                        Text("L")
                            .foregroundStyle(Color(hex: 0xD22F27))
                            .font(.title)
                            .fontWeight(.heavy)
                        Spacer()
                        
                    }.padding()
                    Spacer()
                }
                
                
                
            }
            
            HStack{
                Text("")
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    VStack{
                        Image(systemName: "bell")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screenWidth * 0.06)
                            .fontWeight(.bold)
                        
                        Text("Remind Me")
                            .font(.footnote)
                    }.tint(.white)
                }).padding(.trailing)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    VStack{
                        Image(systemName: "info.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screenWidth * 0.06)
                            .fontWeight(.bold)
                        
                        Text("Info")
                            .font(.footnote)
                    }.tint(.white)
                })
            }.padding( [.top])
            
            
            HStack{
                Text("L")
                    .foregroundStyle(Color(hex: 0xD22F27))
                    .font(.title3)
                    .fontWeight(.heavy)
                Text("F I L M")
                    .font(.footnote)
                
                Spacer()
                
            }
            
            HStack{
                Text(media.titleName)
                    .font(.title2)
                    .fontWeight(.heavy)
                Spacer()
            }
            
            HStack{
                Text(media.overview)
                    .font(.footnote)
                    .lineLimit(3)
                Spacer()
            }
        }.padding()
        
        
    }
}
