import math


proc pow2*[T](x: T): T {.inline.} = x * x


proc binomial_coefficient*(n, k: int): int {.inline.} =
    #[ 
        Based off of https://www.geeksforgeeks.org/space-and-time-efficient-binomial-coefficient/
    ]#
    var 
        res: int = 1
        new_k: int = k

    if k > n - k:
        new_k = n - k
    
    for i in 0..<new_k:
        res = res * (n - i)
        res = res div (i + 1)
    return res


proc lfac*(k: Natural): float {.inline.} = 
    #[
        Factorial using Ln to avoid overflow
    ]#
    var total = 0.0
    for i in 1..k:
        total += ln(i.float)
    return total
