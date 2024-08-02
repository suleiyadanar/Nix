//
//  Sort1View.swift
//  Nix
//
//  Created by Su Lei Yadanar on 7/31/24.
//

import SwiftUI

struct Sort1View: View {
    var props: Properties
    @State private var sortItems: [SortItem] = []
    @State private var currentIndex = 0
    @State private var selectedOptions: [Int] = [] // Array to store selected options
    @State private var selectedOption = 0 // Track currently selected option
    @State private var showResults = false // Flag to show results view
    @State private var result: String? = nil // Store result here

    var body: some View {
        ZStack {
            OnboardingBackgroundView()
            
            if showResults {
                MessageBoxView(
                    props: props,
                    question: "Results",
                    options: [],
                    selectedOption: $selectedOption,
                    onArrowButtonPressed: {},
                    onOptionSelected: { _ in },
                    result: result
                )
            } else {
                VStack {
                    // Display question index
                    HStack {
                        Spacer()
                        Text("\(currentIndex + 1)/\(sortItems.count)")
                            .font(.custom("Courier", size: 16))
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    MessageBoxView(
                        props: props,
                        question: sortItems.isEmpty ? "" : sortItems[currentIndex].question,
                        options: sortItems.isEmpty ? [] : sortItems[currentIndex].options,
                        selectedOption: $selectedOption,
                        onArrowButtonPressed: handleArrowButtonPress,
                        onOptionSelected: saveSelectedOption
                    )
                }
            }
        }
        .onAppear {
            loadData()
        }
    }

    func loadData() {
        sortItems = loadJsonFromBundle(fileName: "sortingQuestions")
    }

    func handleArrowButtonPress() {
        // Save the selected option before moving to the next question
        if selectedOptions.count <= currentIndex {
            selectedOptions.append(selectedOption)
        } else {
            selectedOptions[currentIndex] = selectedOption
        }

        if currentIndex < sortItems.count - 1 {
            currentIndex += 1
            selectedOption = 0 // Set default selection for next question
        } else {
            // All questions answered, calculate results
            calculateResult()
            showResults = true
        }
    }

    func saveSelectedOption(index: Int) {
        selectedOption = index
    }

    func calculateResult() {
        // Count the number of selections for each option
        print("selectedOptions", selectedOptions)
        let optionCounts = [0, 1, 2, 3].map { option in
            selectedOptions.filter { $0 == option }.count
        }
        print("option counts", optionCounts)

        let maxCount = optionCounts.max() ?? 0
        let mostSelectedOptions = optionCounts.indices.filter { optionCounts[$0] == maxCount }
        print("max count", mostSelectedOptions)

        // Map option indices to result strings
        let resultOptions = ["air", "water", "earth", "fire"]
        
        // Select a random result if there is a tie
        let resultOptionIndex = mostSelectedOptions.randomElement() ?? 0
        result = resultOptions[resultOptionIndex]
    }

    func loadJsonFromBundle(fileName: String) -> [SortItem] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            fatalError("Failed to locate file in bundle.")
        }

        do {
            let jsonData = try JSONDecoder().decode([String: [SortItem]].self, from: data)
            guard let questions = jsonData["questions"] else {
                fatalError("Failed to decode JSON.")
            }
            return questions
        } catch {
            fatalError("Failed to decode JSON: \(error)")
        }
    }
}

struct SortItem: Codable {
    let question: String
    let options: [String]
}

//#Preview {
//    Sort1View()
//}



//#Preview {
//    Sort1View()
//}

//#Preview {
//    Sort1View()
//}
