// Figures of chapter 3, § 3. Each is a function called by the text:
// `#fig(fig-3-7()) <fig:…>`.
#import "common.typ": *

// Figure 7: a curve x⃗(t) in space and its tangent line y⃗(t) at
// P₀ = x⃗(t₀), the axes x, y, z in an oblique view. The curve is two cubic
// arcs from its ends that leave P₀ along the tangent, so that the line
// touches it there.
#let fig-3-7() = slim-drawing({
  import cetz.draw: *
  arrowed((0, 0), (0, 29.34), name: "z")
  arrowed((0, 0), (12.70, 4.66), name: "y")
  arrowed((0, 0), (25.95, -4.95), name: "x")
  let p0 = (17.57, 22.35)
  let tangent = 56.4deg
  let along(distance) = (rel: (tangent, distance), to: p0)
  line(along(-16.97), along(12.26), name: "tangent")
  // The ends of the curve and its directions there, towards P₀.
  let (start, start-turn) = ((4.95, 13.04), 55deg)
  let (end, end-turn) = ((17.91, 31.45), 102deg)
  bezier(
    start,
    p0,
    (rel: (start-turn, 7), to: start),
    along(-4),
    stroke: thick-line,
    name: "lower",
  )
  bezier(
    p0,
    end,
    along(3),
    (rel: (end-turn, -3), to: end),
    stroke: thick-line,
    name: "upper",
  )
  spot(p0)
  content("z.end", $z$, anchor: "west")
  content("y.end", $y$, anchor: "north")
  content("x.end", $x$, anchor: "north-east")
  content("upper.50%", $P_0 = arrow(x)(t_0)$, anchor: "east")
  content("lower.65%", $arrow(x) = arrow(x)(t)$, anchor: "south-east")
  content("tangent.33%", $arrow(y) = arrow(y)(t)$, anchor: "west")
})

// Figure 8: the tangent plane Π of a surface M at P₀ = x⃗(u₀, v₀), the
// axes x, y, z in an oblique view. Π is the parallelogram of the points
// P₀ + a ∂x⃗/∂u + b ∂x⃗/∂v; the tangent vector ξ⃗ = s ∂x⃗/∂u + t ∂x⃗/∂v is
// the diagonal of the dashed parallelogram on the two vectors. M is a
// free-hand patch: its four bold sides are smooth curves through a few
// points taken once from the book. The axes and ξ⃗ carry their heads a
// little short of their ends.
#let fig-3-8() = slim-drawing({
  import cetz.draw: *
  let p0 = (7.22, 27.06)
  let (along-u, along-v) = ((10.79, 0), (4.55, 8.92))
  let (s, t) = (1.274, 1.77)
  let plane(a, b) = (
    p0.at(0) + a * along-u.at(0) + b * along-v.at(0),
    p0.at(1) + a * along-u.at(1) + b * along-v.at(1),
  )
  let short-head(back) = (end: "stealth", offset: back, shorten-to: none)
  line((0, 0), (0, 45.68), mark: short-head(1.7), name: "z")
  line((0, 0), (17.74, 5.18), mark: short-head(1.7), name: "y")
  line((0, 0), (24.11, -2.91), mark: short-head(1.7), name: "x")
  let (a0, a1, b0, b1) = (-1.30, 0.72, -1.78, 1.27)
  line(plane(a0, b0), plane(a1, b0), plane(a1, b1), plane(a0, b1), close: true)
  // The patch M from its left corner round to its right one.
  let (left, bottom, right, corner) = (
    (-6.51, 24.22),
    (9.49, 7.99),
    (27.97, 26.35),
    (21.56, 10.81),
  )
  let edge = (stroke: thick-line)
  hobby(
    left,
    (-3.36, 26.80),
    (5.26, 31.48),
    (13.49, 32.94),
    (22.97, 30.09),
    right,
    ..edge,
  )
  hobby(
    left,
    (-2.64, 23.42),
    (1.78, 21.36),
    (5.65, 17.17),
    (8.03, 12.97),
    bottom,
    ..edge,
  )
  hobby(bottom, (12.93, 10.58), (16.30, 11.38), corner, ..edge)
  hobby(corner, (21.90, 17.38), (23.37, 21.63), (25.29, 23.77), right, ..edge)
  // The tangent vectors and the parallelogram of their sum.
  arrowed(p0, plane(1, 0), name: "u")
  arrowed(p0, plane(0, 1), name: "v")
  line(plane(1, 0), plane(s, 0), ..fine-dash)
  line(plane(0, 1), plane(0, t), ..hidden)
  line(plane(s, 0), plane(s, t), plane(0, t), ..hidden)
  line(p0, plane(s, t), mark: short-head(3.7))
  spot(p0)
  // The derivatives in display style, smaller, as printed.
  let derivative(by) = text(
    size: 7pt,
    $display((partial arrow(x))/(partial by))$,
  )
  content("u.end", derivative($u$), anchor: "north")
  content("v.50%", cutout(derivative($v$)), anchor: "south-east")
  content(plane(s, t), $arrow(xi)$, anchor: "north-west")
  content(p0, $P_0$, anchor: "north-east")
  content(left, $M$, anchor: "north-west")
  content(plane(-0.97, -1.51), $Pi$)
  content("z.end", $z$, anchor: "north-west")
  content("y.end", $y$, anchor: "north-west")
  content("x.end", $x$, anchor: "north-east")
})

