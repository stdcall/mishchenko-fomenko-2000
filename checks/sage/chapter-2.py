"""Exact checks of Chapter 2 "Общая топология" (Sage).

Run: sage -python checks/sage/chapter-2.py (plain asserts; do not use -O).
The last line of the output is "ok chapter-2: N checks".  Last run with
SageMath 10.9.

Book: А. С. Мищенко, А. Т. Фоменко, Курс дифференциальной геометрии и
топологии, 2-е изд., М.: Факториал Пресс, 2000, гл. 2 (pp. 65-94).  Pages
are the printed pages of the book; statements are named by their printed
numbers inside the section ("theorem 3 § 3", "problem 7 § 2").  Expected
values are the book's statements and numbers, written below as literals
read off the printed page; our Typst source is not parsed.  Where the
printed text is wrong, the printed reading is kept as a refuted check
(`refuted`: it must fail) next to the corrected one.  Literature: Р.
Энгелькинг, Общая топология, пер. с англ., М.: Мир, 1986, cited by its
numbered statements.

General topology has few computations.  What is checked, and how:

1. Finite topological spaces, exhaustively.  All topologies on a set of
   n <= 4 points are enumerated (their number is cross-checked against the
   number of preorders, Alexandrov's correspondence); maps between spaces of
   at most 3 points are all enumerated.  The definitions are the book's
   (closure point: every neighbourhood meets the set; continuity by Cauchy,
   § 1, p. 71; connectedness, p. 77; Hausdorff, p. 80; compact = Hausdorff
   with finite subcovers, definition 1 § 3, p. 83 - so a finite space is
   compact exactly when it is Hausdorff, i.e. discrete).
   * § 1: example 2 (two points: four topologies, three spaces up to
     homeomorphism, p. 70); theorems 4, 5 (closed = equal to its closure,
     the closure is closed); theorem 6 (open dense sets); theorem 7
     (Cauchy continuity = open preimages = closed preimages) with the
     corrected f(f^-1(V)) ⊂ V of its proof (p. 72; the printed "= V"
     refuted by a constant map); theorem 8 (a closed cover); problem 8
     (a difference of two closed sets) and problem 9 (dense image).
   * § 2: theorems 1-3 (connectedness); example 4: the bouquet X v Y of
     connected X, Y is connected, X and Y keep their topologies inside it
     and meet in one point, which is theorem 1 (the corrected reference,
     p. 80); the disjoint sum is disconnected; the two-point space with
     open sets ∅, {x}, X is not Hausdorff (p. 80); problem 6 (Hausdorff =
     closed diagonal); problem 7, the kept direction (continuous into a
     Hausdorff space => closed graph) and the need for "Hausdorff" there.
   * § 3: theorem 3 as printed ("в пространство Y") refuted, as corrected
     ("в хаусдорфово пространство Y") confirmed; theorem 2 and the role of
     its hypothesis; problem 1 read as a union of compact subspaces of an
     arbitrary space refuted (the book's own reading - the disjoint sum
     "X ∪ Y" of example 4 § 2, or a Hausdorff ambient space as in п. 4 -
     is true).
2. Exact real algebra (polynomial identities over QQ, numbers in AA).
   * Example 8 § 1 (pp. 75-76): the Cauchy-Schwarz (Lagrange) identity
     behind the triangle inequality of the metric (2) "left to the reader";
     the inequalities (3) with C_1 = 1, C_2 = sqrt 2 (identities for
     a >= b >= 0) and their sharpness; the choice of radii for (4): the
     printed eps' = C_2 eps'', eps = eps'/C_1 refuted by explicit points of
     R x R, the corrected eps' = C_1 eps'', eps = eps'/C_2 confirmed on a
     grid of 1089 points (the general case follows from (3)).
   * Problem 1 § 1: a four-point metric (a centre at distance 1 from three
     points at mutual distance 2) has no isometric embedding into any
     Euclidean space (Gram certificate).
   * Example 3 § 2: the points P, Q of p. 79 lie on y = sin(1/x).
   * Theorem 6 § 2: the constant 1/3 gives the contradiction.
   * Problem 3 § 2: the largest number of regions of the plane cut by n
     lines is 1 + n + n(n - 1)/2 and the smallest is n + 1 (the book prints
     no answer; the values come from adding the lines one by one): attained
     for n <= 6, and every arrangement of n <= 4 distinct lines with
     coefficients in {-1, 0, 1} lies between the bounds.
   * Problem 7 § 2 as printed ("тогда и только тогда") refuted: f(x) = 1/x,
     f(0) = 0 has a closed graph and is discontinuous.
   * Theorem 5 § 3 (p. 87): eps = 1/(s + 1) occurs (the corrected "<="),
     eps = 0 when a term equals x_0 (the logged question).
   * Example 5 § 1 (p. 73) and theorem 1 § 4 (p. 90): equality in the
     triangle inequality for f_n = f (the corrected "<=").
   * Theorem 3 § 4 (pp. 91-92): the bound |phi_0 - f_0| <= 2A/3, the
     constants 2A/9, 4A/9 of the second step and the induction (1)-(2),
     the telescoping sum, the sum of the series = A with the exponent k
     (the printed exponent n refuted), a homeomorphism R -> (-1, 1).
3. Models on intervals of the line (exact rationals).
   * Theorem 7 § 2 (p. 83): the two steps of the shrinking on [0, 3]; the
     printed "V_2 ⊂ closure V_2" alone does not give closure V_2 ⊂ U_2.
   * Theorem 2 § 4 (Urysohn, pp. 90-91): the dyadic construction
     Gamma_(p/2^n) ⋐ Gamma_((2p+1)/2^(n+1)) ⋐ Gamma_((p+1)/2^n) for
     X = [0, 3], F_0 = [0, 1], F_1 = [2, 3] with midpoints, levels n <= 10;
     conditions 1)-3); the extension Gamma_t; the corrected end Gamma_(t')
     of the chain (the printed Gamma_t refuted); dyadic r, r' between any
     t < t' (the corrected "двоично-рациональные"); the function f and
     its dyadic approximations; the neighbourhood U of the continuity
     proof; Gamma_0 by the union formula is empty, and Gamma_t for t > 1
     must be X (the logged questions).
   * Theorem 4 § 4 (pp. 93-94): with the cover [0, 2), (1, 3] of [0, 3]
     the printed conditions psi_alpha = 1 on closure V_alpha, 0 off
     U_alpha admit psi_1 with 2 ∈ supp psi_1, 2 ∉ U_1, so "supp psi_alpha
     ⊂ U_alpha" and a) are refuted; the corrected psi_alpha = 0 off
     W_alpha, closure W_alpha ⊂ U_alpha, gives supp psi_alpha ⊂ U_alpha;
     psi >= 1 > 0 (both the printed "psi >= 1" and the corrected
     "psi > 0" hold); the sum of the phi_alpha is 1.
   * Example 1 § 4: a small neighbourhood of x in [-3, 3] meets (-n, n)
     for all 4 <= n < 100; every such x lies in some (n, n + 2) and has a
     neighbourhood meeting at most three of them.

What these checks do NOT establish.  A check on finite spaces is
exhaustive only for the stated numbers of points; a finite Hausdorff space
is discrete, so compactness, normality and the separation statements are
trivial there and are not tested by it.  The interval models illustrate a
construction on one example; they prove nothing about other spaces.
Polynomial identities hold for all values of their variables; the
inequalities derived from them hold under the stated signs.  The general
theorems of the chapter rest on their proofs.  The counterexample to
problem 5 § 2 as printed (the Niemytzki plane with the discrete topology
mapped identically onto itself; Энгелькинг, пример 1.5.9) and the closed
graph theorem for compact Y (Энгелькинг, упр. 3.1.D) are cited, not
computed.  Nothing here compares our text with the printed book.
"""
from itertools import combinations, permutations, product

