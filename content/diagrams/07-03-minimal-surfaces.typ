// Figures of chapter 7, § 3. Each is a function called by the text:
// `#fig(fig-7-15()) <fig:…>`.
#import "common.typ": *

// The plane w = 0 of a perspective view `at` as a slab: its top from x =
// `left` to `right` and from the front edge to `depth` back, stippled, its
// front face `thickness` deep, black.
#let stippled-slab(at, left, right, depth, thickness, edge: thick-line) = {
  import cetz.draw: *
  let top = (
    at((left, 0, 0)),
    at((right, 0, 0)),
    at((right, depth, 0)),
    at((left, depth, 0)),
  )
  line(
    at((left, 0, 0)),
    at((right, 0, 0)),
    at((right, 0, -thickness)),
    at((left, 0, -thickness)),
    close: true,
    fill: black,
    stroke: edge,
  )
  line(..top, close: true, fill: stipple, stroke: edge)
}

// The region of the page covered by the points `points` of a surface, the
// upper and the lower edge from left to right: in each of `bins` columns
// the highest and the lowest point.
#let covered-region(points, bins: 200) = {
  let xs = points.map(p => p.at(0))
  let (low, high) = (calc.min(..xs), calc.max(..xs))
  let column(x) = calc.min(int((x - low) / (high - low) * bins), bins - 1)
  let upper = range(bins).map(_ => none)
  let lower = range(bins).map(_ => none)
  for p in points {
    let i = column(p.at(0))
    if upper.at(i) == none or p.at(1) > upper.at(i).at(1) { upper.at(i) = p }
    if lower.at(i) == none or p.at(1) < lower.at(i).at(1) { lower.at(i) = p }
  }
  (upper.filter(p => p != none), lower.filter(p => p != none))
}

// The height on the upper edge `upper` (points from left to right) above
// x.
#let edge-height(upper, x) = {
  let i = upper.position(p => p.at(0) >= x)
  if i == none { upper.last().at(1) } else if i == 0 {
    upper.first().at(1)
  } else {
    let (p, q) = (upper.at(i - 1), upper.at(i))
    p.at(1) + (q.at(1) - p.at(1)) * (x - p.at(0)) / (q.at(0) - p.at(0))
  }
}

// The graph w = f(x, v) of a function over the ellipse of `centre` and
// `semi-axes` in the plane of the perspective view `at`, as seen on the
// page: the boundary of the domain (`rim`, points of the plane), the
// upper and lower edges of the graph and the near and far halves of its
// boundary, from left to right.
#let graph-edges(at, f, centre, semi-axes, rings: 50, turns: 240) = {
  let (a, b) = semi-axes
  let in-domain(rho, phi) = (
    centre.at(0) + a * rho * calc.cos(phi),
    centre.at(1) + b * rho * calc.sin(phi),
  )
  let lift((x, v)) = at((x, v, f(x, v)))
  let rim = range(720).map(k => in-domain(1, k * 0.5deg))
  let inner = range(1, rings)
    .map(i => range(turns).map(k => in-domain(i / rings, k * 360deg / turns)))
    .join()
  let by-x = points => points.sorted(key: p => p.at(0))
  let (upper, lower) = covered-region((rim + inner).map(lift), bins: 150)
  (
    rim: rim,
    upper: upper,
    lower: lower,
    near: by-x(rim.filter(((x, v)) => v <= centre.at(1)).map(lift)),
    far: by-x(rim.filter(((x, v)) => v > centre.at(1)).map(lift)),
  )
}

// The runs of `points` (from left to right) that lie under the edge
// `upper`, hidden by the surface.
#let hidden-runs(points, upper) = runs-where(
  points,
  p => edge-height(upper, p.at(0)) > p.at(1) + 0.3,
)

// The style of a hidden boundary of a graph.
#let hidden-edge = (stroke: (..hidden.stroke, thickness: 0.9pt))

