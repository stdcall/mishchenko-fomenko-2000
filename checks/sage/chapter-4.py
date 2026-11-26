r"""Exact checks of Chapter 4 "Smooth manifolds (examples)" (Sage).

Run: sage -python checks/sage/chapter-4.py (plain asserts; do not use -O).
The last line of the output is "ok chapter-4: N checks".

Book: A. S. Mishchenko, A. T. Fomenko, Kurs differentsial'noi geometrii i
topologii, 2nd ed., Faktorial Press, Moscow, 2000, Chapter 4 (pp. 155-299).
Pages are the printed pages.  The expected values are the book's: formulas,
tables and numbers written below as literals read off the printed page; our
Typst source is not parsed.  Where the book is wrong, the printed reading is
kept as a refuted check (function `refuted`: the printed reading must fail)
next to the corrected one.  Symbolic checks use the symbolic ring with
assumptions (radicals are canonicalized only where every variable is
positive) or polynomial and rational function rings over QQ and QQ(i); no
floating point is used for equalities or signs.

What is checked, by section:

Section 1, curves (content/04-01-curves.typ, pp. 155-169)
  * the circle of radius R (pp. 157-158): unit velocity, dv/ds, k = 1/R, the
    parameter runs to 2 pi R (the printed "to 2 pi" refuted for R = 2); the
    straight line has k = 0; the normal n(s) of p. 157 with the squares
    (without them it is not a unit vector: refuted);
  * Theorem 1 (p. 158): k = |x''y' - y''x'| / ((x')^2 + (y')^2)^(3/2) for
    arbitrary functions x(t), y(t), with the intermediate components and the
    printed expression for k^2 (p. 159);
  * Theorem 2 and its geometric meaning (pp. 159-161): for a frame turned by
    the angle phi(s), dv/ds = phi' n, dn/ds = -phi' v (so k = d phi/ds), and
    A(d phi) = E + (0, d phi; -d phi, 0) + O(d phi^2);
  * Lemma 3 (p. 163): the derivative at 0 of a family of rotations (Cayley
    family of a generic skew matrix of order 3) is skew-symmetric;
  * Theorem 4 (pp. 165-166): the Frenet matrix (<d tau_i/ds, tau_j>) of an
    explicit curve in R^4 with natural parameter is skew-symmetric and
    tridiagonal; its superdiagonal entries a_12, a_23, a_34 are pairwise
    distinct, so the printed choice k_i = a_(i,i+1) is refuted and
    k_(i+1) = a_(i,i+1) confirmed; the helix in R^3 has k = a/(a^2 + b^2),
    torsion b/(a^2 + b^2) and tau_3 = [v, n] (an illustration of p. 166, not
    a printed value);
  * Proposition 2 (p. 168) refuted as stated: the nodal cubic
    t -> (t^2 - 1, t^3 - t) has nowhere vanishing velocity but passes twice
    through the origin with independent velocities, and the figure-eight
    t -> (cos t, sin 2t), -pi/2 < t < 3 pi/2, is a one-to-one immersion whose
    ends accumulate at its own point f(pi/2) = (0, 0) (L. W. Tu, An
    Introduction to Manifolds, 2nd ed., Springer 2011, Examples 11.8 and
    11.12, pp. 120, 122).

Section 2, surfaces (content/04-02-surfaces.typ, pp. 169-207)
  * the first form of a graph in R^4 (p. 170: g_kp = delta_kp + f_k f_p) and
    of a level set (p. 171), of a surface of revolution (p. 172:
    E = r^2, F = 0, G = 1 + r'^2);
  * Lemma 2 (p. 175): det(G^-1 Q - lambda E) is invariant under
    G -> J G J^T, Q -> J Q J^T (2 x 2 generic; 3 x 3 with generic G, Q and
    a fixed rational J);
  * the matrix G^-1 Q and the formulas for H and K (p. 186); the graph
    z = f(x, y) (p. 187): L, M, N, H with exponent 3/2 and K with exponent 2
    for an arbitrary function f; the printed exponent 3/2 of K (pp. 187, 188)
    refuted; at a critical point H = f_xx + f_yy, K = f_xx f_yy - f_xy^2
    (p. 178);
  * p. 181: dx^1 vanishes on the tangent line of S^1 at the equator point
    (1, 0), so the printed chart "x^(n-1) >= 0" is refuted, "> 0" confirmed;
    p. 183: for B = diag(1, 0) the critical point (0, 1) has B x_0 = 0 (the
    printed "lambda(x_0) != 0" refuted); the quadric with lambda = (1, 0) is
    not an ellipse (the printed "nonnegative" refuted, "positive" gives the
    semi-axes 1/sqrt(lambda_i));
  * the sphere (p. 187: K = 1/R^2, |H| = 2/R); the ellipsoid task (p. 188):
    the corrected parametrization lies on the ellipsoid (z = sin theta
    refuted) and K = 1/(a^2 b^2 c^2 (x^2/a^4 + y^2/b^4 + z^2/c^4)^2) > 0;
  * z = x^2 - y^2: K = -4/(1 + 4(x^2 + y^2))^2 (p. 188), the numerator of H
    is 8(y^2 - x^2), so H = 0 exactly on y = +-x (p. 206; the printed "only
    at (0, 0)" refuted at (1, 1)); the monkey saddle (p. 186);
  * the triangle A B x of Fig. 22 (p. 188): tg phi = -y' and the equation
    |AB| = a of p. 189;
  * the tractrix (pp. 188-189): sin phi = -y'/sqrt(1 + y'^2) (the printed
    sign refuted), x'_y = -sqrt(a^2 - y^2)/y, the corrected chain of
    integrals and its closed form (derivative and value at y = a); the
    printed first member has the opposite derivative (refuted);
  * Lemma 5 (p. 190): r_(x phi), the normal and M = 0, F = 0; Lemma 6
    (p. 190) with lambda_1, lambda_2 (pp. 191-192) and cos theta;
  * Lemma 7 (p. 192): x'' and the corrected chain |K| = ... = 1/a^2 (the
    printed final -1/a^2 refuted), K = -1/a^2;
  * the Beltrami metric (p. 194): 1 + (x'_r)^2 = a^2/r^2, so the printed
    ds^2 = dr^2/r^2 + r^2 d phi^2 holds for a = 1 only (refuted for a = 2);
    Assertion 1 (u = phi, v = 1/r gives (du^2 + dv^2)/v^2) and its analogue
    v = a/r for any a; Re and Im of 1/z (p. 196);
  * the catenoid (p. 201): H = 0 with y'' = (1/a) cosh(x/a) (the printed 1/2
    refuted), K = -1/(a^2 cosh^4(x/a)); the helicoid exercise (p. 200);
  * Assertion 2 (p. 207) on the catenoid in conformal coordinates: E = G,
    F = 0, H = 0, r_uu + r_vv = 0, and the four differentiated identities.

Section 3, transformation groups (content/04-03-transformation-groups.typ,
pp. 207-236)
  * Example 2 (p. 209): the matrices of O(2), their determinants, the
    product of two reflections is a rotation; O(2) is not commutative;
    Example 3 (p. 210): the block matrices multiply as the motions compose;
  * Example 4 (pp. 210-214): the system a^2 - b^2 = 1, ac = bd,
    d^2 - c^2 = 1 from B = A B A^T; the corrected matrix with numerators beta
    (the printed numerators 1 refuted: det 0); the four sign patterns satisfy
    B = A B A^T, (+, -; -, +) is G_1 with psi -> -psi, g_i lies in G_i; the
    multiplication table of p. 214 (16 cells), so G/G_1 = Z_2 + Z_2;
    G_1 is commutative and normal, G_2 G_2 lies in G_1; the printed "G is
    commutative" refuted (g_3 and a hyperbolic rotation), the corrected
    argument (the representatives g_i commute and G_i = g_i G_1) confirmed;
  * Example 6 and Lemmas 4, 5 (pp. 216-218): dw for a fractional linear map,
    Im w = (ad - bc) Im z / |cz + d|^2, the expansion of w, the invariance of
    dz dz^/(z - z^)^2; the printed metric dz dz^/(z - z^)^2 is negative
    definite (refuted as a Riemannian metric), -4 dz dz^/(z - z^)^2 =
    (dx^2 + dy^2)/y^2; the Jacobian u^2 + v^2 (p. 217);
  * Proposition 1 (p. 218): composition of maps = product of matrices, and
    phi(g) = phi(g') with det g = det g' = 1 forces g' = +-g (primary
    decomposition); Lemma 7 (p. 220): phi on L(2, R) is a homomorphism
    including the maps of z^, the kernel and the centre are {E, -E};
    Lemma 8 (p. 221): g = rotation x triangular;
  * the dimension of SL(n) (p. 224) from the gradient of det, n <= 4;
    Lemma 10 (p. 225): the corrected path gamma(t) lies in SO(4), SO(5),
    joins E with the canonical form (the printed path without t refuted);
    tr A B^T = sum a_ij b_ij (p. 225);
  * Lemma 11 (pp. 226-227): the corrected paths in SU(3) and U(3) (printed
    entries refuted); Lemma 12 (p. 228): det maps GL(n, C) onto C \ 0, not
    into S^1 (printed reading refuted); the printed "O(n) connected" (p. 227)
    refuted (det is +-1 on O(n), both values occur);
  * the complex structure (p. 230): A = (0, -E; E, 0) is orthogonal, A^2 = -E,
    charpoly (x^2 + 1)^n, n <= 4; an orthogonal skew matrix has det
    Pf^2 = 1 (generic 4 x 4 Pfaffian identity); phi_k = pi/2 + l pi (the
    printed 2 pi/2 + l pi refuted); Proposition 3 (p. 231): the realification
    C + iB -> (C, -B; B, C) is multiplicative, takes A^* to the transpose and
    has det |det A|^2 (n = 1, 2, 3);
  * quaternions (pp. 232-235): the multiplication table (16 cells) against
    Sage's QuaternionAlgebra(-1, -1), non-commutativity, |q|^2 = q q^,
    |ab| = |a||b|, conj(ab) = b^ a^, q = z1 + j z2^, j z = z^ j; the
    complexified product of p. 233; Proposition 5:
    q1 a^ a q2^ = |a|^2 q1 q2^, the corrected product
    (alpha + j beta)(p + j q^) = (alpha p - beta^ q^) + (alpha q + beta^ p^) j
    (printed beta without bars refuted for beta = i), the matrix
    (p, -q^; q, p^) in the coordinates (alpha, beta^), its determinant; every
    matrix of SU(2) has this form; the map a -> (q -> a q a^) gives
    R(a)^T R(a) = |a|^4 E, det R(a) = |a|^6, R(ab) = R(a) R(b), and
    R(a) = E with |a| = 1 forces a = +-1.

Section 4, dynamical systems (content/04-04-dynamical-systems.typ,
pp. 236-253)
  * p. 241: iq, jq, kq are tangent to S^3 and, with q, orthonormal for
    |q| = 1 (Gram matrix |q|^2 E);
  * Lemma 3 (p. 243): det(E + dt Dv) = 1 + dt div v + O(dt^2);
  * Lemma 4 (p. 244): Green's formula on the unit disc for an explicit
    polynomial field (the printed P_y - Q_x refuted); Proposition 3
    (p. 245): the corrected integrand d Q/d x (printed d Q/d y refuted) and
    both formulas for the potential;
  * p. 247: for a = x^3 - 3xy^2 the conjugate potential b = 3x^2 y - y^3
    satisfies b_x = -Q, b_y = P, the conjugate of b is -a (the printed "a is
    conjugate to b" refuted), <v, v~> = 0; pp. 247-248: d/dz, d/dz^, the
    Cauchy-Riemann equations, f'_z = a_x - i a_y = b_y + i b_x,
    <grad a, grad b> = 0; z^k and z^-k in polar form (p. 249);
  * p. 250: (ln(z + alpha) - ln(z - alpha))/alpha -> 2/z (the printed 1/z
    refuted).

Section 5, surfaces (content/04-05-surface-classification.typ,
pp. 253-275)
  * the Klein bottle group (p. 260): with the corrected b(x, y) = (x + 1, y),
    a b a^-1 = b^-1 and every word of length <= 8 is (x, y) ->
    ((-1)^n x + m, y + n), without fixed points unless it is the identity;
    with the printed b(x, y) = (x, y + 1), a b^-1 is the reflection
    (x, y) -> (1 - x, y) with fixed points (refuted);
  * polygon words: vertex classes, Euler characteristic V - E + 1 and
    orientability of the words of the section: torus, Klein bottle, RP^2,
    the pretzel (p. 263), the word of Fig. 105 (p. 271), the normal forms of
    Lemma 10 (g <= 6, k <= 8), S^2 + k r + s mu = S^2 + (2k + s) mu
    (k, s <= 4, s >= 1), Theorem 3 (p. 275) for N <= 10: for eps = -1 the
    words with N = 1 (sphere) and N = 3 (torus) are orientable, so the
    printed "N is even" is refuted as a consequence, chi = 2 - N for even N
    and 3 - N for odd N; for eps = +1 chi = 2 - N, non-orientable; the
    transformations of Lemmas 5, 6, 7 and the word W~ of Lemma 9 preserve
    (chi, orientability) on 300 random words each; the triangulation of RP^2
    with 13 vertices and 24 triangles (p. 269) has chi = 1.

Section 6, Riemann surfaces (content/04-06-riemann-surfaces.typ,
pp. 276-299)
  * pp. 276-277: d/dx = d/dz + d/dz^, d/dy = i(d/dz - d/dz^), Laplacian
    = 4 d^2/dz dz^ on polynomials of degree <= 4; the corrected real part
    u_x - v_y and u_xx + u_yy = 0 (the printed u_x - u_y and u_xx + v_yy
    refuted on f = z^2);
  * Theorem 1 (p. 279): at a zero (z0, 0) of w^2 - z the curve is the graph
    z = w^2, not a graph w = g(z) (two points (e^2, +-e)) - the printed
    reading refuted;
  * Theorem 2 (pp. 286-287): in u = 1/z, v = 1/w the closure of
    w^2 = prod (z - a_k) is F = v^2 prod (1 - a_k u) - u^n = 0; the gradient
    of f~ is (1, 0) for n > 1 and (1, -1) for n = 1 (the printed (1, 1)
    refuted);
    F is singular at (0, 0) exactly for n >= 2 (n <= 12, generic a_k): for
    n = 2 two transversal smooth branches (tangent cone v^2 - u^2), for even
    n >= 4 two tangent smooth branches (blow-up identities), for odd n >= 3
    one branch, symmetric under v -> -v, with the power-series
    parametrization (s^2 + ..., s^n + ...) (n = 3, 5, 7), not an immersion;
    so Theorem 2 as printed fails for 2 <= n <= 12;
  * pp. 288-289: the homogenized curve in CP^2 for a_k = 1, ..., n is smooth
    for n <= 3 and singular exactly at (0 : 1 : 0) for 4 <= n <= 8; the
    printed "zero gradient of q for n > 2" refuted for n = 3; geometric
    genus [(n - 1)/2] and arithmetic genus (n - 1)(n - 2)/2; the case n = 2
    (p. 289) with the corrected a_2;
  * Proposition 2 (p. 291): prod (1/u - a_k) = u^-n prod (1 - a_k u), n <= 6,
    the corrected position of the product (the printed one refuted);
  * Theorem 3 (p. 294): genus [(n - 1)/2] by the Riemann-Hurwitz count
    (n <= 40) and by Sage's genus of the function field of
    y^2 = prod_(k <= n) (x - k), n <= 10;
  * p. 298: g'(z) = u_x + i v_x = v_y + i v_x for g = z^3; z fails to be a
    local coordinate of w^2 = (z - 1)(z - 2)(z - 3) exactly at z = 1, 2, 3
    (not at z = 0: the printed "except the point 0" refuted).

What these checks do NOT establish.  An identity in a polynomial or rational
function ring, or in the symbolic ring with arbitrary functions, holds for
all values of the written variables; all other checks are exhaustive only
for the listed sizes n, words, curves and parameters.  None of them proves a
general theorem of the book for all n.  Topological statements
(connectedness, being a submanifold, homeomorphism type) are reduced to the
algebra stated in the comments: the Euler characteristic and orientability
of polygon words, the number of branches and the tangent cone of a plane
curve singularity, and Riemann-Hurwitz; the classification of surfaces and
the Riemann-Hurwitz formula are used, not proved.  The random words are
evidence only.  Nothing here compares our text with the printed book.
"""
import random
from itertools import product

