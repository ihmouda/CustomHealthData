//
//  ContentView.swift
//  HealthTech
//
//  Created by mihmouda on 27/10/2023.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var speechRecognitionManager = SpeechRecognitionManager()

    var body: some View {
        VStack {
            
            Text(self.speechRecognitionManager.resultString ?? "Please Speak")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Button(action: {
                                
                do {
                    try self.speechRecognitionManager.requestSpeech()
                } catch {
                    
                }
                
            }, label: {
                
                Image("mic")
                    .renderingMode(.template)
                    .resizable()
                    .padding(20)
                    .frame(width: 100.0, height: 100.0)
                    .clipShape(Circle())
            })
            .frame(width: 100, height: 100)
            .disabled(!speechRecognitionManager.isAvaliable)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