// Figure 9: the class of curves tangent at P₀ to a vector of M: the
// parabolas s ↦ P₀ + s τ⃗ + k s² ν⃗ (τ⃗ along the vector, ν⃗ normal to it)
// with k = ±c, ±2c, each drawn until it stands `spread` off the tangent.
// The piece of M is a free-hand patch: its four sides are smooth curves
// through a few points taken once from the book.
#let fig-3-9() = slim-drawing({
  import cetz.draw: *
  let (left, bottom-left, bottom-right, right) = (
    (-15.54, 3.85),
    (-12.70, -12.15),
    (6.14, -11.90),
    (18.50, -1.02),
  )
  hobby(
    left,
    (-12.06, 6.35),
    (-5.71, 9.65),
    (0.64, 11.09),
    (6.99, 9.99),
    (13.34, 5.67),
    right,
  )
  hobby(left, (-13.76, 0.04), (-12.19, -4.19), (-12.36, -10.12), bottom-left)
  hobby(
    bottom-left,
    (-7.83, -10.46),
    (-3.17, -9.99),
    (1.91, -10.54),
    bottom-right,
  )
  hobby(bottom-right, (7.28, -9.27), (10.75, -5.04), (14.18, -3.13), right)
  let (turn, length) = (45.45deg, 18.6)
  let (c, spread) = (0.085, 1.3)
  let (tx, ty) = (calc.cos(turn), calc.sin(turn))
  for k in (-2 * c, -c, c, 2 * c) {
    let reach = calc.sqrt(spread / calc.abs(k))
    line(..sample(
      s => (s * tx - k * s * s * ty, s * ty + k * s * s * tx),
      -reach,
      reach,
      n: 40,
    ))
  }
  arrowed((0, 0), (turn, length))
  // The point is marked smaller than usual, as printed.
  spot((0, 0), radius: 0.45)
  content((0, 0), $P_0$, anchor: "north-west")
})

