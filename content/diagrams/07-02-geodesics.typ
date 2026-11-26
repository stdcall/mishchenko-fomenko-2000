// Figures of chapter 7, § 2. Each is a function called by the text:
// `#fig(fig-7-8()) <fig:…>`.
#import "common.typ": *

// Figure 8: L is constant on the orbits of the group 𝔊 of changes of
// parameter. The space ΩMⁿ is a slab seen obliquely; the orbit 𝔊(γ) a line
// on it through γ; the graph of L over a strip about it a trough with its
// bottom over the orbit, the profile across two half-parabolas (steeper on
// the left, as printed). Parts of the trough behind its right wall dashed.
#let fig-7-8() = lettered-drawing({
  import cetz.draw: *
  // Oblique view: x along the front edge, the depth d receding at 43.5°,
  // the value z of L up.
  let corner = (1.9, 4.75)
  let recede = (0.726, 0.688)
  let at((x, d, z)) = (
    corner.at(0) + x + recede.at(0) * d,
    corner.at(1) + recede.at(1) * d + z,
  )
  let (width, depth, slab) = (52.3, 28.8, 2.9)
  // The orbit x = `orbit`; its points at the depths `front`, `middle` (γ)
  // and `back`, between which the trough stands.
  let orbit = 29
  let (front, middle, back) = (3.5, 12.8, 25.1)
  // L on the orbit and at the rims, the half-widths of the trough.
  let (floor, rim) = (9.8, 28.7)
  let (left, right) = (7.7, 12.6)
  let profile(u) = (
    floor + (rim - floor) * calc.pow(u / if u < 0 { left } else { right }, 2)
  )
  let surface(u, d) = at((orbit + u, d, profile(u)))
  let cross(d, from, to) = sample(u => surface(u, d), from, to, n: 60)
  // The generator along which the right wall turns away from the viewer.
  let turn = recede.at(1) / recede.at(0) * right * right / (2 * (rim - floor))
  // The right wall seen from outside, which hides what lies behind it.
  let wall = (
    ..cross(front, turn, right),
    ..cross(back, right, turn),
  )
  let seen(p) = not inside-polygon(p, wall)
  // The slab and the stippled plane on it.
  let plane = (
    (0, 0, 0),
    (width, 0, 0),
    (width, depth, 0),
    (0, depth, 0),
  ).map(at)
  let below((x, d, z)) = at((x, d, z - slab))
  line(
    ..plane.slice(0, 2),
    ..plane
      .slice(0, 2)
      .rev()
      .map(p => (
        p.at(0),
        p.at(1) - slab,
      )),
    close: true,
    fill: black,
  )
  line(
    ..plane.slice(1, 3),
    ..plane
      .slice(1, 3)
      .rev()
      .map(p => (
        p.at(0),
        p.at(1) - slab,
      )),
    close: true,
    fill: black,
  )
  line(..plane, close: true, fill: stipple, stroke: thick-line)
  let (base-front, base-middle, base-back) = (front, middle, back).map(d => at((
    orbit,
    d,
    0,
  )))
  line(base-front, base-back)
  // The trough, opaque, as strips between its generators.
  let profile-front = cross(front, -left, right)
  let profile-back = cross(back, -left, right)
  for i in range(1, profile-front.len()) {
    line(
      profile-front.at(i - 1),
      profile-front.at(i),
      profile-back.at(i),
      profile-back.at(i - 1),
      close: true,
      fill: white,
      stroke: (paint: white, thickness: 0.15mm),
    )
  }
  let (bottom-front, bottom-back) = (surface(0, front), surface(0, back))
  seen-hidden(p => p, seen, profile-back)
  seen-hidden(
    p => p,
    seen,
    sample(
      d => surface(0, d),
      front,
      back,
      n: 60,
    ),
  )
  line(surface(turn, front), surface(turn, back))
  for (from, to) in ((base-front, bottom-front), (base-back, bottom-back)) {
    line(from, to, stroke: (..hidden.stroke, thickness: thick-line))
  }
  // The cut edge of the sheet in front and its rims, thick.
  for u in (-left, right) {
    line(surface(u, front), surface(u, back), stroke: (
      thickness: 1.3mm,
      cap: "butt",
    ))
  }
  line(..profile-front, stroke: 0.9mm)
  for p in (base-front, base-middle, base-back, bottom-front, bottom-back) {
    spot(p, radius: 0.9)
  }
  axis-head-short(plane.first(), (1.9, 43), short: 2.8, name: "axis")
  content("axis.end", $L$, anchor: "north-west")
  content(surface(0.93 * right, back), $L lr((gamma))$, anchor: "north-west")
  content(plane.at(2), $Omega M^n$, anchor: "south-east")
  content(base-middle, $gamma$, anchor: "north-west", padding: 0.9)
  content(base-back, $frak(G) gamma$, anchor: "north-west", padding: 0.6)
})

