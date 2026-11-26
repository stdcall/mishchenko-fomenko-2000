// Figures of chapter 7, § 1. Each is a function called by the text:
// `#fig(fig-7-1()) <fig:…>`.
#import "common.typ": *
#import "../main-defs.typ": grad

// The graph of a function by its `nodes`, pairs (point, slope) with the
// points from left to right: the cubic Hermite spline through them, `n`
// samples a piece.
#let hermite-graph(nodes, n: 24) = {
  let points = (nodes.first().first(),)
  for i in range(nodes.len() - 1) {
    let (((x0, y0), m0), ((x1, y1), m1)) = (nodes.at(i), nodes.at(i + 1))
    let h = x1 - x0
    for k in range(1, n + 1) {
      let s = k / n
      let (s2, s3) = (s * s, s * s * s)
      points.push((
        x0 + s * h,
        (2 * s3 - 3 * s2 + 1) * y0
          + (s3 - 2 * s2 + s) * h * m0
          + (3 * s2 - 2 * s3) * y1
          + (s3 - s2) * h * m1,
      ))
    }
  }
  points
}

// Figure 1: the graph of α = α(t) with its stationary points, two maxima, a
// minimum and an inflection point, where the slope is zero; each is marked
// by a ring and dropped to the t-axis. The graph is the Hermite spline
// through them and through the steepest point of each flank between them.
#let fig-7-1() = lettered-drawing({
  import cetz.draw: *
  let (max-1, min-1, bend, max-2) = (
    (9.74, 21.89),
    (16.59, 7.15),
    (27.43, 16),
    (37.38, 28.83),
  )
  let stationary = (max-1, min-1, bend, max-2)
  let nodes = (
    ((2.12, 4.87), 2),
    ((5.93, 14.39), 2.9),
    (max-1, 0),
    ((12.28, 16.81), -4.2),
    ((14.23, 8.9), -2.2),
    (min-1, 0),
    ((19.2, 8.72), 1.4),
    ((20.5, 11.39), 2.1),
    ((22.86, 14.9), 0.7),
    (bend, 0),
    ((31.33, 17.31), 0.9),
    ((33.87, 21.12), 2.3),
    ((35.39, 25.99), 3.7),
    (max-2, 0),
    ((39.71, 16.55), -11),
    ((43.01, 3.6), -1.3),
  )
  let ring = 0.7
  arrowed((-2.37, 0), (45.3, 0), name: "t")
  arrowed((0, -4.7), (0, 31.96), name: "alpha")
  content("t.end", $t$, anchor: "north-east", padding: (top: 1.6, right: 0))
  content("alpha.end", $alpha$, anchor: "north-west")
  for p in stationary { line(p, (p, "|-", (0, 0)), ..hidden) }
  line(..hermite-graph(nodes), stroke: 2 * thick-line)
  // The names above the rings, each moved by `shift` clear of the graph.
  for (p, label, shift) in stationary.zip(
    ($max$, $min$, emph[Перегиб], $max$),
    ((0, 0), (0, 1.6), (-1.2, 0), (0, 0)),
  ) {
    circle(p, radius: ring, fill: white, stroke: thick-line)
    let (dx, dy) = shift
    content((rel: (dx, ring + dy), to: p), label, anchor: "south")
  }
  content((max-2, "|-", (0, 0)), $alpha = alpha lr((t))$, anchor: "south-west")
})

