// Figures of chapter 4, § 6. Each is a function called by the text:
// `#fig(fig-4-114()) <fig:…>`.
#import "common.typ": *

// The graph of the polynomial through the points `nodes` (Lagrange's
// formula): the real picture of an algebraic curve w = g(z).
#let polynomial-through(nodes) = t => {
  let value = 0
  for (i, (xi, yi)) in nodes.enumerate() {
    let basis = 1
    for (j, (xj, _)) in nodes.enumerate() {
      if j != i { basis *= (t - xj) / (xi - xj) }
    }
    value += yi * basis
  }
  value
}

// The axes of the plane ℂ²(z, w) in figs. 114–118: z across, w up, plain
// lines from the starts to the ends, the origin 0 marked; the names stand
// beside the ends on the sides `z-side` and `w-side`.
#let complex-plane-axes(
  z-start,
  w-start,
  z-end,
  w-end,
  z-name: $CC^1 (z)$,
  w-name: $CC^1 (w)$,
  z-side: "south-east",
) = {
  import cetz.draw: *
  line((z-start, 0), (z-end, 0))
  line((0, w-start), (0, w-end))
  spot((0, 0))
  content((0, 0), $0$, anchor: "north-east")
  content((z-end, 0), z-name, anchor: z-side)
  content((0, w-end), w-name, anchor: "north-west")
}

// A coil along the polyline `points`, as drawn about the ends of a bold
// curve: short bold bars across it, `step` apart along it, `reach` to either
// side, leaning by `lean`.
#let coil-bars(points, step: 0.8, reach: 0.75, lean: 10deg) = {
  let travelled = 0
  let next = step / 2
  for i in range(1, points.len()) {
    let ((x0, y0), (x1, y1)) = (points.at(i - 1), points.at(i))
    let d = calc.sqrt(calc.pow(x1 - x0, 2) + calc.pow(y1 - y0, 2))
    let across = calc.atan2(x1 - x0, y1 - y0) + 90deg + lean
    while next <= travelled + d {
      let s = (next - travelled) / d
      let p = (x0 + s * (x1 - x0), y0 + s * (y1 - y0))
      cetz.draw.line(
        (rel: (across, -reach), to: p),
        (rel: (across, reach), to: p),
        stroke: 1.5pt,
      )
      next += step
    }
    travelled += d
  }
}

// Figure 114: near a point P₀ of f(z, w) = 0 the curve is the graph of
// w = g(z), bold inside the neighbourhood U(P₀), a coil beyond it where the
// solution is not considered. The curve is a cubic through four points,
// taken relative to P₀.
#let fig-4-114() = lettered-drawing({
  import cetz.draw: *
  let centre = (17.19, 21.08)
  let radius = 10.92
  let g = polynomial-through((
    (-11.85, -11.51),
    (0, 0),
    (8.04, 7.11),
    (13.55, 9.23),
  ))
  let curve = sample(
    t => (centre.at(0) + t, centre.at(1) + g(t)),
    -11.85,
    13.55,
  )
  let inside(p) = (
    calc.pow(p.at(0) - centre.at(0), 2) + calc.pow(p.at(1) - centre.at(1), 2)
      <= radius * radius
  )
  complex-plane-axes(
    -7.37,
    -4.83,
    32.6,
    39.79,
    z-name: $(z) = CC^1$,
    w-name: $(w) = CC^1$,
    z-side: "north-east",
  )
  circle(centre, radius: radius, fill: stipple)
  line((0, centre.at(1)), centre, (centre.at(0), 0))
  for run in (
    curve.filter(p => not inside(p) and p.at(0) < centre.at(0)),
    curve.filter(p => not inside(p) and p.at(0) > centre.at(0)),
  ) {
    coil-bars(run)
  }
  line(..curve.filter(inside), stroke: (thickness: 1.1, cap: "butt"))
  spot(centre, radius: 1.3)
  spot((0, centre.at(1)))
  spot((centre.at(0), 0))
  content((rel: (0deg, 1.3), to: centre), $P_0$, anchor: "north-west")
  content((rel: (65deg, radius), to: centre), $U(P_0)$, anchor: "south")
  content((0, centre.at(1)), $w$, anchor: "east")
  content((centre.at(0), 0), $z$, anchor: "south-west")
})

// Figure 115: moving along the curve f(z, w) = 0 from (z₀, w₀) to
// (z̃₀, w̃₀). The curve is the graph of the cubic through its ends and the
// two marked points.
#let fig-4-115() = lettered-drawing({
  import cetz.draw: *
  let (start, here, there, end) = (
    (9.57, 16.85),
    (16.34, 23.79),
    (28.45, 30.9),
    (33.1, 39.71),
  )
  let g = polynomial-through((start, here, there, end))
  let at(t) = (t, g(t))
  complex-plane-axes(-4.23, -4.06, 37.51, 40.13)
  // The marked points with their coordinates; the label of w₀ below its
  // mark, that of w̃₀ above.
  for (name, p, z-name, w-name, w-side) in (
    ("here", here, $z_0$, $w_0$, "north-east"),
    ("there", there, $tilde(z)_0$, $tilde(w)_0$, "south-east"),
  ) {
    line((0, p.at(1)), p, (p.at(0), 0))
    spot((0, p.at(1)))
    spot((p.at(0), 0))
    content((p.at(0), 0), z-name, anchor: "north", name: "z-" + name)
    content((0, p.at(1)), w-name, anchor: w-side, name: "w-" + name)
  }
  brush-stroke(sample(at, start.at(0), end.at(0)), 1.6, taper: 4)
  spot(here, radius: 1.4)
  spot(there, radius: 1.4)
  // The moves z₀ → z̃₀ and w₀ → w̃₀ between the labels.
  arrowed("z-here.east", "z-there.west")
  arrowed("w-here.north", "w-there.south")
  // The name of the curve along its chord from (z̃₀, w̃₀) to the end, clear
  // of the bold stroke: the convex arc keeps below the chord.
  content(
    there,
    $f(z, w) = 0$,
    angle: end,
    anchor: "south-west",
    padding: 1.4,
  )
})

// The curve Γ = {f = 0} of figs. 116 and 117, a free-hand loop in the real
// picture of ℂ²: the points of a smooth curve that meets the line
// z = `fibre` at the heights `levels`, from the top down. Along the curve
// it runs from its upper end through the points `arm` to the top point,
// round the outer bend `outer` to the third point, round the inner bend
// `inner` to the second, round the lower bend `lower` to the fourth, and
// through `tail` to its lower end.
#let looping-curve(fibre, levels, arm, outer, inner, lower, tail) = {
  let over = levels.map(w => (fibre, w))
  (
    over: over,
    through: (
      ..arm,
      over.at(0),
      outer,
      over.at(2),
      inner,
      over.at(1),
      lower,
      over.at(3),
      ..tail,
    ),
  )
}

// The bold curve of figs. 116 and 117 through its points.
#let bold-hobby(points) = cetz.draw.hobby(
  ..points,
  stroke: (thickness: 1.0, cap: "round"),
)

// Figure 116: the projection π: Γ → ℂ¹(z); over the point z₀ lie the four
// values of w = g(z), the points of Γ on the line z = z₀.
#let fig-4-116() = lettered-drawing({
  import cetz.draw: *
  let fibre = 19.57
  let name-at = (29.6, 35.7)
  let gamma = looping-curve(
    fibre,
    (34.71, 27.74, 19.27, 10.61),
    ((41.26, 40.96), name-at),
    (10.13, 28.72),
    (29.67, 24.48),
    (10.45, 20.25),
    ((34.22, 17.64), (39.44, 36.66)),
  )
  complex-plane-axes(-4.66, -4.23, 41.91, 40.64)
  for p in gamma.over {
    line((0, p.at(1)), p)
    spot((0, p.at(1)))
  }
  line(gamma.over.first(), (fibre, 0), ..fine-dash)
  bold-hobby(gamma.through)
  for p in gamma.over { spot(p, radius: 1.0) }
  spot((fibre, 0))
  content((fibre, 0), $z_0$, anchor: "south-west")
  content(name-at, $Gamma = {f = 0}$, anchor: "south-east")
  // The projection π, a heavy arrow down beside ℂ¹(w).
  arrowed(
    (-2.57, 35.55),
    (-2.57, 17.64),
    stroke: 1.4pt,
    mark: (end: "stealth", length: 5, width: 2.2),
    name: "projection",
  )
  content("projection.start", $pi$, anchor: "south")
})

