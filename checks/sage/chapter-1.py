"""Exact checks of Chapter 1 "Introduction to differential geometry" (Sage).

Run: sage -python checks/sage/chapter-1.py (plain asserts; do not use -O).
The last line of the output is "ok chapter-1: N checks".

Book: A. S. Mishchenko, A. T. Fomenko, Kurs differentsial'noi geometrii i
topologii, 2nd ed., Faktorial Press, 2000, Chapter 1, pp. 6-64.  Pages are
the printed pages.  The expected values are the book's statements, written
below as literals read off the printed page (coordinate changes, Jacobi
matrices, metrics, lengths, explicit maps); our Typst source is not parsed.
Where the book is wrong, the printed reading is kept as a refuted check
(function `refuted`: the printed reading must fail) next to the corrected
one.  Labels in brackets are those of content/01-*.typ.

Conventions.  A Jacobi matrix is that of Definition 2 of § 1 (p. 12,
def:jacobi-matrix): one row per function x^i, one column per argument y^j
(function `jac`).  Trigonometric and hyperbolic identities are checked
exactly: cos t, sin t are polynomial variables c, s modulo c^2 + s^2 = 1
with d/dt acting as c -> -s, s -> c (function `D`); e^t is a variable q
with d/dt q = q, so ch t = (q + 1/q)/2.  Everything else is a polynomial
or rational-function identity, an exact symbolic derivative, or an exact
value at a stated point.

What is checked, by section:

§ 1 (content/01-01-coordinates.typ, pp. 6-20)
  * p. 7: the ellipse with right side 1 has semi-axes a, b; the printed
    right side R^2 is refuted (the vertex (A^1 + a, A^2) lies on it only
    for R = 1); the spiral sqrt(x^2 + y^2) = e^(lambda arctg(y/x)) is
    r = e^(lambda phi) for |phi| < pi/2.
  * p. 9: in polar coordinates d/dt (r^2 phi') = r a_phi (a_phi the
    component of the acceleration along e_phi), so r^2 phi' is conserved
    in a central field, and the sectorial velocity is r^2 phi'/2; the
    printed "r^2 phi" is refuted on the uniform circular motion (a central
    motion with r^2 phi = t).
  * Lemma 1 (pp. 13-14, lem:change-of-coordinates): d psi = dg (df)^(-1)
    and J(psi) = J(g)/J(f) on polynomial maps f, g; the other order of the
    factors is refuted.
  * p. 15: w = z^2: the matrix df (corrected; the printed transpose is
    refuted), J = 4((y^1)^2 + (y^2)^2), f(r, phi) = (r^2, 2 phi), the two
    preimages (r, phi), (r, phi + pi).
  * p. 16, the question about 0 < eps <= J(f) <= N: the map T(u, v) =
    (e^u cos(v e^(-2u)), e^u sin(v e^(-2u))) has J = 1 identically and
    T(u, v) = T(u, v + 2 pi e^(2u)), so it is not one-to-one; |T|^2 =
    e^(2u) > 0, so its image misses the origin (it is not onto R^2).
  * pp. 17-20: the Jacobi matrices of the polar, cylindrical and spherical
    coordinates (corrected; the printed transposes on pp. 17, 18 and the
    printed sign on p. 20 are refuted) and J = r, r, r^2 sin theta; at
    r = 0 the spherical map is constant and J = 0 (the corrected domain
    r > 0, the printed r >= 0 refuted as a regular system), J = 0 exactly
    over the axis x^3.
  * p. 19 (the remark on f_n), n = 2..6: J_n = r^(n-1) sin^(n-2) theta_1 ...
    sin theta_(n-2); the corrected recurrence (both terms positive) and the
    expansion along the last column; the printed J_3 = -r^2 sin theta_1
    and the printed recurrence with (-1)^n (odd n) are refuted; the printed
    entries of the sketched matrix (n = 4, 5, 6) with the corrected entry
    d x^(n-1)/d theta_(n-1) (the printed one without sin theta_(n-1) is
    refuted).
  * Problem 1 (pr:regular-sine-system): J = 1 + cos x cos y / 2.

§ 2 (content/01-02-curve-length.typ, pp. 21-34)
  * Lemma 1 (p. 22, lem:reparametrization): <g_tau, g_tau> = <g_t, g_t>
    (dt/dtau)^2 for a polynomial curve and t = tau^3 + tau; p. 23: the
    segment and the circle.
  * p. 24: g_mp = sum_i (dx^i/dz^m)(dx^i/dz^p) is A^T A for A = d psi_(z,x)
    (polar, cylindrical, spherical); the printed A A^T is refuted.
  * p. 25: the law G(y) = B^T G(z) B, B = d psi_(y,z), on a polynomial
    change of a polynomial chart; the printed B G B^T is refuted.
  * pp. 26-27: the matrices d psi of the three examples, G = (d psi)^T d psi
    = diag(1, r^2), diag(1, r^2, 1), diag(1, r^2, r^2 sin^2 theta), the
    printed product of matrices on p. 26; the printed (d psi)(d psi)^T is
    refuted for the spherical (Definition 2) matrix; the helix: the
    corrected length sqrt(R^2 omega^2 + q^2)(b - a), the printed one
    refuted.
  * p. 29 (lem:metric-scalar-product): g'(xi', eta') = g(xi, eta) for
    G' = B^T G B, xi = B xi' (generic 2 x 2 and 3 x 3 matrices).
  * p. 30: the chain rule d psi_(z1,z2) = d psi_(z3,z2) d psi_(z1,z3)
    (corrected order; the printed order refuted) on polynomial maps, and
    property 3) for G(z) = (d psi)^T d psi.
  * p. 32 (remark): -<,>_(n-s) is <,>_s after reversing the order of the
    coordinates, n <= 6.

§ 3 (content/01-03-sphere-plane.typ, pp. 35-43)
  * p. 36: the corrected parametrization of the sphere and its metric
    R^2 (d theta^2 + sin^2 theta d phi^2); the printed parametrization is
    not on the sphere, and the one-letter alternative z = R sin theta gives
    another metric (both refuted).
  * pp. 37-38: the projection from N = (0, 0, R): |OQ| = R ctg(theta/2);
    dr/d theta = -R/(2 sin^2(theta/2)) (the corrected diagonal matrix with
    the coordinates in the order (theta, phi) -> (r, phi)), sin^2(theta/2)
    = R^2/(R^2 + r^2), cos^2(theta/2) = r^2/(R^2 + r^2), and the metric
    4 R^4/(R^2 + r^2)^2 (dr^2 + r^2 d phi^2) (the printed denominator
    without the square, pp. 39, 41, 42, refuted).
  * p. 39: rho = 2 R arctg(a/R) (exact integral) equals R(pi - theta), the
    length of the meridian from the south pole S (theta = pi, r = 0) to the
    circle; the printed "from the north pole" (R theta) is refuted;
    l_c = 4 pi a R^2/(R^2 + a^2) = 2 pi R sin(rho/R), the printed
    2 pi R sin rho refuted (R = a = 2); l_c/(2 pi rho) -> 1 as a -> 0.
  * p. 40: the circle theta = const has length 2 pi R sin theta.
  * Lemma 1 (p. 42): cos alpha = cos beta for a conformal factor.
  * pp. 42-43, the loxodrome: r = c e^(phi ctg alpha) meets the rays at
    the angle alpha; the Euclidean length of this plane curve is
    (c/cos alpha) e^(phi ctg alpha) + const; the length of the loxodrome
    on the sphere (metric 4 R^4/(R^2 + r^2)^2 (dr^2 + r^2 d phi^2)) is
    (2 R/cos alpha) arctg(c e^(phi ctg alpha)/R) + const (corrected), and
    no c' e^(phi ctg alpha) + c'' is (printed reading refuted); the whole
    loxodrome has length pi R/cos alpha (0 < alpha < pi/2).
  * Problem 1: the octant triangle has angle sum 3 pi/2: more than pi
    (corrected), not more than 2 pi (printed, refuted); Girard: area
    pi R^2/2 = (3 pi/2 - pi) R^2.

§ 4 (content/01-04-pseudosphere.typ, pp. 43-64)
  * Lemma 1 (p. 46, lem:stereographic-formulas): the formulas give points
    of the hyperboloid on the line N P; x + alpha = 2 alpha^3/(alpha^2 -
    |u|^2) > 0 (corrected); the printed x - alpha > 0 fails at u = 0.
  * p. 46: the right sheet projected from N fills the open disc; the left
    sheet projected from N fills the exterior of the circle and N goes to
    infinity (the corrected "from N"); projected from S (printed) the left
    sheet would fill the disc again and N would go to O (refuted).
  * Lemma 2 (p. 47): the four partial derivatives and J(f) = 4 alpha^4
    (alpha^2 + |u|^2)/(alpha^2 - |u|^2)^3 = 4 alpha^3 x/(alpha^2 -
    |u|^2)^2.
  * Lemma 3 (p. 49, lem:lines-to-arcs): the circle, and alpha^2 + r^2 =
    alpha^2 (b^2 + c^2)/a^2 (corrected; the printed (b^2 + c^2)/a^2
    refuted).
  * pp. 50-51 (the remark on the one-sheeted hyperboloid): the metric
    induced on -x^2 + y^2 + z^2 = alpha^2 is alpha^2 (-dt^2 + ch^2 t
    d phi^2), indefinite; every central plane through a point off the plane
    x = 0 meets the "line" x = 0, y^2 + z^2 = alpha^2 of this surface; a
    point P of it is space-like and the plane <,>_1-orthogonal to P meets
    the two-sheeted hyperboloid.
  * pp. 51-53: the pseudospherical coordinates; the induced metric
    4 alpha^4 |du|^2/(alpha^2 - |u|^2)^2; r = th(chi/2) turns 4 (dr^2 +
    r^2 d phi^2)/(1 - r^2)^2 into d chi^2 + sh^2 chi d phi^2 (corrected;
    the printed cth(chi/2) exceeds 1, refuted as a point of the disc); the
    meridian length theta'; 2r/(1 - r^2) = sh theta' for r = th(theta'/2)
    and -sh theta' for cth (refuted); chi = ln((1 + a)/(1 - a)), a =
    th(chi/2), l = 4 pi a/(1 - a^2) = 2 pi sh chi.
  * pp. 54-55: the Jacobi matrix [[1, i], [1, -i]] of (x, y) -> (z, zbar),
    J = -2i, dz dzbar = dx^2 + dy^2; the sphere metric with the factor 4
    (corrected; without it, refuted against § 3 with R = 1).
  * p. 56: z = (1 + iw)/(1 - iw): 0 -> 1, i -> 0, 1 -> i, the system with
    1 = b/d (the printed 1 = b/a refuted), the upper half-plane goes into
    the unit disc, z = -1 - 2/(iw - 1); the Jacobi matrix of z = 1/w
    (corrected; the printed transpose refuted) with determinant
    (u^2 + v^2)^2; dz = 2i dw/(1 - iw)^2; 4 dz dzbar/(1 - |z|^2)^2 =
    -4 dw dwbar/(w - wbar)^2 = (du^2 + dv^2)/v^2 (the printed sign
    refuted).
  * Lemma 4 (pp. 57-58, lem:equators-to-circles): the image of a circle of
    the sphere satisfies the printed equation (ideal membership), and for
    c = d (the plane through N) it is the line a x' + b y' = c.
  * Lemma 5 (p. 58, lem:circles-to-circles): z = a/c - (ad - bc)/(c(cw +
    d)); the image of a circle under z = 1/w (corrected term zbar_0 zbar;
    the printed zbar_0 z refuted: the equation must be real).
  * Lemma 6 (p. 59, lem:conformal): dz = (ad - bc)/(cw + d)^2 dw (the
    printed numerator with aw + d refuted); for a concrete map the real
    Jacobi matrix M has M^T M = |ad - bc|^2/|cw + d|^4 E (the printed
    |cw + d|^2 refuted).
  * p. 60: w = (z - 1)/(i(z + 1)) is the inverse map; the unit circle goes
    to the real axis; the diameter (-1, 1) goes to the positive imaginary
    axis.
  * p. 61: d/d phi ln tg(phi/2) = 1/sin phi, the chain of equalities with
    the limits phi_2 (below), phi_1 (above) (corrected; the printed limits
    refuted at phi_1 = 2 pi/3, phi_2 = pi/3); the vertical segment: the
    corrected |ln(y_2/y_1)| and the printed ln(y_2/y_1) (negative for P_1
    above P_2 as in Fig. 40, refuted); the metric is invariant under
    w -> k w.
  * p. 62: ch(chi_1 - chi_2) = x_1 x_2 - y_1 y_2, so l_12 = |chi_1 -
    chi_2| = arcch(-<e_1, e_2>); the printed middle member |arcch x_2 -
    arcch x_1| refuted at chi_1 = 1, chi_2 = -1; <e_1, e_2> < 0 (the
    printed "positive" refuted); the squared inequality and the corrected
    sign of <e_2, e_3>^2 (printed sign refuted); the Gram determinant and
    Gram = -det(M)^2 <= 0.
  * Problem 1 to § 4: a right isosceles triangle with angle sum < pi.

What these checks do NOT establish.  Every check is a polynomial or
rational-function identity in the written variables (with cos, sin modulo
c^2 + s^2 = 1, e^t as a variable), an ideal membership over QQ, an exact
symbolic derivative, integral or limit, or an exact value at the stated
point; general n is checked only for n <= 6.  Inequalities rest on the
checked identities plus a stated sign argument (e.g. x + alpha > 0 on the
right sheet), not on computation.  The answer to the question of p. 16 is
established here only for maps into the plane: T is a counterexample to
injectivity with J = 1 whose image is R^2 minus a point; that there are
also such maps onto the whole plane, and the positive answer for n = 1,
are arguments outside this script.  That the geometry of the one-sheeted
hyperboloid is not that of Lobachevsky rests on the checked facts above
(indefinite metric; a "line" meeting every line through a point off it)
together with the parallel axiom of the Lobachevsky plane stated on p. 50.
Theorems of the book (the implicit function theorem, the approximation of
curves by broken lines) are not proved.  Nothing here compares our text
with the printed book.
"""
from sage.all import (
    QQ, SR, PolynomialRing, QuadraticField, abs_symbolic as sage_abs, arccosh,
    arctan, assume, cos, cosh, diff, exp, forget, function,
    identity_matrix, integrate, limit, log, matrix, oo, pi, sin, sqrt, tan,
    vector,
)
from sage.rings.fraction_field import FractionField_generic

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
    """Jacobi matrix of Definition 2 (p. 12): one row per function."""
    return matrix([[diff(f, x) for x in xs] for f in fs])