from sage.all import (
    QQ, SR, I, Curve, FunctionField, PolynomialRing, PowerSeriesRing,
    ProjectiveSpace, QuaternionAlgebra, assume, block_matrix, cos, cosh, exp,
    function, identity_matrix, integral, limit, ln, matrix, pi, prod, sin,
    sinh, sqrt, taylor, var, vector, zero_matrix,
)

COUNT = [0]


def check(condition, label):
    """The book's statement (or our corrected reading) holds."""
    assert bool(condition), label
    COUNT[0] += 1


def refuted(condition, label):
    """The printed reading must fail: it is kept as a refuted check."""
    assert not bool(condition), 'printed reading unexpectedly holds: ' + label
    COUNT[0] += 1


def zero(e):
    """Exact zero test in the symbolic ring."""
    return bool(SR(e).simplify_full() == 0)


def zero_pos(e):
    """Exact zero test when every variable of e is positive (radicals of
    squares are then taken positively)."""
    return bool(SR(e).canonicalize_radical().simplify_full() == 0)


def vzero(v):
    return all(zero(e) for e in v)


def vzero_pos(v):
    return all(zero_pos(e) for e in v)


def mzero(M):
    return all(zero(e) for e in M.list())


def vdiff(v, x):
    return vector(SR, [SR(e).diff(x) for e in v])


def cross(a, b):
    return vector(SR, [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2],
                       a[0] * b[1] - a[1] * b[0]])


# ---------------------------------------------------------------------------
# Section 1. Curves.

def section_1():
    s, t = var('s t', domain='real')
    R = var('R', domain='positive')
    x0, y0, al, be = var('x0 y0 al be', domain='real')

    # p. 157: the straight line x = x0 + al s, y = y0 + be s, al^2 + be^2 = 1.
    line = vector(SR, [x0 + al * s, y0 + be * s])
    check(vzero(vdiff(vdiff(line, s), s)), 'p. 157: the line has k = 0')

    # pp. 157-158: the circle of radius R.
    r = vector(SR, [x0 + R * cos(s / R), y0 + R * sin(s / R)])
    v = vdiff(r, s)
    check(vzero(v - vector(SR, [-sin(s / R), cos(s / R)])),
          'p. 157: v(s) = (-sin(s/R), cos(s/R))')
    check(zero(v.dot_product(v) - 1), 'p. 157: s is the natural parameter')
    dv = vdiff(v, s)
    check(vzero(dv - vector(SR, [-cos(s / R) / R, -sin(s / R) / R])),
          'p. 158: dv/ds = (-1/R cos(s/R), -1/R sin(s/R))')
    check(zero(dv.dot_product(dv) - 1 / R ** 2), 'p. 158: k = 1/R')
    # p. 157: n(s) = ((x")^2 + (y")^2)^(-1/2) (x" e_1 + y" e_2), on the circle
    nc = dv / sqrt(dv[0] ** 2 + dv[1] ** 2)
    check(vzero_pos(nc - R * dv),
          'p. 157 corrected: n(s) = (x"^2 + y"^2)^(-1/2)(x", y") is the unit '
          'vector R dv/ds')
    np_ = (dv / sqrt(dv[0] + dv[1])).subs(s=pi * R, R=2)
    refuted(zero(np_.dot_product(np_) - 1),
            'p. 157 printed: (x" + y")^(-1/2)(x", y") is a unit vector '
            '(R = 2)')
    check(vzero(r.subs(s=2 * pi * R) - r.subs(s=0)),
          'p. 157 corrected: s runs from 0 to 2 pi R')
    refuted(vzero((r.subs(s=2 * pi) - r.subs(s=0)).subs(R=2)),
            'p. 157 printed: s runs from 0 to 2 pi (R = 2)')

    # Theorem 1 (pp. 158-159), arbitrary functions x(t), y(t).
    X = function('X')(t)
    Y = function('Y')(t)
    rt = vector(SR, [X, Y])
    vt = vdiff(rt, t)
    S = vt.dot_product(vt)
    # d^2 r/ds^2 = (dt/ds) d/dt (v/|v|), dt/ds = 1/|v|
    kvec = vdiff(vt / sqrt(S), t) / sqrt(S)
    x1, x2 = X.diff(t), X.diff(t, 2)
    y1, y2 = Y.diff(t), Y.diff(t, 2)
    check(zero(kvec.dot_product(kvec)
               - (x2 * y1 - y2 * x1) ** 2 / (x1 ** 2 + y1 ** 2) ** 3),
          'p. 158, Theorem 1: k^2 = (x"y\' - y"x\')^2/((x\')^2 + (y\')^2)^3')
    check(zero(kvec[0] - (x2 * y1 ** 2 - x1 * y1 * y2)
               / (x1 ** 2 + y1 ** 2) ** 2),
          'p. 159: the e_1-component of d^2r/ds^2')
    check(zero(kvec[1] - (y2 * x1 ** 2 - y1 * x1 * x2)
               / (x1 ** 2 + y1 ** 2) ** 2),
          'p. 159: the e_2-component of d^2r/ds^2')
    check(zero(kvec.dot_product(kvec) - (x1 ** 2 + y1 ** 2) ** (-4)
               * (y1 ** 2 * (x2 * y1 - y2 * x1) ** 2
                  + x1 ** 2 * (y2 * x1 - x2 * y1) ** 2)),
          'p. 159: the printed expression for k^2')
    # the circle in an arbitrary parameter: the formula gives 1/R
    xc, yc = R * cos(t), R * sin(t)
    kc2 = ((xc.diff(t, 2) * yc.diff(t) - yc.diff(t, 2) * xc.diff(t)) ** 2
           / (xc.diff(t) ** 2 + yc.diff(t) ** 2) ** 3)
    check(zero(kc2 - 1 / R ** 2), 'Theorem 1 on the circle: k = 1/R')

    # Theorem 2 and pp. 160-161: a frame turned by phi(s).
    phi = function('phi')(s)
    vv = vector(SR, [cos(phi), sin(phi)])
    nn = vector(SR, [-sin(phi), cos(phi)])
    check(vzero(vdiff(vv, s) - phi.diff(s) * nn), 'p. 159: dv/ds = k n')
    check(vzero(vdiff(nn, s) + phi.diff(s) * vv),
          'p. 159: dn/ds = -k v, with k = d phi/ds (p. 161)')
    dp = var('dp')
    A = matrix(SR, [[cos(dp), sin(dp)], [-sin(dp), cos(dp)]])
    A1 = A.apply_map(lambda e: taylor(e, dp, 0, 1))
    check(mzero(A1 - identity_matrix(SR, 2)
                - matrix(SR, [[0, dp], [-dp, 0]])),
          'p. 160: A(d phi) = E + (0, d phi; -d phi, 0) + ...')
    # omega(s + ds) = A omega(s): v turns towards n
    check(vzero(A.row(0) * matrix(SR, [vv, nn])
                - vv.subs({phi: phi + dp})),
          'p. 160: the first row of A turns v by d phi towards n')

    # Lemma 3 (p. 163): a family of rotations through E (Cayley family).
    Rk = PolynomialRing(QQ, 'k1,k2,k3,tt')
    k1, k2, k3, tt = Rk.gens()
    K = matrix(Rk, [[0, -k3, k2], [k3, 0, -k1], [-k2, k1, 0]])
    Ff = Rk.fraction_field()
    E3 = identity_matrix(Ff, 3)
    Kf_ = K.change_ring(Ff)
    At = (E3 - tt * Kf_).inverse() * (E3 + tt * Kf_)
    check(At * At.transpose() == E3 and At.det() == 1,
          'p. 162: the family A(t) is orthogonal with det +1')
    check(At.subs({tt: 0}) == E3, 'p. 162: A(0) = E')
    Xd = At.apply_map(lambda e: e.derivative(tt)).subs({tt: 0})
    check(Xd + Xd.transpose() == 0, 'p. 163, Lemma 3: X = A\'(0) is skew')

    # Theorem 4 (pp. 165-166) in R^4: a curve with natural parameter s.
    def frenet(r, n):
        ders = [r]
        for _ in range(n):
            ders.append(vdiff(ders[-1], s))
        ders = ders[1:]
        taus = []
        for d in ders:
            w = d - sum((d.dot_product(u) * u for u in taus),
                        vector(SR, [0] * len(r)))
            w = w.apply_map(lambda e: e.simplify_full())
            taus.append((w / sqrt(w.dot_product(w).simplify_full()))
                        .apply_map(lambda e: e.simplify_full()))
        M = matrix(SR, n, n,
                   lambda i, j: vdiff(taus[i], s).dot_product(taus[j])
                   .simplify_full())
        return taus, ders, M

    r4 = vector(SR, [cos(s / sqrt(2)), sin(s / sqrt(2)),
                     cos(sqrt(2) * s) / 2, sin(sqrt(2) * s) / 2])
    check(zero(vdiff(r4, s).dot_product(vdiff(r4, s)) - 1),
          'R^4 curve: s is natural')
    taus, ders, M = frenet(r4, 4)
    check(not zero(matrix(SR, [list(d) for d in ders]).det()),
          'R^4 curve: r\', ..., r"" are linearly independent')
    check(mzero(M + M.transpose()), 'p. 166: the Frenet matrix is skew')
    check(all(zero(M[i, j]) for i in range(4) for j in range(4)
              if abs(i - j) != 1),
          'p. 165, Theorem 4: d tau_i/ds lies in span(tau_(i-1), tau_(i+1))')
    a12, a23, a34 = M[0, 1], M[1, 2], M[2, 3]
    check(not zero(a12) and not zero(a23) and not zero(a34),
          'Theorem 4: k_2, k_3, k_4 are nonzero')
    # d tau_1/ds = k_2 tau_2 requires k_2 = a_12 (corrected k_(i+1) =
    # a_(i,i+1)); the printed k_i = a_(i,i+1) would give k_2 = a_23.
    check(vzero(vdiff(taus[0], s) - a12 * taus[1]),
          'p. 166 corrected: d tau_1/ds = a_12 tau_2, k_2 = a_12')
    refuted(zero(a12 - a23),
            'p. 166 printed: k_i = a_(i,i+1), i.e. k_2 = a_23 = a_12')

    # the helix (illustration of p. 166): k = a/(a^2 + b^2), torsion
    # b/(a^2 + b^2), tau_3 = [v, n].
    a, b = var('a b', domain='positive')
    c = sqrt(a ** 2 + b ** 2)
    hx = vector(SR, [a * cos(s / c), a * sin(s / c), b * s / c])
    taus, ders, M = frenet(hx, 3)
    check(zero_pos(M[0, 1] - a / (a ** 2 + b ** 2))
          and zero_pos(M[1, 2] - b / (a ** 2 + b ** 2)),
          'helix: curvature a/(a^2+b^2), torsion b/(a^2+b^2)')
    check(vzero_pos(taus[2] - cross(taus[0], taus[1])),
          'p. 166: tau_3 = [v, n] for the helix')

    # Proposition 2 (p. 168) as stated is refuted.
    Rt = PolynomialRing(QQ, 'u')
    u = Rt.gen()
    f = (u ** 2 - 1, u ** 3 - u)
    df = (f[0].derivative(), f[1].derivative())
    check(Rt.ideal([df[0], df[1]]) == Rt.ideal(1),
          'nodal cubic (Tu, Ex. 11.8): the velocity never vanishes')
    check(f[0](1) == f[0](-1) == 0 and f[1](1) == f[1](-1) == 0,
          'nodal cubic: f(1) = f(-1) = (0, 0)')
    two_lines = matrix(QQ, [[df[0](1), df[1](1)], [df[0](-1), df[1](-1)]])
    refuted(two_lines.det() == 0,
            'p. 168, Proposition 2 printed: a curve with nonzero velocity '
            'is a submanifold (one tangent line at the origin)')
    tf = var('tf')
    f8 = vector(SR, [cos(tf), sin(2 * tf)])
    check(vzero(f8.subs(tf=pi / 2)) and vzero(f8.subs(tf=-pi / 2))
          and vzero(f8.subs(tf=3 * pi / 2)),
          'figure-eight (Tu, Ex. 11.12): both ends tend to f(pi/2) = (0, 0)')
    d8 = vdiff(f8, tf)
    check(not zero(matrix(SR, [d8.subs(tf=pi / 2),
                               d8.subs(tf=-pi / 2)]).det()),
          'figure-eight: the branch and the ends cross with distinct tangents')