// Figure 117: Γ again; a point P of it, its value w = ρ(P) and its
// projection z(P), the other points over z(P) open.
#let fig-4-117() = lettered-drawing({
  import cetz.draw: *
  let fibre = 20.26
  let name-at = (26.49, 31.76)
  let gamma = looping-curve(
    fibre,
    (33.88, 24.5, 16.46, 8.06),
    ((37.98, 31.16), (33.14, 29.04), name-at),
    (9.56, 24.5),
    (29.51, 21.48),
    (11.97, 14.22),
    ((32.54, 14.22), (38.58, 20.57)),
  )
  let point = gamma.over.at(1)
  // The label w = ρ(P) is wider than its lettering in the book: the curve
  // stands this much further from the axis ℂ¹(w).
  let room = 4
  complex-plane-axes(-1.7, -5.13, 39.79 + room, 39.02)
  spot((0, point.at(1)), radius: 1.0)
  content((0, point.at(1)), $w = rho(P)$, anchor: "north-west")
  group({
    translate((room, 0))
    line(gamma.over.first(), (fibre, 0))
    line((-room, point.at(1)), point)
    bold-hobby(gamma.through)
    for p in gamma.over {
      if p == point { spot(p, radius: 1.0) } else {
        circle(p, radius: 0.8, fill: white, stroke: 1pt)
      }
    }
    spot((fibre, 0))
    content(point, $P$, anchor: "south-west", padding: 1.8)
    content((fibre, 0), $z(P)$, anchor: "south-west")
    content(name-at, $Gamma = {f = 0}$, anchor: "south-west")
  })
})

// A target on the axis marking a point z with the values over it: a black
// dot in `rings` concentric rings, `radius` across.
#let target-mark(at, rings, radius: 1.75) = {
  let step = radius / (rings + 1)
  for k in range(rings + 1, 1, step: -1) {
    cetz.draw.circle(at, radius: k * step, fill: white, stroke: 1pt)
  }
  spot(at, radius: step)
}

// Figure 118: the branches φ₁, …, φ₄ of w = g(z). Over z₀ they take four
// values, k(z₀) = k; at the branch point z₀′ they merge in pairs,
// k(z₀′) < k. A pair is w = w′ + (c s ± a √s) e^(−s/L), s = z − z₀′: the
// two values of a square root at a branch point, fading out to the right;
// w′ is the branch point, a and c are fixed by the values over z₀.
#let fig-4-118() = lettered-drawing({
  import cetz.draw: *
  let (branch, base) = (8.33, 23.99)
  let (fade, reach) = (30.14, 36)
  let gap = base - branch
  // A pair: the branch point, the upper and lower values over z₀, their
  // names.
  let pairs = (
    (26.08, 34.76, 17.47, $phi_4$, $phi_2$),
    (12.53, 23.82, 5.4, $phi_3$, $phi_1$),
  )
  let branch-of(pair, sign) = s => {
    let (merge, upper, lower, ..) = pair
    let mean = (upper + lower) / 2 - merge
    let half = (upper - lower) / 2
    (
      branch + s,
      merge
        + (mean * s / gap + sign * half * calc.sqrt(s / gap))
          * calc.exp((gap - s) / fade),
    )
  }
  let bold = (stroke: (thickness: 1.0, cap: "round"))
  complex-plane-axes(-3.2, -2.3, 47.6, 42.66)
  line((branch, pairs.first().at(0)), (branch, 0))
  line((base, pairs.first().at(1)), (base, 0))
  // The lower pair passes under the upper one where φ₃ crosses φ₂.
  for (index, pair) in pairs.rev().enumerate() {
    if index == 1 {
      let under = sample(branch-of(pair, -1), 0.1 * gap, 0.5 * gap, n: 40)
      line(..under, stroke: (paint: white, thickness: 2.2, cap: "butt"))
    }
    for (sign, name, side) in (
      (1, pair.at(3), "south-west"),
      (-1, pair.at(4), "north-west"),
    ) {
      let points = sample(branch-of(pair, sign), 0, reach)
      line(..points, ..bold)
      content(points.last(), name, anchor: side, padding: 0.5)
    }
    spot((branch, pair.at(0)), radius: 0.85)
    spot((base, pair.at(1)), radius: 0.85)
    spot((base, pair.at(2)), radius: 0.85)
  }
  target-mark((branch, 0), 1)
  target-mark((base, 0), 2)
  content(
    branch-of(pairs.first(), 1)(0.28 * reach),
    $Gamma$,
    anchor: "south",
  )
  content((branch, 0), $z'_0$, anchor: "south-east", padding: 1.6)
  content((base, 0), $z_0$, anchor: "south-west", padding: 1.6)
  // The notes under the axis begin at the origin and at z₀, as printed.
  content(
    (0, 0),
    anchor: "north-west",
    padding: 2.2,
    std.grid(
      row-gutter: 0.6mm,
      emph[Точка ветвления],
      $k(z'_0) < k$,
    ),
  )
  content((base, 0), anchor: "north-west", padding: 2.2, $k(z_0) = k$)
})

// A plane seen in perspective: the map of its unit square onto the
// quadrilateral with the corners `front-left`, `front-right`, `back-right`,
// `back-left` (the images of (0, 0), (1, 0), (1, 1), (0, 1)), Heckbert's
// square-to-quadrilateral projective map.
#let perspective-square(front-left, front-right, back-right, back-left) = {
  let ((x0, y0), (x1, y1), (x2, y2), (x3, y3)) = (
    front-left,
    front-right,
    back-right,
    back-left,
  )
  let (sx, sy) = (x0 - x1 + x2 - x3, y0 - y1 + y2 - y3)
  let (dx1, dx2, dy1, dy2) = (x1 - x2, x3 - x2, y1 - y2, y3 - y2)
  let det = dx1 * dy2 - dx2 * dy1
  let g = (sx * dy2 - dx2 * sy) / det
  let h = (dx1 * sy - sx * dy1) / det
  ((u, v)) => {
    let w = g * u + h * v + 1
    (
      ((x1 - x0 + g * x1) * u + (x3 - x0 + h * x3) * v + x0) / w,
      ((y1 - y0 + g * y1) * u + (y3 - y0 + h * y3) * v + y0) / w,
    )
  }
}

// The parameter in [a, b] where the increasing function f reaches `target`.
#let solve-increasing(f, target, a, b) = {
  let (low, high) = (a, b)
  for _ in range(40) {
    let middle = (low + high) / 2
    if f(middle) < target { low = middle } else { high = middle }
  }
  (low + high) / 2
}

