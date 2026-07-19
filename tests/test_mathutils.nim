import std/math
import std/unittest

import distributions

suite "mathutils":
  test "pow2":
    check pow2(3.0) == 9.0
    check pow2(-4.0) == 16.0
    check pow2(0.0) == 0.0
    check pow2(1.0'f32) == 1.0'f32

  test "pow3":
    check pow3(2.0) == 8.0
    check pow3(-3.0) == -27.0
    check pow3(0.0) == 0.0
    check pow3(2.0'f32) == 8.0'f32

  test "lfac matches lgamma":
    for k in 0 .. 20:
      check abs(lfac(k) - lgamma(float(k) + 1.0)) < 1e-9

    check abs(lfac(100) - lgamma(101.0)) < 1e-9
    check abs(lfac(1000) - lgamma(1001.0)) < 1e-9