# ---------------------------------------------------------------------------
# Section 2. Surfaces.

def first_form(r, coords):
    J = [vdiff(r, x) for x in coords]
    return matrix(SR, len(coords), len(coords),
                  lambda i, j: J[i].dot_product(J[j]))


def forms(r, u, v):
    """E, F, G, L, M, N with the unit normal r_u x r_v / |r_u x r_v|."""
    ru, rv = vdiff(r, u), vdiff(r, v)
    nn = cross(ru, rv)
    W = sqrt(nn.dot_product(nn))
    E, F, G = ru.dot_product(ru), ru.dot_product(rv), rv.dot_product(rv)
    L = vdiff(ru, u).dot_product(nn) / W
    M = vdiff(ru, v).dot_product(nn) / W
    N = vdiff(rv, v).dot_product(nn) / W
    return E, F, G, L, M, N


def section_2():
    x, y, u, v, s, t = var('x y u v s t', domain='real')

    # p. 170: graph x^4 = f(x^1, x^2, x^3) in R^4.
    xs = var('x1 x2 x3', domain='real')
    f = function('f')(*xs)
    g = first_form(vector(SR, list(xs) + [f]), xs)
    check(mzero(g - matrix(SR, 3, 3, lambda i, j: (1 if i == j else 0)
                           + f.diff(xs[i]) * f.diff(xs[j]))),
          'p. 170: g_kp = delta_kp + f_k f_p for a graph')
    # p. 171: level set, f_k = -F_k/F_n.
    Rl = PolynomialRing(QQ, 'F1,F2,F3,F4')
    F1, F2, F3, F4 = Rl.fraction_field().gens()
    Fk = [F1, F2, F3]
    check(all(1 * (i == j) + (Fk[i] / F4) * (Fk[j] / F4)
              == (Fk[i] * Fk[j]) / F4 ** 2 + (1 if i == j else 0)
              for i in range(3) for j in range(3)),
          'p. 171: g_kp = F_k F_p / F_n^2 + delta_kp')

    # p. 172: surface of revolution phi = u, z = v, r = r(v).
    rr = function('rr')(v)
    rev = vector(SR, [rr * cos(u), rr * sin(u), v])
    g = first_form(rev, (u, v))
    check(zero(g[0, 0] - rr ** 2) and zero(g[0, 1])
          and zero(g[1, 1] - 1 - rr.diff(v) ** 2),
          'p. 172: E = r^2, F = 0, G = 1 + (r\')^2')

    # Lemma 2 (p. 175): invariance of det(G^-1 Q - lambda E).
    R2 = PolynomialRing(QQ, 'g11,g12,g22,q11,q12,q22,j11,j12,j21,j22,lam')
    K2 = R2.fraction_field()
    g11, g12, g22, q11, q12, q22, j11, j12, j21, j22, lam = K2.gens()
    G2 = matrix(K2, [[g11, g12], [g12, g22]])
    Q2 = matrix(K2, [[q11, q12], [q12, q22]])
    J2 = matrix(K2, [[j11, j12], [j21, j22]])
    E2 = identity_matrix(K2, 2)
    check(((J2 * G2 * J2.T).inverse() * (J2 * Q2 * J2.T) - lam * E2).det()
          == (G2.inverse() * Q2 - lam * E2).det(),
          'p. 175, Lemma 2: the characteristic polynomial is invariant (2x2)')
    R3 = PolynomialRing(QQ, ['g%d%d' % (i, j) for i in range(3)
                             for j in range(i, 3)]
                        + ['q%d%d' % (i, j) for i in range(3)
                           for j in range(i, 3)] + ['lam'])
    K3 = R3.fraction_field()
    gg = K3.gens()
    G3 = matrix(K3, 3, 3)
    Q3 = matrix(K3, 3, 3)
    idx = 0
    for i in range(3):
        for j in range(i, 3):
            G3[i, j] = G3[j, i] = gg[idx]
            Q3[i, j] = Q3[j, i] = gg[6 + idx]
            idx += 1
    lam3 = gg[-1]
    J3 = matrix(K3, [[2, 1, 0], [-1, 3, 1], [1, 0, 1]])
    E3 = identity_matrix(K3, 3)
    check(((J3 * G3 * J3.T).inverse() * (J3 * Q3 * J3.T) - lam3 * E3).det()
          == (G3.inverse() * Q3 - lam3 * E3).det(),
          'p. 175, Lemma 2 for 3 x 3 (generic G, Q; a fixed J)')

    # p. 186: G^-1 Q, H and K in terms of E, F, G, L, M, N.
    Rf = PolynomialRing(QQ, 'E,F,G,L,M,N')
    Kf = Rf.fraction_field()
    E_, F_, G_, L_, M_, N_ = Kf.gens()
    Gm = matrix(Kf, [[E_, F_], [F_, G_]])
    Qm = matrix(Kf, [[L_, M_], [M_, N_]])
    gdet = E_ * G_ - F_ ** 2
    check(Gm.inverse() * Qm == matrix(Kf, [[G_ * L_ - F_ * M_,
                                             G_ * M_ - F_ * N_],
                                            [-F_ * L_ + E_ * M_,
                                             -M_ * F_ + E_ * N_]]) / gdet,
          'p. 186: G^-1 Q')
    check((Gm.inverse() * Qm).trace()
          == (G_ * L_ - 2 * M_ * F_ + E_ * N_) / gdet, 'p. 186: H')
    check((Gm.inverse() * Qm).det() == (L_ * N_ - M_ ** 2) / gdet,
          'p. 186: K = (LN - M^2)/(EG - F^2)')

    # p. 187: graph z = f(x, y) with an arbitrary function f.
    fn = function('f')
    f = fn(x, y)
    gr = vector(SR, [x, y, f])
    E, F, G, L, M, N = forms(gr, x, y)
    W = sqrt(1 + f.diff(x) ** 2 + f.diff(y) ** 2)
    check(zero(L - f.diff(x, 2) / W) and zero(M - f.diff(x, y) / W)
          and zero(N - f.diff(y, 2) / W),
          'p. 187: L, M, N = f_xx, f_xy, f_yy over sqrt(1 + f_x^2 + f_y^2)')
    nup = cross(vdiff(gr, x), vdiff(gr, y))
    check(vzero(nup - vector(SR, [-f.diff(x), -f.diff(y), 1])),
          'p. 187: the normal is grad(z - f)/|grad(z - f)|')
    Hf = (G * L - 2 * M * F + E * N) / (E * G - F ** 2)
    Kg = (L * N - M ** 2) / (E * G - F ** 2)
    num_H = ((1 + f.diff(y) ** 2) * f.diff(x, 2)
             - 2 * f.diff(x) * f.diff(y) * f.diff(x, y)
             + (1 + f.diff(x) ** 2) * f.diff(y, 2))
    check(zero(Hf - num_H / W ** 3), 'p. 187: H with the exponent 3/2')
    hess = f.diff(x, 2) * f.diff(y, 2) - f.diff(x, y) ** 2
    check(zero(Kg - hess / W ** 4), 'p. 187 corrected: K with the exponent 2')
    # the printed exponent 3/2 is refuted on z = x^2 - y^2 at (1, 0)
    fs = x ** 2 - y ** 2
    Kfs = Kg.substitute_function(fn, (x ** 2 - y ** 2).function(x, y))
    check(zero(Kfs - (-4) / (1 + 4 * (x ** 2 + y ** 2)) ** 2),
          'p. 188: z = x^2 - y^2 has K = -4/(1 + 4(x^2 + y^2))^2')
    printed_K = ((fs.diff(x, 2) * fs.diff(y, 2) - fs.diff(x, y) ** 2)
                 / (1 + fs.diff(x) ** 2 + fs.diff(y) ** 2) ** (QQ(3) / 2))
    refuted(zero((printed_K - Kfs).subs(x=1, y=0)),
            'pp. 187, 188 printed: K = (f_xx f_yy - f_xy^2)/(1 + ...)^(3/2)')
    # at a critical point (p. 178)
    crit = {f.diff(x): 0, f.diff(y): 0}
    check(zero(Hf.subs(crit) - f.diff(x, 2) - f.diff(y, 2))
          and zero(Kg.subs(crit) - hess),
          'p. 178: at a critical point H = f_xx + f_yy, K = det Hess')
    # p. 206: H for z = x^2 - y^2
    num_s = num_H.substitute_function(fn, (x ** 2 - y ** 2).function(x, y))
    check(zero(num_s - 8 * (y ** 2 - x ** 2)),
          'p. 206: the numerator of H for z = x^2 - y^2 is 8(y^2 - x^2)')
    check(zero(num_s.subs(x=1, y=1)) and zero(num_s.subs(x=1, y=-1)),
          'p. 206 corrected: H = 0 on the lines y = +-x')
    refuted(not zero(num_s.subs(x=1, y=1)),
            'p. 206 printed: H = 0 only at (0, 0)')
    rh = vector(SR, [x, y, x ** 2 - y ** 2])
    check(vzero(vdiff(vdiff(rh, x), x) + vdiff(vdiff(rh, y), y)),
          'p. 206: r(x, y) = (x, y, x^2 - y^2) is harmonic')
    # monkey saddle (p. 186)
    fm = x ** 3 - 3 * x * y ** 2
    Hm = matrix(SR, [[fm.diff(x, 2), fm.diff(x, y)],
                     [fm.diff(x, y), fm.diff(y, 2)]])
    check(mzero(Hm - 6 * matrix(SR, [[x, -y], [-y, -x]])),
          'p. 186: Q = 6 (x, -y; -y, -x) for the monkey saddle')
    check(mzero(Hm.subs(x=0, y=0)) and zero(fm.diff(x).subs(x=0, y=0))
          and zero(fm.diff(y).subs(x=0, y=0)),
          'p. 186: Q = 0 and G = E at (0, 0)')

    # p. 187: the sphere of radius R.
    R = var('R', domain='positive')
    assume(x ** 2 + y ** 2 < R ** 2)
    sp = sqrt(R ** 2 - x ** 2 - y ** 2)
    Ksp = Kg.substitute_function(fn, sp.function(x, y))
    Hsp = Hf.substitute_function(fn, sp.function(x, y))
    check(zero(Ksp - 1 / R ** 2), 'p. 187: the sphere has K = 1/R^2')
    check(zero(Hsp ** 2 - 4 / R ** 2), 'p. 187: the sphere has |H| = 2/R')

    # p. 188: the ellipsoid task.
    a, b, c = var('a b c', domain='positive')
    th, ph = var('th ph', domain='real')
    el = vector(SR, [a * cos(th) * cos(ph), b * cos(th) * sin(ph),
                     c * sin(th)])
    on = el[0] ** 2 / a ** 2 + el[1] ** 2 / b ** 2 + el[2] ** 2 / c ** 2 - 1
    check(zero(on), 'p. 188 corrected: z = c sin theta lies on the ellipsoid')
    el_pr = vector(SR, [el[0], el[1], sin(th)])
    on_pr = (el_pr[0] ** 2 / a ** 2 + el_pr[1] ** 2 / b ** 2
             + el_pr[2] ** 2 / c ** 2 - 1)
    refuted(zero(on_pr.subs(c=2)), 'p. 188 printed: z = sin theta (c = 2)')
    E, F, G, L, M, N = forms(el, th, ph)
    Kel = (L * N - M ** 2) / (E * G - F ** 2)
    Kclosed = 1 / (a ** 2 * b ** 2 * c ** 2
                   * (el[0] ** 2 / a ** 4 + el[1] ** 2 / b ** 4
                      + el[2] ** 2 / c ** 4) ** 2)
    check(zero(Kel - Kclosed),
          'p. 188, task: K = 1/(a^2 b^2 c^2 (x^2/a^4 + ...)^2) > 0')

    # p. 181: x^1, ..., x^(n-2) are coordinates on S^(n-2) where x^(n-1) > 0;
    # on the equator (n = 3: the point (1, 0) of S^1) the tangent vector
    # (0, 1) is killed by dx^1.
    thc = var('thc', domain='real')
    tang = vdiff(vector(SR, [cos(thc), sin(thc)]), thc).subs(thc=0)
    refuted(not zero(tang[0]),
            'p. 181 printed: x^1 is a coordinate where x^2 >= 0 (fails at '
            'the equator point (1, 0))')
    check(all(not zero(vdiff(vector(SR, [cos(thc), sin(thc)]), thc)[0]
                       .subs(thc=th0))
              for th0 in (pi / 6, pi / 3, 2 * pi / 3)),
          'p. 181 corrected: dx^1 != 0 on the tangent line where x^2 > 0')
    # p. 183: a critical point of f = B(x, x) on S^1 with B x_0 = 0.
    Bm = matrix(QQ, [[1, 0], [0, 0]])
    fB = (vector(SR, [cos(thc), sin(thc)]) * Bm
          * vector(SR, [cos(thc), sin(thc)]))
    check(zero(fB.diff(thc).subs(thc=pi / 2))
          and Bm * vector(QQ, [0, 1]) == 0,
          'p. 183: x_0 = (0, 1) is critical for B = diag(1, 0), B x_0 = 0')
    refuted(Bm * vector(QQ, [0, 1]) != 0,
            'p. 183 printed: lambda(x_0) != 0 at every critical point')
    # p. 183: the quadric lambda_1 x_1^2 + lambda_2 x_2^2 = 1.
    l1, l2 = var('l1 l2', domain='positive')
    check(zero(l1 * (1 / sqrt(l1)) ** 2 - 1) and zero(l2 * (1 / sqrt(l2)) ** 2
                                                       - 1),
          'p. 183 corrected: for lambda_i > 0 the semi-axes are 1/sqrt('
          'lambda_i)')
    tq = var('tq', domain='real')
    check(zero((1 * 1 ** 2 + 0 * tq ** 2) - 1),
          'p. 183: lambda = (1, 0): the points (1, t) for all t lie on the '
          'quadric')
    refuted(matrix(QQ, [[1, 0], [0, 0]]).is_positive_definite(),
            'p. 183 printed: lambda_i >= 0 gives an ellipsoid (lambda = '
            '(1, 0): the form is not definite, the quadric is the pair of '
            'lines x_1 = +-1)')

    # p. 188: the triangle A B x of Fig. 22: A = (x, y), the tangent at A
    # meets Ox at B = (x - y/y', 0), x is the foot of the perpendicular.
    xa, ya, ypa = var('xa ya ypa', domain='real')
    Bx = xa - ya / ypa
    check(zero(ya / (Bx - xa) + ypa),
          'p. 188: from the triangle A B x, tg phi = y/(x_B - x) = -y\'')
    check(zero(((Bx - xa) ** 2 + ya ** 2) * ypa ** 2
               - ya ** 2 * (1 + ypa ** 2)),
          'p. 188: |AB|^2 y\'^2 = y^2 (1 + y\'^2), so |AB| = a gives the '
          'equation of p. 189')

    # pp. 188-189: the tractrix.
    a = var('a', domain='positive')
    # 0 < phi < pi/2 with tg(phi/2) = m, 0 < m < 1; tg phi = -y'_x (p. 188)
    Rm = PolynomialRing(QQ, 'm').fraction_field()
    m = Rm.gen()
    cphi, sphi = (1 - m ** 2) / (1 + m ** 2), 2 * m / (1 + m ** 2)
    yp = -sphi / cphi
    check(cphi ** 2 + sphi ** 2 == 1 and yp ** 2 / (1 + yp ** 2) == sphi ** 2
          and -yp == 2 * m / (1 - m ** 2),
          'p. 189 corrected: sin phi = -y\'/sqrt(1 + y\'^2) (both sides '
          'positive for 0 < m < 1, equal squares)')
    refuted(yp(QQ(1) / 2) * sphi(QQ(1) / 2) > 0,
            'p. 189 printed: sin phi = y\'/sqrt(1 + y\'^2) (opposite signs)')
    yy = var('yy', domain='positive')
    assume(yy < a)
    # a y'/sqrt(1 + y'^2) = -y with y' = -y/sqrt(a^2 - y^2):
    ypy = -yy / sqrt(a ** 2 - yy ** 2)
    check(zero_pos(a * ypy / sqrt(1 + ypy ** 2) + yy),
          'p. 189: a y\'/sqrt(1 + y\'^2) = -y')
    xpy = 1 / ypy
    check(zero(xpy + sqrt(a ** 2 - yy ** 2) / yy),
          'p. 189: x\'_y = -sqrt(a^2 - y^2)/y')
    xclosed = (-sqrt(a ** 2 - yy ** 2)
               + a / 2 * ln((a + sqrt(a ** 2 - yy ** 2))
                            / (a - sqrt(a ** 2 - yy ** 2))))
    check(zero(xclosed.diff(yy) - xpy),
          'p. 189: the closed form of x(y) has derivative x\'_y')
    check(zero(limit(xclosed, yy=a, dir='-')),
          'p. 189: the closed form vanishes at y = a (x(a) = 0)')
    # the corrected chain: x(y) = int_y^a sqrt(a^2 - t^2)/t dt
    #   = a^2 int_y^a dt/(t sqrt(a^2 - t^2)) - int_y^a t dt/sqrt(a^2 - t^2)
    tt_ = var('tt_', domain='positive')
    check(zero(sqrt(a ** 2 - tt_ ** 2) / tt_
               - (a ** 2 / (tt_ * sqrt(a ** 2 - tt_ ** 2))
                  - tt_ / sqrt(a ** 2 - tt_ ** 2))),
          'p. 189: the splitting of the integrand')
    check(zero(-(sqrt(a ** 2 - yy ** 2)).diff(yy)
               - yy / sqrt(a ** 2 - yy ** 2)),
          'p. 189: int_y^a t dt/sqrt(a^2 - t^2) = sqrt(a^2 - y^2)')
    second = a / 2 * ln((a + sqrt(a ** 2 - yy ** 2))
                        / (a - sqrt(a ** 2 - yy ** 2)))
    check(zero(-second.diff(yy) - a ** 2 / (yy * sqrt(a ** 2 - yy ** 2))),
          'p. 189: a^2 int_y^a dt/(t sqrt(a^2 - t^2)) = a/2 ln(...)')
    # the printed first member -int_y^a sqrt(a^2 - t^2)/t dt has the
    # derivative +sqrt(a^2 - y^2)/y, the closed form -sqrt(a^2 - y^2)/y.
    refuted(zero(sqrt(a ** 2 - yy ** 2) / yy - xclosed.diff(yy)),
            'p. 189 printed: x(y) = -int_y^a sqrt(a^2 - y^2)/y dy')

    # Lemmas 5, 6 (pp. 190-192): surface of revolution about Ox.
    xx, ph = var('xx ph', domain='real')
    r = function('r')(xx)
    sr = vector(SR, [xx, r * cos(ph), r * sin(ph)])
    rx, rph = vdiff(sr, xx), vdiff(sr, ph)
    rxph = vdiff(rx, ph)
    check(vzero(rxph - vector(SR, [0, -r.diff(xx) * sin(ph),
                                   r.diff(xx) * cos(ph)])),
          'p. 190: r_(x phi) = (0, -r\' sin phi, r\' cos phi)')
    nrm = vector(SR, [r.diff(xx), -cos(ph), -sin(ph)]) / sqrt(
        1 + r.diff(xx) ** 2)
    check(zero(nrm.dot_product(nrm) - 1) and zero(nrm.dot_product(rx))
          and zero(nrm.dot_product(rph)),
          'p. 190: n = (r\', -cos phi, -sin phi)/sqrt(1 + r\'^2) is '
          'the normal')
    check(zero(rxph.dot_product(nrm)) and zero(rx.dot_product(rph)),
          'p. 190, Lemma 5: M = 0 and F = 0')
    E, F, G = rx.dot_product(rx), rx.dot_product(rph), rph.dot_product(rph)
    L = vdiff(rx, xx).dot_product(nrm)
    N = vdiff(rph, ph).dot_product(nrm)
    Ksr = L * N / (E * G)
    r1, r2 = r.diff(xx), r.diff(xx, 2)
    check(zero(Ksr + r2 / (r * (1 + r1 ** 2) ** 2)),
          'p. 190, Lemma 6: K = -r"/(r(1 + r\'^2)^2), so |K| as printed')
    check(zero((N / G) ** 2 - 1 / (r ** 2 * (1 + r1 ** 2))),
          'p. 191: lambda_1 = 1/(r sqrt(1 + r\'^2)) (up to sign)')
    check(zero((L / E) ** 2 - r2 ** 2 / (1 + r1 ** 2) ** 3),
          'p. 191: lambda_2 = r"/(1 + r\'^2)^(3/2) (up to sign)')
    p1 = var('p1', domain='real')
    check(zero(vector(SR, [0, 1]).dot_product(
        vector(SR, [-p1, 1]) / sqrt(1 + p1 ** 2)) - 1 / sqrt(1 + p1 ** 2)),
          'p. 192: cos theta = 1/sqrt(1 + r\'^2)')

    # Lemma 7 (p. 192): the Beltrami surface, x = x(y), r = y.
    x1 = -sqrt(a ** 2 - yy ** 2) / yy
    x2 = x1.diff(yy)
    check(zero(x2 - a ** 2 / (yy ** 2 * sqrt(a ** 2 - yy ** 2))),
          'p. 192: x" = a^2/(r^2 sqrt(a^2 - y^2))')
    rp, rpp = 1 / x1, -x2 / x1 ** 3       # derivatives of the inverse function
    m1 = rpp / (yy * (1 + rp ** 2) ** 2)
    m2 = -x2 / (x1 ** 3 * yy * (1 + 1 / x1 ** 2) ** 2)
    m3 = -x2 * x1 / (yy * (1 + x1 ** 2) ** 2)
    check(zero(m1 - m2) and zero(m2 - m3),
          'p. 192: the members of the chain for |K| agree')
    check(zero(m3 - 1 / a ** 2), 'p. 192 corrected: |K| = ... = 1/a^2')
    refuted(zero(m3 + 1 / a ** 2), 'p. 192 printed: ... = -1/a^2')
    check(zero(-rpp / (yy * (1 + rp ** 2) ** 2) + 1 / a ** 2),
          'p. 192: K = -1/a^2 (Lemma 6 with the sign)')

    # p. 194: the metric of the Beltrami funnel.
    rr_ = var('rr_', domain='positive')
    assume(rr_ < a)
    xr = -sqrt(a ** 2 - rr_ ** 2) / rr_
    check(zero(1 + xr ** 2 - a ** 2 / rr_ ** 2),
          'p. 194: 1 + (x\'_r)^2 = a^2/r^2')
    check(zero((1 + xr ** 2 - 1 / rr_ ** 2).subs(a=1)),
          'p. 194 corrected (a = 1): ds^2 = dr^2/r^2 + r^2 d phi^2')
    refuted(zero((1 + xr ** 2 - 1 / rr_ ** 2).subs(a=2)),
            'p. 194 printed for any a: ds^2 = dr^2/r^2 + r^2 d phi^2 (a = 2)')
    vv_ = var('vv_', domain='positive')
    # pull back by r = 1/v: dr = -dv/v^2
    dr_dv = (1 / vv_).diff(vv_)
    check(zero((dr_dv ** 2 / (1 / vv_) ** 2) - 1 / vv_ ** 2)
          and zero((1 / vv_) ** 2 - 1 / vv_ ** 2),
          'p. 194, Assertion 1: u = phi, v = 1/r give (du^2 + dv^2)/v^2')
    dr_dv = (a / vv_).diff(vv_)
    check(zero(a ** 2 * dr_dv ** 2 / (a / vv_) ** 2 - a ** 2 / vv_ ** 2)
          and zero((a / vv_) ** 2 - a ** 2 / vv_ ** 2),
          'p. 194 for any a: v = a/r gives a^2 (du^2 + dv^2)/v^2')
    rho, fi = var('rho fi', domain='positive')
    zz = rho * exp(I * fi)
    check(zero((1 / zz).real_part() - cos(fi) / rho)
          and zero((1 / zz).imag_part() + sin(fi) / rho),
          'p. 196: Re(1/z) = cos(phi)/r, Im(1/z) = -sin(phi)/r')

    # p. 201: the catenoid y = a cosh(x/a).
    yc = a * cosh(xx / a)
    y1, y2 = yc.diff(xx), yc.diff(xx, 2)
    check(zero(y2 - cosh(xx / a) / a), 'p. 201: y" = (1/a) cosh(x/a)')
    Hc = 1 / (yc * sqrt(1 + y1 ** 2)) - y2 / (1 + y1 ** 2) ** (QQ(3) / 2)
    check(zero(Hc), 'p. 201: H = 0 for the catenoid')
    sq = 1 + sinh(xx / a) ** 2
    printed = (1 / yc * sq ** (-QQ(1) / 2)
               - QQ(1) / 2 * cosh(xx / a) * sq ** (-QQ(3) / 2))
    corrected = (1 / yc * sq ** (-QQ(1) / 2)
                 - 1 / a * cosh(xx / a) * sq ** (-QQ(3) / 2))
    check(zero(corrected), 'p. 201 corrected: the second line with 1/a')
    refuted(zero(printed.subs(a=1, xx=0)),
            'p. 201 printed: the second line with 1/2 (a = 1, x = 0)')
    check(zero(-y2 / (yc * (1 + y1 ** 2) ** 2)
               + 1 / (a ** 2 * cosh(xx / a) ** 4)),
          'p. 202: K = -1/(a^2 ch^4(x/a)) of the catenoid, -1/a^2 at x = 0')
    # p. 200: the right helicoid in cylindrical coordinates
    cc = var('cc', domain='positive')
    hel = vector(SR, [v * cos(u), v * sin(u), cc * u])
    E, F, G, L, M, N = forms(hel, u, v)
    check(zero(G * L - 2 * M * F + E * N), 'p. 200: the helicoid is minimal')

    # Assertion 2 (p. 207): the catenoid in conformal coordinates.
    cat = vector(SR, [a * cosh(v) * cos(u), a * cosh(v) * sin(u), a * v])
    E, F, G, L, M, N = forms(cat, u, v)
    check(zero(E - G) and zero(F),
          'p. 207: (u, v) are conformal: E = G, F = 0')
    check(zero(G * L - 2 * M * F + E * N), 'p. 207: H = 0, L + N = 0')
    ru, rv = vdiff(cat, u), vdiff(cat, v)
    ruu, ruv, rvv = vdiff(ru, u), vdiff(ru, v), vdiff(rv, v)
    check(zero(ruu.dot_product(ru) - ruv.dot_product(rv))
          and zero(ruv.dot_product(ru) - rvv.dot_product(rv))
          and zero(ruu.dot_product(rv) + ru.dot_product(ruv))
          and zero(ruv.dot_product(rv) + ru.dot_product(rvv)),
          'p. 207: the four identities from E = G, F = 0')
    check(vzero(ruu + rvv), 'p. 207, Assertion 2: r_uu + r_vv = 0')