// Figure 2: stationary points of α = α(u, v): a maximum, a minimum and a
// saddle, on three pieces of graphs over the plane (u, v). A drawing of the
// three bodies; the axes and labels set over it.
#let fig-7-2() = lettered-drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/07-02-critical-points.svg",
    64.35,
    corner: (6.94, 6.05),
  )
  let origin = (4.72, 11.85)
  axis-head-short(origin, (4.72, 36.5), name: "alpha")
  axis-head-short(origin, (26.1, 11.85), name: "v")
  axis-head-short(origin, (1.2, 3.85), name: "u")
  content(
    (rel: (-3.7, 0), to: "alpha.end"),
    $alpha = alpha lr((u, v))$,
    anchor: "south-west",
    padding: 0.5,
  )
  content(("v.end", 2.2, origin), $v$, anchor: "north")
  content("u.end", $u$, anchor: "west")
  content((14.15, 34.5), $max$, anchor: "south-west", padding: 0.3)
  content((31.2, 17.8), $min$, anchor: "north")
  content((55.65, 25.3), emph[Седло])
})
// Figure 3: the derivative of α(u, v) along a⃗ at a point of G: the graph
// α = α(u, v) over the domain G with a curve γ(t) on it, a⃗ and grad(α) at
// the point. A drawing of the graph and the domain; the axes and labels set
// over it.
#let fig-7-3() = lettered-drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/07-03-directional-derivative.svg",
    36.03,
    corner: (8.34, 4.23),
  )
  let origin = (6.75, 19.74)
  axis-head-short(origin, (6.75, 46.35), name: "alpha")
  axis-head-short(origin, (17, 19.74), name: "v")
  axis-head-short(origin, (0.79, 3.29), name: "u")
  spot(origin, radius: 0.7)
  content("alpha.end", $alpha$, anchor: "north-west")
  content(("v.end", 2.2, origin), $v$, anchor: "north")
  content("u.end", $u$, anchor: "west")
  content((38.45, 42.5), $alpha = alpha lr((u, v))$)
  content((36.15, 34.5), cutout($gamma lr((t))$))
  content((39.8, 9.8), cutout($arrow(a)$))
  content((13.73, 3.66), $G$)
  content((35.25, 2.93), $grad lr((alpha))$)
})
// Figure 4: the functional J as a graph over the space F: the points f⃗,
// f⃗ + εη⃗, f⃗ + η⃗ of F and the values of J over them. A drawing; the labels
// set over it.
#let fig-7-4() = lettered-drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/07-04-functional-graph.svg",
    50.67,
    corner: (0.85, 0.08),
  )
  for (at, label) in (
    ((4.68, 45), $J$),
    ((46.4, 46.85), $J[arrow(f)]$),
    ((19.5, 6.8), $arrow(f)$),
  ) {
    content(at, cutout(label))
  }
  content(
    (36.6, 7.45),
    cutout($arrow(f) + arrow(eta)$),
    anchor: "west",
    padding: 0,
  )
  content((47.4, 11.7), $F$)
  // Between the line of the points and the edge of F, as small as printed.
  content((29.6, 4.03), text(size: 6.5pt, $arrow(f) + epsilon arrow(eta)$))
})

// Figure 5: the graph of J over F cut by the subspace T of the functions
// f⃗ + εη⃗, η⃗|_∂D = 0, through f⃗: the restriction J/T. A drawing; the labels
// set over it.
#let fig-7-5() = lettered-drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/07-05-functional-restriction.svg",
    52.62,
    corner: (0.97, 0.13),
  )
  for (at, label) in (
    ((8.37, 49.3), $J$),
    ((29.9, 7.45), $arrow(f)$),
    ((41.1, 5.9), $T$),
  ) {
    content(at, cutout(label))
  }
  content((54.24, 3.1), $F$)
  // Between the axis and the leader to the section, as small as printed.
  content(
    (15.25, 30.35),
    cutout(text(size: 7pt, $J \/ T$)),
    anchor: "east",
    padding: 0,
  )
})

// The point at abscissa x of a polyline that runs left to right.
#let polyline-at-x(points, x) = {
  for i in range(points.len() - 1) {
    let ((x0, y0), (x1, y1)) = (points.at(i), points.at(i + 1))
    if (x0 - x) * (x1 - x) <= 0 {
      return (x, y0 + (y1 - y0) * (x - x0) / (x1 - x0))
    }
  }
}

