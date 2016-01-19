use     vecmath
import  vecmath

main: \
func (args: String[]) -> Int {
    mat := Matrix new([
            [4.0f, 5.0f, 6.0f, 7.0f],
            [2.0f, 8.0f, 3.0f, 1.0f],
            [4.0f, 1.0f, 9.0f, 3.0f]
    ])

    mat _dbg()

    println()

    vec := Vector new([1.0f, 5.0f, 3.0f])
    vec _dbg()

    return 0
}