// Figure 119: the Riemann surface Γ of w² = z over the plane ℂ¹(z), drawn
// as a ramp of two turns about the branch point 0: the lower sheet φ₂ an
// annulus rising by one turn, the upper sheet φ₁ a cone of rulings from 0
// to a narrower level turn that ends in the cut at the left. Over a point z
// of the circle γ about 0 the vertical meets both sheets, at φ₁(z) and
// φ₂(z); going round γ passes from one sheet to the other. The rims are
// elliptic turns in the view, s turns from the left counterclockwise; the
// plane is a black slab in perspective, γ a circle on it.
#let fig-4-119() = lettered-drawing({
  import cetz.draw: *
  // The plane: its corners in the view, the branch point 0 and the radius
  // of γ in the coordinates of the plane (the plane is deep by `depth`
  // widths), the angle of z on γ.
  let plane = perspective-square(
    (-41.66, -8.47),
    (55.71, -8.47),
    (27.18, 7.62),
    (-28.11, 8.04),
  )
  let (centre, radius, depth) = ((0.449, 0.379), 0.35, 1.21)
  let on-gamma(t) = plane((
    centre.at(0) + radius * calc.cos(t),
    centre.at(1) + radius * calc.sin(t) / depth,
  ))
  let origin = plane(centre)
  let point = on-gamma(-124deg)
  let slab = 2.4
  // The rims: the lower turn s ∈ [0, 1] rises by `rise`, the upper turn
  // s ∈ [1, 2] is level and narrows; the apex of the rulings over 0.
  let lower(s) = (
    4.49 - 30.48 * calc.cos(s * 360deg),
    25.4 + 9.74 * s - 11.43 * calc.sin(s * 360deg),
  )
  let upper(s) = (
    -0.8 - (24.34 - 4.24 * (s - 1)) * calc.cos(s * 360deg),
    32.9 - 6.35 * calc.sin(s * 360deg),
  )
  let apex = (origin.at(0), 31.75)
  // Where the vertical through x meets the front of a rim.
  let over(rim, x, from) = rim(solve-increasing(
    s => rim(s).at(0),
    x,
    from,
    from + 0.5,
  ))
  let back-edge-at(x) = {
    let ((xa, ya), (xb, yb)) = (plane((0, 1)), plane((1, 1)))
    (x, ya + (yb - ya) * (x - xa) / (xb - xa))
  }

  // The slab: the black top, the hatched front.
  line(
    plane((0, 0)),
    plane((1, 0)),
    plane((1, 1)),
    plane((0, 1)),
    close: true,
    fill: black,
  )
  let (front-left, front-right) = (plane((0, 0)), plane((1, 0)))
  let below(p) = (p.at(0), p.at(1) - slab)
  line(
    front-left,
    front-right,
    below(front-right),
    below(front-left),
    close: true,
  )
  for x in range(int(front-left.at(0) / 0.7) + 1, int(
    front-right.at(0) / 0.7,
  )) {
    let x = x * 0.7
    line(
      (x, front-left.at(1)),
      (x - slab, front-left.at(1) - slab),
      stroke: 0.4pt,
    )
  }
  // On the plane: γ with its arrows, 0, z, the verticals in white.
  let white-line = (stroke: (paint: white, thickness: 0.8pt))
  line(..sample(on-gamma, 0deg, 360deg, n: 144), close: true, ..white-line)
  for t in (-102deg, -62deg) {
    mark(
      on-gamma(t - 1deg),
      on-gamma(t),
      symbol: "stealth",
      fill: white,
      stroke: white,
    )
  }
  line(origin, back-edge-at(origin.at(0)), ..white-line)
  line(point, back-edge-at(point.at(0)), ..white-line)
  spot(origin, fill: white)
  spot(point, fill: white)
  let on-black(body) = text(fill: white, body)
  content(origin, on-black($0$), anchor: "west")
  content(plane((0.07, 0.06)), on-black($z$))
  content(on-gamma(-25deg), on-black($gamma$), anchor: "north-west")
  content(plane((1, 0.62)), $CC^1 (z)$, anchor: "south-west")

  // The lower sheet with its rim; the axis and the vertical through z up
  // to it.
  let lower-front = over(lower, origin.at(0), 0)
  let lower-at-z = over(lower, point.at(0), 0)
  let upper-at-z = over(upper, point.at(0), 1)
  line(back-edge-at(origin.at(0)), lower-front)
  line(back-edge-at(point.at(0)), lower-at-z, upper-at-z)
  line(..sample(lower, 0, 1), close: true, fill: stipple, stroke: none)
  line(..sample(lower, 0.55, 1))
  line(lower(1), lower(0))
  line(..sample(lower, 0, 0.55), stroke: thick-line)
  line(lower-front, apex, ..fine-dash)
  // The upper sheet: white, its rulings, its rim.
  line(..sample(upper, 1, 2), close: true, fill: white, stroke: none)
  for s in sample(s => s, 1, 2, n: 48) { line(apex, upper(s), stroke: 0.4pt) }
  line(..sample(upper, 1.5, 2))
  line(..sample(upper, 1, 1.5), stroke: thick-line)
  line(lower-at-z, upper-at-z)
  // The way round: arrows on the backs of both rims.
  for rim in (lower, upper) {
    let s = if rim == lower { 0.75 } else { 1.75 }
    mark(rim(s - 0.01), rim(s), symbol: "stealth", fill: black)
  }
  spot(lower-at-z, radius: 1.0)
  spot(upper-at-z, radius: 1.0)
  content(upper-at-z, cutout($phi_1 (z)$), anchor: "north-east")
  content(lower-at-z, $phi_2 (z)$, anchor: "north-east")
  content(upper(1.5), $phi_1$, anchor: "west")
  content(lower(0.5), $phi_2$, anchor: "west")
  content(lower(0.66), $Gamma = {w^2 = z}$, anchor: "south-west")
})

// S² × S² drawn as a square of `side` (figs. 120, 122): its sides the
// spheres 0 × S²(w), S²(z) × 0, ∞_z × S²(w), S²(z) × ∞_w, through the
// corners (0, 0), (∞_z, 0), (∞_z, ∞_w), (0, ∞_w), each a spindle bulging
// `bulge` to either side with its equator `equator` across; the square is
// stippled between the inner arcs. The equator is a solid black ellipse
// (`solid`) or a ring with its half towards the lower right bold. The
// tips of the spindles, outwards from the bottom counterclockwise, are
// `product-square-tips(side, bulge)`.
#let product-square-tips(side, bulge) = (
  (side / 2, -bulge),
  (side + bulge, side / 2),
  (side / 2, side + bulge),
  (-bulge, side / 2),
)
#let product-square(side, bulge, equator, solid: false) = {
  import cetz.draw: *
  let corners = ((0, 0), (side, 0), (side, side), (0, side))
  let sides = range(4).map(k => (corners.at(k), corners.at(calc.rem(k + 1, 4))))
  // The point of a side's spindle at its middle, `m` outwards.
  let off(p, q, m) = {
    let (dx, dy) = (q.at(0) - p.at(0), q.at(1) - p.at(1))
    let length = calc.sqrt(dx * dx + dy * dy)
    (
      (p.at(0) + q.at(0)) / 2 + dy / length * m,
      (p.at(1) + q.at(1)) / 2 - dx / length * m,
    )
  }
  merge-path(close: true, fill: stipple, stroke: none, {
    for (p, q) in sides { arc-through(p, off(p, q, -bulge), q) }
  })
  for (p, q) in sides {
    line(p, q)
    arc-through(p, off(p, q, bulge), q)
    arc-through(p, off(p, q, -bulge), q)
    group({
      translate(off(p, q, 0))
      rotate(calc.atan2(q.at(0) - p.at(0), q.at(1) - p.at(1)))
      let ring(width) = t => (width * calc.cos(t), bulge * calc.sin(t))
      if solid {
        line(
          ..sample(ring(equator), 0deg, 360deg, n: 72),
          close: true,
          fill: black,
        )
      } else {
        let lit = if (q.at(0) - p.at(0)) - (q.at(1) - p.at(1)) > 0 { 1 } else {
          -1
        }
        line(..sample(ring(equator), 0deg, 360deg, n: 72), close: true)
        line(
          ..sample(ring(lit * equator), -90deg, 90deg, n: 36),
          ..sample(ring(lit * 0.4 * equator), 90deg, -90deg, n: 36),
          close: true,
          fill: black,
        )
        spot((0, 0), radius: 0.45)
      }
    })
  }
}

