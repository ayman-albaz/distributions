import math
import math_utils
import utils


#[
    Special Functions
    
    Current supported functions:
        - beta function
        - log beta function
        - regularized incomplete beta function
        - lower_incomplete_gamma
        - regularized lower incomplete gamma function
]#





proc regularized_incomplete_beta*(a, b, x: float): float = 
    #[
        Incomplete beta function.
        Based off of Lewis Van Winkle's implementation: https://github.com/codeplea/incbeta
        :raises ValueError: if x 0.0 <= x <= 1.0
        :raises ValueError: if fails to converge
    ]#
    if x < 0.0:
        raise newException(ValueError, "x must be 0.0 <= x")

    const
        STOP =  1.0e-8
        TINY = 1.0e-30
        MAx_copyITER = 200

    # The continued fraction converges nicely for x < (a + 1) / (a + b + 2)
    if x > (a + 1.0) / (a + b + 2.0):
        return (1.0 - regularized_incomplete_beta(b, a, 1.0 - x))

    # Find the first part before the continued fraction
    let
        lbeta_ab: float = lgamma(a) + lgamma(b) - lgamma(a + b)
        front: float = exp(ln(x) * a + ln(1.0 - x) * b - lbeta_ab) / a

    # Use Lentz's algorithm to evaluate the continued fraction
    var
        f = 1.0
        c = 1.0
        d = 0.0
        m: float
        numerator: float
        cd: float

    for i in 0..MAx_copyITER:
        m = floor(i / 2)
        if i == 0:
            numerator = 1.0
        elif floorMod(i, 2) == 0:
            numerator = (m * (b - m) * x) / ((a + 2.0 * m - 1.0) * (a + 2.0 * m))
        else:
            numerator = -((a + m) * (a + b + m) * x) / ((a + 2.0 * m) * (a + 2.0 * m + 1))

        # Do an iteration of Lentz's algorithm
        d = 1.0 + numerator * d
        if abs(d) < TINY:
            d = TINY
        d = 1.0 / d
        c = 1.0 + numerator / c
        if abs(c) < TINY:
            c = TINY

        cd = c * d
        f *= cd
        # Check for stop
        if abs(1.0 - cd) < STOP:
            return front * (f - 1.0)

    raise newException(ValueError, "x must be 0.0 <= x <= 1.0")


#[
    Gamma functions
]#

proc lower_incomplete_gamma*(x: float, a: float): float = 
    #[
        Lower incomplete gamma function.
        Based off of Danilo Horta's implementation: https://github.com/PMBio/limix/
    ]#
    const
        MAx_copyITER = 400
        EPS = 2.2204e-16
    var
        total: float = 1.0 / a
        frac: float = total
        an: float = a
    for i in 0..MAx_copyITER:
        an += 1.0
        frac = x * frac / an
        total += frac

        # Stopping criteria
        if abs(frac) < abs(total * EPS):
            break

    return total * exp(-x - lgamma(a) + a * ln(x))


proc regularized_lower_incomplete_gamma*(x: float, a: float): float =
    return lower_incomplete_gamma(x, a) / gamma(a)


