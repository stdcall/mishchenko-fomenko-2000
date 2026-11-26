r"""Exact checks of Chapter 6 "Теория гомологий" (Sage).

Run: sage -python checks/sage/chapter-6.py (plain asserts; do not use -O).
The last line of the output is "ok chapter-6: N checks".  Last run with
SageMath 10.9.

Book: A. S. Mishchenko, A. T. Fomenko, Kurs differentsial'noi geometrii i
topologii, 2nd ed., Faktorial Press, Moscow, 2000, Chapter 6 (pp. 372-406).
Pages are the printed pages.  The expected values are the book's: formulas,
signs and numbers written below as literals read off the printed page; our
Typst source is not parsed.  Where the book is wrong, the printed reading is
kept as a refuted check (function `refuted`: the printed reading must fail)
next to the corrected one.  Exterior forms are dictionaries {increasing index
tuple: coefficient} with the standard Grassmann sign rule; coefficients lie
in polynomial rings over QQ or in the symbolic ring with arbitrary
(unspecified) smooth functions; no floating point is used.

What is checked, by section:

Section 1, forms and de Rham cohomology (content/06-01-forms.typ,
pp. 372-388)
  * pp. 373-374: for a symmetric connection the Christoffel terms of the
    alternated covariant derivative (2) cancel (n = 3, k = 1, 2, generic
    symmetric Gamma; a non-symmetric Gamma leaves them); formula (3) equals
    (-1)^k k! times formula (4), and (4) is the exterior derivative
    (R^4, all k, arbitrary coefficients);
  * p. 375: the signs of the permutation sigma(i, I, J) (i first, then I,
    then J): it is the product of the signs of the formula (6) for {i} u I
    and of the shuffle (5) of ({i} u I, J), and also (-1)^p times the
    corresponding product for (I, {i} u J); exhaustive for n <= 6.  The
    printed names sigma(I, K, i) and sigma(i, I, K) are a notational slip
    (K is the whole set), not a computable claim;
  * Theorem 1 (p. 374): the Leibniz rule a) for degrees p + q <= 3 and
    d d = 0 b) for degrees k <= 3, on R^4 with arbitrary coefficients;
  * pp. 377-378: the iterated integrals give a solution of df = Omega for
    every closed polynomial 1-form with coefficients of degree <= 2 on R^3
    and R^4 (a basis) and an arbitrary base point x_0;
  * Examples 2, 3 (pp. 381-382): the primitive (17) of a cubic g on an
    interval; on the circle a trigonometric polynomial g of degree <= 3 has
    mean a_0, g - a_0 has a 2 pi-periodic primitive, g = 1 has none;
  * Theorem 3 (pp. 383-384): the coordinate formula (23) agrees with the
    definition on vectors, f^* d = d f^* (arbitrary maps R^2 -> R^3, forms of
    degree 0, 1, 2), (g f)^* = f^* g^* (polynomial maps, basis forms);
  * Theorem 4 (pp. 385-387): with Omega = F^*(omega) = Omega_1 + Omega_2 ^ dt
    and D as in (26): d Omega_1 = d_x Omega_1 + (-1)^k (d/dt) Omega_1 ^ dt
    for a k-form (the printed reading without (-1)^k refuted for k = 1);
    the dt-part of F^*(d omega) is (-1)^k (d/dt) Omega_1 + d_x Omega_2
    (arbitrary F: R^2 x I -> R^3 and omega, k = 0..3); (27); with D computed
    by integration, f_1^* - f_0^* = (-1)^k (D d - d D) for all basis forms
    of degree k = 0..3 with coefficients of degree <= 1 on R^3 under an
    explicit polynomial homotopy; the printed final formula
    f_1^* - f_0^* = D d - d D holds for even k and is refuted for k = 1;
    (24) as printed, (f_0^* - f_1^*) = d D +- D d with D of (26), is
    refuted for k = 1 with either sign (translation on R, omega = y dy);
    the corrected (24) with (-1)^k (d D - D d) holds;
  * the Corollary and the Poincare lemma (pp. 387-388): for F = t x on R^3
    the form (-1)^(k+1) D omega is a primitive of every closed basis form
    d eta (k = 1, 2, 3; coefficients of eta of degree <= 2); with the
    printed final formula the primitive -D omega fails for k = 1.

Section 2, integration (content/06-02-integration.typ, pp. 388-399)
  * (2) (p. 389): the pullback of dx^1 ^ ... ^ dx^n is det(dx/dy) dy (n = 2,
    3, arbitrary maps; polar coordinates); Proposition 1 c): the change
    y^1 = -x^1 has determinant -1 (n <= 4);
  * pp. 391-392: the induction step for partitions of unity (N <= 6);
  * Proposition 1 a) (p. 393): the pieces U_i \ (U_1 u ... u U_(i-1)) are
    disjoint, their union is U_1 u ... u U_N, and U_(i0) n (U_1 u ... u U_N)
    = U_(i0) for every i0 (all families of N <= 3 subsets of a 4-point
    set); the printed "= U_(i0) n M", which needs the charts to cover M,
    refuted for one chart that covers supp omega but not M;
  * Theorem 1, formula (9) (p. 394): (-1)^n int_M d omega = int_dM omega on
    the cube [0, 1]^n, n = 1..4, the boundary oriented as in the proof of
    the theorem (a frame of the boundary followed by the inner normal is
    positive), for every basis (n - 1)-form with coefficients of degree
    <= 2; Example 1 (Green, pp. 394-395) on the unit disc for general P, Q
    of degree <= 2, the counterclockwise orientation being the boundary
    orientation; Examples 2, 3 (pp. 395-396): the printed d omega; the
    Gauss-Ostrogradsky sign; Example 4 (pp. 396-397): Newton-Leibniz with
    the printed point orientations;
  * Example 5 (p. 398): integral_W d Omega = (-1)^k integral_dW Omega (the
    printed (-1)^(k-1) refuted on [0, 1]^k, k = 1, 2, 3); the path integral
    of p. 399 gives df = omega for every closed polynomial 1-form with
    coefficients of degree <= 2 on R^3 and R^4.

Section 3, degree (content/06-03-degree.typ, pp. 399-406)
  * p. 399-400: z -> z^n on S^1 (n <= 6): f^* d phi = n d phi, the integral
    2 pi n, each of the n arcs contributes 2 pi, the n preimages of a point
    are distinct, degree n;
  * pp. 402-403: z -> z^n on CP(1) (n <= 6): the Jacobian and its printed
    matrix form, n^2 |z^(n-1)|^2; (8) (n <= 5); (9) never meets (0, 0);
    degree n; Theorem 2 for z^n with the spherical area form: the integral
    of f^* Omega is 4 pi n (n <= 4);
  * Theorem 2 (p. 404): a model of the flow on R^1: phi_1(U_0) = U and
    supp phi_1^*(omega) in U_0 hold for the flow carrying Q_0 to Q; the
    printed reading (Q carried to Q_0) refuted;
  * Theorem 3 (pp. 405-406): for a graph x^n = f(x^1, ..., x^(n-1)) with the
    printed normal (f_x, -1)/W, the chart orientation on M and the
    orientation of S^(n-1) as the boundary of the ball by the convention of
    (9): nu^*(Omega) = det(f_ij)/W^(n+1) d sigma (n = 3, 4, arbitrary f);
    for n = 3 det(f_ij)/W^4 is the Gaussian curvature (LN - M^2)/(EG - F^2);
    the printed displays of p. 406; at P_0 the normal is (0, ..., 0, -1)
    (the printed f(P_0) = (0, ..., 0, 1) refuted) and Omega there is
    dx^1 ^ ... ^ dx^(n-1);
  * Theorem 4 and the Remark (p. 406): integral K d sigma = 4 pi (1 - g):
    the sphere (4 pi, degree 1), the torus of revolution (0, degree 0), and
    an algebraic surface of genus 2 (z^2 + (y^2 + x^4 - x^2)^2 = 1/64,
    smooth, Euler characteristic -2 from the signs of K at the six critical
    points of x): the degree of its outward Gauss map at +-e_x is -1; the
    printed lambda = g - 1 refuted (sphere, genus 2).

What these checks do NOT establish.  An identity in a polynomial ring or in
the symbolic ring with arbitrary functions holds for all values of the
written variables, but only in the dimensions and degrees listed; basis
checks cover the stated spaces of polynomial forms only, for the stated
maps and homotopies.  No general theorem of the chapter (Stokes, homotopy
invariance, invariance of the degree, Gauss-Bonnet) is proved here.  The
genus of the algebraic surface rests on Morse theory (the index parity of
the critical points of the height function read off the sign of K), which
is used, not proved.  Nothing here compares our text with the printed book.
"""
from itertools import combinations, permutations, product