from sage.all import (
    AA, QQ, HyperplaneArrangements, PolynomialRing, matrix, pi, sin, vector,
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
# Finite topological spaces.  Points are 0, ..., n - 1; a subset is a bit
# mask; a topology is the frozenset of its open sets.


def full(n):
    return (1 << n) - 1


def is_topology(family, n):
    if 0 not in family or full(n) not in family:
        return False
    return all((a | b) in family and (a & b) in family
               for a in family for b in family)


def topologies(n):
    """All topologies on n points (axioms а), б) of п. 2 § 1, p. 69)."""
    middle = list(range(1, full(n)))
    found = []
    for choice in range(1 << len(middle)):
        family = {0, full(n)} | {middle[i] for i in range(len(middle))
                                 if choice >> i & 1}
        if is_topology(family, n):
            found.append(frozenset(family))
    return found


def number_of_preorders(n):
    """Reflexive transitive relations on n points, by brute force."""
    pairs = [(i, j) for i in range(n) for j in range(n) if i != j]
    count = 0
    for choice in range(1 << len(pairs)):
        rel = {(i, i) for i in range(n)}
        rel |= {pairs[k] for k in range(len(pairs)) if choice >> k & 1}
        if all((a, d) in rel for (a, b) in rel for (c, d) in rel if b == c):
            count += 1
    return count


def points(mask, n):
    return [x for x in range(n) if mask >> x & 1]


def subset_of(a, b):
    return a & ~b == 0


def closure(top, a, n):
    """The points every neighbourhood of which meets a (p. 69)."""
    return sum(1 << x for x in range(n)
               if all(u & a for u in top if u >> x & 1))


def is_closed(top, a, n):
    return (full(n) ^ a) in top


def subspace(top, s):
    """The induced topology on s (p. 71), as masks inside the same points."""
    return frozenset(u & s for u in top)


def is_connected(top, s):
    """No subset of s other than ∅, s is open and closed in s (p. 77)."""
    sub = subspace(top, s)
    return not any(u not in (0, s) and (s ^ u) in sub for u in sub)


def is_hausdorff(top, n, s=None):
    """Distinct points of s (default: all) have disjoint neighbourhoods."""
    s = full(n) if s is None else s
    sub = subspace(top, s)
    return all(any(u >> x & 1 and v >> y & 1 and u & v == 0
                   for u in sub for v in sub)
               for x in points(s, n) for y in points(s, n) if x != y)


def image(f, a):
    return sum({1 << f[x] for x in range(len(f)) if a >> x & 1})


def preimage(f, b):
    return sum(1 << x for x in range(len(f)) if b >> f[x] & 1)


def continuous_cauchy(f, tx, ty):
    """Definition by Cauchy (p. 71) at every point."""
    return all(any(u >> x & 1 and subset_of(image(f, u), v) for u in tx)
               for x in range(len(f)) for v in ty if v >> f[x] & 1)


def continuous(f, tx, ty):
    return all(preimage(f, v) in tx for v in ty)


def maps(nx, ny):
    return product(range(ny), repeat=nx)


SPACES = {n: topologies(n) for n in (1, 2, 3, 4)}


def spaces(limit):
    for n in range(1, limit + 1):
        for top in SPACES[n]:
            yield n, top


def map_triples(limit=3):
    """All (nx, tx, ny, ty, f) with at most `limit` points on each side."""
    for nx, tx in spaces(limit):
        for ny, ty in spaces(limit):
            for f in maps(nx, ny):
                yield nx, tx, ny, ty, f


def rectangles(tx, nx, ty, ny):
    """The open rectangles V x W of X x Y; (x, y) is the bit x*ny + y."""
    rects = []
    for v in tx:
        for w in ty:
            rects.append(sum(1 << (x * ny + y) for x in points(v, nx)
                             for y in points(w, ny)))
    return rects


def open_in_product(s, rects, n):
    """s is a union of rectangles (example 7 § 1, p. 74)."""
    return all(any(r >> p & 1 and subset_of(r, s) for r in rects)
               for p in points(s, n))


def wedge(tx, nx, x0, ty, ny, y0):
    """The bouquet X v Y of example 4 § 2 (p. 80).

    The points of X are 0, ..., nx - 1; the points of Y other than y0
    follow; y0 becomes x0.  U is open when U ∩ X and U ∩ Y are open."""
    place, k = [], nx
    for y in range(ny):
        if y == y0:
            place.append(x0)
        else:
            place.append(k)
            k += 1
    n = k
    xs = full(nx)
    ys = sum(1 << place[y] for y in range(ny))

    def in_y(u):
        return sum(1 << y for y in range(ny) if u >> place[y] & 1)

    opens = frozenset(u for u in range(1 << n)
                      if (u & xs) in tx and in_y(u) in ty)
    return opens, n, xs, ys, in_y


# Enumerator: the number of topologies on n points equals the number of
# preorders on n points (Alexandrov's correspondence) for n <= 4.
check(all(len(SPACES[n]) == number_of_preorders(n) for n in (1, 2, 3, 4)),
      'topologies on n <= 4 points counted as preorders')

# Example 2 § 1 (p. 70).  On two points x = 0, y = 1 the book lists the
# discrete topology, {∅, X} and {∅, {x}, X}, "все различные топологии ...,
# которые задают три различных топологических пространства".  There are
# four topologies; {∅, {y}, X} is the third one with x, y exchanged.
X, Y, BOTH = 1, 2, 3
printed_two_point = [frozenset({0, X, Y, BOTH}), frozenset({0, BOTH}),
                     frozenset({0, X, BOTH})]
check(all(t in SPACES[2] for t in printed_two_point)
      and len(SPACES[2]) == 4, 'example 2 § 1: four topologies on 2 points')


def canonical(top, n):
    return min(tuple(sorted(sum(1 << p[x] for x in points(u, n)) for u in top))
               for p in permutations(range(n)))


check(len({canonical(t, 2) for t in SPACES[2]}) == 3
      and len({canonical(t, 2) for t in printed_two_point}) == 3,
      'example 2 § 1: three spaces up to homeomorphism, the printed ones')
SIERPINSKI = printed_two_point[2]
DISCRETE_2 = printed_two_point[0]

# Theorems 4, 5 § 1 (p. 70): Y is closed iff Y = closure Y; closure Y is
# closed.  Theorem 6 § 1 (p. 71): two open dense sets meet in an open
# dense set.  Problem 8 § 1 (p. 76): Y is a difference of two closed sets
# iff closure(Y) \ Y is closed.  All spaces with at most 4 points.
cases = [0, 0, 0, 0]
th4 = th5 = th6 = pr8 = True
for n, top in spaces(4):
    closed = [a for a in range(1 << n) if is_closed(top, a, n)]
    differences = {f1 & ~f2 for f1 in closed for f2 in closed}
    for a in range(1 << n):
        cl = closure(top, a, n)
        th4 &= is_closed(top, a, n) == (cl == a)
        th5 &= is_closed(top, cl, n)
        pr8 &= (a in differences) == is_closed(top, cl & ~a, n)
        cases[0] += 1
    dense_open = [u for u in top if closure(top, u, n) == full(n)]
    for u in dense_open:
        for v in dense_open:
            th6 &= (u & v) in top and closure(top, u & v, n) == full(n)
            cases[1] += 1
check(th4, 'theorem 4 § 1 on spaces with <= 4 points')
check(th5, 'theorem 5 § 1 on spaces with <= 4 points')
check(th6, 'theorem 6 § 1 on spaces with <= 4 points')
check(pr8, 'problem 8 § 1 on spaces with <= 4 points')
check(cases[0] == sum(len(SPACES[n]) * 2**n for n in (1, 2, 3, 4)),
      'all subsets of all spaces with <= 4 points were visited')

# Theorem 7 § 1 (pp. 71-72): Cauchy continuity = open preimages = closed
# preimages; in its proof f(f^-1(V)) ⊂ V (corrected), not "= V" (printed).
# Theorem 8 § 1 (p. 72): for a cover X = F_1 ∪ F_2 by closed sets, f is
# continuous iff f|F_1, f|F_2 are.  Problem 9 § 1: a continuous image of a
# dense set is dense in the image.  Theorem 3 § 2 (p. 78): a continuous
# image of a connected space is connected.  All maps between spaces with
# at most 3 points.
th7 = th7_inclusion = th8 = pr9 = th3_2 = True
printed_equality_fails = False
n_maps = 0
for nx, tx, ny, ty, f in map_triples(3):
    n_maps += 1
    cont = continuous(f, tx, ty)
    closed_pre = all(is_closed(tx, preimage(f, full(ny) ^ v), nx)
                     for v in ty)
    th7 &= continuous_cauchy(f, tx, ty) == cont == closed_pre
    for v in ty:
        back = image(f, preimage(f, v))
        th7_inclusion &= subset_of(back, v)
        printed_equality_fails |= back != v
    closed = [a for a in range(1 << nx) if is_closed(tx, a, nx)]
    for f1, f2 in product(closed, repeat=2):
        if f1 | f2 != full(nx):
            continue
        restricted = all((preimage(f, v) & fi) in subspace(tx, fi)
                         for fi in (f1, f2) for v in ty)
        th8 &= cont == restricted
    if not cont:
        continue
    fx = image(f, full(nx))
    sub = subspace(ty, fx)
    for dense in range(1 << nx):
        if closure(tx, dense, nx) == full(nx):
            fd = image(f, dense)
            # every point of f(X) is a closure point of f(D) in f(X)
            pr9 &= all(all(u & fd for u in sub if u >> y & 1)
                       for y in points(fx, ny))
    if is_connected(tx, full(nx)):
        th3_2 &= is_connected(ty, fx)
check(n_maps == sum(len(SPACES[i]) * len(SPACES[j]) * j**i
                    for i in (1, 2, 3) for j in (1, 2, 3)),
      'all maps between spaces with <= 3 points were visited')
check(th7, 'theorem 7 § 1: the three forms of continuity agree')
check(th7_inclusion, 'theorem 7 § 1, proof: f(f^-1(V)) ⊂ V (corrected)')
refuted(not printed_equality_fails,
        'theorem 7 § 1, proof: f(f^-1(V)) = V (printed)')
# The simplest case: a constant map of a point into two points, V = Y.
const = (0,)
refuted(image(const, preimage(const, 3)) == 3,
        'f(f^-1(V)) = V for the constant map of a point, V = Y')
check(th8, 'theorem 8 § 1 for all closed covers of spaces with <= 3 points')
check(pr9, 'problem 9 § 1: dense sets have dense images in the image')
check(th3_2, 'theorem 3 § 2: continuous images of connected spaces')

# Theorems 1, 2 § 2 (p. 78).  Theorem 1: a union of connected subsets with
# a common point is connected (all families, spaces with <= 3 points).
# Theorem 2: if any two points lie in a connected subset, the space is
# connected (spaces with <= 4 points).
th1_2 = th2_2 = True
for n, top in spaces(3):
    conn = [s for s in range(1, 1 << n) if is_connected(top, s)]
    for size in range(1, len(conn) + 1):
        for family in combinations(conn, size):
            common = full(n)
            union = 0
            for s in family:
                common &= s
                union |= s
            if common:
                th1_2 &= is_connected(top, union)
for n, top in spaces(4):
    conn = [s for s in range(1, 1 << n) if is_connected(top, s)]
    joined = all(any(s >> x & 1 and s >> y & 1 for s in conn)
                 for x in range(n) for y in range(n))
    if joined:
        th2_2 &= is_connected(top, full(n))
check(th1_2, 'theorem 1 § 2 on spaces with <= 3 points')
check(th2_2, 'theorem 2 § 2 on spaces with <= 4 points')

# Example 4 § 2 (p. 80).  The bouquet X v Y of connected X, Y is connected
# "в силу теоремы 1" (corrected; printed: "теоремы 2"): X and Y are
# subspaces of X v Y with their own topologies, connected, and meet in the
# single point x_0 = y_0, which is exactly theorem 1.  Theorem 2 would need
# a connected set containing a point of X and a point of Y other than x_0;
# neither X nor Y is such a set.  The disjoint sum Z = X ∪ Y is
# disconnected.  All connected X, Y with <= 3 points and all base points.
bouquet_ok = sum_disconnected = theorem2_needs_more = True
n_bouquets = 0
for nx, tx in spaces(3):
    for ny, ty in spaces(3):
        sum_top = frozenset(u | (v << nx) for u in tx for v in ty)
        sum_disconnected &= not is_connected(sum_top, full(nx + ny))
        if not (is_connected(tx, full(nx)) and is_connected(ty, full(ny))):
            continue
        for x0 in range(nx):
            for y0 in range(ny):
                opens, n, xs, ys, in_y = wedge(tx, nx, x0, ty, ny, y0)
                n_bouquets += 1
                bouquet_ok &= (
                    is_topology(opens, n)
                    and subspace(opens, xs) == tx
                    and {in_y(u) for u in subspace(opens, ys)} == set(ty)
                    and xs & ys == 1 << x0
                    and is_connected(opens, xs) and is_connected(opens, ys)
                    and is_connected(opens, full(n)))
                if nx > 1 and ny > 1:
                    theorem2_needs_more &= not any(
                        s & ~(1 << x0) & xs and s & ~(1 << x0) & ys
                        for s in (xs, ys))
check(n_bouquets > 0 and bouquet_ok,
      'example 4 § 2: X v Y connected by theorem 1 (<= 3 + 3 points)')
check(theorem2_needs_more,
      'example 4 § 2: X, Y alone do not join a point of X to one of Y')
check(sum_disconnected, 'example 4 § 2: the disjoint sum is disconnected')

# P. 80: the two-point space with open sets ∅, X, {x} is not Hausdorff.
check(not is_hausdorff(SIERPINSKI, 2) and is_hausdorff(DISCRETE_2, 2),
      'p. 80: the space ∅, {x}, X is not Hausdorff; the discrete one is')

# Problem 6 § 2 (p. 83): X is Hausdorff iff the diagonal is closed in
# X x X (product topology of example 7 § 1), spaces with <= 4 points.
# Problem 7 § 2, the kept direction: the graph of a continuous map into a
# Hausdorff space is closed (maps between spaces with <= 3 points); without
# "Hausdorff" it fails (the identity of the space ∅, {x}, X).
pr6 = pr7 = True
for n, top in spaces(4):
    rects = rectangles(top, n, top, n)
    diagonal = sum(1 << (x * n + x) for x in range(n))
    pr6 &= is_hausdorff(top, n) == open_in_product(
        full(n * n) ^ diagonal, rects, n * n)
check(pr6, 'problem 6 § 2 on spaces with <= 4 points')
for nx, tx, ny, ty, f in map_triples(3):
    if is_hausdorff(ty, ny) and continuous(f, tx, ty):
        graph = sum(1 << (x * ny + f[x]) for x in range(nx))
        pr7 &= open_in_product(full(nx * ny) ^ graph,
                               rectangles(tx, nx, ty, ny), nx * ny)
check(pr7, 'problem 7 § 2: continuous into Hausdorff => closed graph')
sierpinski_diagonal = 1 | (1 << 3)
refuted(open_in_product(full(4) ^ sierpinski_diagonal,
                        rectangles(SIERPINSKI, 2, SIERPINSKI, 2), 4),
        'graph of the identity of ∅, {x}, X closed (Hausdorff dropped)')

# Theorem 3 § 3 (p. 85).  Printed: "непрерывное отображение компактного
# пространства X в пространство Y.  Тогда образ f(X) является компактным
# пространством."  Corrected: "в хаусдорфово пространство Y".  Compact
# (definition 1 § 3) includes Hausdorff; for finite spaces compact means
# Hausdorff.  The printed reading fails, e.g., for the identity of the
# discrete two-point space onto the space ∅, {x}, X.
printed_th3 = corrected_th3 = True
for nx, tx, ny, ty, f in map_triples(3):
    if is_hausdorff(tx, nx) and continuous(f, tx, ty):
        image_compact = is_hausdorff(ty, ny, image(f, full(nx)))
        printed_th3 &= image_compact
        if is_hausdorff(ty, ny):
            corrected_th3 &= image_compact
refuted(printed_th3, 'theorem 3 § 3 without "хаусдорфово" (printed)')
check(corrected_th3, 'theorem 3 § 3 with Y Hausdorff (corrected)')
identity = (0, 1)
check(is_hausdorff(DISCRETE_2, 2) and continuous(identity, DISCRETE_2,
                                                  SIERPINSKI),
      'theorem 3 § 3: the identity of the compact discrete two-point space '
      'onto ∅, {x}, X is continuous')
refuted(is_hausdorff(SIERPINSKI, 2, image(identity, BOTH)),
        'theorem 3 § 3 (printed): its image ∅, {x}, X is compact')

# Theorem 2 § 3 (p. 85) needs the Hausdorff ambient space: in ∅, {x}, X the
# one-point subspace {x} is compact and not closed.  With X Hausdorff it
# holds (spaces with <= 4 points, trivially: they are discrete).
check(is_hausdorff(SIERPINSKI, 2, X) and not is_closed(SIERPINSKI, X, 2),
      'theorem 2 § 3: {x} compact, not closed in ∅, {x}, X')
check(all(is_closed(top, s, n) for n, top in spaces(4)
          if is_hausdorff(top, n) for s in range(1 << n)
          if is_hausdorff(top, n, s)),
      'theorem 2 § 3 on Hausdorff spaces with <= 4 points')

# Problem 1 § 3 (p. 89), "объединение конечного числа компактных
# пространств компактно": for compact subspaces A, B of an arbitrary space
# it fails - {x} and {y} in ∅, {x}, X are compact, their union is not.
# For the disjoint sum (the book's "X ∪ Y" of example 4 § 2), or inside a
# Hausdorff space (п. 4, p. 88), it holds.
refuted(is_hausdorff(SIERPINSKI, 2, X | Y),
        'problem 1 § 3 read for subspaces of a non-Hausdorff space')
check(all(is_hausdorff(frozenset(u | (v << nx) for u in tx for v in ty),
                       nx + ny)
          for nx, tx in spaces(3) for ny, ty in spaces(3)
          if is_hausdorff(tx, nx) and is_hausdorff(ty, ny)),
      'problem 1 § 3 for disjoint sums of compact spaces (<= 3 + 3)')

# ---------------------------------------------------------------------------
# Example 8 § 1 (pp. 75-76): the metrics (1) rho = max{rho_1, rho_2} and
# (2) rho' = sqrt(rho_1^2 + rho_2^2) on X x Y.

R = PolynomialRing(QQ, 'a, b, c, d')
a, b, c, d = R.gens()
# Triangle inequality for (2) ("Проверку свойств а), б), в) мы
# предоставляем читателю"): with a = rho_1(x_1, x_3), b = rho_1(x_3, x_2),
# c = rho_2(y_1, y_3), d = rho_2(y_3, y_2) (all >= 0), rho' is increasing
# in rho_1, rho_2, so it suffices that (a + b)^2 + (c + d)^2 <=
# (sqrt(a^2 + c^2) + sqrt(b^2 + d^2))^2, i.e. ab + cd <=
# sqrt((a^2 + c^2)(b^2 + d^2)), which is Lagrange's identity:
check((a**2 + c**2) * (b**2 + d**2) - (a * b + c * d)**2 == (a * d - b * c)**2,
      'example 8 § 1: Lagrange identity (Cauchy-Schwarz)')
check((a**2 + c**2) + (b**2 + d**2) - ((a + b)**2 + (c + d)**2)
      == -2 * (a * b + c * d),
      'example 8 § 1: the expansion behind the triangle inequality of (2)')
# (3) with C_1 = 1, C_2 = sqrt 2 (p. 76): for a = max >= b >= 0 (the case
# b >= a is symmetric), rho'^2 - rho^2 = b^2 >= 0 and 2 rho^2 - rho'^2 =
# (a - b)(a + b) >= 0.
check((a**2 + b**2) - a**2 == b**2, '(3): rho <= rho\'')
check(2 * a**2 - (a**2 + b**2) == (a - b) * (a + b), '(3): rho\' <= sqrt2 rho')
SQRT2 = AA(2).sqrt()
C1, C2 = AA(1), SQRT2


def rho(p):
    return max(abs(p[0]), abs(p[1]))


def rho_prime(p):
    return AA(p[0]**2 + p[1]**2).sqrt()


check(rho_prime((1, 1)) == C2 * rho((1, 1))
      and rho_prime((1, 0)) == C1 * rho((1, 0)),
      '(3): the constants C_1 = 1, C_2 = sqrt 2 are attained')
# (4): O_eps ⊂ O'_eps' ⊂ O_eps'' around (0, 0) in R x R, |.| on each factor.


def inclusions_hold(eps, eps1, eps2, pts):
    first = all(rho_prime(p) < eps1 for p in pts if rho(p) < eps)
    second = all(rho(p) < eps2 for p in pts if rho_prime(p) < eps1)
    return first, second


eps2 = AA(1)
# Printed: "выполняется при eps' = C_2 eps'', eps = eps'/C_1".
p_eps1 = C2 * eps2
p_eps = p_eps1 / C1
first, second = inclusions_hold(p_eps, p_eps1, eps2, [(1, 1), (1, 0)])
refuted(first, '(4) printed: O_eps ⊂ O\'_eps\' at (1, 1)')
refuted(second, '(4) printed: O\'_eps\' ⊂ O_eps\'\' at (1, 0)')
# Corrected: eps' = C_1 eps'', eps = eps'/C_2.
c_eps1 = C1 * eps2
c_eps = c_eps1 / C2
grid = [(QQ(i) / 8, QQ(j) / 8) for i in range(-16, 17) for j in range(-16, 17)]
first, second = inclusions_hold(c_eps, c_eps1, eps2, grid)
check(first and second and len(grid) == 1089,
      '(4) corrected: both inclusions on the grid of 1089 points')

# Problem 1 § 1 (p. 76): a metric on four points not induced by any
# embedding into a Euclidean space.  Centre 0 at distance 1 from 1, 2, 3,
# which are at mutual distance 2.
dist = matrix(QQ, [[0, 1, 1, 1], [1, 0, 2, 2], [1, 2, 0, 2], [1, 2, 2, 0]])
check(all(dist[i, j] == dist[j, i] and (dist[i, j] == 0) == (i == j)
          and dist[i, j] <= dist[i, k] + dist[k, j]
          for i in range(4) for j in range(4) for k in range(4)),
      'problem 1 § 1: the four-point metric satisfies а), б), в)')
# For images p_0, ..., p_3 in R^m the Gram matrix of p_i - p_0 has entries
# (d_0i^2 + d_0j^2 - d_ij^2)/2 (polarization) and is positive semidefinite;
# here v G v^T < 0 for v = (1, 1, 1).
S = PolynomialRing(QQ, 'u1, u2, u3, w1, w2, w3')
u = vector(S, S.gens()[:3])
w = vector(S, S.gens()[3:])
check(u * w == (u * u + w * w - (u - w) * (u - w)) / 2,
      'problem 1 § 1: polarization identity')
gram = matrix(QQ, 3, 3, lambda i, j: (dist[0, i + 1]**2 + dist[0, j + 1]**2
                                      - dist[i + 1, j + 1]**2) / 2)
check(vector(QQ, [1, 1, 1]) * gram * vector(QQ, [1, 1, 1]) == -3,
      'problem 1 § 1: the Gram form is negative at (1, 1, 1)')

# ---------------------------------------------------------------------------
# § 2.

# Example 3 § 2 (p. 79): P = (-1/pi, 0) and Q = (1/pi, 0) lie on the graph.
check(bool(sin(1 / (-1 / pi)) == 0) and bool(sin(1 / (1 / pi)) == 0),
      'example 3 § 2: P, Q lie on y = sin(1/x)')

# Theorem 6 § 2 (p. 82): rho(x, z) < rho(x, y)/3 and rho(y, z) <
# rho(x, y)/3 give rho(x, z) + rho(z, y) < (2/3) rho(x, y) < rho(x, y), a
# contradiction with the triangle inequality since rho(x, y) > 0.
check(QQ(1) / 3 + QQ(1) / 3 == QQ(2) / 3 and QQ(2) / 3 < 1,
      'theorem 6 § 2: the constants 1/3 + 1/3 = 2/3 < 1')

# Problem 3 § 2 (p. 83): n lines cut the plane into at most
# 1 + n + n(n - 1)/2 and at least n + 1 regions.
H = HyperplaneArrangements(QQ, ('x', 'y'))
check(all(H([[k**2, k, -1] for k in range(n)]).n_regions()
          == 1 + n + n * (n - 1) / 2 for n in range(1, 7)),
      'problem 3 § 2: tangents y = kx + k^2 to a parabola, n <= 6')
check(all(H([[k, 0, 1] for k in range(n)]).n_regions() == n + 1
          for n in range(1, 7)), 'problem 3 § 2: n parallel lines, n <= 6')
small_lines = []
for coeffs in product((-1, 0, 1), repeat=3):
    if coeffs[:2] != (0, 0) and tuple(-e for e in coeffs) not in small_lines:
        small_lines.append(coeffs)
between = True
for n in range(1, 5):
    for family in combinations(small_lines, n):
        regions = H([[cc, aa, bb] for (aa, bb, cc) in family]).n_regions()
        between &= n + 1 <= regions <= 1 + n + n * (n - 1) / 2
check(len(small_lines) == 12 and between,
      'problem 3 § 2: all arrangements of <= 4 of the 12 small lines')

# Problem 7 § 2 (p. 83).  Printed: f: X -> Y into a Hausdorff Y is
# continuous "тогда и только тогда, когда" its graph is closed.  The "if"
# fails: f(x) = 1/x (x != 0), f(0) = 0 on R.  Its graph is the zero set of
# xy - 1 together with (0, 0), a closed set; f(1/n) = n does not tend to
# f(0) = 0.
T = PolynomialRing(QQ, 'x, y')
x_, y_ = T.gens()
F = T.fraction_field()
check(F(x_) * (1 / F(x_)) - 1 == 0,
      'problem 7 § 2: (x, 1/x) lies on xy = 1')
check((x_ * y_ - 1).subs(x=0) == -1,
      'problem 7 § 2: xy = 1 has no point with x = 0')


def f_inverse(xv):
    return 1 / xv if xv != 0 else QQ(0)


check(all(f_inverse(QQ(1) / n) == n for n in range(1, 1000)),
      'problem 7 § 2: f(1/n) = n')
# Continuity at 0 with eps = 1 would need |f(x)| < 1 for 0 < x < 1/N.
refuted(any(all(abs(f_inverse(QQ(1) / n)) < 1 for n in range(N, 1000))
            for N in range(1, 999)),
        'problem 7 § 2, "if" (printed): f continuous at 0')

# ---------------------------------------------------------------------------
# § 3.

# Theorem 5 § 3 (p. 87).  eps = min{1/(s + 1), rho(x_0, x_1), ...,
# rho(x_0, x_(n_s))}.  Printed "rho(x_0, x_(n_(s+1))) < eps < 1/(s + 1)";
# corrected "eps <= 1/(s + 1)".  On the line, x_0 = 0, s = 1, n_1 = 1,
# x_1 = 1/2 (rho(x_0, x_1) < 1): eps = 1/2 = 1/(s + 1).
s, x0, x1 = 1, QQ(0), QQ(1) / 2
eps = min(QQ(1) / (s + 1), abs(x0 - x1))
check(abs(x0 - x1) < QQ(1) / s and eps <= QQ(1) / (s + 1),
      'theorem 5 § 3: eps <= 1/(s + 1) (corrected)')
refuted(eps < QQ(1) / (s + 1), 'theorem 5 § 3: eps < 1/(s + 1) (printed)')
# The logged question: a term equal to x_0 makes eps = 0.
check(min(QQ(1) / 2, abs(x0 - x0)) == 0,
      'theorem 5 § 3: eps = 0 when some x_m = x_0')

# ---------------------------------------------------------------------------
# § 4 and example 5 § 1.

# Example 5 § 1 (p. 73) and theorem 1 § 4 (p. 90): the first relation is
# the triangle inequality; for f_n = f = id on the line, x_0 = 0, x = 1,
# both sides are equal, so "<" (printed) fails and "<=" (corrected) holds.
fx0, fx, fnx0, fnx = QQ(0), QQ(1), QQ(0), QQ(1)
lhs = abs(fx0 - fx)
rhs = abs(fx0 - fnx0) + abs(fnx0 - fnx) + abs(fnx - fx)
check(lhs <= rhs, 'example 5 § 1, theorem 1 § 4: "<=" (corrected)')
refuted(lhs < rhs, 'example 5 § 1, theorem 1 § 4: "<" (printed)')

# Theorem 7 § 2 (p. 83), a model: X = [0, 3], U_1 = [0, 2), U_2 = (1, 3].
# Step 1 separates X \ U_2 = [0, 1] from X \ U_1 = [2, 3]: V_1 = [0, 3/2).
# Step 2 separates X \ V_1 = [3/2, 3] from X \ U_2 = [0, 1]: V_2 = (5/4, 3].
# An interval [0, e) or (e, 3] is given by e; closures add the endpoint.
v1, v2 = QQ(3) / 2, QQ(5) / 4
check(1 < v1 < 2 and 1 < v2 < v1,
      'theorem 7 § 2: closure V_1 ⊂ U_1, closure V_2 ⊂ U_2, V_1 ∪ V_2 = X')


def closure_in_u2(left_end):
    """closure of (e, 3] (or of X = [0, 3], e = 0) is [e, 3] ⊂ (1, 3]?"""
    return left_end > 1


# Printed "V_2 ⊂ closure V_2" holds for every set, e.g. V_2 = X, whose
# closure is not in U_2: the inclusion "⊂ U_2" is the content of the step.
check(closure_in_u2(v2), 'theorem 7 § 2: V_2 ⊂ closure V_2 ⊂ U_2 (corrected)')
refuted(closure_in_u2(QQ(0)),
        'theorem 7 § 2: V_2 = X meets "V_2 ⊂ closure V_2" and lies in U_2')

# Theorem 2 § 4 (Urysohn, pp. 90-91), a model: X = [0, 3], F_0 = [0, 1],
# F_1 = [2, 3].  Gamma_r = [0, g_r); V ⋐ U ("V ⊂ closure V ⊂ U") for
# [0, g) and [0, h) means g < h, and F ⋐ [0, g) for F = [0, e] means
# e < g.  The book's steps with the midpoint choice: Gamma_0 between F_0
# and X \ F_1 = [0, 2), Gamma_1 between closure Gamma_0 and [0, 2), then
# Gamma_((2p+1)/2^(n+1)) between Gamma_(p/2^n) and Gamma_((p+1)/2^n).
LEVEL = 10
g = {QQ(0): (1 + QQ(2)) / 2}
g[QQ(1)] = (g[QQ(0)] + 2) / 2
step_ok = True
for n in range(LEVEL):
    for p in range(2**n):
        lo, hi = QQ(p) / 2**n, QQ(p + 1) / 2**n
        step_ok &= g[lo] < g[hi]  # Gamma_(p/2^n) ⋐ Gamma_((p+1)/2^n)
        g[QQ(2 * p + 1) / 2**(n + 1)] = (g[lo] + g[hi]) / 2
dyadic = sorted(g)
check(step_ok and len(dyadic) == 2**LEVEL + 1
      and all(g[r] == QQ(3) / 2 + r / 4 for r in dyadic),
      'theorem 2 § 4: the dyadic sets of levels <= 10, g_r = 3/2 + r/4')
check(1 < g[QQ(0)] and g[QQ(1)] < 2
      and all(g[r] < g[rr] for r, rr in zip(dyadic, dyadic[1:])),
      'theorem 2 § 4: conditions 1), 2), 3)')


def gamma(t):
    """Gamma_t = union of Gamma_r over dyadic r < t, as its endpoint g
    (Gamma_t = [0, g); 0 means ∅).  With g_r = 3/2 + r/4 (the midpoint
    rule keeps g linear in r at every level) the union is [0, 3/2 + t/4)
    for 0 < t <= 1 and Gamma_1 for t > 1."""
    if t <= 0:
        return QQ(0)
    if t > 1:
        return g[QQ(1)]
    return QQ(3) / 2 + t / 4


coarse = [QQ(j) / 16 for j in range(17)]
check(all(gamma(t) <= g[r] for t in coarse for r in dyadic if t < r)
      and all(g[r] <= gamma(t) for t in coarse for r in dyadic if r < t),
      'theorem 2 § 4: Gamma_t ⊂ Gamma_r, Gamma_r\' ⊂ Gamma_t\'')
# The chain for t < r < r' < t' ends in Gamma_(t') (corrected); the printed
# end Gamma_t would need Gamma_r' ⊂ Gamma_t with r' > t.
t, r, rr, tt = QQ(1) / 3, QQ(3) / 8, QQ(1) / 2, QQ(2) / 3
check(gamma(t) <= g[r] < g[rr] <= gamma(tt),
      'theorem 2 § 4: closure Gamma_t ⊂ ... ⊂ Gamma_t\' (corrected)')
refuted(g[rr] <= gamma(t), 'theorem 2 § 4: Gamma_r\' ⊂ Gamma_t (printed)')
# Dyadic r, r' with t < r < r' < t' exist for any t < t' (the corrected
# "двоично-рациональные"): with 2^-m < (t' - t)/3, r = (floor(2^m t) +
# 1)/2^m and r' = r + 2^-m.
between_ok = True
for t, tt in combinations(sorted({QQ(i) / j for j in range(1, 8)
                                  for i in range(j + 1)}), 2):
    m = 0
    while QQ(1) / 2**m >= (tt - t) / 3:
        m += 1
    r = QQ((2**m * t).floor() + 1) / 2**m
    between_ok &= t < r < r + QQ(1) / 2**m < tt
check(between_ok, 'theorem 2 § 4: dyadic r, r\' between rationals t < t\'')
# The logged question: by the union formula Gamma_0 is empty, while
# condition 1) needs F_0 ⊂ Gamma_0; and for t > 1 the formula gives
# Gamma_1, which misses x_0 = 2 ∈ F_1 with f(x_0) = 1, so the continuity
# proof needs Gamma_t = X for t > 1.
check(gamma(QQ(0)) == 0 and g[QQ(0)] > 1,
      'theorem 2 § 4: Gamma_0 by the union formula is ∅')
check(gamma(QQ(5) / 4) == g[QQ(1)] < 2,
      'theorem 2 § 4: the union formula for t > 1 gives Gamma_1 ∌ 2')


def f_level(xv, n):
    """sup{t | x ∉ Gamma_t} over t = p/2^n; 0 on Gamma_0."""
    if xv < g[QQ(0)]:
        return QQ(0)
    return max(QQ(p) / 2**n for p in range(2**n + 1)
               if xv >= g[QQ(p) / 2**n])


def f_limit(xv):
    return min(QQ(1), max(QQ(0), 4 * xv - 6))


sample = [QQ(j) / 64 for j in range(193)]
check(all(0 <= f_limit(xv) - f_level(xv, LEVEL) <= QQ(1) / 2**LEVEL
          for xv in sample),
      'theorem 2 § 4: f = sup{t | x ∉ Gamma_t} = min(1, max(0, 4x - 6))')
check(all(f_limit(xv) == 0 for xv in sample if xv <= 1)
      and all(f_limit(xv) == 1 for xv in sample if xv >= 2),
      'theorem 2 § 4: f = 0 on F_0, f = 1 on F_1')


def gamma_ext(t):
    """Gamma_t with Gamma_t = ∅ for t < 0 and X for t > 1; the constructed
    Gamma_r for dyadic r (so Gamma_0 ⊃ F_0)."""
    if t < 0:
        return QQ(0)
    if t > 1:
        return QQ(4)  # [0, 4) ∩ X = X
    return g[t] if t in g else gamma(t)


cont_ok = True
for xv in sample:
    for e in (QQ(1) / 10, QQ(1) / 3, QQ(1)):
        t0 = f_limit(xv)
        right = gamma_ext(t0 + e / 2)   # U = [0, right) minus [0, left]
        left = gamma_ext(t0 - e / 2)
        closure_left = left if t0 - e / 2 >= 0 else -1
        cont_ok &= closure_left < xv < right
        cont_ok &= all(abs(f_limit(yv) - t0) <= e
                       for yv in sample if closure_left < yv < right)
check(cont_ok, 'theorem 2 § 4: the neighbourhood U of the continuity proof')

# Theorem 3 § 4 (Tietze, pp. 91-92), with A = 1 (the statement is
# homogeneous in A).  f_0 = -1/3 where phi_0 <= -1/3, 1/3 where phi_0 >=
# 1/3, and f_0 ∈ [-1/3, 1/3] between; |phi_0 - f_0| is convex, so its
# maximum on each of the three polygons is at a vertex.
third = QQ(1) / 3
polygons = [[(-1, -third), (-third, -third)],
            [(third, third), (1, third)],
            [(-third, -third), (-third, third), (third, -third),
             (third, third)]]
check(max(abs(QQ(ph) - fz) for poly in polygons for ph, fz in poly)
      == QQ(2) / 3, 'theorem 3 § 4: |phi_0 - f_0| <= 2A/3')
check(QQ(2) / 3 * third == QQ(2) / 9 and (QQ(2) / 3)**2 == QQ(4) / 9,
      'theorem 3 § 4: |f_1| <= 2/3 * A/3 = 2A/9, |phi_1 - f_1| <= 4A/9')
# Step n with |phi_n| <= B gives |f_n| <= B/3 and |phi_(n+1)| <= 2B/3:
# with B = (2/3)^n A these are (1) and (2), and the first two steps above
# are n = 0, 1.
ratio = QQ(2) / 3
check(all(ratio**n * third * 3 == ratio**n and ratio**n * ratio
          == ratio**(n + 1) for n in range(20))
      and ratio * third == QQ(2) / 9 and ratio**2 == QQ(4) / 9,
      'theorem 3 § 4: the induction (1), (2) matches the first two steps')
P = PolynomialRing(QQ, ['phi0'] + ['f%d' % k for k in range(7)])
phi = [P.gens()[0]]
for k in range(7):
    phi.append(phi[k] - P.gens()[k + 1])
check(all(phi[0] == sum(P.gens()[1:n + 2]) + phi[n + 1] for n in range(7)),
      'theorem 3 § 4: phi_0 = f_0 + ... + f_n + phi_(n+1), n <= 6')
check(third / (1 - ratio) == 1,
      'theorem 3 § 4: sum (2/3)^k A/3 over k >= 0 equals A')
# Printed: "sum_(k=0)^oo (2/3)^n A/3 = A" (exponent n, not k): for n = 1
# the terms do not depend on k and five of them already exceed A.
refuted(5 * ratio * third <= 1,
        'theorem 3 § 4: the series with exponent n is bounded by A')
# A homeomorphism h: R -> (-1, 1) (the book only uses its existence):
# h(x) = x/(1 + |x|), inverse y/(1 - |y|), on x >= 0 and on x <= 0.
Q1 = PolynomialRing(QQ, 'z').fraction_field()
z = Q1.gen()
h_pos, h_neg = z / (1 + z), z / (1 - z)
check(h_pos(z / (1 - z)) == z and h_neg(z / (1 + z)) == z,
      'theorem 3 § 4: h(x) = x/(1 + |x|) is invertible')

# Theorem 4 § 4 (pp. 93-94), a model: X = [0, 3], U_1 = [0, 2),
# U_2 = (1, 3]; the shrinking V_1 = [0, 9/5), V_2 = (6/5, 3].


def clamp(v):
    return min(QQ(1), max(QQ(0), v))


cut1, cut2 = QQ(9) / 5, QQ(6) / 5
check(cut2 < cut1 and cut1 < 2 and cut2 > 1,
      'theorem 4 § 4: V_1 ∪ V_2 = X, closure V_alpha ⊂ U_alpha')
# Printed: psi_alpha = 1 on closure V_alpha, 0 on X \ U_alpha, "Это
# значит, что supp psi_alpha ⊂ U_alpha".  The function psi_1(x) =
# clamp(5(2 - x)) satisfies the printed conditions, but psi_1(2 - 1/m) =
# 5/m != 0 for m >= 5, so 2 ∈ supp psi_1 and 2 ∉ U_1.


def psi1_printed(xv):
    return clamp(5 * (2 - xv))


check(all(psi1_printed(xv) == 1 for xv in sample if xv <= cut1)
      and all(psi1_printed(xv) == 0 for xv in sample if xv >= 2),
      'theorem 4 § 4: psi_1 = clamp(5(2 - x)) meets the printed conditions')
refuted(all(psi1_printed(2 - QQ(1) / m) == 0 for m in range(5, 1000)),
        'theorem 4 § 4: supp psi_1 ⊂ U_1 = [0, 2) (printed)')
check(all(psi1_printed(2 - QQ(1) / m) == QQ(5) / m for m in range(5, 1000)),
      'theorem 4 § 4: psi_1(2 - 1/m) = 5/m, so 2 ∈ supp psi_1')
# Corrected: psi_alpha = 0 on X \ W_alpha, closure V_alpha ⊂ W_alpha,
# closure W_alpha ⊂ U_alpha: W_1 = [0, 19/10), W_2 = (11/10, 3].


def psi1(xv):
    return clamp(19 - 10 * xv)


def psi2(xv):
    return clamp(10 * xv - 11)


w1, w2 = QQ(19) / 10, QQ(11) / 10
check(cut1 < w1 < 2 and 1 < w2 < cut2,
      'theorem 4 § 4: closure V ⊂ W, closure W ⊂ U')
breaks = [QQ(0), w2, cut2, cut1, w1, QQ(3)]
# The psi_alpha are piecewise linear with breakpoints in `breaks`, so a
# linear inequality holding at the breakpoints holds on [0, 3].
check(all(psi1(xv) == 1 for xv in breaks if xv <= cut1)
      and all(psi1(xv) == 0 for xv in breaks if xv >= w1)
      and all(psi2(xv) == 1 for xv in breaks if xv >= cut2)
      and all(psi2(xv) == 0 for xv in breaks if xv <= w2),
      'theorem 4 § 4: psi_alpha = 1 on closure V_alpha, 0 off W_alpha')
check(all(psi1(xv) + psi2(xv) >= 1 for xv in breaks),
      'theorem 4 § 4: psi >= 1 > 0 on X')
U2 = PolynomialRing(QQ, 'p1, p2').fraction_field()
p1, p2 = U2.gens()
check(p1 / (p1 + p2) + p2 / (p1 + p2) == 1,
      'theorem 4 § 4: sum phi_alpha = sum psi_alpha / psi = 1')

# Example 1 § 4 (p. 93): every neighbourhood (x - delta, x + delta) meets
# all (-n, n) with n > |x| + 1, infinitely many; the neighbourhood
# (x - 1/2, x + 1/2) meets (n, n + 2) only for x - 5/2 < n < x + 1/2,
# at most three integers, and every x lies in some (n, n + 2).
quarter = [QQ(k) / 4 for k in range(-12, 13)]
delta = QQ(1) / 100
check(all(xv - delta < n and -n < xv + delta
          for xv in quarter for n in range(4, 100)),
      'example 1 § 4: (x - 1/100, x + 1/100) meets (-n, n), 4 <= n < 100')
check(all(1 <= len([n for n in range(-6, 7) if n < xv < n + 2])
          and len([n for n in range(-6, 7)
                   if n < xv + QQ(1) / 2 and n + 2 > xv - QQ(1) / 2]) <= 3
          for xv in quarter),
      'example 1 § 4: (n, n + 2) is a locally finite cover (x in [-3, 3])')

print('ok chapter-2: %d checks' % COUNT[0])