#[
    Other functions 
]#
proc inverse_erf*(x: FractionFloat): float =
    #[
        Inverse error function.
        Based off of: http://libit.sourceforge.net/math_8c-source.html
    ]#
    const
        inv_erf_a3 = -0.140543331
        inv_erf_a2 = 0.914624893
        inv_erf_a1 = -1.645349621
        inv_erf_a0 = 0.886226899

        inv_erf_b4 = 0.012229801
        inv_erf_b3 = -0.329097515
        inv_erf_b2 = 1.442710462
        inv_erf_b1 = -2.118377725
        inv_erf_b0 = 1

        inv_erf_c3 = 1.641345311
        inv_erf_c2 = 3.429567803
        inv_erf_c1 = -1.62490649
        inv_erf_c0 = -1.970840454

        inv_erf_d2 = 1.637067800
        inv_erf_d1 = 3.543889200
        inv_erf_d0 = 1
    var 
        x_sign: float
        x_copy: float
        x2: float
        r: float
        y: float

    if x == 0:
        return 0.0

    elif x > 0:
        x_sign = 1.0
        x_copy = x

    elif x < 0:
        x_sign = -1.0
        x_copy = -x

    if x_copy <= 0.7:
        x2 = x_copy * x_copy
        r = x_copy * (((inv_erf_a3 * x2 + inv_erf_a2) * x2 + inv_erf_a1) * x2 + inv_erf_a0)
        r /= (((inv_erf_b4 * x2 + inv_erf_b3) * x2 + inv_erf_b2) * x2 + inv_erf_b1) * x2 + inv_erf_b0

    elif x_copy > 0.7:
        y = sqrt(-ln((1 - x_copy) / 2))
        r = (((inv_erf_c3 * y + inv_erf_c2) * y + inv_erf_c1) * y + inv_erf_c0)
        r /= ((inv_erf_d2 * y + inv_erf_d1) * y + inv_erf_d0)

    r = r * x_sign
    x_copy = x_copy * x_sign

    r -= (erf(r) - x_copy) / (2 / sqrt(PI) * exp(-r * r))
    r -= (erf(r) - x_copy) / (2 / sqrt(PI) * exp(-r * r))

    return r


#
proc as26_2_22(p: float): float =
    #[ 
        Implement the formula 26.2.22 in [Abramowitz & Stegun], i.e
        return such `x` that approximately satisfies Q(x) ~= p.
    ]#
    # [Abramowitz & Stegun], section 26.2.22:
    const
        a0 = 2.30753
        a1 = 0.27061
        b0 = 0.99229
        b1 = 0.04481
    var
        pp: float
        t: float
        x: float

    if p >= 0.5:
        pp = 1.0 - p
    else:
        pp = p

    t = sqrt(-2.0 * ln(pp))
    x = t - (a0 + a1 * t) / (1.0 + t * (b0 + b1 * t))

    if p > 0.5:
        return -x
    else:
        return x


# proc inverse_lower_incomplete_gamma(a, g: float): float =
#     const
#         EPS = 2.2204e-16
#         TOL = 1e-12
#         MAX_ITER = 10000
#         c1 = 0.253
#         c2 = 0.12

#     # sanity check
#     if a < EPS or g < 0.0
#         raise newException(ValueError, "a must be < 2.2204e-16 and g must be less than 0")
#     end

#     let G = gamma(a)
#     var
#         p = g
#         x = 1.0
#         pa: float
#         cpa: float

#     p /= G

#     if abs(p) < EPS:
#         return 0.0

#     if p >= 1 - EPS:
#         raise newException(ValueError, "p must be p >= 1 - 2.2204e-16")

#     if a <= 1.0:
#         pa = a * (c1 + c2 * a)
#         cpa = 1.0 - pa

#         if p < cpa:
#             x = pow(p / cpa, 1.0 / a)
#         else:
#             x = 1.0 - ln((1.0 - p) / pa)

#     else:
#         x = -as26_2_22(p)

#         # [Abramowitz & Stegun], section 26.4.17:
#         x = 1.0 - (1.0 / (9.0 * a)) + (x / (3.0 * sqrt(a)))

#         # x = a * x^3:
#         x  = a * x * x * x

#     var
#         xn = 0.0
#         f = lower_incomplete_gamma(a, x) - p
#         i = 0

#     while abs(f) > TOL and i < MAX_ITER 
#         xn = x - f * G * exp(x) / pow(x, (a - 1.0))

#         # x must not go negative!
#         if xn > EPS:
#             x = xn
#         else:
#             x = x * 0.5

#         f = lower_incomplete_gamma(a, x) - p
#         i += 1

#     # Has the algorithm converged?
#     if i >= MAX_ITER:
#         raise newException(ValueError, "Algorithm has not converged")

#     return x



#[
    Beta functions
]#


proc lbeta*(a, b: float): float =
    return lgamma(a) + lgamma(b) - lgamma(a + b)


proc beta*(a, b: float): float =
    return exp(lbeta(a, b))


