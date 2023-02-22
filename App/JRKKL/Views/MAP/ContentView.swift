import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var locationManager = LocationManager()
    @State private var checkInView = false
    @State private var checkInNumber = 0
    @State private var tappedLocation: CLLocationCoordinate2D?
    @State private var showLookAround = false
    @State private var showUserLocation = false
    let alertTitle: String = "位置情報サービスをオンにして使用して下さい。"
    let screen = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            MapView(checkInView: $checkInView, checkInNumber: $checkInNumber, tappedLocation: $tappedLocation, showUserLocation: $showUserLocation)
                .ignoresSafeArea()
            HStack {
                VStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding()
                            .background(.ultraThickMaterial)
                            .cornerRadius(50)
                    }
                    Spacer()
                }
                .padding(.leading)
                Spacer()
                VStack {
                    Button {

                    } label: {
                        Image(systemName: "map.fill")
                            .foregroundColor(.gray)
                            .padding()
                            .background(.ultraThickMaterial)
                            .cornerRadius(8)
                    }
                    Button {
                        self.showUserLocation.toggle()
                    } label: {
                        Image(systemName: showUserLocation ? "location.fill" : "location")
                            .foregroundColor(showUserLocation ? .blue : .gray)
                            .padding()
                            .background(.ultraThickMaterial)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.trailing)
            }
            .padding(.top)
            .alert(alertTitle, isPresented: $locationManager.isDenied) {
                Button {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } label: {
                    Text("'設定'でオンにする")
                }
                Button("位置情報サービスをオフのままにする") {
                }
            } message: {
                Text("位置情報サービスをオンにして利用する機能となっております。設定から位置情報の許可をお願いします")
            }
            if tappedLocation != nil {
                LookAroundView(tappedlocation: $tappedLocation, showLookAroundView: $showLookAround)
                    .frame(maxWidth: screen.width * 0.5, maxHeight: screen.height * 0.15)
                    .cornerRadius(5)
                    .padding(.bottom)
                    .padding(.leading)
                    .offset(x: screen.width * -0.25, y: screen.height * 0.30)
            }
            CheckInView(locationManager: locationManager, checkInView: $checkInView ,checkInNumber: $checkInNumber)
                .opacity(checkInView ? 1 : 0)
                .scaleEffect(checkInView ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: checkInView)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