// Figure 9: the exponential map exp_P₀ of the ball B^n_ε of T_P₀ Mⁿ onto
// the ball D^n_ε about P₀: a⃗ goes to exp_P₀ a⃗, the end of the geodesic
// with initial velocity a⃗; a geodesic γ and another path ω from P to Q. A
// drawing; the labels set over it, on the stipple in white cut-outs.
#let fig-7-9() = lettered-drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/07-09-exponential-map.svg",
    47.46,
    corner: (2.5, 3.73),
  )
  for (at, label) in (
    ((22.1, 34.4), $arrow(a)$),
    ((16.35, 26.9), $P_0$),
    ((43.4, 28.7), text(size: 7pt, $exp_(P_0) arrow(a)$)),
    ((38.25, 19.45), $Q$),
    ((28, 23.5), $omega$),
    ((10.3, 10.95), $P$),
    ((20.5, 7.7), $gamma$),
  ) {
    content(at, cutout(label))
  }
  content((3.8, 31.6), $B_epsilon^n$)
  content((48.95, 20.6), $D_epsilon^n$)
})

// Hand shading of a sphere drawn as a circle about `centre` of `radius`: a
// crescent inside its rim from the polar angle `from` to `to`, of `count`
// strokes. Each starts `gap` within the rim and runs onwards along it,
// turned inwards by `turn`, for `length`; all three swell from their
// first to their second value in the middle of the crescent.
#let sphere-shading(centre, radius, from, to, count, gap, length, turn) = {
  for k in range(count) {
    let s = (k + 0.5) / count
    let swell(pair) = (
      pair.at(0)
        + (pair.at(1) - pair.at(0))
          * calc.sin(
            s * 180deg,
          )
    )
    let angle = from + s * (to - from)
    let start = (rel: (angle, radius - swell(gap)), to: centre)
    cetz.draw.line(start, (
      rel: (angle + 90deg + swell(turn), swell(length)),
      to: start,
    ))
  }
}