# proc incomplete_beta*(a, b, x: float, lower, reg: bool): float =
#     const
#         EPS = 2.2204e-16
#         EPS2 = 4.9301761600000003e-32
#         TOL2 = 1e-24
#         MAX_ITER = 10000

#     if pow2(a) < EPS2:
#         raise newException(ValueError, "a must not be pow2(a) < EPS2")

#     # if pow2(x) >= 1.0:
#     #     raise newException(ValueError, "x must not be pow2(x) >= 1.0")

#     let B = beta(a, b)

#     var
#         i = 1.0
#         binc = pow(x, a) / a
#         term = binc * a
#         at = a
#         bt = -b

#     while pow2(term) > TOL2 and i <= MAX_ITER:
#         at += 1.0
#         bt += 1.0

#         # if 'a' is a negative integer, sooner or later this exception will be thrown
#         if pow2(at) < EPS2:
#             raise newException(ValueError, "at must not be pow2(at) < EPS2")

#         term *= x * bt / i
#         binc += term / at
#         i += 1

#     # Has the algorithm converged?
#     if i >= MAX_ITER:
#         raise newException(ValueError, "Algorithm has not converged")

#     if lower == false:
#         binc = B - binc

#     if reg == true:
#         # Very unlikely but check it anyway
#         if pow2(B) < EPS2:
#             raise newException(ValueError, "B must not be pow2(B) < EPS2")
#         binc /= B

#     return binc


proc incomplete_beta_ctdfrac_closure(a, b, x: float): ((proc(i: int): float {.closure, noSideEffect, gcsafe, locks: 0.}), (proc(i: int): float {.noSideEffect, gcsafe, locks: 0.})) =
    let fa =  proc(i: int): float = 
        let m: float = (i div 2).float
        if floorMod(i, 2) == 1:
            return -((a + m) * (a + b + m) * x) / (( a + i.float - 1) * (a + i.float))
        else:
            return (m * (b - m) * x) / ((a + i.float - 1) * (a + i.float))

    let fb = proc(i: int): float {.closure.} = 
        return 1.0

    return (fa, fb)


proc ctdfrac_eval(fa: (proc(i: int): float {.closure, noSideEffect, gcsafe, locks: 0.}), fb: (proc(i: int): float {.closure, noSideEffect, gcsafe, locks: 0.})): float = 

    const
        EPS = 2.2204e-16
        TOL = 1e-12
        MAX_ITER = 10000

    var
        f: float = fb(0)
        c: float = f
        d: float = 0.0
        Delta: float = 0.0
        j: int = 1
        a: float
        b: float


    while abs(Delta - 1) > TOL and j < MAX_ITER:
        # obtain 'aj' and 'bj'
        a = fa(j)
        b = fb(j)

        # dj = bj + aj * d_j-1
        d = b + a * d

        if abs(d) < EPS:
            d = EPS

        # cj = bj + aj/c_j-1
        c = b + a / c

        if abs(c) < EPS:
            c = EPS

        # dj = 1 / dj
        d = 1.0 / d

        # Delta_j = cj * dj
        Delta = c * d

        # fj = f_j-1 * Delta_j
        f *= Delta

        j += 1

    # check if the algorithm has converged:
    if j >= MAX_ITER:
        raise newException(ValueError, "Algorithm has not converged")

    return f




