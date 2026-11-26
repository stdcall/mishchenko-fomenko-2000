"""Exact checks of Chapter 7 "Simplest variational problems of Riemannian
geometry" (Sage).

Run: sage -python checks/sage/chapter-7.py (plain asserts; do not use -O).
The last line of the output is "ok chapter-7: N checks".

Book: A. S. Mishchenko, A. T. Fomenko, Kurs differentsial'noi geometrii i
topologii, 2nd ed., Faktorial Press, 2000, Chapter 7, pp. 407-448.  Pages
are the printed pages.  The expected values are the book's statements,
written below as literals read off the printed page (Lagrangians, Euler
equations, metrics, explicit fields, the rigid-body system and its
integrals); our Typst source is not parsed.  Where the book is wrong, the
printed reading is kept as a refuted check (function `refuted`: the printed
reading must fail) next to the corrected one.  Labels in brackets are those
of content/07-*.typ.

What is checked, by section:

§ 1 (content/07-01-functionals.typ, pp. 407-415)
  * Example (p. 408, exm:arc-length-functional): the length of f(t) =
    (t, 0, 0) is the integral of |f'| (= 1); the printed integrand |f|
    gives 1/2 (refuted); J[f] + J[-f] != J[0] (the functional is not
    linear).
  * p. 409: the Lagrangian sqrt(1 + f_x^2) has Euler expression
    -f_xx/(1 + f_x^2)^(3/2) (extremals: straight lines); p. 409-410: for
    the area functional EG - F^2 = |f_x x f_y|^2 and, for a graph,
    EG - F^2 = 1 + z_x^2 + z_y^2.
  * pp. 412-415, the first variation and the Euler equations (A)
    [eq:euler-equations, th:euler-equations]: for two polynomial
    Lagrangians (n = 1, k = 1 on [0, 1]; n = 2, k = 2 on the unit square),
    concrete f and perturbations eta vanishing on the boundary,
    d/d eps J[f + eps eta] at 0 equals the integral of the Euler expression
    of (A) times eta (exact rational integrals); the remainder
    J[f + eps eta] - J[f] - eps J'[eta] has order >= 2 in eps, so the
    remainder divided by eps tends to 0 (the corrected lim (1/eps) int o(eps)
    on p. 414).  p. 414: int_P^Q of a derivative is the printed bracket
    [.. (Q) - .. (P)]; the printed limits int_Q^P give the opposite sign
    (refuted).

§ 2 (content/07-02-geodesics.typ, pp. 415-424)
  * Lemma (p. 416, lem:length-action-inequality): L^2 < E for (t^2, 0),
    L^2 = E for the unit-speed (t, 0).
  * Theorem 1 (pp. 416-417, th:action-extremals): for a generic metric g_ij
    of two variables (symbolic functions) along a generic curve,
    d/dt(dL/dx'^k) = 2 dg_kj/dx^a x'^a x'^j + 2 g_kj x''^j, the Euler
    expression equals -2 (g_kj x''^j + Gamma_(k,ij) x'^i x'^j), and the two
    printed forms of the quadratic term agree after contraction with
    x'^i x'^j.  The printed sign "- 2 g_kj x''^j" in line 2 is refuted on
    the straight line r = sqrt(1 + t^2), theta = arctan t in polar
    coordinates (a geodesic, residual 4 at t = 0).  On the sphere
    (metric dtheta^2 + sin^2 theta dphi^2) the equator and a meridian are
    extremals of E, the parallel theta = pi/3 is not.
  * Theorem 2 (p. 417, th:length-extremals): on the sphere, for a generic
    curve, EL(length) = EL(E)/(2|x'|) + (dG/dx') G'/(4 G^(3/2)), G = |x'|^2,
    so at constant speed the two Euler systems agree; the printed display
    equals twice EL(length).  The equator reparametrized by phi = t^3 + t
    is an extremal of the length, not of E.
  * Theorem 3 (pp. 418-421, th:geodesic-shortest): Gauss lemma for the
    exponential map of S^2 and S^3 at a pole, f(r, t) = cos r N +
    sin r a(t) with a generic unit curve a(t): <f_r, f_t> = 0, |f_r| = 1,
    f(0, t) = N, f_rr = -f (the radial curves are great circles).  The
    corrected |w'|^2 = |f_r r'|^2 + |f_t|^2 for w(t) = f(r(t), t); the
    printed |w'|^2 = |f_r|^2 + |f_t|^2 (refuted for r = 3t); the printed
    bound int |f_r| dt >= |r(b) - r(a)| fails for the radial segment
    r = 3t, 1/10 <= t <= 1/5 (refuted), the corrected int |r'| dt >=
    |r(b) - r(a)| holds there with equality.
  * Corollary 2 (p. 423, cor:sphere-geodesics): for 2 <= n <= 5 the
    reflection diag(1, 1, -1, ..., -1) of R^(n+1) (corrected from R^n) is
    orthogonal and fixes exactly the plane R^2, so its fixed points on S^n
    form the equator; cos t P + sin t v (P, v orthonormal) lies on S^n and
    has normal acceleration.
  * Proposition (p. 423, prop:action-minimum): in the plane, E(straight
    segment) = d^2 < E of two other curves with the same ends.

§ 3 (content/07-03-minimal-surfaces.typ, pp. 424-430)
  * p. 425: for a generic function f of n - 1 = 2, 3, 4 variables the
    Euler expression of L = sqrt(1 + sum f_i^2) is -sum d/dx^i (f_i/W),
    W^2 = 1 + sum f_i^2, and W^3 sum d/dx^i (f_i/W) = W^2 tr Hess f -
    grad f . Hess f . grad f; with the first and second fundamental forms
    I = 1 + grad f grad f^T, II = Hess f/W this is (n - 1) H W^3, H the mean
    of the principal curvatures (polynomial identities in the jets).
  * Theorem 1 (p. 425, th:minimal-mean-curvature), n = 3: the printed
    expanded expression equals W^3 sum d/dx^i(f_i/W) and f_xx(1 + f_y^2) -
    2 f_x f_y f_xy + f_yy(1 + f_x^2); it equals 2 H W^3 with H = (EN - 2FM +
    GL)/(2(EG - F^2)) of the graph.  Examples: the
    helicoid z = arctan(y/x) and the catenoid z = arccosh sqrt(x^2 + y^2)
    satisfy the equation.
  * pp. 425-426: in conformal coordinates the Euler expression of
    sqrt(EG - F^2), and of the Lagrangian of the "Poyasnenie"
    sqrt((x_u^2 + y_u^2 + z_u^2)(x_v^2 + y_v^2 + z_v^2)), is -Delta r
    (checked on the conformal, non-harmonic inverse stereographic map); the
    printed equations d/du(2 x_u) + d/dv(2 x_v) = 0 are twice these
    (equivalent).  Theorem 3 (p. 426, th:dirichlet-extremals): the Euler
    expression of E + G is -2 Delta r.  Catenoid (cosh v cos u, cosh v
    sin u, v) and helicoid (sinh v cos u, sinh v sin u, u) are conformal,
    harmonic and minimal; (u, v, u^2 - v^2) is harmonic, not conformal, and
    not minimal (H(1, 0) != 0), p. 426-427.
  * p. 427: ((E + G)/2)^2 - (EG - F^2) = ((E - G)/2)^2 + F^2.
  * pp. 429-430 (convexity): the squared inequality and its reduction with
    beta = 1 - alpha (polynomial identities), the boundary values of
    alpha r + beta g, and Lagrange's identity |a|^2 |b|^2 - <a, b>^2 =
    |a x b|^2 behind <a, b> <= |a| |b| for a = (r_x, r_y, -1), b = (g_x,
    g_y, -1).

§ 4 (content/07-04-symplectic.typ, pp. 430-448)
  * p. 430 (def:momentum-energy): for L = g_ij a^i a^j (generic symmetric
    3 x 3 g) p = 2 g a and E = a^i p_i - L = L.
  * p. 431: for the flow of X = (x1^2, -x2), d/dt (dg_t a) at t = 0 is
    (dX/dx) a; Assertion 1 (stmt:invariance-condition): the condition holds
    for L = |a|^2 + |x|^2 and the rotation field, agrees with d/dt
    L(g_t x, dg_t a) for the rotations, and fails for |a|^2 + a_2^2.
  * Theorem 1 (p. 432, th:momentum-projection): for a generic Lagrangian of
    (x1, x2, a1, a2), a generic field X and a generic curve,
    d/dtau(X^i p_i) = [invariance expression] - X^i EL_i (the corrected
    display); the printed "dL/da^k a^k" gives 2(a1^2 - a2^2) for the
    rotation and L = |a|^2 instead of 0 (refuted).
  * Assertion 2 (p. 433, stmt:clairaut) and the examples: X = d/dphi has
    |X| = r and <X, gamma'> = r^2 phi'; circles are geodesics of the
    cylinder, not of the cone r = kz, and the only geodesic parallel of the
    sphere is the equator.
  * Remark (p. 434): in polar coordinates (L = r'^2 + r^2 phi'^2, X =
    d/dphi = d/dx^n) p_phi = 2 r^2 phi' is constant and equal to 2 on the
    line x = 1: the corrected (p, X)' = 0, p_n' = 0 hold, the printed
    (p, X) = 0, p_n = 0 fail (refuted).
  * Theorem 2 (p. 434, th:energy-conservation): for a generic L(x, a) of two
    variables and a generic curve dE/dtau = -x'^i EL_i.
  * pp. 434-437 (def:nondegenerate-lagrangian, th:hamilton-equations):
    Legendre transform of g_ij a^i a^j (a = g^(-1) p/2, H = p g^(-1) p/4,
    a = dH/dp) and of cosh a; for L = g(x) a^2 - U(x), H(x, L_a) = a L_a -
    L, H_p = a, H_x = -L_x and Hamilton's equations are equivalent to the
    Euler equation.  The literal step d/dx (a p) = 0 of p. 437 fails for
    g = 1 + x^2 (refuted); the conclusion L_x = -H_x holds by the chain
    rule.
  * p. 438: the matrix of sum dp_i ^ dx^i (order p1, x1, p2, x2) is the
    printed block matrix; the field dual to dH by the definition of sgrad
    (omega(Y, s) = Y(H)) is (x' = H_p, p' = -H_x), Hamilton's equations;
    the opposite convention gives x' = -H_p (refuted).
  * p. 439: d(omega_i dx^i) = sum_(i<j) (d_i omega_j - d_j omega_i)
    dx^i ^ dx^j against the exterior derivative of Sage on R^3; the printed
    order of the difference is refuted (omega = x dy).  sum dp^i ^ dq^i is
    nondegenerate (det 1, n <= 4) and closed.
  * sgrad (p. 438 def:skew-gradient, p. 440 corrected): for omega = sum
    dp^i ^ dq^i (n = 1, 2) the definition gives sgrad H = (-H_q; H_p) =
    omega^(ij) d_j H, omega^(ij) the entries of the inverse matrix; the
    printed p. 440 relation omega(sgrad f, Y) = Y(f) and vector (H_q; -H_p)
    contradict the definition (refuted).  With the definition the proof of
    Theorem 4 gives (X^i; Y^i) = (-H_q; H_p) = sgrad H; the p. 446
    components; Corollary 2 (p. 448, cor:sgrad-homomorphism)
    sgrad{f, g} = [sgrad f, sgrad g]; the printed p. 440 sign gives
    [sgrad f, sgrad g] = -sgrad{f, g} (refuted).  sgrad H is orthogonal
    to grad H; sgrad(pq) = grad((q^2 - p^2)/2) is a gradient.
  * Theorem 4 (pp. 441-443, th:locally-hamiltonian), n = 2, for a generic
    polynomial field: the printed coefficients of L_X omega and of
    d omega^(1), omega^(1) = sum(Y^i dp^i - X^i dq^i), against Sage's Lie
    derivative and exterior derivative; d omega^(1) = -L_X omega; for
    X = sgrad H, L_X omega = 0 and omega^(1) = dH.
  * Corollary 1 (p. 443, cor:hamiltonian-incompressible), corrected to
    locally Hamiltonian flows: for omega = sqrt(g) dx ^ dy (a concrete
    metric) L_X omega = div_g(X) omega; on the flat torus d/dx is
    divergence-free and locally Hamiltonian (H = -y) but any H with
    sgrad H = d/dx changes by -1 along y -> y + 1, so it is not
    Hamiltonian (the printed "Hamiltonian" refuted for genus 1).
  * p. 443: grad Re f = sgrad(-Im f) for omega = dx ^ dy (f = z^3 + z) and
    the round-metric gradient is sgrad(-Im f) for 4/(1 + x^2 + y^2)^2
    dx ^ dy.
  * Rigid body (pp. 444-445): for n = 3, 4, 5, [X, phi X]_ij =
    (lambda_j - lambda_i) sum_k x_ik x_kj and (phi X)_ij = (lambda_i +
    lambda_j) x_ij (so phi X' = [X, phi X] gives the printed x'_ij; the
    printed "(X')_ij =" is refuted); phi is self-adjoint for tr(XY); the
    printed system for n = 3; tr((phi X)^2) and tr(X phi X) are integrals
    for n = 3, 4.  For the printed system: Q is an integral; the printed
    P = x^2 + y^2 + z^2 is not: X'(P) = 2xyz(l1 - l2)(l1 - l3)(l2 - l3)/
    ((l1 + l2)(l1 + l3)(l2 + l3)), the printed bracket = 0 is refuted
    (it is -2 at l = (1, 2, 3)); the corrected P = x^2 (l1 + l2)^2 +
    y^2 (l1 + l3)^2 + z^2 (l2 + l3)^2 = -tr((phi X)^2)/2 is an integral,
    with the corrected display; Q = -tr(X phi X)/2; grad P x grad Q =
    4(l1 + l2)(l1 + l3)(l2 + l3) X' (so the integrals are independent where
    X' != 0, and i_X' vol = dP ^ dQ/(4(l1 + l2)(l1 + l3)(l2 + l3)): on a
    level ellipsoid of P the flow is Hamiltonian for the form sigma with
    dP ^ sigma = dx ^ dy ^ dz and Hamiltonian Q/(4(..)(..)(..))); div X' =
    0; the flow does not preserve the Euclidean area of the ellipsoids
    (X'(|grad P|^2) != 0 at (1, 1, 1), l = (1, 2, 3)).
  * Poisson bracket (pp. 446-448, def:poisson-bracket,
    prop:poisson-bracket): for n = 1, 2 and generic functions (symbolic):
    {f, g} = omega(sgrad f, sgrad g) = (sgrad f) g = -(sgrad g) f =
    omega^(ak) d_k f d_a g (corrected), the printed omega^(ka) d_k f d_a g
    is refuted ({p, q} = 1, printed -1); skew-symmetry, the Jacobi
    identity, {f, {g, h}} - {g, {f, h}} = [L_f, L_g] h, the chain of the
    proof of Corollary 2; Proposition 2 (prop:poisson-integrals):
    (sgrad H) f = {H, f}; sgrad{q, p} = 0 although q is not an integral of
    sgrad p.  p. 448: [cos phi d/dphi, sin phi d/dphi] = d/dphi, cos and
    sin are derivatives of periodic functions, 1 is not.

What these checks do NOT establish.  Every check is a polynomial or
rational-function identity in the written variables (then it holds for all
values where defined), an identity of symbolic expressions in generic
functions (then it holds for all smooth functions, in the dimension
written), an exact integral, or a computation on the listed examples,
dimensions and sample points.  General statements of the book (the Euler
equations for every Lagrangian and every n, Theorem 3 of § 2 for every
manifold, Theorem 4 of § 4 for every symplectic manifold, Darboux's
theorem, the fundamental lemma of the calculus of variations, local
minimality of minimal surfaces) are checked only in the dimensions and on
the examples listed; analytic points (limits, existence of extremals,
convexity implying a minimum) are arguments of the book, not computations.
The rigid-body integrals are checked as identities in lambda and x, y, z;
their mechanical meaning is not.
"""
from sage.all import (
    I, QQ, SR, Manifold, PolynomialRing, arccosh, arctan, asinh, assume,
    block_diagonal_matrix, cos, cosh, diagonal_matrix, exp, forget, function,
    identity_matrix, integrate, matrix, pi, sin, sinh, sqrt, vector,
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


def zero(expr):
    """Exact zero test of a symbolic expression."""
    e = SR(expr)
    if e.is_trivial_zero() or e.expand().is_trivial_zero():
        return True
    e = e.simplify_full()
    return e.is_trivial_zero() or e.simplify_trig().is_trivial_zero()


def zero_vec(v):
    return all(zero(c) for c in v)


def euler_lagrange(L, xs, vs, curve, t):
    """Euler expressions dL/dx^k - d/dt dL/dv^k of a Lagrangian L written
    in the symbols xs (position) and vs (velocity), along curve(t)."""
    sub = dict(zip(xs, curve))
    sub.update(zip(vs, [c.diff(t) for c in curve]))
    return [L.diff(x).subs(sub) - L.diff(v).subs(sub).diff(t)
            for x, v in zip(xs, vs)]


# ---------------------------------------------------------------------------
# § 1


def integrate_square(p):
    """Integral over [0, 1]^2 of a polynomial in x, y (other variables are
    kept as coefficients)."""
    R = p.parent()
    x, y = R('x'), R('y')
    ix, iy = R.gens().index(x), R.gens().index(y)
    total = R(0)
    for e, c in p.dict().items():
        mono = R({tuple(0 if k in (ix, iy) else e[k]
                        for k in range(len(e))): c})
        total += mono / ((e[ix] + 1) * (e[iy] + 1))
    return total


def section_1():
    t = SR.var('t')
    # Example, p. 408: the length is the integral of |f'|, not of |f|.
    f = vector(SR, [t, 0, 0])
    length = integrate(sqrt(f.diff(t) * f.diff(t)), t, 0, 1)
    check(length == 1, 'p. 408: length of (t, 0, 0) on [0, 1] is 1')
    printed = integrate(t, t, 0, 1)          # |f(t)| = t on [0, 1]
    refuted(printed == length, 'p. 408: int |f(t)| dt as the length')
    check(2 * length != 0, 'p. 408: J[f] + J[-f] != J[0]: J is not linear')

    # p. 409: L = sqrt(1 + f_x^2); Euler expression -f''/(1 + f'^2)^(3/2).
    x = SR.var('x')
    fx = function('f')(x)
    P = SR.var('P')
    L = sqrt(1 + P ** 2)
    el = -(L.diff(P).subs(P == fx.diff(x))).diff(x)
    check(zero(el + fx.diff(x, 2) / (1 + fx.diff(x) ** 2) ** QQ((3, 2))),
          'p. 409: Euler expression of sqrt(1 + f_x^2) is -f_xx/(..)^(3/2)')

    # pp. 409-410: area functional.
    R = PolynomialRing(QQ, 'a1,a2,a3,b1,b2,b3,zx,zy')
    a1, a2, a3, b1, b2, b3, zx, zy = R.gens()
    A, B = vector(R, [a1, a2, a3]), vector(R, [b1, b2, b3])
    check((A * A) * (B * B) - (A * B) ** 2 == A.cross_product(B)
          * A.cross_product(B), 'p. 409: EG - F^2 = |f_x x f_y|^2')
    fxv, fyv = vector(R, [1, 0, zx]), vector(R, [0, 1, zy])
    check((fxv * fxv) * (fyv * fyv) - (fxv * fyv) ** 2 == 1 + zx ** 2
          + zy ** 2, 'p. 410: EG - F^2 = 1 + z_x^2 + z_y^2 for a graph')

    # pp. 412-415, n = 1, k = 1: first variation = int EL * eta.
    J = PolynomialRing(QQ, 't,F,P')
    tt, F, Pp = J.gens()
    Lag = Pp ** 2 + tt * F ** 2 + Pp * F ** 3
    S = PolynomialRing(QQ, 'eps')
    eps = S.gen()
    T = PolynomialRing(S, 't')
    tv = T.gen()
    f0 = tv ** 2 + tv
    eta = tv ** 2 * (1 - tv)
    check(eta(0) == 0 and eta(1) == 0, 'p. 411: eta vanishes on dD')

    def J_of(fun):
        val = Lag(tv, fun, fun.derivative())
        prim = val.integral()
        return prim(1) - prim(0)

    delta = J_of(f0 + eps * eta) - J_of(f0)
    first = delta[1]
    LF, LP = Lag.derivative(F), Lag.derivative(Pp)
    EL = LF(tv, f0, f0.derivative()) - LP(tv, f0, f0.derivative()).derivative()
    prim = (EL * eta).integral()
    check(first == prim(1) - prim(0),
          'pp. 413-415: d/d eps J[f + eps eta] = int (A)-expression * eta, '
          'n = 1')
    check(delta[0] == 0 and (delta - first * eps).valuation() >= 2,
          'p. 414: the remainder is O(eps^2), (1/eps) int o(eps) -> 0')

    # n = 2, k = 2 on the unit square.
    J2 = PolynomialRing(QQ, 'x,y,F1,F2,F1x,F1y,F2x,F2y')
    xx, yy, F1, F2, F1x, F1y, F2x, F2y = J2.gens()
    Lag2 = (F1x ** 2 + F2y ** 2 + F1 * F2 * F1y + xx * F2 ** 2
            + F1x * F2x * F2y + yy * F1 * F2x)
    R2 = PolynomialRing(QQ, 'x,y,eps')
    X, Y, E = R2.gens()
    f1, f2 = X + Y ** 2, X * Y
    bump = X * (1 - X) * Y * (1 - Y)
    e1, e2 = bump, bump * (1 + X)

    def subs2(expr, g1, g2):
        return expr(X, Y, g1, g2, g1.derivative(X), g1.derivative(Y),
                    g2.derivative(X), g2.derivative(Y))

    var_J = integrate_square(subs2(Lag2, f1 + E * e1, f2 + E * e2)
                             - subs2(Lag2, f1, f2))
    first2 = var_J.coefficient({E: 1})
    el_int = R2(0)
    for Fi, Fix, Fiy, ei in ((F1, F1x, F1y, e1), (F2, F2x, F2y, e2)):
        expr = (subs2(Lag2.derivative(Fi), f1, f2)
                - subs2(Lag2.derivative(Fix), f1, f2).derivative(X)
                - subs2(Lag2.derivative(Fiy), f1, f2).derivative(Y))
        el_int += integrate_square(expr * ei)
    check(first2 == el_int, 'pp. 413-415: first variation = int sum_i eta^i '
          '(A)_i, n = 2, k = 2')
    check(var_J.coefficient({E: 0}) == 0, 'p. 413: delta J has no eps^0 term')

    # p. 414: int_P^Q d/dx(g) dx = g(Q) - g(P) (printed bracket); the
    # printed limits int_Q^P give g(P) - g(Q).
    xs = SR.var('xs')
    g = xs ** 2
    P0, Q0 = 0, 1
    bracket = g.subs(xs == Q0) - g.subs(xs == P0)
    check(integrate(g.diff(xs), xs, P0, Q0) == bracket,
          'p. 414: int_P^Q gives [.. (Q) - .. (P)]')
    refuted(integrate(g.diff(xs), xs, Q0, P0) == bracket,
            'p. 414: printed int_Q^P with the bracket [(Q) - (P)]')


# ---------------------------------------------------------------------------
# § 2


def section_2():
    t = SR.var('t')
    # Lemma, p. 416: L^2 <= E.
    for curve, strict in (((t ** 2, 0), True), ((t, 0), False)):
        v = vector(SR, curve).diff(t)
        speed = sqrt(v * v).simplify_full()
        assume(t > 0)
        Lc = integrate(speed.canonicalize_radical(), t, 0, 1)
        forget(t > 0)
        Ec = integrate(v * v, t, 0, 1)
        check((Lc ** 2 < Ec) if strict else (Lc ** 2 == Ec),
              f'p. 416: L^2 <= E for {curve} (L = {Lc}, E = {Ec})')

    # Theorem 1, generic metric of two variables.
    X1, X2, V1, V2 = SR.var('X1 X2 V1 V2')
    xs, vs = [X1, X2], [V1, V2]
    g11, g12, g22 = function('g11'), function('g12'), function('g22')
    G = matrix(SR, [[g11(X1, X2), g12(X1, X2)], [g12(X1, X2), g22(X1, X2)]])
    V = vector(SR, vs)
    L = V * G * V
    x1, x2 = function('x1')(t), function('x2')(t)
    curve = [x1, x2]
    sub = {X1: x1, X2: x2, V1: x1.diff(t), V2: x2.diff(t)}
    xd = [c.diff(t) for c in curve]
    xdd = [c.diff(t, 2) for c in curve]
    Gc = G.subs(sub)

    def dG(k, i, j):
        return G[i, j].diff(xs[k]).subs(sub)

    EL = euler_lagrange(L, xs, vs, curve, t)
    for k in range(2):
        dt_p = L.diff(vs[k]).subs(sub).diff(t)
        check(zero(dt_p - sum(2 * dG(a, k, j) * xd[a] * xd[j]
                              for a in range(2) for j in range(2))
                   - sum(2 * Gc[k, j] * xdd[j] for j in range(2))),
              'p. 416: d/dt dL/dx\'^k = 2 dg_kj/dx^a x\'^a x\'^j + 2 g_kj x\'\'^j')
        line3 = (sum(Gc[k, j] * xdd[j] for j in range(2))
                 + QQ((1, 2)) * sum((2 * dG(i, k, j) - dG(k, i, j))
                                    * xd[i] * xd[j]
                                    for i in range(2) for j in range(2)))
        check(zero(EL[k] + 2 * line3),
              'p. 416: corrected line 2 / line 3: EL_k = -2 (g_kj x\'\'^j + ..)')
        line4 = sum((dG(i, k, j) + dG(j, k, i) - dG(k, i, j)) * xd[i] * xd[j]
                    for i in range(2) for j in range(2))
        check(zero(sum((2 * dG(i, k, j) - dG(k, i, j)) * xd[i] * xd[j]
                       for i in range(2) for j in range(2)) - line4),
              'p. 416: lines 3 and 4 agree after contraction with x\'^i x\'^j')
    # Printed sign in line 2 refuted: polar coordinates, straight line x = 1.
    Rr, Th, VR, VT = SR.var('Rr Th VR VT')
    Lpol = VR ** 2 + Rr ** 2 * VT ** 2
    line = [sqrt(1 + t ** 2), arctan(t)]
    ELp = euler_lagrange(Lpol, [Rr, Th], [VR, VT], line, t)
    check(zero_vec(ELp), 'p. 416: the line x = 1 is an extremal of E (polar)')
    r, th = line
    lhs = Lpol.diff(Rr).subs({Rr: r, VT: th.diff(t)})       # dg_ij/dr x'x'
    printed = lhs - (0 - 2 * r.diff(t, 2))                   # "... - 2 g x''"
    check(printed.subs(t == 0) == 4,
          'p. 416: printed line 2 has residual 4 at t = 0 on a geodesic')
    refuted(zero(printed), 'p. 416: printed "- 2 g_kj x\'\'^j"')

    # Sphere: equator, meridian are extremals of E, a parallel is not.
    Ph, VP = SR.var('Ph VP')
    Lsph = VT ** 2 + sin(Th) ** 2 * VP ** 2
    sx, sv = [Th, Ph], [VT, VP]
    check(zero_vec(euler_lagrange(Lsph, sx, sv, [pi / 2 + 0 * t, t], t)),
          'p. 423: the equator is a geodesic')
    check(zero_vec(euler_lagrange(Lsph, sx, sv, [t, 0 * t], t)),
          'p. 423: a meridian is a geodesic')
    par = euler_lagrange(Lsph, sx, sv, [pi / 3 + 0 * t, t], t)
    check(par[0] == sqrt(3) / 2, 'p. 423: a parallel pi/3 is not a geodesic')

    # Theorem 2: Euler equations of the length on the sphere.
    thf, phf = function('theta')(t), function('phi')(t)
    Gs = VT ** 2 + sin(Th) ** 2 * VP ** 2
    Llen = sqrt(Gs)
    cur = [thf, phf]
    ELlen = euler_lagrange(Llen, sx, sv, cur, t)
    ELE = euler_lagrange(Gs, sx, sv, cur, t)
    sub2 = {Th: thf, Ph: phf, VT: thf.diff(t), VP: phf.diff(t)}
    Gc2 = Gs.subs(sub2)
    for k in range(2):
        extra = Gs.diff(sv[k]).subs(sub2) * Gc2.diff(t) / (4 * Gc2 ** QQ((3, 2)))
        check(zero(ELlen[k] - ELE[k] / (2 * sqrt(Gc2)) - extra),
              'p. 417: EL(length) = EL(E)/(2|x\'|) + (dG/dx\') G\'/(4G^(3/2))')
        printed_disp = (Gs.diff(sx[k]).subs(sub2) / sqrt(Gc2)
                        - (Gs.diff(sv[k]).subs(sub2) / sqrt(Gc2)).diff(t))
        check(zero(printed_disp - 2 * ELlen[k]),
              'p. 417: the printed display is 2 EL(length) (equivalent)')
    repar = [pi / 2 + 0 * t, t ** 3 + t]
    check(zero_vec(euler_lagrange(Llen, sx, sv, repar, t)),
          'Theorem 2: the reparametrized equator is an extremal of L')
    refuted(zero_vec(euler_lagrange(Gs, sx, sv, repar, t)),
            'Theorem 2: ... and of E (it is not: phi\'\' != 0)')

    # Theorem 3: Gauss lemma on S^2 and S^3, exponential map at a pole.
    rr = SR.var('rr')
    u, w = function('u')(t), function('w')(t)
    for a, N in ((vector(SR, [cos(u), sin(u), 0]), vector(SR, [0, 0, 1])),
                 (vector(SR, [cos(u) * cos(w), cos(u) * sin(w), sin(u), 0]),
                  vector(SR, [0, 0, 0, 1]))):
        f = cos(rr) * N + sin(rr) * a
        fr, ft = f.diff(rr), f.diff(t)
        n = len(N) - 1
        check(zero(f * f - 1) and zero(fr * ft) and zero(fr * fr - 1)
              and zero_vec(f.subs(rr == 0) - N)
              and zero_vec(f.diff(rr, 2) + f),
              f'pp. 419-420: Gauss lemma for exp at a pole of S^{n}')
        rt = function('rho')(t)
        om = f.subs(rr == rt)
        dom = om.diff(t)
        corrected = (rt.diff(t) ** 2 * (fr * fr) + ft * ft).subs(rr == rt)
        check(zero(dom * dom - corrected),
              f'p. 421: |w\'|^2 = |f_r r\'|^2 + |f_t|^2 on S^{n}')
    # Printed Pythagoras without r'(t): r = 3t, a constant.
    f2 = cos(rr) * vector(SR, [0, 0, 1]) + sin(rr) * vector(SR, [1, 0, 0])
    om = f2.subs(rr == 3 * t)
    sq = (om.diff(t) * om.diff(t)).simplify_full()
    check(sq == 9, 'p. 421: |w\'|^2 = 9 for the radial path r = 3t')
    refuted(sq == 1 + 0, 'p. 421: printed |w\'|^2 = |f_r|^2 + |f_t|^2 = 1')
    ta, tb = QQ((1, 10)), QQ((1, 5))
    refuted(tb - ta >= abs(3 * tb - 3 * ta),
            'p. 421: printed int_a^b |f_r| dt >= |r(b) - r(a)|')
    check(integrate(3, t, ta, tb) >= abs(3 * tb - 3 * ta)
          and integrate(3, t, ta, tb) == abs(3 * tb - 3 * ta),
          'p. 421: int |r\'| dt >= |r(b) - r(a)|, equality for monotone r')

    # Corollary 2: the reflection of R^(n+1) fixing R^2.
    for n in range(2, 6):
        g = diagonal_matrix(QQ, [1, 1] + [-1] * (n - 1))
        fixed = (g - identity_matrix(QQ, n + 1)).right_kernel()
        e = identity_matrix(QQ, n + 1)
        check(g * g.transpose() == 1 and fixed.dimension() == 2
              and fixed == fixed.ambient_vector_space().subspace([e[0], e[1]]),
              f'p. 423: reflection of R^{n + 1} fixes exactly R^2 (n = {n})')
    Pv = vector(SR, [QQ((1, 3)), QQ((2, 3)), QQ((2, 3)), 0])
    Vv = vector(SR, [QQ((2, 3)), QQ((1, 3)), QQ((-2, 3)), 0])
    gam = cos(t) * Pv + sin(t) * Vv
    check(Pv * Pv == 1 and Vv * Vv == 1 and Pv * Vv == 0
          and zero(gam * gam - 1) and zero_vec(gam.diff(t, 2) + gam),
          'p. 423: cos t P + sin t v (P, v orthonormal) lies on S^3, '
          'acceleration normal')

    # Proposition, p. 423: E of the segment is d^2 and is the least.
    d = 2
    Es = [integrate(vector(SR, c).diff(t) * vector(SR, c).diff(t), t, 0, 1)
          for c in ((d * t, 0), (d * t ** 2, 0), (d * t, t * (1 - t)))]
    check(Es[0] == d ** 2 and Es[1] > Es[0] and Es[2] > Es[0],
          f'p. 423: E(segment) = d^2 < E of other curves ({Es})')


# ---------------------------------------------------------------------------
# § 3


def graph_jets(m):
    """Jets of a graph x^(m+1) = f(x^1, ..., x^m): first derivatives p_i and
    second derivatives h_ij (symmetric)."""
    names = [f'p{i}' for i in range(m)]
    names += [f'h{i}{j}' for i in range(m) for j in range(i, m)]
    R = PolynomialRing(QQ, names)
    p = list(R.gens()[:m])
    H = matrix(R, m, m)
    k = m
    for i in range(m):
        for j in range(i, m):
            H[i, j] = H[j, i] = R.gens()[k]
            k += 1
    return R, p, H


def section_3():
    # p. 425 and Theorem 1: Euler expression and mean curvature of graphs.
    for m in (2, 3, 4):
        xs = SR.var(' '.join(f'y{i}' for i in range(m)))
        Ps = SR.var(' '.join(f'P{i}' for i in range(m)))
        fgen = function('fg')(*xs)
        grad_f = [fgen.diff(w) for w in xs]
        Wf = sqrt(1 + sum(c ** 2 for c in grad_f))
        Lvol = sqrt(1 + sum(c ** 2 for c in Ps))
        el = -sum(Lvol.diff(Ps[i]).subs(dict(zip(Ps, grad_f))).diff(xs[i])
                  for i in range(m))
        div_f = sum((grad_f[i] / Wf).diff(xs[i]) for i in range(m))
        hess = matrix(SR, m, m, lambda i, j: fgen.diff(xs[i]).diff(xs[j]))
        gv = vector(SR, grad_f)
        num = Wf ** 2 * hess.trace() - gv * hess * gv
        check(zero(el + div_f) and zero(div_f * Wf ** 3 - num),
              f'p. 425: Euler expression of the volume is -sum D_i(f_i/W) = '
              f'-(W^2 tr Hess - grad Hess grad)/W^3, n - 1 = {m}')
        # Mean curvature: (n - 1) H = tr(I^-1 II), I = 1 + p p^T, II = H/W.
        R, p, H = graph_jets(m)
        W2 = 1 + sum(pi_ ** 2 for pi_ in p)
        Imat = identity_matrix(R, m) + matrix(R, m, 1, p) * matrix(R, 1, m, p)
        Iinv_num = W2 * identity_matrix(R, m) - matrix(R, m, 1, p) * matrix(
            R, 1, m, p)
        check(Imat * Iinv_num == W2 * identity_matrix(R, m)
              and (Iinv_num * H).trace() == W2 * H.trace() - (
                  vector(p) * H * vector(p)),
              f'Theorem 1: (n - 1) H W^3 = W^2 tr Hess - grad Hess grad, '
              f'n - 1 = {m}')
    # n = 3: the printed expansion and its simplification.
    R, (fx, fy), Hm = graph_jets(2)
    fxx, fxy, fyy = Hm[0, 0], Hm[0, 1], Hm[1, 1]
    printed = (fxx + fxx * fx ** 2 + fxx * fy ** 2 - fx ** 2 * fxx
               - fx * fy * fxy + fyy + fyy * fx ** 2 + fyy * fy ** 2
               - fx * fy * fxy - fy ** 2 * fyy)
    final = fxx * (1 + fy ** 2) - 2 * fx * fy * fxy + fyy * (1 + fx ** 2)
    W2 = 1 + fx ** 2 + fy ** 2
    check(printed == W2 * (fxx + fyy) - (fx ** 2 * fxx + 2 * fx * fy * fxy
                                        + fy ** 2 * fyy),
          'p. 425: printed expansion = W^3 (d/dx(f_x/W) + d/dy(f_y/W))')
    check(printed == final, 'p. 425: = f_xx(1 + f_y^2) - 2 f_x f_y f_xy + '
          'f_yy(1 + f_x^2)')
    E, F, G = 1 + fx ** 2, fx * fy, 1 + fy ** 2
    # L, M, N times W: f_xx, f_xy, f_yy; 2H (EG - F^2) W = E N - 2 F M + G L.
    check(E * fyy - 2 * F * fxy + G * fxx == final and E * G - F ** 2 == W2,
          'Theorem 1: the equation is 2 H W^3 = 0 (graph in R^3)')
    # Examples: helicoid and catenoid as graphs.
    x, y = SR.var('x y')
    assume(x ** 2 + y ** 2 > 1)
    for name, fz in (('helicoid', arctan(y / x)),
                     ('catenoid', arccosh(sqrt(x ** 2 + y ** 2)))):
        gx, gy = fz.diff(x), fz.diff(y)
        ms = (fz.diff(x, 2) * (1 + gy ** 2) - 2 * gx * gy * fz.diff(x, y)
              + fz.diff(y, 2) * (1 + gx ** 2))
        check(zero(ms), f'p. 425: the {name} graph satisfies H = 0')
    forget(x ** 2 + y ** 2 > 1)

    # Conformal coordinates, pp. 425-427.
    u, v = SR.var('u v')

    def forms(r):
        ru, rv = r.diff(u), r.diff(v)
        nn = ru.cross_product(rv)
        return (ru * ru, ru * rv, rv * rv,
                r.diff(u, 2) * nn, r.diff(u).diff(v) * nn, r.diff(v, 2) * nn,
                nn * nn)

    def mean_curv_num(r):
        E_, F_, G_, L_, M_, N_, nn2 = forms(r)
        return E_ * N_ - 2 * F_ * M_ + G_ * L_   # 2H (EG-F^2) |n|

    def laplacian(r):
        return r.diff(u, 2) + r.diff(v, 2)

    for name, r in (('catenoid', vector(SR, [cosh(v) * cos(u),
                                             cosh(v) * sin(u), v])),
                    ('helicoid', vector(SR, [sinh(v) * cos(u),
                                             sinh(v) * sin(u), u]))):
        E_, F_, G_ = forms(r)[:3]
        check(zero(E_ - G_) and zero(F_) and zero_vec(laplacian(r))
              and zero(mean_curv_num(r)),
              f'pp. 426-427: the {name} is conformal, harmonic and minimal')
    r = vector(SR, [u, v, u ** 2 - v ** 2])
    E_, F_, G_ = forms(r)[:3]
    check(zero_vec(laplacian(r)) and not zero(E_ - G_)
          and mean_curv_num(r).subs({u: 1, v: 0}) != 0,
          'p. 427: (u, v, u^2 - v^2) is harmonic, not conformal, not minimal')
    # Euler expression of the area Lagrangian on a conformal map.
    J = SR.var('xu yu zu xv yv zv')
    ru_s, rv_s = vector(SR, J[:3]), vector(SR, J[3:])
    Es, Fs, Gs = ru_s * ru_s, ru_s * rv_s, rv_s * rv_s
    sphere = vector(SR, [2 * u, 2 * v, u ** 2 + v ** 2 - 1]) / (
        1 + u ** 2 + v ** 2)
    E_, F_, G_ = forms(sphere)[:3]
    check(zero(E_ - G_) and zero(F_) and not zero_vec(laplacian(sphere)),
          'p. 425: the inverse stereographic map is conformal, not harmonic')
    sub = dict(zip(J, list(sphere.diff(u)) + list(sphere.diff(v))))

    def on_map(expr):
        # E = G = 4/(1 + u^2 + v^2)^2 > 0 here, so sqrt(E^2) = E.
        return expr.subs(sub).canonicalize_radical()

    for name, Lag, factor in (('sqrt(EG - F^2)', sqrt(Es * Gs - Fs ** 2), 1),
                              ('sqrt(EG) (Poyasnenie)', sqrt(Es * Gs), 1),
                              ('E + G (Dirichlet)', Es + Gs, 2)):
        el = [-(on_map(Lag.diff(J[i])).diff(u)
                + on_map(Lag.diff(J[i + 3])).diff(v)) for i in range(3)]
        check(zero_vec(vector(SR, el) + factor * laplacian(sphere)),
              f'pp. 426: Euler expression of {name} on a conformal map is '
              f'-{factor} Delta r')
    # p. 427: D >= S.
    Rf = PolynomialRing(QQ, 'E,F,G')
    E1, F1, G1 = Rf.gens()
    check(((E1 + G1) / 2) ** 2 - (E1 * G1 - F1 ** 2)
          == ((E1 - G1) / 2) ** 2 + F1 ** 2,
          'p. 427: ((E + G)/2)^2 - (EG - F^2) = ((E - G)/2)^2 + F^2')

    # pp. 429-430: convexity of the area of graphs.
    Rc = PolynomialRing(QQ, 'al,rx,ry,gx,gy,AB')
    al, rx, ry, gx, gy, AB = Rc.gens()
    be = 1 - al
    A2, B2 = 1 + rx ** 2 + ry ** 2, 1 + gx ** 2 + gy ** 2
    lhs2 = 1 + (al * rx + be * gx) ** 2 + (al * ry + be * gy) ** 2
    rhs2 = al ** 2 * A2 + be ** 2 * B2 + 2 * al * be * AB   # AB = |a||b|
    check(lhs2 - al ** 2 * (A2 - 1) - be ** 2 * (B2 - 1)
          == 1 + 2 * al * be * (rx * gx + ry * gy)
          and rhs2 - al ** 2 * (A2 - 1) - be ** 2 * (B2 - 1)
          == al ** 2 + be ** 2 + 2 * al * be * AB,
          'p. 429: the squared inequality')
    check(1 - al ** 2 - be ** 2 == 2 * al * be
          and (al ** 2 + be ** 2 + 2 * al * be * AB) - (1 + 2 * al * be * (
              rx * gx + ry * gy)) == 2 * al * be * (AB - 1 - rx * gx
                                                     - ry * gy),
          'p. 429: with 1 - alpha^2 - beta^2 = 2 alpha beta: '
          '1 + r_x g_x + r_y g_y <= sqrt(..) sqrt(..)')
    a = vector(Rc, [rx, ry, -1])
    b = vector(Rc, [gx, gy, -1])
    check(a * b == 1 + rx * gx + ry * gy and a * a == A2 and b * b == B2
          and (a * a) * (b * b) - (a * b) ** 2
          == a.cross_product(b) * a.cross_product(b),
          'p. 429: <a, b> <= |a||b| (Lagrange identity), a = grad(r - z)')
    Rb = PolynomialRing(QQ, 'al,fb')
    alb, fb = Rb.gens()
    check(alb * fb + (1 - alb) * fb == fb,
          'p. 429: (alpha r + beta g)|dD = f|dD')


# ---------------------------------------------------------------------------
# § 4: symplectic helpers


def canonical(n, R=QQ):
    """Matrix of sum dp^i ^ dq^i in the coordinates (p^1..p^n, q^1..q^n),
    omega(u, v) = u^T A v."""
    Z = matrix(R, n, n)
    One = identity_matrix(R, n)
    return block_matrix_2x2(Z, One, -One, Z)


def block_matrix_2x2(A, B, C, D):
    top = A.augment(B)
    bot = C.augment(D)
    return top.stack(bot)


def section_4():
    # p. 430: momentum and energy of g_ij a^i a^j.
    Rg = PolynomialRing(QQ, 'g11,g12,g13,g22,g23,g33,a1,a2,a3')
    g11, g12, g13, g22, g23, g33, a1, a2, a3 = Rg.gens()
    g = matrix(Rg, [[g11, g12, g13], [g12, g22, g23], [g13, g23, g33]])
    a = vector(Rg, [a1, a2, a3])
    L = a * g * a
    p = vector(Rg, [L.derivative(ai) for ai in a])
    check(p == 2 * g * a and a * p - L == L,
          'p. 430: p = 2 g a, E = a^i p_i - L = g_ij a^i a^j')

    # p. 431: linearized flow of X = (x1^2, -x2).
    t, x1, x2, b1, b2 = SR.var('t x1 x2 b1 b2')
    flow = vector(SR, [x1 / (1 - t * x1), x2 * exp(-t)])
    Xf = vector(SR, [x1 ** 2, -x2])
    check(zero_vec(flow.diff(t) - Xf.subs({x1: flow[0], x2: flow[1]}))
          and zero_vec(flow.subs(t == 0) - vector(SR, [x1, x2])),
          'p. 431: g_t is the flow of X = (x1^2, -x2)')
    Jt = matrix(SR, [[c.diff(x) for x in (x1, x2)] for c in flow])
    bb = vector(SR, [b1, b2])
    DX = matrix(SR, [[c.diff(x) for x in (x1, x2)] for c in Xf])
    check(zero_vec((Jt * bb).diff(t).subs(t == 0) - DX * bb),
          'p. 431: da^i/dt = dX^i/dx^k a^k')
    # Assertion 1 with the rotations.
    rot = vector(SR, [-x2, x1])
    Drot = matrix(SR, [[c.diff(x) for x in (x1, x2)] for c in rot])

    def invariance(Lag):
        return (sum(Lag.diff(x) * rot[i] for i, x in enumerate((x1, x2)))
                + sum(Lag.diff(bb[i]) * (Drot * bb)[i] for i in range(2)))

    Linv = b1 ** 2 + b2 ** 2 + x1 ** 2 + x2 ** 2
    check(zero(invariance(Linv)), 'p. 431: Assertion 1 for |a|^2 + |x|^2')
    gt = matrix(SR, [[cos(t), -sin(t)], [sin(t), cos(t)]])
    moved = Linv.subs(dict(zip((x1, x2, b1, b2),
                               list(gt * vector(SR, [x1, x2]))
                               + list(gt * bb))))
    check(zero(moved.diff(t).subs(t == 0) - invariance(Linv))
          and zero(moved - Linv),
          'p. 431: the condition is d/dt L(g_t x, dg_t a) at t = 0')
    refuted(zero(invariance(b1 ** 2 + 2 * b2 ** 2)),
            'p. 431: the condition for the non-invariant |a|^2 + a_2^2')

    # Theorem 1 (p. 432) for a generic Lagrangian and field.
    tau = SR.var('tau')
    Y1, Y2, A1, A2 = SR.var('Y1 Y2 A1 A2')
    Lf = function('Lag')(Y1, Y2, A1, A2)
    Xg = [function('Xa')(Y1, Y2), function('Xb')(Y1, Y2)]
    c1, c2 = function('c1')(tau), function('c2')(tau)
    sub = {Y1: c1, Y2: c2, A1: c1.diff(tau), A2: c2.diff(tau)}
    pvec = [Lf.diff(A).subs(sub) for A in (A1, A2)]
    ELg = euler_lagrange(Lf, [Y1, Y2], [A1, A2], [c1, c2], tau)
    inv = (sum(Lf.diff(Y) * Xg[i] for i, Y in enumerate((Y1, Y2)))
           + sum(Lf.diff(Aa) * Xg[i].diff(Yk) * Ak
                 for i, Aa in enumerate((A1, A2))
                 for Yk, Ak in ((Y1, A1), (Y2, A2)))).subs(sub)
    proj = sum(Xg[i].subs(sub) * pvec[i] for i in range(2))
    check(zero(proj.diff(tau) - inv + sum(Xg[i].subs(sub) * ELg[i]
                                          for i in range(2))),
          'p. 432: (X^i p_i)\' = [Assertion 1 expression] - X^i EL_i')
    printed = (sum(Linv.subs({x1: 0, x2: 0}).diff(x) * rot[i]
                   for i, x in enumerate((x1, x2)))
               + sum(Drot[i, k] * (b1 ** 2 + b2 ** 2).diff(bb[k]) * bb[k]
                     for i in range(2) for k in range(2)))
    check(zero(printed - 2 * (b1 ** 2 - b2 ** 2)),
          'p. 432: printed line 2 is 2(a1^2 - a2^2) for |a|^2, rotations')
    refuted(zero(printed), 'p. 432: printed "dL/da^k a^k" vanishes')
    line = vector(SR, [1, tau])
    Lpos = 2 * (rot.subs({x1: 1, x2: tau}) * line.diff(tau))
    check(Lpos == 2, 'p. 432: X^i p_i = 2 along the line (1, tau)')

    # Assertion 2 (Clairaut) and examples, p. 433.
    z, Ph, Vz, Vp = SR.var('z Ph Vz Vp')
    rz = function('rgen')(z)
    gsurf = diagonal_matrix(SR, [1 + rz.diff(z) ** 2, rz ** 2])
    Xrot = vector(SR, [0, 1])
    check(zero(Xrot * gsurf * Xrot - rz ** 2)
          and zero(Xrot * gsurf * vector(SR, [Vz, Vp]) - rz ** 2 * Vp),
          'p. 433: |X| = r, <X, gamma\'> = r^2 phi\'')
    kk = SR.var('kk')
    for name, prof, is_geod in (('cylinder', 2 + 0 * z, True),
                                ('cone r = kz', kk * z, False)):
        Lrev = (1 + prof.diff(z) ** 2) * Vz ** 2 + prof ** 2 * Vp ** 2
        el = euler_lagrange(Lrev, [z, Ph], [Vz, Vp], [1 + 0 * tau, tau], tau)
        if is_geod:
            check(zero_vec(el), f'p. 433: circles are geodesics of the {name}')
        else:
            check(zero(el[0] - 2 * kk ** 2) and zero(el[1]),
                  f'p. 434: circles are not geodesics of the {name} (k != 0)')
    for z0 in (0, QQ((1, 2))):
        prof = sqrt(1 - z ** 2)
        Lrev = (1 + prof.diff(z) ** 2) * Vz ** 2 + prof ** 2 * Vp ** 2
        el = euler_lagrange(Lrev, [z, Ph], [Vz, Vp], [z0 + 0 * tau, tau], tau)
        check(zero(el[0] + 2 * z0) and zero(el[1]),
              f'p. 433: on the parallel z = {z0} of S^2 the Euler expression '
              f'is ({-2 * z0}, 0): only the equator is a geodesic')

    # Remark, p. 434: polar coordinates, X = d/dphi.
    Rr, Th, VR, VT = SR.var('Rr Th VR VT')
    Lpol = VR ** 2 + Rr ** 2 * VT ** 2
    path = [sqrt(1 + tau ** 2), arctan(tau)]
    check(zero_vec(euler_lagrange(Lpol, [Rr, Th], [VR, VT], path, tau)),
          'p. 434: the line x = 1 is an extremal (polar coordinates)')
    p_phi = Lpol.diff(VT).subs({Rr: path[0], VT: path[1].diff(tau)})
    check(zero(p_phi - 2) and zero(p_phi.diff(tau)) and Lpol.diff(Th) == 0,
          'p. 434: corrected (p, X)\' = 0, p_n\' = 0 (p_phi = 2)')
    refuted(zero(p_phi), 'p. 434: printed (p, X) = 0, p_n = 0')

    # Theorem 2, p. 434: energy conservation, generic L.
    sub_v = {A1: c1.diff(tau), A2: c2.diff(tau)}
    Ecur = (sum(Lf.diff(Aa) * Aa for Aa in (A1, A2)) - Lf).subs(sub)
    check(zero(Ecur.diff(tau) + c1.diff(tau) * ELg[0]
               + c2.diff(tau) * ELg[1]),
          'p. 434: dE/dtau = -x\'^i EL_i, so E is constant on extremals')
    del sub_v

    # pp. 434-437: Legendre transform and Hamilton's equations.
    Rl = PolynomialRing(QQ, 'g11,g12,g22,p1,p2').fraction_field()
    G11, G12, G22, P1, P2 = Rl.gens()
    gm = matrix(Rl, [[G11, G12], [G12, G22]])
    pv = vector(Rl, [P1, P2])
    av = gm.inverse() * pv / 2
    Hm = pv * av - av * gm * av
    check(Hm == pv * gm.inverse() * pv / 4 and vector(
        Rl, [Hm.derivative(P1), Hm.derivative(P2)]) == av
          and 2 * gm * av == pv,
          'p. 437: L = g a a: a = g^-1 p/2, H = p g^-1 p/4, a = dH/dp')
    aa, pp = SR.var('aa pp')
    Hc = pp * asinh(pp) - sqrt(1 + pp ** 2)
    a_of_p = asinh(pp)                       # solves p = dL/da = sinh a
    check(zero(cosh(aa).diff(aa).subs(aa == a_of_p) - pp)
          and zero(Hc - (pp * a_of_p - cosh(a_of_p)))
          and zero(Hc.diff(pp) - a_of_p),
          'p. 435: Legendre transform of cosh a: H = p a - L, a = dH/dp')
    xx = SR.var('xx')
    gx, Ux = function('gm')(xx), function('U')(xx)
    Lx = gx * aa ** 2 - Ux
    Hx = pp ** 2 / (4 * gx) + Ux
    pa = Lx.diff(aa)
    check(zero(Hx.subs(pp == pa) - (aa * pa - Lx))
          and zero(Hx.diff(pp).subs(pp == pa) - aa)
          and zero(Hx.diff(xx).subs(pp == pa) + Lx.diff(xx)),
          'pp. 436-437: H(x, L_a) = a L_a - L, H_p = a, H_x = -L_x')
    pa_c = (1 + xx ** 2) * 2 * aa             # p = L_a for g = 1 + x^2
    check(zero((aa * pa_c).diff(xx) - 4 * xx * aa ** 2),
          'p. 437: d/dx(a p) = 4 x a^2 for g = 1 + x^2 (a fixed)')
    refuted(zero((aa * pa_c).diff(xx)),
            'p. 437: literal d/dx(a^i p_i) = 0 (g = 1 + x^2)')
    xt = function('xt')(tau)
    ptraj = pa.subs(aa == xt.diff(tau)).subs(xx == xt)
    el1 = euler_lagrange(Lx, [xx], [aa], [xt], tau)[0]
    check(zero(ptraj.diff(tau) + Hx.diff(xx).subs(pp == pa).subs(
        aa == xt.diff(tau)).subs(xx == xt) + el1)
          and zero(Hx.diff(pp).subs(pp == ptraj).subs(xx == xt)
                   - xt.diff(tau)),
          'Theorem 3: Hamilton\'s equations <=> Euler equation, L = g a^2 - U')

    # p. 438: matrix of sum dp_i ^ dx^i, dual of dH.
    blk = matrix(QQ, [[0, 1], [-1, 0]])
    A438 = block_diagonal_matrix([blk, blk])     # order p1, x1, p2, x2
    M4 = Manifold(4, 'TM', structure='smooth')
    C4 = M4.chart('pa xa pb xb')
    cf = [C4.coframe()[i] for i in range(4)]
    om438 = cf[0].wedge(cf[1]) + cf[2].wedge(cf[3])
    check(all(om438[i, j].expr() == A438[i, j] for i in range(4)
              for j in range(4)) and A438.det() == 1,
          'p. 438: matrix of dp_i ^ dx^i is the printed block matrix')
    Hxs = SR.var('Hp1 Hx1 Hp2 Hx2')        # partial derivatives of H
    gradH = vector(SR, Hxs)
    s = A438.change_ring(SR).inverse() * gradH       # omega(Y, s) = Y(H)
    check(zero_vec(s - vector(SR, [-Hxs[1], Hxs[0], -Hxs[3], Hxs[2]])),
          'p. 438: dual of dH by the definition: x\' = H_p, p\' = -H_x')
    s_alt = -s                                       # omega(s, Y) = Y(H)
    refuted(zero(s_alt[1] - Hxs[0]),
            'p. 440 convention: x\' = -H_p is not Hamilton\'s equation')

    # p. 439: exterior derivative of a 1-form.
    M3 = Manifold(3, 'R3', structure='smooth')
    C3 = M3.chart('x y z')
    x, y, zz = C3[:]
    comps = [x * y ** 2 + zz ** 3, x ** 2 * zz + y, x * y * zz + x ** 4]
    w1 = M3.diff_form(1)
    for i in range(3):
        w1[i] = comps[i]
    dw = w1.exterior_derivative()
    co = (x, y, zz)
    check(all(zero(dw[i, j].expr() - (comps[j].diff(co[i])
                                       - comps[i].diff(co[j])))
              for i in range(3) for j in range(i + 1, 3)),
          'p. 439: d omega^(1) = sum_(i<j) (d_i omega_j - d_j omega_i) '
          'dx^i ^ dx^j (Sage)')
    w2 = M3.diff_form(1)
    w2[1] = x                                        # x dy
    dw2 = w2.exterior_derivative()
    check(dw2[0, 1].expr() == 1, 'p. 439: d(x dy) = dx ^ dy')
    refuted(dw2[0, 1].expr() == (0 - 1),
            'p. 439: printed (d_j omega_i - d_i omega_j) for x dy')
    for n in range(1, 5):
        check(canonical(n).det() == 1
              and canonical(n).transpose() == -canonical(n),
              f'p. 439: sum dp^i ^ dq^i is nondegenerate, n = {n}')
    check(om438.exterior_derivative() == 0, 'p. 439: sum dp ^ dq is closed')

    # sgrad: definition (p. 438) and p. 440 (corrected).
    for n in (1, 2):
        A = canonical(n).change_ring(SR)
        Hd = vector(SR, SR.var(' '.join(f'Hp{i} ' for i in range(n))
                               + ' '.join(f'Hq{i}' for i in range(n))))
        Yv = vector(SR, SR.var(' '.join(f'Y{i}' for i in range(2 * n))))
        sg = A.inverse() * Hd
        expected = vector(SR, [-Hd[n + i] for i in range(n)]
                          + [Hd[i] for i in range(n)])
        check(zero(Yv * A * sg - Yv * Hd) and zero_vec(sg - expected),
              f'p. 440: omega(Y, sgrad H) = Y(H), sgrad H = (-H_q; H_p), '
              f'n = {n}')
        winv = A.inverse()
        check(zero_vec(sg - vector(SR, [sum(winv[i, j] * Hd[j]
                                            for j in range(2 * n))
                                        for i in range(2 * n)])),
              f'p. 440: (sgrad f)^i = omega^(ij) d_j f, n = {n}')
        printed = -expected                         # (H_q; -H_p)
        refuted(zero(Yv * A * printed - Yv * Hd),
                f'p. 440: printed (H_q; -H_p) against the definition, n = {n}')
        check(zero(sg * Hd), f'p. 440: sgrad H is orthogonal to grad H, '
              f'n = {n}')
    pq, qq = SR.var('pq qq')
    Hpq = pq * qq
    sg_pq = vector(SR, [-Hpq.diff(qq), Hpq.diff(pq)])
    pot = (qq ** 2 - pq ** 2) / 2
    check(zero_vec(sg_pq - vector(SR, [pot.diff(pq), pot.diff(qq)])),
          'p. 440: sgrad(pq) = grad((q^2 - p^2)/2) is a gradient')

    # Theorem 4, pp. 441-443, n = 2, coordinates (p1, q1, p2, q2).
    M = Manifold(4, 'R4', structure='smooth')
    C = M.chart('p1 q1 p2 q2')
    p1, q1, p2, q2 = C[:]
    dp = [C.coframe()[0], C.coframe()[2]]
    dq = [C.coframe()[1], C.coframe()[3]]
    idx_p, idx_q = (0, 2), (1, 3)
    om = dp[0].wedge(dq[0]) + dp[1].wedge(dq[1])
    P, Q = (p1, p2), (q1, q2)
    Xc = [p1 * q2 ** 2 + q1 * p2, p2 * q1 ** 2 + p1 ** 3 * q2]
    Yc = [q1 * q2 + p2 ** 2 * p1, p1 * p2 * q1 + q2 ** 3]
    vf = M.vector_field(Xc[0], Yc[0], Xc[1], Yc[1])
    Lom = om.lie_derivative(vf)

    def comp(form, i, j):
        return form[i, j].expr()

    ok = True
    for k in range(2):
        for i in range(2):
            ok &= zero(comp(Lom, idx_p[k], idx_q[i])
                       - (Xc[i].diff(P[k]) + Yc[k].diff(Q[i])))
    ok &= zero(comp(Lom, idx_q[0], idx_q[1])
               - (Xc[1].diff(Q[0]) - Xc[0].diff(Q[1])))
    ok &= zero(comp(Lom, idx_p[0], idx_p[1])
               - (Yc[0].diff(P[1]) - Yc[1].diff(P[0])))
    check(ok, 'p. 442: the printed coefficients of d/dt omega^(2) (Lie '
          'derivative)')
    w1 = M.diff_form(1)
    for i in range(2):
        w1[idx_p[i]] = Yc[i]
        w1[idx_q[i]] = -Xc[i]
    dw1 = w1.exterior_derivative()
    ok = zero(comp(dw1, idx_p[0], idx_p[1])
              - (Yc[1].diff(P[0]) - Yc[0].diff(P[1])))
    for k in range(2):
        for i in range(2):
            # dq^k ^ dp^i coefficient
            val = (comp(dw1, idx_q[k], idx_p[i]) if idx_q[k] < idx_p[i]
                   else -comp(dw1, idx_p[i], idx_q[k]))
            ok &= zero(val - (Yc[i].diff(Q[k]) + Xc[k].diff(P[i])))
    ok &= zero(comp(dw1, idx_q[0], idx_q[1])
               - (Xc[0].diff(Q[1]) - Xc[1].diff(Q[0])))
    check(ok, 'p. 442: the printed coefficients of d omega^(1)')
    check(dw1 == -Lom, 'p. 442: d omega^(1) = -L_X omega^(2): the two '
          'conditions are equivalent')
    Hc = p1 ** 2 * q2 + q1 ** 3 * p2 + p1 * p2 * q1 * q2
    sgH = M.vector_field(-Hc.diff(q1), Hc.diff(p1), -Hc.diff(q2), Hc.diff(p2))
    w1H = M.diff_form(1)
    for i in range(2):
        w1H[idx_p[i]] = sgH[idx_q[i]].expr()        # Y^i = q-component
        w1H[idx_q[i]] = -sgH[idx_p[i]].expr()       # X^i = p-component
    dH = M.scalar_field(Hc).differential()
    check(om.lie_derivative(sgH) == 0 and w1H == dH,
          'p. 443: for X = sgrad H (definition): L_X omega = 0, '
          'omega^(1) = dH')
    w1Hp = M.diff_form(1)                           # printed p. 440 field
    for i in range(2):
        w1Hp[idx_p[i]] = -sgH[idx_q[i]].expr()
        w1Hp[idx_q[i]] = sgH[idx_p[i]].expr()
    refuted(w1Hp == dH, 'p. 440: printed (H_q; -H_p) with omega^(1) = dH')

    # Corollary 1, p. 443.
    M2 = Manifold(2, 'S', structure='smooth')
    C2 = M2.chart('x y')
    xs, ys = C2[:]
    lam = 4 / (1 + xs ** 2 + ys ** 2) ** 2
    gmet = M2.riemannian_metric('g')
    gmet[0, 0], gmet[1, 1] = lam, lam
    V = M2.vector_field(-ys * xs, xs ** 3 + ys)
    vol = gmet.volume_form()
    check(zero(vol.lie_derivative(V)[0, 1].expr() - V.div(gmet).expr()
               * vol[0, 1].expr()),
          'p. 443: L_X (sqrt(g) dx ^ dy) = div_g(X) sqrt(g) dx ^ dy')
    flat = M2.riemannian_metric('h')
    flat[0, 0], flat[1, 1] = 1, 1
    dx_field = M2.vector_field(1, 0)
    Htor = -ys
    check(dx_field.div(flat).expr() == 0 and zero_vec(
        vector(SR, [-Htor.diff(ys), Htor.diff(xs)]) - vector(SR, [1, 0])),
          'p. 443: d/dx on the torus: div = 0, locally sgrad(-y)')
    check(integrate(-1, ys, 0, 1) == -1,
          'p. 443: sgrad H = d/dx forces H_y = -1: H(x, y + 1) - H(x, y) = -1')
    refuted(integrate(-1, ys, 0, 1) == 0,
            'p. 443: printed "Hamiltonian" (periodic H exists) for g = 1')

    # p. 443: grad Re f is Hamiltonian.
    xr, yr = SR.var('xr yr')
    zc = xr + I * yr
    uu = (xr ** 3 - 3 * xr * yr ** 2 + xr)
    vv = (3 * xr ** 2 * yr - yr ** 3 + yr)
    check(zero((zc ** 3 + zc).expand() - (uu + I * vv)),
          'p. 443: f = z^3 + z = u + iv')
    lamr = 4 / (1 + xr ** 2 + yr ** 2) ** 2
    du = vector(SR, [uu.diff(xr), uu.diff(yr)])
    dmv = vector(SR, [(-vv).diff(xr), (-vv).diff(yr)])
    for name, dens in (('dx ^ dy', 1), ('the round area form', lamr)):
        Aform = dens * matrix(SR, [[0, 1], [-1, 0]])
        grad_u = (dens * identity_matrix(SR, 2)).inverse() * du
        check(zero_vec(Aform.inverse() * dmv - grad_u),
              f'p. 443: grad Re f = sgrad(-Im f) for {name} (metric '
              f'{dens} (dx^2 + dy^2))')

    rigid_body()
    poisson()


def rigid_body():
    # [X, phi X] and phi X for n = 3, 4, 5.
    for n in (3, 4, 5):
        names = [f'l{i}' for i in range(n)]
        names += [f'x{i}{j}' for i in range(n) for j in range(i + 1, n)]
        R = PolynomialRing(QQ, names)
        lam = R.gens()[:n]
        X = matrix(R, n, n)
        k = n
        for i in range(n):
            for j in range(i + 1, n):
                X[i, j], X[j, i] = R.gens()[k], -R.gens()[k]
                k += 1
        Im = diagonal_matrix(R, lam)
        phiX = X * Im + Im * X
        br = X * phiX - phiX * X
        check(all(phiX[i, j] == (lam[i] + lam[j]) * X[i, j]
                  and br[i, j] == (lam[j] - lam[i]) * sum(
                      X[i, kk] * X[kk, j] for kk in range(n))
                  for i in range(n) for j in range(n))
              and phiX.transpose() == -phiX,
              f'p. 444: (phi X)_ij = (l_i + l_j) x_ij, [X, phi X]_ij = '
              f'(l_j - l_i) sum x_ik x_kj, n = {n}')
        if n == 5:
            continue
        Ry = PolynomialRing(R, [f'y{i}{j}' for i in range(n)
                                for j in range(i + 1, n)])
        Y = matrix(Ry, n, n)
        k = 0
        for i in range(n):
            for j in range(i + 1, n):
                Y[i, j], Y[j, i] = Ry.gens()[k], -Ry.gens()[k]
                k += 1
        Xy, Iy = X.change_ring(Ry), Im.change_ring(Ry)
        check(((Y * Iy + Iy * Y) * Xy).trace() == (Y * (Xy * Iy + Iy * Xy))
              .trace(), f'p. 444: phi is self-adjoint for tr(XY), n = {n}')
        F = R.fraction_field()
        Xd = matrix(F, n, n, lambda i, j: (br[i, j] / (lam[i] + lam[j])
                                           if i != j else 0))
        Mphi = phiX.change_ring(F)
        Md = Xd * Im + Im * Xd
        check(Md == br and ((Md * Mphi).trace() == 0)
              and (Xd * Mphi + X * Md).trace() == 0,
              f'p. 445: phi X\' = [X, phi X] has the integrals tr((phi X)^2), '
              f'tr(X phi X), n = {n}')
        if n == 3:
            printed_first = [Xd[0, 1], Xd[0, 2], Xd[1, 2]]
            check(printed_first[0] == (lam[1] - lam[0]) / (lam[1] + lam[0])
                  * X[0, 2] * X[2, 1]
                  and printed_first[1] == (lam[2] - lam[0]) / (lam[2] + lam[0])
                  * X[0, 1] * X[1, 2]
                  and printed_first[2] == (lam[2] - lam[1]) / (lam[2] + lam[1])
                  * X[1, 0] * X[0, 2], 'p. 444: the printed x\'_12, x\'_13, '
                  'x\'_23')
            refuted(all(br[i, j] == Xd[i, j] for i in range(3)
                        for j in range(3)),
                    'p. 444: printed "(X\')_ij = sum (x_ik (phi X)_kj - ..)"')

    # The printed system for n = 3.
    R = PolynomialRing(QQ, 'l1,l2,l3,x,y,z')
    l1, l2, l3, x, y, z = R.gens()
    F = R.fraction_field()
    a, b, c = l1 + l2, l1 + l3, l2 + l3
    v = vector(F, [(l1 - l2) / a * y * z, (l3 - l1) / b * x * z,
                   (l2 - l3) / c * y * x])
    X = matrix(R, [[0, x, y], [-x, 0, z], [-y, -z, 0]])
    Im = diagonal_matrix(R, [l1, l2, l3])
    phiX = X * Im + Im * X
    br = X * phiX - phiX * X
    check(v == vector(F, [br[0, 1] / a, br[0, 2] / b, br[1, 2] / c]),
          'p. 444: the printed system x\' = .., y\' = .., z\' = ..')

    def deriv(fun):
        return sum(F(fun).derivative(w) * v[i] for i, w in enumerate((x, y, z)))

    Q = x ** 2 * a + y ** 2 * b + z ** 2 * c
    check(deriv(Q) == 0, 'p. 445: X\'(Q) = 2xyz(l1 - l2 + l3 - l1 + l2 - l3) '
          '= 0')
    Pp = x ** 2 + y ** 2 + z ** 2
    first = 2 * x * y * z * ((l1 - l2) / a + (l3 - l1) / b + (l2 - l3) / c)
    bracket = ((l1 - l2) * b * c + (l3 - l1) * a * c + (l2 - l3) * a * b)
    check(deriv(Pp) == first and first == 2 * x * y * z / (a * b * c)
          * bracket, 'p. 445: the first two equalities for X\'(P)')
    check(bracket == (l1 - l2) * (l1 - l3) * (l2 - l3)
          and bracket(1, 2, 3, 0, 0, 0) == -2
          and deriv(Pp)(1, 2, 3, 1, 1, 1) == QQ((-1, 15)),
          'p. 445: X\'(P) = 2xyz (l1 - l2)(l1 - l3)(l2 - l3)/(..)(..)(..), '
          'bracket -2 at l = (1, 2, 3)')
    refuted(deriv(Pp) == 0, 'p. 444-445: printed P = x^2 + y^2 + z^2 is an '
            'integral (the bracket = 0)')
    Pc = x ** 2 * a ** 2 + y ** 2 * b ** 2 + z ** 2 * c ** 2
    corrected = l1 ** 2 - l2 ** 2 + l3 ** 2 - l1 ** 2 + l2 ** 2 - l3 ** 2
    check(deriv(Pc) == 2 * x * y * z * (a * (l1 - l2) + b * (l3 - l1)
                                        + c * (l2 - l3))
          and a * (l1 - l2) + b * (l3 - l1) + c * (l2 - l3) == corrected
          and corrected == 0,
          'p. 445 (corrected): X\'(P) = 2xyz(l1^2 - l2^2 + l3^2 - l1^2 + '
          'l2^2 - l3^2) = 0')
    check(-(phiX * phiX).trace() / 2 == Pc and -(X * phiX).trace() / 2 == Q,
          'p. 444: P = -tr((phi X)^2)/2, Q = -tr(X phi X)/2')
    gP = vector(F, [F(Pc).derivative(w) for w in (x, y, z)])
    gQ = vector(F, [F(Q).derivative(w) for w in (x, y, z)])
    check(gP.cross_product(gQ) == 4 * a * b * c * v,
          'p. 445: grad P x grad Q = 4(l1 + l2)(l1 + l3)(l2 + l3) X\' '
          '(i_X\' vol = dP ^ dQ/(4abc))')
    check(gP.cross_product(gQ)(1, 2, 3, 1, 1, 1) != 0,
          'p. 445: P, Q independent at (1, 1, 1), l = (1, 2, 3)')
    check(sum(v[i].derivative(w) for i, w in enumerate((x, y, z))) == 0,
          'p. 445: div X\' = 0')
    check(deriv(gP * gP)(1, 2, 3, 1, 1, 1) != 0,
          'p. 445: the flow does not preserve the Euclidean area of the '
          'level ellipsoids of P')


def poisson():
    for n in (1, 2):
        qs = SR.var(' '.join(f'p{i}' for i in range(n)) + ' '
                    + ' '.join(f'q{i}' for i in range(n)))
        qs = list(qs) if n > 1 else list(qs)
        A = canonical(n).change_ring(SR)
        Ainv = A.inverse()
        f, g, h = (function(nm)(*qs) for nm in ('f', 'g', 'h'))

        def grad(F):
            return vector(SR, [F.diff(w) for w in qs])

        def sg(F):
            return Ainv * grad(F)

        def sg_printed(F):
            return -sg(F)

        def apply(vec, F):
            return sum(vec[i] * F.diff(w) for i, w in enumerate(qs))

        def pb(F, G):
            return sg(F) * A * sg(G)

        def lie(Vv, Ww):
            return vector(SR, [apply(Vv, Ww[i]) - apply(Ww, Vv[i])
                               for i in range(2 * n)])

        check(zero(pb(f, g) - apply(sg(f), g))
              and zero(pb(f, g) + apply(sg(g), f)),
              f'p. 446: {{f, g}} = (sgrad f) g = -(sgrad g) f, n = {n}')
        corrected = sum(Ainv[al, k] * f.diff(qs[k]) * g.diff(qs[al])
                        for k in range(2 * n) for al in range(2 * n))
        printed = sum(Ainv[k, al] * f.diff(qs[k]) * g.diff(qs[al])
                      for k in range(2 * n) for al in range(2 * n))
        check(zero(pb(f, g) - corrected),
              f'p. 446: {{f, g}} = omega^(ak) d_k f d_a g (corrected), n = {n}')
        refuted(zero(pb(f, g) - printed),
                f'p. 446: printed {{f, g}} = omega^(ka) d_k f d_a g, n = {n}')
        check(zero_vec(sg(g) - vector(SR, [-g.diff(qs[n + i]) for i in range(n)]
                                      + [g.diff(qs[i]) for i in range(n)])),
              f'p. 446: (sgrad g) = (-g_q; g_p), n = {n}')
        check(zero(pb(f, g) + pb(g, f)), f'p. 446: skew-symmetry, n = {n}')
        jac = pb(h, pb(f, g)) + pb(g, pb(h, f)) + pb(f, pb(g, h))
        check(zero(jac), f'p. 446: Jacobi identity, n = {n}')
        check(zero(pb(f, pb(g, h)) - pb(g, pb(f, h))
                   - (apply(sg(f), apply(sg(g), h))
                      - apply(sg(g), apply(sg(f), h)))),
              f'p. 447: {{f, {{g, h}}}} - {{g, {{f, h}}}} = [L_f, L_g] h, n = {n}')
        check(zero_vec(sg(pb(f, g)) - lie(sg(f), sg(g)))
              and zero(apply(sg(pb(f, g)), h) - pb(pb(f, g), h))
              and zero(pb(pb(f, g), h) + pb(h, pb(f, g))),
              f'p. 448: sgrad{{f, g}} = [sgrad f, sgrad g] (definition), '
              f'n = {n}')
        Fbr = sg_printed(f) * A * sg_printed(g)
        refuted(zero_vec(sg_printed(Fbr) - lie(sg_printed(f), sg_printed(g))),
                f'p. 448 with the printed p. 440 sign: homomorphism, n = {n}')
        check(zero(apply(sg(h), f) - pb(h, f)),
              f'p. 448: (sgrad H) f = {{H, f}}, n = {n}')
    pv, qv = SR.var('pv qv')
    A1 = canonical(1).change_ring(SR)

    def pb1(F, G):
        s1 = A1.inverse() * vector(SR, [F.diff(pv), F.diff(qv)])
        s2 = A1.inverse() * vector(SR, [G.diff(pv), G.diff(qv)])
        return s1 * A1 * s2

    Ainv1 = A1.inverse()
    check(pb1(pv, qv) == 1 and Ainv1[1, 0] == 1,
          'p. 446: {p, q} = 1 = omega^(ak) d_k p d_a q (k = p, a = q)')
    refuted(Ainv1[0, 1] == 1, 'p. 446: printed omega^(ka) d_k p d_a q = -1')
    # Corollary 2 with the printed p. 440 sign, f = p^2, g = q (n = 1).
    sgd = (lambda F: Ainv1 * vector(SR, [F.diff(pv), F.diff(qv)]))

    def bracket_vf(Vv, Ww):
        return vector(SR, [sum(Vv[m] * Ww[i].diff(w) - Ww[m] * Vv[i].diff(w)
                               for m, w in enumerate((pv, qv)))
                           for i in range(2)])

    fb = pb1(pv ** 2, qv)
    check(fb == 2 * pv and sgd(fb) == bracket_vf(sgd(pv ** 2), sgd(qv))
          and sgd(fb) == vector(SR, [0, 2]),
          'p. 448: sgrad{p^2, q} = [sgrad p^2, sgrad q] = (0, 2)')
    refuted(-sgd(fb) == bracket_vf(-sgd(pv ** 2), -sgd(qv)),
            'p. 448 with the printed p. 440 sign: sgrad{p^2, q} = [..]')
    sp = Ainv1 * vector(SR, [1, 0])                 # sgrad p
    check(pb1(qv, pv) == -1 and sp * vector(SR, [0, 1]) == 1,
          'p. 448: sgrad{q, p} = 0, but (sgrad p) q = 1: q is not an '
          'integral')
    ph = SR.var('ph')
    Pf, Qf = cos(ph), sin(ph)
    test = function('test')(ph)
    comm = Pf * (Qf * test.diff(ph)).diff(ph) - Qf * (Pf * test.diff(ph)).diff(
        ph)
    check(zero(comm - (Pf * Qf.diff(ph) - Qf * Pf.diff(ph)) * test.diff(ph))
          and zero(Pf * Qf.diff(ph) - Qf * Pf.diff(ph) - 1),
          'p. 448: [cos d/dphi, sin d/dphi] = (PQ\' - QP\') d/dphi = d/dphi')
    check(zero(sin(ph).diff(ph) - Pf) and zero((-cos(ph)).diff(ph) - Qf)
          and integrate(1, ph, 0, 2 * pi) != 0,
          'p. 448: cos, sin are gradients, the constant field is not')


def main():
    section_1()
    section_2()
    section_3()
    section_4()
    print(f'ok chapter-7: {COUNT[0]} checks')


if __name__ == '__main__':
    main()