# ---------------------------------------------------------------------------
# Section 3. Transformation groups.

def rot(a):
    return matrix(SR, [[cos(a), sin(a)], [-sin(a), cos(a)]])


def mobius(M, w):
    return (M[0, 0] * w + M[0, 1]) / (M[1, 0] * w + M[1, 1])


def section_3():
    ph, ph2 = var('ph ph2', domain='real')
    ref = matrix(SR, [[cos(ph), sin(ph)], [sin(ph), -cos(ph)]])
    ref2 = ref.subs(ph=ph2)
    E2 = identity_matrix(SR, 2)
    check(mzero(rot(ph) * rot(ph).T - E2) and mzero(ref * ref.T - E2)
          and zero(rot(ph).det() - 1) and zero(ref.det() + 1),
          'p. 209: the two kinds of matrices of O(2), det +1 and -1')
    check(mzero(ref * ref2 - rot(ph2 - ph)),
          'p. 209: a product of two reflections is a rotation')
    r90 = matrix(QQ, [[0, 1], [-1, 0]])
    s0 = matrix(QQ, [[1, 0], [0, -1]])
    refuted(r90 * s0 == s0 * r90, 'p. 213 printed: O(2) is commutative')
    check(mzero(rot(ph) * rot(ph2) - rot(ph2) * rot(ph)),
          'p. 213 corrected: SO(2) is commutative')

    # Example 3 (p. 210): y = A x + b as block matrices.
    Rb = PolynomialRing(QQ, ['a%d%d' % (i, j) for i in range(2)
                             for j in range(2)]
                        + ['c%d%d' % (i, j) for i in range(2)
                           for j in range(2)] + ['b0', 'b1', 'd0', 'd1'])
    g = Rb.gens()
    A1 = matrix(Rb, 2, 2, g[0:4])
    A2 = matrix(Rb, 2, 2, g[4:8])
    b1 = matrix(Rb, 2, 1, g[8:10])
    b2 = matrix(Rb, 2, 1, g[10:12])

    def T(A, b):
        return block_matrix(Rb, [[A, b], [zero_matrix(Rb, 1, 2), 1]],
                            subdivide=False)

    check(T(A1, b1) * T(A2, b2) == T(A1 * A2, A1 * b2 + b1),
          'p. 210: (y = Ax + b) -> T is a homomorphism')

    # Example 4 (pp. 210-214): the pseudo-Euclidean plane.
    R4 = PolynomialRing(QQ, 'a,b,c,d')
    a, b, c, d = R4.gens()
    B = matrix(R4, [[-1, 0], [0, 1]])
    A = matrix(R4, [[a, b], [c, d]])
    D = A * B * A.T - B
    check(D[0, 0] == -(a ** 2 - b ** 2 - 1) and D[0, 1] == -(a * c - b * d)
          and D[1, 0] == D[0, 1] and D[1, 1] == d ** 2 - c ** 2 - 1,
          'p. 210: B = A B A^T is a^2 - b^2 = 1, ac = bd, d^2 - c^2 = 1')
    # psi = ln t, t > 0: ch psi = (t + 1/t)/2, sh psi = (t - 1/t)/2,
    # beta = th psi, sqrt(1 - beta^2) = 2t/(t^2 + 1).
    Rt = PolynomialRing(QQ, 't,s').fraction_field()
    t, s = Rt.gens()
    Bt = matrix(Rt, [[-1, 0], [0, 1]])

    def chs(x):
        return (x + 1 / x) / 2, (x - 1 / x) / 2

    cht, sht = chs(t)
    beta = sht / cht
    root = 2 * t / (t ** 2 + 1)
    check(root ** 2 == 1 - beta ** 2 and 1 / root == cht
          and beta / root == sht,
          'p. 211: 1/sqrt(1 - beta^2) = ch psi, '
          'beta/sqrt(1 - beta^2) = sh psi')
    Abeta = matrix(Rt, [[1, beta], [beta, 1]]) / root
    check(Abeta * Bt * Abeta.T == Bt,
          'p. 211 corrected: the matrix with numerators 1, beta, beta, 1')
    Apr = matrix(Rt, [[1, 1], [1, 1]]) / root
    refuted(Apr * Bt * Apr.T == Bt or Apr.det() != 0,
            'p. 211 printed: all four numerators 1 (det = 0)')

    def G(i, x):
        c_, s_ = chs(x)
        return {1: matrix(Rt, [[c_, s_], [s_, c_]]),
                2: matrix(Rt, [[-c_, -s_], [-s_, -c_]]),
                3: matrix(Rt, [[c_, -s_], [s_, -c_]]),
                4: matrix(Rt, [[-c_, s_], [-s_, c_]])}[i]

    check(all(G(i, t) * Bt * G(i, t).T == Bt for i in (1, 2, 3, 4)),
          'p. 211: the four sign patterns G_1, ..., G_4 preserve the metric')
    check(matrix(Rt, [[cht, -sht], [-sht, cht]]) == G(1, 1 / t),
          'p. 211: (+, -; -, +) lies in G_1 (psi -> -psi)')
    g_ = {1: matrix(Rt, [[1, 0], [0, 1]]), 2: matrix(Rt, [[-1, 0], [0, -1]]),
          3: matrix(Rt, [[1, 0], [0, -1]]), 4: matrix(Rt, [[-1, 0], [0, 1]])}
    check(all(G(i, Rt(1)) == g_[i] for i in g_),
          'p. 212: g_i = G_i at psi = 0 (the representatives of Fig. 52)')
    table = [[1, 2, 3, 4], [2, 1, 4, 3], [3, 4, 1, 2], [4, 3, 2, 1]]
    check(all(g_[i] * g_[j] == g_[table[i - 1][j - 1]]
              for i in g_ for j in g_),
          'p. 214: the multiplication table of g_1, ..., g_4 (16 cells)')
    check(all(g_[i] ** 2 == g_[1] for i in g_)
          and all(table[i][j] == table[j][i] for i in range(4)
                  for j in range(4)),
          'p. 214: G/G_1 has exponent 2 and is abelian: Z_2 + Z_2, not Z_4')
    check(G(1, t) * G(1, s) == G(1, t * s) == G(1, s) * G(1, t),
          'p. 213 corrected: G_1 is a commutative subgroup')
    check(G(2, t) * G(2, s) == G(1, t * s),
          'p. 212: the product of two matrices of G_2 lies in G_1')
    check(all(g_[i] * G(1, t) * g_[i].inverse() in (G(1, t), G(1, 1 / t))
              for i in g_),
          'p. 213: G_1 is normal (g_i G_1 g_i^-1 = G_1)')
    check(g_[2] * G(1, t) == G(2, t) and g_[3] * G(1, t) == G(3, 1 / t)
          and g_[4] * G(1, t) == G(4, 1 / t),
          'p. 213 corrected: G_i = g_i G_1')
    check(all(g_[i] * g_[j] == g_[j] * g_[i] for i in g_ for j in g_),
          'p. 213 corrected: the representatives g_i commute')
    refuted(g_[3] * G(1, Rt(2)) == G(1, Rt(2)) * g_[3],
            'p. 213 printed: the group G is commutative')

    # Example 6 and Lemmas 4, 5 (pp. 216-218).
    x, y = var('x y', domain='real')
    ar, br, cr, dr = var('ar br cr dr', domain='real')
    z = x + I * y
    w = mobius(matrix(SR, [[ar, br], [cr, dr]]), z)
    check(zero(w.diff(x) - (ar * dr - br * cr) / (cr * z + dr) ** 2),
          'p. 216: dw = (ad - bc)/(cz + d)^2 dz')
    check(zero(w.imag_part() - (ar * dr - br * cr) * y
               / ((cr * x + dr) ** 2 + cr ** 2 * y ** 2)),
          'p. 217: Im w = (ad - bc) Im z / |cz + d|^2')
    Rz = PolynomialRing(QQ, 'a,b,c,d,z,zb')
    a, b, c, d, zz, zb = Rz.gens()
    check((a * zz + b) * (c * zb + d)
          == a * c * zz * zb + b * d + a * d * zz + b * c * zb,
          'p. 217: the expansion of (az + b)(c z^ + d)')
    Kz = Rz.fraction_field()
    wz = (a * zz + b) / (c * zz + d)
    wzb = (a * zb + b) / (c * zb + d)
    check(wz - wzb == (a * d - b * c) * (zz - zb)
          / ((c * zz + d) * (c * zb + d)),
          'p. 217: w - w^ = (ad - bc)(z - z^)/|cz + d|^2 (real coefficients)')
    dw = wz.derivative(zz)
    dwb = wzb.derivative(zb)
    check(dw * dwb / (wz - wzb) ** 2 == Kz(1) / (zz - zb) ** 2,
          'p. 218, Lemma 5: dw dw^/(w - w^)^2 = dz dz^/(z - z^)^2')
    ypos = var('ypos', domain='positive')
    # at the point z = x + i ypos, the vector (1, 0): dz dz^ = 1
    check(zero(((x + I * ypos) - (x - I * ypos)) ** 2 + 4 * ypos ** 2),
          'p. 216: (z - z^)^2 = -4 y^2')
    refuted(bool((1 / ((x + I * ypos) - (x - I * ypos)) ** 2).subs(
        x=0, ypos=1) > 0),
            'p. 216 printed: dz dz^/(z - z^)^2 is a Riemannian metric '
            '(its value on (1, 0) is -1/(4 y^2) < 0)')
    check(zero(-4 / ((x + I * ypos) - (x - I * ypos)) ** 2 - 1 / ypos ** 2),
          'p. 216 corrected: -4 dz dz^/(z - z^)^2 = (dx^2 + dy^2)/y^2')
    uu, vv = var('uu vv', domain='real')
    lam = uu + I * vv
    Jm = matrix(SR, [[(lam * z).real_part().diff(x),
                      (lam * z).real_part().diff(y)],
                     [(lam * z).imag_part().diff(x),
                      (lam * z).imag_part().diff(y)]])
    check(zero(Jm.det() - (uu ** 2 + vv ** 2)),
          'p. 217: the Jacobian of z -> lambda z is u^2 + v^2')

    # Proposition 1 (p. 218): composition and kernel.
    R8 = PolynomialRing(QQ, 'a,b,c,d,a1,b1,c1,d1,z')
    a, b, c, d, a1, b1, c1, d1, z8 = R8.gens()
    K8 = R8.fraction_field()
    inner = (a * z8 + b) / (c * z8 + d)
    comp = (a1 * inner + b1) / (c1 * inner + d1)
    check(comp == ((a1 * a + c * b1) * z8 + (a1 * b + d * b1))
          / ((c1 * a + c * d1) * z8 + (c1 * b + d * d1)),
          'p. 218: the composite of two fractional linear maps')
    check(matrix(R8, [[a1, b1], [c1, d1]]) * matrix(R8, [[a, b], [c, d]])
          == matrix(R8, [[a1 * a + c * b1, a1 * b + d * b1],
                         [c1 * a + c * d1, c1 * b + d * d1]]),
          'p. 218: ... is given by the product of the matrices')
    R8b = PolynomialRing(QQ, 'a,b,c,d,a1,b1,c1,d1')
    a, b, c, d, a1, b1, c1, d1 = R8b.gens()
    # (az + b)(c'z + d') - (a'z + b')(cz + d) = 0 identically in z
    Iker = R8b.ideal([a * c1 - a1 * c, a * d1 + b * c1 - a1 * d - b1 * c,
                      b * d1 - b1 * d, a * d - b * c - 1,
                      a1 * d1 - b1 * c1 - 1])
    primes = Iker.minimal_associated_primes()
    plus = R8b.ideal([a - a1, b - b1, c - c1, d - d1, a * d - b * c - 1])
    minus = R8b.ideal([a + a1, b + b1, c + c1, d + d1, a * d - b * c - 1])
    check(len(primes) == 2 and set(primes) == {plus, minus},
          'pp. 218-219: phi(g) = phi(g\') with det 1 forces g\' = +-g')

    # Lemma 7 (p. 220): phi on L(2, R), including the maps of z^.
    R16 = PolynomialRing(QQ, 'p0,p1,p2,p3,q0,q1,q2,q3,z,zb')
    pq = R16.gens()
    zr, zbr = pq[8], pq[9]
    K16 = R16.fraction_field()
    M1 = matrix(K16, 2, 2, pq[0:4])
    M2 = matrix(K16, 2, 2, pq[4:8])

    def conj(e):
        # complex conjugation of a rational function with real coefficients
        return K16(e.numerator()(*pq[:8], zbr, zr)) / K16(
            e.denominator()(*pq[:8], zbr, zr))

    ok = True
    for s1, s2 in product((1, -1), repeat=2):
        f2 = mobius(M2, zr if s2 == 1 else zbr)
        f12 = mobius(M1, f2 if s1 == 1 else conj(f2))
        ok = ok and f12 == mobius(M1 * M2, zr if s1 * s2 == 1 else zbr)
    check(ok, 'p. 220, Lemma 7: phi is a homomorphism on L(2, R)')
    Rc = PolynomialRing(QQ, 'e,f,g,h')
    e, f_, g2, h = Rc.gens()
    Mc = matrix(Rc, [[e, f_], [g2, h]])
    eqs = []
    for X in (matrix(Rc, [[0, 1], [0, 0]]), matrix(Rc, [[0, 0], [1, 0]])):
        eqs += (Mc * X - X * Mc).list()
    Ic = Rc.ideal(eqs)
    check(Ic == Rc.ideal([f_, g2, e - h]),
          'p. 220: the centre of L(2, R) is scalar, so {E, -E} (det = +-1)')
    # Lemma 8 (p. 221): g = rotation * (alpha, beta; 0, 1/alpha)
    al, be = var('al be', domain='positive')
    tri = matrix(SR, [[al, be], [0, 1 / al]])
    gg = rot(ph) * tri
    check(zero(gg.det() - 1), 'p. 221: rotation x triangular lies in SL(2, R)')
    check(zero((rot(ph).T * gg)[1, 0]) and zero(gg[0, 0] ** 2 + gg[1, 0] ** 2
                                                 - al ** 2),
          'p. 221: alpha = |first column|, phi its angle (uniqueness)')

    # p. 224: dim SL(n) = n^2 - 1 (the gradient of det is the cofactor
    # matrix, nonzero on det = 1), n <= 4.
    ok = True
    for n in range(2, 5):
        Rn = PolynomialRing(QQ, ['x%d_%d' % (i, j) for i in range(n)
                                 for j in range(n)])
        Xn = matrix(Rn, n, n, Rn.gens())
        grad = matrix(Rn, n, n, [Xn.det().derivative(v) for v in Rn.gens()])
        ok = ok and grad.T * Xn == Xn.det() * identity_matrix(Rn, n)
    check(ok, 'p. 224: grad det = cofactors, so det = 1 is regular (n <= 4)')

    # Lemma 10 (p. 225): the path in SO(4) and SO(5).
    tt = var('tt', domain='real')
    p1, p2 = var('p1 p2', domain='real')

    def blocks(m1, m2, extra):
        out = block_matrix(SR, [[m1, zero_matrix(SR, 2, 2)],
                                [zero_matrix(SR, 2, 2), m2]],
                           subdivide=False)
        if extra:
            out = block_matrix(SR, [[out, zero_matrix(SR, 4, 1)],
                                    [zero_matrix(SR, 1, 4), 1]],
                               subdivide=False)
        return out

    ok = True
    for extra in (False, True):
        gam = blocks(rot(tt * p1), rot(tt * p2), extra)
        n = gam.nrows()
        ok = ok and mzero(gam * gam.T - identity_matrix(SR, n))
        ok = ok and zero(gam.det() - 1)
        ok = ok and mzero(gam.subs(tt=0) - identity_matrix(SR, n))
        ok = ok and mzero(gam.subs(tt=1) - blocks(rot(p1), rot(p2), extra))
    check(ok, 'p. 225 corrected: gamma(t) joins E with the canonical form '
              'inside SO(4), SO(5)')
    pr = blocks(rot(p1), rot(p2), False)
    refuted(mzero(pr.subs(p1=pi / 2) - identity_matrix(SR, 4)),
            'p. 225 printed: the family without t starts at E')
    R9 = PolynomialRing(QQ, ['a%d' % i for i in range(9)]
                        + ['b%d' % i for i in range(9)])
    A9 = matrix(R9, 3, 3, R9.gens()[:9])
    B9 = matrix(R9, 3, 3, R9.gens()[9:])
    check((A9 * B9.T).trace() == sum(A9[i, j] * B9[i, j] for i in range(3)
                                     for j in range(3)),
          'p. 225: tr A B^T = sum a_i^j b_i^j')
    refuted(len({(-identity_matrix(QQ, 3)).det(),
                 identity_matrix(QQ, 3).det()}) == 1,
            'p. 227 printed: O(n) is connected (det takes both values +-1)')

    # Lemma 11 (pp. 226-227): paths in SU(3) and U(3), l = 1.
    f1, f2 = var('f1 f2', domain='real')
    f3 = 2 * pi - f1 - f2
    a_su = matrix(SR, 3, 3, [exp(I * tt * f1), 0, 0, 0, exp(I * tt * f2), 0,
                             0, 0, exp(I * (2 * pi - tt * (f1 + f2)))])
    check(zero(a_su.det() - 1) and mzero(a_su.subs(tt=0)
                                         - identity_matrix(SR, 3))
          and mzero(a_su.subs(tt=1) - matrix(SR, 3, 3, [
              exp(I * f1), 0, 0, 0, exp(I * f2), 0, 0, 0, exp(I * f3)])),
          'p. 227 corrected: the path in SU(3) (det 1, from E to g_0)')
    a_pr = matrix(SR, 3, 3, [exp(I * f1), 0, 0, 0, exp(I * f2), 0,
                             0, 0, exp(I * (2 * pi - tt * (f1 + f2)))])
    refuted(mzero((a_pr.subs(tt=0) - identity_matrix(SR, 3)).subs(
        f1=pi / 2, f2=pi / 2)),
            'p. 227 printed: the first entries without t (gamma(0) = E)')
    a_u = matrix(SR, 3, 3, [exp(I * f1 * tt), 0, 0, 0, exp(I * f2 * tt), 0,
                            0, 0, exp(I * f3 * tt)])
    check(mzero(a_u.subs(tt=0) - identity_matrix(SR, 3))
          and mzero(a_u * a_u.conjugate().T - identity_matrix(SR, 3)),
          'p. 227 corrected: the path a(t) in U(3)')
    a_upr = matrix(SR, 3, 3, [exp(I * f1) * tt, 0, 0, 0, exp(I * f2) * tt, 0,
                              0, 0, exp(I * f3) * tt])
    refuted(mzero(a_upr.subs(tt=0) - identity_matrix(SR, 3)),
            'p. 227 printed: entries e^(i phi_k) t (a(0) = 0)')

    # Lemma 12 (p. 228).
    cc = var('cc')
    check(zero(matrix(SR, [[cc, 0], [0, 1]]).det() - cc),
          'p. 228 corrected: det maps GL(n, C) onto C \\ 0')
    refuted(abs((2 * identity_matrix(QQ, 2)).det()) == 1,
            'p. 228 printed: f(g) = det g lies in S^1')
    a_ = matrix(QQ, [[1, 0, 0], [0, 1, 0], [0, 0, -1]])
    check(a_.det() == -1, 'p. 227: g -> a g exchanges det > 0 and det < 0')

    # complex structure (pp. 229-230)
    xr, yr, cr2, dr2 = var('xr yr cr2 dr2', domain='real')
    check(zero(((xr + I * yr) * (cr2 - I * dr2)).expand()
               - (xr * cr2 + yr * dr2) - I * (yr * cr2 - xr * dr2)),
          'p. 229: (x + iy)(c - id) = (xc + yd) + i(yc - xd)')
    ok = True
    Rx = PolynomialRing(QQ, 'X')
    X = Rx.gen()
    for n in range(1, 5):
        En = identity_matrix(QQ, n)
        Zn = zero_matrix(QQ, n, n)
        Acs = block_matrix(QQ, [[Zn, -En], [En, Zn]], subdivide=False)
        ok = ok and Acs * Acs.T == identity_matrix(QQ, 2 * n)
        ok = ok and Acs ** 2 == -identity_matrix(QQ, 2 * n)
        ok = ok and Acs.det() == 1 and Acs.T == -Acs
        ok = ok and Acs.charpoly(X) == (X ** 2 + 1) ** n
    check(ok, 'p. 230: A = (0, -E; E, 0): orthogonal, A^2 = -E, eigenvalues '
              '+-i of multiplicity n, A in SO(2n) (n <= 4)')
    Rs = PolynomialRing(QQ, 's01,s02,s03,s12,s13,s23')
    s01, s02, s03, s12, s13, s23 = Rs.gens()
    Sk = matrix(Rs, [[0, s01, s02, s03], [-s01, 0, s12, s13],
                     [-s02, -s12, 0, s23], [-s03, -s13, -s23, 0]])
    check(Sk.det() == Sk.pfaffian() ** 2,
          'p. 230: det of a skew 4 x 4 matrix is Pf^2 >= 0, so an orthogonal '
          'skew matrix has det 1')
    check(mzero(rot(pi / 2) ** 2 + E2),
          'p. 230 corrected: phi_k = pi/2 + l pi')
    refuted(mzero(rot(2 * pi / 2) ** 2 + E2),
            'p. 230 printed: phi_k = 2 pi/2 + l pi gives A^2 = E')

    # Proposition 3 (p. 231): realification.
    Kg = QQ.extension(PolynomialRing(QQ, 'T').gen() ** 2 + 1, 'ii')
    ii = Kg.gen()
    ok = True
    for n in (1, 2, 3):
        Rr = PolynomialRing(Kg, ['c%d' % k for k in range(n * n)]
                            + ['b%d' % k for k in range(n * n)]
                            + ['e%d' % k for k in range(n * n)]
                            + ['f%d' % k for k in range(n * n)])
        gs = Rr.gens()
        C = matrix(Rr, n, n, gs[:n * n])
        Bm = matrix(Rr, n, n, gs[n * n:2 * n * n])
        C2 = matrix(Rr, n, n, gs[2 * n * n:3 * n * n])
        B2 = matrix(Rr, n, n, gs[3 * n * n:])

        def real(Cm, Bmm):
            return block_matrix(Rr, [[Cm, -Bmm], [Bmm, Cm]], subdivide=False)

        prodA = (C + ii * Bm) * (C2 + ii * B2)
        Cp = prodA.apply_map(lambda e: e.map_coefficients(
            lambda q: q.polynomial()[0]))
        Bp = prodA.apply_map(lambda e: e.map_coefficients(
            lambda q: q.polynomial()[1]))
        ok = ok and real(C, Bm) * real(C2, B2) == real(Cp, Bp)
        ok = ok and real(C, Bm).T == real(C.T, -Bm.T)
        ok = ok and (real(C, Bm).det()
                     == (C + ii * Bm).det() * (C - ii * Bm).det())
    check(ok, 'p. 231, Proposition 3: phi(AB) = phi(A)phi(B), phi(A^*) = '
              'phi(A)^T, det phi(A) = |det A|^2 (n <= 3)')

    # quaternions (pp. 232-235)
    H = QuaternionAlgebra(QQ, -1, -1)
    i, j, k = H.gens()
    one = H(1)
    basis = [one, i, j, k]
    printed = [[one, i, j, k], [i, -one, k, -j], [j, -k, -one, i],
               [k, j, -i, -one]]
    check(all(basis[r] * basis[c_] == printed[r][c_] for r in range(4)
              for c_ in range(4)),
          'p. 232: the multiplication table of 1, i, j, k (16 cells)')
    check(i * j != j * i, 'p. 232: the algebra is not commutative')
    Rq = PolynomialRing(QQ, ['a%d' % m for m in range(4)]
                        + ['b%d' % m for m in range(4)]).fraction_field()
    Hq = QuaternionAlgebra(Rq, -1, -1)
    iq, jq, kq = Hq.gens()
    av = Rq.gens()[:4]
    bv = Rq.gens()[4:]
    qa = av[0] + av[1] * iq + av[2] * jq + av[3] * kq
    qb = bv[0] + bv[1] * iq + bv[2] * jq + bv[3] * kq
    check(qa * qa.conjugate() == sum(x_ ** 2 for x_ in av),
          'p. 232: |q|^2 = q q^ = sum (a^i)^2')
    check((qa * qb).reduced_norm() == qa.reduced_norm() * qb.reduced_norm(),
          'p. 235: |ab| = |a| |b|')
    check((qa * qb).conjugate() == qb.conjugate() * qa.conjugate(),
          'p. 233: conj(ab) = b^ a^')
    z1 = av[0] + av[1] * iq
    z2 = av[2] + av[3] * iq
    z2b = av[2] - av[3] * iq
    check(qa == z1 + jq * z2b, 'p. 233: q = z^1 + j z^2-bar')
    check(jq * z1 == z1.conjugate() * jq, 'p. 233: j z = z^ j')

    def cpx(re, im):
        return re + im * iq

    pc, qc, cc_, dc = (cpx(av[0], av[1]), cpx(av[2], av[3]),
                       cpx(bv[0], bv[1]), cpx(bv[2], bv[3]))
    lhs = (pc + jq * qc.conjugate()) * (cc_ + jq * dc.conjugate()).conjugate()
    check((cc_ + jq * dc.conjugate()).conjugate() == cc_.conjugate() - dc * jq
          and lhs == (pc * cc_.conjugate() + qc * dc.conjugate())
          + (qc * cc_ - pc * dc) * jq,
          'p. 233: (p + j q^)(c^ - d j) = (p c^ + q d^) + (q c - p d) j')
    check(qa * qa.conjugate() * qb * qb.conjugate()
          == (qa * qb) * (qa * qb).conjugate(),
          'p. 235: q1 a^ a q2^ = |a|^2 q1 q2^')
    alc, bec = pc, qc
    pp_, qq_ = cc_, dc
    lhs = (alc + jq * bec) * (pp_ + jq * qq_.conjugate())
    check(lhs == (alc * pp_ - bec.conjugate() * qq_.conjugate())
          + (alc * qq_ + bec.conjugate() * pp_.conjugate()) * jq,
          'p. 235 corrected: (alpha + j beta)(p + j q^) = (alpha p - beta^ q^)'
          ' + (alpha q + beta^ p^) j')
    # alpha = 0, beta = i, p = 1, q = 0
    lhs0 = (H(0) + j * i) * (one + j * H(0))
    refuted(lhs0 == (H(0) * one - i * H(0)) + (H(0) * H(0) + i * one) * j,
            'p. 235 printed: (alpha p - beta q^) + (alpha q + beta p^) j')
    # the matrix in the coordinates (z1, z2) = (alpha, beta^)
    zq1, zq2 = pc, qc
    qv = zq1 + jq * zq2.conjugate()
    abar = pp_ + jq * qq_.conjugate()
    image = qv * abar
    new1 = pp_ * zq1 - qq_.conjugate() * zq2
    new2 = qq_ * zq1 + pp_.conjugate() * zq2
    check(image == new1 + jq * new2.conjugate(),
          'p. 235: the matrix (p, -q^; q, p^) of q -> q a^')
    check(pp_ * pp_.conjugate() + qq_ * qq_.conjugate()
          == pp_ * pp_.conjugate() - (-qq_.conjugate()) * qq_,
          'p. 235: det (p, -q^; q, p^) = |p|^2 + |q|^2')
    Rsu = PolynomialRing(QQ, 'sa,sb,sc,sd')
    sa, sb, sc, sd = Rsu.gens()
    Msu = matrix(Rsu, [[sa, sb], [sc, sd]])
    check(Msu.adjugate() == matrix(Rsu, [[sd, -sb], [-sc, sa]]),
          'p. 236: for det 1 the inverse (d, -b; -c, a) equals the adjoint '
          '(a^, c^; b^, d^), so d = a^, b = -c^')

    def R_of(q):
        imgs = [q * e_ * q.conjugate() for e_ in (iq, jq, kq)]
        return matrix(Rq, 3, 3, lambda r, c_: list(imgs[c_])[r + 1])

    Ra, Rb_ = R_of(qa), R_of(qb)
    na = qa.reduced_norm()
    check(Ra.T * Ra == na ** 2 * identity_matrix(Rq, 3)
          and Ra.det() == na ** 3,
          'p. 236: q -> a q a^ is orthogonal with det 1 for |a| = 1')
    check(all(list(qa * e_ * qa.conjugate())[0] == 0 for e_ in (iq, jq, kq)),
          'p. 236: a q a^ is imaginary for imaginary q')
    check(R_of(qa * qb) == Ra * Rb_, 'p. 236: f(a_1 a_2) = f(a_1) f(a_2)')
    check(Ra[0, 0] - na == -2 * (av[2] ** 2 + av[3] ** 2)
          and Ra[1, 1] - na == -2 * (av[1] ** 2 + av[3] ** 2)
          and Ra[2, 2] - na == -2 * (av[1] ** 2 + av[2] ** 2),
          'p. 236: R(a) = E with |a| = 1 forces a_1 = a_2 = a_3 = 0, a = +-1')


