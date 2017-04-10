import Foundation

public class ActivationFunction {
    
    static func sigmoid(x: Float) -> Float {
        return 1 / (1 + exp(-x))
    }
    
    static func sigmoidDerivative(x: Float) -> Float {
        return x * (1 - x)
    }
    
}