// Figure 10: the derivative of f along ξ⃗ = (ξ¹, ξ²) at P₀ by a curve γ
// through P₀, the axes in an oblique view. The surface is the graph of
// f(x, y) = f₀ + f_x u + f_y v + a u² + b u v + c v² (u = x − x₀,
// v = y − y₀) over a strip that ends over the points P₀ + ξ¹ and
// P₀ + ξ⃗; its tangent plane at the lift of P₀ carries the lifts of
// ξ¹, ξ² and ξ⃗, which make the angle φ with ξ⃗ moved up to that height.
// Dashed: the parallelograms of ξ⃗ in the base and at the height of the
// lift, and the verticals over their corners. The curve γ leaves P₀
// along ξ⃗ and bends aside by a smooth step; its lift lies on the graph.
#let fig-3-10() = slim-drawing({
  import cetz.draw: *
  let at = projection((0.9853, -0.1708), (0.7585, 0.6518), (0, 1))
  let (x0, y0) = (5.19, 5.26)
  let (xi1, xi2) = (23.0, 12.0)
  let (f0, fx, fy) = (19.47, 0.377, 0.335)
  let (a, b, c) = (-0.0104, -0.00364, -0.0151)
  let f(u, v) = f0 + fx * u + fy * v + a * u * u + b * u * v + c * v * v
  let lifted(u, v, h) = at((x0 + u, y0 + v, h))
  let base(u, v) = lifted(u, v, 0)
  let level(u, v) = lifted(u, v, f0)
  let tangent(u, v) = lifted(u, v, f0 + fx * u + fy * v)
  let graph(u, v) = lifted(u, v, f(u, v))
  arrowed((0, 0), (0, 40.4), name: "z")
  arrowed((0, 0), at((0, 17.86, 0)), name: "y")
  arrowed((0, 0), at((16.11, 0, 0)), name: "x")
  // The patch of the graph over the strip from u = −4.30 (v = 0) and
  // u = −6.87 (v = ξ²) to u = ξ¹.
  let edge(point) = line(..sample(point, 0, 1, n: 60), stroke: thick-line)
  edge(t => graph(-4.30 + (xi1 + 4.30) * t, 0))
  edge(t => graph(-6.87 + (xi1 + 6.87) * t, xi2))
  edge(t => graph(-4.30 - 2.57 * t, xi2 * t))
  edge(t => graph(xi1, xi2 * t))
  // The parallelograms of ξ⃗ and the verticals over their corners.
  let dashed-arrow = (mark: (end: "stealth", stroke: (dash: none)), ..hidden)
  line(base(0, 0), base(xi1, 0), ..dashed-arrow)
  line(base(0, 0), base(0, xi2), ..dashed-arrow)
  line(base(xi1, 0), base(xi1, xi2), base(0, xi2), ..hidden)
  line(level(xi1, 0), level(0, 0), level(0, xi2), ..hidden)
  line(level(xi1, 0), level(xi1, xi2), level(0, xi2), ..hidden)
  line(tangent(xi1, 0), tangent(xi1, xi2), tangent(0, xi2), ..hidden)
  line(base(0, 0), level(0, 0), ..hidden)
  line(base(0, xi2), level(0, xi2), ..hidden)
  line(base(xi1, 0), tangent(xi1, 0), ..hidden)
  line(base(xi1, xi2), tangent(xi1, xi2), ..hidden)
  // ξ⃗ in the base and at the level of the lift; the lifted vectors.
  arrowed(base(0, 0), base(xi1, xi2))
  arrowed(level(0, 0), level(xi1, xi2))
  arrowed(tangent(0, 0), tangent(xi1, 0))
  arrowed(tangent(0, 0), tangent(0, xi2))
  arrowed(tangent(0, 0), tangent(xi1, xi2))
  // γ by its arc length s along ξ⃗ and its step aside, arriving at P₀,
  // and its lift.
  let norm = calc.sqrt(xi1 * xi1 + xi2 * xi2)
  let (step, reach, last) = (2, 11, 16.2)
  let gamma(s) = {
    let d = calc.min(s / reach, 1)
    let aside = -step * d * d * (3 - 2 * d)
    ((s * xi1 - aside * xi2) / norm, (s * xi2 + aside * xi1) / norm)
  }
  for point in (base, graph) {
    line(
      ..sample(s => point(..gamma(s)), last, 0, n: 80),
      mark: (end: "stealth"),
    )
  }
  cetz.angle.angle(
    level(0, 0),
    level(xi1, xi2),
    tangent(xi1, xi2),
    radius: 18.6,
    label-radius: 20.8,
    label: $phi$,
    mark: (start: "stealth", end: "stealth"),
  )
  content(
    (tangent(0, xi2), 25%, tangent(xi1, xi2)),
    $phi$,
    anchor: "south",
  )
  content("z.end", $z$, anchor: "north-west")
  content("y.end", $y$, anchor: "south-east")
  content("x.end", $x$, anchor: "north-east")
  content(base(0, 0), $P_0$, anchor: "east")
  content(base(xi1, 0), $xi^1$, anchor: "north")
  content(base(0, xi2), $xi^2$, anchor: "north")
  content(base(xi1, xi2), $arrow(xi)$, anchor: "north-east")
})

