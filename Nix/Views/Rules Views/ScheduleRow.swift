import SwiftUI

struct ScheduleRow: View {
    var item: ScheduleItem
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                // Color tag on the left
                HStack {
                    UnevenRoundedRectangle(cornerRadii: .init(
                        topLeading: 15.0,
                        bottomLeading: 15.0,
                        bottomTrailing: 0,
                        topTrailing: 0),
                                           style: .continuous)
                    .fill(item.color)
                    .frame(width: 13, height: CGFloat(item.duration) * 63)
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    VStack {
                        HStack {
                            Text(item.title)
                                .font(.system(size: 16))
                                .padding(.bottom, 2)
                            Spacer()
                            if item.isSuggested {
                                Button(action: {
                                    // Add action
                                }) {
                                    HStack {
                                        Text("Add")
                                            .font(.system(size: 10))
                                            .foregroundStyle(Color.mauve)
                                            .offset(x: 1)
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: 10))
                                            .font(.headline)
                                            .foregroundColor(.mauve)
                                            .offset(x: -1)
                                    }
                                    .padding(3)
                                    .background(Color.lemon)
                                    .cornerRadius(20)
                                    .padding(.trailing, 5)
                                }
                            }
                        }
                    
                       
                        if item.hasAlarm {
                            HStack {
                                Image(systemName: "bell")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                Text("Before 15 minutes")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "plus")
                               .font(.system(size: 10, weight: .semibold))
                               .foregroundColor(.gray)
                        }
                        HStack {
                            Image(systemName: "clock")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(item.formattedTime)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(item.appsBlocked) apps blocked")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                    
                }
                
            }
            .frame(width: 280, height: CGFloat(item.duration) * 63) // Control the height based on duration
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 5, y: 5)
            )
            .padding(.bottom, 5)
        }
    }
}

// Sample preview with the current ScheduleItem structure
struct ScheduleRow_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRow(item: ScheduleItem(startTime: "10:00am", endTime: "11:00am", title: "Morning study session", details: "", color: Color.red, appsBlocked: 10, hasAlarm: true, isSuggested: false))
    }
}
