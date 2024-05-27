import SwiftUI

struct ContentView: View {
    @State private var numberOfTables = 2
    @State private var rounds = [2, 5, 10, 20]
    @State private var userAnswer = ""
    @State private var textDisplay = ""
    @State private var randomNumber = 0
    @State private var randomUser = 0
    @State private var score = 0
    @State private var negativeScore = 0
    @State private var alertBool = false
    @State private var roundsCount = 0
    @State private var selectedRounds = 5
    
    let letters = Array("Play with Numbers")
        @State private var enabled = false
        @State private var dragAmount = CGSize.zero

    var body: some View {
        ZStack {
            Image("YellowPic")
                .resizable()
                .ignoresSafeArea()

            VStack {
                HStack(spacing: 0) {
                                    ForEach(0..<letters.count, id: \.self) { num in
                                        Text(String(letters[num]))
                                            .padding(4)
                                            .font(.title)
                                            .background(enabled ? .blue : .yellow)
                                            .offset(dragAmount)
                                            .animation(.linear.delay(Double(num) / 20), value: dragAmount)
                                    }
                                }
                                .gesture(
                                    DragGesture()
                                        .onChanged { dragAmount = $0.translation }
                                        .onEnded { _ in
                                            dragAmount = .zero
                                            enabled.toggle()
                                        }
                                )
                Spacer()

                Section() {
                    Stepper("Tables selected: \(numberOfTables.formatted())", value: $numberOfTables, in: 2...12)
                }
                .padding(8)
                .bold()
                .background(Color("ColorR"))
                .cornerRadius(8)
                .onChange(of: numberOfTables) { _ in
                    generateNewQuestion()
                }

                Spacer()

                Text("Number of Rounds")
                    .font(.title)
                    .padding()
                    .background(Color("ColorR"))
                    .cornerRadius(8)

                Section {
                    Picker("Select", selection: $selectedRounds) {
                        ForEach(rounds, id: \.self) { round in
                            Text("\(round)")
                        }
                    }
                    .pickerStyle(.wheel)
                }
                .padding()
                
                Text("Let's Go: \(randomNumber) x \(randomUser)")
                    .font(.title)
                    .padding()
                    .background(Color("ColorR"))
                    .cornerRadius(8)

                Section("Ready to answer?!") {
                    TextField("Place your answer", text: $userAnswer)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color("ColorR"))
                        .cornerRadius(8)
                        .keyboardType(.numberPad)
                }
                .padding()
                .foregroundColor(.blue)
                .bold()

                Button("Submit") {
                    submitAnswer()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Text("\(textDisplay)")
                    .font(.title)
                    .padding()
            }
            .padding()
            
            .alert("The game is over", isPresented: $alertBool) {
                Button("Restart", action: terminal)
            } message: {
                Text("""
                        Your final score is \(score)
                        Incorrect answers: \(negativeScore)
                    """)
                    .fontWeight(.bold)
            }
            
        }
        .onAppear {
            generateNewQuestion()
        }
    }
    
    func generateNewQuestion() {
        randomNumber = Int.random(in: 2...12)
        randomUser = Int.random(in: 2...numberOfTables)
    }
    
    func submitAnswer() {
        if let result = Int(userAnswer.trimmingCharacters(in: .whitespaces)), result == randomNumber * randomUser {
            textDisplay = "Hooray!"
            score += 1
        } else {
            textDisplay = "Boooo!"
            negativeScore += 1
        }
        roundsCount += 1
        userAnswer = ""
        
        if roundsCount == selectedRounds{
            alertBool = true
        } else {
            generateNewQuestion()
        }
    }
    
    func terminal() {
        score = 0
        userAnswer = ""
        numberOfTables = 2
        roundsCount = 0
        generateNewQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