def zero(expr):
    """An exact symbolic identity: a simplification of expr gives 0.

    canonicalize_radical takes principal branches; it is used only where
    the assumptions of the check make all radicands and logarithms
    positive.
    """
    e = SR(expr).simplify_full()
    if bool(e == 0):
        return True
    e = e.canonicalize_radical().simplify_full()
    if bool(e == 0):
        return True
    return bool(e.simplify_log().simplify_full() == 0)


def is_fraction(p):
    return isinstance(p.parent(), FractionField_generic)


# ---------------------------------------------------------------------------
# Trigonometric and hyperbolic functions as polynomial variables.


def D(p, pairs=(), exps=()):
    """d/dt of p in a polynomial ring or its fraction field.

    pairs: (c, s) = (cos(k t), sin(k t)) with factor k, as (c, s, k);
    exps: (q, k) with q = e^(k t).  Other variables are constant.
    """
    def dpoly(f):
        out = 0
        for c, s, k in pairs:
            out += k * (-s * f.derivative(c) + c * f.derivative(s))
        for q, k in exps:
            out += k * q * f.derivative(q)
        return out
    if is_fraction(p):
        n, d = p.numerator(), p.denominator()
        return (dpoly(n) * d - n * dpoly(d)) / d**2
    return dpoly(p)


def jac_D(fs, args):
    """Jacobi matrix (rows = functions) with derivations as columns."""
    return matrix([[a(f) for a in args] for f in fs])


def in_ideal(I, f):
    """f (polynomial or fraction) vanishes modulo the (prime) ideal I.

    For a fraction the numerator is tested; the denominators met here do
    not vanish identically on the variety of I.
    """
    if is_fraction(f):
        f = f.numerator()
    return I.reduce(I.ring()(f)) == 0


def mat_in_ideal(I, M):
    return all(in_ideal(I, e) for e in M.list())


# ---------------------------------------------------------------------------
# § 1. Curvilinear coordinates.


