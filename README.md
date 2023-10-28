# CustomHealthData

[![License](https://img.shields.io/cocoapods/l/JNMentionTextView.svg?style=flat)](https://cocoapods.org/pods/JNMentionTextView)
[![Platform](https://img.shields.io/cocoapods/p/JNMentionTextView.svg?style=flat)](https://cocoapods.org/pods/JNMentionTextView)

**Custom on-device speech recognition**
<br>
Improve on-device speech recognition  by customizing the language model


## Preview

<img src="https://github.com/ihmouda/GitHubRepositories/raw/main/CustomHealthData/Resources/images/a_camel.png" width="260"/>

<img src="https://github.com/ihmouda/GitHubRepositories/raw/main/CustomHealthData/Resources/images/acamol.png" width="260"/>


## Requirements

- Xcode 15+
- iOS 17.0+
- Swift 5+


## Installation

you will need to have Git installed on your system. If you don't have Git installed, you can download it from the official website: [Git Downloads](https://git-scm.com/downloads)
.
Once you have Git installed, you can clone this repository to your local machine using the following command:

```swift
git clone https://github.com/ihmouda/CustomHealthData.git
```


## Overview:

This sample project demonstrates how to customize and improve the accurecy of the speech framework tailor to user application’s domain to recognize words from captured audio. When the user taps the mic button, the app begins capturing user’s voice commands and send back the recognized text.

## Usage:


- **Data Generation:**

    This code project includes a command-line utility named “CustomHealthDataML” that produces a training data binary file. You can add your code to train and customize the language model with a collection of items using result builder DSL.
    
    ```swift
    import Speech
    
    let data = SFCustomLanguageModelData(locale: Locale(identifier: "en_US"),
                                     identifier: "com.lemona.health",
                                     version: "1.0") {
                                     
    SFCustomLanguageModelData.PhraseCount(phrase: "I have headache, I need acamol",
                                          count: 1000)

     SFCustomLanguageModelData.PhraseCountsFromTemplates(classes: [
        "illness": ["headache", "stomach"],
        "medicine": ["acamol", "trofen"]
    ]) {
        SFCustomLanguageModelData.TemplatePhraseCountGenerator.Template(
            "I have <illness>, I need <medicine>",
            count: 1000
        )
      }
    }

    SFCustomLanguageModelData.CustomPronunciation(grapheme: "Tramadol",
                                                  phonemes: ["tra' ma doll"])

    try await data.export(to: URL(filePath: "/[path]/CustomLMData.bin"))
    ```

- **Configure the Speech Request:**

    Configure the request to start using our customized language model with trained data binary file..
    

    ```swift
    Task.detached {
        do {
            let assetPath = Bundle.main.path(forResource: "CustomLMData",
                                             ofType: "bin",
                                             inDirectory: "[path]")!
    
            let assetUrl = URL(fileURLWithPath: assetPath)
    
            try await SFSpeechLanguageModel.prepareCustomLanguageModel(for: assetUrl,
                                                                       clientIdentifier: "com.lemona.health",
                                                                       configuration: self.lmConfiguration)
        } catch {
            NSLog("Failed to prepare custom LM: \(error.localizedDescription)")
        }
    }
    ```


    ```swift
    request.requiresOnDeviceRecognition = true
    request.customizedLanguageModel = self.lmConfiguration
    ```

### Refer to my article on [hashnode](https://github.com/ihmouda/CustomHealthData/blob/master/LICENSE) for full documentation.


## Author

Mohammad Ihmouda

## License

CustomHealthData is available under the MIT license. See the [LICENSE](https://github.com/ihmouda/CustomHealthData/blob/master/LICENSE) file for more info.
