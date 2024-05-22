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
    @State var viewModel = MediaViewModel()
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var selectedSegment = 0
    @State private var contentLoaded = false
    
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
                            withAnimation{
                                self.selectedSegment = index
                            }
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
            
            ScrollViewReader{ scrollReader in
                VStack(spacing: 12){
                    ScrollView(showsIndicators: false){
                        
                        VStack{
                            
                            ForEach(categories.indices, id: \.self){ index in
                                Section(header: HStack{
                                    Image(systemName: categories[index].iconName)
                                        .foregroundStyle(categories[index].primaryColor, categories[index].secondaryColor)
                                        
                                    
                                    Text(categories[index].name)
                                        .bold()
                                        .font(.title2)
                                        .frame(width: screenWidth, alignment: .leading)
                                        .background(GeometryReader{
                                            Color.clear.preference(key: ViewOffsetKey.self, value: -$0.frame(in: .global).minY)
                                        })
                                }.offset(CGSize(width: 30, height: 0)))
                                {
                                    if index == 0 {
                                        ForEach(viewModel.upcomingMovies) { media in
                                            NewHotMediaCard(media: media, category: .comingSoon)
                                        }
                                    } else if index == 1 {
                                        ForEach(viewModel.onTheAirTVs) { media in
                                            NewHotMediaCard(media: media, category: .everyoneWatching)
                                        }
                                    } else if index == 2 {
                                        ForEach(viewModel.ratedTVs.indices, id: \.self) { idx in
                                            if idx < 10 {
                                                NewHotMediaCard(media: viewModel.ratedTVs[idx], category: .topTV, topIndex: idx + 1)
                                            }
                                        }
                                    } else if index == 3 {
                                        ForEach(viewModel.ratedMovies.indices, id: \.self) { idx in
                                            if idx < 10 {
                                                NewHotMediaCard(media: viewModel.ratedMovies[idx], category: .topMovie, topIndex: idx + 1)
                                            }
                                        }
                                    }
                                }.id(index)
                                    
                            }
                            
                            
                            
                        }
                        
                        
                    }
                }
                .onChange(of: selectedSegment){ newIndex in
                    DispatchQueue.main.async {
                        withAnimation{
                            scrollReader.scrollTo(newIndex, anchor: .top)
                        }
                    }
                    
                }
                
                
                .onAppear{
                    Task{
                        await withTaskGroup(of: Void.self) { group in
                            group.addTask {
                                await viewModel.loadUpcomingMovies()
                            }
                            group.addTask {
                                await viewModel.loadOnTheAirTVs()
                            }
                            group.addTask {
                                await viewModel.loadRated(mediaType: .movie)
                            }
                            group.addTask {
                                await viewModel.loadRated(mediaType: .tv)
                            }
                        }
                        contentLoaded = true
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
    
    struct ViewOffsetKey: PreferenceKey {
        static var defaultValue: Double = 0
        static func reduce(value: inout Double,nextValue: () -> Double){
            value += nextValue()
        }
    }
    
    
}

#Preview {
    NewHotView()
}