def section_1():
    # p. 7: the ellipse; the printed right side R^2.
    t, A1, A2, a, b, R, lam, phi = SR.var('t A1 A2 a b R lam phi')
    X, Y = A1 + a * cos(t), A2 + b * sin(t)
    check(zero((X - A1)**2 / a**2 + (Y - A2)**2 / b**2 - 1),
          'p. 7: (x - A1)^2/a^2 + (y - A2)^2/b^2 = 1 has semi-axes a, b')
    refuted(zero((a / a)**2 + 0 - R**2),
            'p. 7: printed "= R^2": the vertex (A1 + a, A2) lies on it')
    # p. 7: the spiral, on the branch |phi| < pi/2 of arctg
    check(zero(diff(arctan(tan(phi)), phi) - 1)
          and arctan(tan(SR(0))) == 0,
          'p. 7: arctg(y/x) = phi for |phi| < pi/2, so the spiral is '
          'r = e^(lambda phi)')

    # p. 9: central field.
    T = SR.var('T')
    rr = function('r')(T)
    pp = function('p')(T)
    Xt, Yt = rr * cos(pp), rr * sin(pp)
    ax, ay = diff(Xt, T, 2), diff(Yt, T, 2)
    a_phi = -sin(pp) * ax + cos(pp) * ay
    check(zero(rr * a_phi - diff(rr**2 * diff(pp, T), T)),
          'p. 9: d/dt (r^2 phi\') = r a_phi: r^2 phi\' is conserved when '
          'the force is central')
    check(zero((Xt * diff(Yt, T) - Yt * diff(Xt, T)) / 2
               - rr**2 * diff(pp, T) / 2),
          'p. 9: the sectorial velocity is r^2 phi\'/2')
    # uniform circular motion r = 1, phi = t: acceleration -e_r (central)
    Xc, Yc = cos(T), sin(T)
    check(zero(diff(Xc, T, 2) + Xc) and zero(diff(Yc, T, 2) + Yc),
          'p. 9: r = 1, phi = t is a motion in the central field f = -1')
    refuted(zero(diff(1**2 * T, T)),
            'p. 9: printed "r^2 phi" is conserved (r = 1, phi = t)')

    # Lemma 1, pp. 13-14: d psi = dg (df)^(-1), J(psi) = J(g)/J(f).
    P = PolynomialRing(QQ, ['y1', 'y2', 'x1', 'x2'])
    y1, y2, x1, x2 = P.gens()
    f = [y1 + y2**3, y2]
    finv = [x1 - x2**3, x2]                      # f^(-1)
    g = [y1, y2 + y1**2]
    check([fi.subs({y1: finv[0], y2: finv[1]}) for fi in f] == [x1, x2],
          'Lemma 1: f^(-1) is the inverse of f')
    psi = [gi.subs({y1: finv[0], y2: finv[1]}) for gi in g]
    at = {y1: finv[0], y2: finv[1]}
    dg = jac(g, [y1, y2]).subs(at)
    df = jac(f, [y1, y2]).subs(at)
    dpsi = jac(psi, [x1, x2])
    dfi = df.change_ring(P.fraction_field()).inverse()
    check(dpsi == dg * dfi, 'Lemma 1, p. 14: d psi = (dg)(df)^(-1)')
    refuted(dpsi == dfi * dg, 'Lemma 1: the other order (df)^(-1)(dg)')
    check(dpsi.det() == dg.det() / df.det(),
          'Lemma 1, p. 14: J(psi) = J(g)/J(f)')

    # p. 15: w = z^2.
    Q2 = PolynomialRing(QQ, ['y1', 'y2'])
    y1, y2 = Q2.gens()
    F = [y1**2 - y2**2, 2 * y1 * y2]
    dF = jac(F, [y1, y2])
    check(dF == matrix([[2 * y1, -2 * y2], [2 * y2, 2 * y1]]),
          'p. 15: df = (2y1, -2y2; 2y2, 2y1) (Definition 2)')
    refuted(dF == matrix([[2 * y1, 2 * y2], [-2 * y2, 2 * y1]]),
            'p. 15: printed df = (2y1, 2y2; -2y2, 2y1)')
    check(dF.det() == 4 * (y1**2 + y2**2), 'p. 15: J(f) = 4((y1)^2 + (y2)^2)')
    rho, ph = SR.var('rho ph')
    w = [(rho * cos(ph))**2 - (rho * sin(ph))**2,
         2 * rho * cos(ph) * rho * sin(ph)]
    check(zero(w[0] - rho**2 * cos(2 * ph)) and zero(w[1] - rho**2
                                                     * sin(2 * ph)),
          'p. 15: f(r, phi) = (r^2, 2 phi)')
    check(all(zero(wi.subs(ph=ph + pi) - wi) for wi in w),
          'p. 15: (r, phi) and (r, phi + pi) have the same image')

    # p. 16: the known question.  T has J = 1 and is not one-to-one.
    u, v = SR.var('u v')
    Tm = [exp(u) * cos(v * exp(-2 * u)), exp(u) * sin(v * exp(-2 * u))]
    check(zero(jac(Tm, [u, v]).det() - 1),
          'p. 16: T(u, v) = e^u (cos, sin)(v e^(-2u)) has J = 1')
    check(all(zero(Ti.subs(v=v + 2 * pi * exp(2 * u)) - Ti) for Ti in Tm),
          'p. 16: T(u, v) = T(u, v + 2 pi e^(2u)): T is not one-to-one')
    check(zero(Tm[0]**2 + Tm[1]**2 - exp(2 * u)),
          'p. 16: |T|^2 = e^(2u) > 0: the image of T misses the origin')

    # pp. 17-18: polar and cylindrical coordinates (c, s = cos, sin phi).
    Rp = PolynomialRing(QQ, ['r', 'c', 's', 'z'])
    r, c, s, z = Rp.gens()
    I = Rp.ideal([c**2 + s**2 - 1])
    dr = lambda e: e.derivative(r)
    dphi = lambda e: D(e, pairs=[(c, s, 1)])
    dz = lambda e: e.derivative(z)
    polar = jac_D([r * c, r * s], [dr, dphi])
    check(polar == matrix([[c, -r * s], [s, r * c]]),
          'p. 17: d psi = (cos phi, -r sin phi; sin phi, r cos phi)')
    refuted(polar == matrix([[c, s], [-r * s, r * c]]),
            'p. 17: printed d psi = (cos, sin; -r sin, r cos)')
    check(in_ideal(I, polar.det() - r), 'p. 17: J(psi) = r')
    cyl = jac_D([r * c, r * s, z], [dr, dphi, dz])
    check(cyl == matrix([[c, -r * s, 0], [s, r * c, 0], [0, 0, 1]]),
          'p. 18: the cylindrical Jacobi matrix (Definition 2)')
    refuted(cyl == matrix([[c, s, 0], [-r * s, r * c, 0], [0, 0, 1]]),
            'p. 18: printed cylindrical matrix (the transpose)')
    check(in_ideal(I, cyl.det() - r), 'p. 18: the Jacobian is r')

    # p. 19: spherical coordinates in R^n, n = 2..6.
    for n in range(2, 7):
        names = ['r'] + [f'c{k}' for k in range(1, n)] + \
            [f's{k}' for k in range(1, n)]
        Rn = PolynomialRing(QQ, names)
        r = Rn.gen(0)
        cs = Rn.gens()[1:n]
        ss = Rn.gens()[n:]
        In = Rn.ideal([cs[k]**2 + ss[k]**2 - 1 for k in range(n - 1)])

        def prod_s(m):
            out = Rn.one()
            for k in range(m):
                out *= ss[k]
            return out
        xs = [r * prod_s(i) * cs[i] for i in range(n - 1)] + \
            [r * prod_s(n - 1)]
        args = [lambda e: e.derivative(r)] + \
            [(lambda k: (lambda e: D(e, pairs=[(cs[k], ss[k], 1)])))(k)
             for k in range(n - 1)]
        M = jac_D(xs, args)
        Jn = Rn.one() * r**(n - 1)
        for k in range(n - 2):
            Jn *= ss[k]**(n - 2 - k)
        check(in_ideal(In, M.det() - Jn),
              f'p. 19: J_{n} = r^{n - 1} sin^{n - 2} theta_1 ... '
              'sin theta_(n-2)')
        if n >= 3:
            # corrected recurrence: both terms positive
            Jprev = Rn.one() * r**(n - 2)
            for k in range(n - 3):
                Jprev *= ss[k]**(n - 3 - k)
            base = r * prod_s(n - 2)
            term1 = base * cs[n - 2] * cs[n - 2] * Jprev
            term2 = base * ss[n - 2] * ss[n - 2] * Jprev
            check(in_ideal(In, M.det() - (term1 + term2))
                  and in_ideal(In, term1 + term2 - base * Jprev),
                  f'p. 19: J_{n} = r sin..cos^2 J_(n-1) + r sin..sin^2 '
                  'J_(n-1) = r sin theta_1 ... sin theta_(n-2) J_(n-1)')
            # expansion along the last column (the entries and cofactors)
            last = n - 1
            minor_nn = M.delete_rows([last]).delete_columns([last]).det()
            minor_n1 = M.delete_rows([last - 1]).delete_columns([last]).det()
            check(in_ideal(In, minor_nn - cs[n - 2] * Jprev)
                  and in_ideal(In, minor_n1 - ss[n - 2] * Jprev)
                  and M[last, last] == base * cs[n - 2]
                  and M[last - 1, last] == -base * ss[n - 2],
                  f'p. 19: n = {n}: the last column and its minors '
                  'cos theta_(n-1) J_(n-1), sin theta_(n-1) J_(n-1)')
            if n % 2 == 1:
                refuted(in_ideal(In, M.det() - (-1)**n * base * Jprev),
                        f'p. 19: printed recurrence with (-1)^n, n = {n}')
        if n == 3:
            refuted(in_ideal(In, M.det() + r**2 * ss[0]),
                    'p. 19: printed J_3 = -r^2 sin theta_1')
        if n >= 4:
            # the printed rows of the sketch: rows 1, 2, n-1, n
            ok = (M[0, 0] == cs[0] and M[0, 1] == -r * ss[0]
                  and M[0, 2] == 0
                  and M[1, 0] == ss[0] * cs[1]
                  and M[1, 1] == r * cs[0] * cs[1]
                  and M[1, 2] == -r * ss[0] * ss[1])
            mid = prod_s(n - 2) // ss[0]         # sin theta_2 ... theta_(n-2)
            ok &= M[n - 2, 0] == prod_s(n - 2) * cs[n - 2]
            ok &= M[n - 2, 1] == r * cs[0] * mid * cs[n - 2]
            ok &= M[n - 1, 0] == prod_s(n - 1)
            ok &= M[n - 1, 1] == r * cs[0] * mid * ss[n - 2]
            ok &= M[n - 1, n - 1] == r * prod_s(n - 2) * cs[n - 2]
            check(ok, f'p. 19: n = {n}: the printed entries of rows 1, 2, '
                  'n - 1, n')
            check(M[n - 2, n - 1] == -r * prod_s(n - 1),
                  f'p. 19: n = {n}: d x^(n-1)/d theta_(n-1) = -r sin theta_1'
                  ' ... sin theta_(n-1)')
            refuted(M[n - 2, n - 1] == -r * prod_s(n - 2),
                    f'p. 19: n = {n}: printed entry -r sin theta_1 ... '
                    'sin theta_(n-2)')

    # p. 20: spherical coordinates in R^3.
    Rs = PolynomialRing(QQ, ['r', 'ct', 'st', 'cp', 'sp'])
    r, ct, st, cp, sp = Rs.gens()
    Is = Rs.ideal([ct**2 + st**2 - 1, cp**2 + sp**2 - 1])
    dth = lambda e: D(e, pairs=[(ct, st, 1)])
    dph = lambda e: D(e, pairs=[(cp, sp, 1)])
    xs = [r * st * cp, r * st * sp, r * ct]
    S3 = jac_D(xs, [lambda e: e.derivative(r), dth, dph])
    check(S3 == matrix([[st * cp, r * ct * cp, -r * st * sp],
                        [st * sp, r * ct * sp, r * st * cp],
                        [ct, -r * st, 0]]),
          'p. 20: the spherical Jacobi matrix (corrected sign)')
    refuted(S3[0, 2] == r * st * sp,
            'p. 20: printed d x^1/d phi = r sin theta sin phi')
    check(in_ideal(Is, S3.det() - r**2 * st), 'p. 20: J = r^2 sin theta')
    check([e.subs({r: 0}) for e in xs] == [0, 0, 0]
          and S3.det().subs({r: 0}) == 0,
          'p. 20: at r = 0 the map is constant in theta, phi and J = 0: '
          'the domain needs r > 0 (printed r >= 0)')
    check(xs[0].subs({st: 0}) == 0 and xs[1].subs({st: 0}) == 0,
          'p. 20: J = 0 (r = 0 or sin theta = 0) only over the axis x^3')
    refuted(S3.det().subs({r: 0}) != 0,
            'p. 20: printed domain r >= 0: J != 0 on all of it (fails on '
            'the face r = 0)')

    # Problem 1 to § 1: u = x + sin y, v = y - sin x / 2.
    xx, yy = SR.var('xx yy')
    check(zero(jac([xx + sin(yy), yy - sin(xx) / 2], [xx, yy]).det()
               - (1 + cos(xx) * cos(yy) / 2)),
          'Problem 1: J = 1 + cos x cos y / 2 >= 1/2')


# ---------------------------------------------------------------------------
# § 2. Length of a curve.