// The graph w = f(x, v) over the ellipse D of `centre` and `semi-axes` in
// the plane of the perspective view `at`: the black domain D, the dashed
// verticals over its ends, the stippled graph with its outline, the hidden
// part of its boundary dashed.
#let graph-over-domain(at, f, centre, semi-axes) = {
  import cetz.draw: *
  let edges = graph-edges(at, f, centre, semi-axes)
  let base((x, v)) = at((x, v, 0))
  line(..edges.rim.map(base), close: true, fill: black)
  let by-page-x = edges.rim.sorted(key: p => base(p).at(0))
  for (x, v) in (by-page-x.first(), by-page-x.last()) {
    line(at((x, v, 0)), at((x, v, f(x, v))), ..hidden)
  }
  let outline = (..edges.upper, ..edges.near.rev())
  line(..outline, close: true, fill: white, stroke: none)
  line(..outline, close: true, fill: stipple, stroke: none)
  line(..edges.upper, stroke: 0.9pt)
  line(..edges.near, stroke: 0.9pt)
  for run in hidden-runs(edges.far, edges.upper) { line(..run, ..hidden-edge) }
}

// Figure 15: the graph V^(n−1) of x^n = f(x¹, …, x^(n−1)) over a domain D
// of ℝ^(n−1), drawn for n = 3: D an ellipse, f a tilted plane plus a dome
// with a ridge across it, both vanishing on the boundary of D.
#let fig-7-15() = lettered-drawing({
  import cetz.draw: *
  let at = plane-perspective((37.8, 73), 2.4, 100)
  let (left, right, depth) = (0.2, 79, 29.2)
  stippled-slab(at, left, right, depth, 1.0)
  let (centre, semi-axes) = ((38.6, 9.3), (20.6, 8.0))
  let f(x, v) = {
    let rho2 = (
      calc.pow((x - centre.at(0)) / semi-axes.at(0), 2)
        + calc.pow((v - centre.at(1)) / semi-axes.at(1), 2)
    )
    (
      22.85
        + 0.371 * (x - centre.at(0))
        + 0.45 * (v - centre.at(1))
        + (1 - rho2) * (8 + 11 * calc.exp(-calc.pow((x - 39) / 9, 2)))
    )
  }
  graph-over-domain(at, f, centre, semi-axes)
  // The axis x^n from the far left corner of the plane.
  let corner = at((left, depth, 0))
  arrowed(corner, (corner.at(0), 46.6), name: "axis")
  content("axis.end", $x^n$, anchor: "north-west", padding: (left: 1.2))
  content((23.5, 40.5), $V^(n-1)$)
  content((61.5, 42.5), $x^n = f lr((x^1, dots, x^(n-1)))$)
  content((68.5, 20.2), $RR^(n-1) lr((x^1, dots, x^(n-1)))$, anchor: "south")
  content((15.4, 10.5), cutout($D$))
})