// Figure 11: the circle S¹ with its tangent lines at P₀ and Q₀ (at the
// polar angles `at-p`, `at-q`); the tangent vectors ξ at P₀ and μ at Q₀
// end where the two tangents meet, on the bisector of the angle P₀OQ₀.
#let fig-3-11() = slim-drawing({
  import cetz.draw: *
  let (centre, radius) = ((13.57, 16.22), 11.18)
  let (at-p, at-q) = (-15.6deg, 53deg)
  let p0 = (rel: (at-p, radius), to: centre)
  let q0 = (rel: (at-q, radius), to: centre)
  let half = (at-q - at-p) / 2
  let meet = (rel: (at-p + half, radius / calc.cos(half)), to: centre)
  arrowed((0, 0), (0, 33.57), name: "y")
  arrowed((0, 0), (27.16, 0), name: "x")
  circle(centre, radius: radius, stroke: thick-line)
  // The tangent lines, each from its far end beyond the point to its
  // near end beyond the meeting point.
  line(
    (rel: (at-p - 90deg, 10.21), to: p0),
    (rel: (at-p + 90deg, 15.73), to: p0),
    name: "tangent-p",
  )
  line(
    (rel: (at-q + 90deg, 14.70), to: q0),
    (rel: (at-q - 90deg, 12.01), to: q0),
    name: "tangent-q",
  )
  arrowed(p0, meet, name: "xi")
  arrowed(q0, meet, name: "mu")
  // The points are marked smaller than usual, as printed.
  spot(p0, radius: 0.5)
  spot(q0, radius: 0.5)
  content("y.end", $y$, anchor: "north-west")
  content("x.end", $x$, anchor: "north-east")
  content(p0, $P_0$, anchor: "south-east")
  content(q0, $Q_0$, anchor: "north-east")
  content("xi.55%", $xi$, anchor: "west")
  content("mu.40%", $mu$, anchor: "south-west")
  content("tangent-p.8%", $T_(P_0)(S^1)$, anchor: "west")
  content("tangent-q.13%", $T_(Q_0)(S^1)$, anchor: "south-west")
})

// Figure 12: the tangent lines of the circle S¹ (the waist, radius `waist`)
// turned out of the plane (x, y) about their radii by the angle φ sweep
// the one-sheeted hyperboloid x² + y² = a²(1 + z²/c²), c = a tg φ, drawn
// between the rims z = ±h of radius `rim`, which fix φ. The turned lines
// through P₀ and Q₀ (ξ and μ), the tangent lines they come from (dashed)
// and the angles φ between them; the arc P₀Q₀ of the waist bold. Seen
// orthographically from the front and above; hidden lines dashed. The
// axes stand apart, without names, as printed.
#let fig-3-12() = slim-drawing({
  import cetz.draw: *
  let view = orthographic(0deg, 18.7deg)
  let centre = (14.24, 5.42)
  let at(p) = {
    let (u, v) = (view.project)(p)
    (u + centre.at(0), v + centre.at(1))
  }
  let (waist, rim, h) = (4.15, 10.07, 11.9)
  let c = waist * h / calc.sqrt(rim * rim - waist * waist)
  let tilt = calc.atan(c / waist)
  let k = waist * waist / (c * c)
  let (_, ty, tz) = view.toward
  // The point of the surface at height z and polar angle `turn`; its
  // outer side at p faces the viewer.
  let surface(z, turn) = {
    let r = waist * calc.sqrt(1 + z * z / (c * c))
    (r * calc.cos(turn), r * calc.sin(turn), z)
  }
  let seen((x, y, z)) = y * ty - k * z * tz > 0
  arrowed((0, 0), (0, 25.44))
  arrowed((0, 0), (6.79, 4.02))
  arrowed((0, 0), (5.95, -1.06))
  // The rims, the waist and the contour, where the normal of the surface
  // is at a right angle to the line of sight.
  line(..sample(t => at(surface(h, t)), 0deg, 360deg, n: 120), close: true)
  for z in (-h, 0) {
    seen-hidden(at, seen, sample(t => surface(z, t), -90deg, 270deg, n: 160))
  }
  for side in (-1, 1) {
    line(..sample(
      z => {
        let y = k * z * tz / ty
        let r = waist * calc.sqrt(1 + z * z / (c * c))
        at((side * calc.sqrt(r * r - y * y), y, z))
      },
      -h,
      h,
      n: 80,
    ))
  }
  // Through P₀ and Q₀: the turned line, its upper half named, and the
  // tangent line from `back` to `front` along its direction.
  let (at-p, at-q) = (-111.5deg, -58.7deg)
  line(
    ..sample(t => at(surface(0, t)), at-p, at-q, n: 30),
    stroke: thick-line,
  )
  let reach = h / calc.sin(tilt)
  let named = ()
  for (turn, back, front) in ((at-p, -8.6, 8.2), (at-q, -5.7, 8.6)) {
    let (x, y, _) = surface(0, turn)
    let across = (-calc.sin(turn), calc.cos(turn), 0)
    let rising = (
      -calc.sin(turn) * calc.cos(tilt),
      calc.cos(turn) * calc.cos(tilt),
      calc.sin(tilt),
    )
    let on-line(s, (dx, dy, dz)) = (x + s * dx, y + s * dy, s * dz)
    seen-hidden(at, seen, sample(s => on-line(s, rising), -reach, reach, n: 80))
    line(at(on-line(back, across)), at(on-line(front, across)), ..hidden)
    cetz.angle.angle(
      at(on-line(0, across)),
      at(on-line(1, across)),
      at(on-line(1, rising)),
      radius: 7.4,
      label-radius: 9,
      label: $phi$,
      mark: (start: "stealth", end: "stealth"),
    )
    named.push(at(on-line(0.72 * reach, rising)))
    spot(at(on-line(0, across)))
  }
  // ξ and μ on the outer sides of their lines, above the angles.
  content(named.first(), $xi$, anchor: "east")
  content(named.last(), $mu$, anchor: "west")
})

