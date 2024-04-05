//
//  DiscoveryView.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 13/11/23.
//

import SwiftUI

struct DiscoveryView: View {
    
    @State var viewModel = MediaViewModel()
    
    @State var searchText = ""
    
    var body: some View {
        NavigationStack{
            
            
            ScrollView {
               
                if searchText.isEmpty{
                    if viewModel.trendingMovies.isEmpty{
                        Text("No Results")
                        
                    }else{
                        HStack{
                            Text("Trending")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                            Spacer()
                        } 
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal,showsIndicators: false) {
                            HStack{
                                ForEach(viewModel.trendingMovies){ trendingItem in
                                    NavigationLink(destination: MediaDetailView(media: trendingItem)){
                                        TrendingCard(trendingItem: trendingItem)
                                    }
                                        
                                        
                                   
                                }
                            }.padding(.horizontal)
                        }
                    }
                }else {
                    LazyVStack{
                        ForEach(viewModel.searchResults) { item in
                            HStack{
                                AsyncImage(url: item.posterThumbnail){ image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80,height: 120)
                                        
                                }placeholder: {
                                    ProgressView()
                                        .frame(width: 80,height: 120)
                                }
                                .clipped()
                                .cornerRadius(10.0)
                                VStack(alignment: .leading){
                                    
                                    Text(item.media_type == "movie"  ? item.title ?? "" : item.name ?? "")
                                        .foregroundColor(.white)
                                        .fontWeight(.heavy)
                                        .font(.headline)
                                    
                                    Text("Adult: "+String(item.adult))
                                    
                                    HStack{
                                        Image(systemName: "hand.thumbsup.fill")
                                        Text("\(item.vote_average, specifier: "%.1f")" )
                                        Spacer()
                                    }
                                    .foregroundColor(.yellow)
                                    .fontWeight(.heavy)
                                }.padding()
                                
                                Spacer()
                                
                            }.padding(.horizontal)
                            
                        }
                    }
                }
    
            }
            .background(Color(red: 39/255,green: 40/255,blue: 59/255))
        }
        .onChange(of: searchText){newValue in
            if newValue.count > 0{
                Task{
                   await viewModel.search(term: searchText)
                }
                
            }
        }
        
        
        .searchable(text: $searchText)
        
        .onAppear{
            Task{
                await viewModel.loadTrending(mediaType: .movie)
                await viewModel.loadTrending(mediaType: .tv)
            }
           
        }
        
    }
}



#Preview {
    DiscoveryView()
}
