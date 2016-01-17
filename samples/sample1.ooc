use		vecmath
import	vecmath

main:	func (args: String[]) -> Int {
	g	:= Matrix new([
			[4.0f, 5.0f, 6.0f, 7.0f],
			[2.0f, 8.0f, 3.0f, 1.0f],
			[4.0f, 1.0f, 9.0f, 3.0f]
	])

	g _dbg()

	println()

	h	:= Vector new([1.0f, 5.0f, 3.0f])
	h _dbg()

	return 0
}