// Figure 6: a curve f⃗ with fixed ends A and B and its variation f⃗ + η⃗,
// η⃗(A) = η⃗(B) = 0: the varied arc leaves f⃗ at one point and returns at
// another; η⃗ is drawn upwards from f⃗ at equal steps of x. Both curves are
// smooth curves through points of the free-hand originals.
#let fig-7-6() = lettered-drawing({
  import cetz.draw: *
  let (a, b) = ((2.27, 17.75), (31.75, 3.13))
  // Where the variation leaves f⃗ and returns.
  let (leave, back) = ((12.8, 12), (42, 29.8))
  let f-points = (
    a,
    (4, 15.8),
    (6, 14.28),
    (8, 13.19),
    (10, 12.45),
    leave,
    (16, 11.94),
    (20, 12.5),
    (24, 14.2),
    (28, 17.2),
    (32, 21.6),
    (36, 26.3),
    (39, 28.6),
    back,
    (44.5, 29.2),
    (45.9, 26.5),
    (45.6, 24),
    (44, 20),
    (40.7, 16),
    (36, 12),
    (33.95, 10),
    (32.7, 8),
    (32, 6),
    b,
  )
  let varied-points = (
    leave,
    (16, 13.18),
    (20, 16.4),
    (22.2, 20),
    (23.1, 24),
    (24.3, 28),
    (26, 29.6),
    (30, 30.24),
    (36, 29.95),
    back,
  )
  let n = 16
  let f = spline-through(f-points, n: n)
  let varied = spline-through(varied-points, n: n)
  let arc = f.slice(
    n * f-points.position(p => p == leave),
    n * f-points.position(p => p == back) + 1,
  )
  // The varied arc: a white band between two thin lines.
  let band = 1mm
  line(..varied, stroke: (thickness: band))
  line(..varied, stroke: (thickness: band - 2 * thin-line, paint: white))
  // η⃗ at `count` equal steps of x from `first` to `last`.
  let (first, last, count) = (18.2, 37.8, 17)
  for k in range(count) {
    let x = first + k * (last - first) / (count - 1)
    let (base, top) = (polyline-at-x(arc, x), polyline-at-x(varied, x))
    line(
      base,
      (rel: (0, -band / 2 / 1mm), to: top),
      mark: (
        end: "stealth",
        length: 1.4mm,
        width: 0.7mm,
        inset: 0.35mm,
      ),
    )
  }
  line(..f, stroke: 2 * thick-line)
  spot(a, radius: 1.6)
  spot(b, radius: 1.4)
  content(a, $A$, anchor: "north", padding: 1.6 + 0.6)
  content(b, $B$, anchor: "west", padding: 1.4 + 0.6)
  content((31.5, 17.7), $arrow(f)$)
  content((18.1, 26.1), $arrow(f) + arrow(eta)$)
  content((41.3, 21), $gamma lr((t))$)
})