# ---------------------------------------------------------------------------
# Section 4. Dynamical systems.

def section_4():
    Rq = PolynomialRing(QQ, ['q%d' % m for m in range(4)]).fraction_field()
    Hq = QuaternionAlgebra(Rq, -1, -1)
    iq, jq, kq = Hq.gens()
    qs = Rq.gens()
    q = qs[0] + qs[1] * iq + qs[2] * jq + qs[3] * kq
    vecs = [q, iq * q, jq * q, kq * q]
    gram = matrix(Rq, 4, 4, lambda r, c: (vecs[r] * vecs[c].conjugate())
                  .reduced_trace() / 2)
    nq = q.reduced_norm()
    check(gram == nq * identity_matrix(Rq, 4),
          'p. 241: <iq, q> = 0 and q, iq, jq, kq are orthonormal on S^3')

    Rv = PolynomialRing(QQ, 'p1,p2,q1,q2,dt')
    p1, p2, q1, q2, dt = Rv.gens()
    Dv = matrix(Rv, [[p1, p2], [q1, q2]])
    check((identity_matrix(Rv, 2) + dt * Dv).det()
          == 1 + dt * (p1 + q2) + dt ** 2 * Dv.det(),
          'p. 243, Lemma 3: d(dm)/dt = (P_x + Q_y) dx dy')

    x, y, tt, r, th = var('x y tt r th', domain='real')
    P = -y ** 3 + x * y
    Q = x ** 3 + x ** 2
    circ = integral((P * (cos(tt)).diff(tt) + Q * (sin(tt)).diff(tt))
                    .subs(x=cos(tt), y=sin(tt)), tt, 0, 2 * pi)
    rot_ = (Q.diff(x) - P.diff(y)).subs(x=r * cos(th), y=r * sin(th)) * r
    dbl = integral(integral(rot_, th, 0, 2 * pi), r, 0, 1)
    check(zero(circ - dbl) and zero(dbl - 3 * pi / 2),
          'p. 244 corrected: the circulation is the integral of Q_x - P_y')
    rot_pr = (P.diff(y) - Q.diff(x)).subs(x=r * cos(th), y=r * sin(th)) * r
    refuted(zero(circ - integral(integral(rot_pr, th, 0, 2 * pi), r, 0, 1)),
            'p. 244 printed: the integral of P_y - Q_x')

    a0 = x ** 3 * y + y ** 2 + 2 * x
    P, Q = a0.diff(x), a0.diff(y)
    xs, ys = var('xs ys', domain='real')
    pot1 = (integral(P.subs(x=xs), xs, 0, x)
            + integral(Q.subs(x=0, y=ys), ys, 0, y))
    pot2 = (integral(Q.subs(y=ys), ys, 0, y)
            + integral(P.subs(x=xs, y=0), xs, 0, x))
    check(zero(pot1 - a0) and zero(pot2 - a0),
          'pp. 245-246: both formulas for the potential a(x, y)')
    check(zero(integral(Q.diff(x).subs(x=xs), xs, 0, x)
               - (Q - Q.subs(x=0))),
          'p. 245 corrected: int_0^x dQ/dx dx = Q(x, y) - Q(0, y)')
    refuted(zero(integral(Q.diff(y).subs(x=xs), xs, 0, x)
                 - (Q - Q.subs(x=0))),
            'p. 245 printed: int_0^x dQ/dy dx')

    a = x ** 3 - 3 * x * y ** 2
    b = 3 * x ** 2 * y - y ** 3
    P, Q = a.diff(x), a.diff(y)
    check(zero(a.diff(x, 2) + a.diff(y, 2)), 'p. 246: a is harmonic')
    check(zero(b.diff(x) + Q) and zero(b.diff(y) - P),
          'p. 247: b_x = -Q, b_y = P (b is the conjugate potential)')
    check(zero((-a).diff(x) + b.diff(y)) and zero((-a).diff(y) - b.diff(x)),
          'p. 247 corrected: the conjugate of b is -a')
    refuted(zero(a.diff(x) + b.diff(y)) and zero(a.diff(y) - b.diff(x)),
            'p. 247 printed: a is conjugate to b')
    check(zero(P * (-Q) + Q * P), 'p. 247: <v, v~> = -PQ + QP = 0')
    z = x + I * y
    f = (z ** 3).expand()
    check(zero(f.real_part() - a) and zero(f.imag_part() - b),
          'p. 247: f = a + ib = z^3')
    check(zero(3 * z ** 2 - (a.diff(x) - I * a.diff(y)))
          and zero(3 * z ** 2 - (b.diff(y) + I * b.diff(x))),
          'p. 248: f\'_z = a_x - i a_y = b_y + i b_x')
    check(zero(a.diff(x) * b.diff(x) + a.diff(y) * b.diff(y)),
          'p. 249: <grad a, grad b> = 0')
    uf = function('uf')(x, y)
    vf = function('vf')(x, y)
    gg = uf + I * vf
    check(zero((gg.diff(x) + I * gg.diff(y))
               - ((uf.diff(x) - vf.diff(y)) + I * (vf.diff(x) + uf.diff(y)))),
          'p. 248: dg/dz^ = 0 is u_x = v_y, u_y = -v_x')
    rr, fi = var('rr fi', domain='positive')
    zp = rr * exp(I * fi)
    check(zero((zp ** (-3)).real_part() - rr ** (-3) * cos(3 * fi))
          and zero((zp ** (-3)).imag_part() + rr ** (-3) * sin(3 * fi)),
          'p. 249: z^-k = r^-k (cos k phi - i sin k phi), k = 3')
    al, zv = var('al zv')
    dip = (ln(zv + al) - ln(zv - al)) / al
    lim0 = taylor(dip, al, 0, 1)
    check(zero(lim0 - 2 / zv), 'p. 250 corrected: f(z) -> 2/z as alpha -> 0')
    refuted(zero(lim0 - 1 / zv), 'p. 250 printed: f(z) -> 1/z')


