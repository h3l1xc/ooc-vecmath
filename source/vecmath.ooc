import	math

Matrix:	class {
	elements	: Float[][]
	columns		::= elements[0] length
	rows		::= elements length

	init:	func ~empty (rows: UInt, columns: UInt) {
		elements = Float[rows][columns] new()
	}

	init:	func ~fromArrayOfArrays (elements: Float[][]) {
		length		:= elements[0] length

		for (i in 0 .. elements length) {
			if (elements[i] length != length) {
				Exception new("All columns in a matrix must have the same length") \
				throw()
			}
		}

		this elements	= elements
	}

	add:	func ~individual (mat: Matrix) -> This {
		if (mat rows != this rows || mat columns != this columns) {
			Exception new("Matrix size mismatch: %ux%u vs %ux%u" \
			format(this rows, this columns, mat rows, mat columns)) throw()
		}

		for (i in 0 .. this rows) {
			for (j in 0 .. this columns) {
				this elements[i][j] = this elements[i][j] + mat elements[i][j]
			}
		}

		return this
	}

	add:	func ~recursive (mats: ...) -> This {
		mats each( |mat|
			match (mat) {
				case i: This => this add(i)
				case => Exception new("Matrix expected, found %s" \
						format(mat class name)) throw()
			}
		)
		
		return this
	}

	mul:	func ~byScalar (scalar: Float) -> This {
		for (i in 0 .. this rows) {
			for (j in 0 .. this columns) {
				this elements[i][j] = this elements[i][j] * scalar
			}
		}

		return this
	}

	mul:	func ~byMatrix (mat: Matrix) -> This {
		if (mat rows != this columns) {
			Exception new("Matrix size mismatch: %ux%u vs %ux%u" \
			format(this rows, this columns, mat rows, mat columns)) throw()
		}

		elements	:= Float[this rows][mat columns] new()

		for (i in 0 .. this rows) {
			for (j in 0 .. mat columns) {
				column	:= Float[mat rows] new()

				for (k in 0 .. mat rows) {
					column[k] = mat elements[k][j]
				}

				elements[i][j] = Vector new(this elements[i]) dot(Vector new(column))
			}
		}

		this elements	= elements

		return this
	}

	mul:	func ~recursive (args: ...) -> This {
		args each( |arg|
			match (arg) {
				case i: Double => this mul(i)
				case i: Float => this mul(i)
				case i: Int => this mul(i)
				case i: LDouble => this mul(i)
				case i: LLong => this mul(i)
				case i: Long => this mul(i)
				case i: Matrix => this mul(i)
				case => Exception new("Scalar or matrix expected, found %s" \
					format(arg class name)) throw()
			}
		)
		
		return this
	}

	sub:	func (mats: ...) -> This {
		mats each( |mat|
			match (mat) {
				case i: This => this add(i mul(-1))
				case => Exception new("Matrix expected, found %s" \
						format(mat class name)) throw()
			}
		)

		return this
	}

	_dbg:	func () {
		for (i in 0 .. this rows) {
			str := i == 0 ? "┌" : (i == this rows - 1 ? "└" : "│")

			for (j in 0 .. this columns) {
				str += "   " + this elements[i][j] toString()
			}

			str += "   " + (i == 0 ? "┐" : (i == this rows - 1 ? "┘" : "│"))
			str println()
		}
	}
}

Vector:	class {
	components	: Float[]
	dimensions	::= components length

	x	::= components[0]
	y	::= components[1]
	z	::= components[2]
	w	::= components[3]

	init:	func ~empty (dimensions: UInt) { components = Float[dimensions] new() }
	init:	func ~fromArray (=components)

	add:	func ~individual (vec: This) -> This {
		if (vec dimensions != this dimensions) {
			Exception new("Vector dimension mismatch: %u vs %u" \
			format(this dimensions, vec dimensions)) throw()
		}

		for (i in 0 .. this dimensions) {
			this components[i] = this components[i] + vec components[i]
		}

		return this
	}

	add:	func ~recursive (vecs: ...) -> This {
		vecs each( |vec|
			match (vec) {
				case i: This => this add(i)
				case => Exception new("Vector expected, found %s" \
						format(vec class name)) throw()
			}
		)
		
		return this
	}

	dot:	func (vec: Vector) -> Float {
		if (vec dimensions != this dimensions) {
			Exception new("Vector dimension mismatch: %u vs %u" \
			format(this dimensions, vec dimensions)) throw()
		}

		product	: Float

		for (i in 0 .. this dimensions) {
			product += this components[i] * vec components[i]
		}

		return product
	}

	mul:	func ~individual (scalar: Float) -> This {
		for (i in 0 .. this dimensions) {
			this components[i] = this components[i] * scalar
		}

		return this
	}

	mul:	func ~recursive (scalars: ...) -> This {
		scalars each( |scalar|
			match (scalar) {
				case i: Float => this mul(i)
				case => Exception new("Scalar expected, found %s" \
					format(scalar class name)) throw()
			}
		)
		
		return this
	}

	sub:	func (vecs: ...) -> This {
		vecs each( |vec|
			match (vec) {
				case i: This => this add(i mul(-1))
				case => Exception new("Vector expected, found %s" \
						format(vec class name)) throw()
			}
		)

		return this
	}

	_dbg:	func () {
		str := "["

		for (i in 0 .. this dimensions) {
			str += "   " + this components[i] toString()
		}

		str += "   ]"
		str println()
	}
}
