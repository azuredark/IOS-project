import Cocoa

// 처음 주어진 코드
struct Grade {
    var letter: Character
    var points: Double
    var credits: Double
}

class Person {
    var firstName: String
    var lastName: String

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    func printMyName() {
        print("My name is \(firstName) \(lastName)")
    }
}

class Student: Person { //상속
    var grades: [Grade] = []

}
let jay = Person(firstName: "Jay", lastName: "Lee")
let jason = Student(firstName: "Jason", lastName: "Lee")

jay.firstName
jason.firstName

jay.printMyName()
jason.printMyName()

let math = Grade(letter: "B", points: 8.5, credits: 3)
let history = Grade(letter: "A", points: 10.0, credits: 4)
jason.grades.append(math)
jason.grades.append(history)
jason.grades.count

//jay.grades 는 불가능하다. why? Student만 상속을 받았기때문에.

//학생인데 운동선수

class StudentAthelete: Student{
    var minimumTrainingTime: Int = 2
    var trainedTime: Int = 0
    
    func train(){
        trainedTime += 1
    }
}

//운동선수인데 축구선수..
class FootballPlayer: StudentAthelete{
    var footballTeam = "FC Swift"
    
    override func train() {
        trainedTime += 2
    }
}
// Person > Student > Athelete > Football Player

var athelete1 = StudentAthelete(firstName: "Yuna", lastName: "Kim")
var athelete2 = FootballPlayer(firstName: "Heung", lastName: "Son")

athelete1.firstName
athelete2.firstName

//athelete1.grades.append(math)
athelete2.grades.append(math)

athelete1.minimumTrainingTime
athelete2.minimumTrainingTime

athelete2.footballTeam

athelete1.train()
athelete1.trainedTime

athelete2.train()
athelete2.trainedTime


athelete1 = athelete2 as StudentAthelete //uppercasting
athelete1.train()
athelete1.trainedTime

if let son = athelete1 as? FootballPlayer{ //downcasting
    print("---> team: \(son.footballTeam)")
}

// 상속에 대한 개념,, !