# ---------------------------------------------------------------------------
# Section 5. Polygon words.

def parse(text):
    """'a b A B' -> [(a, 1), (b, 1), (a, -1), (b, -1)]; capital = inverse."""
    out = []
    for tok in text.split():
        out.append((tok.lower(), -1 if tok[0].isupper() else 1))
    return out


def invert(word):
    return [(L, -e) for (L, e) in reversed(word)]


def surface(word):
    """(Euler characteristic, orientable) of the closed surface of a polygon
    whose boundary word has every letter exactly twice."""
    m = len(word)
    parent = list(range(m))

    def find(p):
        while parent[p] != p:
            parent[p] = parent[parent[p]]
            p = parent[p]
        return p

    occ = {}
    for pos, (L, e) in enumerate(word):
        tail, head = (pos, (pos + 1) % m) if e == 1 else ((pos + 1) % m, pos)
        occ.setdefault(L, []).append((tail, head, e))
    for L, lst in occ.items():
        assert len(lst) == 2, 'letter %s does not occur twice' % L
        (t1, h1, _), (t2, h2, _) = lst
        parent[find(t1)] = find(t2)
        parent[find(h1)] = find(h2)
    V = len({find(p) for p in range(m)})
    chi = V - len(occ) + 1
    orientable = all(lst[0][2] != lst[1][2] for lst in occ.values())
    return chi, orientable