from sage.all import (
    AA, QQ, SR, QuadraticField, PolynomialRing, assume, cos, factorial,
    function, gcd, integral, matrix, oo, pi, sin, sqrt, var, vector,
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


# ---------------------------------------------------------------------------
# A small exterior algebra.  A form is a dict {increasing tuple I: coeff}
# meaning sum coeff dx^(i_1) ^ ... ^ dx^(i_k); indices start at 0.
# ---------------------------------------------------------------------------

def perm_sign(seq):
    """Sign of the sequence relative to its increasing rearrangement
    (0 if an index repeats)."""
    seq = list(seq)
    s = 1
    for i in range(len(seq)):
        for j in range(i + 1, len(seq)):
            if seq[i] == seq[j]:
                return 0
            if seq[i] > seq[j]:
                s = -s
    return s


def trivial_zero(c):
    if c in SR and hasattr(c, 'is_trivial_zero'):
        return c.is_trivial_zero()
    return c == 0


def clean(a):
    return {I: c for I, c in a.items() if not trivial_zero(c)}


def fadd(*forms):
    out = {}
    for a in forms:
        for I, c in a.items():
            out[I] = out.get(I, 0) + c
    return clean(out)


def fscale(c, a):
    return clean({I: c * v for I, v in a.items()})


def fsub(a, b):
    return fadd(a, fscale(-1, b))


def fmap(a, op):
    return clean({I: op(c) for I, c in a.items()})


def wedge(a, b):
    out = {}
    for I, c in a.items():
        for J, e in b.items():
            s = perm_sign(I + J)
            if s:
                K = tuple(sorted(I + J))
                out[K] = out.get(K, 0) + s * c * e
    return clean(out)


def dform(a, xs, only=None):
    """Exterior derivative in the coordinates xs; with `only`, the partial
    differential in the listed coordinate indices (d_x on M x I)."""
    out = {}
    idx = range(len(xs)) if only is None else only
    for I, c in a.items():
        for i in idx:
            s = perm_sign((i,) + I)
            if s:
                K = tuple(sorted((i,) + I))
                out[K] = out.get(K, 0) + s * c.derivative(xs[i])
    return clean(out)


def pullback(a, F, xs, ys):
    """Pullback of a (in the coordinates ys) by y = F(x)."""
    dF = [clean({(l,): Fj.derivative(x) for l, x in enumerate(xs)})
          for Fj in F]
    sub = dict(zip(ys, F))
    out = {}
    for I, c in a.items():
        term = {(): c.subs(sub)}
        for i in I:
            term = wedge(term, dF[i])
        out = fadd(out, term)
    return out


def sr_zero(c):
    c = SR(c)
    if c.expand().is_trivial_zero():
        return True
    return bool(c.simplify_full() == 0)


def is_zero_form(a):
    """Zero test for forms with symbolic coefficients."""
    return all(sr_zero(c) for c in a.values())


def poly_zero_form(a):
    return all(c == 0 for c in a.values())


def generic_form(n, k, name, xs):
    """A k-form on R^n with arbitrary smooth coefficients of xs."""
    return {I: function('%s%s' % (name, ''.join(str(i + 1) for i in I)
                                    or '0'))(*xs)
            for I in combinations(range(n), k)}


def comp(a, J):
    """Skew-symmetric component a_(j_1 ... j_k) for any index tuple J."""
    s = perm_sign(J)
    if s == 0:
        return 0
    return s * a.get(tuple(sorted(J)), 0)


def split_dt(a, it):
    """Omega = Omega_1 + Omega_2 ^ dt (dt has index it, the largest)."""
    o1 = {I: c for I, c in a.items() if it not in I}
    o2 = {I[:-1]: c for I, c in a.items() if it in I}
    return clean(o1), clean(o2)


def monomials(R, vs, deg):
    """All monomials of total degree <= deg in vs."""
    out = []
    for e in product(range(deg + 1), repeat=len(vs)):
        if sum(e) <= deg:
            m = R(1)
            for v, k in zip(vs, e):
                m *= v ** k
            out.append(m)
    return out


# ---------------------------------------------------------------------------
# Section 1: exterior derivative, cohomology, homotopy invariance
# ---------------------------------------------------------------------------

def section_1():
    n = 4
    xs = list(var('x1 x2 x3 x4'))

    # (3) = (-1)^k k! (4), and (4) is the exterior derivative (p. 374).
    for k in range(0, 4):
        w = generic_form(n, k, 'w', xs)
        dw = dform(w, xs)
        ok4 = ok3 = True
        for J in combinations(range(n), k + 1):
            f4 = sum((-1) ** s * comp(w, J[:s] + J[s + 1:]).derivative(
                xs[J[s]]) for s in range(k + 1))
            f3 = sum(perm_sign(sig) * comp(w, sig[:k]).derivative(
                xs[sig[k]]) for sig in permutations(J))
            ok4 = ok4 and sr_zero(f4 - dw.get(J, 0))
            ok3 = ok3 and sr_zero(f3 - (-1) ** k * factorial(k) * f4)
        check(ok4, 'p. 374, (4) is d omega, k = %d' % k)
        check(ok3, 'p. 374, (3) = (-1)^k k! (4), k = %d' % k)

    # (2): the Christoffel terms cancel for a symmetric connection.
    n3 = 3
    ys = list(var('y1 y2 y3'))
    Gs = {}
    Gn = {}
    for a in range(n3):
        for b in range(n3):
            for c in range(n3):
                lo, hi = min(b, c), max(b, c)
                Gs[a, b, c] = var('Gs_%d_%d_%d' % (a, lo, hi))
                Gn[a, b, c] = var('Gn_%d_%d_%d' % (a, b, c))
    for k in (1, 2):
        w = generic_form(n3, k, 'v', ys)
        for G, symmetric in ((Gs, True), (Gn, False)):
            total_ok = True
            for J in combinations(range(n3), k + 1):
                term = 0
                for sig in permutations(J):
                    l = sig[k]
                    for s in range(k):
                        for al in range(n3):
                            idx = sig[:s] + (al,) + sig[s + 1:k]
                            term += (perm_sign(sig) * G[al, l, sig[s]]
                                     * comp(w, idx))
                total_ok = total_ok and sr_zero(term)
            if symmetric:
                check(total_ok, 'p. 374, Gamma terms cancel, k = %d' % k)
            else:
                check(not total_ok,
                      'p. 374, the cancellation uses Gamma symmetric, k = %d'
                      % k)

    # p. 375: signs of sigma(i, I, J) and of (6); exhaustive for n <= 6.
    ok6 = okA = okB = True
    for m in range(1, 7):
        for size in range(1, m + 1):
            for K in combinations(range(m), size):
                for pos, i in enumerate(K):
                    ok6 = ok6 and (perm_sign((i,) + K[:pos] + K[pos + 1:])
                                   == (-1) ** pos)
                    rest = K[:pos] + K[pos + 1:]
                    for p in range(len(rest) + 1):
                        for I in combinations(rest, p):
                            J = tuple(j for j in rest if j not in I)
                            s = perm_sign((i,) + I + J)
                            iI = tuple(sorted((i,) + I))
                            iJ = tuple(sorted((i,) + J))
                            a = perm_sign((i,) + I) * perm_sign(iI + J)
                            b = ((-1) ** p * perm_sign((i,) + J)
                                 * perm_sign(I + iJ))
                            okA = okA and s == a
                            okB = okB and s == b
    check(ok6, 'p. 375, (6): moving i to the front has sign (-1)^position')
    check(okA, 'p. 375, sigma(i, I, J) gives (d omega_1 ^ omega_2)_K')
    check(okB, 'p. 375, sigma(i, I, J) = (-1)^p ... gives '
               '(omega_1 ^ d omega_2)_K')

    # Theorem 1 a) and b) on R^4 with arbitrary coefficients.
    for p in range(4):
        for q in range(4 - p):
            a = generic_form(n, p, 'a', xs)
            b = generic_form(n, q, 'b', xs)
            lhs = dform(wedge(a, b), xs)
            rhs = fadd(wedge(dform(a, xs), b),
                       fscale((-1) ** p, wedge(a, dform(b, xs))))
            check(is_zero_form(fsub(lhs, rhs)),
                  'Theorem 1 a), p = %d, q = %d' % (p, q))
    for k in range(4):
        w = generic_form(n, k, 'c', xs)
        check(is_zero_form(dform(dform(w, xs), xs)),
              'Theorem 1 b), d d = 0, k = %d' % k)

    # pp. 377-378: the iterated integrals solve df = Omega for closed Omega.
    for m in (3, 4):
        names = (['x%d' % i for i in range(1, m + 1)]
                 + ['a%d' % i for i in range(1, m + 1)] + ['s'])
        R = PolynomialRing(QQ, names)
        X, A, s = R.gens()[:m], R.gens()[m:2 * m], R.gens()[2 * m]
        ok = True
        for h in monomials(R, X, 3):
            Om = [h.derivative(xk) for xk in X]
            f = R(0)
            for k in range(m):
                sub = {X[j]: A[j] for j in range(k)}
                sub[X[k]] = s
                prim = Om[k].subs(sub).integral(s)
                f += prim.subs({s: X[k]}) - prim.subs({s: A[k]})
            ok = ok and all(f.derivative(X[j]) == Om[j] for j in range(m))
        check(ok, 'pp. 377-378, the solution of df = Omega, n = %d' % m)

    # Examples 2 and 3 (pp. 381-382).
    xv, sv = var('xv sv')
    co = list(var('k0 k1 k2 k3'))
    g = sum(cf * xv ** j for j, cf in enumerate(co))
    check(sr_zero(integral(g.subs(xv=sv), sv, 0, xv).derivative(xv) - g),
          'Example 2, f = integral_c^x g has df = g dx (cubic g)')
    ph = var('ph')
    a0, a1, a2, a3, b1, b2, b3 = var('a0 a1 a2 a3 b1 b2 b3')
    g = (a0 + a1 * cos(ph) + a2 * cos(2 * ph) + a3 * cos(3 * ph)
         + b1 * sin(ph) + b2 * sin(2 * ph) + b3 * sin(3 * ph))
    c = integral(g, ph, 0, 2 * pi) / (2 * pi)
    check(sr_zero(c - a0), 'Example 3, c is the mean a_0')
    anti = integral(g - c, ph)              # an antiderivative
    prim = anti - anti.subs(ph=0)
    check(sr_zero(prim.subs(ph=ph + 2 * pi) - prim),
          'Example 3, g - c has a 2 pi-periodic primitive')
    check(sr_zero(prim.derivative(ph) - (g - c)),
          'Example 3, the primitive of g - c')
    check(integral(SR(1), ph, 0, 2 * pi) == 2 * pi,
          'Example 3, g = 1 is not in Im d (2 pi != 0)')

    # Theorem 3 (pp. 383-384).
    x12 = list(var('u1 u2'))
    y3 = list(var('y1 y2 y3'))
    F = [function('F%d' % j)(*x12) for j in (1, 2, 3)]
    J = [[Fj.derivative(u) for u in x12] for Fj in F]
    w1 = generic_form(3, 1, 'p', y3)
    pb = pullback(w1, F, x12, y3)
    sub = dict(zip(y3, F))
    check(all(sr_zero(pb.get((l,), 0)
                      - sum(w1[(i,)].subs(sub) * J[i][l] for i in range(3)))
              for l in range(2)),
          'Theorem 3 d), 1-forms: (23) agrees with the definition')
    w2 = generic_form(3, 2, 'q', y3)
    pb = pullback(w2, F, x12, y3)
    u = [J[i][0] for i in range(3)]
    v = [J[i][1] for i in range(3)]
    val = sum(w2[(i, j)].subs(sub) * (u[i] * v[j] - u[j] * v[i])
              for i, j in combinations(range(3), 2))
    check(sr_zero(pb.get((0, 1), 0) - val),
          'Theorem 3 d), 2-forms: (23) agrees with the definition')
    for k in range(3):
        w = generic_form(3, k, 'r', y3)
        lhs = pullback(dform(w, y3), F, x12, y3)
        rhs = dform(pullback(w, F, x12, y3), x12)
        check(is_zero_form(fsub(lhs, rhs)), 'Theorem 3 b), k = %d' % k)
    R = PolynomialRing(QQ, 'u1,u2,y1,y2,y3,z1,z2')
    U1, U2, Y1, Y2, Y3, Z1, Z2 = R.gens()
    fmap_ = [U1 * U2 + 1, U1 ** 2 - U2, U2 ** 3 + U1]     # f: R^2 -> R^3
    gmap_ = [Y1 * Y3 - Y2, Y2 ** 2 + Y1 * Y2 * Y3]       # g: R^3 -> R^2
    gf = [gj.subs(dict(zip([Y1, Y2, Y3], fmap_))) for gj in gmap_]
    ok = True
    for k in range(3):
        for I in combinations(range(2), k):
            for m in monomials(R, [Z1, Z2], 2):
                w = {I: m}
                lhs = pullback(w, gf, [U1, U2], [Z1, Z2])
                rhs = pullback(pullback(w, gmap_, [Y1, Y2, Y3], [Z1, Z2]),
                               fmap_, [U1, U2], [Y1, Y2, Y3])
                ok = ok and poly_zero_form(fsub(lhs, rhs))
    check(ok, 'Theorem 3 a), (g f)^* = f^* g^*')

    # Theorem 4: the decomposition of d Omega and of F^*(d omega).
    xt = list(var('s1 s2 tt'))              # coordinates of M_1 x I
    it = 2
    Fh = [function('H%d' % j)(*xt) for j in (1, 2, 3)]
    for k in range(4):
        # a form on M_1 x I that does not contain dt
        o1 = generic_form(2, k, 'e', xt) if k <= 2 else {}
        do1 = dform(o1, xt)
        dto1 = wedge(fmap(o1, lambda c: c.derivative(xt[it])),
                     {(it,): SR(1)})
        corrected = fadd(dform(o1, xt, only=[0, 1]), fscale((-1) ** k, dto1))
        printed = fadd(dform(o1, xt, only=[0, 1]), dto1)
        if k <= 2:
            check(is_zero_form(fsub(do1, corrected)),
                  'p. 387, d Omega = d_x Omega + (-1)^k Omega_t ^ dt, k = %d'
                  % k)
        if k == 1:
            refuted(is_zero_form(fsub(do1, printed)),
                    'p. 387, d Omega = d_x Omega + Omega_t ^ dt, k = 1')
        w = generic_form(3, k, 'm', y3)
        Om = pullback(w, Fh, xt, y3)
        O1, O2 = split_dt(Om, it)
        A1, A2 = split_dt(pullback(dform(w, y3), Fh, xt, y3), it)
        dtO1 = fmap(O1, lambda c: c.derivative(xt[it]))
        check(is_zero_form(fsub(A1, dform(O1, xt, only=[0, 1]))),
              'p. 387, F^*(d omega) without dt is d_x Omega_1, k = %d' % k)
        check(is_zero_form(fsub(A2, fadd(fscale((-1) ** k, dtO1),
                                         dform(O2, xt, only=[0, 1])))),
              'p. 387, F^*(d omega): (-1)^k Omega_1,t + d_x Omega_2, k = %d'
              % k)
        if k == 1:
            refuted(is_zero_form(fsub(A2, fadd(dtO1,
                                               dform(O2, xt, only=[0, 1])))),
                    'p. 387, F^*(d omega) as printed, k = 1')
        f0 = [Fj.subs({xt[it]: 0}) for Fj in Fh]
        check(is_zero_form(fsub(fmap(O1, lambda c: c.subs({xt[it]: 0})),
                                pullback(w, f0, xt[:2], y3))),
              '(27), f_0^*(omega) = Omega_1(0), k = %d' % k)

    # Theorem 4 with D computed by integration (26)-(29).
    R = PolynomialRing(QQ, 'x1,x2,x3,t,y1,y2,y3')
    X1, X2, X3, T, Y1, Y2, Y3 = R.gens()
    XS, YS = [X1, X2, X3], [Y1, Y2, Y3]
    XT = XS + [T]

    def D_op(w, Fpol):
        _, o2 = split_dt(pullback(w, Fpol, XT, YS), 3)
        out = {}
        for I, c in o2.items():
            prim = c.integral(T)
            out[I] = prim.subs({T: 1}) - prim.subs({T: 0})
        return clean(out)

    def homotopy_parts(w, Fpol):
        f0 = [Fj.subs({T: 0}) for Fj in Fpol]
        f1 = [Fj.subs({T: 1}) for Fj in Fpol]
        diff10 = fsub(pullback(w, f1, XS, YS), pullback(w, f0, XS, YS))
        Dd = D_op(dform(w, YS), Fpol)
        dD = dform(D_op(w, Fpol), XS)
        return diff10, Dd, dD

    Fpol = [X1 + T * X2 ** 2, X2 - T ** 2 * X3 + T * X1 * X3,
            X3 + T * X1 - T ** 3 * X2]
    ok_corr = True
    ok_printed_even = True
    for k in range(4):
        for I in combinations(range(3), k):
            for m in monomials(R, YS, 1):
                w = {I: m}
                diff10, Dd, dD = homotopy_parts(w, Fpol)
                ok_corr = ok_corr and poly_zero_form(
                    fsub(diff10, fscale((-1) ** k, fsub(Dd, dD))))
                if k % 2 == 0:
                    ok_printed_even = ok_printed_even and poly_zero_form(
                        fsub(diff10, fsub(Dd, dD)))
    check(ok_corr, 'p. 387, f_1^* - f_0^* = (-1)^k (D d - d D), k = 0..3')
    check(ok_printed_even, 'p. 387, the printed formula holds for even k')
    w = {(1,): Y1}
    diff10, Dd, dD = homotopy_parts(w, Fpol)
    refuted(poly_zero_form(fsub(diff10, fsub(Dd, dD))),
            'p. 387, f_1^* - f_0^* = (D d - d D), omega = y1 dy2')

    # (24) on R with the translation F(x, t) = x + t and omega = y dy.
    R1 = PolynomialRing(QQ, 'x,t,y')
    x_, t_, y_ = R1.gens()
    w = {(0,): y_}
    Om = pullback(w, [x_ + t_], [x_, t_], [y_])
    _, o2 = split_dt(Om, 1)
    Dw = {(): o2[()].integral(t_).subs({t_: 1}) - o2[()].integral(t_).subs(
        {t_: 0})}
    dD = dform(Dw, [x_])
    Dd = {}                                   # d omega = 0 on R
    lhs = fsub(pullback(w, [x_], [x_], [y_]), pullback(w, [x_ + 1], [x_],
                                                     [y_]))
    refuted(poly_zero_form(fsub(lhs, fadd(dD, Dd))),
            '(24) with +: f_0^* - f_1^* = d D + D d, k = 1')
    refuted(poly_zero_form(fsub(lhs, fsub(dD, Dd))),
            '(24) with -: f_0^* - f_1^* = d D - D d, k = 1')
    check(poly_zero_form(fsub(lhs, fscale(-1, fsub(dD, Dd)))),
          '(24) corrected: f_0^* - f_1^* = (-1)^k (d D - D d), k = 1')

    # Corollary / Poincare lemma: F = t x on R^3.
    Fcone = [T * X1, T * X2, T * X3]
    ok_prim = True
    for k in (1, 2, 3):
        for I in combinations(range(3), k - 1):
            for m in monomials(R, YS, 2):
                om = dform({I: m}, YS)
                if not om:
                    continue
                prim = fscale((-1) ** (k + 1), D_op(om, Fcone))
                target = pullback(om, XS, XS, YS)      # omega in x
                ok_prim = ok_prim and poly_zero_form(
                    fsub(dform(prim, XS), target))
    check(ok_prim, 'Poincare lemma: d((-1)^(k+1) D omega) = omega, k <= 3')
    om = {(0,): R(1)}                                   # omega = dy1
    prim = fscale(-1, D_op(om, Fcone))
    refuted(poly_zero_form(fsub(dform(prim, XS), {(0,): R(1)})),
            'Poincare lemma with the printed formula: -D omega, k = 1')
    check(poly_zero_form(fsub(homotopy_parts({(): R(5)}, Fcone)[0], {})),
          'Corollary, H^0: a constant is fixed by f_1^* - f_0^*')


# ---------------------------------------------------------------------------
# Section 2: integration of forms, Stokes
# ---------------------------------------------------------------------------

def section_2():
    # (2), p. 389: the pullback of the volume form is the Jacobian.
    for n in (2, 3):
        ys = list(var(' '.join('yy%d' % i for i in range(1, n + 1))))
        xs = list(var(' '.join('xx%d' % i for i in range(1, n + 1))))
        Xf = [function('phi%d' % i)(*ys) for i in range(1, n + 1)]
        pb = pullback({tuple(range(n)): SR(1)}, Xf, ys, xs)
        Jm = matrix(SR, n, n, lambda i, j: Xf[i].derivative(ys[j]))
        check(sr_zero(pb.get(tuple(range(n)), 0) - Jm.det()),
              '(2): dx^1 ^ ... ^ dx^n = det(dx/dy) dy, n = %d' % n)
    r, th = var('r th')
    xx, yy = var('xx yy')
    pb = pullback({(0, 1): SR(1)}, [r * cos(th), r * sin(th)], [r, th],
                  [xx, yy])
    check(sr_zero(pb[(0, 1)] - r), '(2): dx ^ dy = r dr ^ dth')
    for n in range(1, 5):
        Jm = matrix(QQ, n, n, lambda i, j: (-1 if i == j == 0 else
                                            (1 if i == j else 0)))
        check(Jm.det() == -1,
              'Proposition 1 c): y^1 = -x^1 has det -1, n = %d' % n)

    # pp. 391-392: the induction step for partitions of unity.
    for N in range(2, 7):
        R = PolynomialRing(QQ, ['psi%d' % i for i in range(1, N + 1)]
                           + ['chi'])
        psi, chi = R.gens()[:N], R.gens()[N]
        Iid = R.ideal([sum(psi), chi * psi[-1] - psi[-1]])
        check(sum(p_ - chi * p_ for p_ in psi[:-1]) in Iid,
              'p. 392, sum (psi_a - chi psi_a) = 0, N = %d' % N)
        check(psi[-1] + sum(chi * p_ for p_ in psi[:-1]) in Iid,
              'p. 392, psi_N = -sum chi psi_a, N = %d' % N)

    # Proposition 1 a), p. 393: set algebra on a finite model.
    Mset = frozenset(range(4))
    subsets = [frozenset(c) for k in range(5) for c in combinations(Mset, k)]
    ok = True
    for N in (1, 2, 3):
        for fam in combinations(subsets, N):
            pieces = [fam[i] - frozenset().union(*fam[:i]) for i in range(N)]
            union = frozenset().union(*fam)
            ok = ok and frozenset().union(*pieces) == union
            ok = ok and all(not (pieces[i] & pieces[j])
                            for i, j in combinations(range(N), 2))
            ok = ok and all(fam[i0] & union == fam[i0] for i0 in range(N))
    check(ok, 'p. 393, the pieces partition U_1 u ... u U_N, which '
              'contains U_(i0)')
    chart, supp = frozenset({0, 1}), frozenset({0})
    check(supp <= chart, 'p. 393, one chart covering supp omega')
    refuted(chart == Mset, 'p. 393, the union of the charts is M')

    # Theorem 1, (9), on the cube [0, 1]^n with the boundary orientation of
    # the proof: (frame of the boundary, inner normal) is positive.
    def cube_integral(c, X):
        R_ = X[0].parent() if X else None
        for x in X:
            prim = R_(c).integral(x)
            c = R_(prim.subs({x: 1}) - prim.subs({x: 0}))
        return c

    for n in range(1, 5):
        # an unused extra variable keeps the ring multivariate for n = 1
        R = PolynomialRing(QQ, ['x%d' % i for i in range(1, n + 1)] + ['zz'])
        X = R.gens()[:n]
        full = tuple(range(n))
        ok9 = True
        refute_ex5 = False
        for i in range(n):
            I = full[:i] + full[i + 1:]
            for m in monomials(R, X, 2):
                w = {I: m}
                lhs = (-1) ** n * cube_integral(
                    dform(w, X).get(full, R(0)), X)
                rhs = R(0)
                for c0, inner in ((0, 1), (1, -1)):
                    cols = [[1 if r_ == j else 0 for r_ in range(n)]
                            for j in I]
                    cols.append([inner if r_ == i else 0 for r_ in range(n)])
                    sgn = matrix(QQ, cols).transpose().det()
                    face = m.subs({X[i]: c0})
                    rhs += sgn * cube_integral(face, [X[j] for j in I])
                ok9 = ok9 and lhs == rhs
                lhs_ex5 = (-1) ** (n - 1) * cube_integral(
                    dform(w, X).get(full, R(0)), X)
                refute_ex5 = refute_ex5 or lhs_ex5 != rhs
        check(ok9, '(9): (-1)^n int d omega = int_boundary omega, cube, '
                   'n = %d' % n)
        if n <= 3:
            refuted(not refute_ex5,
                    'Example 5: int_W d Omega = (-1)^(k-1) int_dW Omega, '
                    'k = %d' % n)

    # Example 1 (Green) on the unit disc.
    s, r, th = var('s r th')
    xv, yv = var('xv yv')
    cP = list(var('cp0 cp1 cp2 cp3 cp4 cp5'))
    cQ = list(var('cq0 cq1 cq2 cq3 cq4 cq5'))
    mons = [SR(1), xv, yv, xv ** 2, xv * yv, yv ** 2]
    P = sum(a * b for a, b in zip(cP, mons))
    Q = sum(a * b for a, b in zip(cQ, mons))
    curve = {xv: cos(s), yv: sin(s)}
    line = integral(P.subs(curve) * (-sin(s)) + Q.subs(curve) * cos(s),
                    s, 0, 2 * pi)
    dens = (Q.derivative(xv) - P.derivative(yv)).subs(
        {xv: r * cos(th), yv: r * sin(th)}) * r
    double = integral(integral(dens, r, 0, 1), th, 0, 2 * pi)
    check(sr_zero(line - double), 'Example 1, Green on the unit disc')
    tangent = vector(SR, [-sin(s), cos(s)])
    inner = vector(SR, [-cos(s), -sin(s)])
    check(sr_zero(matrix(SR, [tangent, inner]).transpose().det() - 1),
          'Example 1, counterclockwise = boundary orientation of (9)')

    # Examples 2, 3: the printed d omega.
    x3 = list(var('w1 w2 w3'))
    Pf, Qf, Rf = [function(nm)(*x3) for nm in ('PP', 'QQf', 'RR')]
    d1 = dform({(0,): Pf, (1,): Qf, (2,): Rf}, x3)
    pr = {(0, 1): Qf.derivative(x3[0]) - Pf.derivative(x3[1]),
          (1, 2): Rf.derivative(x3[1]) - Qf.derivative(x3[2]),
          (0, 2): -(Pf.derivative(x3[2]) - Rf.derivative(x3[0]))}
    check(is_zero_form(fsub(d1, pr)), 'Example 2, d omega in R^3')
    d2 = dform({(0, 1): Pf, (1, 2): Qf, (0, 2): -Rf}, x3)
    check(sr_zero(d2[(0, 1, 2)] - Pf.derivative(x3[2])
                  - Qf.derivative(x3[0]) - Rf.derivative(x3[1])),
          'Example 3, d omega = (P_3 + Q_1 + R_2) dx^1 ^ dx^2 ^ dx^3')
    # The outer normal reverses the orientation of (9) on every face (n = 3)
    for i in range(3):
        I = [j for j in range(3) if j != i]
        cols = [[1 if r_ == j else 0 for r_ in range(3)] for j in I]
        inner_ = matrix(QQ, cols + [[1 if r_ == i else 0
                                     for r_ in range(3)]]).det()
        outer_ = matrix(QQ, cols + [[-1 if r_ == i else 0
                                     for r_ in range(3)]]).det()
        check(inner_ == -outer_,
              'Example 3, classical orientation is opposite, face %d' % i)
    # Example 4: Newton-Leibniz, a positive, b negative.
    a_, b_ = var('a_ b_')
    co = list(var('k0 k1 k2 k3'))
    fpol = sum(cf * xv ** j for j, cf in enumerate(co))
    bdry = fpol.subs(xv=a_) - fpol.subs(xv=b_)
    check(sr_zero((-1) ** 1 * integral(fpol.derivative(xv), xv, a_, b_)
                  - bdry), 'Example 4, int_[a,b] df = (-1)^1 int_d f')

    # Example 5, p. 399: the path integral is a primitive.
    for m in (3, 4):
        R = PolynomialRing(QQ, ['x%d' % i for i in range(1, m + 1)] + ['s'])
        X, s_ = R.gens()[:m], R.gens()[m]
        ok = True
        for h in monomials(R, X, 3):
            gk = [h.derivative(xk) for xk in X]
            f = R(0)
            for k in range(m):
                sub = {X[j]: 0 for j in range(k + 1, m)}
                sub[X[k]] = s_
                prim = gk[k].subs(sub).integral(s_)
                f += prim.subs({s_: X[k]}) - prim.subs({s_: 0})
            ok = ok and all(f.derivative(X[j]) == gk[j] for j in range(m))
        check(ok, 'Example 5, p. 399: df = omega, n = %d' % m)


# ---------------------------------------------------------------------------
# Section 3: degree, Gauss map, Gauss-Bonnet
# ---------------------------------------------------------------------------

def gaussian_curvature_times_area(rr, u, v):
    """(K, sqrt(g)^2 = g, numerator) for a parametrized surface rr(u, v):
    K = (<r_uu, X><r_vv, X> - <r_uv, X>^2) / g^2 with X = r_u x r_v."""
    ru, rv = rr.derivative(u), rr.derivative(v)
    X = ru.cross_product(rv)
    g = X.dot_product(X)
    num = (rr.derivative(u, 2).dot_product(X)
           * rr.derivative(v, 2).dot_product(X)
           - rr.derivative(u).derivative(v).dot_product(X) ** 2)
    return num / g ** 2, g


def section_3():
    # p. 399-400: z -> z^n on S^1.
    ph = var('ph')
    Rz = PolynomialRing(QQ, 'z')
    z = Rz.gen()
    for n in range(1, 7):
        pb = pullback({(0,): SR(1)}, [n * ph], [ph], [var('psi_')])
        check(pb == {(0,): n}, 'p. 400, f^* d phi = n d phi, n = %d' % n)
        check(integral(SR(n), ph, 0, 2 * pi) == 2 * pi * n,
              'p. 400, (1): the integral is 2 pi n, n = %d' % n)
        check(all(integral(SR(n), ph, 2 * pi * (k - 1) / n, 2 * pi * k / n)
                  == 2 * pi for k in range(1, n + 1)),
              'p. 400, each arc I_k contributes 2 pi, n = %d' % n)
        check(gcd(z ** n - 1, n * z ** (n - 1)) == 1,
              'p. 399, z^n = z_0 has n distinct roots, n = %d' % n)

    # pp. 402-403: z -> z^n on CP(1).
    Kf = QuadraticField(-1, 'i')
    ii = Kf.gen()
    RK = PolynomialRing(Kf, 'x,y')
    x, y = RK.gens()
    RQ = PolynomialRing(QQ, 'x,y')
    xq, yq = RQ.gens()

    def re_im(p):
        re = sum(QQ(c.list()[0]) * xq ** e[0] * yq ** e[1]
                 for e, c in p.dict().items())
        im = sum(QQ(c.list()[1]) * xq ** e[0] * yq ** e[1]
                 for e, c in p.dict().items())
        return RQ(re), RQ(im)

    for n in range(1, 7):
        u, v = re_im((x + ii * y) ** n)
        du = re_im(n * (x + ii * y) ** (n - 1))
        zr = re_im((x + ii * y) ** (n - 1))
        jac = u.derivative(xq) * v.derivative(yq) - u.derivative(yq) * \
            v.derivative(xq)
        check(u.derivative(xq) == du[0] and u.derivative(yq) == -du[1]
              and v.derivative(xq) == du[1] and v.derivative(yq) == du[0],
              'p. 403, the Jacobi matrix (Re w\', -Im w\'; Im w\', Re w\'), '
              'n = %d' % n)
        mform = n ** 2 * matrix(RQ, [[zr[0], -zr[1]], [zr[1], zr[0]]]).det()
        check(jac == mform == n ** 2 * (xq ** 2 + yq ** 2) ** (n - 1),
              'p. 403, det = n^2 |z^(n-1)|^2, n = %d' % n)
    for n in range(1, 6):
        names = ['a%d' % j for j in range(n)] + ['z0', 'z1']
        Rh = PolynomialRing(QQ, names)
        A, z0, z1 = Rh.gens()[:n], Rh.gens()[n], Rh.gens()[n + 1]
        w1 = z1 ** n + sum(A[j] * z1 ** j * z0 ** (n - j) for j in range(n))
        w0 = z0 ** n
        Fr = Rh.fraction_field()
        zp = Fr(z0) / Fr(z1)
        den = 1 + sum(A[j] * zp ** (n - j) for j in range(n))
        check(Fr(w0) / Fr(w1) == zp ** n / den, '(8), n = %d' % n)
        # (9): w_1 = z_1^n + t (...); the bracket vanishes at z_0 = 0, so
        # (w_0, w_1) != (0, 0) for every t when (z_0, z_1) != (0, 0).
        bracket = w1 - z1 ** n
        check(bracket.subs({z0: 0}) == 0,
              '(9) at z_0 = 0 is z_1^n != 0 for every t, n = %d' % n)
    rho, tht = var('rho tht')
    assume(rho > 0)
    for n in range(1, 5):
        dens = 4 * n ** 2 * rho ** (2 * n - 2) / (1 + rho ** (2 * n)) ** 2
        tot = integral(integral(dens * rho, rho, 0, oo), tht, 0, 2 * pi)
        check(sr_zero(tot - 4 * pi * n),
              'Theorem 2 for z^n: int f^* Omega = 4 pi n, n = %d' % n)
    area = integral(integral(4 / (1 + rho ** 2) ** 2 * rho, rho, 0, oo),
                    tht, 0, 2 * pi)
    check(sr_zero(area - 4 * pi), 'the area form of CP(1) has total 4 pi')

    # Theorem 2, p. 404: which way the flow carries Q_0 and Q.
    Q, Q0, eps = QQ(3), QQ(0), QQ(1) / 2
    U = (Q - eps, Q + eps)
    U0 = (Q0 - eps, Q0 + eps)

    def flow(c):
        return lambda p: p + c          # phi_1 of the field c on R

    phi1 = flow(Q - Q0)                 # carries Q_0 to Q
    check(phi1(Q0) == Q and (phi1(U0[0]), phi1(U0[1])) == U,
          'p. 404, phi_1(U_0) = U for the flow carrying Q_0 to Q')
    # supp phi_1^*(omega) = phi_1^(-1)(supp omega)
    check((U[0] - (Q - Q0), U[1] - (Q - Q0)) == U0,
          'p. 404, supp omega_1 lies in U_0')
    psi1 = flow(Q0 - Q)                 # carries Q to Q_0 (printed)
    refuted((psi1(U0[0]), psi1(U0[1])) == U,
            'p. 404, phi_1(U_0) = U for the flow carrying Q to Q_0')
    refuted((U[0] - (Q0 - Q), U[1] - (Q0 - Q)) == U0,
            'p. 404, supp omega_1 in U_0 for the flow carrying Q to Q_0')
    xs_ = var('xs_')
    bump = (1 - (xs_ - Q) ** 2 / eps ** 2) ** 2
    check(integral(bump.subs(xs_=xs_ + (Q - Q0)), xs_, U0[0], U0[1])
          == integral(bump, xs_, U[0], U[1]),
          'p. 404, int omega_1 = int omega for the model flow')

    # Theorem 3 (pp. 405-406): the Gauss map of a graph.
    for n in (3, 4):
        Xs = list(var(' '.join('g%d' % i for i in range(1, n + 1))))
        # Omega on S^(n-1) as the boundary of the ball by the convention of
        # (9): Omega(v_1, ..., v_(n-1)) = det(v_1, ..., v_(n-1), inner normal)
        Om = {}
        for i in range(n):
            cols = [[1 if r_ == j else 0 for r_ in range(n)]
                    for j in range(n) if j != i]
            cols.append([-Xs[r_] for r_ in range(n)])
            Om[tuple(j for j in range(n) if j != i)] = \
                matrix(SR, cols).transpose().det()
        south = {Xs[j]: 0 for j in range(n - 1)}
        south[Xs[n - 1]] = -1
        north = dict(south)
        north[Xs[n - 1]] = 1
        top = tuple(range(n - 1))
        check(all(sr_zero(c.subs(south) - (1 if I == top else 0))
                  for I, c in Om.items()),
              'p. 405, Omega = dx^1 ^ ... ^ dx^(n-1) at (0, ..., 0, -1), '
              'n = %d' % n)
        check(sr_zero(Om[top].subs(north) + 1),
              'at (0, ..., 0, 1) this Omega is -dx^1 ^ ... ^ dx^(n-1), '
              'n = %d' % n)
        dOm = dform(Om, Xs)
        check(sr_zero(dOm[tuple(range(n))] - (-1) ** n * n),
              '(9) for the ball: int Omega = n vol > 0, n = %d' % n)
        us = list(var(' '.join('h%d' % i for i in range(1, n))))
        f = function('f')(*us)
        fg = [f.derivative(uu) for uu in us]
        W = sqrt(1 + sum(c ** 2 for c in fg))
        nu = [c / W for c in fg] + [-1 / W]
        pb = pullback(Om, nu, us, Xs)
        H = matrix(SR, n - 1, n - 1,
                   lambda i, j: f.derivative(us[i]).derivative(us[j]))
        check(sr_zero(pb[top] - H.det() / W ** n),
              'Theorem 3: nu^* Omega = det(f_ij)/W^(n+1) d sigma, n = %d' % n)
        # p. 406: d(f_i / W)
        ok = True
        for i in range(n - 1):
            lhs = dform({(): fg[i] / W}, us)
            rhs = fsub(fscale(1 / W, dform({(): fg[i]}, us)),
                       fscale(fg[i] / W ** 3,
                              fadd(*[fscale(fg[j], dform({(): fg[j]}, us))
                                     for j in range(n - 1)])))
            ok = ok and is_zero_form(fsub(lhs, rhs))
        check(ok, 'p. 406, d(f_i/W) = df_i/W - f_i sum f_j df_j / W^3, '
                  'n = %d' % n)
        Hs = matrix(SR, n - 1, n - 1, lambda i, j: var('H_%d_%d' % (
            min(i, j), max(i, j))))
        prod_ = {(): SR(1)}
        for i in range(n - 1):
            prod_ = wedge(prod_, {(j,): Hs[i, j] for j in range(n - 1)})
        check(sr_zero(prod_[top] - Hs.det()),
              'p. 406, the wedge of the rows is det(f_ij), n = %d' % n)
    # n = 3: the Gaussian curvature, and P_0 for a concrete graph.
    h1, h2 = var('h1 h2')
    f = function('f')(h1, h2)
    Kc, g = gaussian_curvature_times_area(vector(SR, [h1, h2, f]), h1, h2)
    W2 = 1 + f.derivative(h1) ** 2 + f.derivative(h2) ** 2
    Hdet = (f.derivative(h1, 2) * f.derivative(h2, 2)
            - f.derivative(h1).derivative(h2) ** 2)
    check(sr_zero(g - W2) and sr_zero(Kc - Hdet / W2 ** 2),
          'Theorem 3, n = 3: det(f_ij)/W^4 is the Gaussian curvature')
    a, b, c = QQ(2), QQ(-1), QQ(5)
    Rg = PolynomialRing(QQ, 'h1,h2')
    H1, H2 = Rg.gens()
    fp = a * H1 ** 2 + b * H1 * H2 + c * H2 ** 2 + H1 ** 3 - 7 * H1 * H2 ** 2
    grad0 = [fp.derivative(v_).subs({H1: 0, H2: 0}) for v_ in (H1, H2)]
    nu0 = [g_ for g_ in grad0] + [-1]          # W = 1 at P_0
    check(nu0 == [0, 0, -1], 'p. 405, the printed normal at P_0 is '
                             '(0, 0, -1)')
    refuted(nu0 == [0, 0, 1], 'p. 405, f(P_0) = (0, ..., 0, 1)')
    hess0 = matrix(QQ, 2, 2, lambda i, j: fp.derivative((H1, H2)[i])
                   .derivative((H1, H2)[j]).subs({H1: 0, H2: 0}))
    check(hess0.det() == 4 * a * c - b ** 2,
          'p. 405, K(P_0) = det(f_ij) for the concrete graph')

    # Theorem 4 and the Remark: the sphere, the torus, genus 2.
    Rr, R0, r0 = var('Rr R0 r0')
    assume(Rr > 0)
    assume(R0 > r0)
    assume(r0 > 0)
    th, ph = var('th ph')
    sph = vector(SR, [Rr * cos(th) * cos(ph), Rr * cos(th) * sin(ph),
                      Rr * sin(th)])
    Kc, g = gaussian_curvature_times_area(sph, th, ph)
    sq = Rr ** 2 * cos(th)            # sqrt(g) for -pi/2 <= th <= pi/2
    check(sr_zero(Kc - 1 / Rr ** 2) and sr_zero(sq ** 2 - g),
          'the sphere: K = 1/R^2')
    tot = integral(integral((Kc * sq).simplify_full(), th, -pi / 2, pi / 2),
                   ph, 0, 2 * pi)
    check(sr_zero(tot - 4 * pi), 'the sphere: int K d sigma = 4 pi')
    genus = 0
    check(sr_zero(tot - 4 * pi * (1 - genus)),
          'Remark: lambda = 1 - g for the sphere')
    refuted(sr_zero(tot - 4 * pi * (genus - 1)),
            'Remark: lambda = g - 1 for the sphere')
    tor = vector(SR, [(R0 + r0 * cos(th)) * cos(ph),
                      (R0 + r0 * cos(th)) * sin(ph), r0 * sin(th)])
    Kc, g = gaussian_curvature_times_area(tor, th, ph)
    sq = r0 * (R0 + r0 * cos(th))
    check(sr_zero(sq ** 2 - g)
          and sr_zero(Kc - cos(th) / (r0 * (R0 + r0 * cos(th)))),
          'the torus: K = cos th / (r (R + r cos th))')
    tot = integral(integral((Kc * sq).simplify_full(), th, 0, 2 * pi),
                   ph, 0, 2 * pi)
    check(sr_zero(tot), 'the torus: int K d sigma = 0 = 4 pi (1 - 1)')
    # Degrees of the outward Gauss maps at the regular value e_1: the
    # preimages and the signs of K there (sign det d nu = sign K, Theorem 3).
    e1 = vector(SR, [1, 0, 0])
    check(all(sr_zero(c) for c in sph.subs({th: 0, ph: 0}) / Rr - e1),
          'the sphere: nu = x/R takes e_1 once (K > 0): degree 1 = 1 - 0')
    nut = vector(SR, [cos(th) * cos(ph), cos(th) * sin(ph), sin(th)])
    check(all(sr_zero(c) for c in nut.subs({th: 0, ph: 0}) - e1)
          and all(sr_zero(c) for c in nut.subs({th: pi, ph: pi}) - e1),
          'the torus: nu = e_1 at (th, ph) = (0, 0) and (pi, pi)')
    Kt = cos(th) / (r0 * (R0 + r0 * cos(th)))
    check(bool(Kt.subs({th: 0}) > 0) and bool(Kt.subs({th: pi}) < 0),
          'the torus: K > 0 at (0, 0), K < 0 at (pi, pi): degree 0 = 1 - 1')

    # Genus 2: M = {z^2 + p^2 = delta^2}, p = y^2 + x^4 - x^2, delta = 1/8.
    R3 = PolynomialRing(QQ, 'x,y,z', order='lex')
    x, y, z = R3.gens()
    delta = QQ(1) / 8
    p = y ** 2 + x ** 4 - x ** 2
    F = z ** 2 + p ** 2 - delta ** 2
    Fx, Fy, Fz = [F.derivative(v_) for v_ in (x, y, z)]
    check(R3.ideal([F, Fx, Fy, Fz]) == R3.ideal([R3(1)]),
          'genus 2: grad F != 0 on F = 0 (smooth surface)')
    R2 = PolynomialRing(QQ, 'x,y')
    X2, Y2 = R2.gens()
    p2 = Y2 ** 2 + X2 ** 4 - X2 ** 2
    crit = R2.ideal([p2.derivative(X2), p2.derivative(Y2)])
    check(crit == R2.ideal([Y2, X2 * (2 * X2 ** 2 - 1)]),
          'genus 2: critical points of p are (0, 0), (+-1/sqrt 2, 0)')
    check(p2(0, 0) == 0
          and p2(1 / AA(2).sqrt(), AA(0)) == QQ(-1) / 4
          and p2(-1 / AA(2).sqrt(), AA(0)) == QQ(-1) / 4
          and 0 < delta < QQ(1) / 4,
          'genus 2: critical values 0 (saddle) and -1/4 (minima); '
          '0 < delta < 1/4, so |p| <= delta is a disc with two holes')
    check(R3.ideal([F, Fy, Fz]) == R3.ideal(
        [z, y, (x ** 4 - x ** 2) ** 2 - delta ** 2]),
        'genus 2: nu = +-e_x exactly at (x, 0, 0), (x^4 - x^2)^2 = delta^2')
    Rx = PolynomialRing(QQ, 'X')
    Xv = Rx.gen()
    pts = ((Xv ** 4 - Xv ** 2 - delta).roots(AA, multiplicities=False)
           + (Xv ** 4 - Xv ** 2 + delta).roots(AA, multiplicities=False))
    check(len(set(pts)) == 6, 'genus 2: six critical points of the height x')
    Fyy = F.derivative(y).derivative(y)
    Fzz = F.derivative(z).derivative(z)
    Fyz = F.derivative(y).derivative(z)
    signs = []
    for x0 in pts:
        def ev(G):
            return AA(G(x0, AA(0), AA(0)))
        fx = ev(Fx)
        # At a point where grad F = (F_x, 0, 0) the surface is a graph
        # x = h(y, z) with h_y = h_z = 0, h_.. = -F_../F_x, so (p. 405)
        # K = det(h_..) = (F_yy F_zz - F_yz^2) / F_x^2.
        K0 = (ev(Fyy) * ev(Fzz) - ev(Fyz) ** 2) / fx ** 2
        check(fx != 0 and K0 != 0, 'genus 2: e_x regular, K != 0')
        signs.append((fx.sign(), K0.sign()))
    chi = sum(sk for _, sk in signs)
    check(chi == -2, 'genus 2: chi = -2 (index parity from the sign of K)')
    genus = (2 - chi) // 2
    deg_plus = sum(sk for sx, sk in signs if sx > 0)
    deg_minus = sum(sk for sx, sk in signs if sx < 0)
    check(genus == 2 and deg_plus == deg_minus == -1,
          'genus 2: the outward Gauss map has degree -1 at e_x and -e_x')
    check(deg_plus == 1 - genus, 'Remark: lambda = 1 - g for genus 2')
    refuted(deg_plus == genus - 1, 'Remark: lambda = g - 1 for genus 2')


section_1()
section_2()
section_3()
print("ok chapter-6: %d checks" % COUNT[0])
