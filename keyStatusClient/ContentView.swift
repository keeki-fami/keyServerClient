

import SwiftUI

struct ContentView: View {
    @State private var status: Bool? = nil
    @State private var time: Date? = nil
    let url = URL(string: "")!
    @State private var data: [Bool:Date] = [:]
    @State private var backgroundColor: Color = .gray
    
    struct KeyStatus: Codable {
        let status: Bool
        let date: Date
        let id: String
    }

    var body: some View {
        VStack {
        GeometryReader { geometry in
            
                ZStack {
                    
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: geometry.size.height-100, height: geometry.size.height-100)
//                                        .offset(x: geometry.size.width/2, y: geometry.size.height/2)
                        .position(x: geometry.size.width, y: geometry.size.height/2)
                        .ignoresSafeArea(edges: [.bottom, .trailing])
                        .shadow(color: .black.opacity(0.25), radius: 10)
                    
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: geometry.size.height-150, height: geometry.size.height-150)
//                                        .offset(x: geometry.size.width/2, y: geometry.size.height/2)
                        .position(x: 0, y: geometry.size.height*3/4)
                        .ignoresSafeArea(edges: [.bottom, .trailing])
                        .shadow(color: .black.opacity(0.25), radius: 10)
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.ultraThinMaterial)
                            .frame(
                                width: geometry.size.width*0.75,
                                height: geometry.size.height*0.5
                            )
                            .shadow(color: .black.opacity(0.25), radius: 10)
                            .overlay() {
                                VStack{
                                    if let status = status {
                                        Text("\(status == true ? "open" : "close")")
                                    } else {
                                        Text("-")
                                    }
                                    if let time = time {
                                        Text("\(time)")
                                    } else {
                                        Text("-")
                                    }
                                    Button("確認") {
                                        var request = URLRequest(url: url)
                                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                                            guard let data = data else {
                                                print("nodata")
                                                return
                                            }
                                            do {
                                                
                                                let decoder = JSONDecoder()
                                                decoder.dateDecodingStrategy = .iso8601
                                                let decoded = try decoder.decode(KeyStatus.self, from: data)
                                                status = decoded.status
                                                time = decoded.date
                                                
                                            } catch {
                                                print("failured:\(error)")
                                            }
                                        }
                                        task.resume()
                                    }
                                }
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.white, lineWidth: 3)
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: geometry.size.height-150, height: geometry.size.height-150)
//                                        .offset(x: geometry.size.width/2, y: geometry.size.height/2)
                        .position(x: geometry.size.width, y: geometry.size.height)
                        .ignoresSafeArea(edges: [.bottom, .trailing])
                        .shadow(color: .black.opacity(0.25), radius: 10)
                    
                    
                }
                
            }
            
        }
        .background(backgroundColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            if let status = status {
                if status {
                    backgroundColor = .yellow
                } else {
                    backgroundColor = .blue
                }
            } else {
                backgroundColor = .gray
            }
        }
    }
}

#Preview {
    ContentView()
}
