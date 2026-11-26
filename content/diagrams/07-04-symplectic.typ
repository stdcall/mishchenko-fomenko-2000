// Figures of chapter 7, § 4. Each is a function called by the text:
// `#fig(fig-7-19()) <fig:…>`.
#import "common.typ": *

// A body of revolution about a horizontal axis z, seen in the orthographic
// view turned by `turn` about the vertical, so that its left end faces the
// viewer; the axis at the height `axis`. `at(z, r, θ)` is the point of the
// parallel of radius r at z, θ measured about the axis from the viewer
// upwards; `seen(slope)` is the half-width in θ of the visible arc of a
// parallel where the radius grows by `slope` along z.
#let revolution-view(turn, axis: 0) = {
  let (c, s) = (calc.cos(turn), calc.sin(turn))
  (
    at: (z, r, theta) => (
      z * c + r * calc.cos(theta) * s,
      axis + r * calc.sin(theta),
    ),
    seen: slope => calc.acos(calc.clamp(-slope * s / c, -1, 1)),
  )
}

// The small arc of the angle between the parallel and a geodesic where
// they cross at `p`: from `up`, a point up the parallel, to `ahead`, a
// point further along the geodesic.
#let crossing-angle(p, up, ahead) = cetz.angle.angle(
  p,
  up,
  ahead,
  direction: "near",
  radius: 1.4,
  label: none,
  stroke: thin-line,
  fill: none,
  mark: none,
)

// The black open end of a tube seen from the outside: an ellipse of
// `points`, its rim a ring of white dashes `inset` inside.
#let open-end(points, centre, inset: 0.86) = {
  import cetz.draw: *
  line(..points, close: true, fill: black)
  line(
    ..points.map(p => cetz.vector.lerp(centre, p, inset)),
    close: true,
    stroke: (paint: white, thickness: 0.3mm, dash: (array: (0.5mm, 0.45mm))),
  )
}

// A smooth function through the knots ((z, r), …), z increasing: the cubic
// Hermite spline with the tangents of Catmull and Rom. Gives (r, r′) at z.
#let spline-profile(knots) = z => {
  let n = knots.len()
  let i = calc.clamp(knots.filter(((a, _)) => a <= z).len() - 1, 0, n - 2)
  let tangent(j) = {
    let (a, b) = (calc.max(j - 1, 0), calc.min(j + 1, n - 1))
    (
      (knots.at(b).at(1) - knots.at(a).at(1))
        / (knots.at(b).at(0) - knots.at(a).at(0))
    )
  }
  let ((z0, r0), (z1, r1)) = (knots.at(i), knots.at(i + 1))
  let h = z1 - z0
  let t = (z - z0) / h
  let (m0, m1) = (tangent(i) * h, tangent(i + 1) * h)
  (
    (2 * t * t * t - 3 * t * t + 1) * r0
      + (t * t * t - 2 * t * t + t) * m0
      + (-2 * t * t * t + 3 * t * t) * r1
      + (t * t * t - t * t) * m1,
    (
      (6 * t * t - 6 * t) * r0
        + (3 * t * t - 4 * t + 1) * m0
        + (-6 * t * t + 6 * t) * r1
        + (3 * t * t - 2 * t) * m1
    )
      / h,
  )
}

