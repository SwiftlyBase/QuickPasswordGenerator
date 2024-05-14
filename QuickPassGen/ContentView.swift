//
//  ContentView.swift
//  QuickPassGen
//
//  Created by Mario Saputra on 2023/07/17.
//

struct PasswordGenerator {
    var length: Int
    
    var includeSymbols: Bool
    
    var numbersOnly: Bool
    
    func generate() -> String {
        
        let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let numbers = "0123456789"
        let symbols = "!@#$%^&*(){}[]=<>,.?/:;~`|"
        
        let baseCharacters = numbersOnly ? numbers : lettersAndNumbers
        let characters = includeSymbols && !numbersOnly ? (baseCharacters + symbols) : baseCharacters

        var password = ""
        for _ in 0..<length {
            if let character = characters.randomElement() {
                password.append(character)
            }
        }
        return password
    }
}

import SwiftUI

struct ContentView: View {
    @State private var passwordLength = Double(8)
    @State private var generatedPassword = ""
    @State private var includeSymbols = true
    @State private var numbersOnly = false

    private var passwordGenerator: PasswordGenerator {
        PasswordGenerator(length: Int(passwordLength), includeSymbols: includeSymbols,  numbersOnly: numbersOnly)
    }

    var body: some View {
        VStack {
            Text("QuickPassGen")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(Color.white)
                .padding(.bottom, 50)

            Text("\(generatedPassword)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.bottom, 50)
                .onTapGesture {
                    UIPasteboard.general.string = generatedPassword
                }

            Slider(value: $passwordLength, in: 1...20, step: 1)
                .padding(.horizontal, 50)
            
            Text(String(format: NSLocalizedString("pass_length_str", comment: ""), Int(passwordLength)))
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(Color.white)
                .padding(.bottom, 50)

            
            Toggle(isOn: $includeSymbols) {
                Text(NSLocalizedString("symbols_str", comment: ""))
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 50)
            .onChange(of: includeSymbols) { newValue in
                if newValue {
                    numbersOnly = false
                }
            }
            
            Toggle(isOn: $numbersOnly) {
                Text(NSLocalizedString("numbers_only_str", comment: ""))
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 50)
            .onChange(of: numbersOnly) { newValue in
                if newValue {
                    includeSymbols = false
                }
            }
            

            Button(action: {
                generatedPassword = passwordGenerator.generate()
            }) {
                Text(NSLocalizedString("generate_password_str", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 40)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
            
            Button(action: {
                UIPasteboard.general.string = generatedPassword
            }) {
                Text(NSLocalizedString("copy_password_str", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 40)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            .padding(.top, 10)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea(edges: .all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