def section_2():
    # Lemma 1, p. 22: reparametrization t = tau^3 + tau.
    P = PolynomialRing(QQ, ['tau'])
    tau = P.gen()
    t_of = tau**3 + tau
    gam_t = lambda t: [t**2 + 1, t**3 - t, 2 * t]   # a polynomial curve
    Pt = PolynomialRing(QQ, ['t'])
    tt = Pt.gen()
    vel_t = [e.derivative(tt) for e in gam_t(tt)]
    vel_t_at = [e(t_of) for e in vel_t]
    vel_tau = [e.derivative(tau) for e in gam_t(t_of)]
    check(sum(e**2 for e in vel_tau)
          == sum(e**2 for e in vel_t_at) * t_of.derivative(tau)**2,
          'Lemma 1, p. 22: <g_tau, g_tau> = <g_t, g_t> (dt/dtau)^2')
    # p. 23: the segment and the circle
    al1, al2, al3, a, b, R, tvar = SR.var('al1 al2 al3 a b R tvar')
    seg = integrate(sqrt(al1**2 + al2**2 + al3**2), tvar, a, b)
    check(zero(seg - (b - a) * sqrt(al1**2 + al2**2 + al3**2)),
          'p. 23: the segment has length (b - a) sqrt(sum alpha_i^2)')
    assume(R > 0)
    circ = integrate(sqrt(diff(R * cos(tvar), tvar)**2
                          + diff(R * sin(tvar), tvar)**2).simplify_full(),
                     tvar, 0, 2 * pi)
    check(zero(circ - 2 * pi * R), 'p. 24: the circle has length 2 pi R')
    forget()

    # p. 24: G = A^T A (polar, cylindrical, spherical).
    Rp = PolynomialRing(QQ, ['r', 'c', 's', 'z'])
    r, c, s, z = Rp.gens()
    I = Rp.ideal([c**2 + s**2 - 1])
    dphi = lambda e: D(e, pairs=[(c, s, 1)])
    A = jac_D([r * c, r * s], [lambda e: e.derivative(r), dphi])
    G = matrix(2, 2, lambda m, p: sum(A[i, m] * A[i, p] for i in range(2)))
    check(G == A.transpose() * A,
          'p. 24: g_mp = sum_i dx^i/dz^m dx^i/dz^p is A^T A')
    check(mat_in_ideal(I, A.transpose() * A - matrix([[1, 0], [0, r**2]])),
          'p. 26: G(r, phi) = (d psi)^T d psi = diag(1, r^2)')
    refuted(mat_in_ideal(I, A * A.transpose() - matrix([[1, 0],
                                                          [0, r**2]])),
            'p. 24: printed G = A A^T (polar coordinates)')
    check(mat_in_ideal(I, matrix([[c, s], [-r * s, r * c]])
                       * matrix([[c, -r * s], [s, r * c]])
                       - matrix([[1, 0], [0, r**2]])),
          'p. 26: the printed product (c, s; -rs, rc)(c, -rs; s, rc) = '
          'diag(1, r^2)')
    Acyl = jac_D([r * c, r * s, z], [lambda e: e.derivative(r), dphi,
                                     lambda e: e.derivative(z)])
    check(mat_in_ideal(I, Acyl.transpose() * Acyl
                       - matrix([[1, 0, 0], [0, r**2, 0], [0, 0, 1]])),
          'p. 27: G(r, phi, z) = (d psi)^T d psi = diag(1, r^2, 1)')
    Rs = PolynomialRing(QQ, ['r', 'ct', 'st', 'cp', 'sp'])
    r, ct, st, cp, sp = Rs.gens()
    Is = Rs.ideal([ct**2 + st**2 - 1, cp**2 + sp**2 - 1])
    As = jac_D([r * st * cp, r * st * sp, r * ct],
               [lambda e: e.derivative(r),
                lambda e: D(e, pairs=[(ct, st, 1)]),
                lambda e: D(e, pairs=[(cp, sp, 1)])])
    check(mat_in_ideal(Is, As.transpose() * As - matrix(
        [[1, 0, 0], [0, r**2, 0], [0, 0, r**2 * st**2]])),
          'p. 27: G(r, theta, phi) = diag(1, r^2, r^2 sin^2 theta), so '
          'dl^2 = dr^2 + r^2 dtheta^2 + r^2 sin^2 theta dphi^2')
    refuted(mat_in_ideal(Is, As * As.transpose() - matrix(
        [[1, 0, 0], [0, r**2, 0], [0, 0, r**2 * st**2]])),
            'p. 27: printed G = (d psi)(d psi)^T (spherical)')
    # the helix r = R, phi = omega t, z = q t: velocity (0, omega, q)
    Hx = PolynomialRing(QQ, ['R', 'om', 'q'])
    Rh, om, qh = Hx.gens()
    Gh = matrix(Hx, [[1, 0, 0], [0, Rh**2, 0], [0, 0, 1]])
    vel = vector(Hx, [0, om, qh])
    check(vel * Gh * vel == Rh**2 * om**2 + qh**2,
          'p. 27: along the helix |gamma\'|^2 = R^2 omega^2 + q^2 (constant), '
          'so l = sqrt(R^2 omega^2 + q^2)(b - a)')
    refuted(sqrt(SR(2)**2 * 1 + 0) == SR(2)**2 * 1 + 0,
            'p. 27: printed length (R^2 omega^2 + q^2)(b - a) (R = 2, '
            'omega = 1, q = 0, b - a = 1)')

    # p. 25: the law G(y) = B^T G(z) B on polynomial maps.
    Pz = PolynomialRing(QQ, ['y1', 'y2'])
    y1, y2 = Pz.gens()
    zy = [y1 + y2**3, y2 - y1**2]                  # z = z(y)
    Pzz = PolynomialRing(QQ, ['z1', 'z2'])
    z1, z2 = Pzz.gens()
    xz = [z1 + z2**2, z1 * z2]                      # x = x(z), x Cartesian
    Az = jac(xz, [z1, z2])
    Gz = Az.transpose() * Az
    Gz_at = Gz.apply_map(lambda e: e(zy[0], zy[1]))
    xy = [e(zy[0], zy[1]) for e in xz]
    Gy = jac(xy, [y1, y2]).transpose() * jac(xy, [y1, y2])
    B = jac(zy, [y1, y2])
    check(Gy == B.transpose() * Gz_at * B,
          'p. 25: G(y) = (d psi_(y,z))^T G(z) d psi_(y,z)')
    refuted(Gy == B * Gz_at * B.transpose(),
            'p. 25: printed G(y) = d psi G(z) (d psi)^T')

    # p. 29, Lemma 2: invariance of g(xi, eta).
    for n in (2, 3):
        names = [f'g{i}{j}' for i in range(n) for j in range(n)] + \
            [f'b{i}{j}' for i in range(n) for j in range(n)] + \
            [f'x{i}' for i in range(n)] + [f'e{i}' for i in range(n)]
        W = PolynomialRing(QQ, names)
        gs = W.gens()
        Gm = matrix(W, n, n, gs[:n * n])
        Gm = Gm + Gm.transpose()
        Bm = matrix(W, n, n, gs[n * n:2 * n * n])
        xi1 = vector(W, gs[2 * n * n:2 * n * n + n])
        eta1 = vector(W, gs[2 * n * n + n:])
        G1 = Bm.transpose() * Gm * Bm
        check(xi1 * G1 * eta1 == (Bm * xi1) * Gm * (Bm * eta1),
              f'p. 29, Lemma 2: g\'(xi\', eta\') = g(xi, eta), n = {n}')

    # p. 30: the chain rule for a double change; property 3).
    Pa = PolynomialRing(QQ, ['a1', 'a2'])
    a1, a2 = Pa.gens()
    m13 = [a1 + a2**2, a2]                           # z1 -> z3
    m32 = lambda w: [w[0], w[1] + w[0]**3]           # z3 -> z2
    m12 = m32(m13)
    J13 = jac(m13, [a1, a2])
    Pc = PolynomialRing(QQ, ['c1', 'c2'])
    c1, c2 = Pc.gens()
    J32 = jac(m32([c1, c2]), [c1, c2]).apply_map(lambda e: e(m13[0],
                                                             m13[1]))
    J12 = jac(m12, [a1, a2])
    check(J12 == J32 * J13,
          'p. 30: d psi_(z1,z2) = d psi_(z3,z2) d psi_(z1,z3)')
    refuted(J12 == J13 * J32, 'p. 30: printed d psi_(z1,z3) d psi_(z3,z2)')
    # property 3): G(z1) = J12^T G(z2) J12 for G = (d psi_(z,x))^T d psi
    xz2 = lambda w: [w[0] * w[1], w[0] + w[1]**2]   # x = x(z2)
    G1 = jac(xz2(m12), [a1, a2]).transpose() * jac(xz2(m12), [a1, a2])
    Jx2 = jac(xz2([c1, c2]), [c1, c2])
    G2 = (Jx2.transpose() * Jx2).apply_map(lambda e: e(m12[0], m12[1]))
    check(G1 == J12.transpose() * G2 * J12,
          'p. 30: property 3) holds for G(z) = (d psi)^T d psi')

    # p. 32, remark: <,>_(n-s) and <,>_s.
    ok = True
    for n in range(2, 7):
        for s_ in range(0, n + 1):
            form = lambda k, idx: (-1 if idx < k else 1)
            for i in range(n):
                # -<e_i, e_i>_(n-s) at the reversed index = <,>_s
                ok &= -form(n - s_, n - 1 - i) == form(s_, i)
    check(ok, 'p. 32: -<,>_(n-s) is <,>_s after reversing the coordinates '
          '(n <= 6)')


# ---------------------------------------------------------------------------
# § 3. Sphere and plane.


