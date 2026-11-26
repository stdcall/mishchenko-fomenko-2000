"""Exact checks of Chapter 3 "Smooth manifolds (general theory)" (Sage).

Run: sage -python checks/sage/chapter-3.py (plain asserts; do not use -O).
The last line of the output is "ok chapter-3: N checks".

Book: A. S. Mishchenko, A. T. Fomenko, Kurs differentsial'noi geometrii i
topologii, 2nd ed., Faktorial Press, 2000, Chapter 3, pp. 95-154.  Pages are
the printed pages; formula numbers restart in every section, so "(7) of § 4"
is formula (7) on p. 147.  The expected values are the book's statements,
written below as literals read off the printed page (charts, transition
maps, Jacobi matrices, bounds); our Typst source is not parsed.  Where the
book is wrong, the printed reading is kept as a refuted check (function
`refuted`: the printed reading must fail) next to the corrected one.
Labels in brackets are those of content/03-*.typ.

What is checked, by section:

§ 1 (content/03-01-manifolds.typ, pp. 97-113)
  * Example 1 (p. 98, exm:circle-atlas): the inverse maps of the four charts
    of S^1 land on the circle; on U_1 & U_3 the transition x_3 = sqrt(1 -
    x_1^2) has a nonzero derivative; the angle charts (p. 99): phi_1 = phi_2
    for y > 0 and phi_1 = phi_2 - 2 pi for y < 0 at the ten points of
    angle k pi/6, k != 0, 6 (a sample, not a proof).
  * Example 4 (pp. 99-100, exm:sphere-atlas): for n <= 4 the inverse maps of
    all 2n + 2 charts land on S^n, and every transition map between charts
    U_i^(+-), U_j (i != j) has Jacobian determinant +-x^j/x^i, nonzero on
    the overlap (so the atlas is smooth, as p. 107 states).
  * Example 5 (pp. 100-101, exm:projective-plane): the printed charts of
    RP^2 and their inverses; the transition maps are rational, mutually
    inverse, with nonzero Jacobian determinant.
  * Example 6 (p. 105, exm:cube-chart): the difference quotient of the cube
    root at 0 tends to +infinity: the transition (6) has no derivative at 0.
  * Example 7 (pp. 106-107, exm:abs-chart): x_2 = x + x|x| and its inverse
    have one-sided first derivatives 1 = 1 and second derivatives of
    opposite signs at 0: the atlas is C^1 and not C^2.
  * p. 108: the stereographic charts; w_0 w_1 = 1 on the sphere; 1/w
    satisfies the Cauchy-Riemann equations (the corrected "complex
    analytic"), while a complex-valued map such as the conjugation does not
    (the printed "complex-valued" alone is refuted as a reason).
  * Lemma 3 (p. 110, lem:chain-rule) and the proof of Theorem 1: d(g o f) =
    dg(f) df for polynomial maps R^2 -> R^3 -> R^2; for y = h(x) the matrix dh
    has m rows and n columns, and d(h o h^(-1)) = E_m on the side of y (the
    corrected roles of x and y, p. 110).
  * Lemma 4 (p. 112, eq:ball-diffeomorphism): the two maps (11) are mutually
    inverse between the unit ball and R^n (n <= 5).
  * Lemma 5 (p. 113): the derivatives of order <= 6 of exp(-1/t^2) tend to
    0 as t -> 0-, so the glued function h is C^6 at the junction (the C^oo
    claim is the standard fact, only its first orders are checked).

§ 2 (content/03-02-equations.typ, pp. 113-118)
  * Example 1 (pp. 113-114): the branches of x^2 - y^2 = c; the gradient
    vanishes only at the origin, which lies on the level c = 0 only.
  * Example 2 (pp. 115-116): grad sum (x^k)^2 does not vanish on S^n, n <= 6.
  * Example 3 (pp. 116-117, exm:special-linear-group): the expansion (2),
    d det/d a_11 = det A_11, (3) at E, and (4): its right side equals det A_0
    (= 1 on SL(n, R)) for generic A_0, n <= 4; the gradient of det is the
    cofactor matrix, nonzero on SL(n, R).
  * p. 117: by the convention of p. 110 (one row per function) the Jacobi
    matrix of one function is the row of its partial derivatives (the rows
    of df on p. 118 are the gradients of f^1, f^2); the printed "column"
    is refuted.
  * Example 4 (p. 118, exm:torus): the printed matrix df; its rank is 2 at
    every point of the torus (Groebner basis).

§ 3 (content/03-03-tangent-vectors.typ, pp. 118-135)
  * p. 119: for a curve with Taylor data x(t_0 + dt) = a + v dt + w dt^2 the
    squared distance to a line through a with unit direction b is
    |v'|^2 dt^2 + 2 (v', w') dt^3 + |w'|^2 dt^4 (v', w' orthogonal to b); on
    the parabola (t, t^2, 0) and its tangent line the distance is dt^2, so
    replacing the increment by its linear part costs dt^2, which is not
    o(dt^2): the printed "= o(dt^2)" (and "(3) = o(dt)") are refuted as
    consequences of (1), (2); the corrected o(dt), o(1) hold.  A line with
    another direction violates (2).
  * (5)-(11), Lemma 1 (pp. 120-123): the velocity of a curve on a concrete
    surface, the change of parameters (10), (11), on polynomial examples.
  * (12), Proposition 1 (pp. 123-124): the velocities of a curve in the three
    charts of RP^2 obey the tensor law; p. 125: the law of the Jacobi
    matrices of a triple change of coordinates for all triples of charts of
    RP^2 (rational identities).
  * Theorem 2 (pp. 126-127, th:osculation-tangent): osculating and
    non-osculating pairs of polynomial curves, also after a change of
    coordinates.
  * Theorem 3 (pp. 128-129): (17)-(19) and the Leibniz rule (20) for
    polynomials.
  * Lemma 3 (pp. 130-131, lem:second-order-expansion): the functions h_i of
    (23)-(25) computed by the integral formula for generic polynomials of
    degree <= 4 in two variables and <= 3 in three; (22), (23), (24), (25)
    are identities.
  * p. 134: the tangent lines of S^1 turned by an angle alpha lie on the
    hyperboloid x^2 + y^2 - z^2 ctg^2 alpha = 1 and are pairwise disjoint
    (Groebner basis); the tangent lines of the helix (cos t, sin t, c t),
    c != 0, at t = +-delta meet iff sin delta - delta cos delta = 0; this
    function has derivative delta sin delta and value pi at pi, so for
    0 < 2 delta <= 2 pi (an arc of the circle) the tangent lines are
    disjoint, while at 3 pi/2 its value is -1 (the whole helix has meeting
    tangent lines); the tangent lines touch the helix (the corrected "не
    исчезло").  The screw motion maps tangent lines to tangent lines, so
    every pair reduces to +-delta.
  * Examples 1, 3 (pp. 134-135): the double pendulum is a regular level set
    of rank 2 in R^4 mapped linearly onto the torus of Example 4 § 2; the
    orthogonal frames: d(A^T A) has rank 6 at every A in O(3), so the
    configuration space of the rigid body has dimension 3; det A = +-1.

§ 4 (content/03-04-submanifolds.typ, pp. 135-154)
  * Lemmas 1, 2 (pp. 137-138): eta(g) = xi(g o f) and the curve version, for
    polynomial maps; p. 139: f(x, y) = (x, y^2) has df = diag(1, 0) at 0;
    Example 4 (p. 141): the Jacobi matrix of X -> AX is A.
  * Example 6 (p. 144): the velocity of (cos phi, sin 2 phi) never vanishes
    (Groebner basis); the curve passes twice through the origin.
  * Lemma 3 (p. 146): a cube of side 1/N has diameter sqrt(n)/N, the image
    interval has length 2 C n^(k/2) / N^k and the N^n intervals have total
    length 2 C n^(k/2) / N^(k-n) -> 0 (k > n); the printed bound
    2 sqrt(n) C / N^(k-n) for one interval and for the sum is refuted
    (n = 2..5, k = n+1..n+3).
  * (7) (p. 147): for f = x^2 y^2 (n = 2, k = 3) the set F of critical
    points is the union of the axes, the origin is in F_3, and a point
    (a, 0), a != 0, lies in F_(0,1) on the curve M_(0,1) = {y = 0, x != 0}
    defined by (7) with the multi-index l in both conditions (the corrected
    reading; (0, a) and M_(1,0) by symmetry).  This illustrates the
    decomposition of F - F_k, it does not prove it.
  * The embedding of RP^2 (pp. 149-151): g is well defined, its image lies
    in y^1 + y^2 + y^3 = 1, which is an affine and not a linear subspace
    (the corrected wording); dg is the printed matrix times
    1/(1 + x_2^2 + x_3^2)^2 (the printed matrix without the factor is
    refuted); the three printed minors and the omitted case x_2 != 0,
    x_3 = 0 (rows 1, 6); rank 2 everywhere in the chart; the coordinate
    functions are permuted by permutations of x_1, x_2, x_3; g(x) = g(x') on
    the sphere forces x' = +-x (radical membership).
  * Theorem 4 (p. 151): for phi = g the vectors zeta of h vanish at xi = 0
    (h is not defined there: the corrected domain U x (R^n - 0)) and are
    homogeneous in xi.
  * p. 152: 2n + 1 is not the minimal dimension: (x^2 - y^2, xy, xz, yz)
    embeds RP^2 in R^4 (immersion and injectivity on RP^2 by Groebner
    bases).
  * pp. 152-154 (eq:metric-change, eq:induced-metric, prop:induced-metric):
    the metric induced on S^2 in the two stereographic charts is
    4/(1 + u^2 + v^2)^2 E and obeys the transformation law (8); the chain
    of equalities of Proposition 1 as a matrix identity.

What these checks do NOT establish.  Every check is a polynomial or
rational-function identity in the written variables (then it holds for all
values where defined), an ideal computation (Groebner basis, saturation,
radical membership) over QQ, an exact symbolic limit or derivative, or a
computation for the listed dimensions, examples and sample points.  Smooth
(non-polynomial) statements are checked on polynomial or rational examples
only; theorems of the book (Sard, Whitney, the implicit function theorem,
partitions of unity) are not proved.  The inequality sin d - d cos d > 0 on
(0, pi] rests on the checked derivative and the sign of sin on (0, pi),
an argument, not a computation.  That RP^2 embeds in R^4 and not in R^3 and
that every compact n-manifold embeds in R^2n are facts of the literature
(Whitney); only the explicit map to R^4 is checked here.
"""
from itertools import permutations, product

