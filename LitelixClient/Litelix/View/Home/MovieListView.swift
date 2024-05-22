//
//  MovieListView.swift
//  Litelix
//
//  Created by Linar Zinatullin on 20/11/23.
//

import Foundation
import SwiftUI

struct MovieListView: View {
    
    @Binding var collection: [Media]
    
    var titleText: String
    
    var body: some View {
        
        HStack{
            Text(titleText)
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.heavy)
            Spacer()
        }
        .padding(.horizontal)
        
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing: 12){
                ForEach(collection){ item in
                    NavigationLink(destination: MediaDetailView(media: item)){
                        MediaCard(item: item)
                    }
                }
            }
        }
    }
  
    
}