def section_3():
    R = SR.var('R')
    Rs = PolynomialRing(QQ, ['R', 'ct', 'st', 'cp', 'sp'])
    RR_, ct, st, cp, sp = Rs.gens()
    Is = Rs.ideal([ct**2 + st**2 - 1, cp**2 + sp**2 - 1])
    dth = lambda e: D(e, pairs=[(ct, st, 1)])
    dph = lambda e: D(e, pairs=[(cp, sp, 1)])
    # p. 36: the corrected parametrization and its metric
    X = [RR_ * st * cp, RR_ * st * sp, RR_ * ct]
    check(in_ideal(Is, sum(e**2 for e in X) - RR_**2),
          'p. 36: (R sin theta cos phi, R sin theta sin phi, R cos theta) '
          'lies on the sphere')
    A = jac_D(X, [dth, dph])
    check(mat_in_ideal(Is, A.transpose() * A
                       - matrix([[RR_**2, 0], [0, RR_**2 * st**2]])),
          'p. 36: the induced metric is R^2 (dtheta^2 + sin^2 theta dphi^2)')
    Xp = [RR_ * ct * cp, RR_ * ct * sp, RR_ * sp]
    refuted(in_ideal(Is, sum(e**2 for e in Xp) - RR_**2),
            'p. 36: printed (R cos cos, R cos sin, R sin phi) lies on the '
            'sphere')
    Xa = [RR_ * ct * cp, RR_ * ct * sp, RR_ * st]
    Aa = jac_D(Xa, [dth, dph])
    refuted(mat_in_ideal(Is, Aa.transpose() * Aa
                         - matrix([[RR_**2, 0], [0, RR_**2 * st**2]])),
            'p. 36: the alternative z = R sin theta gives R^2 (dtheta^2 + '
            'sin^2 theta dphi^2)')

    # pp. 37-38: stereographic projection from N = (0, 0, R); half angles
    H = PolynomialRing(QQ, ['R', 'r', 'C', 'S', 'cp', 'sp'])
    Rh, r, C, S, cp2, sp2 = H.gens()
    Ih = H.ideal([C**2 + S**2 - 1, cp2**2 + sp2**2 - 1])
    Fh = H.fraction_field()
    sth, cth = 2 * S * C, C**2 - S**2                  # sin, cos theta
    P = [Rh * sth * cp2, Rh * sth * sp2, Rh * cth]
    lam = Fh(1) / (1 - cth)                             # N + lam (P - N)
    Q = [lam * P[0], lam * P[1], Rh + lam * (P[2] - Rh)]
    check(in_ideal(Ih, Q[2].numerator())
          and in_ideal(Ih, (Q[0]**2 + Q[1]**2 - (Rh * C / S)**2)
                       .numerator()),
          'p. 38: the projection from N: Q in the plane, '
          '|OQ| = R ctg(theta/2)')
    rt = Rh * C / S                                     # r(theta)
    dhalf = lambda e: D(e, pairs=[(C, S, QQ(1) / 2)])
    drdth = dhalf(Fh(rt))
    check(in_ideal(Ih, (drdth + Rh / (2 * S**2)).numerator()),
          'p. 38: dr/dtheta = -R/(2 sin^2(theta/2)), the Jacobi matrix '
          'diag(-R/(2 sin^2(theta/2)), 1) for (theta, phi) -> (r, phi)')
    check(in_ideal(Ih, (S**2 - Rh**2 / (Rh**2 + rt**2)).numerator())
          and in_ideal(Ih, (C**2 - rt**2 / (Rh**2 + rt**2)).numerator()),
          'p. 38: sin^2(theta/2) = R^2/(R^2 + r^2), cos^2 = r^2/(R^2 + r^2)')
    lam2 = 4 * Rh**4 / (Rh**2 + rt**2)**2
    # R^2 dtheta^2 = lam2 dr^2 and R^2 sin^2 theta = lam2 r^2
    check(in_ideal(Ih, (Rh**2 - lam2 * drdth**2).numerator())
          and in_ideal(Ih, (Rh**2 * sth**2 - lam2 * rt**2).numerator()),
          'p. 38: ds^2 = 4 R^4/(R^2 + r^2)^2 (dr^2 + r^2 dphi^2)')
    refuted(in_ideal(Ih, (Rh**2 - 4 * Rh**4 / (Rh**2 + rt**2)
                          * drdth**2).numerator()),
            'pp. 39, 41, 42: printed 4 R^4/(R^2 + r^2) (dr^2 + r^2 dphi^2)')

    # p. 39: rho, l_c; rho is measured from the south pole.
    a, rr, th = SR.var('a rr th')
    assume(R > 0)
    assume(a > 0)
    rho = integrate(2 * R**2 / (R**2 + rr**2), rr, 0, a)
    check(zero(rho - 2 * R * arctan(a / R)),
          'p. 39: rho = 2 int_0^a R^2/(R^2 + r^2) dr = 2 R arctg(a/R)')
    # with a = R ctg(theta/2): d rho/d theta = -R and rho = 0 at theta = pi
    a_th = R * cos(th / 2) / sin(th / 2)
    rho_th = 2 * R * arctan(a_th / R)
    check(zero(diff(rho_th, th) + R)
          and zero(rho_th.subs(th=pi)),
          'p. 39: rho = R(pi - theta): the meridian from the south pole S '
          '(theta = pi, r = 0)')
    refuted(zero(diff(rho_th, th) - R),
            'p. 39: printed "from the north pole": rho = R theta')
    lc = integrate(2 * R**2 * a / (R**2 + a**2), SR.var('pp'), 0, 2 * pi)
    check(zero(lc - 4 * pi * a * R**2 / (R**2 + a**2)),
          'p. 39: l_c = 2 int_0^(2 pi) R^2 a dphi/(R^2 + a^2) = '
          '4 pi a R^2/(R^2 + a^2)')
    check(zero(4 * pi * a * R**2 / (R**2 + a**2)
               - 2 * pi * R * sin(rho / R)),
          'p. 39: l_c = 2 pi R sin(rho/R)')
    vals = {R: 2, a: 2}
    refuted(zero((4 * pi * a * R**2 / (R**2 + a**2)).subs(vals)
                 - (2 * pi * R * sin(rho)).subs(vals)),
            'p. 39: printed l_c = 2 pi R sin rho (R = a = 2)')
    check(limit(4 * pi * a * R**2 / (R**2 + a**2) / (2 * pi * rho), a=0)
          == 1, 'p. 40: l_c ~ 2 pi rho as rho -> 0')
    forget()
    # p. 40: the circle theta = const in the metric R^2(...)
    check(zero(integrate(R * sin(th), SR.var('pp'), 0, 2 * pi)
               - 2 * pi * R * sin(th)),
          'p. 40: the circle of radius theta has length 2 pi R sin theta')

    # Lemma 1, p. 42: the conformal factor cancels in the cosine.
    l2, r1d, r2d, p1d, p2d, r0 = SR.var('l2 r1d r2d p1d p2d r0')
    cos_g = l2 * (r1d * r2d + r0**2 * p1d * p2d) / sqrt(
        l2 * (r1d**2 + r0**2 * p1d**2) * l2 * (r2d**2 + r0**2 * p2d**2))
    cos_e = (r1d * r2d + r0**2 * p1d * p2d) / sqrt(
        (r1d**2 + r0**2 * p1d**2) * (r2d**2 + r0**2 * p2d**2))
    assume(l2 > 0)
    check(zero(cos_g - cos_e), 'Lemma 1, p. 42: cos alpha = cos beta')
    forget()

    # pp. 42-43: the loxodrome; k = ctg alpha, cos alpha = k/sqrt(1 + k^2).
    k, cc, ph, Rr = SR.var('k cc ph Rr')
    assume(k > 0)
    assume(cc > 0)
    assume(Rr > 0)
    cosal = k / sqrt(1 + k**2)
    rl = cc * exp(ph * k)
    rdot = diff(rl, ph)
    check(zero(rdot / sqrt(rdot**2 + rl**2) - cosal),
          'p. 42: r = c e^(phi ctg alpha) meets the rays at the angle alpha')
    eucl_speed = sqrt(rdot**2 + rl**2)
    check(zero(diff(cc / cosal * exp(ph * k), ph) - eucl_speed),
          'p. 42: the plane image has Euclidean length (c/cos alpha) '
          'e^(phi ctg alpha) + const')
    sph_speed = 2 * Rr**2 / (Rr**2 + rl**2) * eucl_speed
    lox = 2 * Rr / cosal * arctan(rl / Rr)
    check(zero(diff(lox, ph) - sph_speed),
          'p. 42: the loxodrome has spherical length (2R/cos alpha) '
          'arctg(c e^(phi ctg alpha)/R) + const')
    # if c' e^(phi ctg alpha) + c'' were the spherical length, the ratio
    # of the speeds would be the constant c'; it takes different values
    ratio = sph_speed / diff(exp(ph * k), ph)
    at = lambda p0: ratio.subs({k: 1, cc: 1, Rr: 1, ph: p0})
    r0v, r1v = at(0).simplify_full(), at(log(SR(2))).simplify_full()
    check(zero(r0v - 2 * sqrt(2) / 2) and zero(r1v - 2 * sqrt(2) / 5),
          'p. 42: speed ratio sqrt(2) at phi = 0 and 2 sqrt(2)/5 at '
          'phi = ln 2 (alpha = pi/4, c = R = 1)')
    refuted(zero(r0v - r1v),
            'p. 42: printed length c\' e^(phi ctg alpha) + c\'\' on the '
            'sphere (the ratio of the speeds would be constant)')
    total = limit(lox, ph=oo) - limit(lox, ph=-oo)
    check(zero(total - pi * Rr / cosal),
          'p. 42: the whole loxodrome has length pi R/cos alpha')
    forget()

    # Problem 1 to § 3: the octant triangle.
    e = identity_matrix(QQ, 3)
    # at e1 the arcs to e2, e3 leave in the directions e2, e3: angle pi/2
    tangent = lambda P_, Q_: Q_ - (Q_ * P_) * P_
    ok = all(tangent(e[i], e[j]) * tangent(e[i], e[k]) == 0
             for i, j, k in ((0, 1, 2), (1, 0, 2), (2, 0, 1)))
    check(ok, 'Problem 1 to § 3: the octant triangle has three right '
          'angles: sum 3 pi/2 > pi')
    refuted(3 * pi / 2 > 2 * pi,
            'Problem 1 to § 3: printed "the angle sum exceeds 2 pi"')
    check(4 * pi / 8 == (3 * pi / 2 - pi),
          'Problem 2 to § 3: area pi/2 = (sum of angles - pi) R^2, R = 1')


# ---------------------------------------------------------------------------
# § 4. Pseudosphere and Lobachevsky geometry.