// Figure 19: a surface of revolution M² about the axis z, its generator
// r(z) a free smooth curve through a few points; the parallels, the orbits
// of the rotations, carry the field X⃗; a geodesic γ₀ crosses them at the
// angle α with r(z) cos α(z) = c (Clairaut), integrated from its lower end.
// The left end open towards the viewer, the right end shaded.
#let fig-7-19() = lettered-drawing({
  import cetz.draw: *
  let view = revolution-view(12.9deg, axis: 21.2)
  let at = view.at
  let profile = spline-profile((
    (3.49, 11.0),
    (8.21, 11.1),
    (13.34, 12.8),
    (19.5, 17.6),
    (25.65, 20.6),
    (31.8, 20.2),
    (37.97, 16.2),
    (44.13, 9.2),
    (50.29, 5.85),
    (55.73, 6.4),
  ))
  let (left, right) = (3.49, 55.73)
  let point(z, theta) = at(z, profile(z).at(0), theta)
  let rim(z, from, to) = sample(t => point(z, t), from, to, n: 72)
  // The outline: where the view grazes the surface.
  let contour(side) = sample(
    z => point(z, side * (view.seen)(profile(z).at(1))),
    left,
    right,
    n: 120,
  )
  line(..contour(1))
  line(..contour(-1))
  open-end(rim(left, 0deg, 360deg), at(left, 0, 0deg))
  line(..rim(right, 0deg, 360deg), close: true, fill: stipple, stroke: none)
  line(..rim(right, -90deg, 90deg), stroke: 2 * thick-line)
  // The parallels with the arrows of X⃗.
  let parallels = range(7).map(k => 17.6 + k * 4.4)
  for z in parallels {
    let edge = (view.seen)(profile(z).at(1))
    line(..rim(z, -edge, edge))
    let tip = 0.6 * edge
    mark(point(z, tip - 3deg), point(z, tip), symbol: "stealth")
  }
  // The axis: through the open end, hidden inside, out of the right end.
  let (axis-in, axis-out) = (point(left, 180deg), at(right, 0, 0deg))
  line((0, axis-in.at(1)), axis-in)
  line(axis-in, point(left, 0deg), stroke: (paint: white, thickness: 0.3mm))
  line(point(left, 0deg), axis-out, ..fine-dash)
  line(axis-out, (57.6, axis-out.at(1)), name: "z")
  content("z.end", $z$, anchor: "north-east", padding: (top: 1.2))
  // The radius r(z) from the axis to the top of its parallel.
  let z-radius = 10.67
  line(at(z-radius, 0, 0deg), point(z-radius, 90deg), name: "r")
  spot(at(z-radius, 0, 0deg), radius: 0.95)
  spot(point(z-radius, 90deg), radius: 0.95)
  content("r.45%", $r lr((z))$, anchor: "west", padding: 0.6)
  content((15.9, 30.6), $arrow(X)$)
  content(point(left, 90deg), $M^2$, anchor: "south-west", padding: (
    bottom: 1.6,
    left: 0.4,
  ))
  // The geodesic: dθ/dz = c √(1 + r′²) / (r √(r² − c²)).
  let (clairaut, start, stop, theta0) = (10.0, 16.53, 42.4, -45.6deg)
  let steps = 240
  let dz = (stop - start) / steps
  let geodesic = ((start, theta0),)
  for k in range(steps) {
    let (z, theta) = geodesic.last()
    let (r, slope) = profile(z + dz / 2)
    let turn = (
      clairaut
        * calc.sqrt(1 + slope * slope)
        / (r * calc.sqrt(r * r - clairaut * clairaut))
    )
    geodesic.push((z + dz, theta + turn * dz * 1rad))
  }
  line(
    ..geodesic.map(((z, theta)) => point(z, theta)),
    stroke: (thickness: 2.4pt, cap: "butt"),
  )
  let (label-z, label-theta) = geodesic.find(((z, _)) => z > 27.4)
  content(
    point(label-z, label-theta),
    $gamma_0$,
    anchor: "north-west",
    padding: 1.6,
  )
  // The angles where it crosses the inner parallels.
  for z in parallels.slice(1, 5) {
    let (zz, theta) = geodesic.sorted(key: ((a, _)) => calc.abs(a - z)).first()
    let ahead = geodesic.find(((a, _)) => a > zz + 2)
    crossing-angle(
      point(zz, theta),
      point(zz, theta + 15deg),
      point(..ahead),
    )
  }
})

// Figure 20: the cylinder r(z) = const with its parallels; a geodesic, the
// helix θ = θ₀ + k z, crossing them at a constant angle. The left end
// open towards the viewer, the far half of the right rim hidden.
#let fig-7-20() = lettered-drawing({
  import cetz.draw: *
  let view = revolution-view(12.9deg, axis: 7.9)
  let at = view.at
  let radius = 7.6
  let (left, right) = (2.77, 41.44)
  let circles = 12
  let rim(z, from, to) = sample(t => at(z, radius, t), from, to, n: 72)
  open-end(rim(left, 0deg, 360deg), at(left, 0, 0deg))
  for side in (90deg, -90deg) {
    line(at(left, radius, side), at(right, radius, side))
  }
  for k in range(1, circles) {
    let z = left + k * (right - left) / circles
    line(..rim(z, -90deg, 90deg))
  }
  line(..rim(right, -90deg, 90deg))
  line(..rim(right, 90deg, 270deg), ..fine-dash)
  // The axis: through the open end, then out of the right end.
  let (axis-in, axis-out) = (at(left, radius, 180deg), at(right, radius, 0deg))
  line((0, axis-in.at(1)), axis-in)
  line(axis-in, at(left, radius, 0deg), stroke: (
    paint: white,
    thickness: 0.3mm,
  ))
  arrowed(axis-out, (rel: (7.4, 0), to: axis-out), name: "z")
  content("z.end", $z$, anchor: "north-east", padding: 1.6)
  // The helix from `start` to `stop` along z, turning by `pitch` per mm.
  let (start, stop, theta0, pitch) = (10.86, 34.2, -57.4deg, 4.49deg)
  let helix(z) = at(z, radius, theta0 + pitch * (z - start))
  line(
    ..sample(helix, start, stop, n: 60),
    stroke: (thickness: 1.7pt, cap: "butt"),
  )
  let crossings = range(1, circles)
    .map(k => left + k * (right - left) / circles)
    .filter(z => start < z and z < stop)
  for z in crossings.slice(0, -1) {
    let theta = theta0 + pitch * (z - start)
    crossing-angle(helix(z), at(z, radius, theta + 20deg), helix(z + 2))
  }
})

