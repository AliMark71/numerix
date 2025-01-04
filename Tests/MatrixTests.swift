/*
 Tests for the Matrix structure.
 */

import Testing
@testable import Numerix

struct MatrixTests {

    @Test func arrayLiteral() {
        let a: Matrix = [[1, 2, 3, 4],
                         [5, 6, 7, 8]]
        #expect(a == [[1, 2, 3, 4], [5, 6, 7, 8]])

        let b: Matrix = [[1, 2, 3, 4.7],
                         [5, 16.1, 7, 8],
                         [10, 11, 12, 13]]
        #expect(b == [[1, 2, 3, 4.7], [5, 16.1, 7, 8], [10, 11, 12, 13]])
    }

    @Test func printing() {
        let a = Matrix([[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12.5]])
        var outputA = ""
        print(a, terminator: "", to: &outputA)
        #expect(outputA == """
        ⎛ 1.0   2.0   3.0   4.0 ⎞
        ⎜ 5.0   6.0   7.0   8.0 ⎟
        ⎝ 9.0  10.0  11.0  12.5 ⎠
        """)

        let b = Matrix([[2.5, 1, 8.235], [0.45, 23.5, 3]])
        var outputB = ""
        print(b, terminator: "", to: &outputB)
        #expect(outputB == """
        ⎛ 2.5    1.0  8.235 ⎞
        ⎝ 0.45  23.5  3.0   ⎠
        """)
    }

    @Test func debugPrinting() {
        let a = Matrix([[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12.5]])
        var outputA = ""
        debugPrint(a, terminator: "", to: &outputA)
        #expect(outputA == """
        3x4 Matrix<Double>
        ⎛ 1.0   2.0   3.0   4.0 ⎞
        ⎜ 5.0   6.0   7.0   8.0 ⎟
        ⎝ 9.0  10.0  11.0  12.5 ⎠
        """)

        let b = Matrix([[2.5, 1, 8.235], [0.45, 23.5, 3]])
        var outputB = ""
        debugPrint(b, terminator: "", to: &outputB)
        #expect(outputB == """
        2x3 Matrix<Double>
        ⎛ 2.5    1.0  8.235 ⎞
        ⎝ 0.45  23.5  3.0   ⎠
        """)
    }

    @Test func approximatelyEqual() {
        let a = Matrix<Float>([[1, 2, 3, 4], [5, 6, 7, 8.123]])
        let b = Matrix<Float>([[1, 2, 3, 4], [5, 6, 7, 8.1234567891011]])
        #expect(!a.isApproximatelyEqual(to: b))
        #expect(a.isApproximatelyEqual(to: b, absoluteTolerance: 0.001))

        let c = Matrix([[1, 2, 3, 4], [5, 6, 7, 8.123]])
        let d = Matrix([[1, 2, 3, 4], [5, 6, 7, 8.1234567891011]])
        #expect(!c.isApproximatelyEqual(to: d))
        #expect(c.isApproximatelyEqual(to: d, absoluteTolerance: 0.001))
    }

    @Test func integerArithmetic() {
        let k = 5
        let a = Matrix([[1, 2, 3], [4, 5, 6]])
        let b = Matrix([[7, 8, 9], [3, 4, 5]])
        let c = Matrix([[1, 2], [3, 4], [5, 6]])

        // Equality
        #expect(a == a)
        #expect(a != b)

        // Addition
        #expect(k + a == Matrix([[6, 7, 8], [9, 10, 11]]))
        #expect(a + k == Matrix([[6, 7, 8], [9, 10, 11]]))
        #expect(a + b == Matrix([[8, 10, 12], [7, 9, 11]]))

        var d = Matrix([[1, 2, 3], [4, 5, 6]])
        d += b
        #expect(d == Matrix([[8, 10, 12], [7, 9, 11]]))

        // Subtraction
        #expect(k - a == Matrix([[4, 3, 2], [1, 0, -1]]))
        #expect(a - k == Matrix([[-4, -3, -2], [-1, 0, 1]]))
        #expect(a - b == Matrix([[-6, -6, -6], [1, 1, 1]]))

        // Element-wise multiplication
        #expect(k .* a == Matrix([[5, 10, 15], [20, 25, 30]]))
        #expect(a .* k == Matrix([[5, 10, 15], [20, 25, 30]]))
        #expect(a .* b == Matrix([[7, 16, 27], [12, 20, 30]]))

        // Matrix multiplication
        #expect(a * c == Matrix([[22, 28], [49, 64]]))

        // Methods
        // #expect(a.dot(b) == 100)
        // #expect(a.sum() == 15)
        // #expect(a.absoluteSum() == 15)
    }

    @Test func floatArithmetic() {
        let k: Float = 5
        let a = Matrix<Float>([[1, 2, 3], [4, 5, 6]])
        let b = Matrix<Float>([[7, 8, 9], [3, 4, 5]])
        let c = Matrix<Float>([[1, 2], [3, 4], [5, 6]])

        // Equality
        #expect(a == a)
        #expect(a != b)

        // Addition
        #expect(k + a == Matrix([[6, 7, 8], [9, 10, 11]]))
        #expect(a + k == Matrix([[6, 7, 8], [9, 10, 11]]))
        #expect(a + b == Matrix([[8, 10, 12], [7, 9, 11]]))

        var d = Matrix<Float>([[1, 2, 3], [4, 5, 6]])
        d += b
        #expect(d == Matrix([[8, 10, 12], [7, 9, 11]]))

        // Subtraction
        #expect(k - a == Matrix([[4, 3, 2], [1, 0, -1]]))
        #expect(a - k == Matrix([[-4, -3, -2], [-1, 0, 1]]))
        #expect(a - b == Matrix([[-6, -6, -6], [1, 1, 1]]))

        // Element-wise multiplication
        #expect(k .* a == Matrix([[5, 10, 15], [20, 25, 30]]))
        #expect(a .* k == Matrix([[5, 10, 15], [20, 25, 30]]))
        #expect(a .* b == Matrix([[7, 16, 27], [12, 20, 30]]))

        // Matrix multiplication
        #expect(a * c == Matrix([[22, 28], [49, 64]]))

        // Methods
        // #expect(a.dot(b) == 100)
        // #expect(a.sum() == 15)
        // #expect(a.absoluteSum() == 15)
    }

    @Test func doubleArithmetic() {
        let k = 5.0
        let a = Matrix([[1, 2, 3], [4, 5, 6.0]])
        let b = Matrix([[7, 8, 9], [3, 4, 5.0]])
        let c = Matrix([[1, 2], [3, 4], [5, 6.0]])

        // Equality
        #expect(a == a)
        #expect(a != b)

        // Addition
        #expect(k + a == Matrix([[6, 7, 8], [9, 10, 11]]))
        #expect(a + k == Matrix([[6, 7, 8], [9, 10, 11]]))
        #expect(a + b == Matrix([[8, 10, 12], [7, 9, 11]]))

        var d = Matrix([[1, 2, 3], [4, 5, 6.0]])
        d += b
        #expect(d == Matrix([[8, 10, 12], [7, 9, 11]]))

        // Subtraction
        #expect(k - a == Matrix([[4, 3, 2], [1, 0, -1]]))
        #expect(a - k == Matrix([[-4, -3, -2], [-1, 0, 1]]))
        #expect(a - b == Matrix([[-6, -6, -6], [1, 1, 1]]))

        // Element-wise multiplication
        #expect(k .* a == Matrix([[5, 10, 15], [20, 25, 30]]))
        #expect(a .* k == Matrix([[5, 10, 15], [20, 25, 30]]))
        #expect(a .* b == Matrix([[7, 16, 27], [12, 20, 30]]))

        // Matrix multiplication
        #expect(a * c == Matrix([[22, 28], [49, 64]]))

        // Methods
        // #expect(a.dot(b) == 100)
        // #expect(a.sum() == 15)
        // #expect(a.absoluteSum() == 15)
    }

    @Test func integerAlgebra() {
        let a = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
        let b = Matrix([[2, 3, 4, 5], [6, 7, 8, 9]])

        #expect(a.norm() == 16)
        #expect(a.transpose() == Matrix([[1, 4, 7], [2, 5, 8], [3, 6, 9]]))
        #expect(b.transpose() == Matrix([[2, 6], [3, 7], [4, 8], [5, 9]]))

        var c = Matrix([[1, 2, 3], [4, 5, 6]])
        c.scale(by: 3)
        #expect(c == [[3, 6, 9], [12, 15, 18]])
    }

    @Test func floatAlgebra() {
        let a = Matrix<Float>([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
        let b = Matrix<Float>([[2, 3, 4, 5], [6, 7, 8, 9]])

        #expect(a.norm() == 16.881943)
        #expect(a.transpose() == Matrix<Float>([[1, 4, 7], [2, 5, 8], [3, 6, 9]]))
        #expect(b.transpose() == Matrix<Float>([[2, 6], [3, 7], [4, 8], [5, 9]]))

        var c = Matrix<Float>([[1, 2, 3], [4, 5, 6]])
        c.scale(by: 3.0)
        #expect(c == [[3, 6, 9], [12, 15, 18.0]])
    }

    @Test func doubleAlgebra() {
        let a = Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9.0]])
        let b = Matrix([[2, 3, 4, 5], [6, 7, 8, 9.0]])

        #expect(a.norm() == 16.881943016134134)
        #expect(a.transpose() == Matrix([[1, 4, 7], [2, 5, 8], [3, 6, 9.0]]))
        #expect(b.transpose() == Matrix([[2, 6], [3, 7], [4, 8], [5, 9.0]]))

        var c = Matrix([[1, 2, 3], [4, 5, 6.0]])
        c.scale(by: 3.0)
        #expect(c == [[3, 6, 9], [12, 15, 18.0]])
    }
}
