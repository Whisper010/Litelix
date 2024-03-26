import SwiftUI

class GradientViewModel: ObservableObject{
    
    
    @Published var gradientFactor: Double = 0.5
    private let scrollTreshold: Double = UIScreen.main.bounds.height * 0.2
    
    // Function to adjust gradient factor smoothly based on scroll offset
    func adjustGradientFactor(for offset: CGFloat){
        
        if abs(offset) > scrollTreshold{
            
            let adjustedOffset = abs(offset) - scrollTreshold
            
            let directionFactor = offset > 0 ? -1 : 1
            
            let newFactor = max(0.0, min(1.0, 0.35 - Double(directionFactor) * adjustedOffset / 1000))
            withAnimation(.easeInOut){
                gradientFactor = newFactor
            }
            
            
        }
        
        
    }
}

struct HomeView: View {
    
    @StateObject var viewModel = MediaViewModel()
    
    @StateObject var gradientViewModel = GradientViewModel()
    
    @State var searchText = ""
    
    @State var mainMedia: Media? = nil
    
    @State var start = Date.now
    
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                ScrollView(showsIndicators: false){
                   
                    
                    if searchText.isEmpty{
                        VStack{
                            
                            ZStack {
                                GeometryReader { geo in
                                    TimelineView(.animation) { tl in
                                        let time = start.distance(to: tl.date)
                                        let maxHeight = geo.size.height * 3
                                        let topHeightArea = geo.size.height * 0.7
                                        Color.blue
                                            .colorEffect(
                                                ShaderLibrary.rainbow(.float(time * 0.2), .float(maxHeight))
                                            )
                                            .frame(width: screenWidth , height: maxHeight).offset(y: -topHeightArea )
                                    }
                                }
                                    RecommendationPoster(media: viewModel.airingTVs.last)
                                
                            }
                                   
                            MovieListView(collection: $viewModel.trendingTVs, titleText: "Trending TV Shows")
                            MovieListView(collection: $viewModel.trendingMovies, titleText: "Trending Movies")
                            
                            MovieListView(collection: $viewModel.ratedTVs, titleText: "Top TV Shows")
                            MovieListView(collection: $viewModel.ratedMovies, titleText: "Top Movies")
                            
                            MovieListView(collection: $viewModel.popularTVs, titleText: "Popular TV Shows")
                            MovieListView(collection: $viewModel.popularMovies, titleText: "Popular Movies")
                            
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
                .coordinateSpace(name: "ScrollView")
                .onPreferenceChange(ViewOffsetKey.self){ value in
                    gradientViewModel.adjustGradientFactor(for: value)
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
            
            .background(
                Color.black
            )
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
                    
                    group.addTask { await viewModel.loadAiringTVs() }
                    
                    group.addTask { await viewModel.loadGenres(mediaType: .movie) }
                    group.addTask { await viewModel.loadGenres(mediaType: .tv) }
                }
                 
                mainMedia = viewModel.airingTVs.first
            }
            
           
            
        }
        
    }
    
    struct ViewOffsetKey: PreferenceKey{
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            withAnimation{
                value += nextValue()
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