// Figure 7: integration along x^α: the line parallel to the axis x^α
// through a point of the hyperplane x¹ … x̂^α … xⁿ (a black triangle seen
// obliquely) enters the domain D at P and leaves it at Q. D is a free-hand
// region, a smooth closed curve through points of the original, white over
// its stippled shadow, with hand shading along the inside of its outline.
#let fig-7-7() = lettered-drawing({
  import cetz.draw: *
  // The hyperplane: its corners, the lowest one on the axis x^α.
  let (left, top, bottom) = ((1.9, 25.6), (18.3, 41.6), (9.8, 4))
  let (p, q) = ((33.6, 24.9), (59.3, 24.72))
  // The point of the line PQ at abscissa x.
  let on-line(x) = (
    x,
    p.at(1)
      + (q.at(1) - p.at(1))
        * (x - p.at(0))
        / (
          q.at(0) - p.at(0)
        ),
  )
  let (start, end) = (on-line(12.9), on-line(85.5))
  // The outline of D counterclockwise from its top, and its shadow.
  let outline-points = (
    (46.5, 38.35),
    (42.5, 38.1),
    (39, 37),
    (36, 35.2),
    (33.4, 33),
    (31.4, 30.5),
    (30.1, 27.5),
    (29.8, 24.5),
    (30, 21.5),
    (30.7, 18.8),
    (32.2, 16.3),
    (34.5, 14),
    (37.5, 12.6),
    (41.2, 12.05),
    (44.6, 12.5),
    (47.9, 14),
    (51.2, 15.7),
    (54.5, 17.15),
    (56.6, 16),
    (58.2, 14),
    (59.6, 11.6),
    (62.4, 9.65),
    (64.6, 11.1),
    (65.6, 13.5),
    (65.95, 16),
    (66.05, 19),
    (65.75, 22),
    (65.35, 25.5),
    (64.8, 28),
    (63.8, 30),
    (62.4, 32),
    (60.55, 34),
    (57.45, 36),
    (55.05, 37),
    (51.3, 38),
  )
  let shadow-points = (
    (39.5, 37.3),
    (33, 37.7),
    (28.5, 37.1),
    (25.3, 36),
    (23, 34),
    (20.9, 32),
    (19.4, 30),
    (18.4, 27),
    (18, 24),
    (18.3, 20),
    (19.4, 16.5),
    (20.7, 14),
    (22.6, 12),
    (25, 9.9),
    (28.5, 8.6),
    (33, 8.2),
    (38, 8.8),
    (43, 10.2),
    (46.5, 9.2),
    (48.2, 7.6),
    (50, 5.9),
    (51.6, 5.4),
    (53.5, 6),
    (54.8, 7.6),
    (55.3, 10.5),
    (55.2, 13),
    (55.4, 17.3),
    (48, 26),
  )
  let n = 16
  let outline = spline-through(outline-points, n: n, close: true)
  // The length of the outline up to each of its samples.
  let walked = (0,)
  for i in range(1, outline.len()) {
    let ((x0, y0), (x1, y1)) = (outline.at(i - 1), outline.at(i))
    walked.push(walked.last() + calc.norm(x1 - x0, y1 - y0))
  }
  // Hand shading inside D along its outline from the point `from` to the
  // point `to` of `outline-points`: `count` strokes of `length` at equal
  // steps, set in from the outline by `inset` at the ends and `deep` in the
  // middle, turned from the outline by `turns` (start, middle, end).
  let shading(from, to, count, length, inset, deep, turns) = {
    let (a, b) = (walked.at(n * from), walked.at(n * to))
    for k in range(count) {
      let s = (k + 0.5) / count
      let target = a + s * (b - a)
      let i = walked.position(w => w >= target)
      let ((x0, y0), (x1, y1)) = (outline.at(i - 1), outline.at(i))
      let along = calc.atan2(x1 - x0, y1 - y0)
      let r = (target - walked.at(i - 1)) / (walked.at(i) - walked.at(i - 1))
      let depth = inset + (deep - inset) * calc.sin(s * 180deg)
      let turn = if s < 0.5 {
        turns.at(0) + (turns.at(1) - turns.at(0)) * 2 * s
      } else { turns.at(1) + (turns.at(2) - turns.at(1)) * (2 * s - 1) }
      let centre = (
        x0 + r * (x1 - x0) - depth * calc.sin(along),
        y0 + r * (y1 - y0) + depth * calc.cos(along),
      )
      let half = (rel: (along + turn, length / 2), to: centre)
      line((rel: (along + turn + 180deg, length / 2), to: centre), half)
    }
  }
  line(
    ..spline-through(shadow-points, n: n, close: true),
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(..outline, close: true, fill: white, stroke: thick-line)
  group({
    set-style(stroke: (thickness: 0.9pt))
    shading(8, 17, 22, 1.6, 1.8, 2.8, (68deg, 58deg, 12deg))
    shading(22, 32, 30, 1.3, 1.5, 3.2, (-30deg, -5deg, 10deg))
  })
  // The hyperplane, the axis x^α and the line through P and Q, which
  // passes over the outline of D.
  line(left, top, bottom, close: true, fill: black)
  axis-head-short(bottom, (83.5, bottom.at(1)), short: 1.7, name: "axis")
  group({
    set-style(stroke: (thickness: thick-line))
    line(start, p)
    line(p, q, ..hidden)
    bridge((q, end))
    mark((end, 4.2, start), end, symbol: "stealth")
  })
  circle(start, radius: 0.6, fill: white, stroke: none)
  spot(bottom, radius: 0.85)
  spot(p, radius: 0.75)
  spot(q, radius: 0.75)
  content(p, $P$, anchor: "north", padding: 1.2)
  content(q, $Q$, anchor: "north", padding: 1.2)
  content((63.9, 35.1), $D$)
  content(("axis.end", 1.7, bottom), $x^alpha$, anchor: "north")
  content(
    (left, 50%, top),
    $x^1 dots hat(x^alpha) dots x^n$,
    angle: top,
    anchor: "south",
    padding: 0.8,
  )
})