proc incomplete_beta*(a, b, x: float, lower, reg: bool): float =
    const
        EPS = 2.2204e-16
        TOL2 = 1e-12
        MAX_ITER = 10000

    if a < EPS or b < EPS or x < 0.0 or x > 1:
        raise newException(ValueError, "Must not be: a < EPS or b < EPS or x < 0.0 or x > 1")

    var
        xlarge: bool = x > ((a + 1) / (a + b + 2))
        binc: float = 0.0
        xn: float
        an: float
        bn: float
        B: float

    if xlarge:
        xn = 1.0 - x
        an = b
        bn = a
    else:
        xn = x
        an = a
        bn = b

    if reg == true or (xlarge == false and lower == false) or (xlarge == true and lower == true):
        B = beta(a, b)
    else:
        B = 0.0

    if abs(xn) < EPS:
        if xlarge == true:
            binc = B
        else:
            binc = 0.0

    else:
        binc = pow(xn, an) * pow(1.0 - xn, bn) / an
        binc /= ctdfrac_eval(incomplete_beta_ctdfrac_closure(an, bn, xn)[0], incomplete_beta_ctdfrac_closure(an, bn, xn)[1])



    if (xlarge == false and lower == false) or (xlarge == true and lower == true):
        binc = B - binc

    # Finally regularize the result if requested (via 'reg')
    if reg == true:
        # Just in case handle the very unlikely case
        if abs(B) < EPS:
             raise newException(ValueError, "Must not be: abs(B) < EPS")

        binc /= B

    return binc









proc lower_incomplete_beta*(a, b, x: float): float =
    return incomplete_beta(a, b, x, true, false)


proc upper_incomplete_beta*(a, b, x: float): float =
    return incomplete_beta(a, b, x, false, false)


proc regularized_lower_incomplete_beta*(a, b, x: float): float =
    return incomplete_beta(a, b, x, true, true)


proc regularized_upper_incomplete_beta*(a, b, x: float): float =
    return incomplete_beta(a, b, x, false, true)


proc inverse_incomplete_beta*(a, b, y: float, lower, reg: bool): float =
    const
        EPS = 2.2204e-16
        TOL = 1e-12
        MAX_ITER = 10000
        c1 = 0.253
        c2 = 0.12

    # sanity check
    if a < EPS or b < EPS or y < 0:
        raise newException(ValueError, "a < EPS or b < EPS or y < 0")

    let B = beta(a, b)
    var
        i = 0
        p = y
        x = 0.0
        xn = 0.0
        pa: float
        cpa: float
        lambda: float
        ta: float
        tb: float
        h: float
        w: float
        S: float
        f: float


    if reg == false:
        p /= B

    if lower == false:
        p = 1 - p

    if abs(p) < EPS:
        return 0.0

    if p >= (1.0 - EPS):
        raise newException(ValueError, "p >= (1.0 - EPS)")

    if a >= 1.0 and b >= 1.0:
        x = as26_2_22(p)
        lambda = (x * x - 3.0) / 6.0
        ta = 1 / (2 * a - 1)
        tb = 1 / (2 * b - 1)
        h = 2 / (ta + tb)
        w = x * sqrt(h + lambda) / h - (tb - ta) * (lambda + 5.0 / 6.0 - 2.0 / (3.0 * h))
        x = a / (a + b * exp(2.0 * w))
    else:
        ta = pow(a / (a + b), a) / a
        tb = pow(b / (a + b), b) / b
        S = ta + tb
        if p < ta / S:
            x = pow(p * S * a, 1.0 / a)
        else:
            x = pow(1.0 - p * S * b, 1.0 / b)

    f = regularized_lower_incomplete_beta(a, b, x) - p
    while abs(f) > TOL and i < MAX_ITER:
        xn = x - f * B / (pow(x, (a - 1)) * pow((1 - x), (b - 1)))
        if xn < EPS:
            x *= 0.5
        elif xn > 1.0 - EPS:
            x = (1.0 + x) * 0.5
        else:
            x = xn
        f = regularized_lower_incomplete_beta(a, b, x) - p
        i += 1

    # Has the algorithm converged?
    if i >= MAX_ITER:
        raise newException(ValueError, "Algorithm has not converged")

    return x

proc inverse_lower_incomplete_beta*(a, b, x: float): float =
    return inverse_incomplete_beta(a, b, x, true, false)


proc inverse_upper_incomplete_beta*(a, b, x: float): float =
    return inverse_incomplete_beta(a, b, x, false, false)


proc inverse_regularized_lower_incomplete_beta*(a, b, x: float): float =
    return inverse_incomplete_beta(a, b, x, true, true)


proc inverse_regularized_upper_incomplete_beta*(a, b, x: float): float =
    return inverse_incomplete_beta(a, b, x, false, true)