// Figure 120: S² × S² and its part ℂ²(z, w). Top: S² × S² as a square,
// its sides the spheres through the points 0 and ∞ of either factor, each
// drawn as a spindle with its equator, the front half bold. Middle: the
// torus S² × S², the circles ∞_z × S²(w) (bold) and S²(z) × ∞_w meeting
// at (∞_z, ∞_w); the torus with both removed, cut open across one and
// stripped of the other (black). Bottom: what is left, ≅ ℂ¹(z) × ℂ¹(w).
#let fig-4-120() = lettered-drawing({
  import cetz.draw: *
  // The square: side, the bulge of a spindle, the half-width of its
  // equator; the names of the spheres beyond their spindles.
  let (side, bulge, equator) = (45.3, 4.0, 1.3)
  let corner(i, j) = (i * side, j * side)
  product-square(side, bulge, equator)
  for (tip, name, label-side) in product-square-tips(side, bulge)
    .zip(
      (
        ($S^2 (z) times 0$, "north"),
        ($infinity_z times S^2 (w)$, "west"),
        ($S^2 (z) times infinity_w$, "south"),
        ($0 times S^2 (w)$, "east"),
      ),
    )
    .map(((tip, (name, label-side))) => (tip, name, label-side)) {
    content(tip, name, anchor: label-side)
  }
  for (i, j, name, side) in (
    (0, 0, $0$, "north-east"),
    (1, 0, $infinity_z$, "north-west"),
    (0, 1, $infinity_w$, "south-east"),
    (1, 1, $(infinity_z, infinity_w)$, "west"),
  ) {
    spot(corner(i, j), radius: 0.9)
    content(corner(i, j), name, anchor: side, padding: 1.3)
  }
  let pair = (31.5, 32.4)
  circle(pair, radius: 1.3, fill: black)
  circle(pair, radius: 0.3, fill: white, stroke: none)
  content(pair, cutout($(z, w)$), anchor: "north", padding: 1.8)

  // The torus S² × S² with the circles ∞_z × S²(w) and S²(z) × ∞_w through
  // (∞_z, ∞_w); the same torus without both circles, cut open across one,
  // stripped of the other. A drawing, its lower left corner at the point
  // given.
  book-picture(
    "/assets/figures/04-120-tori.svg",
    102.23,
    labels: (
      ((7.1, 29.5), $S^2 times S^2$, "south-east"),
      ((30.1, 31.5), $infinity_z times S^2 (w)$, "south-west"),
      ((34.8, 7.1), $(infinity_z, infinity_w)$),
      ((23.2, 2.6), $S^2 (z) times infinity_w$),
    ),
    corner: (-23.07, -42.67),
  )

  // What is left: the plane ℂ¹(z) × ℂ¹(w), its removed sides black.
  content((49.1, -48.6), $tilde.equiv$, angle: 90deg)
  let (left, right, bottom, top) = (35.81, 60.79, -75.4, -53.8)
  rect((left, bottom), (right, top), fill: stipple)
  rect((left, bottom), (left + 2.1, top), fill: black)
  rect((left, bottom), (right, bottom + 1.5), fill: black)
  content((left, (bottom + top) / 2), $CC^1 (z) times CC^1 (w)$, anchor: "east")
})

// Figure 121: ℂP² as a disc with the points [1:0:0], [0:1:0], [0:0:1] on
// its rim; the lines x^i = 0 are the three sides of an equilateral
// triangle about the centre, each cutting a segment off the disc. The
// chart A_i = {x^i ≠ 0} is the disc without its segment (black); the last
// disc shows ℂP² = A₁ ∪ A₂ ∪ A₃: the segments hatched across their sides,
// where two meet cross-hatched.
#let fig-4-121() = lettered-drawing({
  import cetz.draw: *
  let radius = 11.3
  // The distance of the sides from the centre; the outward normals of the
  // lines x¹ = 0, x² = 0, x³ = 0.
  let inset = 0.3 * radius
  let normals = (150deg, 30deg, 270deg)
  let points = (90deg, 210deg, 330deg)
  let centres = (0, 23.71, 55.6, 81.2).map(x => (x, 0))
  // The point p from c, p given by its coordinates or as (angle, length).
  let at(c, p) = {
    let (x, y) = if type(p.at(0)) == angle {
      (p.at(1) * calc.cos(p.at(0)), p.at(1) * calc.sin(p.at(0)))
    } else { p }
    (c.at(0) + x, c.at(1) + y)
  }
  // The segment beyond the side with the normal n, as a closed polyline.
  let segment(c, n) = {
    let reach = calc.acos(inset / radius)
    sample(t => at(c, (t, radius)), n - reach, n + reach, n: 48)
  }
  let marks(c) = {
    for t in points {
      spot(at(c, (t, radius)), radius: 0.75, stroke: (
        paint: white,
        thickness: 0.3mm,
      ))
    }
  }
  // The charts.
  let names = (
    ($x^1 = 0$, $x^1 != 0$, $A_1 (z, w)$),
    ($x^2 = 0$, $x^2 != 0$, $A_2 (u, v)$),
    ($x^3 = 0$, $x^3 != 0$, $A_3 (alpha, beta)$),
  )
  for (k, (line-name, chart-name, name)) in names.enumerate() {
    let (c, n) = (centres.at(k), normals.at(k))
    circle(c, radius: radius, fill: stipple)
    line(..segment(c, n), close: true, fill: black)
    // The name of the chart in a white oval opposite the segment.
    let middle = at(c, (n + 180deg, inset))
    circle(middle, radius: (3.6, 1.6), fill: white, stroke: none)
    content(middle, chart-name)
    marks(c)
    content(at(c, (240deg, radius)), name, anchor: "north-east")
    if k < 2 {
      let side = if k == 0 { 1 } else { -1 }
      content(
        at(c, (n - side * 12deg, radius)),
        line-name,
        angle: side * 60deg,
        anchor: "south",
      )
    } else {
      content(
        at(c, (-calc.sqrt(radius * radius - inset * inset), -inset)),
        line-name,
        anchor: "north-east",
      )
    }
  }
  // The union: each segment hatched across its side.
  let c = centres.last()
  circle(c, radius: radius, fill: white)
  for n in normals {
    let gap = 0.55
    let count = int(radius / gap)
    for k in range(-count, count + 1) {
      let t = k * gap
      let outer = calc.sqrt(calc.max(radius * radius - t * t, 0))
      if outer > inset {
        let along = n + 90deg
        let foot = (t * calc.cos(along), t * calc.sin(along))
        line(
          at(c, at(foot, (n, inset))),
          at(c, at(foot, (n, outer))),
          stroke: 0.4pt,
        )
      }
    }
  }
  circle(c, radius: radius)
  marks(c)
  content(
    at(c, (240deg, radius)),
    anchor: "north-east",
    std.grid(
      align: right,
      row-gutter: 0.6mm,
      $CC P^2 =$,
      $= A_1 union A_2 union A_3$,
    ),
  )
})

// Figure 122: the closure Γ̃ of the Riemann surface in S² × S²: it meets
// the spheres at infinity in the single point (∞_z, ∞_w). The curve runs
// from the corner 0 to that corner, the oval stands for the rest of Γ̃.
#let fig-4-122() = lettered-drawing({
  import cetz.draw: *
  let (side, bulge, equator) = (34, 3.3, 1.1)
  product-square(side, bulge, equator, solid: true)
  let bold = (stroke: (thickness: 1.0, cap: "round"))
  hobby((0, 0), (11.3, 10.8), (21.6, 19.3), (side, side), ..bold)
  let (centre, tilt) = ((12.8, 18.6), 40deg)
  let oval(t) = {
    let (a, b) = (7.5 * calc.cos(t), 3.1 * calc.sin(t))
    (
      centre.at(0) + a * calc.cos(tilt) - b * calc.sin(tilt),
      centre.at(1) + a * calc.sin(tilt) + b * calc.cos(tilt),
    )
  }
  line(..sample(oval, 0deg, 360deg, n: 72), close: true, ..bold)
  spot((side, side), radius: 1.2)
  let (bottom, right, top, left) = product-square-tips(side, bulge)
  content(top, $S^2 times S^2$, anchor: "south")
  content((side, side), $(infinity_z, infinity_w)$, anchor: "south-west")
  content(left, $0 times S^2 (w)$, angle: 90deg, anchor: "south")
  content(bottom, $S^2 (z) times 0$, anchor: "north-west")
  content(oval(60deg), cutout($tilde(Gamma)$), anchor: "south")
})

// Figure 123: the closure Γ̃″ of the Riemann surface in ℂP², drawn as the
// disc of fig. 121 in the chart A₃: the line S₃² (x³ = 0) cuts off the
// black segment, Γ̃″ meets it in one point (open circle). Γ̃″ is a
// free-hand closed curve with a curl, a smooth curve through a few points.
#let fig-4-123() = lettered-drawing({
  import cetz.draw: *
  let radius = 23.6
  // The line S₃²: its outward normal and distance from the centre.
  let (normal, inset) = (30deg, 8.3)
  let reach = calc.acos(inset / radius)
  let along(t) = (
    inset * calc.cos(normal) - t * calc.sin(normal),
    inset * calc.sin(normal) + t * calc.cos(normal),
  )
  let meet = along(2.0)
  circle((0, 0), radius: radius, fill: stipple)
  line(
    ..sample(t => (t, radius), normal - reach, normal + reach, n: 72),
    close: true,
    fill: black,
  )
  for (at, name) in (
    ((-16.51, 10.08), $x^3 != 0$),
    ((-4.91, 10.92), $tilde(Gamma)''$),
    ((6.35, -14.31), $A_3$),
  ) {
    circle(at, radius: (4.8, 2.1), fill: white, stroke: none)
    content(at, name)
  }
  hobby(
    meet,
    (-0.85, 6.01),
    (-11.01, 3.05),
    (-16.09, -2.88),
    (-16.09, -8.81),
    (-13.12, -11.77),
    (-9.31, -9.23),
    (-11.43, -6.69),
    (-14.82, -8.38),
    (-13.55, -13.89),
    (-5.08, -13.46),
    (2.54, -7.96),
    (5.5, -0.34),
    close: true,
    stroke: (thickness: 1.0, cap: "round"),
  )
  circle(meet, radius: 0.7, fill: white, stroke: 0.6pt)
  for t in (90deg, 210deg, 330deg) {
    spot((t, radius), radius: 0.75, stroke: (paint: white, thickness: 0.3mm))
  }
  arrowed(
    (rel: (55deg, 4.5), to: (65deg, radius)),
    (65deg, radius - 2),
    name: "line",
  )
  content("line.start", $S_3^2$, anchor: "south-west", padding: 0.3)
  content((250deg, radius), $CC P^2$, anchor: "north-east")
})

