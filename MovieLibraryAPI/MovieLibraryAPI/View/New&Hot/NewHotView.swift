//
//  NewHotView.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 21/11/23.
//

import SwiftUI

enum Categories: String {
    case comingSoon = "Coming Soon"
    case everyoneWatching = "Everyone watching"
    case topTV = "Top 10 TV Shows"
    case topMovie = "Top 10 Movies"
}

struct CategoryItem {
    let name: String
    let iconName: String
    let primaryColor: Color
    let secondaryColor: Color
}


struct NewHotView: View {
    @StateObject var viewModel = MediaViewModel()
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var selectedSegment = 0
    
    let categories: [CategoryItem] = [
        CategoryItem(name: Categories.comingSoon.rawValue, iconName: "popcorn.fill", primaryColor: .yellow , secondaryColor: .clear),
        CategoryItem(name: Categories.everyoneWatching.rawValue, iconName: "flame.fill", primaryColor: .orange , secondaryColor: .clear),
        CategoryItem(name: Categories.topTV.rawValue, iconName: "10.square.fill", primaryColor: .white , secondaryColor: .red),
        CategoryItem(name: Categories.topMovie.rawValue, iconName: "10.square.fill", primaryColor: .white , secondaryColor: .red)
    ]
    
    var body: some View {
        NavigationStack{
           
            ScrollView(.horizontal,showsIndicators: false){
                
                HStack{
                    ForEach(0..<categories.count, id:\.self){index in
                        Button(action: {
                            self.selectedSegment = index
                        }){
                            HStack{
                                
                                Image(systemName: categories[index].iconName)
                                    .foregroundStyle(categories[index].primaryColor, categories[index].secondaryColor)
                                Text(self.categories[index].name)
                                    .foregroundStyle((self.selectedSegment == index ? Color.black : Color.white))
                                
                                    
                            }.padding([.leading, .trailing])
                                .padding([.top,.bottom], screenHeight * 0.005)
                                .background(RoundedRectangle(cornerRadius: 25.0).fill(self.selectedSegment == index ? Color.white : Color.clear))
                                .bold()
                            
                                
                        }
                    }
                }.padding()
            }
            VStack(spacing: 12){
                ScrollView(showsIndicators: false){
                    VStack{
                        HStack{
                            Image(systemName: categories[0].iconName)
                                .foregroundStyle(categories[0].primaryColor, categories[0].secondaryColor)
                            Text(categories[0].name)
                                .bold()
                                .font(.title2)
                            Spacer()
                        }.padding()
                        
                       
                        ForEach(viewModel.upcomingMovies){ media in
                            UpcommingMediaCard(media: media)
                        }
                        HStack{
                            Image(systemName: categories[1].iconName)
                                .foregroundStyle(categories[1].primaryColor,categories[1].secondaryColor)
                            Text(categories[1].name)
                                .bold()
                                .font(.title2)
                            Spacer()
                        }.padding()
                        ForEach(viewModel.onTheAirTVs){ media in
                            UpcommingMediaCard(media: media)
                        }
                        
                        HStack{
                            Image(systemName: categories[2].iconName)
                                .foregroundStyle(categories[2].primaryColor,categories[2].secondaryColor)
                            Text(categories[2].name)
                                .bold()
                                .font(.title2)
                            Spacer()
                        }.padding()
                        ForEach(viewModel.ratedTVs){ media in
                            EveryoneWatchingMediaCard(media: media)
                        }
                        
                        HStack{
                            Image(systemName: categories[3].iconName)
                                .foregroundStyle(categories[3].primaryColor,categories[3].secondaryColor)
                            Text(categories[3].name)
                                .bold()
                                .font(.title2)
                            Spacer()
                        }.padding()
                        ForEach(viewModel.ratedMovies){ media in
                            EveryoneWatchingMediaCard(media: media)
                        }
                        
                    }
                }
            }.onAppear{
                Task{
                    await viewModel.loadUpcomingMovies()
                    await viewModel.loadOnTheAirTVs()
                    await viewModel.loadRated(mediaType: .movie)
                    await viewModel.loadRated(mediaType: .tv)
                }
            }
            
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Text("For You")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding()
                    
                }
                
            }
            
        }
        
        
    }
    
    
    
}

#Preview {
    NewHotView()
}
