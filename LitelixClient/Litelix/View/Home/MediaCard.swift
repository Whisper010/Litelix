//
//  MediaCard.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 20/11/23.
//

import Foundation
import SwiftUI

struct MediaCard: View {
    
    
    let item: Media
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var widthFactor: Double {
        let aspectRatio = Double(screenHeight/screenWidth)
        if aspectRatio >= 19.0/9 && aspectRatio <= 19.6/9{
            return 0.3
        }else if aspectRatio >= 15.0/9 && aspectRatio <= 17.0/9{
            return 0.25
        }
        return 0.2
    }
    var heightFactor: Double = 0.2
    
    
    
    var body: some View{
        ZStack(alignment: .top){
            AsyncImage(url: item.posterURL){ image in
                image
                    .resizable()
                    .frame(width: screenWidth * widthFactor,
                           height: screenHeight * heightFactor)
                    .scaledToFill()
                    
                   
            } placeholder: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10.0).fill(Color.black)
                        .frame(width: screenWidth * widthFactor,
                               height: screenHeight * heightFactor)
                    ProgressView()
                        .frame(width: screenWidth * widthFactor,
                               height: screenHeight * heightFactor)
                }
    
            }
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            VStack(alignment: .leading){
                HStack(){
                    Text("L")
                        .foregroundStyle(Color(hex: 0xD22F27))
                        .font(.title2)
                        .fontWeight(.heavy)
                    Spacer()
 
                }.padding(.horizontal, 5.0)
               
            }
            
        }
        .clipped()
            
        
        
        
    }
}