// Figure 13: the tangent lines of an arc of a helix do not meet: the band
// they sweep, the hidden lines dashed, its lower sheet stippled. A drawing.
#let fig-3-13() = image(
  "/assets/figures/03-13-helix-tangents.svg",
  width: 39.41mm,
)

// The pendulums of Figures 14 and 15, drawn about their hinges: the
// dash-dotted vertical through a hinge, the hatched mount over a hinge
// with its two struts, a rod (a bar turned by `turn` from the downward
// vertical, closed at its far end, or only its sides if styled) and the
// hinge itself, a small ring.
#let pendulum-axis-style = (
  stroke: (dash: (array: (3mm, 0.75mm, 0.15mm, 0.75mm))),
)
#let pendulum-axis((x, y), above, below) = cetz.draw.line(
  (x, y + above),
  (x, y - below),
  ..pendulum-axis-style,
)
#let pendulum-mount((x, y)) = {
  import cetz.draw: *
  // The mount 4.66 mm over the hinge, 3.1 mm to either side, its hatch
  // strokes 0.62 mm apart; the struts meet it 2.1 mm off the vertical.
  let (top, half, spread, step) = (y + 4.66, 3.1, 2.1, 0.62)
  line((x - half, top), (x + half, top))
  let count = calc.floor(2 * half / step)
  for k in range(count + 1) {
    let u = x - half + k * step
    line((u, top), (rel: (60deg, 1.1)))
  }
  line((x - spread, top), (x, y), (x + spread, top))
}
#let pendulum-rod((x, y), turn, length, ..style) = {
  let (dx, dy) = (calc.sin(turn), -calc.cos(turn))
  let (nx, ny) = (-dy * 0.75, dx * 0.75)
  let end = (x + length * dx, y + length * dy)
  let (ex, ey) = end
  if style.named().len() == 0 {
    cetz.draw.line(
      (x + nx, y + ny),
      (ex + nx, ey + ny),
      (ex - nx, ey - ny),
      (x - nx, y - ny),
    )
  } else {
    cetz.draw.line((x + nx, y + ny), (ex + nx, ey + ny), ..style)
    cetz.draw.line((x - nx, y - ny), (ex - nx, ey - ny), ..style)
  }
}
#let pendulum-hinge(at, radius: 0.55) = cetz.draw.circle(
  at,
  radius: radius,
  fill: white,
)