// Figure 124: the sphere S² with the points 0 and ∞, the circle γ about
// the axis through them (its near half bold, with the way round), and the
// two-sheeted neighbourhoods U ⊂ Γ and W ⊂ Γ of the branch points over 0
// and ∞, their sheets crossing.
#let fig-4-124() = lettered-drawing(book-picture(
  "/assets/figures/04-124-branching-at-infinity.svg",
  78.23,
  labels: (
    ((50.1, 40.6), $S^2$),
    ((21.6, 23.1), $0$),
    ((53.9, 23.7), $infinity$),
    ((43.1, 8.9), $gamma$),
    ((6.6, 0.0), $U subset Gamma$),
    ((70.9, -2.5), $W subset Gamma$),
  ),
))

// Figure 125: the roots a₁, …, a_n of P_n(z); a small circle S¹(a_k) about
// a_k with no other root inside, run counterclockwise; a point z on it,
// z − a_k its radius.
#let fig-4-125() = lettered-drawing({
  import cetz.draw: *
  let radius = 11
  let point = (78deg, radius)
  let origin = (-35.73, -5.5)
  circle((0, 0), radius: radius, fill: stipple, stroke: thick-line)
  for t in (140deg, 190deg, 355deg) {
    mark((t - 2deg, radius), (t, radius), symbol: "stealth")
  }
  line(origin, point, stroke: thick-line)
  line((0, 0), point, stroke: thick-line, name: "radius")
  for (at, name, side) in (
    ((0, 0), cutout($a_k$), "north"),
    (point, $z$, "south-west"),
    (origin, $0$, "north-west"),
    ((-19.22, 7.79), $a_p$, "east"),
    ((-15.24, -7.37), $a_1$, "west"),
    ((13.55, -6.6), $a_n$, "north-west"),
  ) {
    spot(at, radius: 0.95)
    content(at, name, anchor: side, padding: 1.4)
  }
  content("radius.55%", cutout($z - a_k$), anchor: "west", padding: 1.2)
  content((40deg, radius), $S^1 (a_k)$, anchor: "south-west")
})

// The stipple of `stipple` with its dots moved half a step: laid over it,
// shading twice as dense.
#let stipple-between = dot-stipple(0.5mm, offset: 0.41mm)

// Figure 126: going round a_k along the circle about it, z − a_p for a
// root a_p outside returns to its value: the circle stays inside the angle
// under which it is seen from a_p (stippled; each further root its own
// shading, denser where two meet). The point z on the circle, the vectors
// z − a_p and z − a_k.
#let fig-4-126() = lettered-drawing({
  import cetz.draw: *
  let radius = 13.55
  let roots = ((-41.15, 9.48), (-34.63, -25.65), (24.89, -24.98))
  let point = (46deg, radius)
  // The region seen from p: to the tangent points and the near arc.
  for (i, p) in roots.enumerate() {
    let d = calc.sqrt(p.at(0) * p.at(0) + p.at(1) * p.at(1))
    let towards = calc.atan2(p.at(0), p.at(1))
    let opening = calc.acos(radius / d)
    let shade = if i == 1 { stipple-between } else { stipple }
    line(
      p,
      ..sample(
        t => (radius * calc.cos(t), radius * calc.sin(t)),
        towards - opening,
        towards + opening,
        n: 36,
      ),
      close: true,
      fill: shade,
    )
  }
  circle((0, 0), radius: radius, fill: white, stroke: thick-line)
  arrowed(roots.first(), point, stroke: 1.6pt, name: "from-p")
  arrowed((0, 0), point, stroke: 1.6pt, name: "from-k")
  for (p, name, side) in (
    (roots.at(0), $a_p$, "south-east"),
    (roots.at(1), $a_1$, "north-east"),
    (roots.at(2), $a_n$, "north-west"),
    ((0, 0), $a_k$, "north"),
  ) {
    spot(p, radius: 0.95)
    content(p, name, anchor: side, padding: 1.2)
  }
  spot(point, radius: 0.95)
  content(point, $z$, anchor: "west", padding: 1.4)
  content("from-p.88%", $z - a_p$, anchor: "north-east", padding: 1.2)
  content(
    "from-k.50%",
    $z - a_k$,
    angle: point,
    anchor: "north",
    padding: 1.2,
  )
})

// Figure 127: the Riemann surface Γ of w = √z over S² (left): two sheets
// over the disc about 0, crossing; the projection to the sphere sends the
// branch points to 0 and ∞. Cut along an arc γ from 0 to ∞, Γ falls into
// two sheets Γ₁, Γ₂ (right), each a copy of S² \ γ: the sphere with the
// slit opened, its edges γ⁺ and γ⁻.
#let fig-4-127() = lettered-drawing(book-picture(
  "/assets/figures/04-127-square-root-sheets.svg",
  98.72,
  labels: (
    ((39.4, 59.1), $Gamma$),
    ((38.2, 36.7), $infinity$),
    ((38.0, 13.0), $S^2$),
    ((15.8, 28.3), text(fill: white, $0$)),
    ((26.5, 7.6), text(fill: white, $infinity$)),
    ((91.4, 58.8), $Gamma_1$),
    ((72.9, 54.5), text(fill: white, $0$)),
    ((94.5, 39.5), $Gamma_2$),
    ((74.4, 37.1), text(fill: white, $0$)),
    ((71.7, 24.2), $0$),
    ((73.3, 16.7), $gamma^+$),
    ((82.3, 18.2), $gamma^-$),
    ((67.9, 9.3), $S^2 without gamma$),
    ((78.7, 6.7), $infinity$),
  ),
))

// Figure 128: gluing Γ from the sheets Γ₁ and Γ₂, each a sphere slit
// along γ (fig. 127). Across the slit the sheets cross (top right): the
// edge γ₁⁻ is glued to γ₂⁺, γ₁⁺ to γ₂⁻. Opening the slits (middle) and
// gluing gives a sphere again, S² = Γ = Γ₁ ∪ Γ₂ (bottom).
#let fig-4-128() = lettered-drawing(book-picture(
  "/assets/figures/04-128-gluing-sheets.svg",
  104.52,
  labels: (
    ((25.8, 79.2), $Gamma_1$),
    ((17.0, 77.3), $0$),
    ((16.8, 70.9), $gamma^+$),
    ((27.1, 69.3), $gamma^-$),
    ((23.7, 59.7), $infinity$, "north"),
    ((32.4, 68.2), text(1.6em, $union$)),
    ((52.8, 80.1), $Gamma_2$),
    ((47.4, 77.2), $0$),
    ((48.2, 70.3), $gamma^+$),
    ((57.2, 69.9), $gamma^-$),
    ((52.6, 59.5), $infinity$, "north"),
    ((96.4, 81.2), $Gamma_1$),
    ((101.9, 68.1), $Gamma_2$),
    ((84.5, 69.9), $0$),
    ((82.5, 63.4), $gamma_1^+$),
    ((88.4, 63.1), $gamma_1^-$),
    ((85.6, 54.7), $gamma_2^+$),
    ((91.9, 54.5), $gamma_2^-$),
    ((17.8, 46.1), $Gamma_1$),
    ((25.7, 46.1), $0$),
    ((18.1, 34.5), $gamma_1^+$),
    ((28.6, 35.6), $gamma_1^-$),
    ((24.2, 21.0), $infinity$, "north"),
    ((34.5, 47.2), $0$),
    ((39.3, 45.3), $Gamma_2$),
    ((39.5, 31.8), $gamma_2^-$),
    ((29.6, 27.7), $gamma_2^+$),
    ((34.8, 21.2), $infinity$, "north"),
    ((77.1, 49.4), $gamma_1^- = gamma_2^+$, "east"),
    ((85.3, 46.7), $0$),
    ((68.4, 41.8), $Gamma_1$),
    ((98.5, 41.1), $Gamma_2$),
    ((87.3, 38.2), $gamma_1^+ = gamma_2^-$, "west"),
    ((84.7, 28.8), $infinity$, "north"),
    ((71.6, 25.3), $0$),
    ((77.1, 13.9), $S^2 = Gamma = Gamma_1 union Gamma_2$, "west"),
    ((58.8, 1.8), cutout($infinity$)),
  ),
))