def random_segments(rng, nseg, letters):
    occ = []
    for L in letters:
        occ += [(L, rng.choice((1, -1))), (L, rng.choice((1, -1)))]
    rng.shuffle(occ)
    cuts = sorted(rng.randint(0, len(occ)) for _ in range(nseg - 1))
    cuts = [0] + cuts + [len(occ)]
    return [occ[cuts[q]:cuts[q + 1]] for q in range(nseg)]


def section_5():
    # The Klein bottle group (p. 260); (eps, m, n) is the map
    # (x, y) -> (eps x + m, y + n)
    def act(g, p):
        return (g[0] * p[0] + g[1], p[1] + g[2])

    def comp(g1, g2):
        return (g1[0] * g2[0], g1[0] * g2[1] + g1[1], g1[2] + g2[2])

    def inv(g):
        return (g[0], -g[0] * g[1], -g[2])

    a = (-1, 1, 1)                     # a(x, y) = (1 - x, y + 1)
    b = (1, 1, 0)                      # corrected b(x, y) = (x + 1, y)
    xg, yg = var('xg yg')
    check(act(a, (xg, yg)) == (1 - xg, yg + 1)
          and act(b, (xg, yg)) == (xg + 1, yg),
          'p. 260: the generators a and (corrected) b')
    check(comp(comp(a, b), inv(a)) == inv(b),
          'p. 260: the relation a b a^-1 = b^-1 of the Klein bottle group')
    gens = [a, inv(a), b, inv(b)]
    words = [(1, 0, 0)]
    frontier = [(1, 0, 0)]
    for _ in range(8):
        frontier = [comp(g, h) for g in frontier for h in gens]
        words += frontier
    ok = all(g[0] == (-1) ** (g[2] % 2) for g in words)
    ok = ok and all(g == (1, 0, 0) or g[2] != 0 or g[1] != 0 for g in words)
    check(ok, 'p. 260: every word of length <= 8 is (eps x + m, y + n) with '
              'eps = (-1)^n and acts without fixed points unless trivial')
    # printed b(x, y) = (x, y + 1): a b^-1 is (x, y) -> (1 - x, y)
    bp = (1, 0, 1)
    ab = comp(a, inv(bp))
    refuted(ab[2] != 0 or ab == (1, 0, 0) or ab[0] == 1,
            'p. 260 printed: b(x, y) = (x, y + 1), the action is free '
            '(a b^-1 fixes the line x = 1/2)')
    check(act(ab, (QQ(1) / 2, yg)) == (QQ(1) / 2, yg),
          'p. 260 printed: a b^-1 fixes (1/2, y)')

    check(surface(parse('a A')) == (2, True), 'p. 274: a a^-1 is the sphere')
    check(surface(parse('a b A B')) == (0, True), 'p. 259: the torus')
    check(surface(parse('a b a B')) == (0, False),
          'p. 260: the Klein bottle (Fig. 88)')
    check(surface(parse('a b a b')) == (1, False),
          'p. 260: the projective plane (Fig. 89)')
    check(surface(parse('a b A B c d C D')) == (-2, True),
          'p. 263: the pretzel W = a b a^-1 b^-1 c d c^-1 d^-1, genus 2')
    check(surface(parse('a1 a2 A1 A2 a3 a4 A3 A4 a5 a5')) == (-3, False)
          == surface(parse(' '.join('c%d c%d' % (q, q) for q in range(5)))),
          'p. 271, Fig. 105: S^2 + 2r + mu = S^2 + 5 mu')

    def commutators(g, tag='x'):
        return ' '.join('%s%d %s%d %s%d %s%d' % (tag, q, tag + 'y', q,
                                                 tag.upper(), q,
                                                 (tag + 'y').upper(), q)
                        for q in range(g))

    def squares(k, tag='c'):
        return ' '.join('%s%d %s%d' % (tag, q, tag, q) for q in range(k))

    check(all(surface(parse(commutators(g))) == (2 - 2 * g, True)
              for g in range(1, 7)),
          'p. 275, Lemma 10, 2): genus g, chi = 2 - 2g (g <= 6)')
    check(all(surface(parse(squares(k))) == (2 - k, False)
              for k in range(1, 9)),
          'p. 275, Lemma 10, 3): k squares, chi = 2 - k (k <= 8)')
    check(all(surface(parse(commutators(kk) + ' ' + squares(ss)))
              == surface(parse(squares(2 * kk + ss)))
              for kk in range(0, 5) for ss in range(1, 5)),
          'p. 268: S^2 + k r + s mu = S^2 + (2k + s) mu (k <= 4, 1 <= s <= 4)')

    def thm3(N, eps):
        w = ['a%d' % q for q in range(1, N + 1)]
        w += ['A%d' % q for q in range(1, N)]
        w += ['A%d' % N if eps == -1 else 'a%d' % N]
        return parse(' '.join(w))

    check(all(surface(thm3(N, -1)) == (2 - N if N % 2 == 0 else 3 - N, True)
              for N in range(1, 11)),
          'p. 275, Theorem 3, eps = -1: orientable, chi = 2 - N (N even), '
          '3 - N (N odd), N <= 10')
    check(all(surface(thm3(N, 1)) == (2 - N, False) for N in range(1, 11)),
          'p. 275, Theorem 3, eps = +1: non-orientable, chi = 2 - N')
    refuted(all(N % 2 == 0 for N in range(1, 11)
                if surface(thm3(N, -1))[1]),
            'p. 275 printed: orientable (eps = -1) forces N even '
            '(N = 1 is the sphere, N = 3 the torus)')
    check(13 - 24 * 3 // 2 + 24 == 1,
          'p. 269: 13 vertices, 36 edges, 24 triangles give chi(RP^2) = 1')

    rng = random.Random(20261126)
    ok5 = ok6 = ok7 = ok9 = True
    for _ in range(300):
        letters = ['l%d' % q for q in range(rng.randint(1, 6))]
        A_, B_ = random_segments(rng, 2, letters)
        ok5 = ok5 and (surface(A_ + [('s', 1), ('s', -1)] + B_)
                       == surface(A_ + B_))
        letters = ['l%d' % q for q in range(rng.randint(0, 6))]
        A_, B_, C_ = random_segments(rng, 3, letters)
        a1, = parse('a')
        ok6 = ok6 and (surface(B_ + [a1] + A_ + [a1] + C_)
                       == surface(B_ + invert(A_) + [a1, a1] + C_))
        A_, R_, P_, Q_, B_ = random_segments(rng, 5, letters)
        aa, bb, AA, BB = parse('a b A B')
        ok7 = ok7 and (surface(A_ + [aa] + R_ + [bb] + P_ + [AA] + Q_ + [BB]
                               + B_)
                       == surface(A_ + Q_ + P_ + [aa, bb, AA, BB] + R_ + B_))
        A_, B_, Q_ = random_segments(rng, 3, letters)
        cc, dd, DD = parse('c d D')
        ok9 = ok9 and (surface(A_ + [aa, bb, AA, BB] + B_ + [cc, cc] + Q_)
                       == surface(A_ + [aa, bb, DD] + invert(B_)
                                  + [bb, aa, DD] + Q_))
    check(ok5, 'p. 272, Lemma 5: cancelling a a^-1 keeps (chi, orientability)'
               ' (300 random words)')
    check(ok6, 'p. 272, Lemma 6: B a A a C -> B A^-1 a a C (300 random words)')
    check(ok7, 'p. 272, Lemma 7: A a R b P a^-1 Q b^-1 B -> '
               'A Q P a b a^-1 b^-1 R B (300 random words)')
    check(ok9, 'p. 274, Lemma 9: W~ = A a b d^-1 B^-1 b a d^-1 Q has the '
               'invariants of W (300 random words)')