// Figure 10: the geodesics r ↦ exp_P₀(r a⃗(t)) from P₀ cross the curves
// t ↦ exp_P₀(r₀ a⃗(t)) on the sphere S^(n−1)_r₀ ⊂ D^n_ε at right angles. The
// sphere is a shaded circle about P₀; a curve on it, free-hand (a smooth
// curve through points of the original), and a geodesic through its point,
// dashed inside the sphere.
#let fig-7-10() = lettered-drawing({
  import cetz.draw: *
  let (centre, radius) = ((21.38, 23.7), 20.45)
  let crossing = (33.42, 32.55)
  circle(centre, radius: radius, stroke: thick-line)
  group({
    set-style(stroke: (thickness: 0.9pt, cap: "butt"))
    sphere-shading(
      centre,
      radius,
      128deg,
      292deg,
      58,
      (1.2, 3.8),
      (1.2, 4.2),
      (10deg, 60deg),
    )
  })
  // The geodesic: dashed inside the sphere, as far as the curve.
  let n = 16
  let geodesic = spline-through(
    (
      centre,
      (27.9, 29.4),
      crossing,
      (35, 33.23),
      (38, 34.05),
      (42, 34.8),
      (
        46.3,
        35,
      ),
    ),
    n: n,
  )
  line(..geodesic.slice(0, 2 * n + 1), stroke: (
    ..hidden.stroke,
    thickness: thick-line,
  ))
  line(..geodesic.slice(2 * n))
  line(
    ..spline-through((
      (24.1, 39),
      (27.3, 39.6),
      (30.4, 39.4),
      (30.9, 38),
      (29.25, 36),
      (30.8, 35),
      (32.85, 34),
      crossing,
      (34.05, 30),
      (33.9, 28),
      (34.8, 26),
      (36.45, 24),
      (35.6, 22.3),
      (33.5, 21.6),
      (31.5, 20),
      (32.8, 18),
      (33.4, 16),
      (31.9, 14),
      (29.6, 13.1),
    )),
    stroke: 2 * thick-line,
  )
  spot(centre, radius: 1)
  spot(crossing, radius: 1.1)
  content((18.2, 21.75), $P_0$)
  content((44.45, 26.1), $exp_(P_0) lr((r arrow(a) lr((t))))$, angle: 90deg)
  content(
    (29.5, 11.3),
    $exp_(P_0) lr((r_0 arrow(a) lr((t))))$,
    angle: 15deg,
  )
  content(
    (33.8, 6.6),
    $S_(r_0)^(n-1) subset D_epsilon^n$,
    anchor: "north-west",
    padding: 0,
  )
})
// Figure 11: the surface f(r, t) = exp_P₀(r a⃗(t)), a "cone" of geodesics
// t = const from P₀ to the curve f(r₀, t), and at its point the tangent
// vectors ∂f⃗/∂t along the curve and ∂f⃗/∂r along the geodesic. The curve is
// a smooth curve through points of the original; each geodesic a quadratic
// arc whose start is turned from the chord by an angle growing from the
// lowest geodesic to the highest, so that the fan spreads as printed.
#let fig-7-11() = lettered-drawing({
  import cetz.draw: *
  let apex = (2.6, 34.2)
  let point = (30.2, 33.1)
  let curve-points = (
    (25.1, 8),
    (24.85, 12),
    (25.05, 16.5),
    (25.6, 21),
    (26.25, 24),
    (27.1, 27),
    (28.35, 30),
    point,
    (31.15, 35),
    (33.95, 38),
    (37.2, 41),
    (41, 44),
    (44.2, 46),
    (48, 47.8),
    (51.8, 48.6),
  )
  let n = 16
  let curve = spline-through(curve-points, n: n)
  let walked = (0,)
  for i in range(1, curve.len()) {
    let ((x0, y0), (x1, y1)) = (curve.at(i - 1), curve.at(i))
    walked.push(walked.last() + calc.norm(x1 - x0, y1 - y0))
  }
  // The point of the curve at the length s along it.
  let along(s) = {
    let i = calc.max(1, walked.position(w => w >= s))
    let r = (s - walked.at(i - 1)) / (walked.at(i) - walked.at(i - 1))
    let ((x0, y0), (x1, y1)) = (curve.at(i - 1), curve.at(i))
    (x0 + r * (x1 - x0), y0 + r * (y1 - y0))
  }
  // The fan ends at the 14th point; the geodesics stand at equal steps of
  // the curve, `below` steps up to the point and `above` beyond it.
  let (at-point, at-top) = (walked.at(n * 7), walked.at(n * 13))
  let (below, above) = (12, 11)
  // The turn of the start of a geodesic from its chord: at the lowest, at
  // the point, at the highest.
  let turns = (-6deg, 8deg, 17deg)
  let control(s) = {
    let turn = if s <= at-point {
      turns.at(0) + (turns.at(1) - turns.at(0)) * s / at-point
    } else {
      let r = (s - at-point) / (at-top - at-point)
      turns.at(1) + (turns.at(2) - turns.at(1)) * r
    }
    let (dx, dy) = along(s).zip(apex).map(((a, b)) => (a - b) / 2)
    (
      apex.at(0) + dx * calc.cos(turn) - dy * calc.sin(turn),
      apex.at(1) + dx * calc.sin(turn) + dy * calc.cos(turn),
    )
  }
  let stops = (
    ..range(below).map(k => k * at-point / below),
    ..range(above + 1).map(k => at-point + k * (at-top - at-point) / above),
  )
  for s in stops {
    bezier(apex, along(s), control(s), stroke: 0.9pt)
  }
  bezier(apex, along(0), control(0), stroke: 0.8mm)
  line(..curve, stroke: 2 * thick-line)
  // ∂f⃗/∂t along the curve and ∂f⃗/∂r along the geodesic at the point.
  let (before, after) = (curve.at(7 * n - 1), curve.at(7 * n + 1))
  let tangent = calc.atan2(
    after.at(0) - before.at(0),
    after.at(1) - before.at(1),
  )
  let c = control(at-point)
  let radial = calc.atan2(point.at(0) - c.at(0), point.at(1) - c.at(1))
  let up = (rel: (tangent, 25.2), to: point)
  group({
    set-style(stroke: thick-line)
    bridge((point, up))
    mark((up, 3, point), up, symbol: "stealth")
    arrowed(point, (rel: (radial, 25.5), to: point), name: "r")
  })
  // The leader of the surface's label.
  let (tail, head) = ((4.87, 19.94), (15.9, 27.56))
  bridge((tail, head))
  mark(
    head,
    (rel: (head.at(0) - tail.at(0), head.at(1) - tail.at(1)), to: head),
    symbol: "stealth",
  )
  spot(apex, radius: 1)
  spot(point, radius: 1.6)
  content(apex, $P_0$, anchor: "south", padding: 1.8)
  content((36.2, 52), $display((partial arrow(f)) / (partial t))$)
  content((48.8, 22.4), $display((partial arrow(f)) / (partial r))$)
  content((47.6, 51.4), $f lr((r_0, t))$)
  content(tail, $f lr((r, t))$, anchor: "north", padding: 0.6)
})