// The runs of the points of a curve where `seen` holds, each run carried
// on to the first unseen point after it.
#let seen-runs(points, seen) = {
  let runs = ()
  let open = false
  for p in points {
    if seen(p) {
      if not open { runs.push(()) }
      runs.last().push(p)
      open = true
    } else if open {
      runs.last().push(p)
      open = false
    }
  }
  runs.filter(run => run.len() > 1)
}

// Figure 21: the sphere S², r(z) = √(R² − z²): its parallels, the north
// pole tilted towards the viewer and the axis through the poles; a
// geodesic, a great circle at the angle `incline` to the equator, crosses
// the parallels at a varying angle. Only the near side of the parallels
// is drawn; the far half of the great circle is dashed.
#let fig-7-21() = lettered-drawing({
  import cetz.draw: *
  let radius = 19.6
  let centre = (19.5, 23.1)
  let view = orthographic(0deg, 26deg)
  let at(p) = cetz.vector.add(centre, (view.project)(p))
  let seen(p) = facing(view, p)
  let on-sphere(polar, turn) = (
    radius * calc.sin(polar) * calc.cos(turn),
    radius * calc.sin(polar) * calc.sin(turn),
    radius * calc.cos(polar),
  )
  // The parallels at their polar angles: rings about the pole, then every
  // 13°.
  let parallels = (8deg, 16deg, 26deg, ..range(8).map(k => 39deg + k * 13deg))
  for polar in parallels {
    let points = sample(t => on-sphere(polar, t), 0deg, 360deg, n: 144)
    for run in seen-runs(points, seen) { line(..run.map(at)) }
  }
  circle(centre, radius: radius, stroke: thick-line)
  // The great circle through e₁ on the equator and e₂ at `incline` above
  // it, its plane's normal turned by `node` about the axis.
  let (incline, node) = (51.8deg, 74.5deg)
  let e1 = (-calc.sin(node), calc.cos(node), 0)
  let e2 = (
    -calc.cos(incline) * calc.cos(node),
    -calc.cos(incline) * calc.sin(node),
    calc.sin(incline),
  )
  let great(t) = cetz.vector.add(
    cetz.vector.scale(e1, radius * calc.cos(t)),
    cetz.vector.scale(e2, radius * calc.sin(t)),
  )
  let points = sample(great, 0deg, 360deg, n: 180)
  let bold = (thickness: 2pt, cap: "butt")
  for run in seen-runs(points, seen) {
    line(..run.map(at), stroke: bold)
  }
  for run in seen-runs(points, p => not seen(p)) {
    line(..run.map(at), stroke: (..bold, dash: (array: (1.3mm, 0.6mm))))
  }
  // The angles at some of its crossings with the parallels, z = R sin t
  // sin(incline) = R cos(polar); `far` picks the second solution. Each arc
  // spans the two curves on their right.
  for (polar, far) in (
    (52deg, false),
    (52deg, true),
    (65deg, false),
    (
      78deg,
      false,
    ),
  ) {
    let t = calc.asin(calc.cos(polar) / calc.sin(incline))
    let t = if far { 180deg - t } else { t }
    let p = great(t)
    let turn = calc.atan2(p.at(0), p.at(1))
    let right(a, b) = if a.at(0) > b.at(0) { a } else { b }
    crossing-angle(
      at(p),
      right(at(great(t + 8deg)), at(great(t - 8deg))),
      right(at(on-sphere(polar, turn + 8deg)), at(on-sphere(
        polar,
        turn - 8deg,
      ))),
    )
  }
  // The axis: out of the north pole, from the hidden south pole down.
  let (north, south) = (at((0, 0, radius)), at((0, 0, -radius)))
  arrowed(north, (north.at(0), 48.3))
  spot(north)
  spot(south)
  let rim = (south.at(0), centre.at(1) - radius)
  line(south, rim, ..fine-dash)
  line(rim, (rim.at(0), 0))
})
// Figure 22: a right circular cone with its parallels, the orbits of its
// rotations, which are not geodesics, and its development: a sector of
// the angle 2π sin(α), α the half-angle at the apex O, drawn reduced; the
// parallels unroll into arcs about O, the geodesics into straight lines.
// The base open towards the viewer.
#let fig-7-22() = lettered-drawing({
  import cetz.draw: *
  let turn = 16.3deg
  let view = revolution-view(turn, axis: 24.3)
  let at = view.at
  // The cone: base radius, the base and the apex along the axis; the
  // parallels divide its generators into `steps` equal parts.
  let radius = 18.15
  let (base, apex) = (4.95 / calc.cos(turn), 32.9 / calc.cos(turn))
  let steps = 15
  let height = apex - base
  let slope = -radius / height
  let edge = (view.seen)(slope)
  let ring(z, from, to) = sample(
    t => at(z, radius * (apex - z) / height, t),
    from,
    to,
    n: 90,
  )
  // The open base: black, its rim hatched by white strokes across it, a
  // light on the far wall.
  let rim = ring(base, 0deg, 360deg)
  let centre = at(base, 0, 0deg)
  line(..rim, close: true, fill: black)
  for p in rim {
    line(
      cetz.vector.lerp(centre, p, 0.97),
      cetz.vector.lerp(centre, p, 0.8),
      stroke: (paint: white, thickness: 0.2mm),
    )
  }
  circle((7.6, 24.1), radius: (0.75, 6.5), fill: white, stroke: none)
  for side in (1, -1) {
    line(at(apex, 0, 0deg), at(base, radius, side * edge))
  }
  for k in range(1, steps) {
    let z = base + k * height / steps
    line(..ring(z, -edge, edge))
  }
  line(..rim, close: true)
  // The axis, seen through the base, hidden in the cone.
  let (axis-in, axis-out) = (at(base, radius, 180deg), at(base, radius, 0deg))
  bridge((axis-in, axis-out), gap: 0.9mm)
  line(axis-out, at(apex, 0, 0deg), ..fine-dash)
  content(at(apex, 0, 0deg), $O$, anchor: "north-west", padding: 0.6)
  // The development about O: the sector of the angle 2π sin(α) about the
  // direction `gap` of the cut, of the radius `reach`; the parallels as
  // arcs at the same steps; a geodesic, a straight chord.
  let (o, reach, gap) = ((56.5, 24.5), 21.8, -84.5deg)
  let sector = 360deg * radius / calc.sqrt(radius * radius + height * height)
  let (from, to) = (gap + 180deg - sector / 2, gap + 180deg + sector / 2)
  let arc-points(r) = sample(
    t => cetz.vector.add(o, (r * calc.cos(t), r * calc.sin(t))),
    from,
    to,
    n: 120,
  )
  for k in range(1, steps + 1) { line(..arc-points(k * reach / steps)) }
  let outer = arc-points(reach)
  line(outer.first(), o, outer.last())
  spot(o)
  content(o, $O$, anchor: "north", padding: 1.6)
  let chord = (166deg, 58deg).map(t => cetz.vector.add(o, (
    reach * calc.cos(t),
    reach * calc.sin(t),
  )))
  line(..chord)
  // The words of the book.
  content(
    chord.last(),
    align(center, emph[Геодезические \ (прямые)]),
    anchor: "south-west",
    padding: (bottom: 1.2, left: -2),
  )
  let pointed = cetz.vector.add(o, (
    (steps - 1) / steps * reach * calc.cos(122deg),
    (steps - 1) / steps * reach * calc.sin(122deg),
  ))
  content((41.8, 47.3), emph[Не геодезические], anchor: "south")
  hobby((40.6, 46.4), (43.6, 43.8), pointed, mark: leader-mark)
  content(
    (o.at(0), o.at(1) - 4.5),
    align(center, emph[Развертка \ конуса]),
    anchor: "north",
  )
})

