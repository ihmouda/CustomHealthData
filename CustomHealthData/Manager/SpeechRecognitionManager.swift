//
//  SpeechRecognitionManager.swift
//  HealthTech
//
//  Created by mihmouda on 27/10/2023.
//

import Speech
import AVFAudio

class SpeechRecognitionManager: ObservableObject {
    
    @Published var resultString: String?
    @Published var isAvaliable: Bool = false
    
    var audioEngine = AVAudioEngine()
    var request: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    
    var lmConfiguration: SFSpeechLanguageModel.Configuration {
        let outputDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dynamicLanguageModel = outputDir.appendingPathComponent("LM")
        let dynamicVocabulary = outputDir.appendingPathComponent("Vocab")
        return SFSpeechLanguageModel.Configuration(languageModel: dynamicLanguageModel, vocabulary: dynamicVocabulary)
    }
    
    init() {
        
        
        // Make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            // Divert to the app's main thread so that the UI
            // can be updated.
            switch authStatus {
            case .authorized:
                
                self.isAvaliable = true
                
                Task.detached {
                    do {
                        let assetPath = Bundle.main.path(forResource: "CustomLMData",
                                                         ofType: "bin")!
                        let assetUrl = URL(fileURLWithPath: assetPath)
                        try await SFSpeechLanguageModel.prepareCustomLanguageModel(for: assetUrl,
                                                                                   clientIdentifier: "com.lemona.health.ml",
                                                                                   configuration: self.lmConfiguration)
                    } catch {
                        NSLog("Failed to prepare custom LM: \(error.localizedDescription)")
                    }
                }
                
            default:
                self.isAvaliable = false
            }
        }
    }
    
    func requestSpeech() throws {
        
        self.isAvaliable = false
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = true
        request.customizedLanguageModel = self.lmConfiguration
        request.contextualStrings = ["headache", "acamol"]

        recognitionTask = speechRecognizer?.recognitionTask(with: request) { (result, error) in
            if let result = result  {
                
                DispatchQueue.main.async {
                    self.resultString = result.bestTranscription.formattedString
                }
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.request?.append(buffer)
        }
        
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
}