// Figure 16: a variation f + η of f with η = 0 on the boundary of D. The
// graph of f over the ellipse D is the saddle of the harmonic polynomial
// x² − v² (a minimal surface to first order) with a slight tilt; η is a
// narrow bump (1 − r²)⁴ over a small ellipse in D, hatched; the far rim of
// that ellipse is hidden by the bump.
#let fig-7-16() = lettered-drawing({
  import cetz.draw: *
  let at = plane-perspective((51.1, 81.8), 2.2, 100)
  let (left, right, depth) = (0.3, 91.8, 24.1)
  stippled-slab(at, left, right, depth, 1.0)
  let (centre, semi-axes) = ((47.0, 13.6), (35.2, 8.45))
  let f(x, v) = {
    let (dx, dv) = (x - centre.at(0), v - centre.at(1))
    17.87 + 0.00939 * (dx * dx - dv * dv) + 0.048 * dx + 0.27 * dv
  }
  graph-over-domain(at, f, centre, semi-axes)
  let edges = graph-edges(at, f, centre, semi-axes)
  // The support of η, hatched, and the verticals over its ends: white over
  // D, up to the near edge of the graph.
  let (support-centre, support-axes) = ((46.3, 15.4), (10.8, 4.6))
  let support = range(360).map(k => (
    support-centre.at(0) + support-axes.at(0) * calc.cos(k * 1deg),
    support-centre.at(1) + support-axes.at(1) * calc.sin(k * 1deg),
  ))
  let base((x, v)) = at((x, v, 0))
  line(..support.map(base), close: true, fill: white, stroke: none)
  line(
    ..support.map(base),
    close: true,
    fill: line-hatching(35deg, 0.55mm),
    stroke: none,
  )
  let d-far = edges
    .rim
    .filter(((x, v)) => v > centre.at(1))
    .map(base)
    .sorted(key: p => p.at(0))
  let by-page-x = support.sorted(key: p => base(p).at(0))
  for (x, v) in (by-page-x.first(), by-page-x.last()) {
    let foot = base((x, v))
    let rim-y = edge-height(d-far, foot.at(0))
    let top = edge-height(edges.near, foot.at(0))
    line(foot, (foot.at(0), rim-y), stroke: (..hidden.stroke, paint: white))
    line((foot.at(0), rim-y), (foot.at(0), top), ..hidden)
  }
  // The bump: white, outlined by the upper edge of its raised part (where
  // η is more than a tenth of its height), its right flank shaded, the far
  // rim of its support dashed where it hides it.
  let bump-height(x, v) = {
    let r2 = (
      calc.pow((x - support-centre.at(0)) / support-axes.at(0), 2)
        + calc.pow((v - support-centre.at(1)) / support-axes.at(1), 2)
    )
    if r2 < 1 { 16 * calc.pow(1 - r2, 3) } else { 0 }
  }
  let raised(x, v) = f(x, v) + bump-height(x, v)
  let bump = graph-edges(at, raised, support-centre, support-axes)
  let core = calc.sqrt(1 - calc.pow(0.1, 1 / 3))
  let raised-part = graph-edges(
    at,
    raised,
    support-centre,
    support-axes.map(r => core * r),
  )
  let contour = raised-part.upper
  line(
    ..contour,
    ..raised-part.near.rev(),
    close: true,
    fill: white,
    stroke: none,
  )
  line(..contour, stroke: 0.9pt)
  for run in hidden-runs(bump.far, bump.upper) { line(..run, ..hidden-edge) }
  let peak = contour.sorted(key: p => p.at(1)).last()
  let flank = contour.filter(p => p.at(0) > peak.at(0) + 0.2)
  let low = flank.last().at(1)
  line(
    ..flank,
    ..flank
      .rev()
      .map(((x, y)) => (x - 1.6 * (peak.at(1) - y) / (peak.at(1) - low), y)),
    close: true,
    fill: line-hatching(-55deg, 0.45mm),
    stroke: none,
  )
  // The axis z from the far left corner of the plane.
  let corner = at((left, depth, 0))
  arrowed(corner, (corner.at(0), 45.8), name: "axis")
  content("axis.end", $z$, anchor: "north-east", padding: (right: 1.6))
  content(peak, $f + eta$, anchor: "south-west", padding: (left: 1.6))
  content((78.0, 35.3), cutout($f$))
  content((13.4, 9.6), cutout($D$))
  content((85.6, 4.6), cutout($RR^2$))
})

// Figure 17: the space F(f) of the functions f + η with η|∂D = 0 is the
// linear space C of the perturbations η moved by f: the vectors f and η
// from 0 and their sum f + η, on the line of F(f) parallel to C.
#let fig-7-17() = lettered-drawing({
  import cetz.draw: *
  let origin = (8.5, 4.1)
  let (f, perturbation) = ((9.3, 23.9), (34.5, 11.6))
  let step = cetz.vector.sub(perturbation, origin)
  let along(p, t) = cetz.vector.add(p, cetz.vector.scale(step, t))
  let sum = along(f, 1)
  let dot-radius = 1.1
  line(along(origin, -0.32), along(origin, 1.29), name: "c")
  line(along(f, -0.23), along(f, 1.33))
  line(perturbation, sum, ..fine-dash)
  for end in (f, sum) { arrowed(origin, (end, dot-radius, origin)) }
  line(origin, perturbation)
  mark(
    (origin, 84%, perturbation),
    (origin, 85%, perturbation),
    symbol: "stealth",
  )
  for p in (origin, f, perturbation, sum) { spot(p, radius: dot-radius) }
  let gap = dot-radius + 0.6
  content(origin, $0$, anchor: "north-east", padding: gap)
  content(perturbation, $eta$, anchor: "north", padding: gap)
  content(f, $f$, anchor: "south-west", padding: gap)
  content(sum, $f + eta$, anchor: "south-east", padding: gap)
  content(along(f, -0.23), $F lr((f))$, anchor: "south", padding: 2.2)
  content("c.end", $C$, anchor: "north", padding: 1.3)
})