// The identifications φ: T_*Mⁿ → T*Mⁿ and φ⁻¹ back: two horizontal
// arrows `reach` to either side of x = `middle`, at the heights `upper`
// and `lower`, their heads `short` of the ends.
#let identification-arrows(middle, upper, lower, reach, short: 1.4) = {
  import cetz.draw: *
  for (y, side, name, anchor) in (
    (upper, 1, $phi$, "south"),
    (lower, -1, $phi^(-1)$, "north"),
  ) {
    let (from, to) = ((middle - side * reach, y), (middle + side * reach, y))
    line(from, to, name: "phi")
    mark((to, short + 1, from), (to, short, from), symbol: "stealth")
    content("phi.mid", name, anchor: anchor, padding: 1.2)
  }
}

// A bundle over Mⁿ drawn as a rectangle from `corner` of `size`, ruled
// by its fibres into `strips` equal strips, the zero section Mⁿ across it
// at the height `zero`.
#let ruled-bundle(corner, size, strips, zero) = {
  import cetz.draw: *
  let (x, y) = corner
  let (width, height) = size
  for i in range(1, strips) {
    let u = x + i * width / strips
    line((u, y), (u, y + height))
  }
  line((x, zero), (x + width, zero))
  rect(corner, (x + width, y + height))
}

// The bold curve of a trajectory in a bundle, a smooth curve through
// `points` with dots at its ends.
#let bundle-trajectory(points) = {
  cetz.draw.hobby(..points, stroke: 1.6pt)
  for p in (points.first(), points.last()) { spot(p, radius: 0.8) }
}

