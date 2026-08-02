# Package

version = "2.0.0"
author = "ayman albaz"
description = "Probability distributions and functions in Nim"
license = "Apache-2.0"
srcDir = "src"
# Dependencies

requires "nim >= 2.0.0"
requires "special_functions >= 1.0.0"
requires "results >= 0.5.1"

task format, "Formats the whole codebase":
  exec "nph ."