// Figure 18: a convex functional S on the affine space F(f): its graph is
// a bowl, drawn as the paraboloid S = s₀ + k|p − c|² + τ(x − c_x) over a
// disc of F(f) (fitted to the printed bowl), open at its rim. Over the
// segment from r to g it is convex: S[αr + βg] lies under the chord from
// S[r] to S[g], here α = 0.58, β = 0.42. A haze of stipple, free-hand,
// stands behind the bowl.
#let fig-7-18() = lettered-drawing({
  import cetz.draw: *
  let at = plane-perspective((20.27, 68.74), 4.0, 100)
  let (left, right, depth) = (1.0, 46.5, 25.13)
  // The haze: denser below, with a hanging lower edge.
  for (step, bottom) in (
    (1.1mm, ((0.2, 37), (49, 37))),
    (0.72mm, ((0.2, 30), (6, 31), (49, 31))),
    (
      0.5mm,
      (
        (0.4, 20.0),
        (2.8, 28.0),
        (5.5, 22.5),
        (8.5, 30.0),
        (11.5, 20.5),
        (14.5, 27.0),
        (19.0, 19.5),
        (24.0, 26.5),
        (29.0, 19.5),
        (33.5, 25.0),
        (37.5, 20.5),
        (41.0, 24.0),
        (44.5, 30.0),
        (47.0, 15.5),
        (49.0, 22.0),
      ),
    ),
  ) {
    let top = if step > 1mm { 57.5 } else { 44 }
    merge-path(close: true, fill: dot-stipple(step), stroke: none, {
      catmull(..bottom)
      line(bottom.last(), (49, top), (0.2, top), bottom.first())
    })
  }
  stippled-slab(at, left, right, depth, 3.2)
  // The bowl.
  let (s0, k, tau, centre, radius) = (
    13.93,
    0.056,
    0.321,
    (30.65, 21.02),
    21.45,
  )
  let bowl(x, v) = {
    let (dx, dv) = (x - centre.at(0), v - centre.at(1))
    s0 + k * (dx * dx + dv * dv) + tau * dx
  }
  let edges = graph-edges(at, bowl, centre, (radius, radius))
  let lift((x, v)) = at((x, v, bowl(x, v)))
  let rim = edges.rim.map(lift)
  line(
    ..edges.upper,
    ..edges.lower.rev(),
    close: true,
    fill: white,
    stroke: none,
  )
  // The opening: black, its inner wall hatched by white strokes.
  line(..rim, close: true, fill: black)
  let middle = cetz.vector.lerp(
    ..rim.sorted(key: p => p.at(0)).slice(0, 1),
    rim.sorted(key: p => p.at(0)).last(),
    0.5,
  )
  for p in rim
    .enumerate()
    .filter(((i, _)) => calc.rem(i, 7) == 0)
    .map(((_, p)) => p) {
    line(
      cetz.vector.lerp(middle, p, 0.97),
      cetz.vector.lerp(middle, p, 0.84),
      stroke: (paint: white, thickness: 0.16mm),
    )
  }
  line(..rim, close: true, stroke: 0.9pt)
  line(..edges.lower, stroke: 0.9pt)
  // The points r, g of F(f), αr + βg between them, and the values of S.
  let (r, g) = ((21.74, 19.36), (35.98, 5.2))
  let t = 0.42
  let along(s) = cetz.vector.lerp(r, g, s)
  let base((x, v)) = at((x, v, 0))
  let chord(s) = {
    let (x, v) = along(s)
    at((x, v, (1 - s) * bowl(..r) + s * bowl(..g)))
  }
  line(base(r), base(g))
  for p in (r, along(t), g) { line(base(p), lift(p)) }
  line(lift(along(t)), chord(t))
  line(lift(r), lift(g), ..hidden)
  line(..sample(s => lift(along(s)), 0, 1, n: 60), stroke: 2 * thick-line)
  for p in (
    base(r),
    base(along(t)),
    base(g),
    lift(r),
    lift(along(t)),
    lift(g),
    chord(t),
  ) {
    spot(p, radius: 0.9)
  }
  let gap = 1.6
  content(lift(r), cutout($S [r]$), anchor: "south-east", padding: gap)
  content(lift(g), $S [g]$, anchor: "south", padding: gap)
  content(base(r), $r$, anchor: "east", padding: gap)
  content(
    base(along(t)),
    cutout($alpha r + beta g$),
    anchor: "north-east",
    padding: (top: 1.8, right: -0.6),
  )
  content(base(g), $g$, anchor: "east", padding: gap)
  let corner = at((left, depth, 0))
  arrowed(corner, (corner.at(0), 55.5), name: "axis")
  content("axis.end", $S$, anchor: "north-west", padding: (left: 1.2))
  content(corner, $F lr((f))$, anchor: "south-east", padding: 0.8)
})
