/*
Linear algebra protocol and extensions for the Matrix struct.
*/

import Accelerate

public protocol Algebra {
    static func norm(_ a: Matrix<Self>) -> Self
    static func scale(_ a: inout Matrix<Self>, by k: Self)
    static func transpose(_ a: Matrix<Self>) -> Matrix<Self>
    static func swapValues(a: inout Matrix<Self>, b: inout Matrix<Self>)
}

extension Int: Algebra {

    public static func swapValues(a: inout Matrix<Int>, b: inout Matrix<Int>) {
        precondition(a.rows == b.rows && a.columns == b.columns, "Matrices must have same shape")
        swap(&a, &b)
    }

    public static func norm(_ a: Matrix<Int>) -> Int {
        var sumOfSquares = 0
        for i in 0..<a.rows {
            for j in 0..<a.columns {
                sumOfSquares &+= a[i, j] * a[i, j]
            }
        }
        let result = sqrt(Float(sumOfSquares))
        return Int(result)
    }

    public static func scale(_ a: inout Matrix<Int>, by k: Int) {
        a = a .* k
    }

    public static func transpose(_ a: Matrix<Int>) -> Matrix<Int> {
        var transposed = Matrix<Int>(rows: a.columns, columns: a.rows)
        for i in 0..<a.rows {
            for j in 0..<a.columns {
                transposed[j, i] = a[i, j]
            }
        }
        return transposed
    }
}

extension Float: Algebra {

    public static func swapValues(a: inout Matrix<Float>, b: inout Matrix<Float>) {
        precondition(a.rows == b.rows && a.columns == b.columns, "Matrices must have same shape")
        cblas_sswap(a.buffer.count, a.buffer.baseAddress, 1, b.buffer.baseAddress, 1)
    }

    public static func norm(_ a: Matrix<Float>) -> Float {
        cblas_snrm2(a.buffer.count, a.buffer.baseAddress, 1)
    }

    public static func scale(_ a: inout Matrix<Float>, by k: Float) {
        cblas_sscal(a.rows * a.columns, k, a.buffer.baseAddress, 1)
    }

    public static func transpose(_ a: Matrix<Float>) -> Matrix<Float> {
        let m = vDSP_Length(a.columns)
        let n = vDSP_Length(a.rows)
        let mat = Matrix<Float>(rows: a.columns, columns: a.rows)
        vDSP_mtrans(a.buffer.baseAddress!, 1, mat.buffer.baseAddress!, 1, m, n)
        return mat
    }
}

extension Double: Algebra {

    public static func swapValues(a: inout Matrix<Double>, b: inout Matrix<Double>) {
        precondition(a.rows == b.rows && a.columns == b.columns, "Matrices must have same shape")
        cblas_dswap(a.buffer.count, a.buffer.baseAddress, 1, b.buffer.baseAddress, 1)
    }

    public static func norm(_ a: Matrix<Double>) -> Double {
        cblas_dnrm2(a.buffer.count, a.buffer.baseAddress, 1)
    }

    public static func scale(_ a: inout Matrix<Double>, by k: Double) {
        cblas_dscal(a.rows * a.columns, k, a.buffer.baseAddress, 1)
    }

    public static func transpose(_ a: Matrix<Double>) -> Matrix<Double> {
        let m = vDSP_Length(a.columns)
        let n = vDSP_Length(a.rows)
        let mat = Matrix<Double>(rows: a.columns, columns: a.rows)
        vDSP_mtransD(a.buffer.baseAddress!, 1, mat.buffer.baseAddress!, 1, m, n)
        return mat
    }
}

extension Matrix where Scalar: Algebra {

    /// The Euclidean norm of the matrix. Also known as the 2-norm or maximum singular value.
    /// - Returns: The matrix norm.
    public func norm() -> Scalar {
        Scalar.norm(self)
    }

    /// Multiply each value in the matrix by a constant.
    ///
    /// For integer matrices, this performs element-wise multiplication. For
    /// single and double precision matrices this uses BLAS routines `sscal`
    /// and `dscal` respectively.
    ///
    /// - Parameter k: The scaling factor.
    public mutating func scale(by k: Scalar) {
        Scalar.scale(&self, by: k)
    }

    /// Transpose the matrix and return the result.
    /// - Returns: The transposed matrix.
    public func transpose() -> Matrix {
        Scalar.transpose(self)
    }
}

/// Swap the values of two matrices.
///
/// In this example the scalar values in `mat1` are exchanged for the values in `mat2` and vice versa.
/// ```swift
/// var mat1 = Matrix<Float>([[2, 3, 4], [5, 6, 7]])
/// var mat2 = Matrix<Float>([[9, 8, 7], [10, 12, 13]])
/// swapValues(&mat1, &mat2)
/// ```
/// - Parameters:
///   - a: The first matrix.
///   - b: The second matrix.
public func swapValues<Scalar: Algebra>(_ a: inout Matrix<Scalar>, _ b: inout Matrix<Scalar>) {
    Scalar.swapValues(a: &a, b: &b)
}