// Figure 23: the bundles T_*Mⁿ and T*Mⁿ as ruled quadrilaterals, the
// fibres over the points of Mⁿ, the zero section Mⁿ = (x, 0) a hatched
// band; the identifications φ, φ⁻¹ between them and the projections π, q
// onto the base Mⁿ. The two bundles are mirror images.
#let fig-7-23() = lettered-drawing({
  import cetz.draw: *
  // T_*Mⁿ: its corners from the upper left clockwise, the number of strips
  // between the fibres, where the zero section meets the left and right
  // sides (along them from the top) and where x lies on it.
  let corners = ((0.71, 23.0), (34.3, 41.9), (34.9, 15.5), (5.9, 5.5))
  let strips = 14
  let (zero-left, zero-right, zero-x) = (0.43, 0.58, 0.59)
  let band = 0.9
  let middle = 41.6
  let hatching(side) = line-hatching(
    90deg - side * 35deg,
    0.45mm,
    stroke: 0.12mm + black,
  )
  let mix(p, q, t) = cetz.vector.lerp(p, q, t)
  // The labels of the bundles and of the ends of their zero sections.
  let names = ($T_* M^n = lr((x, arrow(a)))$, $T^* M^n = lr((x, p))$)
  let zero-name = std.grid(
    align: center,
    row-gutter: 0.9mm,
    $M^n$,
    std.rotate(90deg, $=$),
    $lr((x, 0))$,
  )
  for (k, side) in (1, -1).enumerate() {
    let at((x, y)) = (middle + side * (x - middle), y)
    let (top-left, top-right, bottom-right, bottom-left) = corners.map(at)
    for i in range(strips + 1) {
      let t = i / strips
      line(mix(top-left, top-right, t), mix(bottom-left, bottom-right, t))
    }
    line(top-left, top-right, bottom-right, bottom-left, close: true)
    let zero = (
      mix(top-left, bottom-left, zero-left),
      mix(top-right, bottom-right, zero-right),
    )
    let lift(p, h) = (p.at(0), p.at(1) + h)
    let outline = (
      ..zero.map(p => lift(p, band / 2)),
      ..zero.rev().map(p => lift(p, -band / 2)),
    )
    line(..outline, close: true, fill: white)
    line(..outline, close: true, fill: hatching(side))
    let x = mix(..zero, zero-x)
    spot(x)
    content(
      lift(x, 1.6),
      $lr((x, 0))$,
      angle: 90deg,
      anchor: if side == 1 { "south-west" } else { "north-west" },
    )
    // The name along the upper side, the end of the zero section with its
    // leader.
    let (from, to) = if side == 1 { (top-left, top-right) } else {
      (top-right, top-left)
    }
    label-along(
      mix(top-left, top-right, 0.52),
      calc.atan2(..cetz.vector.sub(to, from)),
      names.at(k),
    )
    let end = zero.at(0)
    content(at((2.4, 5.8)), zero-name)
    hobby(
      at((1.8, 10.9)),
      at((1.9, 12.9)),
      lift(end, -band / 2 - 0.3),
      mark: leader-mark,
    )
  }
  identification-arrows(middle, 37.2, 34.15, 5.65)
  // The base Mⁿ, the projections onto it and where x goes.
  let base = ((26.6, 2.1), (57.5, 3.6))
  rect(..base, fill: hatching(1))
  spot((35.3, 2.85))
  content(
    (base.at(0), "|-", (0, 2.85)),
    $pi lr((x, arrow(a))) = x$,
    anchor: "east",
    padding: 1.6,
  )
  content(
    (base.at(1), "|-", (0, 2.85)),
    $q lr((x, p)) = x$,
    anchor: "west",
    padding: 1.6,
  )
  content((42, 2.1), $M^n$, anchor: "north", padding: 0.4)
  arrowed((22.0, 10.0), (29.6, 4.6), name: "pi")
  arrowed((57.5, 10.5), (50.4, 4.8), name: "q")
  content("pi.30%", $pi$, anchor: "south-west", padding: 1.2)
  content("q.30%", $q$, anchor: "south-east", padding: 1.2)
})