// Figure 129: the closure Γ̃ of the Riemann surface: 1) for odd n an
// embedded surface, here the sphere Γ̃₀; 2) for even n two points ∞ on
// the sheets Γ₁ and Γ₂ glued: the sheets touch; 3) Γ̃ in S² × S² (the
// torus), reaching through its hole.
#let fig-4-129() = lettered-drawing(book-picture(
  "/assets/figures/04-129-immersion.svg",
  96.01,
  labels: (
    ((0.0, 60.7), part-number(1)),
    ((26.6, 63.5), $S^2 = tilde(Gamma)_0$),
    ((3.8, 30.7), part-number(2)),
    (
      (24.5, 43.8),
      stack(spacing: 0.7mm, emph[Касание], emph[двух листов]),
      "north-west",
    ),
    ((43.2, 11.6), $tilde(Gamma)$),
    ((63.7, 60.8), $S^2 times S^2$),
    ((80.1, 59.7), part-number(3)),
    ((84.2, 35.2), cutout($tilde(Gamma)$)),
  ),
))

// Figure 130 (printed a second time as «Рис. 129»): the sheets Γ₁ and Γ₂
// of w = ±√P_n(z) over a neighbourhood of ∞ for even n, in a section: they
// touch at ∞ (two points brought together), over the point ∞ of S²; the
// sheets go on beyond the section (broken ends). Below, for contrast, a
// conical point, where two cones meet at their common apex.
#let fig-4-130() = lettered-drawing({
  import cetz.draw: *
  let bold = 1mm
  let broken = (
    stroke: (thickness: bold, cap: "butt", dash: (array: (1.5mm, 0.5mm))),
  )
  // A sheet: level at `level`, bent by `bend` at 0 over the half-width
  // `reach`; solid from `from` to `to`, broken out to `ends`.
  let reach = 9.7
  let sheet(level, bend) = x => (
    x,
    level
      + if calc.abs(x) < reach {
        bend * (1 + calc.cos(180deg * x / reach)) / 2
      } else { 0 },
  )
  let (ends, from, to) = ((-43.18, 35.73), -29.46, 23.88)
  for (level, bend, sheet-name, branch, side) in (
    (7.79, -6.6, $Gamma_2$, $phi_2$, "north"),
    (-8.3, 7.2, $Gamma_1$, $phi_1$, "south"),
  ) {
    let f = sheet(level, bend)
    line(f(ends.at(0)), f(from), ..broken)
    line(..sample(f, from, to, n: 120), stroke: (thickness: bold, cap: "butt"))
    line(f(to), f(ends.at(1)), ..broken)
    for x in (-25.0, 20.0) {
      content(f(x), sheet-name, anchor: side, padding: 1.4)
    }
    content(f(ends.at(0)), branch, anchor: "east", padding: 1)
    content(f(ends.at(1)), branch, anchor: "west", padding: 1)
    let tip = f(0)
    circle(tip, radius: 0.75, fill: white, stroke: 0.8pt)
    content(
      tip,
      $infinity$,
      anchor: if bend < 0 { "south" } else { "north" },
      padding: 1.4,
    )
  }
  content((3.5, 0), anchor: "west", emph[Касание двух листов])
  // The sphere S² below, its point ∞.
  let base = -17.61
  line((0, -8.3 + 7.2 - 2.4), (0, base), ..fine-dash)
  line((-35.81, base), (34.88, base), stroke: (
    thickness: bold,
    cap: "butt",
    dash: (array: (3mm, 0.5mm)),
  ))
  circle((0, base), radius: 0.55, fill: white, stroke: none)
  content((0, base), $infinity$, anchor: "south-west", padding: 1)

  // The conical point: two cones meeting at their common apex, drawn
  // with its lower left corner at the point given.
  book-picture(
    "/assets/figures/04-130-conical-point.svg",
    60.11,
    labels: (
      (
        (28.4, 6.3),
        std.grid(
          align: center,
          row-gutter: 0.7mm,
          emph[Коническая],
          emph[точка],
        ),
      ),
    ),
    corner: (-32.39, -50.42),
  )
})

// Figure 131: the branch points a₁, …, a_n and a_(n+1) = ∞ joined in pairs
// by cuts; a closed path γ from 0 that goes round the pairs
// (a_(i₁), a_(i₁+1)), …, (a_(i_α), a_(i_α+1)) inside it and crosses no cut.
#let fig-4-131() = lettered-drawing(book-picture(
  "/assets/figures/04-131-cuts-and-contour.svg",
  102.95,
  labels: (
    ((5.7, 6.1), cutout($a_1$)),
    ((15.6, 11.2), $a_2$),
    ((38.2, 19.2), cutout($a_(i_1)$)),
    ((46.5, 19.7), cutout($a_(i_1 + 1)$)),
    ((51.5, 26.4), cutout($a_(i_alpha)$)),
    ((60.1, 25.3), cutout($a_(i_alpha + 1)$), "south"),
    ((61.4, 13.0), $gamma$),
    ((52.8, 2.0), $0$),
    ((86.2, 10.8), $a_n$),
    ((101.0, 10.3), $infinity$),
    ((98.3, 3.7), $a_(n + 1)$),
  ),
))

// Figure 132: n = 2p + 1. 1) The sheets Γ₁ and Γ₂, each the sphere cut
// along γ₁, …, γ_(p+1) joining the branch points in pairs, the edges γ⁺,
// γ⁻ of every cut marked; 2) the cuts opened into tubes; 3) the tubes of
// one sheet glued to those of the other; 4) the result, a sphere with p
// handles (here two), flattened; 5) the same drawn as a sphere with
// handles.
#let fig-4-132() = lettered-drawing(book-picture(
  "/assets/figures/04-132-odd-degree-gluing.svg",
  99.14,
  labels: (
    ((39.5, 99.4), $Gamma_1$),
    ((12.4, 96.6), $a_1$),
    ((23.3, 95.5), $a_(2k - 1)$),
    ((34.9, 95.9), $a_n$),
    ((5.3, 86.4), rotate(-90deg, reflow: true, $gamma_(1(1))^+$)),
    ((11.9, 87.3), $gamma_(1(1))^-$, "west"),
    ((24.8, 87.7), $gamma_(k(1))^-$, "west"),
    ((34.7, 80.7), $gamma_((p+1)(1))^+$, "east"),
    ((40.4, 85.6), rotate(-90deg, reflow: true, $gamma_((p+1)(1))^-$)),
    ((19.9, 78.6), $gamma_(k(1))^+$, "east"),
    ((8.3, 76.7), $a_2$),
    ((22.7, 71.4), $a_(2k)$),
    ((33.6, 74.9), $infinity = a_(n + 1)$),
    ((48.3, 82.7), part-number(1)),
    ((89.3, 101.8), $Gamma_2$),
    ((66.2, 97.0), $a_1$),
    ((76.1, 94.9), $a_(2k - 1)$),
    ((86.4, 97.5), $a_n$),
    ((65.2, 91.0), $gamma_(1(2))^-$, "west"),
    ((77.9, 87.7), $gamma_(k(2))^-$, "west"),
    ((57.6, 83.1), rotate(-90deg, reflow: true, $gamma_(1(2))^+$)),
    ((71.3, 80.7), $gamma_(k(2))^+$, "east"),
    ((88.4, 80.9), $gamma_((p+1)(2))^+$, "east"),
    ((93.2, 83.9), rotate(-90deg, reflow: true, $gamma_((p+1)(2))^-$)),
    ((60.8, 75.4), $a_2$),
    ((74.4, 70.4), $a_(2k)$),
    ((88.2, 74.1), rotate(-34deg, reflow: true, $infinity = a_(n + 1)$)),
    ((10.1, 58.1), $Gamma_1$),
    ((39.3, 57.3), $Gamma_2$),
    ((48.7, 53.3), part-number(2)),
    ((87.2, 56.0), part-number(3)),
    ((28.4, 26.5), part-number(4)),
    ((81.2, 27.3), part-number(5)),
  ),
))

