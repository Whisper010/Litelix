import SwiftUI


class PageObserver: ObservableObject{
    @Published var currentPage: Int = 0
    @Published var numberOfPages: Int = 0
    @Published var direction: PageDirection = .none
    @Published var offset: Double = 0.0
    @Published var hitAllowed: Bool = false
    @Published var dragX: Float = 0.0
    @Published var currentMedia: Media? = nil
    @Published var screenWidth: Float = 0.0
    @Published var widthFactor: Float = 0.0
    @Published var opacity: Double = 1.0
    
    enum PageDirection {
        case none, right, left
    }
}


struct HomeView: View {
    
    @State var viewModel = MediaViewModel()
    
    //    @StateObject var gradientViewModel = GradientViewModel()
    
    @State var searchText = ""
    
    @State var mainMedia: Media? = nil
    
    @State var start = Date.now
    
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @StateObject var observer = PageObserver()
    
    var body: some View {
        
            NavigationStack{
                
                
                ScrollView(showsIndicators: false){
                    
                    
                    if searchText.isEmpty{
                        
                        ZStack{
                            ZStack{
                                VStack(spacing: 0) {
                                    let maxHeight = screenHeight * 1.9
                                    let topHeightArea = screenHeight * 0.6
                                    TimelineView(.animation) { tl in
                                        let time = start.distance(to: tl.date)
                                        
                                        Color.blue
                                            .colorEffect(
                                                ShaderLibrary.rainbow(.float(time * 0.2), .float(maxHeight))
                                            )
                                            
                                    }
                                    .frame(width: screenWidth , height: maxHeight).offset(y: -topHeightArea )
                                    
                                    Color.black
                                }
                            }
                            //                                ForEach(viewModel.airingTVs.indices.reversed(), id: \.self ) {index in
                            //                                    RecommendationPoster(media: viewModel.airingTVs[index], allowGesture: observer.currentPage == index ? true : false)
                            //                                        .environmentObject(observer)
                            //                                        .colorEffect(ShaderLibrary.pageFadeOut(.float(observer.dragX),.float(observer.screenWidth * observer.widthFactor)))
                            //                                }
                            
                            VStack{
                                ZStack{
                                    if viewModel.airingTVs.indices.contains(observer.currentPage){
                                        
                                        let safePage = observer.currentPage

                                        if observer.direction == .right{
                                            let nextPage = safePage - 1
                                            if viewModel.airingTVs.indices.contains(nextPage){
                                                RecommendationPoster(media: viewModel.airingTVs[nextPage], allowGesture: false)
                                                    .environmentObject(observer)
                                                    .disabled(true)
   
                                            }
                                        }
                                        if observer.direction == .left{
                                            let nextPage = safePage + 1
                                            if viewModel.airingTVs.indices.contains(nextPage){
                                                RecommendationPoster(media: viewModel.airingTVs[nextPage],allowGesture: false)
                                                    .environmentObject(observer)
                                                    .disabled(true)
                                                
                                            }
                                        }
                                        
                                        
                                        
                                        RecommendationPoster(media: viewModel.airingTVs[observer.currentPage], allowGesture: true)
                                            .environmentObject(observer)
                                            .colorEffect(ShaderLibrary.pageFadeOut(.float(observer.dragX),.float(observer.screenWidth * observer.widthFactor)))
                                        
                                            .onAppear{
                                                
                                            }
                                    }
                                }
                                
                                PageControl(numberOfPages: viewModel.airingTVs.count, currentPage: $observer.currentPage)
                                
                                MovieListView(collection: $viewModel.trendingTVs, titleText: "Trending TV Shows")
                                MovieListView(collection: $viewModel.trendingMovies, titleText: "Trending Movies")
                                
                                MovieListView(collection: $viewModel.ratedTVs, titleText: "Top TV Shows")
                                MovieListView(collection: $viewModel.ratedMovies, titleText: "Top Movies")
                                
                                MovieListView(collection: $viewModel.popularTVs, titleText: "Popular TV Shows")
                                MovieListView(collection: $viewModel.popularMovies, titleText: "Popular Movies")
                                
                            }
                            
                            
                        }
                        
                        
                    }else {
                        LazyVStack{
                            ForEach(viewModel.searchResults) { item in
                                NavigationLink(destination: MediaDetailView(media: item)){
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
                                            
                                            Text(item.titleName)
                                                .foregroundColor(.white)
                                                .fontWeight(.heavy)
                                                .font(.headline)
                                            
                                            HStack{
                                                Image(systemName: "hand.thumbsup.fill")
                                                Text("\(item.vote_average, specifier: "%.1f")" )
                                                Spacer()
                                            }
                                            .foregroundColor(Color.brighten(hex: 0xCD2F26,percentage: 0.3))
                                            .fontWeight(.heavy)
                                        }.padding()
                                        
                                        Spacer()
                                        
                                    }.padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                }
                .accessibilityLabel("Navigated to Home Screen")
                
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        Text("For You")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .padding()
                        
                    }
                }
            }
        
        .onChange(of: searchText){ newValue in
            if newValue.count > 0{
                Task{
                    await viewModel.search(term: searchText)
                }
                
            }
        }
        .searchable(text: $searchText)
        .onAppear{
            Task{
                await withTaskGroup(of: Void.self) { group in
                    group.addTask { await viewModel.loadTrending(mediaType: .movie) }
                    group.addTask { await viewModel.loadTrending(mediaType: .tv) }
                    
                    group.addTask { await viewModel.loadRated(mediaType: .movie) }
                    group.addTask { await viewModel.loadRated(mediaType: .tv) }
                    
                    group.addTask { await viewModel.loadPopular(mediaType: .movie) }
                    group.addTask { await viewModel.loadPopular(mediaType: .tv) }
                    
                    group.addTask {
                        await viewModel.loadAiringTVs()
                        
                    }
                    
                    group.addTask { await viewModel.loadGenres(mediaType: .movie) }
                    group.addTask { await viewModel.loadGenres(mediaType: .tv) }
                }
                observer.numberOfPages =  viewModel.airingTVs.count
                mainMedia = viewModel.airingTVs.first
            }
     
        }
        
    }
    
}

struct RoundedButtonStyle: ButtonStyle {
    
    var backgroundColor: Color
    var rectOpacity: Double = 1.0
    
    let screenSize = UIScreen.main.bounds.size
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        
            .background(RoundedRectangle(cornerRadius: 10.0).fill( backgroundColor).opacity(rectOpacity))
            .shadow(radius: 5) // Optional: add shadow for a lifted effect
            .frame(width: screenSize.width * 0.35 ,height: screenSize.height * 0.05)
        
    }
}


struct HomeViewPeview: PreviewProvider{
    
    static var previews: some View{
        
        HomeView()
        
    }
    
}