def section_4():
    P = PolynomialRing(QQ, ['al', 'u1', 'u2'])
    al, u1, u2 = P.gens()
    F = P.fraction_field()
    den = al**2 - u1**2 - u2**2
    x = F(al * (u1**2 + u2**2 + al**2)) / den
    y = F(2 * al**2 * u1) / den
    z = F(2 * al**2 * u2) / den
    check(-x**2 + y**2 + z**2 + al**2 == 0
          and y * al == u1 * (x + al) and z * al == u2 * (x + al),
          'Lemma 1, p. 46: the point lies on -alpha^2 = -x^2 + y^2 + z^2 '
          'and on the line N P (y/u1 = z/u2 = (x + alpha)/alpha)')
    check(x + al == 2 * al**3 / den,
          'Lemma 1, p. 46: x + alpha = 2 alpha^3/(alpha^2 - |u|^2) > 0')
    refuted((x - al).subs({u1: 0, u2: 0}) != 0,
            'Lemma 1, p. 46: printed (x - alpha) > 0 (it vanishes at u = 0)')

    # p. 46: the images of the sheets.
    Q = PolynomialRing(QQ, ['al', 'x', 'y', 'z'])
    a_, X, Y, Z = Q.gens()
    Fq = Q.fraction_field()
    hyp = Q.ideal([X**2 - Y**2 - Z**2 - a_**2])
    fromN = Fq(a_**2 * (Y**2 + Z**2)) / (X + a_)**2       # |u|^2 from N
    fromS = Fq(a_**2 * (Y**2 + Z**2)) / (a_ - X)**2       # |u|^2 from S
    check(in_ideal(hyp, (fromN - a_**2 * (X - a_) / (X + a_)).numerator()),
          'p. 46: from N, |u|^2 = alpha^2 (x - alpha)/(x + alpha)')
    check(Fq((X - a_) / (X + a_)) - 1 == Fq(-2 * a_) / (X + a_),
          'p. 46: (x - alpha)/(x + alpha) - 1 = -2 alpha/(x + alpha): < 0 '
          'on the right sheet (disc), > 0 on the left sheet (exterior)')
    check((X + a_).subs({X: -a_}) == 0,
          'p. 46: from N, the pole N itself (x = -alpha) goes to infinity')
    check(in_ideal(hyp, (fromS - a_**2 * (X + a_) / (X - a_)).numerator())
          and Fq((X + a_) / (X - a_)) - 1 == Fq(2 * a_) / (X - a_),
          'p. 46: from S, |u|^2 = alpha^2 (x + alpha)/(x - alpha) < alpha^2 '
          'for x < -alpha: the left sheet would fill the disc')
    # the point (-5/3, 4/3, 0) of the left sheet (alpha = 1)
    left = {a_: 1, X: QQ(-5) / 3, Y: QQ(4) / 3, Z: 0}
    check((X**2 - Y**2 - Z**2 - a_**2).subs(left) == 0
          and fromN.subs(left) == 4,
          'p. 46: from N the left-sheet point (-5/3, 4/3, 0) goes to '
          '|u|^2 = 4 > 1 (exterior)')
    refuted(fromS.subs(left) > 1,
            'p. 46: printed centre S: the left sheet fills the exterior '
            '(|u|^2 = 1/4 for the same point)')
    # the projection from S of N = (-alpha, 0, 0): u = alpha (y, z)/(alpha
    # - x) = (0, 0), the point O; from N, N itself has no image (x + alpha
    # = 0), i.e. goes to infinity as the text says
    check((Fq(a_ * Y) / (a_ - X)).subs({X: -a_, Y: 0}) == 0
          and (Fq(a_ * Z) / (a_ - X)).subs({X: -a_, Z: 0}) == 0,
          'p. 46: from S the pole N would go to O, not to infinity')

    # Lemma 2, p. 47.
    check(y.derivative(u1) == 2 * al**2 * (al**2 + u1**2 - u2**2) / den**2
          and y.derivative(u2) == 2 * al**2 * 2 * u1 * u2 / den**2
          and z.derivative(u1) == 2 * al**2 * 2 * u1 * u2 / den**2
          and z.derivative(u2) == 2 * al**2 * (al**2 + u2**2 - u1**2)
          / den**2,
          'Lemma 2, p. 47: the four partial derivatives')
    Jf = jac([y, z], [u1, u2]).det()
    check(Jf == 4 * al**4 * (al**2 + u1**2 + u2**2) / den**3
          and Jf == 4 * al**3 * x / den**2,
          'Lemma 2, p. 47: J(f) = 4 alpha^4 (alpha^2 + |u|^2)/(alpha^2 - '
          '|u|^2)^3 = 4 alpha^3 x/(alpha^2 - |u|^2)^2')

    # Lemma 3, p. 49.
    L = PolynomialRing(QQ, ['al', 'u1', 'u2', 'a', 'b', 'c'])
    al, u1, u2, a, b, c = L.gens()
    FL = L.fraction_field()
    plane = (a * al * (u1**2 + u2**2 + al**2) + 2 * b * al**2 * u1
             + 2 * c * al**2 * u2)
    circle = (u1 + b * al / a)**2 + (u2 + c * al / a)**2 \
        - al**2 / a**2 * (b**2 + c**2 - a**2)
    check(FL(plane) / (a * al) == circle,
          'Lemma 3, p. 49: the image is the circle with centre '
          '(-b alpha/a, -c alpha/a), r^2 = alpha^2 (b^2 + c^2 - a^2)/a^2')
    r2 = al**2 * (b**2 + c**2 - a**2) / FL(a**2)
    dist2 = (b * al / FL(a))**2 + (c * al / FL(a))**2
    check(al**2 + r2 == dist2 and dist2 == al**2 * (b**2 + c**2) / FL(a**2),
          'Lemma 3, p. 49: alpha^2 + r^2 = alpha^2 (b^2 + c^2)/a^2: '
          'orthogonal circles')
    refuted(al**2 + r2 == (b**2 + c**2) / FL(a**2),
            'Lemma 3, p. 49: printed alpha^2 + r^2 = (b^2 + c^2)/a^2')

    # p. 50, the remark: the one-sheeted hyperboloid.
    H = PolynomialRing(QQ, ['al', 'q', 'cp', 'sp'])
    alh, q, cp, sp = H.gens()
    Ih = H.ideal([cp**2 + sp**2 - 1])
    FH = H.fraction_field()
    chq, shq = (q + 1 / FH(q)) / 2, (q - 1 / FH(q)) / 2
    pt = [alh * shq, alh * chq * cp, alh * chq * sp]
    dt = lambda e: D(e, exps=[(q, 1)])
    dp = lambda e: D(e, pairs=[(cp, sp, 1)])
    check(in_ideal(Ih, (-pt[0]**2 + pt[1]**2 + pt[2]**2 - alh**2)
                   .numerator()),
          'p. 50: (alpha sh t, alpha ch t cos phi, alpha ch t sin phi) '
          'is on -x^2 + y^2 + z^2 = alpha^2')
    Jm = jac_D(pt, [dt, dp])
    eta = matrix(FH, [[-1, 0, 0], [0, 1, 0], [0, 0, 1]])
    g1 = Jm.transpose() * eta * Jm
    check(in_ideal(Ih, (g1[0, 0] + alh**2).numerator())
          and in_ideal(Ih, g1[0, 1].numerator())
          and in_ideal(Ih, (g1[1, 1] - alh**2 * chq**2).numerator()),
          'p. 50: the induced metric is alpha^2 (-dt^2 + ch^2 t dphi^2): '
          'indefinite, not the Lobachevsky metric')
    # every central plane n.p = 0 through a point off x = 0 meets the
    # "line" x = 0 of the hyperboloid: Q = alpha (0, n3, -n2)/sqrt(n2^2 + n3^2)
    N = PolynomialRing(QQ, ['al', 'n1', 'n2', 'n3', 'w'])
    aln, n1, n2, n3, wq = N.gens()     # w = sqrt(n2^2 + n3^2)
    In = N.ideal([wq**2 - n2**2 - n3**2])
    Qp = [0, aln * n3, -aln * n2]      # times 1/w
    check(n1 * Qp[0] + n2 * Qp[1] + n3 * Qp[2] == 0
          and in_ideal(In, -Qp[0]**2 + Qp[1]**2 + Qp[2]**2
                       - aln**2 * wq**2),
          'p. 50: a central plane with (n2, n3) != 0 meets x = 0, '
          'y^2 + z^2 = alpha^2 (if (n2, n3) = 0 it is the plane x = 0)')
    # polarity: P on the one-sheeted hyperboloid, T in P-perp on the
    # two-sheeted one
    Pp = [shq, chq, 0]
    Tt = [chq, shq, 0]
    lor = lambda U, V: -U[0] * V[0] + U[1] * V[1] + U[2] * V[2]
    check(lor(Pp, Pp) == 1 and lor(Pp, Tt) == 0 and lor(Tt, Tt) == -1,
          'p. 50: <P, P>_1 = 1, and the plane P-perp contains T with '
          '<T, T>_1 = -1: P-perp cuts a line of the Lobachevsky plane')

    # pp. 51-53: pseudospherical coordinates, metric in u, r = th(chi/2).
    al, u1, u2 = P.gens()
    F = P.fraction_field()
    den = al**2 - u1**2 - u2**2
    x = F(al * (u1**2 + u2**2 + al**2)) / den
    y = F(2 * al**2 * u1) / den
    z = F(2 * al**2 * u2) / den
    Ju = jac([x, y, z], [u1, u2])
    etaP = matrix(F, [[-1, 0, 0], [0, 1, 0], [0, 0, 1]])
    check(Ju.transpose() * etaP * Ju == 4 * al**4 / den**2
          * identity_matrix(F, 2),
          'p. 51: -dx^2 + dy^2 + dz^2 = 4 alpha^4 |du|^2/(alpha^2 - |u|^2)^2')
    Hq = PolynomialRing(QQ, ['q'])
    qq = Hq.gen()
    Fq1 = Hq.fraction_field()
    # q = e^(chi/2): th(chi/2) = (q^2 - 1)/(q^2 + 1), sh chi = (q^2 - q^-2)/2
    rth = Fq1(qq**2 - 1) / (qq**2 + 1)
    shchi = (qq**2 - 1 / Fq1(qq**2)) / 2
    drdchi = D(rth, exps=[(qq, QQ(1) / 2)])
    check(4 * drdchi**2 / (1 - rth**2)**2 == 1
          and 4 * rth**2 / (1 - rth**2)**2 == shchi**2,
          'p. 51: r = th(chi/2) gives d chi^2 + sh^2 chi d phi^2')
    rcth = 1 / rth
    check(rcth - 1 == 2 / Fq1(qq**2 - 1),
          'p. 51: cth(chi/2) - 1 = 2/(e^chi - 1) > 0 for chi > 0')
    refuted(rcth(2) < 1,
            'p. 51: printed r = cth(chi/2) lies in the disc r < 1 '
            '(chi = 2 ln 2: cth = 5/3)')
    # the meridian x = ch t, z = sh t: -dx^2 + dz^2 = dt^2; tg theta = th
    Hm = PolynomialRing(QQ, ['q'])
    qm = Hm.gen()
    Fm = Hm.fraction_field()
    chm, shm = (qm + 1 / Fm(qm)) / 2, (qm - 1 / Fm(qm)) / 2
    dtm = lambda e: D(e, exps=[(qm, 1)])
    check(-dtm(chm)**2 + dtm(shm)**2 == 1,
          'pp. 51-52: the meridian has pseudo-Euclidean length theta\'')
    # p. 52: 2r/(1 - r^2) = sh theta' for r = th(theta'/2)
    check(2 * rth / (1 - rth**2) == shchi,
          'p. 52: r = th(theta\'/2) gives 2r/(1 - r^2) = sh theta\'')
    refuted(2 * rcth / (1 - rcth**2) == shchi,
            'p. 52: printed r = cth(theta\'/2) (gives -sh theta\')')
    check(2 * rcth / (1 - rcth**2) == -shchi,
          'p. 52: with cth the left side is -sh theta\'')
    # p. 53: chi = ln((1 + a)/(1 - a)), a = th(chi/2), l = 2 pi sh chi
    aa = SR.var('aa')
    assume(aa > 0)
    assume(aa < 1)
    chi_a = integrate(2 / (1 - SR.var('rr')**2), SR.var('rr'), 0, aa)
    check(zero(chi_a - log((1 + aa) / (1 - aa))),
          'p. 53: chi = 2 int_0^a dr/(1 - r^2) = ln((1 + a)/(1 - a))')
    forget()
    check((1 + rth) / (1 - rth) == qq**2,
          'p. 53: a = th(chi/2) satisfies (1 + a)/(1 - a) = e^chi')
    check(4 * rth / (1 - rth**2) == 2 * shchi,
          'p. 53: l = 4 pi a/(1 - a^2) = 2 pi sh chi')

    # pp. 54-55: complex coordinates.
    K = QuadraticField(-1, 'i')
    i = K.gen()
    Pk = PolynomialRing(K, ['x', 'y'])
    xk, yk = Pk.gens()
    Mz = jac([xk + i * yk, xk - i * yk], [xk, yk])
    check(Mz == matrix(K, [[1, i], [1, -i]]) and Mz.det() == -2 * i,
          'p. 54: the Jacobi matrix (1, i; 1, -i), J = -2i')
    dxk, dyk = Pk.gens()
    check((dxk + i * dyk) * (dxk - i * dyk) == dxk**2 + dyk**2,
          'p. 54: dz dzbar = dx^2 + dy^2')
    rS = SR.var('rS')
    check(zero((4 * 1**4 / (1**2 + rS**2)**2) - 4 / (1 + rS**2)**2),
          'p. 55: the unit sphere metric is 4 (dx^2 + dy^2)/(1 + x^2 + '
          'y^2)^2 (§ 3 with R = 1)')
    refuted(zero(1 / (1 + rS**2)**2 - 4 / (1 + rS**2)**2),
            'p. 55: printed (dx^2 + dy^2)/(1 + x^2 + y^2)^2')

    # p. 56: z = (1 + iw)/(1 - iw).
    Pw = PolynomialRing(K, ['w'])
    w = Pw.gen()
    Fw = Pw.fraction_field()
    zw = Fw(1 + i * w) / (1 - i * w)
    ev = lambda f, val: f.numerator()(val) / f.denominator()(val)
    check(ev(zw, 0) == 1 and ev(zw, i) == 0 and ev(zw, 1) == i,
          'p. 56: 0 -> 1, i -> 0, 1 -> i')
    a_, b_, c_, d_ = i, 1, -i, 1
    check(K(b_) / d_ == 1 and (a_ + b_) / (c_ + d_) == i
          and (a_ * i + b_) / (c_ * i + d_) == 0,
          'p. 56: a = i, b = 1, c = -i, d = 1 solve 1 = b/d, '
          'i = (a + b)/(c + d), 0 = (ai + b)/(ci + d)')
    refuted(K(b_) / a_ == 1, 'p. 56: printed equation 1 = b/a')
    check(zw == -1 - 2 / (i * w - 1), 'p. 56: z = -1 - 2/(iw - 1)')
    Puv = PolynomialRing(QQ, ['u', 'v'])
    uu, vv = Puv.gens()
    # |1 + iw|^2 - |1 - iw|^2 for w = u + iv: 1 + iw = (1 - v) + iu
    check(((1 - vv)**2 + uu**2) - ((1 + vv)**2 + uu**2) == -4 * vv,
          'p. 56: |1 + iw|^2 - |1 - iw|^2 = -4 Im w: the upper half-plane '
          'goes into the unit disc')
    Fuv = Puv.fraction_field()
    n2 = uu**2 + vv**2
    xi = Fuv(uu) / n2
    yi = Fuv(-vv) / n2
    Minv = jac([xi, yi], [uu, vv]) * n2**2
    check(Minv == matrix([[vv**2 - uu**2, -2 * uu * vv],
                          [2 * uu * vv, vv**2 - uu**2]]),
          'p. 56: the Jacobi matrix of z = 1/w is (v^2 - u^2, -2uv; 2uv, '
          'v^2 - u^2)/(u^2 + v^2)^2')
    refuted(Minv == matrix([[vv**2 - uu**2, 2 * uu * vv],
                            [-2 * uu * vv, vv**2 - uu**2]]),
            'p. 56: printed (v^2 - u^2, 2uv; -2uv, v^2 - u^2)')
    check(Minv.det() == n2**2, 'p. 56: its determinant (u^2 + v^2)^2 > 0')
    check(zw.derivative(w) == 2 * i / (1 - i * w)**2,
          'p. 56: dz = 2i dw/(1 - iw)^2')
    # 4 |dz/dw|^2/(1 - |z|^2)^2 = 1/v^2, z = ((1 - v) + iu)/((1 + v) - iu)
    m1 = (1 - vv)**2 + uu**2
    m2 = (1 + vv)**2 + uu**2
    absz2 = Fuv(m1) / m2
    absdz2 = Fuv(4) / m2**2                           # |1 - iw|^2 = m2
    check(4 * absdz2 / (1 - absz2)**2 == 1 / Fuv(vv**2),
          'p. 56: 4 dz dzbar/(1 - |z|^2)^2 = (du^2 + dv^2)/v^2')
    wmwb2 = -4 * vv**2                                # (w - wbar)^2
    check(Fuv(-4) / wmwb2 == 1 / Fuv(vv**2),
          'p. 56: -4 dw dwbar/(w - wbar)^2 = (du^2 + dv^2)/v^2')
    refuted(Fuv(4) / wmwb2 == 1 / Fuv(vv**2),
            'p. 56: printed 4 dw dwbar/(w - wbar)^2')

    # Lemma 4, pp. 57-58.
    S4 = PolynomialRing(QQ, ['a', 'b', 'c', 'd', 'x', 'y', 'z'])
    a, b, c, d, X, Y, Z = S4.gens()
    I4 = S4.ideal([X**2 + Y**2 + Z**2 - 1, a * X + b * Y + c * Z - d])
    # x' = x/(1 - z): the printed equation times (c - d)(1 - z)^2
    eq = ((c - d) * (X**2 + Y**2) + 2 * (a * X + b * Y) * (1 - Z)
          - (c - d + 2 * d) * (1 - Z)**2)
    check(eq in I4,
          'Lemma 4, p. 58: x\'^2 + y\'^2 + 2a/(c - d) x\' + 2b/(c - d) y\' = '
          '1 + 2d/(c - d) on the image of the circle')
    I4l = S4.ideal([X**2 + Y**2 + Z**2 - 1, a * X + b * Y + c * Z - c])
    check(a * X + b * Y - c * (1 - Z) in I4l,
          'Lemma 4: for c = d (the plane through N) the image is the line '
          'a x\' + b y\' = c')

    # Lemma 5, p. 58.
    M5 = PolynomialRing(K, ['a', 'b', 'c', 'd', 'w'])
    a, b, c, d, w5 = M5.gens()
    F5 = M5.fraction_field()
    check(F5(a * w5 + b) / (c * w5 + d)
          == a / F5(c) - (a * d - b * c) / (c * (c * w5 + d)),
          'Lemma 5, p. 58: z = a/c - (ad - bc)/(c(cw + d))')
    C5 = PolynomialRing(QQ, ['w', 'wb', 'z0', 'z0b', 'e'])
    w_, wb, z0, z0b, e = C5.gens()
    lhs = (1 - z0 * w_) * (1 - z0b * wb) - e**2 * w_ * wb
    corr = w_ * wb * (e**2 - z0 * z0b) + z0 * w_ + z0b * wb - 1
    check(lhs == -corr,
          'Lemma 5, p. 58: (1 - z0 z)(1 - zbar zbar0) = e^2 z zbar iff '
          'z zbar (e^2 - z0 zbar0) + z0 z + zbar0 zbar - 1 = 0')
    printed = w_ * wb * (e**2 - z0 * z0b) + z0 * w_ + z0b * w_ - 1
    refuted(lhs == -printed,
            'Lemma 5, p. 58: printed term zbar0 z')
    conj = lambda f: f(wb, w_, z0b, z0, e)       # simultaneous swap
    check(conj(corr) == corr and conj(printed) != printed,
          'Lemma 5: the corrected equation is real, the printed one is not')

    # Lemma 6, p. 59.
    check(F5(a * w5 + b).derivative(w5) * (c * w5 + d)
          - F5(a * w5 + b) * c == a * d - b * c,
          'Lemma 6, p. 59: dz = (a dw (cw + d) - c dw (aw + b))/(cw + d)^2 '
          '= (ad - bc)/(cw + d)^2 dw')
    refuted(a * (c * w5 + d) - c * (a * w5 + d) == a * d - b * c,
            'Lemma 6, p. 59: printed numerator a(cw + d) - c(aw + d)')
    # a concrete map z = ((1 + 2i)w + 3)/(w + 2 - i), w = u + iv
    A_, B_, C_, D_ = 1 + 2 * i, K(3), K(1), 2 - i
    Puv2 = PolynomialRing(QQ, ['u', 'v'])
    uu, vv = Puv2.gens()
    Fr = Puv2.fraction_field()
    # z = (A w + B)/(C w + D); real and imaginary parts
    num_re = A_[0] * uu - A_[1] * vv + B_[0]
    num_im = A_[0] * vv + A_[1] * uu + B_[1]
    den_re = C_[0] * uu - C_[1] * vv + D_[0]
    den_im = C_[0] * vv + C_[1] * uu + D_[1]
    dd = den_re**2 + den_im**2
    zr = Fr(num_re * den_re + num_im * den_im) / dd
    zi = Fr(num_im * den_re - num_re * den_im) / dd
    Mr = jac([zr, zi], [uu, vv])
    det_ = A_ * D_ - B_ * C_
    fac = (det_[0]**2 + det_[1]**2) / Fr(dd**2)
    check(Mr.transpose() * Mr == fac * identity_matrix(Fr, 2),
          'Lemma 6, p. 59: dx^2 + dy^2 = |ad - bc|^2/|cw + d|^4 (du^2 + '
          'dv^2) for z = ((1 + 2i)w + 3)/(w + 2 - i)')
    refuted(Mr.transpose() * Mr == (det_[0]**2 + det_[1]**2) / Fr(dd)
            * identity_matrix(Fr, 2),
            'Lemma 6, p. 59: printed |cw + d|^2 in the real form')

    # p. 60: the inverse map, the unit circle, the diameter.
    Pz = PolynomialRing(K, ['z'])
    zz = Pz.gen()
    Fz = Pz.fraction_field()
    wz = Fz(zz - 1) / (i * (zz + 1))
    check((1 + i * wz) / (1 - i * wz) == zz,
          'p. 59: w = (z - 1)/(i(z + 1)) is the inverse of z = (1 + iw)/'
          '(1 - iw)')
    Pq = PolynomialRing(K, ['q'])
    qe = Pq.gen()
    Fqe = Pq.fraction_field()
    lam = Fqe(qe - 1) / (i * (qe + 1))
    lam_bar = (1 / Fqe(qe) - 1) / (-i * (1 / Fqe(qe) + 1))   # qbar = 1/q
    check(lam_bar == lam, 'p. 60: for |q| = 1, conj(lambda) = lambda: the '
          'unit circle goes to the real axis')
    sv = SR.var('sv')
    wdiam = (sv - 1) / (SR(sqrt(-1)) * (sv + 1))
    check(zero(wdiam.real_part().subs(sv=QQ(1) / 3))
          and zero(wdiam.subs(sv=0) - SR(sqrt(-1))),
          'p. 60: the diameter through 0 and -1 goes to the imaginary axis')

    # p. 61: arc length on r = r0 and the vertical segment.
    Ph = PolynomialRing(QQ, ['C', 'S'])
    Ch, Sh = Ph.gens()
    Fh = Ph.fraction_field()
    # F(phi) = ln tg(phi/2): F' = (tg)'/tg with tg = S/C, d/dphi of half angle
    tg = Fh(Sh) / Ch
    dtg = D(tg, pairs=[(Ch, Sh, QQ(1) / 2)])
    Ih2 = Ph.ideal([Ch**2 + Sh**2 - 1])
    check(in_ideal(Ih2, dtg / tg - 1 / Fh(2 * Sh * Ch)),
          'p. 61: d/dphi ln tg(phi/2) = 1/sin phi')
    ratio = Fh(1 + (Ch**2 - Sh**2)) / (1 - (Ch**2 - Sh**2))  # (1+t)/(1-t)
    dratio = D(ratio, pairs=[(Ch, Sh, QQ(1) / 2)])
    check(in_ideal(Ih2, (dratio / ratio / 2 + 1 / Fh(2 * Sh * Ch))
                   .numerator()),
          'p. 61: d/dphi (1/2) ln((1 + cos phi)/(1 - cos phi)) = '
          '-1/sin phi')
    check(in_ideal(Ih2, (ratio - Fh(Ch**2) / Sh**2).numerator()),
          'p. 61: (1 + cos phi)/(1 - cos phi) = ctg^2(phi/2), so the chain '
          'ends with ln(tg(phi_1/2)/tg(phi_2/2))')
    ph1, ph2 = 2 * pi / 3, pi / 3
    F_ = lambda p: log(tan(p / 2))
    value = log(tan(ph1 / 2) / tan(ph2 / 2))
    check(zero((F_(ph1) - F_(ph2)) - value),
          'p. 61: int_(phi_2)^(phi_1) dphi/sin phi = ln(tg(phi_1/2)/'
          'tg(phi_2/2)) (phi_1 = 2pi/3, phi_2 = pi/3)')
    refuted(zero((F_(ph2) - F_(ph1)) - value),
            'p. 61: printed limits phi_1 (below), phi_2 (above)')
    yv = SR.var('yv')
    seg = integrate(1 / yv, yv, 1, 2)                 # P_2 at y = 1, P_1 at 2
    check(zero(seg - sage_abs(log(SR(1) / 2))),
          'p. 61: the vertical segment has length |ln(y_2/y_1)|')
    refuted(bool(log(SR(1) / 2) > 0),
            'p. 61: printed l(P_1, P_2) = ln(y_2/y_1) for P_1 above P_2 '
            '(y_1 = 2, y_2 = 1)')
    kk, vh = SR.var('kk vh')
    check(zero(kk**2 / (kk * vh)**2 - 1 / vh**2),
          'p. 61: (du^2 + dv^2)/v^2 is invariant under w -> k w')

    # p. 62: l_12 and the triangle inequality.
    Q2 = PolynomialRing(QQ, ['q1', 'q2'])
    q1, q2 = Q2.gens()
    F2 = Q2.fraction_field()
    ch = lambda q_: (q_ + 1 / F2(q_)) / 2
    sh = lambda q_: (q_ - 1 / F2(q_)) / 2
    check(ch(q1 / F2(q2)) == ch(q1) * ch(q2) - sh(q1) * sh(q2),
          'p. 62: ch(chi_1 - chi_2) = x_1 x_2 - y_1 y_2 = -<e_1, e_2>, so '
          'l_12 = |chi_1 - chi_2| = arcch(-<e_1, e_2>)')
    c1, c2 = SR(1), SR(-1)
    refuted(sage_abs(c1 - c2) == sage_abs(arccosh(cosh(c2))
                                          - arccosh(cosh(c1))),
            'p. 62: printed |chi_1 - chi_2| = |arcch x_2 - arcch x_1| '
            '(chi_1 = 1, chi_2 = -1)')
    e1 = vector(QQ, [1, 0, 0])
    e2 = vector(QQ, [QQ(5) / 3, QQ(4) / 3, 0])
    lor = lambda U, V: -U[0] * V[0] + U[1] * V[1] + U[2] * V[2]
    check(lor(e1, e1) == -1 and lor(e2, e2) == -1 and lor(e1, e2) < 0,
          'p. 62: <e_1, e_2> < 0 for e_1, e_2 on the upper sheet')
    refuted(lor(e1, e2) > 0,
            'p. 62: printed "all three products are positive"')
    T3 = PolynomialRing(QQ, ['A', 'B', 'C'])
    A, B, C = T3.gens()                  # <e1,e2>, <e2,e3>, <e1,e3>
    check((-A - B * C)**2 - (B**2 - 1) * (C**2 - 1)
          == A**2 + B**2 + C**2 + 2 * A * B * C - 1,
          'p. 62: the squared inequality is -1 + 2ABC + A^2 + C^2 + B^2 <= 0')
    refuted((-A - B * C)**2 - (B**2 - 1) * (C**2 - 1)
            == A**2 - B**2 + C**2 + 2 * A * B * C - 1,
            'p. 62: printed sign "- <e_2, e_3>^2"')
    Gram = matrix(T3, [[-1, A, C], [A, -1, B], [C, B, -1]])
    check(Gram.det() == -1 + A**2 + B**2 + C**2 + 2 * A * B * C,
          'p. 62: the left side is the Gram determinant')
    Mg = PolynomialRing(QQ, [f'm{i}{j}' for i in range(3) for j in range(3)])
    Mm = matrix(Mg, 3, 3, Mg.gens())
    eta = matrix(Mg, [[-1, 0, 0], [0, 1, 0], [0, 0, 1]])
    check((Mm.transpose() * eta * Mm).det() == -Mm.det()**2,
          'p. 62: Gram(e_1, e_2, e_3) = -det(M)^2 <= 0 (sign of det(eta))')
    # Problem 1 to § 4: a right isosceles triangle, angle sum < pi.
    K3 = QuadraticField(3, 's3')
    s3 = K3.gen()
    v0 = vector(K3, [1, 0, 0])
    v1 = vector(K3, [2, s3, 0])
    v2 = vector(K3, [2, 0, s3])
    lor3 = lambda U, V: -U[0] * V[0] + U[1] * V[1] + U[2] * V[2]
    tang = lambda P_, Q_: Q_ + lor3(Q_, P_) * P_       # toward Q_ at P_
    on = all(lor3(vv_, vv_) == -1 for vv_ in (v0, v1, v2))
    t01, t02 = tang(v0, v1), tang(v0, v2)
    t10, t12 = tang(v1, v0), tang(v1, v2)
    cos1_sq = lor3(t10, t12)**2 / (lor3(t10, t10) * lor3(t12, t12))
    check(on and lor3(t01, t02) == 0 and lor3(t10, t12) > 0
          and cos1_sq == QQ(4) / 5 and cos1_sq > QQ(1) / 2,
          'Problem 1 to § 4: angles pi/2 and two angles with cos^2 = 4/5 '
          '(each < pi/4): the sum is < pi')


def main():
    section_1()
    section_2()
    section_3()
    section_4()
    print(f'ok chapter-1: {COUNT[0]} checks')


if __name__ == '__main__':
    main()
