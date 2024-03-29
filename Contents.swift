import Foundation

// MARK: - Retain cycle 2 კლასის გამოყენებით.
class Library {
    var book: Book?
    
    deinit {
        print("Library deinitialized")
    }
}

class Book {
    var library: Library?
    
    deinit {
        print("Book deinitialized")
    }
}

var library: Library? = Library()
var book: Book? = Book()

library?.book = book
book?.library = library

library = nil
book = nil

// MARK: - გასწორება Retain cycle-ის 2 კლასის და weak reference type-ის გამოყენებით.
class Owner {
    weak var dog: Dog?
    
    deinit {
        print("Owner deinitialized")
    }
}

class Dog {
    var owner: Owner?
    
    deinit {
        print("Dog deinitialized")
    }
}

var owner: Owner? = Owner()
var dog: Dog? = Dog()

owner?.dog = dog
dog?.owner = owner

owner = nil
dog = nil

// MARK: ამ შემთხვევაში გვაქვს reference type და value type რის გამოც retain cycle არ ხდება და იძახება deinit.
class Car {
    var superCar: SuperCar?
    
    deinit {
        print("Car deinitialized")
    }
}

struct SuperCar {
    var car: Car?
}

var car: Car? = Car()
var superCar: SuperCar? = SuperCar()

car?.superCar = superCar
superCar?.car = car

car = nil
superCar = nil

// MARK: - Closure სადაც self-ის capture ხდება strong-ად რაც იწვევს memory leaks და არ ხდება class-ის deinit.
class Person {
    var closure: (() -> Void)?
    
    deinit {
        print("Person deinitialized")
    }
    
    func creatingClosure() {
        closure = { [self]
            print(self)
        }
        
    }
}

var person: Person? = Person()
person?.creatingClosure()
person = nil

// MARK: Closure სადაც self-ის capture ხდება weak-ად შესაბამისად Memory leak აღარ ხდება და იძახება deinit.
class SuperHero {
    var closure: (() -> Void)?
    
    deinit {
        print("SuperHero deinitialized")
    }
    
    func creatingClosure() {
        closure = { [weak self] in
            if let self { print(self) }
        }
    }
}

var superHero: SuperHero? = SuperHero()
superHero?.creatingClosure()
superHero = nil

//MARK: ვქმნით protocol-ს რომელსაც ვუკონფირმებთ AnyObject-ს რაც ნიშნავს რომ მარტო კლასები შეძლებენ მის გამოყენებას, კლასებით და protocol-ით ვიწვევთ retain cycle-ს და memory leaks შესაბამისად deinit არ იძახება.
protocol TimeManager: AnyObject {}

class FirstClass {
    var manager: TimeManager?
    
    deinit {
        print("firstClass deinitialized")
    }
}

class SecondClass: TimeManager {
    var firstClass = FirstClass()
    
    
    init() {
        firstClass.manager = self
    }
    
    deinit {
        print("SecondClass deinitialized")
    }
}

var test: SecondClass? = SecondClass()
test = nil

//MARK: მეორე მაგალითში რადგანაც პროტოკოლი AnyObject არის შეგვიძლია ის weak-ად მოვნიშნოთ რაც გამოასწორებს ჩვენს memory leak-ის პრობლემას.
class Redbull {
    weak var manager: TimeManager?
    
    deinit {
        print("Redbull deinitialized")
    }
}

class Mercedes: TimeManager {
    var redBull = Redbull()
    
    init() {
        redBull.manager = self
    }
    
    deinit {
        print("Mercedes deinitialized")
    }
}

var test1: Mercedes? = Mercedes()
test1 = nil