// Figure 133: n = 2p. 1) The sheets Γ₁ and Γ₂, each the sphere cut along
// the arcs joining a₁, …, a_(2p) in pairs, with its own point ∞; 2) the
// cuts opened, the halves joined at ∞; 3) the tubes glued; 4) the result
// flattened, its two points ∞ brought together; 5) the same as a sphere
// with handles, pinched at ∞.
#let fig-4-133() = lettered-drawing(book-picture(
  "/assets/figures/04-133-even-degree-gluing.svg",
  102.45,
  labels: (
    ((16.6, 83.1), $Gamma_1$),
    ((50.0, 83.3), $Gamma_2$),
    ((28.6, 78.8), part-number(1)),
    ((79.8, 83.5), part-number(2)),
    ((35.3, 47.5), part-number(3)),
    ((56.0, 40.4), part-number(4)),
    ((85.6, 31.9), part-number(5)),
    ((7.1, 76.9), $a_1$, "south-west"),
    ((16.4, 78.5), $a_(2p - 1)$),
    ((13.1, 75.3), $a_(2k - 1)$),
    ((6.2, 58.7), $a_2$),
    ((12.7, 58.3), $a_(2k)$, "north-east"),
    ((18.9, 58.3), $infinity$, "north"),
    ((21.3, 62.3), $a_(2p)$, "east"),
    ((41.0, 78.4), $a_1$),
    ((49.4, 79.0), $a_(2p - 1)$),
    ((46.1, 74.2), $a_(2k - 1)$, "south"),
    ((38.4, 59.1), $a_2$),
    ((45.3, 56.7), $a_(2k)$, "east"),
    ((52.2, 59.2), $infinity$, "north"),
    ((54.1, 63.7), $a_(2p)$, "east"),
    ((82.8, 42.4), $infinity$, "north"),
    ((20.6, 13.1), $infinity$, "north"),
    ((57.1, 22.1), $infinity$, "north"),
    ((84.1, -0.3), $infinity$, "north"),
  ),
))
// Figure 134: a scheme of the way round a branch point of w² − P₆(z) = 0.
//
// Above, in perspective (the depth v counted from the plane of the cuts):
// the plane ℂ¹(z) as a slab with the w-axis at its far left corner, and
// the Riemann surface Γ for the real roots a₁ < … < a₆ of P₆, cut along
// [a₁, a₂], [a₃, a₄], [a₅, a₆]. Γ is a closed surface of genus 2 standing
// on the line of the cuts: its outline a band over [a₁, a₆] with
// superelliptic ends, the sheet Γ₁ above the equator and Γ₂ below it, two
// holes over the gaps between the cuts (the circles on the gaps as
// diameters). Over each cut the sheets meet along the equator, the ellipse
// in the horizontal plane with the cut as its axis and the half-depth of
// the surface; the verticals stand over the ends of the cuts. The way round
// goes once about a₂ on the circle through the middle z₀ of the next gap.
// Its lift runs from the point of Γ₁ over z₀ (on top) down the front,
// across the equator over a₂ − r, where the way round crosses the cut, to
// the point of Γ₂ over z₀ (at the bottom); the second turn comes back
// behind across the equator over a₂ − r/3, so that the halves stay apart.
// Each half is a parabola in the plane of the cuts, its depth growing as
// on an ellipse from the outline to the equator.
//
// Below left: the way round 0 in the plane z. Below right: Γ near the
// branch point in the uniformizing parameter w = u + iv, z = w²: the
// graph of Re z = u² − v² (times `rise`) over the square |u|, |v| ≤ 1,
// seen orthographically; the branch point is its saddle point. The line of
// sight t from a point of this quadric meets it again at the distance
// (n · t)/b, n the upward normal, b = rise (t_u² − t_v²) < 0: the part in
// front of the fold n · t = 0 is all seen (stippled); behind the fold the
// underside shows (black) where the second meeting falls outside the
// square. The way round lifts to the half-turn of |w| = r from −r through
// the front valley to r (bold); the second turn passes behind the fold
// (dashed where hidden); the cut z ≤ 0 lifts to the valley u = 0. The disc
// |w| < r swept by the lift is white.
#let fig-4-134() = lettered-drawing({
  import cetz.draw: *
  let medium = 0.9pt
  let bold-dash = (thickness: 0.45mm, dash: (array: (1.6mm, 0.8mm)))

  // Above. The view; the slab from x = 4.8 to 98.0, from 26.5 in front of
  // the cuts to 19.4 behind them, 5.3 deep; the roots a₁, …, a₆.
  let at = plane-perspective((55.5, 208.8), 65.2, 326.5)
  let (slab-left, slab-right, slab-front, slab-back) = (4.8, 98.0, -26.5, 19.4)
  let slab-depth = 5.3
  let branch = (10.8, 26.4, 41.4, 56.5, 70.7, 87.9)
  let cuts = range(3).map(i => branch.slice(2 * i, 2 * i + 2))
  let gaps = range(2).map(i => branch.slice(2 * i + 1, 2 * i + 3))
  // The surface: the height of its equator, its half-height, the width and
  // the exponent of its ends, its half-depth.
  let (equator, half-height, end, roundness, depth) = (37.4, 19, 10, 2.5, 6.5)
  // The way round a₂: the circle through the middle z₀ of the next gap.
  let around = branch.at(1)
  let radius = (branch.at(2) - branch.at(1)) / 2
  let start = around + radius

  let signed-power(x, p) = if x < 0 { -calc.pow(-x, p) } else {
    calc.pow(x, p)
  }
  let end-point(centre, t) = (
    centre + end * signed-power(calc.cos(t), 2 / roundness),
    0,
    equator + half-height * signed-power(calc.sin(t), 2 / roundness),
  )
  let outline = (
    ..sample(t => end-point(branch.last() - end, t), -90deg, 90deg, n: 60),
    ..sample(t => end-point(branch.first() + end, t), 90deg, 270deg, n: 60),
  ).map(at)
  // The height of the lower edge of the outline over x.
  let lower-edge(x) = {
    let e = calc.min(1, calc.max(
      0,
      (branch.first() + end - x) / end,
      (x - branch.last() + end) / end,
    ))
    equator - half-height * calc.pow(1 - calc.pow(e, roundness), 1 / roundness)
  }
  // The half-depth of the surface on the equator over the cut (p, q).
  let depth-over((p, q), x) = (
    depth * calc.sqrt(1 - calc.pow((2 * x - p - q) / (q - p), 2))
  )
  let equator-ring((p, q), t) = at((
    (p + q) / 2 + (q - p) / 2 * calc.cos(t),
    depth * calc.sin(t),
    equator,
  ))
  // A half of the lift: from the top over z₀ across the equator over x,
  // on the side `side` (−1 in front, 1 behind), to the bottom.
  let lift-half(x, side) = sample(
    s => at((
      start - (start - x) * (1 - s * s),
      side * depth-over(cuts.first(), x) * calc.sqrt(1 - s * s),
      equator + half-height * s,
    )),
    1,
    -1,
    n: 60,
  )
  let way-round(t) = at((
    around + radius * calc.cos(t),
    radius * calc.sin(t),
    0,
  ))
  let foot(x) = at((x, 0, 0))

  // The slab: the black front, the stippled top.
  let face(v, w) = (
    at((slab-left, v, w)),
    at((slab-right, v, w)),
  )
  line(
    ..face(slab-front, 0),
    ..face(slab-front, -slab-depth).rev(),
    close: true,
    fill: black,
    stroke: thick-line,
  )
  let back-edge = face(slab-back, 0)
  line(
    ..face(slab-front, 0),
    ..back-edge.rev(),
    close: true,
    fill: stipple,
    stroke: thick-line,
  )
  // On the plane: the names, the way round, the cuts.
  for place in ((9.9, 63.5), (47.3, 62.9), (78.0, 62.4)) {
    content(place, cutout(emph[Разрез]))
  }
  content((23.6, 60.5), cutout(emph[Обход]))
  line(..sample(way-round, 0deg, 360deg, n: 120), close: true, stroke: medium)
  for (p, q) in cuts {
    line(foot(p), foot(q), stroke: (thickness: 0.85mm, cap: "butt"))
  }

  // The surface: stippled, the holes cut out.
  line(..outline, close: true, fill: stipple, stroke: medium)
  for (p, q) in gaps {
    circle(at(((p + q) / 2, 0, equator)), radius: (q - p) / 2, fill: white)
  }
  for (p, q) in cuts {
    line(
      ..sample(t => equator-ring((p, q), t), 0deg, 180deg, n: 40),
      stroke: (..hidden.stroke, thickness: medium),
    )
  }
  // The verticals over the ends of the cuts: hidden behind Γ₂, then over
  // the plane, parting its far edge and the way round where they cross it.
  let far-y = back-edge.first().at(1)
  let behind = sample(way-round, 0deg, 180deg, n: 180)
  for x in branch {
    let low = at((x, 0, lower-edge(x)))
    line(at((x, 0, equator)), low, ..hidden)
    let crossings = (far-y,)
    if calc.abs(x - around) < radius {
      crossings.push(
        behind.sorted(key: p => calc.abs(p.at(0) - x)).first().at(1),
      )
    }
    for y in crossings { bridge(((x, y + 1), (x, y - 1))) }
    line(low, foot(x))
  }
  mark(
    way-round(114deg),
    way-round(118deg),
    symbol: "stealth",
    length: 2mm,
    width: 1.1mm,
    inset: 0.6mm,
  )
  // The lift: the hidden half behind, the bold half in front, the vertical
  // through its ends down to z₀.
  let (top, bottom) = (
    at((start, 0, equator + half-height)),
    at((start, 0, equator - half-height)),
  )
  line(top, foot(start), ..hidden)
  let (front-x, back-x) = (around - radius, around - radius / 3)
  line(..lift-half(back-x, 1), stroke: bold-dash)
  for (p, q) in cuts {
    let ring = sample(t => equator-ring((p, q), t), 180deg, 360deg, n: 40)
    brush-stroke(ring, u => 0.3 + 0.6 * calc.sin(u * 180deg))
  }
  line(..lift-half(front-x, -1), stroke: (thickness: 0.7mm))
  for x in branch { spot(foot(x), radius: 0.9) }
  spot(foot(start), radius: 0.9)
  spot(top, radius: 1.1)
  spot(bottom, radius: 1.1)
  for (x, side) in ((front-x, -1), (back-x, 1)) {
    spot(
      at((x, side * depth-over(cuts.first(), x), equator)),
      radius: if side < 0 { 1.0 } else { 0.55 },
    )
  }
  // The w-axis from the far left corner of the plane.
  let corner = back-edge.first()
  arrowed(corner, (corner.at(0), 132.6), name: "axis")
  spot(corner, radius: 0.5)
  content("axis.end", $w$, anchor: "west", padding: 0.9)
  content((corner.at(0), 117.3), $CC^1 (w)$, anchor: "east", padding: 1)
  content(
    at((53.1, 0, equator + half-height)),
    $w^2 - P_6 (z) = 0$,
    anchor: "south",
    padding: 1.8,
  )
  content((55.1, 118.1), cutout[_Лист_ $Gamma_1$])
  content((48.8, 89.9), cutout[_Лист_ $Gamma_2$])
  content((78.5, 75.1), $CC^1 (z)$)
  content((98.7, 69.3), $z$)

  // Below left: the way round 0, counterclockwise.
  let (disc-centre, disc-radius) = ((11.2, 9.35), 9.0)
  circle(disc-centre, radius: disc-radius, fill: stipple, stroke: thick-line)
  for t in (140deg, -40deg) {
    mark(
      (rel: (t - 2deg, disc-radius), to: disc-centre),
      (rel: (t, disc-radius), to: disc-centre),
      symbol: "stealth",
    )
  }
  spot(disc-centre, radius: 0.8)
  content(disc-centre, cutout($0$), anchor: "north", padding: 1.3)
  content((8.7, -0.8), emph[Обход])

  // Below right: the saddle. The view, the rise of the graph, the radius of
  // the lift.
  let view = orthographic(-22deg, 18.5deg)
  let (rise, lift-radius) = (0.6, 0.72)
  let (tu, tv, tz) = view.toward
  let bend = rise * (tu * tu - tv * tv)
  assert(bend < 0, message: "the fold must be seen")
  // n · t at the point over w: the upper side faces the viewer where it is
  // positive. The line of sight meets the graph again `reach` further on;
  // the point is seen unless that is inside the square.
  let upper-facing((u, v)) = -2 * rise * u * tu + 2 * rise * v * tv + tz
  let seen((u, v)) = {
    let reach = upper-facing((u, v)) / bend
    let (u2, v2) = (u + reach * tu, v + reach * tv)
    reach <= 0 or calc.abs(u2) > 1 or calc.abs(v2) > 1
  }
  let graph((u, v)) = (view.project)((u, v, rise * (u * u - v * v)))
  let square = (
    (s => (s, -1)),
    (s => (1, s)),
    (s => (-s, 1)),
    (s => (-1, -s)),
  )
    .map(edge => sample(edge, -1, 1, n: 100).slice(0, -1))
    .join()
  // The graph fills the printed box, its corners (28, 3) and (94, 44).
  let box = ((28, 94), (3, 44))
  let spans = range(2).map(i => {
    let values = square.map(p => graph(p).at(i))
    (calc.min(..values), calc.max(..values))
  })
  let size((low, high)) = high - low
  let scale = calc.min(..box.zip(spans).map(((b, s)) => size(b) / size(s)))
  let shift = box.zip(spans).map(((b, s)) => (b.sum() - scale * s.sum()) / 2)
  let on-page(p) = graph(p).zip(shift).map(((c, s)) => s + scale * c)
  let ring(t) = (lift-radius * calc.cos(t), lift-radius * calc.sin(t))
  assert(upper-facing(ring(180deg)) > 0, message: "the lift starts in sight")

  let front = polygon-part-where(square, upper-facing)
  let back = polygon-part-where(square, p => -upper-facing(p))
  let disc = polygon-part-where(
    sample(ring, 0deg, 360deg, n: 144).slice(0, -1),
    upper-facing,
  )
  line(..back.map(on-page), close: true, fill: black, stroke: none)
  line(..front.map(on-page), close: true, fill: white, stroke: none)
  line(..front.map(on-page), close: true, fill: stipple, stroke: none)
  line(..disc.map(on-page), close: true, fill: white, stroke: none)
  // The rim, its left edge with the white strokes of a cut sheet where it
  // borders the underside; the fold.
  let rim = square + (square.first(),)
  let left-edge = sample(s => (-1, -s), -1, 1, n: 100)
  for run in runs-where(left-edge, seen) {
    line(..run.map(on-page), stroke: (
      paint: white,
      thickness: 1.3mm,
      cap: "butt",
      dash: (array: (0.14mm, 0.26mm)),
    ))
  }
  for run in runs-where(rim, seen) {
    line(..run.map(on-page), stroke: thick-line)
  }
  let fold = front
    .filter(p => calc.abs(upper-facing(p)) < 1e-9)
    .sorted(key: p => p.at(0))
  line(..fold.map(on-page))
  // The valley u = 0 up to the fold, the lift of the cut.
  let valley-top = -tz / (2 * rise * tv)
  line(
    ..sample(v => on-page((0, v)), -1, valley-top, n: 60),
    stroke: medium,
  )
  // The second turn behind, the lift with its arrow, the points.
  group({
    set-style(stroke: (thickness: medium))
    seen-hidden(on-page, seen, sample(ring, 0deg, 180deg, n: 180))
  })
  let lift = sample(t => on-page(ring(t)), 180deg, 360deg, n: 120)
  line(..lift, stroke: (thickness: 0.75mm))
  mark(
    lift.at(99),
    lift.at(102),
    symbol: "stealth",
    length: 3.8mm,
    width: 2.8mm,
    inset: 1.2mm,
  )
  spot(on-page((0, 0)), radius: 1.1)
  spot(lift.first(), radius: 0.85)
  spot(lift.last(), radius: 0.85)
})
