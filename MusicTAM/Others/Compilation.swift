enum Environment {
    case mock
}

struct Compilation {
    static var environment: Environment = .mock
}