from sage.all import (
    QQ, SR, PolynomialRing, QuadraticField, atan2, cos, diff, exp, oo,
    identity_matrix, limit, matrix, pi, sin, sqrt, vector,
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


def jac(fs, xs):
    """Jacobi matrix in the book's convention: one row per function."""
    return matrix([[diff(f, x) for x in xs] for f in fs])


def unit_ideal(ideal):
    return ideal.groebner_basis() == [1]


# ---------------------------------------------------------------------------
# § 1. The concept of a manifold.


def rp2_chart(k, P):
    """phi_k(x_1 : x_2 : x_3): divide by x_k and drop it (k = 0, 1, 2)."""
    return tuple(P[i] / P[k] for i in range(3) if i != k)


def rp2_inverse(k, ab):
    """phi_k^(-1)(a, b): insert 1 at the place k."""
    rest = list(ab)
    rest.insert(k, 1)
    return tuple(rest)


def section_1():
    # Example 1, p. 98: the four charts of the circle.
    x = SR.var('x')
    inverses = [(x, sqrt(1 - x**2)), (x, -sqrt(1 - x**2)),
                (sqrt(1 - x**2), x), (-sqrt(1 - x**2), x)]
    check(all((a**2 + b**2 - 1).simplify_full() == 0 for a, b in inverses),
          'p. 98: phi_k^(-1) lands on x^2 + y^2 = 1')
    # on U_1 & U_3 (x > 0, y > 0): x_3 = y = sqrt(1 - x_1^2)
    dx3 = diff(sqrt(1 - x**2), x)
    check((dx3 + x / sqrt(1 - x**2)).simplify_full() == 0,
          'p. 98: d x_3 / d x_1 = -x_1/sqrt(1 - x_1^2), nonzero on (0, 1)')
    # p. 99: phi_1 in (-pi, pi), phi_2 in (0, 2 pi)
    ok = True
    for k in (1, 2, 3, 4, 5, 7, 8, 9, 10, 11):    # (-1, 0) is not in U_1
        theta = k * pi / 6              # phi_2 of the point
        phi1 = atan2(sin(theta), cos(theta))
        ok &= bool(phi1 == (theta if k < 6 else theta - 2 * pi))
    check(ok, 'p. 99: phi_1 = phi_2 (y > 0), phi_1 = phi_2 - 2 pi (y < 0)')

    # Example 4, pp. 99-100: the 2n + 2 charts of S^n.
    for n in range(1, 5):
        ys = [SR.var(f'y{k}') for k in range(1, n + 1)]
        root = sqrt(1 - sum(y**2 for y in ys))
        ok = True
        for i, sign in product(range(n + 1), (1, -1)):
            X = ys[:i] + [sign * root] + ys[i:]
            ok &= bool((sum(c**2 for c in X) - 1).simplify_full() == 0)
            ok &= X[:i] + X[i + 1:] == ys          # phi_i o phi_i^(-1) = id
            for j in range(n + 1):
                if j == i:
                    continue
                d = jac(X[:j] + X[j + 1:], ys).det()
                ok &= bool((d**2 * X[i]**2 - X[j]**2).simplify_full() == 0)
        check(ok, f'pp. 99-100: S^{n}: inverse charts on S^n, transition '
              'Jacobians +-x^j/x^i')

    # Example 5, pp. 100-101: RP^2.
    K = PolynomialRing(QQ, 'x,y,z,a,b').fraction_field()
    X, Y, Z, a, b = K.gens()
    P = (X, Y, Z)
    check(rp2_chart(0, P) == (Y / X, Z / X)
          and rp2_chart(1, P) == (X / Y, Z / Y)
          and rp2_chart(2, P) == (X / Z, Y / Z),
          'p. 100: phi_1 = (y/x, z/x), phi_2 = (x/y, z/y), phi_3 = (x/z, y/z)')
    check(rp2_inverse(0, (a, b)) == (1, a, b)
          and rp2_inverse(1, (a, b)) == (a, 1, b)
          and rp2_inverse(2, (a, b)) == (a, b, 1)
          and all(rp2_chart(k, rp2_inverse(k, (a, b))) == (a, b)
                  for k in range(3)),
          'p. 101: the printed inverse maps')
    ok = True
    for j, k in permutations(range(3), 2):
        T = rp2_chart(j, rp2_inverse(k, (a, b)))
        back = rp2_chart(k, rp2_inverse(j, T))
        ok &= back == (a, b) and jac(T, (a, b)).det() != 0
    check(ok, 'p. 101: RP^2 transitions rational, inverse, det J != 0')

    # Example 6, p. 105: x_1 = cube root of x_2 at 0.
    check(limit(x**(QQ(1) / 3) / x, x=0, dir='+') == SR('+Infinity'),
          'p. 105: (cube root)(x)/x -> +oo, no derivative at 0')

    # Example 7, pp. 106-107: x_2 = x + x|x| and its inverse.
    right, left = x + x**2, x - x**2               # x >= 0, x <= 0
    yv = SR.var('yv')
    inv_r = (-1 + sqrt(1 + 4 * yv)) / 2            # y >= 0
    inv_l = (1 - sqrt(1 - 4 * yv)) / 2             # y <= 0
    check((right.subs(x=inv_r) - yv).simplify_full() == 0
          and (left.subs(x=inv_l) - yv).simplify_full() == 0,
          'p. 107: the two branches of the inverse transition')

    def at0(f, v, k):
        return diff(f, v, k).subs({v: 0})

    check(at0(right, x, 1) == at0(left, x, 1) == 1
          and at0(inv_r, yv, 1) == at0(inv_l, yv, 1) == 1,
          'p. 107: one-sided first derivatives agree at 0 (C^1)')
    check(at0(right, x, 2) == 2 and at0(left, x, 2) == -2
          and at0(inv_r, yv, 2) == -2 and at0(inv_l, yv, 2) == 2,
          'p. 107: second derivatives jump at 0 (not C^2)')

    # p. 108: stereographic charts and w_0 w_1 = 1.
    G = QuadraticField(-1, 'i')
    i = G.gen()
    R = PolynomialRing(G, 'x,y,z')
    x_, y_, z_ = R.gens()
    sphere = x_**2 + y_**2 + z_**2 - 1
    check((x_ + i * y_) * (x_ - i * y_) - (1 - z_) * (1 + z_) == sphere,
          'p. 108: w_0 w_1 = (x^2 + y^2)/(1 - z^2) = 1 on S^2')
    F = R.fraction_field()
    N = vector(F, [0, 0, 1])
    Pt = vector(F, [x_, y_, z_])
    Q = vector(F, [x_ / (1 - z_), y_ / (1 - z_), 0])
    check(Q - N == (Pt - N) / (1 - z_),
          'p. 108: phi_0 = (x/(1-z), y/(1-z)) is the projection from N')
    Kr = PolynomialRing(QQ, 'p,q').fraction_field()
    p, q = Kr.gens()
    u, v = p / (p**2 + q**2), -q / (p**2 + q**2)   # 1/(p + i q)

    def cauchy_riemann(u, v):
        return (diff(u, p) == diff(v, q)) and (diff(u, q) == -diff(v, p))

    check(cauchy_riemann(u, v), 'p. 108: 1/w is complex analytic')
    refuted(cauchy_riemann(p, -q),
            'p. 108: "complex-valued" transitions give an analytic manifold'
            ' (the conjugation is complex-valued and not analytic)')

    # p. 110: Lemma 3 (chain rule) and Theorem 1.
    Rx = PolynomialRing(QQ, 'x1,x2')
    x1, x2 = Rx.gens()
    f = [x1 * x2, x1 + x2**2, x1**3]                    # R^2 -> R^3
    Ry = PolynomialRing(QQ, 'y1,y2,y3')
    gy = [Ry('y1*y3 - y2^2'), Ry('y1 + y2*y3')]         # R^3 -> R^2
    gof = [g(*f) for g in gy]
    dg_at_f = jac(gy, Ry.gens()).apply_map(lambda e: e(*f))
    check(jac(gof, Rx.gens()) == dg_at_f * jac(f, Rx.gens()),
          'p. 110: d(g o f)(P) = dg(f(P)) df(P)')
    check(jac(f, Rx.gens()).dimensions() == (3, 2),
          'p. 110: dh of y = h(x), R^n -> R^m, has m rows, n columns')
    h = [x1, x2 + x1**2]
    Y2 = PolynomialRing(QQ, 'y1,y2')
    hinv = [Y2('y1'), Y2('y2 - y1^2')]
    e0 = [c(*hinv) for c in h]
    e1 = [c(*h) for c in hinv]
    check(e0 == list(Y2.gens()) and e1 == list(Rx.gens())
          and jac(h, Rx.gens()).apply_map(lambda e: e(*hinv))
          * jac(hinv, Y2.gens()) == identity_matrix(2),
          'pp. 110-111: e_0 = h o h^(-1) on the side of y, d e_0 = E_m')

    # Lemma 4, p. 112: (11) between the unit ball and R^n.
    ok = True
    for n in range(1, 6):
        Kx = PolynomialRing(QQ, n, 'x').fraction_field()
        r2 = sum(t**2 for t in Kx.gens())
        y2 = r2 / (1 - r2)                         # |y|^2 for y = x/sqrt(1-r2)
        ok &= (1 - r2) * (1 + y2) == 1  # 1 + |y|^2 = 1/(1 - r2)
        Ky = PolynomialRing(QQ, n, 'y').fraction_field()
        s2 = sum(t**2 for t in Ky.gens())
        x2n = s2 / (1 + s2)  # |x|^2, x = y/sqrt(1+|y|^2)
        ok &= 1 - x2n == 1 / (1 + s2)              # so |x| < 1
        ok &= (1 - x2n) * (1 + s2) == 1
    check(ok, 'p. 112: the maps (11) are mutually inverse, ball <-> R^n')

    # Lemma 5, p. 113: exp(-1/t^2), t = x - (1 - eps)^2 -> 0-.
    t = SR.var('t')
    bump = exp(-1 / t**2)
    check(all(limit(diff(bump, t, k), t=0, dir='-') == 0 for k in range(7)),
          'p. 113: derivatives of order <= 6 of h vanish at the junction')


# ---------------------------------------------------------------------------
# § 2. Manifolds given by equations.


def cofactor_matrix(A):
    n = A.nrows()
    return matrix(A.base_ring(), n, n,
                  lambda r, c: (-1)**(r + c) * A.delete_rows([r])
                  .delete_columns([c]).det())


def section_2():
    # Example 1, pp. 113-114.
    xs, ys, c = SR.var('xs ys c')
    check(((sqrt(c + ys**2))**2 - ys**2 - c).simplify_full() == 0
          and (xs**2 - (sqrt(xs**2 - c))**2 - c).simplify_full() == 0,
          'p. 113: x = +-sqrt(c + y^2), y = +-sqrt(x^2 - c) on x^2 - y^2 = c')
    R = PolynomialRing(QQ, 'x,y')
    x, y = R.gens()
    f = x**2 - y**2
    crit = R.ideal([diff(f, x), diff(f, y)])
    check(crit == R.ideal([x, y]) and f(0, 0) == 0
          and f == (x - y) * (x + y),
          'pp. 113-114: grad f = 0 only at 0, on the level c = 0 (two lines)')

    # Example 2, pp. 115-116.
    ok = True
    for n in range(1, 7):
        S = PolynomialRing(QQ, n + 1, 'x')
        g = sum(t**2 for t in S.gens())
        grad = [diff(g, t) for t in S.gens()]
        ok &= grad == [2 * t for t in S.gens()]
        ok &= unit_ideal(S.ideal(grad + [g - 1]))
    check(ok, 'pp. 115-116: grad f = (2x^1, ...) != 0 on S^n, n <= 6')

    # Example 3, pp. 116-117: SL(n, R).
    for n in range(2, 5):
        S = PolynomialRing(QQ, [f'a{r}{s}' for r in range(n)
                                for s in range(n)]
                           + [f'c{r}{s}' for r in range(n) for s in range(n)])
        A = matrix(S, n, n, S.gens()[:n * n])
        A0 = matrix(S, n, n, S.gens()[n * n:])
        detA = A.det()
        minors = [A.delete_rows([0]).delete_columns([k]).det()
                  for k in range(n)]
        check(detA == sum((-1)**k * A[0, k] * minors[k] for k in range(n)),
              f'p. 116: expansion (2) of det along the first row, n = {n}')
        check(diff(detA, A[0, 0]) == minors[0]
              and minors[0].subs({A[r, s]: int(r == s) for r in range(n)
                                  for s in range(n)}) == 1,
              f'p. 116: d f/d a_11 = det A_11, (3): = 1 at E, n = {n}')
        # (4): sum_ij df/da_ij(A_0) d a_ij/d b_11 with A = A_0 B; a_ij is
        # linear in B and d a_ij / d b_11 = (A_0)_i1 delta_j1.
        grad_at_A0 = matrix(S, n, n, lambda r, s: diff(detA, A[r, s]).subs(
            {A[u, w]: A0[u, w] for u in range(n) for w in range(n)}))
        rhs = sum(grad_at_A0[r, s] * (A0[r, 0] if s == 0 else 0)
                  for r in range(n) for s in range(n))
        check(rhs == A0.det(),
              f'p. 117: right side of (4) = det A_0 (= 1 on SL), n = {n}')
        check(grad_at_A0 == cofactor_matrix(A0)
              and cofactor_matrix(A0).transpose() * A0
              == A0.det() * identity_matrix(S, n),
              f'p. 117: grad det = cofactors, nonzero when det = 1, n = {n}')

    # p. 117: the Jacobi matrix of one function (convention of p. 110).
    T = PolynomialRing(QQ, 'x1,x2,x3,x4')
    x1, x2, x3, x4 = T.gens()
    f1, f2 = x1**2 + x2**2, x3**2 + x4**2
    df = jac([f1, f2], T.gens())
    check(df == matrix(T, [[2 * x1, 2 * x2, 0, 0], [0, 0, 2 * x3, 2 * x4]]),
          'p. 118: the printed matrix df of the torus')
    check(df.row(0) == vector([diff(f1, t) for t in T.gens()])
          and jac([f1], T.gens()).dimensions() == (1, 4),
          'p. 117: the gradient of one function is the 1 x n row d f')
    refuted(jac([f1], T.gens()).dimensions() == (4, 1),
            'p. 117: the gradient "column" is the Jacobi matrix')
    check(unit_ideal(T.ideal(df.minors(2) + [f1 - 1, f2 - 1])),
          'p. 118: rk df = 2 at every point of the torus')


# ---------------------------------------------------------------------------
# § 3. Tangent vectors.


def section_3():
    # p. 119: the distance (2) and the expansion (1).
    R = PolynomialRing(QQ, 'v1,v2,v3,w1,w2,w3,dt')
    v1, v2, v3, w1, w2, w3, dt = R.gens()
    # b = e_1 after a rotation; the component orthogonal to b:
    incr = vector(R, [v1 * dt + w1 * dt**2, v2 * dt + w2 * dt**2,
                      v3 * dt + w3 * dt**2])
    perp = vector(R, [0, incr[1], incr[2]])         # incr - b (incr, b)
    vp, wp = vector(R, [0, v2, v3]), vector(R, [0, w2, w3])
    check(perp * perp == (vp * vp) * dt**2 + 2 * (vp * wp) * dt**3
          + (wp * wp) * dt**4,
          'p. 119: squared distance to the line = |v\'|^2 dt^2 + O(dt^3)')
    # the parabola (t, t^2, 0) at t_0 = 0, dt = s, with its tangent b = e_1:
    s = SR.var('s')

    def dist_to_line(w, b):                         # |w - b (w, b)|, |b| = 1
        p = w - b * (w * b)
        return sqrt(p * p)

    e1 = vector(SR, [1, 0, 0])
    inc = vector(SR, [s, s**2, 0])                  # x(s) - x(0)
    lin = vector(SR, [s, 0, 0])                     # dx/dt(0) s
    dist, linear_part = dist_to_line(inc, e1), dist_to_line(lin, e1)
    incr_len = sqrt(inc * inc)
    check(limit(dist / incr_len, s=0) == 0,
          'p. 119: (2) holds for the tangent line of the parabola')
    refuted(limit((dist - linear_part) / s**2, s=0) == 0,
            'p. 119: replacing the increment by its linear part costs '
            'o(dt^2), i.e. the printed "= o(dt^2)" and "(3) = o(dt)"')
    check(limit((dist - linear_part) / s, s=0) == 0,
          'p. 119: corrected: the cost is o(dt), whence o(dt) and o(1)')
    # a line with direction b = (3/5, 4/5, 0) violates (2): d/|incr| -> 4/5
    bb = vector(SR, [QQ(3) / 5, QQ(4) / 5, 0])
    check(limit(dist_to_line(inc, bb) / incr_len, s=0) == QQ(4) / 5,
          'p. 119: a non-tangent line violates (2), b not collinear with x\'')

    # (5)-(11), Lemma 1, pp. 120-123, on a polynomial surface.
    S = PolynomialRing(QQ, 't,u,v,up,vp,du,dv')
    t, u, v, up, vp, du, dv = S.gens()
    surf = vector(S, [u + v**2, v - u * v, u**2 * v + v**3])
    xu, xv = surf.apply_map(lambda e: diff(e, u)), \
        surf.apply_map(lambda e: diff(e, v))
    ut, vt = t + 2 * t**2, 3 * t - t**3              # a curve u(t), v(t)
    curve = surf.apply_map(lambda e: e.subs({u: ut, v: vt}))
    vel = curve.apply_map(lambda e: diff(e, t))
    check(vel == xu.apply_map(lambda e: e.subs({u: ut, v: vt})) * diff(ut, t)
          + xv.apply_map(lambda e: e.subs({u: ut, v: vt})) * diff(vt, t),
          'pp. 121-123: dx/dt = x_u du/dt + x_v dv/dt (Lemma 1)')
    U, V = up + vp**2, vp - up**3                    # u(u', v'), v(u', v')
    new = surf.apply_map(lambda e: e.subs({u: U, v: V}))
    lhs = new.apply_map(lambda e: diff(e, up)) * du \
        + new.apply_map(lambda e: diff(e, vp)) * dv
    Du = diff(U, up) * du + diff(U, vp) * dv         # (10)
    Dv = diff(V, up) * du + diff(V, vp) * dv
    rhs = xu.apply_map(lambda e: e.subs({u: U, v: V})) * Du \
        + xv.apply_map(lambda e: e.subs({u: U, v: V})) * Dv
    check(lhs == rhs, 'pp. 121-122: the tangent plane in (u\', v\') and (10)')
    upt, vpt = t - t**2, 2 * t + t**3                # the curve in (u', v')
    uu, vv = U.subs({up: upt, vp: vpt}), V.subs({up: upt, vp: vpt})
    check(diff(uu, t) == diff(U, up).subs({up: upt, vp: vpt}) * diff(upt, t)
          + diff(U, vp).subs({up: upt, vp: vpt}) * diff(vpt, t)
          and diff(vv, t) == diff(V, up).subs({up: upt, vp: vpt})
          * diff(upt, t) + diff(V, vp).subs({up: upt, vp: vpt})
          * diff(vpt, t),
          'p. 122: (11), the velocity in two systems of coordinates')

    # (12), Proposition 1, p. 125: charts of RP^2.
    K = PolynomialRing(QQ, 't,a,b').fraction_field()
    t, a, b = K.gens()
    gamma = (K(1), 1 + t, 2 + t**2)                  # through (1 : 1 : 2)
    xi = []
    for k in range(3):
        c = rp2_chart(k, gamma)
        xi.append(vector(K, [diff(e, t).subs(t=0) for e in c]))
    P0 = [rp2_chart(k, (1, 1, 2)) for k in range(3)]
    ok = True
    for i, j in product(range(3), repeat=2):
        T = rp2_chart(i, rp2_inverse(j, (a, b)))
        J = jac(T, (a, b)).apply_map(lambda e: e.subs({a: P0[j][0],
                                                       b: P0[j][1]}))
        ok &= xi[i] == J * xi[j]
    check(ok, 'p. 124: velocities in the charts of RP^2 obey (12)')
    ok = True
    for i, j, k in product(range(3), repeat=3):
        Tjk = rp2_chart(j, rp2_inverse(k, (a, b)))
        Jik = jac(rp2_chart(i, rp2_inverse(k, (a, b))), (a, b))
        Jij = jac(rp2_chart(i, rp2_inverse(j, (a, b))), (a, b))
        Jjk = jac(Tjk, (a, b))
        ok &= Jik == Jij.apply_map(lambda e: e.subs({a: Tjk[0],
                                                     b: Tjk[1]})) * Jjk
    check(ok, 'p. 125: the Jacobi matrix of a triple change of coordinates')

    # Theorem 2, pp. 126-127: osculating curves.
    Rt = PolynomialRing(QQ, 't')
    t = Rt.gen()

    def osculate(c1, c2):
        """sum (x^k(c1) - x^k(c2))^2 = o(t^2): no terms of degree <= 2."""
        s = sum((e1 - e2)**2 for e1, e2 in zip(c1, c2))
        return s == 0 or s.valuation() > 2

    def velocity(c):
        return [diff(e, t)(0) for e in c]

    g1, g2, g3 = (t, t**2), (t, -t**2), (t, t)
    check(osculate(g1, g2) and velocity(g1) == velocity(g2),
          'p. 127: (t, t^2), (t, -t^2) osculate, equal velocities')
    check(not osculate(g1, g3) and velocity(g1) != velocity(g3),
          'p. 127: (t, t^2), (t, t) do not osculate, velocities differ')

    def change(c):  # (x + y^2, y + x^3)
        return (c[0] + c[1]**2, c[1] + c[0]**3)

    check(osculate(change(g1), change(g2)) and not osculate(change(g1),
                                                            change(g3)),
          'p. 126: osculation does not depend on the coordinates (example)')

    # Theorem 3, pp. 128-129: (17)-(19), (20).
    R2 = PolynomialRing(QQ, 'x,y,t,x0,y0,k1,k2')
    x, y, t, x0, y0, k1, k2 = R2.gens()
    ff, gg = x**3 * y - 2 * y**2 + x, x * y**2 + 3 * x**2

    def along(h):                                   # d/dt h(gamma(t)) at 0
        return diff(h.subs({x: x0 + k1 * t + t**2, y: y0 + k2 * t - t**3}),
                    t).subs({t: 0})

    def dirder(h):
        return (diff(h, x) * k1 + diff(h, y) * k2).subs({x: x0, y: y0})

    check(along(ff) == dirder(ff) and along(ff * gg)
          == ff.subs({x: x0, y: y0}) * dirder(gg)
          + dirder(ff) * gg.subs({x: x0, y: y0}),
          'pp. 128-129: (17)-(19) and the Leibniz rule (20)')

    # Lemma 3, pp. 130-131: Hadamard's lemma for generic polynomials.
    for nv, deg in ((2, 4), (3, 3)):
        mons = [m for m in product(range(deg + 1), repeat=nv)
                if sum(m) <= deg]
        names = ([f'x{k}' for k in range(nv)] + [f'p{k}' for k in range(nv)]
                 + ['t'] + [f'c{m}' for m in range(len(mons))])
        Q = PolynomialRing(QQ, names)
        X = Q.gens()[:nv]
        X0 = Q.gens()[nv:2 * nv]
        tt = Q.gens()[2 * nv]
        cs = Q.gens()[2 * nv + 1:]
        f = sum(cf * Q.prod(X[r]**m[r] for r in range(nv))
                for cf, m in zip(cs, mons))
        seg = {X[r]: X0[r] + tt * (X[r] - X0[r]) for r in range(nv)}
        at0 = {X[r]: X0[r] for r in range(nv)}

        def integral01(e):
            """int_0^1 e dt, e a polynomial in t."""
            pe = e.polynomial(tt)
            return Q(sum(cf * QQ(1) / (k + 1)
                         for k, cf in enumerate(pe.list())))

        h = [integral01(diff(f, X[r]).subs(seg)) for r in range(nv)]
        check(f == f.subs(at0) + sum((X[r] - X0[r]) * h[r]
                                     for r in range(nv)),
              f'p. 131: (23) for generic f of degree {deg} in {nv} variables')
        check(all(h[r].subs(at0) == diff(f, X[r]).subs(at0)
                  for r in range(nv)),
              f'p. 131: (24): h_i(x_0) = df/dx^i (x_0), {nv} variables')
        hh = [[integral01(diff(h[r], X[s]).subs(seg)) for s in range(nv)]
              for r in range(nv)]
        check(all(h[r] == h[r].subs(at0) + sum((X[s] - X0[s]) * hh[r][s]
                                               for s in range(nv))
                  for r in range(nv)),
              f'p. 131: (25) for the functions h_i, {nv} variables')
        check(f == f.subs(at0) + sum((X[r] - X0[r]) * diff(f, X[r]).subs(at0)
                                     for r in range(nv))
              + sum((X[r] - X0[r]) * (X[s] - X0[s]) * hh[r][s]
                    for r in range(nv) for s in range(nv)),
              f'p. 130: the representation (22), {nv} variables')

    # p. 134: T(S^1) turned by an angle alpha (C = cos, S = sin alpha).
    H = PolynomialRing(QQ, 'c1,s1,c2,s2,r1,r2,C,S', order='degrevlex')
    c1, s1, c2, s2, r1, r2, C, S = H.gens()

    def ruling(cc, ss, r):
        return vector(H, [cc - r * ss * C, ss + r * cc * C, r * S])

    L1 = ruling(c1, s1, r1)
    circ = H.ideal([c1**2 + s1**2 - 1, C**2 + S**2 - 1])
    check((S**2 * (L1[0]**2 + L1[1]**2) - C**2 * L1[2]**2 - S**2)
          in circ,
          'p. 134: the turned tangent lines lie on x^2 + y^2 - z^2 ctg^2 '
          'alpha = 1')
    meet = H.ideal(list(L1 - ruling(c2, s2, r2))
                   + [c1**2 + s1**2 - 1, c2**2 + s2**2 - 1,
                      C**2 + S**2 - 1]).saturation(H.ideal([S]))[0]
    check((c1 - c2) in meet.radical() and (s1 - s2) in meet.radical(),
          'p. 134: two turned tangent lines meet only if they coincide')

    # p. 134: the helix (cos t, sin t, c t), c != 0.
    d, s1_, s2_, cc = SR.var('delta sigma1 sigma2 c')

    def tangent(tt, sg):
        return vector(SR, [cos(tt) - sg * sin(tt), sin(tt) + sg * cos(tt),
                           cc * (tt + sg)])

    D = tangent(d, s1_) - tangent(-d, s2_)
    check((D[0] + sin(d) * (s1_ + s2_)).simplify_full() == 0
          and (D[1] - 2 * sin(d) - (s1_ - s2_) * cos(d)).simplify_full() == 0
          and (D[2] - cc * (2 * d + s1_ - s2_)).simplify_full() == 0,
          'p. 134: the tangent lines at +-delta meet iff (c != 0: '
          'sigma2 - sigma1 = 2 delta) sin delta = delta cos delta')
    gfun = sin(d) - d * cos(d)
    check((diff(gfun, d) - d * sin(d)).simplify_full() == 0
          and gfun.subs({d: 0}) == 0 and gfun.subs({d: pi}) == pi
          and gfun.subs({d: pi / 2}) == 1,
          'p. 134: g = sin d - d cos d: g(0) = 0, g\' = d sin d > 0 on '
          '(0, pi): the tangent lines of an arc are disjoint')
    check(gfun.subs({d: 3 * pi / 2}) == -1,
          'p. 134: g(3 pi/2) < 0: on more than a turn tangent lines meet')
    th, tv = SR.var('theta tv')
    screw = tangent(tv, s1_)
    moved = vector(SR, [cos(th) * screw[0] - sin(th) * screw[1],
                        sin(th) * screw[0] + cos(th) * screw[1],
                        screw[2] + cc * th])
    check(all((moved[k] - tangent(tv + th, s1_)[k]).simplify_full()
              .trig_reduce() == 0 for k in range(3)),
          'p. 134: the screw motion maps tangent lines to tangent lines')
    helix = vector(SR, [cos(tv), sin(tv), cc * tv])
    check(all((tangent(tv, 0)[k] - helix[k]).simplify_full() == 0
              and (diff(tangent(tv, s1_)[k], s1_) - diff(helix[k], tv))
              .simplify_full() == 0 for k in range(3)),
          'p. 134: the fibres touch the helix (corrected "не исчезло")')
    refuted(not all((tangent(tv, 0)[k] - helix[k]).simplify_full() == 0
                    for k in range(3)),
            'p. 134: the printed "свойство касания ... исчезло"')

    # Example 1, pp. 134-135: the double pendulum.
    W = PolynomialRing(QQ, 'p1,p2,q1,q2,l1,l2')
    p1, p2, q1, q2, l1, l2 = W.gens()
    eqs = [p1**2 + p2**2 - l1**2, (q1 - p1)**2 + (q2 - p2)**2 - l2**2]
    Jd = jac(eqs, (p1, p2, q1, q2))
    sat = W.ideal(eqs + Jd.minors(2)).saturation(W.ideal([l1 * l2]))[0]
    check(unit_ideal(sat), 'p. 135: double pendulum: rank 2 on the level set')
    Wf = W.fraction_field()
    tor = [Wf(p1) / l1, Wf(p2) / l1, (q1 - p1) / Wf(l2), (q2 - p2) / Wf(l2)]
    check(tor[0]**2 + tor[1]**2 - 1 == Wf(eqs[0]) / l1**2
          and tor[2]**2 + tor[3]**2 - 1 == Wf(eqs[1]) / l2**2,
          'p. 135: (p, q) -> (p/l_1, (q - p)/l_2) maps it onto the torus T^2')

    # Example 3, p. 135: the rigid body, orthonormal frames.
    O = PolynomialRing(QQ, [f'a{r}{s}' for r in range(3) for s in range(3)]
                       + [f'y{r}{s}' for r in range(3) for s in range(3)])
    A = matrix(O, 3, 3, O.gens()[:9])
    Yv = matrix(O, 3, 3, O.gens()[9:])

    def sym(M):
        return [M[r, s] for r in range(3) for s in range(r, 3)]

    dfE = matrix(QQ, [[QQ(e.coefficient(O.gens()[9 + m]))
                       for m in range(9)]
                      for e in sym(Yv + Yv.transpose())])
    check(dfE.rank() == 6, 'p. 135: d(A^T A) at E has rank 6')
    orth = O.ideal(sym(A.transpose() * A - identity_matrix(O, 3)))
    dfA_AY = A.transpose() * (A * Yv) + (A * Yv).transpose() * A
    check(all(e in orth for e in sym(dfA_AY - (Yv + Yv.transpose())))
          and (A.det()**2 - 1) in orth,
          'p. 135: d(A^T A)_A(A Y) = Y + Y^T on O(3): rank 6, dim O(3) = 3;'
          ' det A = +-1')


# ---------------------------------------------------------------------------
# § 4. Submanifolds.


def section_4():
    # Lemmas 1, 2, pp. 137-138.
    R = PolynomialRing(QQ, 'x1,x2,t,k1,k2')
    x1, x2, t, k1, k2 = R.gens()
    f = [x1**2 - x2, x1 * x2 + x2**3, x1]           # M_1 = R^2 -> R^3
    Ry = PolynomialRing(QQ, 'y1,y2,y3')
    g = Ry('y1^2*y3 - y2 + y1*y2*y3')
    P0 = {x1: 1, x2: -2}
    df = jac(f, (x1, x2)).apply_map(lambda e: e.subs(P0))
    xi = vector(R, [k1, k2])
    eta = df * xi                                   # (1)
    Q0 = [e.subs(P0) for e in f]
    dg = vector(R, [diff(g, yy)(*Q0) for yy in Ry.gens()])
    gof = g(*f)
    xi_gof = sum(diff(gof, xx).subs(P0) * k for xx, k in
                 zip((x1, x2), (k1, k2)))
    check(dg * eta == xi_gof, 'p. 137: eta(g) = xi(g o f), (2)')
    curve = {x1: 1 + k1 * t + t**2, x2: -2 + k2 * t + 5 * t**3}
    check(diff(gof.subs(curve), t).subs({t: 0}) == dg * eta,
          'p. 138: eta(g) = d/dt g(f(gamma(t))) at t_0, (4)')
    # p. 139: f(x, y) = (x, y^2).
    S = PolynomialRing(QQ, 'x,y')
    x, y = S.gens()
    J0 = jac([x, y**2], (x, y)).apply_map(lambda e: e(0, 0))
    check(J0 == matrix(QQ, [[1, 0], [0, 0]]) and J0.rank() == 1,
          'p. 139: f(x, y) = (x, y^2): df at 0 is not onto')
    # Example 4, p. 141: a linear map.
    L = PolynomialRing(QQ, 'z1,z2,z3')
    Am = matrix(QQ, [[1, -2, 3], [0, 4, 5]])
    check(jac(list(Am * vector(L, L.gens())), L.gens()) == Am,
          'p. 141: the Jacobi matrix of X -> AX is A')

    # Example 6, p. 144: f(phi) = (cos phi, sin 2 phi), s = sin, c = cos.
    T = PolynomialRing(QQ, 's,c')
    s, c = T.gens()
    vel = [-s, 2 * (c**2 - s**2)]                   # (-sin phi, 2 cos 2 phi)
    check(unit_ideal(T.ideal(vel + [s**2 + c**2 - 1])),
          'p. 144: the velocity of (cos phi, sin 2 phi) never vanishes')
    check(cos(pi / 2) == 0 and sin(2 * (pi / 2)) == 0
          and cos(3 * pi / 2) == 0 and sin(2 * (3 * pi / 2)) == 0,
          'p. 144: phi = pi/2, 3 pi/2 both go to (0, 0): an immersion only')

    # Lemma 3, p. 146: the bound for f(F_k).
    N, C = SR.var('N C')
    ok = True
    for nn in range(1, 7):
        corner = vector(SR, [1 / N] * nn)        # opposite vertices 0, corner
        ok &= bool((corner * corner - nn / N**2).simplify_full() == 0)
    check(ok, 'p. 146: a cube of side 1/N in R^n has diameter sqrt(n)/N')
    ok_sum = True
    printed_one_somewhere = False       # the printed bounds are refuted if
    printed_sum_somewhere = False       # they fail in every tested case
    for nn in range(2, 6):
        for kk in range(nn + 1, nn + 4):
            one = 2 * C * (sqrt(nn) / N)**kk        # one image interval
            total = N**nn * one                     # at most N^n cubes
            ok_sum &= bool((total - 2 * C * nn**(QQ(kk) / 2)
                            / N**(kk - nn)).simplify_full() == 0)
            ok_sum &= bool((one - 2 * C * nn**(QQ(kk) / 2)
                            / N**kk).simplify_full() == 0)
            ok_sum &= bool(limit(total, N=oo) == 0)
            printed = 2 * sqrt(nn) * C / N**(kk - nn)
            printed_one_somewhere |= bool((one - printed).simplify_full()
                                          == 0)
            printed_sum_somewhere |= bool((total - printed).simplify_full()
                                          == 0)
    check(ok_sum, 'p. 146: corrected: each interval 2 C n^(k/2)/N^k, total '
          '2 C n^(k/2)/N^(k-n) -> 0 (n = 2..5, k = n+1..n+3)')
    refuted(printed_one_somewhere,
            'p. 146: printed length 2 sqrt(n) C/N^(k-n) of one interval')
    refuted(printed_sum_somewhere,
            'p. 146: printed sum 2 sqrt(n) C/N^(k-n)')

    # (7), p. 147: f = x^2 y^2 on R^2 (n = 2), k = 3.
    f7 = x**2 * y**2
    crit = S.ideal([diff(f7, x), diff(f7, y)])
    check(crit.radical() == S.ideal([x * y]),
          'p. 147: F = {grad f = 0} is the union of the axes')
    upto3 = [f7.derivative(x, i).derivative(y, j) for i in range(4)
             for j in range(4) if 1 <= i + j <= 3]
    check(all(e(0, 0) == 0 for e in upto3)
          and f7.derivative(y, 2)(1, 0) != 0,
          'p. 147: the origin is in F_3; (a, 0), a != 0, is not')
    A1 = PolynomialRing(QQ, 'a')
    av = A1.gen()
    fy = f7.derivative(y)                            # l = (0, 1)
    grad_fy = [fy.derivative(x), fy.derivative(y)]
    check(fy(av, 0) == 0 and [e(av, 0) for e in grad_fy] == [0, 2 * av**2],
          'p. 147: (a, 0) is in F_(0,1): d f/dy = 0, grad d f/dy != 0, '
          'M_(0,1) = {y = 0, x != 0} a curve (reading l_1, l_2 in (7))')

    # pp. 149-151: the embedding of RP^2 in R^5 subset R^6.
    G = PolynomialRing(QQ, 'X1,X2,X3,lam').fraction_field()
    X1, X2, X3, lam = G.gens()
    den = X1**2 + X2**2 + X3**2
    gmap = [X1**2 / den, X2**2 / den, X3**2 / den, X1 * X2 / den,
            X2 * X3 / den, X3 * X1 / den]
    check(all(e.subs({X1: lam * X1, X2: lam * X2, X3: lam * X3}) == e
              for e in gmap),
          'p. 150: g is well defined on RP^2')
    check(gmap[0] + gmap[1] + gmap[2] == 1,
          'p. 150: the image lies in y^1 + y^2 + y^3 = 1')
    origin = [0] * 6
    refuted(origin[0] + origin[1] + origin[2] == 1,
            'p. 150: "linear subspace": the zero vector is not on '
            'y^1 + y^2 + y^3 = 1 (an affine hyperplane)')
    perm_ok = True
    for sig in permutations((X1, X2, X3)):
        imgs = [e.subs({X1: sig[0], X2: sig[1], X3: sig[2]}) for e in gmap]
        perm_ok &= sorted(map(str, imgs)) == sorted(map(str, gmap))
    check(perm_ok, 'p. 150: the coordinate functions are permuted by '
          'permutations of x_1, x_2, x_3')
    Kc = PolynomialRing(QQ, 'x2,x3')
    u, v = Kc.gens()
    Kf = Kc.fraction_field()
    sden = 1 + u**2 + v**2
    chart = [Kf(1) / sden, u**2 / sden, v**2 / sden, u / sden, u * v / sden,
             v / sden]                               # x_1 = 1
    dg = jac(chart, (u, v))
    printed = matrix(Kf, [[-2 * u, -2 * v],
                          [2 * u * (1 + v**2), -2 * u**2 * v],
                          [-2 * v**2 * u, 2 * v * (1 + u**2)],
                          [1 - u**2 + v**2, -2 * u * v],
                          [v * (1 - u**2 + v**2), u * (1 + u**2 - v**2)],
                          [-2 * u * v, 1 + u**2 - v**2]])
    check(dg == printed / sden**2,
          'p. 150: dg = printed matrix / (1 + x_2^2 + x_3^2)^2')
    refuted(dg == printed, 'p. 150: dg = the printed matrix without factor')
    P = printed.change_ring(Kc)

    def minor(r1, r2):
        return P.matrix_from_rows([r1, r2]).det()

    check(minor(0, 1) == 4 * u * v * sden,
          'p. 150: rows 1, 2: minor 4 x_2 x_3 (1 + x_2^2 + x_3^2)')
    check(minor(3, 5)(0, 0) == 1 and minor(0, 3)(0, v) == 2 * v * (1 + v**2),
          'p. 150: rows 4, 6 at x_2 = x_3 = 0; rows 1, 4 at x_2 = 0')
    check(minor(0, 5)(u, 0) == -2 * u * (1 + u**2),
          'p. 150: the omitted case x_2 != 0, x_3 = 0: rows 1, 6')
    # 1 + x_2^2 + x_3^2 has no real zeros: saturate by it.
    check(unit_ideal(Kc.ideal(P.minors(2)).saturation(
        Kc.ideal([sden.numerator()]))[0]),
          'p. 150: rk dg = 2 at every real point of the chart x_1 = 1')
    B = PolynomialRing(QQ, 'x1,x2,x3,z1,z2,z3')
    xs, zs = B.gens()[:3], B.gens()[3:]
    same = B.ideal([xs[r] * xs[s] - zs[r] * zs[s] for r in range(3)
                    for s in range(r, 3)]
                   + [sum(e**2 for e in xs) - 1, sum(e**2 for e in zs) - 1])
    rad = same.radical()
    check(all(m in rad for m in matrix(B, [xs, zs]).minors(2)),
          'pp. 150-151: g(P) = g(Q) on the sphere forces x\' = +-x')

    # Theorem 4, p. 151: h on U x R^n, with phi = g, n = 2, N = 6.
    Z = PolynomialRing(QQ, 'x2,x3,e1,e2,tt').fraction_field()
    zu, zv, e1, e2, tt = Z.gens()
    zchart = [c.subs({u: zu, v: zv}) for c in chart]
    zeta = jac(zchart, (zu, zv)) * vector(Z, [e1, e2])
    zeta0 = [e.subs({e1: 0, e2: 0}) for e in zeta]
    refuted(any(e != 0 for e in zeta0),
            'p. 151: h defined at xi = 0 (all zeta^k vanish there)')
    check([e.subs({e1: tt * e1, e2: tt * e2}) for e in zeta]
          == [tt * e for e in zeta],
          'p. 151: zeta is homogeneous in xi: h is constant on rays')

    # p. 152: RP^2 embeds in R^4 (the claim "2n + 1 is minimal" refuted).
    E = PolynomialRing(QQ, 'x,y,z,a,b,c')
    x, y, z, a, b, c = E.gens()
    Fm = [x**2 - y**2, x * y, x * z, y * z]
    JF = jac(Fm, (x, y, z))
    aug = JF.stack(matrix(E, [[x, y, z]]))
    sph = x**2 + y**2 + z**2 - 1
    check(unit_ideal(E.ideal(aug.minors(3) + [sph])),
          'p. 152: (x^2 - y^2, xy, xz, yz) is an immersion of S^2 (and RP^2)')
    Fz = [e.subs({x: a, y: b, z: c}) for e in Fm]
    same4 = E.ideal([e - w for e, w in zip(Fm, Fz)]
                    + [sph, a**2 + b**2 + c**2 - 1])
    rad4 = same4.radical()
    injective = (all(m in rad4 for m in matrix(E, [[x, y, z], [a, b, c]])
                     .minors(2))
                 and all(e.subs({x: -x, y: -y, z: -z}) == e for e in Fm))
    check(injective,
          'p. 152: it is even and injective on RP^2: RP^2 embeds in R^4')
    refuted(not injective,
            'p. 152: "минимальная размерность R^(2n+1)": the example RP^2 '
            '(n = 2) of p. 150 does not need R^5')

    # pp. 152-154: the metric induced on S^2, stereographic charts.
    M = PolynomialRing(QQ, 'u,v').fraction_field()
    u, v = M.gens()
    q = 1 + u**2 + v**2
    Xs = vector(M, [2 * u / q, 2 * v / q, (u**2 + v**2 - 1) / q])
    check(Xs * Xs == 1 and (Xs[0] / (1 - Xs[2]), Xs[1] / (1 - Xs[2]))
          == (u, v),
          'p. 108: the inverse of phi_0 lands on S^2')
    Jx = jac(list(Xs), (u, v))
    Hm = Jx.transpose() * Jx
    check(Hm == 4 / q**2 * identity_matrix(M, 2),
          'p. 153: (9): h_ij = sum g_kl dx^k/dy^i dx^l/dy^j = 4/q^2 delta')
    T = (Xs[0] / (1 + Xs[2]), Xs[1] / (1 + Xs[2]))  # phi_1 o phi_0^(-1)
    check(T == (u / (u**2 + v**2), v / (u**2 + v**2)),
          'p. 108: the transition between the stereographic charts')
    JT = jac(T, (u, v))
    H1 = 4 / (1 + T[0]**2 + T[1]**2)**2 * identity_matrix(M, 2)
    check(Hm == JT.transpose() * H1 * JT,
          'p. 153: the law (8) between the two charts')
    # Proposition 1: h^a = J_a^T G^a J_a, G^a = K^T G^b K, K J_a = J_b L
    W = PolynomialRing(QQ, [f'g{r}{s}' for r in range(3) for s in range(3)]
                       + [f'k{r}{s}' for r in range(3) for s in range(3)]
                       + [f'j{r}{s}' for r in range(3) for s in range(2)]
                       + [f'l{r}{s}' for r in range(2) for s in range(2)])
    gens = W.gens()
    Gb = matrix(W, 3, 3, gens[:9])
    Gb = Gb + Gb.transpose()
    Km = matrix(W, 3, 3, gens[9:18])
    Jb = matrix(W, 3, 2, gens[18:24])
    Lm = matrix(W, 2, 2, gens[24:28])
    Wf = W.fraction_field()
    Ja = Km.change_ring(Wf).inverse() * Jb * Lm    # chain rule K J_a = J_b L
    Ga = Km.transpose() * Gb * Km
    check(Ja.transpose() * Ga * Ja == Lm.transpose() * (Jb.transpose() * Gb
                                                        * Jb) * Lm,
          'p. 154: Proposition 1: h^alpha = L^T h^beta L')


def main():
    section_1()
    section_2()
    section_3()
    section_4()
    print(f'ok chapter-3: {COUNT[0]} checks')


if __name__ == '__main__':
    main()
