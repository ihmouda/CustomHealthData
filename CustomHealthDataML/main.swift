//
//  main.swift
//  HealthTechML
//
//  Created by mihmouda on 27/10/2023.
//

import Foundation
import Speech

// 1
let data = SFCustomLanguageModelData(locale: Locale(identifier: "en_US"),
                                     identifier: "com.lemona.health.ml",
                                     version: "1.0") {
    
    // 2
     
    // 2.1
    SFCustomLanguageModelData.PhraseCount(phrase: "I have headache, I need acamol",
                                          count: 1000)

    // 2.2
     SFCustomLanguageModelData.PhraseCountsFromTemplates(classes: [
        "illness": ["headache", "stomach"],
        "medicine": ["acamol", "trofen"]
    ]) {
        SFCustomLanguageModelData.TemplatePhraseCountGenerator.Template(
            "I have <illness>, I need <medicine>",
            count: 1000
        )
      }
    
    // 2.3
    SFCustomLanguageModelData.CustomPronunciation(grapheme: "Tramadol",
                                                  phonemes: ["tra' ma doll"])
    }

// 3
try await data.export(to: URL(filePath: "/Users/mihmouda/Documents/test/CustomLMData.bin"))

