"""Exact checks of Chapter 5 "Tensor analysis and Riemannian geometry" (Sage).

Run: sage -python checks/sage/chapter-5.py (plain asserts; do not use -O).
The last line of the output is "ok chapter-5: N checks".

Book: A. S. Mishchenko, A. T. Fomenko, Kurs differentsial'noi geometrii i
topologii, 2nd ed., Faktorial Press, Moscow, 2000, Chapter 5 (pp. 300-371).
Pages are the printed pages.  The expected values are the book's: formulas
written below as literals read off the printed page; our Typst source is not
parsed.  Where the book is wrong, the printed reading is kept as a refuted
check (function `refuted`: the printed reading must fail) next to the
corrected one.  Symbolic checks use polynomial and rational function rings
over QQ, Sage's exterior algebra over such rings, or the symbolic ring with
arbitrary functions; hyperbolic functions are written through exp.  No
floating point is used for equalities or signs.

Conventions of the book used throughout: J = (dx^i'/dx^i) (p. 300); the
form T_(i_1...i_k) dx^i_1 ^ ... ^ dx^i_k is summed over i_1 < ... < i_k and
its value on vectors is sum over all indices of T_(i_1...i_k) a_1^i_1 ...
a_k^i_k (p. 318), i.e. dx^1 ^ ... ^ dx^n (a_1, ..., a_n) = det A (p. 319);
the alternation T_[...] carries 1/q! (p. 314); nabla_k T^i = dT^i/dx^k +
T^a G^i_(a k) (p. 333); R^i_(q, kl) = dG^i_(ql)/dx^k - dG^i_(qk)/dx^l
+ G^p_(ql) G^i_(pk) - G^p_(qk) G^i_(pl), R_(iq, kl) = g_(ia) R^a_(q, kl)
(pp. 362, 364), R(X, Y)Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z
- nabla_[X, Y] Z (p. 363).

What is checked, by section:

Section 1 (content/05-01-tensor-fields.typ, pp. 300-306)
  * the laws a' = J a, xi' = (J^-1)^T xi and the invariance of a^i xi_i
    (pp. 300-302), C' = J C J^-1 (p. 302), for a generic 3 x 3 matrix J;
  * p. 303: the printed index law b_(i'j') = dx^i/dx^i' dx^j/dx^j' b_ij is
    B' = (J^-1)^T B J^-1 (the printed matrix form B' = J B J^T refuted), and
    b^(i'j') = dx^i'/dx^i dx^j'/dx^j b^ij is B' = J B J^T (the printed
    (J^-1)^T B J^-1 refuted); B(a, b) is invariant.

Section 2 (content/05-02-tensor-examples.typ, pp. 307-327)
  * p. 307: the inertia sum a^ij l^i l^j = sum m (|x|^2 - <x, l>^2) for
    |l| = 1 and its invariance under a rational orthogonal matrix;
  * pp. 308-309: the strain identities with the sum over all i, k (the
    printed sum over i < k refuted); p. 311: spur eta = 2 div v;
  * p. 312: A^T (M - M^T) A = B C - C B for M = A C A^-1, C = C^T, B = A^T A;
  * p. 315: <a, Tb> = T_ik a^i b^k with T_ik = g_ij T^j_k and <Ta, b> =
    T_ki a^i b^k with T_ki = g_jk T^j_i (generic 2 x 2);
  * p. 315, Lemma 2: the essential component is multiplied by
    det(dx/dx') = (det J)^-1 (n = 2, 3; the printed det J refuted);
  * p. 316, formula (1): for (k, q, n) = (1, 1, 2), (1, 2, 3), (2, 1, 3),
    (2, 2, 4), (1, 3, 4) the right member 1/(k! q!) sum_sigma gives the
    product of the exterior algebra; the middle member T_[...P...] (with the
    1/(k+q)! of p. 314) is refuted, ((k+q)!/(k! q!)) T_[...P...] confirmed;
    the same for the product of forms on p. 318;
  * p. 317 (remark): sum over all i of A dx^i_1 ^ ... equals
    k! A_[...] dx... (i_1 < ... < i_k) for generic A, (k, n) = (2, 3), (3, 3),
    (2, 4), (3, 4); the printed reading without k! refuted;
  * p. 318 (value of a form), p. 319 (Lemma 5), p. 325: with the bracket of
    p. 314 the middle members need the factor k! (n!); printed readings
    refuted, corrected confirmed (k = 2, 3; n = 2, 3, 4); dx^1 ^ ... ^ dx^n
    built from formula (1) (right member) has value det A, built from the
    printed middle member det A / n!;
  * p. 322: for polar coordinates x = (r, phi) and Cartesian y, J =
    (dy^i/dx^j) maps e_j to a_j, g(x) = J^T J (the printed J J^T refuted),
    g = det(J)^2; p. 323: |[r_u, r_v]|^2 = EG - F^2; p. 324: the metric of a
    graph has det 1 + sum f_i^2 (n - 1 = 2, ..., 5);
  * pp. 325-327 (Theorem 1): for a generic skew matrix, omega^n =
    n! Pf(omega) dx^1 ^ ... ^ dx^2n (n = 1, 2, 3) and Pf^2 = det (n <= 4); in
    the canonical block form omega^n / n! = dy^1 ^ ... ^ dy^2n; the pulled-back
    matrix is J^T A(y) J (printed J A(y) J^T refuted) and Omega(x) =
    det J dx; with Omega = omega^n / n! the coefficient f is Pf, f^2 = det;
    the printed f = sqrt(det) refuted (omega = -dx^1 ^ dx^2); the example
    n = 2 (p. 327): omega ^ omega = 2 w12 w34 dx^1...dx^4 (the printed
    "omega ^ omega = 1/2! (2 w12 w34 ...)" refuted), det = (w12 w34)^2, and
    w12 w34 = -sqrt(det) for w12 = 1, w34 = -1.

Section 3 (content/05-03-connections.typ, pp. 327-339)
  * p. 327: the extra term S of the derivative of a covector field is nonzero
    for polar coordinates; p. 328: the naive divergence changes by the
    printed R(T, x, x') = -cos(phi)/r for T = d/dx^1 (nonzero); Assertion 2
    (p. 338) gives 0;
  * pp. 329-331: Euclidean plane, polar coordinates: G^i'_(j'k') =
    dx^i'/dx^i d^2x^i/dx^j' dx^k' equals the Christoffel symbols of
    dr^2 + r^2 dphi^2 (Theorem 3); Lemma 1 (tilde G = -G); the corrected
    explicit formula of p. 331 (printed free indices refuted);
  * Theorem 1 (p. 330): the transformation law of G under the change
    theta = u, phi = v + u^2 of the sphere metric;
  * Theorem 3 (p. 336) for an arbitrary 2-dimensional metric (functions E,
    F, G): symmetry, nabla g = 0, the combination of the three identities;
    the printed solved formula with dg_jk/dx^alpha refuted (g = (1, y; y, 2));
  * p. 337: at a critical point of f the graph metric has dg = 0, G = 0
    (generic jets, n - 1 = 2, 3);
  * Assertion 2 (p. 338): G^i_(a i) = d ln sqrt(g)/dx^a and the divergence
    formula for an arbitrary 2-dimensional metric; d det/dt = sum Delta_ip
    dg_ip/dt for an arbitrary 3 x 3 matrix of functions.

Section 4 (content/05-04-parallel-transport.typ, pp. 339-359)
  * Theorem 1 (p. 343): d<T, R>/dt = <DT/dt, R> + <T, DR/dt> on the sphere
    for arbitrary curves and fields;
  * the cone (p. 346): its metric d rho^2 + sin^2(theta/2) rho^2 dpsi^2, the
    parallel field along rho = r turning by 2 pi sin(theta/2), i.e. by
    -2 pi (1 - sin(theta/2)) modulo 2 pi;
  * the sphere (p. 348): G^1_22 = -sin(2 theta)/2, G^2_12 = ctg theta, the
    geodesic equations with 2 ctg theta (the printed factor 1 refuted), the
    meridian, a great circle in the plane z = y;
  * the Lobachevsky plane (p. 349): the same with sh, ch (printed factor 1
    refuted); r = th(chi/2) turns d chi^2 + sh^2 chi dphi^2 into
    4 (dr^2 + r^2 dphi^2)/(1 - r^2)^2 (curvature -1) and the Cayley map is an
    isometry onto (dx^2 + dy^2)/y^2; the printed (1 - r^2)^-2 (...) has
    curvature -4 (refuted); z -> -z/(z - a), a > 0, maps the circle
    |z - a/2| = a/2 to the imaginary axis and is an isometry;
  * the half-plane (p. 351): G^1_12 = -1/y, G^2_11 = 1/y, G^2_22 = -1/y (the
    printed signs refuted), the geodesic equations, y'' = -(1 + y'^2)/y and
    its circles (pp. 351-352);
  * the torus (p. 352): the embedding (e^(i phi), e^(i psi)) induces
    dphi^2 + dpsi^2;
  * Theorem 2 (p. 355): the Lie algebras so(3), sl(2, R), e(2) have
    dimension 3; n + n(n - 1)/2 = n(n + 1)/2;
  * Lemma 4 (pp. 357-358) in the Euclidean model: exp_P(a) = gamma_a(|a|)
    with the natural parameter is P + a, the Jacobi matrix of F(x, t) =
    (x, x + t) is (E 0; E E) (printed (E E; 0 E) refuted as the Jacobi matrix
    of ch. 1, its transpose), the printed exp_P(a) = gamma_a(1) is not
    injective (refuted).

Section 5 (content/05-05-curvature.typ, pp. 359-371)
  * p. 362 for an arbitrary symmetric connection in dimension 2:
    the printed expansion of nabla_k nabla_l T^i, the corrected bracket
    (printed last term refuted for a nonsymmetric connection) and
    (nabla_k nabla_l - nabla_l nabla_k) T^i = R^i_(q, kl) T^q;
  * Theorem 1 (pp. 363-364): [fX, Y] = f[X, Y] - (Yf) X, the f-linearity of
    R in each argument and [R(X, Y)Z]^i = R^i_(q, kl) X^k Y^l Z^q for
    arbitrary fields and an arbitrary symmetric connection in dimension 2;
  * Theorem 2 (p. 364), the Ricci symmetry (p. 366) and Theorem 3
    (p. 367): for metrics with g(0) = E and generic first and second
    derivatives at 0 (dimensions 3 and 4), the four symmetries of R, the
    corrected cyclic identity, R_jl = R_lj and the formula of Theorem 3 at 0;
    Theorem 3 also for an arbitrary 2-dimensional metric (E, F, G);
  * Theorem 4 (pp. 368-369): the printed chain for z = f(x, y) (an identity
    for every f), R_(12,12) = f_xx f_yy - f_xy^2 at a critical point
    (generic jets), R = (2/g) R_(12,12) for an arbitrary 2-dimensional metric
    and R = 2K for a graph at every point;
  * the examples of p. 369: dr^2 + sin^2(r/r0) dphi^2 has R = 2/r0^2,
    dr^2 + sh^2(r/r0) dphi^2 has R = -2/r0^2 (the printed (sh^2)^2 gives a
    nonconstant R: refuted), lambda (dx^2 + dy^2) has R = -Delta ln lambda /
    lambda for every lambda;
  * p. 370: the number of essential components is n^2 (n^2 - 1)/12 (rank of
    the symmetry system, n = 2, ..., 5, and of the curvature tensors realized
    by metric jets, n = 3); for n = 3 the six printed components are
    coordinates;
  * pp. 370-371, the curvature in a two-dimensional direction: with the
    book's sign of R, <R(X, Y)Y; X> = R_(bj, kl) X^b Y^j X^k Y^l = K for the
    sphere of radius r0 (1/r0^2), the Lobachevsky plane (-1) and the unit
    3-sphere (|X|^2 |Y|^2 - <X, Y>^2 for all X, Y); the printed
    <R(X, Y)X; Y> and R_(bj, kl) X^j X^k Y^l Y^b give -K (refuted); Lemma 4:
    with only R_(12,12) the corrected sum is R_(12,12) (X^1 Y^2 - X^2 Y^1)^2
    and equals the printed four-term line, the printed one is its negative,
    the printed first line of p. 371 (X^b X^l) vanishes identically.

What these checks do NOT establish.  An identity in a polynomial or rational
function ring, or in the symbolic ring with arbitrary functions, holds for
all values of the written variables, but only in the stated dimension; the
checks for 2- and 3-dimensional metrics, connections and forms of the
listed degrees do not prove the general statements of the book for all n.
The pointwise identities for metric jets use g(0) = E: this is reached by a
linear change of coordinates, under which both sides transform as tensors
(an argument, not part of the computation).  The concrete coordinate
systems, curves and metrics are examples.  Topological and analytic
statements (existence and uniqueness for ODE, completeness, triangulation,
dim Iso = 3) are not checked.  Nothing here compares our text with the
printed book.
"""
from itertools import combinations, permutations, product