// The ball D^n_ε about `centre` with two spheres in it, of the radii
// `inner` < `middle` < `outer` (its rim): the inner ball and the shell
// between the middle sphere and the rim stippled.
#let shells(centre, inner, middle, outer) = {
  import cetz.draw: *
  circle(centre, radius: outer, fill: stipple, stroke: none)
  circle(centre, radius: middle, fill: white, stroke: none)
  circle(centre, radius: inner, fill: stipple, stroke: none)
  for r in (inner, middle, outer) {
    circle(centre, radius: r, stroke: thick-line)
  }
}

// A label with a leader from its left side, the arrowhead at `tip`.
#let leader-label(tail, tip, label) = {
  cetz.draw.line(tail, tip, mark: (end: "stealth"), stroke: thick-line)
  cetz.draw.content(tail, label, anchor: "west", padding: 0.6)
}

// Figure 12: the shortest path between two concentric spheres S^(n−1)_r₂
// and S^(n−1)_r₁ about P₀ in D^n_ε is the radial geodesic (thick), not
// another path (free-hand, a smooth curve through points of the original).
#let fig-7-12() = lettered-drawing({
  import cetz.draw: *
  let centre = (24, 29.85)
  let (inner, middle, outer) = (11.55, 18.6, 22.3)
  let on(r, angle) = (
    centre.at(0) + r * calc.cos(angle),
    centre.at(1) + r * calc.sin(angle),
  )
  shells(centre, inner, middle, outer)
  let angle = 37.5deg
  line(centre, on(inner, angle), stroke: (
    ..hidden.stroke,
    thickness: thick-line,
  ))
  line(on(inner, angle), on(middle, angle), stroke: 2.4 * thick-line)
  line(
    ..spline-through((
      (32.8, 36.9),
      (32.2, 38.5),
      (31.2, 40.5),
      (30.8, 42.3),
      (31.8, 43),
      (33.3, 42.5),
      (34.3, 41.7),
      (35.2, 42.7),
      (36.3, 42.8),
      (37.5, 42),
      (38.75, 41.2),
    )),
  )
  spot(centre, radius: 1)
  for r in (inner, middle) { spot(on(r, angle), radius: 1) }
  content((22.5, 26.4), cutout($P_0$))
  leader-label((51.2, 36.3), on(outer, 12.85deg), $D_epsilon^n$)
  leader-label((49, 28.7), on(middle, -2.6deg), $S_(r_1)^(n-1)$)
  leader-label((47.7, 15), on(inner, -31deg), $S_(r_2)^(n-1)$)
})