// Figure 24: a trajectory α(t) in T_*Mⁿ from R = (x₀, a⃗₀) to
// S = (y₀, b⃗₀); the vectors a⃗₀, b⃗₀ in the fibres over x₀, y₀ from the
// zero section Mⁿ. The curve is free-hand, a smooth curve through a few
// points.
#let fig-7-24() = lettered-drawing({
  import cetz.draw: *
  let zero = 16.8
  ruled-bundle((0.2, 0.3), (35.1, 31.3), 12, zero)
  let (x0, y0) = ((6.0, zero), (27.4, zero))
  let (r, s) = ((6.0, 25.1), (27.4, 6.2))
  let dot-radius = 0.95
  for (from, to, name) in ((x0, r, "a"), (y0, s, "b")) {
    arrowed(from, (to, dot-radius, from), stroke: 1.2pt, name: name)
  }
  bundle-trajectory((
    r,
    (8.7, 25.4),
    (12.1, 26.0),
    (16.3, 27.1),
    (20.5, 28.4),
    (24.2, 29.1),
    (26.2, 29.2),
    (27.2, 28.2),
    (27.0, 25.7),
    (25.0, 22.6),
    (22.2, 20.4),
    (19.4, 18.1),
    (17.4, 15.6),
    (16.9, 13.6),
    (17.7, 11.4),
    (20.5, 9.1),
    (23.9, 7.7),
    s,
  ))
  for p in (r, s, x0, y0) { spot(p, radius: dot-radius) }
  let gap = dot-radius + 0.5
  content(r, $R$, anchor: "south-east", padding: gap)
  content(s, $S$, anchor: "north-west", padding: gap)
  content(x0, $x_0$, anchor: "north-west", padding: gap)
  content(y0, $y_0$, anchor: "south-west", padding: gap)
  content("a.mid", $arrow(a)_0$, anchor: "east", padding: 0.8)
  content("b.mid", $arrow(b)_0$, anchor: "west", padding: 0.8)
  content((27.6, 27.4), $alpha lr((t))$, anchor: "west")
  content((35.3, 31.6), $T_* M^n$, anchor: "south-east", padding: 0.6)
  arrowed((41.5, zero), (36.1, zero), name: "zero")
  content("zero.mid", $M^n$, anchor: "south", padding: 1.2)
})

// Figure 25: the trajectory α(t) from R to S in T_*Mⁿ and a trajectory
// from A to B in T*Mⁿ, the two bundles identified by φ, φ⁻¹. The curves
// are free-hand, smooth curves through a few points.
#let fig-7-25() = lettered-drawing({
  import cetz.draw: *
  let size = (35.1, 30.6)
  let zero = 16.5
  ruled-bundle((5.8, 0.6), size, 8, zero)
  ruled-bundle((59.6, 0.6), size, 9, zero)
  let (r, s) = ((14.5, 25.5), (33.0, 7.7))
  let (a, b) = ((78.2, 27.7), (89.7, 22.4))
  bundle-trajectory((
    r,
    (17.1, 25.2),
    (20.3, 25.4),
    (23.9, 26.3),
    (28.1, 27.7),
    (31.7, 28.4),
    (34.3, 27.3),
    (34.9, 25.0),
    (33.2, 21.9),
    (30.1, 19.0),
    (27.3, 16.1),
    (25.5, 13.0),
    (26.2, 9.9),
    (29.1, 8.6),
    s,
  ))
  bundle-trajectory((
    a,
    (74.8, 26.3),
    (70.6, 25.0),
    (67.0, 23.4),
    (64.9, 21.4),
    (66.0, 19.8),
    (69.6, 18.2),
    (71.7, 15.6),
    (71.7, 12.5),
    (71.1, 8.9),
    (71.7, 5.7),
    (74.3, 3.6),
    (77.9, 3.4),
    (82.1, 5.7),
    (85.2, 9.4),
    (87.8, 15.6),
    (89.4, 20.3),
    b,
  ))
  let gap = 1.3
  content(r, $R$, anchor: "south-east", padding: gap)
  content(s, $S$, anchor: "north-west", padding: gap)
  content(a, $A$, anchor: "west", padding: gap)
  content(b, $B$, anchor: "south", padding: gap)
  content((27.6, 24.6), $alpha lr((t))$)
  content((40.9, 31.4), $T_* M^n$, anchor: "south-east", padding: 0.6)
  content((94.7, 31.4), $T^* M^n$, anchor: "south-east", padding: 0.6)
  identification-arrows(50.35, 19.8, 16.6, 4.05)
  // The zero sections named by leaders from below the outer sides.
  for (name-at, from, via, to) in (
    ((2.3, 11.4), (0.3, 13.2), (1.6, 15.5), (5.5, zero)),
    ((96.6, 9.6), (98.6, 11.6), (97.9, 14.6), (95.4, zero + 0.1)),
  ) {
    hobby(from, via, to, mark: leader-mark)
    content(name-at, $M^n$)
  }
})
// Figure 26: the flow 𝔊_t of a Hamiltonian field on M²ⁿ carries a domain
// about y to a domain about x(t, y). The sheet M²ⁿ and the domains are
// free-hand: smooth curves through a few points and turned ellipses.
#let fig-7-26() = lettered-drawing({
  import cetz.draw: *
  let far = (
    (5.0, 24.5),
    (12.0, 27.3),
    (20.0, 29.3),
    (28.0, 30.4),
    (35.0, 30.5),
    (
      43.0,
      30.0,
    ),
  )
  let right = ((43.0, 30.0), (42.3, 20.0), (41.4, 10.0), (40.6, 4.4))
  let near = ((40.6, 4.4), (32.0, 6.9), (20.0, 8.4), (10.0, 8.8), (0.3, 8.5))
  let left = ((0.3, 8.5), (1.5, 13.0), (3.0, 19.0), (5.0, 24.5))
  curved-sheet(far, right, near, left, (0.9, -2.9))
  // The domains: centre, semi-axes, turn; the point in each a white ring.
  let ellipse-point((centre, (a, b), turn), t) = cetz.vector.add(centre, (
    a * calc.cos(t) * calc.cos(turn) - b * calc.sin(t) * calc.sin(turn),
    a * calc.cos(t) * calc.sin(turn) + b * calc.sin(t) * calc.cos(turn),
  ))
  let domains = (
    ((11.3, 18.0), (7.9, 3.8), 27deg),
    ((32.1, 23.8), (8.0, 3.7), 13deg),
  )
  for (domain, ring) in domains.zip(((10.3, 18.5), (32.4, 24.4))) {
    line(
      ..sample(t => ellipse-point(domain, t), 0deg, 360deg, n: 120),
      close: true,
      fill: black,
      stroke: none,
    )
    circle(ring, radius: 1.0, stroke: white + 0.3mm)
  }
  arrowed(
    ellipse-point(domains.at(0), 0deg),
    ellipse-point(domains.at(1), 180deg),
    name: "flow",
  )
  content("flow.mid", cutout($frak(G)_t$), anchor: "south", padding: 1.6)
  content((18.6, 14.2), cutout($y$))
  content((30.6, 17.4), cutout($x lr((t, y))$))
  content(far.last(), $M^(2 n)$, anchor: "south-west", padding: (bottom: 0.8))
})

