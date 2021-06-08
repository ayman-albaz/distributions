type
    Submodule* = object
      name*: string

proc initSubmodule*(): Submodule =
    ## Initialises a new ``Submodule`` object.
    Submodule(name: "Anonymous")



type
    PositiveFloat* = range[0.0..Inf]
    FractionFloat* = range[-1.0..1.0]
    FractionPositiveFloat* = range[0.0..1.0]
    BinaryInteger* = range[0..1]