// Figure 14: a plane pendulum, a rod on a hinge, at rest, turned by the
// angle φ from the vertical and inside the circle of its positions (the
// circle its end describes), with a second position at the angle φ′
// (dashed). The angles are counted from the downward vertical.
#let fig-3-14() = slim-drawing({
  import cetz.draw: *
  let length = 12.3
  let down(hinge) = (rel: (0, -1), to: hinge)
  let toward(hinge, turn) = (rel: (turn - 90deg, 1), to: hinge)
  let panels = ((0, 0), (10.29, 0), (25.91, 0))
  let (still, swung, round) = panels
  for (hinge, above) in panels.zip((16, 16, 17.2)) {
    pendulum-axis(hinge, above, 15.15)
    pendulum-mount(hinge)
  }
  // At rest and turned by φ.
  pendulum-rod(still, 0deg, length)
  let turn = 34.3deg
  pendulum-rod(swung, turn, length)
  cetz.angle.angle(
    swung,
    down(swung),
    toward(swung, turn),
    radius: 9.44,
    label-radius: 12.1,
    label: $phi$,
    mark: (start: "stealth"),
  )
  // In the circle of positions: the rod at φ and, dashed, at φ′.
  let radius = 10.84
  let (turn, other) = (49deg, 128.4deg)
  circle(round, radius: radius)
  pendulum-rod(round, turn, radius)
  pendulum-rod(round, other, radius, ..fine-dash)
  cetz.angle.angle(
    round,
    down(round),
    toward(round, turn),
    radius: 6.69,
    label-radius: 9.05,
    label: $phi$,
    mark: (start: "stealth"),
  )
  cetz.angle.angle(
    round,
    down(round),
    toward(round, other),
    radius: 4.78,
    mark: (start: "stealth", end: "stealth"),
    ..fine-dash,
  )
  content((rel: ((turn + other) / 2 - 90deg, 7.33), to: round), $phi'$)
  for hinge in panels { pendulum-hinge(hinge) }
})

// Figure 15: a double pendulum, two rods joined by a hinge; its position
// is given by the angles φ₁, φ₂ of the rods from the downward vertical.
#let fig-3-15() = slim-drawing({
  import cetz.draw: *
  let (first, second) = ((37deg, 13.0), (69.6deg, 11.5))
  let top = (0, 0)
  let middle = (
    first.at(1) * calc.sin(first.at(0)),
    -first.at(1) * calc.cos(first.at(0)),
  )
  pendulum-axis(top, 8.25, 23.07)
  pendulum-axis(middle, 13.76, 12.91)
  pendulum-mount(top)
  for ((turn, length), hinge, radius, label-radius, name) in (
    (first, top, 8.04, 10.9, $phi_1$),
    (second, middle, 6.86, 10.6, $phi_2$),
  ) {
    pendulum-rod(hinge, turn, length)
    cetz.angle.angle(
      hinge,
      (rel: (0, -1), to: hinge),
      (rel: (turn - 90deg, 1), to: hinge),
      radius: radius,
      label-radius: label-radius,
      label: name,
      mark: (start: "stealth"),
    )
  }
  for hinge in (top, middle) { pendulum-hinge(hinge, radius: 0.85) }
})