// Figure 27: the rigid body, x = x₁₂, y = x₁₃, z = x₂₃: the integral
// trajectories on the ellipsoid Q = x²(λ₁ + λ₂) + y²(λ₁ + λ₃) +
// z²(λ₂ + λ₃) = const are its sections by the spheres P = x² + y² + z² =
// ρ². The ellipsoid is given by its semi-axes a > c > b along x, z, y
// (λ₂ < λ₁ < λ₃), so the trajectories go round the ends of x and of y and
// cross at the ends of z, where ρ = c. Seen in an oblique parallel view
// (x to the right, z up, y back to the right); a free-hand shadow under it.
#let fig-7-27() = lettered-drawing({
  import cetz.draw: *
  let (a, b, c) = (21, 11.5, 13.6)
  // The λ of these semi-axes, up to a factor, are positive and distinct.
  let (qx, qy, qz) = (a, b, c).map(r => 1 / (r * r))
  let lambda = (qx + qy - qz, qx + qz - qy, qy + qz - qx)
  assert(lambda.all(l => l > 0) and lambda.dedup().len() == 3)
  let origin = (23.0, 24.1)
  let depth = (0.8 * calc.cos(58deg), 0.8 * calc.sin(58deg))
  let at((x, y, z)) = (
    origin.at(0) + x + y * depth.at(0),
    origin.at(1) + z + y * depth.at(1),
  )
  // Towards the viewer: the direction the view flattens.
  let toward = (depth.at(0), -1, depth.at(1))
  let seen((x, y, z)) = (
    x / (a * a) * toward.at(0)
      + y / (b * b) * toward.at(1)
      + z / (c * c) * toward.at(2)
      > 0
  )
  // The shadow: a free-hand blob through a few points, with clearings.
  hobby(
    (3.4, 14.5),
    (5.5, 15.0),
    (8.0, 14.9),
    (9.8, 15.4),
    (25.0, 13.5),
    (40.5, 15.3),
    (44.5, 15.5),
    (46.8, 15.2),
    (46.6, 14.3),
    (48.0, 13.3),
    (49.2, 11.8),
    (49.3, 10.2),
    (48.6, 8.6),
    (49.2, 7.3),
    (48.8, 5.5),
    (47.0, 3.5),
    (44.0, 2.0),
    (38.0, 0.6),
    (30.0, 0.5),
    (22.0, 0.6),
    (14.0, 0.8),
    (10.0, 1.5),
    (5.5, 2.3),
    (3.0, 2.8),
    (2.0, 4.0),
    (3.5, 5.3),
    (5.5, 6.3),
    (3.2, 7.0),
    (0.3, 7.8),
    (0.1, 9.4),
    (1.2, 10.4),
    (4.3, 10.9),
    (1.5, 11.5),
    (0.8, 12.4),
    (2.0, 13.0),
    (5.0, 13.5),
    (3.0, 14.0),
    close: true,
    fill: black,
    stroke: none,
  )
  for (centre, size) in (
    ((4.7, 8.8), (1.25, 0.45)),
    ((6.2, 12.1), (0.6, 0.3)),
    ((20.0, 6.0), (4.85, 1.1)),
    ((43.4, 13.6), (0.9, 0.35)),
    ((46.0, 9.1), (1.5, 0.45)),
  ) {
    circle(centre, radius: size, fill: white, stroke: none)
  }
  // The outline: the extreme points of the image of the ellipsoid in the
  // directions of the plane.
  let image = ((a, b * depth.at(0), 0), (0, b * depth.at(1), c))
  let row-dot(i, j) = image.at(i).zip(image.at(j)).map(((p, q)) => p * q).sum()
  let outline = sample(
    t => {
      let (u, v) = (calc.cos(t), calc.sin(t))
      let (sx, sy) = (
        row-dot(0, 0) * u + row-dot(0, 1) * v,
        row-dot(1, 0) * u + row-dot(1, 1) * v,
      )
      let norm = calc.sqrt(sx * u + sy * v)
      (origin.at(0) + sx / norm, origin.at(1) + sy / norm)
    },
    0deg,
    360deg,
    n: 180,
  )
  line(..outline, close: true, fill: white, stroke: thick-line)
  // The trajectories, near halves only: the ellipsoid Q = 1 cut by the
  // ellipsoids P = const, P = (λ1 + λ2)² x² + (λ1 + λ3)² y² + (λ2 + λ3)² z².
  // With x = a u, y = b v, z = c w on Q = 1 (u² + v² + w² = 1), P is
  // proportional to k = u² / a² + v² / b² + w² / c². Round the ends of x: k
  // from 1 / a² up to 1 / c² (the separatrices); round the ends of y: k from
  // 1 / b² down to 1 / c².
  let (ka, kb, kc) = (qx, qy, qz)
  let curve(t, around-x, side) = s => {
    let (u, v, w) = if around-x {
      let k = ka + (kc - ka) * t * t
      let v = calc.sqrt((k - ka) / (kb - ka)) * calc.cos(s)
      let w = calc.sqrt((k - ka) / (kc - ka)) * calc.sin(s)
      (side * calc.sqrt(calc.max(1 - v * v - w * w, 0)), v, w)
    } else {
      let k = kb - (kb - kc) * t * t
      let u = calc.sqrt((kb - k) / (kb - ka)) * calc.cos(s)
      let w = calc.sqrt((kb - k) / (kb - kc)) * calc.sin(s)
      (u, side * calc.sqrt(calc.max(1 - u * u - w * w, 0)), w)
    }
    (a * u, b * v, c * w)
  }
  let families = (
    (true, range(1, 8).map(k => k / 7)),
    (false, range(1, 8).map(k => k / 8)),
  )
  for (around-x, steps) in families {
    for t in steps {
      for side in (1, -1) {
        let points = sample(curve(t, around-x, side), 0deg, 360deg, n: 240)
        for run in seen-runs(points, seen) {
          line(..run.map(at), stroke: 0.9pt)
        }
      }
    }
  }
  // The axes from the centre, and their ends on the ellipsoid; the third
  // goes on over the shadow in white.
  arrowed(origin, (origin.at(0), 47.5))
  arrowed(origin, (48.9, origin.at(1)))
  let front = (9.1, 1.5)
  let (dx, dy) = cetz.vector.sub(front, origin)
  let det = row-dot(0, 0) * row-dot(1, 1) - row-dot(0, 1) * row-dot(0, 1)
  let leave = cetz.vector.add(origin, cetz.vector.scale(
    (dx, dy),
    1
      / calc.sqrt(
        (
          row-dot(1, 1) * dx * dx
            - 2 * row-dot(0, 1) * dx * dy
            + row-dot(0, 0) * dy * dy
        )
          / det,
      ),
  ))
  // Outside the ellipsoid the axis is drawn hollow, white in black.
  line(origin, leave)
  let head = (length: 3.4mm, width: 2.1mm, inset: 0.9mm)
  line(
    leave,
    front,
    stroke: (thickness: 0.75mm, cap: "butt"),
    mark: (
      end: "stealth",
      fill: black,
      ..head,
    ),
  )
  line(
    leave,
    (front, 0.55, leave),
    stroke: (paint: white, thickness: 0.35mm, cap: "butt"),
    mark: (
      end: "stealth",
      fill: white,
      stroke: none,
      length: 2.2mm,
      width: 1.1mm,
      inset: 0.6mm,
    ),
  )
  for p in ((a, 0, 0), (0, -b, 0), (0, 0, c)) { spot(at(p)) }
  content((37.5, 41.5), $Q = "const"$)
})
