//
//  ContentView.swift
//  Bemayu
//
//  Created by cmStudent on 2022/10/19.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel = .shared
    
//    init(){
//        self.launchStatus = LaunchUtil.launchStatus
//    }
    
    // 初回起動なら顔スキャン画面を出す。
    
    var body: some View {
        Group {
            if viewModel.didSetup {
                MainView()
                
            } else {
                FirstView()
            }
        }
        
    }
}

enum LaunchStatus {
    case FirstLaunch
    case NewVersionLaunch
    case Launched
}

class LaunchUtil {
    @AppStorage(launchedVersionKey) static var launchedVersion = ""
    
    static var launchStatus: LaunchStatus {
        get{
            if launchedVersion == "" {
                return .FirstLaunch
            }
            
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let launchedVersion = self.launchedVersion
            
            self.launchedVersion = version
            
            return version == launchedVersion ? .Launched : .NewVersionLaunch
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var didSetup = false
    static let shared: ContentViewModel = .init()
    
    private init() {
        self.switchStatus()
    }
    
    func switchStatus() {
        switch LaunchUtil.launchStatus {
        case .FirstLaunch:
            self.didSetup = false
        case .NewVersionLaunch:
            self.didSetup = true
        case .Launched:
            self.didSetup = true
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
