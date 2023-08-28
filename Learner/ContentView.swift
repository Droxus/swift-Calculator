//
//  ContentView.swift
//  Learner
//
//  Created by Oleksandr Krasnovidov on 27.08.2023.
//

import SwiftUI


struct ContentView: View {
    enum Field: Hashable {
        case labelField
    }
    
    @State private var numField = 0.0
    @State private var strField = "0"
    @State private var labelField = ""
    @State private var lastAction = "+"
    @State private var operatorCharacters: [Character] = ["+", "-", "*", "/"]
    @State private var operators: [String] = ["+", "-", "*", "/"]
    @State private var isTextFieldFocused: Bool = true
    
    @FocusState private var focusedField: Field?
    var body: some View {
            VStack(spacing: 8) {
                VStack {
                    Image(systemName: "globe")
                        .padding(.bottom, 10.0)
                        .frame(width: 0.0)
                        .imageScale(.large)
                        .foregroundColor(.red)
                        .accentColor(.green)
                    
                    Text("The Best Calculator In The World").foregroundColor(.red)
                }
                .padding(.top, -150.0)
                HStack(spacing: 12) {
                    Rectangle()
                        .foregroundColor(Color(hue: 0.51, saturation: 0.444, brightness: 0.595))
                        .cornerRadius(10)
                        .frame(width: 252.0, height: 58.0)
                        .overlay(
                            TextField("Output", text: $labelField)
                                .focused($focusedField, equals: .labelField)
                                .foregroundColor(.white)
                                .padding()
                                .font(.title)
                                .multilineTextAlignment(.leading)
                                .frame(width: 252.0, height: 58.0)
                        )
                    Button("=") {
                        makeAction(action: "+")
                        formateResult()
                    }
                    .foregroundColor(.white)
                    .frame(width: 48.0, height: 28.0)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color(hue: 0.066, saturation: 1.0, brightness: 1.0))
                    .cornerRadius(10)
                        
                }
                .padding(.top, 28.0)
                .frame(width: 312.0, height: 32.0)
                HStack(spacing: 12) {
                    VStack(spacing: 8) {
                        ForEach(0..<3) { row in
                            HStack(spacing: 8) {
                                ForEach(0..<3) { column in
                                    Button("\(row * 3 + column + 1)") {
                                        pushCharToInput(character:"\(row * 3 + column + 1)")
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: 48.0, height: 28.0)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 32.0)
                    VStack(spacing: 8) {
                        ForEach(operators, id: \.self) { operatorSymbol in
                            Button("\(operatorSymbol)") {
                                makeAction(action: "\(operatorSymbol)")
                            }
                            .foregroundColor(.white)
                            .frame(width: 48.0, height: 28.0)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.top, 32.0)
                }
                HStack(spacing: 8) {
                    Button("C") {
                        clearInput()
                    }
                    .foregroundColor(.white)
                    .frame(width: 48.0, height: 28.0)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Button("," ) {
                        pushCommaToInput()
                    }
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .frame(width: 48.0, height: 28.0)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                    Button("0") {
                        pushCharToInput(character:  "0")
                    }
                    .foregroundColor(.white)
                    .frame(width: 48.0, height: 28.0)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(10)
                }
                .padding(.top, -68.0)
                .padding(.trailing, 88.0)
                
                Button("AC") {
                    clearAllInput()
                }
                .foregroundColor(.white)
                .frame(width: 312.0, height: 20.0)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
            }
        }
    
    func makeAction(action: String) {
        focusedField = .labelField
            switch lastAction {
            case "-":
                numField -= Double(strField)!
            case "*":
                numField *= Double(strField)!
            case "/":
                numField /= Double(strField)!
            default:
                numField += Double(strField)!
            }
            
            lastAction = action
            strField = "0"
            if let lastCharacter = labelField.last, operatorCharacters.contains(lastCharacter) {
                labelField.removeLast()
                labelField.append(action)
            } else {
                labelField += action
            }
    }
    func pushCharToInput(character: String) {
        focusedField = .labelField
        strField += character
        labelField += character
    }
    func pushCommaToInput() {
        focusedField = .labelField
        if !strField.contains(".") {
            if strField.count < 2 && labelField != "0" {
                strField += "0."
                labelField += "0,"
            } else {
                strField += "."
                labelField += ","
            }
        }
    }
    func clearAllInput() {
        focusedField = .labelField
        numField = 0.0
        strField = "0"
        labelField = ""
        lastAction = "+"
    }
    func clearInput() {
        focusedField = .labelField
        strField = "0"
        if let lastIndex = labelField.lastIndex(where: { operatorCharacters.contains($0)}) {
            let endIndex = labelField.index(after: lastIndex)
            labelField = String(labelField[..<endIndex])
        } else {
            labelField = ""
            numField = 0.0
        }
    }
    func formateResult() {
        focusedField = .labelField
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 10
        if numField != Double.infinity && numField != -Double.infinity {
            labelField = formatter.string(from: NSNumber(value: numField))!
        } else {
            labelField = "0"
        }
        numField = 0.0
        strField = String(labelField)
        strField = strField.replacingOccurrences(of: ",", with: ".")
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
