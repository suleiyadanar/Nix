//
//  CalendarView.swift
//  Nix
//
//  Created by Su Lei Yadanar on 2/22/24.
//

import SwiftUI

struct CalendarView: View {
    @State var isPresented = false
    @State var clasificationIdentifier : [CalendarEvent]  = [CalendarEvent]()
    
    let hourHeight = 50.0
    let today = Date()
  
    
        var body: some View {
            VStack {
                //                    Button("MyViewController") {
                //                        isPresented = true
                //                    }.sheet(isPresented: $isPresented) {
                //                        ViewControllerRepresentableView(identifier: $clasificationIdentifier)
                //                            .ignoresSafeArea()
                //                    }
                if clasificationIdentifier.count == 0 {
                    ViewControllerRepresentableView(identifier: $clasificationIdentifier)
                        .ignoresSafeArea()
                }else{
                    VStack(alignment: .leading) {
                        // Date headline
                        if clasificationIdentifier.count > 0 {
                            VStack {
                                ScrollView{
                                    ForEach(0...clasificationIdentifier.count-1, id:\.self){count in
                                        let product = clasificationIdentifier[count]
                                        eventCell(product).background(alignment: .leading){
                                            Rectangle().frame(width: 1).offset(x:8)
                                                .padding(.bottom, -35)
                                        }.padding(.vertical,10)
                                        
                                    }
                                }
                            }
                        }
                        
                        
                    }
            }
            }
        }
    func eventCell(_ event: CalendarEvent) -> some View {
        return  AnyView (
            HStack(alignment: .top, spacing: 15){
                Circle()
                    .fill(.blue)
                    .frame(width: 10, height: 10)
                    .padding(4)
                    .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in:.circle)
                VStack(alignment: .leading, spacing: 8, content: {
                    Text(event.summary ?? "").bold()
                    Label("\(event.start?.formatted(.dateTime.hour().minute()) ?? "")-\(event.end?.formatted(.dateTime.hour().minute()) ?? "")", systemImage: "clock").font(.caption).foregroundStyle(.black)
                    Spacer().frame(maxWidth:.infinity)
                })
                .padding(15)
                .background(.blue, in: .rect(cornerRadius: 15))
                .offset(y:-8)
            }
//            VStack (alignment: .leading) {
//                Text(event.summary ?? "").bold()
//                Text(event.start?.formatted(.dateTime.hour().minute()) ?? "")
//                Text("\(event.startTime ?? "")\(event.startTimeOfDay ?? "")-\(event.endTime ?? "")\(event.endTimeOfDay ?? "")")
//            }
//        .font(.caption)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(4)
//                .frame(height: height, alignment: .top)
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(.teal).opacity(0.5)
//                )
//                .padding(.trailing, 3)
//                .offset(x: 3, y: offset + 24)
        )
    }
}


#Preview {
    CalendarView()
}
