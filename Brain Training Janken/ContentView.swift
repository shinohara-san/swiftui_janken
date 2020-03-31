import SwiftUI

struct ContentView: View {
    
    let backgroundColor = RadialGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple])
        , center: .center, startRadius: 50, endRadius: 200)
    
    let missions = ["Win!", "Lose!"]
    let comments = ["","Good Job!", "Nice try..."]
    let hands = ["rock", "scissors", "paper"]
    @State var score = 0
    @State var missionNum = Int.random(in: 0...1)
    @State var commentsNum = 0
    @State var handsNum = Int.random(in: 0...2)
    
    @ObservedObject var jankenTimer = JankenTimer()
    @State var timerIsRunning = false
    
    func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.missionNum = Int.random(in: 0...1)
            self.handsNum = Int.random(in: 0...2)
            self.commentsNum = 0
        }
    }

    
    func addScore(){
        self.score += 5
        self.commentsNum = 1
    }
    
    func minusScore(){
        self.commentsNum = 2
        self.score -= 3
    }
    
    func start(){
        self.jankenTimer.start()
        self.timerIsRunning = true
    }
    
    
    var body: some View {
        
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                Text("You have to...")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(.bottom)
                Text("\(missions[missionNum])")
                    .frame(width: 250).padding().font(.largeTitle).background(Color.white).cornerRadius(20).foregroundColor(.pink)
                Spacer()
                HStack {
                    VStack {
                        Text("CPU Hand").font(.title).foregroundColor(.white)
                        Image("\(hands[handsNum])").resizable().frame(width: 200.0, height: 200.0)
                    }
                    
                    
                    VStack {
                        Text("Your Hand").font(.title).foregroundColor(.white)
                        Group {
                            ForEach(hands, id: \.self){hand in
                                Button(action: {
                                    switch hand{
                                    case "rock":
                                        if self.missionNum == 0 && self.handsNum == 1 || self.missionNum == 1 && self.handsNum == 2{
                                            self.addScore()
                                            self.reset()
                                        } else {
                                            self.minusScore()
                                            self.reset()
                                        }
                                    case "scissors":
                                        if self.missionNum == 0 && self.handsNum == 2 || self.missionNum == 1 && self.handsNum == 0{
                                            self.addScore()
                                            self.reset()
                                        } else {
                                            self.minusScore()
                                            self.reset()
                                        }
                                        
                                    case "paper":
                                        if self.missionNum == 0 && self.handsNum == 0 || self.missionNum == 1 && self.handsNum == 1{
                                            self.addScore()
                                            self.reset()
                                        } else {
                                            self.minusScore()
                                            self.reset()
                                        }
                                    default:
                                        print("エラー")
                                        
                                    }
                                    
                                    
                                }) {                                    Image(hand).resizable().renderingMode(.original)
                                }
                            }
                        }
                    }
                }.padding()
                Text("\(comments[commentsNum])")
                    .padding().font(.title).foregroundColor(.white).frame(width: 200, height: 20)
                Text("SCORE: \(score)点").padding().font(.title).foregroundColor(.white)
                
                Button(action: {
                    if self.timerIsRunning{
                        self.jankenTimer.stop()
                        self.timerIsRunning = false
                    } else {
                        self.start()
                        self.reset()
                    }
                    
                }) {
                    Group{
                        if self.timerIsRunning{
                            Text("\(self.jankenTimer.counter)")
                        } else {
                            Text("Start")
                        }
                    }
                }.padding().frame(width: 250.0).font(.largeTitle).background(Color.pink).cornerRadius(20).foregroundColor(Color.white)
                Spacer()
            }.alert(isPresented: self.$jankenTimer.timeup, content: {
                Alert(title: Text("Time is Up"), message: Text("Your score is \(self.score)"), primaryButton: .default(Text("OK"), action:{}), secondaryButton: .default(Text("Again"), action:{
                    self.jankenTimer.timeup = false
                    self.jankenTimer.counter = 10
                    self.start()
                    self.reset()
                    self.score = 0
                }))
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