// Figure 13: a path ω from P₀ to P contains a piece from the sphere
// S^(n−1)_δ to the sphere S^(n−1)_r (thick), not shorter than r − δ, the
// length of the radial geodesic between them. The path is free-hand, a
// smooth curve through points of the original, dashed outside that piece.
#let fig-7-13() = lettered-drawing({
  import cetz.draw: *
  let centre = (24.4, 30.85)
  let (inner, middle, outer) = (10.36, 18.4, 23.85)
  let on(r, angle) = (
    centre.at(0) + r * calc.cos(angle),
    centre.at(1) + r * calc.sin(angle),
  )
  shells(centre, inner, middle, outer)
  let dashed = (stroke: (..hidden.stroke, thickness: thick-line))
  // The radial geodesic downwards.
  let down = -88.5deg
  line(centre, on(middle, down))
  // The path: from P₀ to the inner sphere, on to P, and beyond.
  let (enter, p, beyond) = (
    on(inner, -37deg),
    on(middle, -32.3deg),
    on(outer, -43.1deg),
  )
  line(
    ..spline-through((centre, (27.3, 30), (30, 28.3), (31.6, 26.2), enter)),
    ..dashed,
  )
  line(
    ..spline-through((
      enter,
      (33.2, 23.5),
      (34.5, 23.2),
      (35.5, 23.8),
      (36.8, 24),
      (38, 23.3),
      (39.2, 22),
      p,
    )),
    stroke: 2 * thick-line,
  )
  line(..spline-through((p, (40.9, 18.5), (41.5, 16.5), beyond)), ..dashed)
  for q in (centre, on(inner, down), on(middle, down), enter, p, beyond) {
    spot(q, radius: 1)
  }
  content((20.6, 30.25), cutout($P_0$))
  content((26.15, 25.85), cutout($delta$))
  content((24, 16.65), $r - delta$, anchor: "east", padding: 0)
  content((37.9, 25.9), $omega$)
  content((36.65, 20), $P$)
  leader-label((49, 47.5), on(inner, 34deg), $S_delta^(n-1)$)
  leader-label((50, 35.6), on(middle, 10.3deg), $S_r^(n-1)$)
  leader-label((52, 28.5), on(outer, -5.4deg), $D_epsilon^n$)
})
// Figure 14: a long arc SNP of a great circle of S² is not minimal: the
// arc PαS is shorter. Left, the sphere in the orthographic view with the
// great circle (its far half dashed) and the axis through its antipodal
// points N and S; right, the section of the sphere by the plane of the
// circle, the arc SNP bold. The points stand at their printed angles.
#let fig-7-14() = lettered-drawing({
  import cetz.draw: *
  // The sphere: the circle in the plane of e1, e2, φ its angle in it.
  let (centre, radius) = ((22.3, 29.95, 0), 21.05)
  let (e1, e2) = ((-0.772, 0.636, 0), (0.219, 0.266, 0.939))
  let on-circle(angle) = range(3).map(i => (
    centre.at(i)
      + radius * (calc.cos(angle) * e1.at(i) + calc.sin(angle) * e2.at(i))
  ))
  let at(p) = (p.at(0), p.at(1))
  let seen(p) = p.at(2) > 0
  let (north, west) = (63.4deg, 38.5deg)
  let south = north + 180deg
  let (n, p, s) = (north, west, south).map(on-circle)
  group({
    set-style(stroke: (thickness: thick-line))
    circle(at(centre), radius: radius)
    seen-hidden(at, seen, sample(on-circle, 0deg, 360deg))
    // The axis through N and S, beyond them by `reach`; hidden inside the
    // sphere and behind it.
    let reach = 2.15
    let axis(k) = range(3).map(i => centre.at(i) + k * (n.at(i) - centre.at(i)))
    let disc(q) = calc.norm(q.at(0) - centre.at(0), q.at(1) - centre.at(1))
    seen-hidden(
      at,
      q => {
        let k = (q.at(2) - centre.at(2)) / (n.at(2) - centre.at(2))
        k > 1 or (k < -1 and disc(q) > radius)
      },
      sample(axis, -reach, reach, n: 120),
    )
    arrowed(at(axis(reach - 0.3)), at(axis(reach)))
  })
  for q in (centre, n, p, s) { spot(at(q), radius: 0.85) }
  content(at(p), $P$, anchor: "north-east", padding: 0.8)
  content(at(n), $N$, anchor: "south-west", padding: 0.8)
  content(at(s), $S$, anchor: "north-east", padding: 0.8)
  content((9.3, 27.95), $alpha$)
  // The section: a stippled disc, the arc from S round through N to P bold.
  let (middle, size, band) = ((70, 29.9), 20.3, 1.9)
  let point(angle) = (rel: (angle, size), to: middle)
  let (to-n, to-p, to-s) = (47.5deg, 129.3deg, 227.5deg)
  circle(middle, radius: size, fill: stipple, stroke: thick-line)
  arc(
    middle,
    start: to-s,
    stop: to-p + 360deg,
    radius: size + band / 2,
    anchor: "origin",
    stroke: (thickness: band * 1mm, cap: "butt"),
  )
  for angle in (to-n, to-p, to-s) { spot(point(angle), radius: 2) }
  content(point(to-p), $P$, anchor: "south-east", padding: 2)
  content(point(to-n), $N$, anchor: "south-west", padding: 2.2)
  content(point(to-s), $S$, anchor: "north-east", padding: 2)
  content(point(180deg), $alpha$, anchor: "east", padding: 1.2)
  content((69.5, 30.35), cutout(emph[Сечение]))
})