// Figure 16: a mechanism whose positions form a torus in ℝ³. Arm 1
// turns about the z-axis by the angle φ₁ from the x-axis, arm 2 turns
// about the end of arm 1 by φ₂ in the plane of the z-axis; the ball at
// the end of arm 2 sweeps the torus of radii `big` (arm 1) and `small`
// (arm 2), and the circle drawn round the hinge at the present φ₁. The
// torus is seen orthographically; its contour is where the line of sight
// touches it, the inner one where that line does not enter the torus.
// The axes x, y and the angles stand in the page, as printed; the shading
// strokes on the torus are a drawing.
#let fig-3-16() = slim-drawing({
  import cetz.draw: *
  let tilt = 23.87deg
  let view = orthographic(0deg, tilt)
  let at = view.project
  let (_, ty, tz) = view.toward
  let (big, small) = (12.87, 5.95)
  let torus(u, v) = {
    let w = big + small * calc.cos(v)
    (w * calc.cos(u), w * calc.sin(u), small * calc.sin(v))
  }
  // Whether the line of sight from p towards the viewer enters the torus.
  let blocked((x, y, z)) = range(1, 161).any(k => {
    let s = 2.2 * (big + small) * k / 160
    let (py, pz) = (y + s * ty, z + s * tz)
    let d = calc.sqrt(x * x + py * py) - big
    d * d + pz * pz < 0.98 * small * small
  })
  // For each u the tube circle touches the line of sight where
  // tg v = sin u ctg(tilt), on its outer (cos v > 0) and inner side.
  let touch(u) = calc.atan(calc.sin(u) / calc.tan(tilt))
  line(
    ..sample(u => at(torus(u, touch(u))), 0deg, 360deg, n: 240),
    close: true,
  )
  // Only the seen part of the inner contour is drawn, as printed.
  let runs = ((),)
  for u in range(241).map(k => -180deg + k * 1.5deg) {
    let p = torus(u, touch(u) + 180deg)
    if blocked(p) {
      if runs.last().len() > 0 { runs.push(()) }
    } else { runs.last().push(at(p)) }
  }
  for run in runs.filter(run => run.len() > 1) { line(..run) }
  book-picture(
    "/assets/figures/03-16-torus-shading.svg",
    27.77,
    corner: (-18.37, 7.79),
    anchor: "north-west",
  )
  // The axes x, y from the centre, in the page; x passes over the
  // contour.
  let (x-end, y-end) = ((13.29, -13.67), (8.21, 7.41))
  bridge(((0, 0), x-end))
  arrowed((0, 0), x-end, name: "x")
  arrowed((0, 0), y-end, name: "y")
  // Arm 1 at the polar angle `turn` to the hinge, the centre of the
  // circle of the ball; arm 2 at the angle `lift` in that circle.
  let (turn, lift) = (-7deg, 95.2deg)
  let hinge = at((big * calc.cos(turn), big * calc.sin(turn), 0))
  let ball = at(torus(turn, lift))
  line(..sample(v => at(torus(turn, v)), 0deg, 360deg, n: 120), close: true)
  let rod(from, to) = {
    let (dx, dy) = (to.at(0) - from.at(0), to.at(1) - from.at(1))
    pendulum-rod(from, calc.atan2(-dy, dx), calc.sqrt(dx * dx + dy * dy))
  }
  rod((0, 0), hinge)
  // The axle about the z-axis, a white cylinder of radius `thick` from
  // `low` to `high`, and the axis through it; above the axle the axis
  // passes over the far side of the torus.
  let (thick, low, high) = (0.89, -2.67, 5.79)
  let (bottom, top) = (at((0, 0, low)).at(1), at((0, 0, high)).at(1))
  let flat = thick * calc.sin(tilt)
  rect((-thick, bottom), (thick, top), fill: white, stroke: none)
  circle((0, bottom), radius: (thick, flat), fill: white, stroke: none)
  line((-thick, bottom), (-thick, top))
  line((thick, bottom), (thick, top))
  arc(
    (thick, bottom),
    start: 0deg,
    stop: -180deg,
    radius: (thick, flat),
  )
  circle((0, top), radius: (thick, flat), fill: white)
  line((0, -13.67), (0, top), ..pendulum-axis-style)
  line((0, top + flat), (0, 17.65), stroke: (
    paint: white,
    thickness: 1.4mm,
    cap: "butt",
  ))
  arrowed((0, top), (0, 17.65), ..pendulum-axis-style, name: "z")
  rod(hinge, ball)
  pendulum-hinge(hinge, radius: 0.62)
  spot(ball, radius: 0.85)
  // The angles: φ₁ from the x-axis to arm 1, φ₂ from arm 1 back to the
  // axis to arm 2.
  cetz.angle.angle(
    (0, 0),
    x-end,
    hinge,
    radius: 4.8,
    label-radius: 7.4,
    label: $phi_1$,
    mark: (start: "stealth", end: "stealth"),
  )
  cetz.angle.angle(
    hinge,
    ball,
    (0, 0),
    radius: 3.9,
    mark: (start: "stealth", end: "stealth"),
  )
  content("z.end", $z$, anchor: "west")
  content("x.end", $x$, anchor: "south-west")
  content("y.end", $y$, anchor: "south")
  // φ₂ beside the middle of arm 2, off its side.
  let (bx, by) = ball
  let (hx, hy) = hinge
  content(
    ((hx + bx) / 2 + 0.75, (hy + by) / 2),
    $phi_2$,
    anchor: "west",
  )
})