# ---------------------------------------------------------------------------
# Section 6. Riemann surfaces.

def section_6():
    Kg = QQ.extension(PolynomialRing(QQ, 'T').gen() ** 2 + 1, 'ii')
    ii = Kg.gen()
    Rxy = PolynomialRing(Kg, 'x,y,z,zb')
    x, y, z, zb = Rxy.gens()
    to_xy = {z: x + ii * y, zb: x - ii * y}
    to_z = {x: (z + zb) / 2, y: -ii * (z - zb) / 2}
    ok = True
    for g in (x ** 3 - 2 * x * y + y ** 2 + 5 * x * y ** 2,
              x ** 4 + 3 * y ** 3 - x * y + 7):
        Gz = g.subs(to_z)
        ok = ok and g.derivative(x) == (Gz.derivative(z)
                                        + Gz.derivative(zb)).subs(to_xy)
        ok = ok and g.derivative(y) == (ii * (Gz.derivative(z)
                                              - Gz.derivative(zb))).subs(to_xy)
        ok = ok and (g.derivative(x, 2) + g.derivative(y, 2)
                     == (4 * Gz.derivative(z).derivative(zb)).subs(to_xy))
    check(ok, 'pp. 276-277: d/dx = d/dz + d/dz^, d/dy = i(d/dz - d/dz^), '
              'Laplacian = 4 d^2/dz dz^')
    xr, yr = var('xr yr', domain='real')
    u = xr ** 2 - yr ** 2
    v = 2 * xr * yr
    check(zero(u.diff(xr) - v.diff(yr)) and zero(v.diff(xr) + u.diff(yr)),
          'p. 277 corrected: u_x - v_y = 0, v_x + u_y = 0 for f = z^2')
    refuted(zero(u.diff(xr) - u.diff(yr)),
            'p. 277 printed: u_x - u_y = 0 for f = z^2')
    check(zero(u.diff(xr, 2) + u.diff(yr, 2)),
          'p. 277 corrected: u_xx + u_yy = 0')
    refuted(zero(u.diff(xr, 2) + v.diff(yr, 2)),
            'p. 277 printed: u_xx + v_yy = 0')

    # Theorem 1 (p. 279): at (z0, 0) the surface is a graph z = phi(w).
    Rzw = PolynomialRing(QQ, 'z,w,e')
    zz, ww, ee = Rzw.gens()
    fz = ww ** 2 - zz
    check(fz.derivative(ww)(0, 0, 0) == 0 and fz.derivative(zz)(0, 0, 0) != 0
          and fz(ww ** 2, ww, 0) == 0,
          'p. 279 corrected: f = w^2 - z is the graph z = w^2 near (0, 0)')
    refuted(fz(ee ** 2, ee, 0) != 0 or fz(ee ** 2, -ee, 0) != 0,
            'p. 279 printed: a graph w = g(z) near (0, 0) (the points '
            '(e^2, e), (e^2, -e) lie on it for every e)')

    # Theorem 2 (pp. 286-287) at (infinity_z, infinity_w), u = 1/z, v = 1/w.
    for n in range(1, 13):
        Ra = PolynomialRing(QQ, ['a%d' % q for q in range(1, n + 1)]
                            + ['u', 'v', 'W'])
        gs = Ra.gens()
        avs, uu, vv, WW = gs[:n], gs[n], gs[n + 1], gs[n + 2]
        h = prod(1 - aq * uu for aq in avs)
        F = vv ** 2 * h - uu ** n
        # the substitution itself (p. 287)
        Kf = Ra.fraction_field()
        lhs = (1 / Kf(vv) ** 2 - prod(1 / Kf(uu) - aq for aq in avs))
        check(lhs * Kf(uu) ** n * Kf(vv) ** 2 == -Kf(F),
              'p. 287: w^2 = prod(z - a_k) becomes v^2 = u^n/prod(1 - a_k u)'
              ' (n = %d)' % n)
        at0 = {uu: 0, vv: 0}
        gu, gv = F.derivative(uu).subs(at0), F.derivative(vv).subs(at0)
        if n == 1:
            check(gu == -1 and gv == 0,
                  'p. 287: n = 1, the closure is smooth at infinity')
        else:
            check(gu == 0 and gv == 0,
                  'p. 287: n = %d, the closure is singular at infinity' % n)
        if n % 2 == 0:
            m = n // 2
            check(F.subs({vv: uu ** m * WW}) == uu ** n * (WW ** 2 * h - 1),
                  'p. 287: n = %d even, v = u^(n/2) w blows up to '
                  'w^2 prod(1 - a_k u) = 1: two smooth branches w = +-1' % n)
        else:
            m = (n - 1) // 2
            check(F.subs({vv: uu ** m * WW}) == uu ** (n - 1)
                  * (WW ** 2 * h - uu),
                  'p. 287: n = %d odd, v = u^((n-1)/2) w blows up to '
                  'w^2 prod(1 - a_k u) = u: one smooth branch' % n)
        if n >= 2:
            low = F.homogeneous_components()[2]
            want = vv ** 2 - uu ** 2 if n == 2 else vv ** 2
            check(min(F.homogeneous_components()) == 2 and low == want,
                  'p. 287: n = %d, multiplicity 2, tangent cone %s'
                  % (n, want))
            check(F.subs({vv: -vv}) == F,
                  'p. 287: n = %d, v -> -v: two points over each u != 0' % n)
    # f~(t, u) = t - u^n/prod(1 - a_k u): the gradient at 0 (p. 287)
    for n in (1, 2, 3):
        Ra = PolynomialRing(QQ, ['a%d' % q for q in range(1, n + 1)]
                            + ['t', 'u'])
        gs = Ra.gens()
        tt, uu = gs[n], gs[n + 1]
        Kf = Ra.fraction_field()
        ft = Kf(tt) - Kf(uu) ** n / prod(1 - aq * Kf(uu) for aq in gs[:n])
        grad = tuple(Kf(ft.derivative(var_)).subs({tt: 0, uu: 0})
                     for var_ in (tt, uu))
        if n == 1:
            check(grad == (1, -1),
                  'p. 287 corrected: grad f~ = (1, -1), n = 1')
            refuted(grad == (1, 1), 'p. 287 printed: grad f~ = (1, 1), n = 1')
        else:
            check(grad == (1, 0), 'p. 287: grad f~ = (1, 0), n = %d' % n)
    # the odd branch: on the strict transform w^2 h(u) = u put w = s; then
    # u(s) solves u = s^2 h(u) (a power series, by iteration) and
    # v(s) = u(s)^((n-1)/2) s.  For n >= 3 both derivatives vanish at s = 0:
    # the parametrization is not an immersion.
    for n in (3, 5, 7):
        Ra = PolynomialRing(QQ, ['a%d' % q for q in range(1, n + 1)])
        PS = PowerSeriesRing(Ra, 's', default_prec=n + 2)
        s = PS.gen()
        uS = PS(0)
        for _ in range(n + 2):
            uS = (s ** 2 * prod(1 - aq * uS for aq in Ra.gens())).add_bigoh(
                n + 2)
        vS = uS ** ((n - 1) // 2) * s
        hS = prod(1 - aq * uS for aq in Ra.gens())
        check((vS ** 2 * hS - uS ** n).add_bigoh(n + 2) == PS(0).add_bigoh(
            n + 2) and uS.valuation() == 2 and vS.valuation() == n,
              'p. 294: n = %d, the branch at infinity is (u, v) = (s^2 + ..., '
              's^n + ...), not immersed: "embedding" only topologically' % n)
    # pp. 288-289: the closure in CP^2 for a_k = 1, ..., n.
    P2 = ProjectiveSpace(QQ, 2, 'X,Y,Z')
    X, Y, Z = P2.gens()
    for n in range(1, 9):
        if n <= 2:
            Fh = Y ** 2 - (prod(X - q * Z for q in range(1, n + 1))
                           * Z ** (2 - n))
        else:
            Fh = Y ** 2 * Z ** (n - 2) - prod(X - q * Z
                                              for q in range(1, n + 1))
        C = Curve(Fh)
        sing = C.singular_points()
        if n <= 3:
            check(Fh.is_homogeneous() and sing == [],
                  'pp. 288-289: n = %d, the closure in CP^2 is smooth' % n)
        else:
            check(Fh.is_homogeneous()
                  and [tuple(p) for p in sing] == [(0, 1, 0)],
                  'p. 288: n = %d, the closure in CP^2 is singular at '
                  '(0 : 1 : 0)' % n)
            check(C.arithmetic_genus() == (n - 1) * (n - 2) // 2
                  and C.genus() == (n - 1) // 2,
                  'p. 288: n = %d, (n-1)(n-2)/2 > [(n-1)/2]: not smooth' % n)
    Rq_ = PolynomialRing(QQ, 'a1,a2,a3,u,v')
    a1, a2, a3, uu, vv = Rq_.gens()
    q3 = vv - (uu - a1 * vv) * (uu - a2 * vv) * (uu - a3 * vv)
    check((q3.derivative(uu).subs({uu: 0, vv: 0}),
           q3.derivative(vv).subs({uu: 0, vv: 0})) == (0, 1),
          'p. 288: n = 3, q = v - prod(u - a_k v) has gradient (0, 1) at 0')
    refuted(q3.derivative(vv).subs({uu: 0, vv: 0}) == 0,
            'p. 288 printed: for n > 2 the gradient of q at (0, 0) is zero')
    Rh = PolynomialRing(QQ, 'a1,a2,X1,X2,X3')
    a1, a2, X1, X2, X3 = Rh.gens()
    Kh = Rh.fraction_field()
    hom = X2 ** 2 - (X1 - a1 * X3) * (X1 - a2 * X3)
    check(Kh(hom) == Kh(X3) ** 2 * ((Kh(X2) / Kh(X3)) ** 2
                                    - (Kh(X1) / Kh(X3) - a1)
                                    * (Kh(X1) / Kh(X3) - a2)),
          'p. 289: n = 2 in homogeneous coordinates')
    Rab = PolynomialRing(QQ, 'a1,a2,al,be')
    a1, a2, al, be = Rab.gens()
    q2 = al ** 2 - (1 - a1 * be) * (1 - a2 * be)
    check(all(q2(a1, a2, sg, 0) == 0
              and (q2.derivative(al)(a1, a2, sg, 0),
                   q2.derivative(be)(a1, a2, sg, 0)) == (2 * sg, a1 + a2)
              for sg in (1, -1)),
          'p. 289 corrected: grad at T_1,2 is (+-2, a_1 + a_2)')
    Rn1 = PolynomialRing(QQ, 'X1,X2,X3,al,be')
    X1, X2, X3, al, be = Rn1.gens()
    check((X2 ** 2 - X1 * X3).subs({X1: 1, X2: al, X3: be}) == al ** 2 - be,
          'p. 289: n = 1, alpha^2 - beta = 0 in the chart A_1')

    # Proposition 2 (pp. 289-291).
    for n in range(1, 7):
        Ra = PolynomialRing(QQ, ['a%d' % q for q in range(1, n + 1)] + ['u'])
        Kf = Ra.fraction_field()
        gs = Kf.gens()
        uu = gs[n]
        check(prod(1 / uu - aq for aq in gs[:n])
              == prod(1 - aq * uu for aq in gs[:n]) / uu ** n,
              'p. 291: prod(1/u - a_k) = u^-n prod(1 - a_k u), n = %d' % n)
    Ku = PolynomialRing(QQ, 'u').fraction_field()
    uq = Ku.gen()
    refuted(prod(1 / uq - aq for aq in (1, 2))
            == 1 / (uq ** 2 * prod(1 - aq * uq for aq in (1, 2))),
            'p. 291 printed: the product under the fraction bar')
    # Theorem 3 (p. 294): the genus.
    ok = True
    for n in range(1, 41):
        branch = n + (n % 2)            # the roots, and infinity for odd n
        chi = 2 * 2 - branch            # two sheets over S^2
        ok = ok and (2 - chi) // 2 == (n - 1) // 2 and (2 - chi) % 2 == 0
    check(ok, 'p. 294, Theorem 3: Riemann-Hurwitz gives g = [(n - 1)/2], '
              'n <= 40')
    Fx = FunctionField(QQ, 'x')
    xf = Fx.gen()
    Ry = PolynomialRing(Fx, 'y')
    yv = Ry.gen()
    check(all(Fx.extension(yv ** 2 - prod(xf - q for q in range(1, n + 1)),
                           'yy').genus() == (n - 1) // 2
              for n in range(1, 11)),
          'p. 294: y^2 = prod_(k <= n)(x - k) has genus [(n - 1)/2], n <= 10')

    # p. 298.
    g = (xr + I * yr) ** 3
    ug, vg = g.expand().real_part(), g.expand().imag_part()
    check(zero(3 * (xr + I * yr) ** 2 - (ug.diff(xr) + I * vg.diff(xr)))
          and zero(3 * (xr + I * yr) ** 2 - (vg.diff(yr) + I * vg.diff(xr))),
          'p. 298: dg/dz = u_x + i v_x = v_y + i v_x (g = z^3)')
    check(zero((3 * (xr + I * yr) ** 2 * 3 * (xr - I * yr) ** 2).expand()
               - (ug.diff(xr) ** 2 + vg.diff(xr) ** 2)),
          'p. 298: |g\'|^2 = u_x^2 + v_x^2')
    Rp = PolynomialRing(QQ, 'z,w')
    zp, wp = Rp.gens()
    fp = wp ** 2 - (zp - 1) * (zp - 2) * (zp - 3)
    Ip = Rp.ideal([fp, fp.derivative(wp)])
    check(Ip == Rp.ideal([wp, (zp - 1) * (zp - 2) * (zp - 3)]),
          'p. 298 corrected: z is not a local coordinate exactly over the '
          'branch points z = 1, 2, 3')
    refuted(fp.derivative(wp).subs({wp: 0}) == 0 and fp.subs({zp: 0, wp: 0})
            == 0,
            'p. 298 printed: the exceptional point is z = 0')


def main():
    section_1()
    section_2()
    section_3()
    section_4()
    section_5()
    section_6()
    print('ok chapter-4: %d checks' % COUNT[0])


if __name__ == '__main__':
    main()