from sage.all import (
    QQ, SR, ExteriorAlgebra, I, PolynomialRing, acos, atan, block_matrix, cos,
    diff, exp,
    factorial, function, identity_matrix, ln, matrix, pi, sin, sqrt, tan,
    var, vector,
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
    """Exact zero test when the variables are positive (radicals)."""
    return bool(SR(e).canonicalize_radical().simplify_full() == 0)


def zero_exp(e):
    """Exact zero test for expressions polynomial in arbitrary functions and
    their derivatives (expansion is canonical there)."""
    return bool(SR(e).expand() == 0)


def mzero(M, test=zero):
    return all(test(e) for e in M.list())


def sh(u):
    return (exp(u) - exp(-u)) / 2


def ch(u):
    return (exp(u) + exp(-u)) / 2


def perm_sign(p):
    inv = sum(1 for i in range(len(p)) for j in range(i + 1, len(p))
              if p[i] > p[j])
    return -1 if inv % 2 else 1


# ---------------------------------------------------------------------------
# Riemannian helpers in the symbolic ring (book's conventions).


def christoffel(g, X):
    """G[i][j][k] = G^i_(jk) by the formula of Theorem 3 (p. 336)."""
    n = len(X)
    gi = g.inverse()
    return [[[sum(gi[i, a] * (diff(g[k, a], X[j]) + diff(g[j, a], X[k])
                              - diff(g[j, k], X[a])) for a in range(n)) / 2
              for k in range(n)] for j in range(n)] for i in range(n)]


def riemann_up(G, X):
    """R[i][q][k][l] = R^i_(q, kl) (p. 362)."""
    n = len(X)
    return [[[[diff(G[i][q][l], X[k]) - diff(G[i][q][k], X[l])
               + sum(G[p][q][l] * G[i][p][k] - G[p][q][k] * G[i][p][l]
                     for p in range(n))
               for l in range(n)] for k in range(n)] for q in range(n)]
            for i in range(n)]


def riemann_down(g, Ru):
    """R[i][q][k][l] = R_(iq, kl) = g_(ia) R^a_(q, kl) (p. 364)."""
    n = g.nrows()
    return [[[[sum(g[i, a] * Ru[a][q][k][l] for a in range(n))
               for l in range(n)] for k in range(n)] for q in range(n)]
            for i in range(n)]


def scalar_curvature(g, Ru):
    """R = g^(kl) R_(kl), R_(jl) = R^i_(j, il) (pp. 366-367)."""
    n = g.nrows()
    gi = g.inverse()
    ric = [[sum(Ru[i][j][i][l] for i in range(n)) for l in range(n)]
           for j in range(n)]
    return sum(gi[k, l] * ric[k][l] for k in range(n) for l in range(n))


def gauss_curvature_2d(g, X):
    """K = R_(12,12) / det g for a 2-dimensional metric."""
    Rd = riemann_down(g, riemann_up(christoffel(g, X), X))
    return Rd[0][1][0][1] / g.det()


def geodesic_lhs(G, X, Xd, Xdd):
    """x''^i + G^i_(ak) x'^a x'^k, formula (G) of p. 345."""
    n = len(X)
    return [Xdd[i] + sum(G[i][a][k] * Xd[a] * Xd[k] for a in range(n)
                         for k in range(n)) for i in range(n)]


# ---------------------------------------------------------------------------
# Section 1. Tensor fields (pp. 300-306).


def section_1():
    n = 3
    names = ([f'j{i}{k}' for i in range(n) for k in range(n)]
             + [f'b{i}{k}' for i in range(n) for k in range(n)]
             + [f'c{i}{k}' for i in range(n) for k in range(n)]
             + [f'a{i}' for i in range(n)] + [f'x{i}' for i in range(n)]
             + [f'u{i}' for i in range(n)])
    R = PolynomialRing(QQ, names)
    K = R.fraction_field()
    gens = [K(v) for v in R.gens()]
    J = matrix(K, n, n, gens[0:9])          # J[i', i] = dx^i'/dx^i
    B = matrix(K, n, n, gens[9:18])
    C = matrix(K, n, n, gens[18:27])
    a = vector(K, gens[27:30])
    xi = vector(K, gens[30:33])
    b = vector(K, gens[33:36])
    Ji = J.inverse()                        # Ji[i, i'] = dx^i/dx^i'

    # pp. 300-302: a^i' = dx^i'/dx^i a^i, xi_i' = dx^i/dx^i' xi_i.
    ap = vector(K, [sum(J[ip, i] * a[i] for i in range(n)) for ip in range(n)])
    xip = vector(K, [sum(Ji[i, ip] * xi[i] for i in range(n))
                     for ip in range(n)])
    check(ap == J * a, 'p. 300: a\' = J a')
    check(xip == Ji.transpose() * xi, 'p. 301: grad f changes by (J^-1)^T')
    check(ap.dot_product(xip) == a.dot_product(xi),
          'p. 301: a^i xi_i is invariant')
    # p. 302: c^i'_j' = dx^i'/dx^i dx^j/dx^j' c^i_j is C' = J C J^-1.
    Cp = matrix(K, n, n, lambda ip, jp: sum(
        J[ip, i] * Ji[j, jp] * C[i, j] for i in range(n) for j in range(n)))
    check(Cp == J * C * Ji, 'p. 302: C\' = J C J^-1')
    # p. 303, item 5): b_i'j' = dx^i/dx^i' dx^j/dx^j' b_ij.
    Bp = matrix(K, n, n, lambda ip, jp: sum(
        Ji[i, ip] * Ji[j, jp] * B[i, j] for i in range(n) for j in range(n)))
    check(Bp == Ji.transpose() * B * Ji,
          'p. 303 corrected: B\' = (J^-1)^T B J^-1')
    refuted(Bp == J * B * J.transpose(), 'p. 303 printed: B\' = J B J^T')
    check(ap * Bp * (J * b) == a * B * b, 'p. 303: B(a, b) is invariant')
    # p. 303: forms on covectors, b^i'j' = dx^i'/dx^i dx^j'/dx^j b^ij.
    Bc = matrix(K, n, n, lambda ip, jp: sum(
        J[ip, i] * J[jp, j] * B[i, j] for i in range(n) for j in range(n)))
    check(Bc == J * B * J.transpose(),
          'p. 303 corrected: forms on covectors, B\' = J B J^T')
    refuted(Bc == Ji.transpose() * B * Ji,
            'p. 303 printed: forms on covectors, B\' = (J^-1)^T B (J^-1)')


# ---------------------------------------------------------------------------
# Section 2. Examples, algebraic operations, skew tensors, forms
# (pp. 306-327).


def skew_tensor(coeffs, k, n):
    """Skew tensor with the given components for increasing index tuples."""
    T = {}
    for idx in product(range(n), repeat=k):
        if len(set(idx)) < k:
            T[idx] = 0
        else:
            s = tuple(sorted(idx))
            T[idx] = perm_sign([s.index(v) for v in idx]) * coeffs[s]
    return T


def form_of(E, T, k, n):
    """sum over i_1 < ... < i_k of T_I e_i_1 ^ ... ^ e_i_k."""
    e = E.gens()
    total = E.zero()
    for s in combinations(range(n), k):
        m = E.one()
        for i in s:
            m = m * e[i]
        total += T[s] * m
    return total


def coeff_of(x, E, idx):
    """Coefficient of e_i_1 ^ ... ^ e_i_k (increasing idx) in x."""
    e = E.gens()
    m = E.one()
    for i in idx:
        m = m * e[i]
    (key, c0), = m.monomial_coefficients().items()
    return x.monomial_coefficients().get(key, 0) / c0


def alt_sum(f, K):
    """sum over sigma in S_m of sgn(sigma) f(K_sigma), K a tuple."""
    m = len(K)
    return sum(perm_sign(p) * f(tuple(K[i] for i in p))
               for p in permutations(range(m)))


def section_2():
    # p. 307: the tensor of inertia (two points, symbolic).
    m1, m2 = var('m1 m2')
    pts = [vector(SR, var('p1 p2 p3')), vector(SR, var('q1 q2 q3'))]
    ms = [m1, m2]
    l = vector(SR, var('l1 l2 l3'))
    a = matrix(SR, 3, 3, lambda i, j: -sum(
        m * x[i] * x[j] for m, x in zip(ms, pts)) + (1 if i == j else 0)
        * sum(m * x.dot_product(x) for m, x in zip(ms, pts)))
    H = l * a * l
    check(zero(H - sum(m * (x.dot_product(x) * l.dot_product(l)
                            - x.dot_product(l) ** 2)
                       for m, x in zip(ms, pts))),
          'p. 307: H(l) = -sum m <x, l>^2 + sum m |l|^2 |x|^2')
    # invariance under a rational orthogonal matrix (Cayley transform)
    S = matrix(QQ, [[0, 1, 2], [-1, 0, 3], [-2, -3, 0]])
    Q = (identity_matrix(QQ, 3) - S) * (identity_matrix(QQ, 3) + S).inverse()
    check(Q.transpose() * Q == identity_matrix(QQ, 3),
          'p. 307: Q is orthogonal')
    pts2 = [Q * x for x in pts]
    a2 = matrix(SR, 3, 3, lambda i, j: -sum(
        m * x[i] * x[j] for m, x in zip(ms, pts2)) + (1 if i == j else 0)
        * sum(m * x.dot_product(x) for m, x in zip(ms, pts2)))
    check(zero((Q * l) * a2 * (Q * l) - H),
          'p. 307: H(l) is invariant under orthogonal changes')

    # pp. 308-309: the strain tensor; U[i][k] = du^i/dx^k.
    n = 3
    R = PolynomialRing(QQ, [f'U{i}{k}' for i in range(n) for k in range(n)]
                       + [f'd{i}' for i in range(n)])
    U = matrix(R, n, n, R.gens()[:9])
    dx = vector(R, R.gens()[9:12])
    du = U * dx
    lhs = (dx + du).dot_product(dx + du) - dx.dot_product(dx)
    sym = sum((U[i, k] + U[k, i]) * dx[i] * dx[k] for i in range(n)
              for k in range(n))
    quad = sum(U[i, k] * U[i, p] * dx[k] * dx[p] for i in range(n)
               for k in range(n) for p in range(n))
    check(lhs == 2 * dx.dot_product(du) + du.dot_product(du),
          'p. 309: (dl\')^2 - (dl)^2 = 2 sum dx du + sum du^2')
    check(2 * sum(U[i, k] * dx[i] * dx[k] for i in range(n)
                  for k in range(n)) == sym,
          'p. 309 corrected: 2 sum_(i,k) = sum_(i,k) (du^i/dx^k + du^k/dx^i)')
    check(lhs == sym + quad, 'p. 309: the expansion of (dl\')^2 - (dl)^2')
    refuted(lhs == sum((U[i, k] + U[k, i]) * dx[i] * dx[k]
                       for i in range(n) for k in range(n) if i < k) + quad,
            'p. 309 printed: the sum over i < k')
    check(sum(U[i, i] + U[i, i] for i in range(n)) == 2 * U.trace(),
          'p. 311: spur eta = 2 div v')

    # p. 312: the remark on C = C^T.
    R2 = PolynomialRing(QQ, 'a11,a12,a21,a22,c11,c12,c22')
    K2 = R2.fraction_field()
    a11, a12, a21, a22, c11, c12, c22 = [K2(v) for v in R2.gens()]
    A = matrix(K2, [[a11, a12], [a21, a22]])
    C = matrix(K2, [[c11, c12], [c12, c22]])
    M = A * C * A.inverse()
    Bm = A.transpose() * A
    check(A.transpose() * (M - M.transpose()) * A == Bm * C - C * Bm,
          'p. 312: A C A^-1 is symmetric iff (A^T A) C = C (A^T A)')

    # p. 315: the explanation for a symmetric operator (generic 2 x 2).
    R3 = PolynomialRing(QQ, 'g11,g12,g22,t11,t12,t21,t22,a1,a2,b1,b2')
    g11, g12, g22, t11, t12, t21, t22, a1, a2, b1, b2 = R3.gens()
    g = matrix(R3, [[g11, g12], [g12, g22]])
    T = matrix(R3, [[t11, t12], [t21, t22]])     # T[j, k] = T^j_k
    av, bv = vector(R3, [a1, a2]), vector(R3, [b1, b2])
    Tlow = g * T                                 # T_ik = g_ij T^j_k
    check(av * g * (T * bv) == av * Tlow * bv,
          'p. 315: <a, Tb> = T_ik a^i b^k, T_ik = g_ij T^j_k')
    Tki = matrix(R3, 2, 2, lambda k, i: sum(g[j, k] * T[j, i]
                                             for j in range(2)))
    check((T * av) * g * bv == sum(Tki[k, i] * av[i] * bv[k]
                                   for i in range(2) for k in range(2)),
          'p. 315 corrected: <Ta, b> = T_ki a^i b^k, T_ki = g_jk T^j_i')

    # p. 315, Lemma 2: T_(1'...n') = det(dx/dx') T_(12...n).
    for n in (2, 3):
        Rn = PolynomialRing(QQ, [f'm{i}{k}' for i in range(n)
                                 for k in range(n)] + ['t'])
        Mx = matrix(Rn, n, n, Rn.gens()[:n * n])   # Mx[i, i'] = dx^i/dx^i'
        t = Rn.gens()[-1]
        T = skew_tensor({tuple(range(n)): t}, n, n)
        top = sum(prod_list([Mx[idx[s], s] for s in range(n)]) * T[idx]
                  for idx in product(range(n), repeat=n))
        check(top == Mx.det() * t,
              f'p. 315, Lemma 2 (n = {n}): factor det(dx/dx\') = (det J)^-1')
        Jm = Mx.change_ring(Rn.fraction_field()).inverse()
        refuted(top == Jm.det() * t, f'p. 315 printed (n = {n}): factor det J')

    # p. 316, formula (1), and p. 318, the product of forms.
    for (k, q, n) in ((1, 1, 2), (1, 2, 3), (2, 1, 3), (2, 2, 4), (1, 3, 4)):
        cT = list(combinations(range(n), k))
        cP = list(combinations(range(n), q))
        Rn = PolynomialRing(QQ, [f't{i}' for i in range(len(cT))]
                            + [f'p{i}' for i in range(len(cP))])
        tg, pg = Rn.gens()[:len(cT)], Rn.gens()[len(cT):]
        T = skew_tensor(dict(zip(cT, tg)), k, n)
        P = skew_tensor(dict(zip(cP, pg)), q, n)
        E = ExteriorAlgebra(Rn, 'e', n)
        prodform = form_of(E, T, k, n) * form_of(E, P, q, n)
        ok_right = ok_mid = ok_mid_corr = True
        for Kx in combinations(range(n), k + q):
            ext = coeff_of(prodform, E, Kx)
            s = alt_sum(lambda Ks: T[Ks[:k]] * P[Ks[k:]], Kx)
            right = s / (factorial(k) * factorial(q))
            mid = s / factorial(k + q)
            ok_right &= (right == ext)
            ok_mid &= (mid == ext)
            ok_mid_corr &= (factorial(k + q) / (factorial(k) * factorial(q))
                            * mid == ext)
        check(ok_right, f'p. 316, (1) right member = exterior product '
              f'(k, q, n) = ({k}, {q}, {n})')
        refuted(ok_mid, f'p. 316/318 printed middle member T_[..P..] '
                f'(k, q, n) = ({k}, {q}, {n})')
        check(ok_mid_corr, f'p. 316/318 corrected ((k+q)!/(k!q!)) T_[..P..] '
              f'(k, q, n) = ({k}, {q}, {n})')

    # p. 318, the remark of p. 317: sum over all i of A dx^i_1 ^ ... .
    for (k, n) in ((2, 3), (3, 3), (2, 4), (3, 4)):
        idxs = list(product(range(n), repeat=k))
        Rn = PolynomialRing(QQ, [f'A{i}' for i in range(len(idxs))])
        A = dict(zip(idxs, Rn.gens()))
        E = ExteriorAlgebra(Rn, 'e', n)
        e = E.gens()
        lhs = E.zero()
        for idx in idxs:
            m = E.one()
            for i in idx:
                m = m * e[i]
            lhs += A[idx] * m
        altA = {s: alt_sum(lambda Ks: A[Ks], s) / factorial(k)
                for s in combinations(range(n), k)}
        check(lhs == form_of(E, {s: factorial(k) * altA[s]
                                 for s in altA}, k, n),
              f'p. 317 corrected: k! A_[...] (k = {k}, n = {n})')
        refuted(lhs == form_of(E, altA, k, n),
                f'p. 317 printed: A_[...] without k! (k = {k}, n = {n})')

    # p. 318: the value of a form on vectors; p. 319, Lemma 5; p. 325.
    for (k, n) in ((2, 3), (3, 4)):
        cT = list(combinations(range(n), k))
        Rn = PolynomialRing(QQ, [f't{i}' for i in range(len(cT))]
                            + [f'v{j}{i}' for j in range(k) for i in range(n)])
        tg = Rn.gens()[:len(cT)]
        av = [Rn.gens()[len(cT) + j * n:len(cT) + (j + 1) * n]
              for j in range(k)]
        T = skew_tensor(dict(zip(cT, tg)), k, n)
        allsum = sum(T[idx] * prod_list([av[j][idx[j]] for j in range(k)])
                     for idx in product(range(n), repeat=k))
        detsum = sum(T[s] * matrix(Rn, k, k, lambda j, l: av[j][s[l]]).det()
                     for s in cT)
        # normalized alternation (p. 314) of a_1^i_1 ... a_k^i_k at s
        midsum = sum(T[s] * alt_sum(lambda Ks: prod_list(
            [av[j][Ks[j]] for j in range(k)]), s) / factorial(k) for s in cT)
        check(detsum == allsum, f'p. 318: (T dx^I)(a) with dx^I(a) = det '
              f'equals T_(i...) a^i... over all indices (k = {k})')
        refuted(midsum == allsum,
                f'p. 318 printed: T dx^[i_1(a_1)...dx^i_k](a_k) (k = {k})')
        check(factorial(k) * midsum == allsum,
              f'p. 318 corrected: k! T dx^[i_1(a_1)...dx^i_k](a_k) '
              f'(k = {k})')
    for n in (2, 3, 4):
        Rn = PolynomialRing(QQ, [f'v{j}{i}' for j in range(n)
                                 for i in range(n)])
        A = matrix(Rn, n, n, Rn.gens())          # row j: the vector a_j
        mid = alt_sum(lambda Ks: prod_list([A[j, Ks[j]] for j in range(n)]),
                      tuple(range(n))) / factorial(n)
        refuted(mid == A.det(),
                f'p. 319 printed: a_1^[i_1 ... a_n^i_n] = det A (n = {n})')
        check(factorial(n) * mid == A.det(),
              f'p. 319 corrected: n! a_1^[i_1 ... a_n^i_n] = det A (n = {n})')
        # dx^1 ^ ... ^ dx^n built by formula (1): right and middle members.
        def build(member):
            T = {(i,): (1 if i == 0 else 0) for i in range(n)}
            for step in range(1, n):
                P = {(i,): (1 if i == step else 0) for i in range(n)}
                k = step
                newT = {}
                for idx in product(range(n), repeat=k + 1):
                    s = alt_sum(lambda Ks: T[Ks[:k]] * P[Ks[k:]], idx)
                    newT[idx] = member(s, k, 1)
                T = newT
            return T
        right = build(lambda s, k, q: s / (factorial(k) * factorial(q)))
        middle = build(lambda s, k, q: s / factorial(k + q))
        val_r = sum(right[idx] * prod_list([A[j, idx[j]] for j in range(n)])
                    for idx in product(range(n), repeat=n))
        val_m = sum(middle[idx] * prod_list([A[j, idx[j]] for j in range(n)])
                    for idx in product(range(n), repeat=n))
        check(right[tuple(range(n))] == 1 and val_r == A.det(),
              f'p. 319: dx^1 ^ ... ^ dx^n by (1) has value det A (n = {n})')
        refuted(val_m == A.det(),
                f'p. 316 printed middle member of (1) gives det A / n! '
                f'(n = {n})')
        # p. 325: a_i = d/dx^i, values dt^i.
        Rt = PolynomialRing(QQ, [f'dt{i}' for i in range(n)])
        D = matrix(Rt, n, n, lambda j, i: Rt.gens()[j] if i == j else 0)
        midt = alt_sum(lambda Ks: prod_list([D[j, Ks[j]] for j in range(n)]),
                       tuple(range(n))) / factorial(n)
        refuted(midt == prod_list(Rt.gens()),
                f'p. 325 printed: dx^[1(a_1 dt^1) ... = dt^1 ... dt^n '
                f'(n = {n})')
        check(factorial(n) * midt == prod_list(Rt.gens()),
              f'p. 325 corrected: n! dx^[1(a_1 dt^1) ... = dt^1 ... dt^n '
              f'(n = {n})')

    # p. 322: polar coordinates x = (r, phi), Cartesian y.
    r = var('r', domain='positive')
    phi = var('phi', domain='real')
    X = [r, phi]
    Y = [r * cos(phi), r * sin(phi)]
    Jp = matrix(SR, 2, 2, lambda i, j: diff(Y[i], X[j]))  # dy^i/dx^j
    gx = matrix(SR, [[1, 0], [0, r ** 2]])
    avec = [vector(SR, [diff(Y[i], X[j]) for i in range(2)]) for j in range(2)]
    check(all(zero(e) for j in range(2)
              for e in Jp * vector(SR, [1 if i == j else 0 for i in range(2)])
              - avec[j]), 'p. 322: J maps e_j to a_j')
    check(mzero(Jp.transpose() * Jp - gx),
          'p. 322 corrected: g(x) = J^T E J = J^T J')
    refuted(mzero(Jp * Jp.transpose() - gx), 'p. 322 printed: g(x) = J J^T')
    check(zero(Jp.det() ** 2 - gx.det()), 'p. 322: g(x) = det(J)^2')

    # p. 323: |[r_u, r_v]|^2 = EG - F^2.
    u, v = var('u v')
    rr = vector(SR, [function(f'r{i}')(u, v) for i in range(3)])
    ru = vector(SR, [diff(c, u) for c in rr])
    rv = vector(SR, [diff(c, v) for c in rr])
    cr = ru.cross_product(rv)
    check(zero_exp(cr.dot_product(cr)
                   - (ru.dot_product(ru) * rv.dot_product(rv)
                      - ru.dot_product(rv) ** 2)),
          'p. 323: |[r_u, r_v]|^2 = EG - F^2')

    # p. 324: det(g) = 1 + sum f_i^2 for a graph.
    for m in range(2, 6):
        Rm = PolynomialRing(QQ, [f'f{i}' for i in range(m)])
        fv = vector(Rm, Rm.gens())
        gm = identity_matrix(Rm, m) + fv.column() * fv.row()
        check(gm.det() == 1 + fv.dot_product(fv),
              f'p. 324: g = 1 + sum f_(x^i)^2 (n - 1 = {m})')

    # pp. 325-327: Theorem 1 and the Pfaffian.
    for n in (1, 2, 3):
        N = 2 * n
        pairs = list(combinations(range(N), 2))
        Rn = PolynomialRing(QQ, [f'w{i}{j}' for i, j in pairs])
        W = matrix(Rn, N, N)
        for (i, j), w in zip(pairs, Rn.gens()):
            W[i, j], W[j, i] = w, -w
        E = ExteriorAlgebra(Rn, 'e', N)
        e = E.gens()
        om = sum(W[i, j] * e[i] * e[j] for i, j in pairs)
        pw = E.one()
        for _ in range(n):
            pw = pw * om
        top = coeff_of(pw, E, tuple(range(N)))
        check(top == factorial(n) * W.pfaffian(),
              f'p. 326: omega^n = n! Pf dx^1...dx^2n (n = {n})')
        check(W.pfaffian() ** 2 == W.det(), f'p. 326: Pf^2 = det (n = {n})')
        if n > 1:
            refuted(top == W.pfaffian(),
                    f'p. 326 printed: omega^n itself has the coefficient Pf '
                    f'(n = {n})')
        # canonical block form
        Ec = ExteriorAlgebra(QQ, 'e', N)
        ec = Ec.gens()
        omc = sum(ec[2 * i] * ec[2 * i + 1] for i in range(n))
        pwc = Ec.one()
        for _ in range(n):
            pwc = pwc * omc
        check(pwc / factorial(n) == prod_list(list(ec), Ec.one()),
              f'p. 326 corrected: Omega(y) = omega^n/n! = dy^1...dy^2n '
              f'(n = {n})')
    R8 = PolynomialRing(QQ, [f'w{i}{j}' for i, j in combinations(range(8), 2)])
    W8 = matrix(R8, 8, 8)
    for (i, j), w in zip(combinations(range(8), 2), R8.gens()):
        W8[i, j], W8[j, i] = w, -w
    check(W8.pfaffian() ** 2 == W8.det(), 'p. 326: Pf^2 = det (n = 4)')
    # n = 1, omega = -dx^1 ^ dx^2: f = -1, sqrt(det) = 1.
    W1 = matrix(QQ, [[0, -1], [1, 0]])
    refuted(W1.pfaffian() == sqrt(W1.det()),
            'p. 326 printed: f(x) = sqrt(det) for omega = -dx^1 ^ dx^2')
    check(W1.pfaffian() ** 2 == W1.det(), 'p. 326 corrected: f = +-sqrt(det)')
    # the law A(x) = J^T A(y) J and Omega(x) = det J dx (concrete change).
    x1, x2, x3, x4 = var('x1 x2 x3 x4')
    xs = [x1, x2, x3, x4]
    ys = [x1 + x2 ** 2, x2 + x3 * x4, x3 + x1 ** 3, x4 - x2 * x3]
    Jy = matrix(SR, 4, 4, lambda i, j: diff(ys[i], xs[j]))   # dy^i/dx^j
    Ay = matrix(QQ, [[0, 1, 0, 0], [-1, 0, 0, 0], [0, 0, 0, 1],
                     [0, 0, -1, 0]])
    Ax = matrix(SR, 4, 4, lambda i, j: sum(
        Ay[k, l] * Jy[k, i] * Jy[l, j] for k in range(4) for l in range(4)))
    check(mzero(Ax - Jy.transpose() * Ay * Jy),
          'p. 326 corrected: A(x) = J^T A(y) J')
    refuted(mzero(Ax - Jy * Ay * Jy.transpose()),
            'p. 326 printed: A(x) = J A(y) J^T')
    check(zero(Ax.det() - Jy.det() ** 2), 'p. 326: det A(x) = (det J)^2')
    Jq = Jy.subs({x1: 1, x2: 2, x3: -1, x4: 3}).change_ring(QQ)
    Eq = ExteriorAlgebra(QQ, 'e', 4)
    eq = Eq.gens()
    dy = [sum(Jq[i, j] * eq[j] for j in range(4)) for i in range(4)]
    omx = dy[0] * dy[1] + dy[2] * dy[3]
    check(omx * omx / 2 == Jq.det() * eq[0] * eq[1] * eq[2] * eq[3],
          'p. 326: Omega(x) = det J dx^1 ^ ... ^ dx^4 (at a point)')
    # p. 327, the example n = 2.
    R4 = PolynomialRing(QQ, 'w12,w34')
    w12, w34 = R4.gens()
    E4 = ExteriorAlgebra(R4, 'e', 4)
    e4 = E4.gens()
    om4 = w12 * e4[0] * e4[1] + w34 * e4[2] * e4[3]
    vol4 = e4[0] * e4[1] * e4[2] * e4[3]
    check(om4 * om4 == 2 * w12 * w34 * vol4,
          'p. 327: omega ^ omega = 2 w12 w34 dx^1...dx^4')
    refuted(om4 * om4 == w12 * w34 * vol4,
            'p. 327 printed: omega ^ omega = 1/2! (2 w12 w34 dx...)')
    check(om4 * om4 / 2 == w12 * w34 * vol4,
          'p. 327 corrected: Omega = 1/2! omega ^ omega = w12 w34 dx...')
    W4 = matrix(R4, [[0, w12, 0, 0], [-w12, 0, 0, 0], [0, 0, 0, w34],
                     [0, 0, -w34, 0]])
    check(W4.det() == (w12 * w34) ** 2, 'p. 327: det(w_ij) = (w12 w34)^2')
    refuted(QQ(1) * QQ(-1) == sqrt(W4.det().subs(w12=1, w34=-1)),
            'p. 327 printed: w12 w34 = sqrt(det) (w12 = 1, w34 = -1)')


def prod_list(xs, one=1):
    out = one
    for x in xs:
        out = out * x
    return out


# ---------------------------------------------------------------------------
# Section 3. Connections (pp. 327-339).


def section_3():
    r = var('r', domain='positive')
    phi = var('phi', domain='real')
    X1, X2 = var('X1 X2', domain='real')
    P = [r, phi]                       # x' (polar)
    C = [r * cos(phi), r * sin(phi)]   # x (Cartesian) as functions of x'
    inv = [sqrt(X1 ** 2 + X2 ** 2), atan(X2 / X1)]   # x' as functions of x
    back = {X1: r * cos(phi), X2: r * sin(phi)}
    M = matrix(SR, 2, 2, lambda i, j: diff(C[i], P[j]))  # dx^i/dx^j'
    Mi = M.inverse()                                     # dx^i'/dx^i
    check(all(zero_pos(diff(inv[i], [X1, X2][j]).subs(back) - Mi[i, j])
              for i in range(2) for j in range(2)),
          'polar: the explicit inverse map has the Jacobi matrix M^-1')

    # p. 327: the extra term S for the covector dx^1 (T_i = delta_i1).
    S = [[sum((1 if i == 0 else 0) * diff(M[i, ip], P[al]) for i in range(2))
          for ip in range(2)] for al in range(2)]
    check(not zero(S[1][1]) and zero(S[1][1] + r * cos(phi)),
          'p. 327: S_(phi phi) = -r cos(phi) != 0 for a nonlinear change')

    # p. 328: div of T = d/dX1 in polar coordinates.
    Tp = [Mi[0, 0], Mi[1, 0]]
    naive = diff(Tp[0], r) + diff(Tp[1], phi)
    Rterm = sum((1 if i == 0 else 0) * M[k, ip]
                * diff(diff(inv[ip], [X1, X2][k]), [X1, X2][i]).subs(back)
                for i in range(2) for k in range(2) for ip in range(2))
    check(zero_pos(naive - Rterm) and zero(naive + cos(phi) / r),
          'p. 328: div changes by R(T, x, x\') = -cos(phi)/r != 0')
    gpol = matrix(SR, [[1, 0], [0, r ** 2]])
    check(zero(naive + Tp[0] * diff(ln(sqrt(gpol.det())), r)
               + Tp[1] * diff(ln(sqrt(gpol.det())), phi)),
          'p. 338, Assertion 2: the invariant divergence of d/dX1 is 0')

    # pp. 329-331: G^i'_(j'k') = dx^i'/dx^i d^2x^i/dx^j' dx^k'.
    Gp = [[[sum(Mi[ip, i] * diff(C[i], P[jp], P[kp]) for i in range(2))
            for kp in range(2)] for jp in range(2)] for ip in range(2)]
    Gc = christoffel(gpol, P)
    check(all(zero(Gp[i][j][k] - Gc[i][j][k]) for i in range(2)
              for j in range(2) for k in range(2)),
          'p. 329: G = dx\'/dx d^2x/dx\'dx\' are the Christoffel symbols of '
          'dr^2 + r^2 dphi^2')
    # Lemma 1: tilde G^k'_(i'j') = d^2x^k'/dx^j dx^i dx^i/dx^i' dx^j/dx^j'.
    tG = [[[sum(diff(inv[kp], [X1, X2][j], [X1, X2][i]).subs(back)
                * M[i, ip] * M[j, jp] for i in range(2) for j in range(2))
            for jp in range(2)] for ip in range(2)] for kp in range(2)]
    check(all(zero_pos(tG[k][i][j] + Gp[k][i][j]) for i in range(2)
              for j in range(2) for k in range(2)),
          'p. 329, Lemma 1: tilde G = -G')
    # p. 331, the explicit formula: corrected and printed free indices.
    corr = [[[-sum(diff(inv[ip], [X1, X2][j], [X1, X2][i]).subs(back)
                   * M[i, jp] * M[j, kp] for i in range(2) for j in range(2))
              for kp in range(2)] for jp in range(2)] for ip in range(2)]
    check(all(zero_pos(corr[i][j][k] - Gp[i][j][k]) for i in range(2)
              for j in range(2) for k in range(2)),
          'p. 331 corrected: G^i\'_(j\'k\') = -d^2x^i\'/dx^j dx^i '
          'dx^i/dx^j\' dx^j/dx^k\'')
    # printed: -d^2x^k'/dx^j dx^i dx^i/dx^i' dx^j/dx^j' at (i',j',k')
    printed = -sum(diff(inv[1], [X1, X2][j], [X1, X2][i]).subs(back)
                   * M[i, 0] * M[j, 1] for i in range(2) for j in range(2))
    refuted(zero_pos(printed - Gp[0][1][1]),
            'p. 331 printed: free indices i\'j\'k\' -> k\'i\'j\' '
            '(G^r_(phi phi) = -r)')

    # Theorem 1 (p. 330): transformation law of G, sphere metric,
    # theta = u, phi = v + u^2.
    th, ph = var('th ph', domain='real')
    uu, vv = var('uu vv', domain='real')
    gs = matrix(SR, [[1, 0], [0, sin(th) ** 2]])
    Gs = christoffel(gs, [th, ph])
    old = [uu, vv + uu ** 2]                      # x' as functions of x''
    sub = {th: old[0], ph: old[1]}
    Mo = matrix(SR, 2, 2, lambda i, j: diff(old[i], [uu, vv][j]))
    Moi = Mo.inverse()
    g2 = Mo.transpose() * gs.subs(sub) * Mo
    G2 = christoffel(g2, [uu, vv])
    law = [[[sum(Moi[a, i] * Mo[j, b] * Mo[k, c] * Gs[i][j][k].subs(sub)
                 for i in range(2) for j in range(2) for k in range(2))
             + sum(Moi[a, i] * diff(old[i], [uu, vv][b], [uu, vv][c])
                   for i in range(2))
             for c in range(2)] for b in range(2)] for a in range(2)]
    check(all(zero(law[a][b][c] - G2[a][b][c]) for a in range(2)
              for b in range(2) for c in range(2)),
          'p. 330, Theorem 1: the transformation law of G')

    # Theorem 3 (p. 336) for an arbitrary 2-dimensional metric.
    x, y = var('x y')
    Xc = [x, y]
    Ef, Ff, Gf = [function(nm)(x, y) for nm in ('E', 'F', 'G')]
    g = matrix(SR, [[Ef, Ff], [Ff, Gf]])
    G = christoffel(g, Xc)
    check(all(zero(G[i][j][k] - G[i][k][j]) for i in range(2)
              for j in range(2) for k in range(2)),
          'p. 336, Theorem 3: G^i_(jk) = G^i_(kj)')
    check(all(zero(diff(g[i, j], Xc[k])
                   - sum(g[a, j] * G[a][i][k] + g[i, a] * G[a][j][k]
                         for a in range(2)))
              for i in range(2) for j in range(2) for k in range(2)),
          'p. 336, Theorem 3: nabla_k g_ij = 0')
    check(all(zero(diff(g[i, j], Xc[k]) + diff(g[k, i], Xc[j])
                   - diff(g[j, k], Xc[i])
                   - 2 * sum(g[i, a] * G[a][j][k] for a in range(2)))
              for i in range(2) for j in range(2) for k in range(2)),
          'p. 336: dg_ij/dx^k + dg_ki/dx^j - dg_jk/dx^i = 2 g_ia G^a_jk')
    # the printed solved formula: third term dg_jk/dx^alpha, a
    # non-diagonal metric g = (1, y; y, 2)
    gn = matrix(SR, [[1, y], [y, 2]])
    gni = gn.inverse()
    Gn = christoffel(gn, Xc)
    pr = [[[sum(gni[i, al] * (diff(gn[i, j], Xc[k]) + diff(gn[k, i], Xc[j])
                              - diff(gn[j, k], Xc[al])) for i in range(2)) / 2
            for k in range(2)] for j in range(2)] for al in range(2)]
    refuted(all(zero(pr[a][j][k] - Gn[a][j][k]) for a in range(2)
                for j in range(2) for k in range(2)),
            'p. 336 printed: the third term dg_jk/dx^alpha (g = (1, y; y, 2))')

    # p. 337: graph at a critical point (generic jets): dg(0) = 0.
    for m in (2, 3):
        names = ([f'q{i}{j}' for i in range(m) for j in range(i, m)]
                 + [f'c{i}{j}{k}' for i in range(m) for j in range(i, m)
                    for k in range(j, m)] + [f'x{i}' for i in range(m)])
        Rm = PolynomialRing(QQ, names)
        xs = Rm.gens()[-m:]
        it = iter(Rm.gens())
        f = sum(next(it) * xs[i] * xs[j] for i in range(m)
                for j in range(i, m))
        f += sum(next(it) * xs[i] * xs[j] * xs[k] for i in range(m)
                 for j in range(i, m) for k in range(j, m))
        fx = [f.derivative(xs[i]) for i in range(m)]
        gm = [[(1 if i == j else 0) + fx[i] * fx[j] for j in range(m)]
              for i in range(m)]
        at0 = {xx: 0 for xx in xs}
        check(all(gm[i][j].derivative(xs[k]).subs(at0) == 0 for i in range(m)
                  for j in range(m) for k in range(m)),
              f'p. 337: dg_ij/dx^k = 0 at a critical point (n - 1 = {m})')

    # Assertion 2 (p. 338), arbitrary 2-dimensional metric.
    lnsg = ln(sqrt(g.det()))
    check(all(zero(sum(G[i][a][i] for i in range(2)) - diff(lnsg, Xc[a]))
              for a in range(2)),
          'p. 338: G^i_(a i) = d ln sqrt(g)/dx^a')
    Tv = [function('T1')(x, y), function('T2')(x, y)]
    divT = sum(diff(Tv[i], Xc[i]) + sum(Tv[a] * G[i][a][i] for a in range(2))
               for i in range(2))
    check(zero(divT - sum(diff(Tv[i], Xc[i]) for i in range(2))
               - sum(Tv[a] * diff(lnsg, Xc[a]) for a in range(2))),
          'p. 338, Assertion 2: div T = dT^i/dx^i + T^a d ln sqrt(g)/dx^a')
    t = var('t')
    Mt = matrix(SR, 3, 3, lambda i, j: function(f'm{i}{j}')(t))
    adj = Mt.adjugate()                  # adj[p, i] = Delta_ip
    check(zero_exp(diff(Mt.det(), t) - sum(adj[p, i] * diff(Mt[i, p], t)
                                           for i in range(3)
                                           for p in range(3))),
          'p. 339: dg/dx = sum Delta_ip dg_ip/dx (3 x 3)')


# ---------------------------------------------------------------------------
# Section 4. Parallel transport, geodesics (pp. 339-359).


def section_4():
    t = var('t')
    # Theorem 1 (p. 343) on the sphere.
    th, ph = var('th ph', domain='real')
    gs = matrix(SR, [[1, 0], [0, sin(th) ** 2]])
    Gs = christoffel(gs, [th, ph])
    cur = {th: function('a')(t), ph: function('b')(t)}
    xd = [diff(cur[th], t), diff(cur[ph], t)]
    Tf = [function('T1')(t), function('T2')(t)]
    Rf = [function('R1')(t), function('R2')(t)]

    def Dt(V):
        return [diff(V[i], t) + sum(V[p] * Gs[i][p][k].subs(cur) * xd[k]
                                    for p in range(2) for k in range(2))
                for i in range(2)]
    gsc = gs.subs(cur)
    inner = sum(gsc[i, j] * Tf[i] * Rf[j] for i in range(2) for j in range(2))
    DT, DR = Dt(Tf), Dt(Rf)
    check(zero(diff(inner, t) - sum(gsc[i, j] * (DT[i] * Rf[j]
                                                 + Tf[i] * DR[j])
                                    for i in range(2) for j in range(2))),
          'p. 343, Theorem 1: d<T, R>/dt = <DT, R> + <T, DR> (sphere)')

    # The cone (p. 346).
    rho, psi = var('rho psi', domain='positive')
    al = var('al', domain='positive')            # theta/2
    cone = vector(SR, [rho * sin(al) * cos(psi), rho * sin(al) * sin(psi),
                       rho * cos(al)])
    cr, cp = cone.diff(rho), cone.diff(psi)
    gc = matrix(SR, [[cr.dot_product(cr), cr.dot_product(cp)],
                     [cp.dot_product(cr), cp.dot_product(cp)]])
    check(mzero(gc - matrix(SR, [[1, 0], [0, sin(al) ** 2 * rho ** 2]])),
          'p. 346: the cone metric d rho^2 + sin^2(theta/2) rho^2 dpsi^2')
    Gco = christoffel(gc, [rho, psi])
    r0 = var('r0', domain='positive')
    c = sin(al)
    Tc = [cos(c * t), -sin(c * t) / (c * r0)]   # along rho = r0, psi = t
    on = {rho: r0, psi: t}
    xdc = [0, 1]
    eqs = [diff(Tc[i], t) + sum(Tc[p] * Gco[i][p][k].subs(on) * xdc[k]
                                for p in range(2) for k in range(2))
           for i in range(2)]
    check(all(zero(e) for e in eqs),
          'p. 346: the parallel field along the circle turns with speed '
          'sin(theta/2)')
    check(zero(2 * pi * c + 2 * pi * (1 - sin(al)) - 2 * pi),
          'p. 346: turn 2 pi sin(theta/2) = -2 pi (1 - sin(theta/2)) mod 2 pi')

    # The sphere (p. 348).
    check(zero(Gs[0][1][1] + sin(2 * th) / 2) and zero(Gs[1][0][1]
                                                     - cos(th) / sin(th))
          and zero(Gs[1][1][0] - cos(th) / sin(th))
          and all(zero(Gs[i][j][k]) for (i, j, k) in
                  ((0, 0, 0), (0, 0, 1), (0, 1, 0), (1, 0, 0), (1, 1, 1))),
          'p. 348: G^1_22 = -sin(2 theta)/2, G^2_12 = G^2_21 = ctg theta, '
          'the others 0')
    thd, phd, thdd, phdd = var('thd phd thdd phdd')
    geo = geodesic_lhs(Gs, [th, ph], [thd, phd], [thdd, phdd])
    check(zero(geo[0] - (thdd - sin(2 * th) / 2 * phd ** 2)),
          'p. 348: the theta-equation')
    check(zero(geo[1] - (phdd + 2 * cos(th) / sin(th) * phd * thd)),
          'p. 348 corrected: the phi-equation with 2 ctg theta')
    refuted(zero(geo[1] - (phdd + cos(th) / sin(th) * phd * thd)),
            'p. 348 printed: the phi-equation with ctg theta')
    check(all(zero(e.subs({thd: 1, phd: 0, thdd: 0, phdd: 0})) for e in geo),
          'p. 348: the meridian phi = const, theta = t is a geodesic')
    # the great circle (cos s, sin s / sqrt 2, sin s / sqrt 2) near s = pi/4
    s = var('s')
    thc = acos(sin(s) / sqrt(2))
    phc = atan(tan(s) / sqrt(2))
    sub = {th: thc}
    ge = [e.subs(sub).subs({thd: diff(thc, s), phd: diff(phc, s),
                            thdd: diff(thc, s, 2), phdd: diff(phc, s, 2)})
          for e in geo]
    check(all(zero(e.subs(s=pi / 4)) for e in ge)
          and all(zero(e.subs(s=pi / 3)) for e in ge),
          'p. 348: a great circle in the plane z = y satisfies (G) '
          '(at s = pi/4, pi/3)')

    # The Lobachevsky plane (p. 349).
    chi = var('chi', domain='positive')
    gl = matrix(SR, [[1, 0], [0, sh(chi) ** 2]])
    Gl = christoffel(gl, [chi, ph])
    check(zero(Gl[0][1][1] + sh(2 * chi) / 2)
          and zero(Gl[1][0][1] - ch(chi) / sh(chi))
          and zero(Gl[1][1][0] - ch(chi) / sh(chi)),
          'p. 349: G^1_22 = -sh(2 chi)/2, G^2_12 = G^2_21 = cth chi')
    chd, chdd = var('chd chdd')
    geol = geodesic_lhs(Gl, [chi, ph], [chd, phd], [chdd, phdd])
    check(zero(geol[1] - (phdd + 2 * ch(chi) / sh(chi) * phd * chd)),
          'p. 349 corrected: the phi-equation with 2 cth chi')
    refuted(zero(geol[1] - (phdd + ch(chi) / sh(chi) * phd * chd)),
            'p. 349 printed: the phi-equation with cth chi')
    check(all(zero(e.subs({chd: 1, phd: 0, chdd: 0, phdd: 0}))
              for e in geol),
          'p. 349: phi = const, chi = t is a geodesic')
    check(zero(gauss_curvature_2d(gl, [chi, ph]) + 1),
          'p. 349: d chi^2 + sh^2 chi dphi^2 has curvature -1')
    rr = var('rr', domain='positive')
    gd = 4 / (1 - rr ** 2) ** 2 * matrix(SR, [[1, 0], [0, rr ** 2]])
    check(zero(gauss_curvature_2d(gd, [rr, ph]) + 1),
          'p. 349 corrected: 4 (1 - r^2)^-2 (dr^2 + r^2 dphi^2), K = -1')
    gd1 = 1 / (1 - rr ** 2) ** 2 * matrix(SR, [[1, 0], [0, rr ** 2]])
    refuted(zero(gauss_curvature_2d(gd1, [rr, ph]) + 1),
            'p. 349 printed: (1 - r^2)^-2 (dr^2 + r^2 dphi^2) has K = -4')
    check(zero(gauss_curvature_2d(gd1, [rr, ph]) + 4),
          'p. 349 printed metric: K = -4')
    rch = (exp(chi) - 1) / (exp(chi) + 1)          # th(chi/2)
    drch = diff(rch, chi)
    check(zero(4 / (1 - rch ** 2) ** 2 * drch ** 2 - 1)
          and zero(4 / (1 - rch ** 2) ** 2 * rch ** 2 - sh(chi) ** 2),
          'p. 349: r = th(chi/2) carries d chi^2 + sh^2 chi dphi^2 to '
          '4 (dr^2 + r^2 dphi^2)/(1 - r^2)^2')
    # the Cayley map w = i(1 + z)/(1 - z) onto the half-plane
    a, b = var('a b', domain='real')
    z = a + I * b
    w = I * (1 + z) / (1 - z)
    dwdz = diff(w, a)                     # holomorphic: dw/dz = dw/da
    imw = (w - w.conjugate()) / (2 * I)
    pull = (dwdz * dwdz.conjugate()) / imw ** 2
    check(zero(pull - 4 / (1 - a ** 2 - b ** 2) ** 2),
          'p. 349: the Cayley map is an isometry of 4|dz|^2/(1 - |z|^2)^2 '
          'onto (dx^2 + dy^2)/y^2')
    refuted(zero(pull - 1 / (1 - a ** 2 - b ** 2) ** 2),
            'p. 349 printed: an isometry of (1 - |z|^2)^-2 |dz|^2')
    # z -> -z/(z - a0), a0 > 0
    a0 = var('a0', domain='positive')
    w2 = -z / (z - a0)
    check(zero((w2 - w2.conjugate()) / (2 * I)
               - a0 * b / ((a - a0) ** 2 + b ** 2)),
          'p. 349: Im(-z/(z - a)) = a Im z/|z - a|^2 > 0 for a > 0')
    tt = var('tt', domain='real')
    zc = a0 / 2 + a0 / 2 * exp(I * tt)
    wc = -zc / (zc - a0)
    check(zero(wc + wc.conjugate()),
          'p. 349: the circle |z - a/2| = a/2 goes to the imaginary axis')
    d2 = diff(w2, a)
    imw2 = (w2 - w2.conjugate()) / (2 * I)
    check(zero(d2 * d2.conjugate() / imw2 ** 2 - 1 / b ** 2),
          'p. 349: z -> -z/(z - a) preserves (dx^2 + dy^2)/y^2')

    # The half-plane (p. 351).
    xh = var('xh')
    yy = var('yy', domain='positive')
    gh = matrix(SR, [[1 / yy ** 2, 0], [0, 1 / yy ** 2]])
    Gh = christoffel(gh, [xh, yy])
    check(zero(Gh[0][0][1] + 1 / yy) and zero(Gh[1][0][0] - 1 / yy)
          and zero(Gh[1][1][1] + 1 / yy) and zero(Gh[0][0][0])
          and zero(Gh[0][1][1]) and zero(Gh[1][0][1]),
          'p. 351 corrected: G^1_12 = -1/y, G^2_11 = 1/y, G^2_22 = -1/y, '
          'the others 0')
    refuted(zero(Gh[0][0][1] - 1 / yy),
            'p. 351 printed: G^1_12 = 1/y')
    refuted(zero(Gh[1][0][0] + 1 / yy),
            'p. 351 printed: G^2_11 = -1/y')
    refuted(zero(Gh[1][1][1] - 1 / yy),
            'p. 351 printed: G^2_22 = 1/y')
    xd_, yd_, xdd_, ydd_ = var('xd_ yd_ xdd_ ydd_')
    geoh = geodesic_lhs(Gh, [xh, yy], [xd_, yd_], [xdd_, ydd_])
    check(zero(geoh[0] - (xdd_ - 2 * xd_ * yd_ / yy))
          and zero(geoh[1] - (ydd_ - (yd_ ** 2 - xd_ ** 2) / yy)),
          'p. 351: x\'\' = 2 x\'y\'/y, y\'\' = (y\'^2 - x\'^2)/y')
    xt, yt = function('xt')(t), function('yt')(t)
    d2ydx2 = diff(diff(yt, t) / diff(xt, t), t) / diff(xt, t)
    check(zero(d2ydx2 - (diff(yt, t, 2) * diff(xt, t) - diff(xt, t, 2)
                         * diff(yt, t)) / diff(xt, t) ** 3),
          'p. 352: d^2y/dx^2 = (y\'\' x\' - x\'\' y\')/x\'^3')
    sol = {diff(xt, t, 2): 2 * diff(xt, t) * diff(yt, t) / yt,
           diff(yt, t, 2): (diff(yt, t) ** 2 - diff(xt, t) ** 2) / yt}
    check(zero(d2ydx2.subs(sol) + (diff(yt, t) ** 2 / diff(xt, t) ** 2 + 1)
               / yt),
          'p. 352: d^2y/dx^2 = -(y\'_x^2 + 1)/y on geodesics')
    Cc, Dd, X = var('Cc Dd X')
    Ycirc = sqrt(Cc ** 2 + Dd - (X - Cc) ** 2)
    check(zero(Ycirc * diff(Ycirc, X, 2) + diff(Ycirc, X) ** 2 + 1),
          'p. 352: the circles (x - C)^2 + y^2 = C^2 + D solve '
          'y y\'\' + y\'^2 = -1')

    # The torus (p. 352).
    f1, f2 = var('f1 f2', domain='real')
    emb = vector(SR, [cos(f1), sin(f1), cos(f2), sin(f2)])
    e1, e2 = emb.diff(f1), emb.diff(f2)
    check(zero(e1.dot_product(e1) - 1) and zero(e2.dot_product(e2) - 1)
          and zero(e1.dot_product(e2)),
          'p. 352: (e^(i phi), e^(i psi)) induces dphi^2 + dpsi^2')

    # Theorem 2 (p. 355): dimensions.
    nv = var('nv')
    check(zero(nv + nv * (nv - 1) / 2 - nv * (nv + 1) / 2),
          'p. 356: n + n(n - 1)/2 = n(n + 1)/2')
    Rm = PolynomialRing(QQ, [f'm{i}{j}' for i in range(3) for j in range(3)])
    Mg = matrix(Rm, 3, 3, Rm.gens())
    so3 = matrix(QQ, [[(Mg + Mg.transpose())[i, j].monomial_coefficient(v)
                       for v in Rm.gens()] for i in range(3)
                      for j in range(3)])
    check(9 - so3.rank() == 3, 'p. 357: dim SO(3) = 3')
    sl2 = matrix(QQ, [[1, 0, 0, 1]])
    check(4 - sl2.rank() == 3, 'p. 357: dim SL(2; R) = 3')
    R2m = PolynomialRing(QQ, 'n00,n01,n10,n11')
    N2 = matrix(R2m, 2, 2, R2m.gens())
    so2 = matrix(QQ, [[(N2 + N2.transpose())[i, j].monomial_coefficient(v)
                       for v in R2m.gens()] for i in range(2)
                      for j in range(2)])
    check((4 - so2.rank()) + 2 == 3,
          'p. 357: dim of the motions x -> Ax + b, A in SO(2), is 1 + 2 = 3')

    # Lemma 4 (pp. 357-358), Euclidean model.
    p1, p2, t1, t2 = var('p1 p2 t1 t2', domain='real')
    a_ = vector(SR, [t1, t2])
    na = sqrt(t1 ** 2 + t2 ** 2)
    gamma = lambda tt_: vector(SR, [p1, p2]) + tt_ * a_ / na   # natural
    check(all(zero_pos(e) for e in gamma(na) - vector(SR, [p1 + t1, p2 + t2])),
          'p. 357 corrected: exp_P(a) = gamma_a(|a|) = P + a')
    g1 = gamma(1)
    same = all(zero(e) for e in (g1.subs(t1=QQ(1) / 2, t2=0)
                                 - g1.subs(t1=QQ(1) / 4, t2=0)))
    refuted(not same, 'p. 357 printed: a -> gamma_a(1) with the natural '
            'parameter is injective (a = (1/2, 0), (1/4, 0) have one image)')
    Fm = [p1, p2, p1 + t1, p2 + t2]
    Jf = matrix(SR, 4, 4, lambda i, j: diff(Fm[i], [p1, p2, t1, t2][j]))
    Eb, Zb = identity_matrix(SR, 2), matrix(SR, 2, 2)
    check(Jf == block_matrix([[Eb, Zb], [Eb, Eb]]),
          'p. 358 corrected: the Jacobi matrix of F is (E 0; E E)')
    refuted(Jf == block_matrix([[Eb, Eb], [Zb, Eb]]),
            'p. 358 printed: (E E; 0 E) (rows = target coordinates)')
    check(Jf.det() == 1, 'p. 358: F is nondegenerate at (P_0, 0)')


# ---------------------------------------------------------------------------
# Section 5. The curvature tensor (pp. 359-371).


def jet_metric(n):
    """g(x) = E + sum a x + sum b x x with independent coefficients; return
    (ring, coordinates, g as a matrix of polynomials)."""
    names = []
    for i in range(n):
        for j in range(i, n):
            names += [f'a{i}{j}_{k}' for k in range(n)]
            names += [f'b{i}{j}_{k}{l}' for k in range(n) for l in range(k, n)]
    names += [f'x{i}' for i in range(n)]
    Rn = PolynomialRing(QQ, names)
    xs = Rn.gens()[-n:]
    it = iter(Rn.gens())
    g = matrix(Rn, n, n)
    for i in range(n):
        for j in range(i, n):
            e = (1 if i == j else 0)
            e += sum(next(it) * xs[k] for k in range(n))
            e += sum(next(it) * xs[k] * xs[l] for k in range(n)
                     for l in range(k, n))
            g[i, j] = g[j, i] = e
    return Rn, xs, g


def jet_curvature(Rn, xs, g):
    """Gamma(0), dGamma(0) and R^i_(q, kl)(0) for g(0) = E."""
    n = len(xs)
    at0 = {x: 0 for x in xs}
    first = [[[(g[k, a].derivative(xs[j]) + g[j, a].derivative(xs[k])
                - g[j, k].derivative(xs[a])) / 2 for k in range(n)]
              for j in range(n)] for a in range(n)]        # G_(a, jk)
    G0 = [[[first[i][j][k].subs(at0) for k in range(n)] for j in range(n)]
          for i in range(n)]
    dg0 = [matrix(Rn, n, n, lambda i, j: g[i, j].derivative(xs[m]).subs(at0))
           for m in range(n)]
    dG0 = [[[[-sum(dg0[m][i, a] * G0[a][j][k] for a in range(n))
              + first[i][j][k].derivative(xs[m]).subs(at0)
              for k in range(n)] for j in range(n)] for i in range(n)]
           for m in range(n)]
    Ru = [[[[dG0[k][i][q][l] - dG0[l][i][q][k]
             + sum(G0[p][q][l] * G0[i][p][k] - G0[p][q][k] * G0[i][p][l]
                   for p in range(n))
             for l in range(n)] for k in range(n)] for q in range(n)]
          for i in range(n)]
    return G0, Ru


def section_5():
    x, y = var('x y')
    Xc = [x, y]
    n = 2
    # Arbitrary symmetric connection in dimension 2.
    Gam = [[[function(f'G{i}{min(j, k)}{max(j, k)}')(x, y)
             for k in range(n)] for j in range(n)] for i in range(n)]
    Ru = riemann_up(Gam, Xc)
    Tv = [function(f'T{i}')(x, y) for i in range(n)]

    def cov(T, G):   # S[i][l] = nabla_l T^i
        return [[diff(T[i], Xc[l]) + sum(T[p] * G[i][p][l] for p in range(n))
                 for l in range(n)] for i in range(n)]

    def second(T, G, k, l):   # the book's nabla_k nabla_l T^i (p. 362)
        S = cov(T, G)
        return [diff(S[i][l], Xc[k]) + sum(S[p][l] * G[i][p][k]
                                           for p in range(n))
                - sum(S[i][p] * G[p][k][l] for p in range(n))
                for i in range(n)]
    ok = True
    for k in range(n):
        for l in range(n):
            nk = second(Tv, Gam, k, l)
            nl = second(Tv, Gam, l, k)
            for i in range(n):
                ok &= zero_exp(nk[i] - nl[i] - sum(Tv[q] * Ru[i][q][k][l]
                                                   for q in range(n)))
    check(ok, 'p. 362: (nabla_k nabla_l - nabla_l nabla_k) T^i = '
          'R^i_(q, kl) T^q (symmetric connection, n = 2)')
    k, l, i = 0, 1, 0
    expansion = (diff(Tv[i], Xc[k], Xc[l])
                 + sum(diff(Tv[p], Xc[k]) * Gam[i][p][l] for p in range(n))
                 + sum(Tv[p] * diff(Gam[i][p][l], Xc[k]) for p in range(n))
                 + sum(diff(Tv[p], Xc[l]) * Gam[i][p][k] for p in range(n))
                 + sum(Tv[q] * Gam[p][q][l] * Gam[i][p][k] for p in range(n)
                       for q in range(n))
                 - sum(diff(Tv[i], Xc[p]) * Gam[p][k][l] for p in range(n))
                 - sum(Tv[q] * Gam[i][q][p] * Gam[p][k][l] for p in range(n)
                       for q in range(n)))
    check(zero_exp(second(Tv, Gam, k, l)[i] - expansion),
          'p. 362: the printed expansion of nabla_k nabla_l T^i')
    # nonsymmetric connection: the bracket of p. 362
    Gn = [[[function(f'H{i}{j}{k}')(x, y) for k in range(n)]
           for j in range(n)] for i in range(n)]
    diffk = second(Tv, Gn, k, l)[i] - second(Tv, Gn, l, k)[i]
    base = (sum(Tv[p] * (diff(Gn[i][p][l], Xc[k]) - diff(Gn[i][p][k], Xc[l]))
                for p in range(n))
            - sum((Gn[p][k][l] - Gn[p][l][k]) * diff(Tv[i], Xc[p])
                  for p in range(n)))

    def bracket(last):
        return sum(Tv[q] * (Gn[p][q][l] * Gn[i][p][k]
                            - Gn[p][q][k] * Gn[i][p][l]
                            - Gn[i][q][p] * Gn[p][k][l]
                            + Gn[i][q][p] * last(p))
                   for p in range(n) for q in range(n))
    check(zero_exp(diffk - base - bracket(lambda p: Gn[p][l][k])),
          'p. 362 corrected: last term G^i_(qp) G^p_(lk)')
    refuted(zero_exp(diffk - base - bracket(lambda p: Gn[p][k][l])),
            'p. 362 printed: last term G^i_(qp) G^p_(kl) (nonsymmetric)')

    # Theorem 1 (pp. 363-364), arbitrary fields.
    f = function('f')(x, y)
    Xv = [function(f'X{i}')(x, y) for i in range(n)]
    Yv = [function(f'Y{i}')(x, y) for i in range(n)]
    Zv = [function(f'Z{i}')(x, y) for i in range(n)]

    def nab(V, W):
        return [sum(V[kk] * (diff(W[ii], Xc[kk])
                             + sum(W[p] * Gam[ii][p][kk] for p in range(n)))
                    for kk in range(n)) for ii in range(n)]

    def lie(V, W):
        return [sum(V[kk] * diff(W[ii], Xc[kk]) - W[kk] * diff(V[ii], Xc[kk])
                    for kk in range(n)) for ii in range(n)]

    def Rop(V, W, Z):
        a1, a2, a3 = nab(V, nab(W, Z)), nab(W, nab(V, Z)), nab(lie(V, W), Z)
        return [a1[ii] - a2[ii] - a3[ii] for ii in range(n)]
    fX = [f * c for c in Xv]
    fY = [f * c for c in Yv]
    fZ = [f * c for c in Zv]
    Yf = sum(Yv[kk] * diff(f, Xc[kk]) for kk in range(n))
    check(all(zero_exp(e) for e in [lie(fX, Yv)[ii] - f * lie(Xv, Yv)[ii]
                                    + Yf * Xv[ii] for ii in range(n)]),
          'p. 364: [fX, Y] = f[X, Y] - (Yf) X')
    RXYZ = Rop(Xv, Yv, Zv)
    check(all(zero_exp(Rop(Xv, Yv, fZ)[ii] - f * RXYZ[ii]) for ii in range(n)),
          'p. 363, Theorem 1: R(X, Y)(fZ) = f R(X, Y)Z')
    check(all(zero_exp(Rop(fX, Yv, Zv)[ii] - f * RXYZ[ii]) for ii in range(n)),
          'p. 364, Theorem 1: R(fX, Y)Z = f R(X, Y)Z')
    check(all(zero_exp(Rop(Xv, fY, Zv)[ii] - f * RXYZ[ii]) for ii in range(n)),
          'p. 364, Theorem 1: R(X, fY)Z = f R(X, Y)Z')
    check(all(zero_exp(RXYZ[ii] - sum(Ru[ii][q][kk][ll] * Xv[kk] * Yv[ll]
                                      * Zv[q] for q in range(n)
                                      for kk in range(n) for ll in range(n)))
              for ii in range(n)),
          'pp. 364, 370: [R(X, Y)Z]^i = R^i_(q, kl) X^k Y^l Z^q')
    check(all(zero_exp(Ru[ii][q][kk][ll] + Ru[ii][q][ll][kk])
              for ii in range(n) for q in range(n) for kk in range(n)
              for ll in range(n)),
          'p. 364, Theorem 2 (1): R^i_(j, kl) = -R^i_(j, lk)')
    check(all(zero_exp(Ru[ii][j][kk][ll] + Ru[ii][ll][j][kk]
                       + Ru[ii][kk][ll][j])
              for ii in range(n) for j in range(n) for kk in range(n)
              for ll in range(n)),
          'p. 364 corrected, Theorem 2 (2): R^i_(j,kl) + R^i_(l,jk) '
          '+ R^i_(k,lj) = 0 (symmetric connection, n = 2)')

    # Theorem 2, Ricci, Theorem 3 at a point: metric jets, n = 3, 4.
    for nn in (3, 4):
        Rn, xs, g = jet_metric(nn)
        G0, Rj = jet_curvature(Rn, xs, g)
        rng = range(nn)
        # R_(iq, kl)(0) = R^i_(q, kl)(0) since g(0) = E.
        check(all(Rj[i][j][k][l] == -Rj[i][j][l][k] for i in rng for j in rng
                  for k in rng for l in rng),
              f'p. 364, Theorem 2 (1) (n = {nn})')
        check(all(Rj[i][j][k][l] + Rj[i][l][j][k] + Rj[i][k][l][j] == 0
                  for i in rng for j in rng for k in rng for l in rng),
              f'p. 364 corrected, Theorem 2 (2) cyclic identity (n = {nn})')
        check(all(Rj[i][j][k][l] == -Rj[j][i][k][l] for i in rng for j in rng
                  for k in rng for l in rng),
              f'p. 364, Theorem 2 (3): R_(ij, kl) = -R_(ji, kl) (n = {nn})')
        check(all(Rj[i][j][k][l] == Rj[k][l][i][j] for i in rng for j in rng
                  for k in rng for l in rng),
              f'p. 364, Theorem 2 (4): R_(ij, kl) = R_(kl, ij) (n = {nn})')
        ric = [[sum(Rj[i][j][i][l] for i in rng) for l in rng] for j in rng]
        check(all(ric[j][l] == ric[l][j] for j in rng for l in rng),
              f'p. 366: the Ricci tensor is symmetric (n = {nn})')
        at0 = {x_: 0 for x_ in xs}
        d2 = lambda e, a, b: e.derivative(xs[a]).derivative(xs[b]).subs(at0)
        th3 = all(Rj[i][q][k][l] == (d2(g[i, l], q, k) + d2(g[q, k], i, l)
                                     - d2(g[i, k], q, l)
                                     - d2(g[q, l], i, k)) / 2
                  + sum((1 if m == p else 0) * (G0[m][q][k] * G0[p][i][l]
                                                - G0[m][q][l] * G0[p][i][k])
                        for m in rng for p in rng)
                  for i in rng for q in rng for k in rng for l in rng)
        check(th3, f'p. 367, Theorem 3 at a point (n = {nn})')
        if nn == 3:
            # rank of the curvature tensors realized by jets (a = 0).
            zero_a = {v: 0 for v in Rn.gens() if str(v).startswith('a')}
            bvars = [v for v in Rn.gens() if str(v).startswith('b')]
            rows = [[Rn(Rn(Rj[i][q][k][l]).subs(zero_a))
                     .monomial_coefficient(v)
                     for v in bvars] for i in rng for q in rng for k in rng
                    for l in rng]
            check(matrix(QQ, rows).rank() == nn ** 2 * (nn ** 2 - 1) // 12,
                  'p. 370: the realized curvature tensors have dimension 6 '
                  '(n = 3)')
    # Theorem 3 for an arbitrary 2-dimensional metric.
    Ef, Ff, Gf = [function(nm)(x, y) for nm in ('E', 'F', 'G')]
    g = matrix(SR, [[Ef, Ff], [Ff, Gf]])
    G = christoffel(g, Xc)
    Rd = riemann_down(g, riemann_up(G, Xc))
    rhs = lambda i, q, k, l: ((diff(g[i, l], Xc[q], Xc[k])
                               + diff(g[q, k], Xc[i], Xc[l])
                               - diff(g[i, k], Xc[q], Xc[l])
                               - diff(g[q, l], Xc[i], Xc[k])) / 2
                              + sum(g[m, p] * (G[m][q][k] * G[p][i][l]
                                               - G[m][q][l] * G[p][i][k])
                                    for m in range(2) for p in range(2)))
    check(all(zero(Rd[i][q][k][l] - rhs(i, q, k, l)) for i in range(2)
              for q in range(2) for k in range(2) for l in range(2)),
          'p. 367, Theorem 3 (arbitrary metric, n = 2, all components)')
    Rsc = scalar_curvature(g, riemann_up(G, Xc))
    check(zero(Rsc - 2 / g.det() * Rd[0][1][0][1]),
          'p. 369: R = (2/g) R_(12,12) (arbitrary metric, n = 2)')

    # Theorem 4 (pp. 368-369): graphs.
    fg = function('f')(x, y)
    fx, fy = diff(fg, x), diff(fg, y)
    fxx, fxy, fyy = diff(fg, x, 2), diff(fg, x, y), diff(fg, y, 2)
    chain1 = (2 * diff(fx * fy, x, y) - diff(fy ** 2, x, 2)
              - diff(fx ** 2, y, 2)) / 2
    chain2 = diff(fxx * fy + fx * fxy, y) - diff(fy * fxy, x) - diff(
        fx * fxy, y)
    check(zero_exp(chain1 - chain2) and zero_exp(chain2 - (fxx * fyy
                                                           - fxy ** 2)),
          'p. 369: the printed chain = f_xx f_yy - f_xy^2 for every f')
    R2 = PolynomialRing(QQ, 'A,B,Cq,c0,c1,c2,c3,u,v')
    A_, B_, Cq, c0, c1, c2, c3, u, v = R2.gens()
    fpol = (A_ * u ** 2 + 2 * B_ * u * v + Cq * v ** 2) / 2 + (
        c0 * u ** 3 + c1 * u ** 2 * v + c2 * u * v ** 2 + c3 * v ** 3)
    gx = [fpol.derivative(u), fpol.derivative(v)]
    gg = matrix(R2, 2, 2, lambda i, j: (1 if i == j else 0) + gx[i] * gx[j])
    _, Rgr = jet_curvature(R2, [u, v], gg)
    check(Rgr[0][1][0][1] == A_ * Cq - B_ ** 2,
          'p. 369, Theorem 4: R_(12,12) = f_xx f_yy - f_xy^2 = K at a '
          'critical point')
    # R = 2K at every point: jet variables f_ij = d^(i+j) f/dx^i dy^j and
    # the total derivatives D_x, D_y on their rational functions.
    jn = [(i, j) for s_ in range(1, 5) for i in range(s_ + 1)
          for j in [s_ - i]]
    Rj2 = PolynomialRing(QQ, [f'f{i}{j}' for i, j in jn])
    Kj = Rj2.fraction_field()
    fv = {ij: Kj(v) for ij, v in zip(jn, Rj2.gens())}

    def Dtot(e, axis):
        e = Kj(e)
        num, den = e.numerator(), e.denominator()

        def dpol(p):
            out = Kj(0)
            for (i, j), v in zip(jn, Rj2.gens()):
                dp = p.derivative(v)
                if dp != 0:
                    nxt = (i + 1, j) if axis == 0 else (i, j + 1)
                    assert nxt in fv, 'jet order exceeded'
                    out += Kj(dp) * fv[nxt]
            return out
        return (dpol(num) * Kj(den) - Kj(num) * dpol(den)) / Kj(den) ** 2
    f10, f01 = fv[(1, 0)], fv[(0, 1)]
    gj = matrix(Kj, [[1 + f10 ** 2, f10 * f01], [f10 * f01, 1 + f01 ** 2]])
    gji = gj.inverse()
    Gj = [[[sum(gji[i, a] * (Dtot(gj[k, a], j) + Dtot(gj[j, a], k)
                             - Dtot(gj[j, k], a)) for a in range(2)) / 2
            for k in range(2)] for j in range(2)] for i in range(2)]
    Ruj = [[[[Dtot(Gj[i][q][l], k) - Dtot(Gj[i][q][k], l)
              + sum(Gj[p][q][l] * Gj[i][p][k] - Gj[p][q][k] * Gj[i][p][l]
                    for p in range(2))
              for l in range(2)] for k in range(2)] for q in range(2)]
           for i in range(2)]
    Rsj = sum(gji[k, l] * sum(Ruj[i][k][i][l] for i in range(2))
              for k in range(2) for l in range(2))
    Kgauss = (fv[(2, 0)] * fv[(0, 2)] - fv[(1, 1)] ** 2) / (
        1 + f10 ** 2 + f01 ** 2) ** 2
    check(Rsj == 2 * Kgauss,
          'p. 369, Theorem 4: R = 2K at every point of a graph')

    # Examples (p. 369).
    rv, ph = var('rv ph', domain='positive')
    r0 = var('r0', domain='positive')
    for gm, val, label in (
            (matrix(SR, [[1, 0], [0, 1]]), 0, '(1) dx^2 + dy^2: R = 0'),
            (matrix(SR, [[1, 0], [0, sin(rv / r0) ** 2]]), 2 / r0 ** 2,
             '(2) dr^2 + sin^2(r/r0) dphi^2: R = 2/r0^2'),
            (matrix(SR, [[1, 0], [0, sh(rv / r0) ** 2]]), -2 / r0 ** 2,
             '(3) dr^2 + sh^2(r/r0) dphi^2: R = -2/r0^2')):
        Gm = christoffel(gm, [rv, ph])
        check(zero(scalar_curvature(gm, riemann_up(Gm, [rv, ph])) - val),
              'p. 369, example ' + label)
    gbad = matrix(SR, [[1, 0], [0, sh(rv / r0) ** 4]])
    Rbad = scalar_curvature(gbad, riemann_up(christoffel(gbad, [rv, ph]),
                                             [rv, ph]))
    refuted(zero(diff(Rbad, rv)),
            'p. 369 printed: dr^2 + (sh^2(r/r0))^2 dphi^2 has constant R')
    lam = function('lam')(x, y)
    gl = lam * matrix(SR, [[1, 0], [0, 1]])
    Rl = scalar_curvature(gl, riemann_up(christoffel(gl, Xc), Xc))
    check(zero(Rl + (diff(ln(lam), x, 2) + diff(ln(lam), y, 2)) / lam),
          'p. 370, example (4): R = -Delta ln lambda / lambda')

    # p. 370: the number of essential components.
    for nn in range(2, 6):
        idx = list(product(range(nn), repeat=4))
        pos = {t_: i for i, t_ in enumerate(idx)}
        rows = []

        def row(terms):
            r_ = [0] * len(idx)
            for c_, t_ in terms:
                r_[pos[t_]] += c_
            return r_
        for (i, j, k, l) in idx:
            rows.append(row([(1, (i, j, k, l)), (1, (i, j, l, k))]))
            rows.append(row([(1, (i, j, k, l)), (1, (j, i, k, l))]))
            rows.append(row([(1, (i, j, k, l)), (1, (i, l, j, k)),
                             (1, (i, k, l, j))]))
        Ms = matrix(QQ, rows)
        dim = len(idx) - Ms.rank()
        check(dim == nn ** 2 * (nn ** 2 - 1) // 12,
              f'p. 370: N = n^2 (n^2 - 1)/12 (n = {nn})')
        if nn == 3:
            ker = Ms.right_kernel().basis_matrix()
            comps = [(0, 1, 0, 2), (1, 0, 1, 2), (2, 0, 2, 1), (0, 1, 0, 1),
                     (0, 2, 0, 2), (1, 2, 1, 2)]
            check(ker.matrix_from_columns([pos[c_] for c_ in comps]).rank()
                  == 6, 'p. 370: R_12,13; R_21,23; R_31,32; R_12,12; '
                  'R_13,13; R_23,23 are coordinates (n = 3)')

    # pp. 370-371: the curvature in a two-dimensional direction.
    th = var('th', domain='real')
    gsph = r0 ** 2 * matrix(SR, [[1, 0], [0, sin(th) ** 2]])
    Rs = riemann_down(gsph, riemann_up(christoffel(gsph, [th, ph]),
                                       [th, ph]))
    Xs = [1 / r0, 0]
    Ys = [0, 1 / (r0 * sin(th))]                   # orthonormal

    def corrected(Rl_, X_, Y_, nn):
        return sum(Rl_[b][j][k][l] * X_[b] * Y_[j] * X_[k] * Y_[l]
                   for b in range(nn) for j in range(nn) for k in range(nn)
                   for l in range(nn))

    def printed(Rl_, X_, Y_, nn):
        return sum(Rl_[b][j][k][l] * X_[j] * X_[k] * Y_[l] * Y_[b]
                   for b in range(nn) for j in range(nn) for k in range(nn)
                   for l in range(nn))
    check(zero(corrected(Rs, Xs, Ys, 2) - 1 / r0 ** 2),
          'p. 370 corrected: R(sigma) = <R(X, Y)Y; X> = 1/r0^2 on the sphere')
    refuted(zero(printed(Rs, Xs, Ys, 2) - 1 / r0 ** 2),
            'p. 370 printed: <R(X, Y)X; Y> on the sphere (it is -1/r0^2)')
    check(zero(printed(Rs, Xs, Ys, 2) + 1 / r0 ** 2),
          'p. 370 printed reading gives -K on the sphere')
    chi = var('chi', domain='positive')
    gL = matrix(SR, [[1, 0], [0, sh(chi) ** 2]])
    RL = riemann_down(gL, riemann_up(christoffel(gL, [chi, ph]), [chi, ph]))
    check(zero(corrected(RL, [1, 0], [0, 1 / sh(chi)], 2) + 1),
          'p. 370 corrected: R(sigma) = -1 on the Lobachevsky plane')
    # the unit 3-sphere, arbitrary X, Y
    c3, t3 = var('c3 t3', domain='real')
    g3 = matrix(SR, [[1, 0, 0], [0, sin(c3) ** 2, 0],
                     [0, 0, sin(c3) ** 2 * sin(t3) ** 2]])
    C3 = [c3, t3, ph]
    R3l = riemann_down(g3, riemann_up(christoffel(g3, C3), C3))
    Xg = list(var('X0 X1 X2'))
    Yg = list(var('Y0 Y1 Y2'))
    Xv3, Yv3 = vector(SR, Xg), vector(SR, Yg)
    area2 = (Xv3 * g3 * Xv3) * (Yv3 * g3 * Yv3) - (Xv3 * g3 * Yv3) ** 2
    check(zero(corrected(R3l, Xg, Yg, 3) - area2),
          'p. 370 corrected: on the unit 3-sphere <R(X, Y)Y; X> = '
          '|X|^2 |Y|^2 - <X, Y>^2')
    check(zero(printed(R3l, Xg, Yg, 3) + area2),
          'p. 370 printed: <R(X, Y)X; Y> = -(|X|^2 |Y|^2 - <X, Y>^2) on the '
          'unit 3-sphere')
    # Lemma 3: g_ab X^b [R(X, Y)Y]^a with [R(X,Y)Z]^k = R^k_(j,pq) X^p Y^q Z^j
    R3u = riemann_up(christoffel(g3, C3), C3)
    RXYY = [sum(R3u[a][j][p][q] * Xg[p] * Yg[q] * Yg[j] for j in range(3)
                for p in range(3) for q in range(3)) for a in range(3)]
    check(zero(sum(g3[a, b] * Xg[b] * RXYY[a] for a in range(3)
                   for b in range(3)) - corrected(R3l, Xg, Yg, 3)),
          'p. 370 corrected, Lemma 3: g_ab X^b [R(X, Y)Y]^a = '
          'R_(bj, kl) X^b Y^j X^k Y^l')
    # Lemma 4 (p. 371): only R_(12,12) = K (and its symmetric copies).
    R4 = PolynomialRing(QQ, 'K,X1,X2,Y1,Y2')
    K_, X1, X2, Y1, Y2 = R4.gens()
    Rt = {}
    for t_ in product(range(2), repeat=4):
        Rt[t_] = 0
    Rt[(0, 1, 0, 1)] = Rt[(1, 0, 1, 0)] = K_
    Rt[(0, 1, 1, 0)] = Rt[(1, 0, 0, 1)] = -K_
    Xl, Yl = [X1, X2], [Y1, Y2]
    corr4 = sum(Rt[(b, j, k, l)] * Xl[b] * Yl[j] * Xl[k] * Yl[l]
                for (b, j, k, l) in product(range(2), repeat=4))
    prin4 = sum(Rt[(b, j, k, l)] * Xl[j] * Xl[k] * Yl[l] * Yl[b]
                for (b, j, k, l) in product(range(2), repeat=4))
    line2 = K_ * (X2 * X2 * Y1 * Y1 - X2 * X1 * Y2 * Y1 + X1 * X1 * Y2 * Y2
                  - X1 * X2 * Y1 * Y2)
    check(corr4 == K_ * (X1 * Y2 - X2 * Y1) ** 2,
          'p. 371 corrected, Lemma 4: R_(bj,kl) X^b Y^j X^k Y^l = '
          'R_(12,12) (X^1 Y^2 - X^2 Y^1)^2')
    check(corr4 == line2 and line2 == K_ * (X2 * Y1 - Y2 * X1) ** 2,
          'p. 371: the printed four-term line equals the corrected sum')
    refuted(prin4 == line2,
            'p. 371 printed (Lemma 3 reading): R_(bj,kl) X^j X^k Y^l Y^b')
    check(prin4 == -line2, 'p. 371: the printed reading is -R_(12,12)(...)^2')
    first_printed = sum(Rt[(b, j, k, l)] * Xl[j] * Xl[k] * Xl[b] * Xl[l]
                        for (b, j, k, l) in product(range(2), repeat=4))
    refuted(first_printed == line2,
            'p. 371 printed first line R_(bj,kl) X^j X^k X^b X^l (it is 0)')


def main():
    section_1()
    section_2()
    section_3()
    section_4()
    section_5()
    print(f'ok chapter-5: {COUNT[0]} checks')


if __name__ == '__main__':
    main()
