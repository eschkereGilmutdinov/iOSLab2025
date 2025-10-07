import SwiftUI

struct ContentView: View {
    @State var number = 0
    @State var enter = ""
    @State var feedback = "Выбери диапазон чисел"
    @State var attempts = 0
    @State var gameOver = false
    @State var win = 0
    @State var lose = 0
    @State var minNumber = 1
    @State var maxNumber = 100
    @State var showSettings = true
    @State var startGame = false
    
    var body: some View {
        VStack {
            if startGame {
                Text("Угадай число")
                    .font(.title)
                    .padding()
                
                Text("От \(minNumber) до \(maxNumber)")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text(feedback)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(minHeight: 80)
                
                TextField("Твое число", text: $enter)
                    //.keyboardType(.numberPad) чето не работает
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Проверить") {
                    checkNumber()
                }
                .padding()
                .disabled(gameOver)
                
                Text("Попыток: \(attempts) из 10")
                    .padding()
                
                if gameOver {
                    VStack {
                        Button("Новая игра") {
                            saveSettings()
                            if minNumber < maxNumber {
                                startGame = true
                                newGame()
                            }
                            startGame = false
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            } else {
                Text("Выбери диапазон чисел")
                    .font(.title)
                    .padding()
                
                Spacer()
                
                VStack {
                    Text("От")
                        .font(.headline)
                    TextField("Минимум", value: $minNumber, formatter: NumberFormatter())
                        //.keyboardType(.numberPad) чето не работает
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Text("До")
                        .font(.headline)
                    TextField("Максимум", value: $maxNumber, formatter: NumberFormatter())
                        //.keyboardType(.numberPad) чето не работает
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Spacer()
                
                Button("Сохранить и начать игру") {
                    saveSettings()
                    startGame = true
                    newGame()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                VStack {
                    Text("Победы: \(win)")
                        .foregroundColor(.green)
                    Text("Поражения: \(lose)")
                        .foregroundColor(.red)
                }
                Spacer()
            }
            .padding()
        }
        .padding()
    }
    
    func newGame() {
        number = Int.random(in: minNumber...maxNumber)
        enter = ""
        feedback = "Введи число от \(minNumber) до \(maxNumber)"
        attempts = 0
        gameOver = false
    }
    
    func checkNumber() {
        guard let myNumber = Int(enter) else {
            feedback = "Надо ввести число!"
            return
        }
        
        if myNumber < minNumber || myNumber > maxNumber {
            feedback = "Число должно быть от \(minNumber) до \(maxNumber)!"
            return
        }
        
        attempts += 1
        
        if myNumber == number {
            feedback = "Ура! Ты угадал! Это было число \(number) 🎉"
            gameOver = true
            win += 1
        } else if attempts >= 10 {
            feedback = "Игра окончена 😢 Загаданное число было \(number)"
            gameOver = true
            lose += 1
        } else {
            if myNumber < number {
                feedback = "Больше! 🔺 Осталось попыток: \(10 - attempts)"
            } else {
                feedback = "Меньше! 🔻 Осталось попыток: \(10 - attempts)"
            }
        }
        
        enter = ""
    }
    
    func saveSettings() {
        guard minNumber < maxNumber else {
            minNumber = 1
            maxNumber = 100
            return
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
