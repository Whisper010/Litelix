//
//  TrendingCard.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 14/11/23.
//

import Foundation
import SwiftUI

struct TrendingCard: View {
    
    let trendingItem: Media
    
    var body: some View{
        ZStack(alignment: .bottom){
            AsyncImage(url: trendingItem.backdropURL){ image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400,height: 250)
            } placeholder: {
                ZStack{
                    Rectangle().fill(Color.black)
                        .frame(width: 400,height: 250)
                    ProgressView()
                        .frame(width: 400,height: 250)
                }
    
            }
            
            VStack {
                HStack{
                    Text(trendingItem.titleName  )
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: 350,alignment: .leading)
                        
                    Spacer()
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    
                }
                HStack{
                    Image(systemName: "hand.thumbsup.fill")
                    Text("\(trendingItem.vote_average, specifier: "%.1f")" )
                    Spacer()
                }
                .foregroundColor(.yellow)
                .fontWeight(.heavy)
            }
            .padding()
            .background(.black)
        }.cornerRadius(10.0)
        
        
        
    }
}
