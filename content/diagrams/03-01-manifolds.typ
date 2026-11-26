// Figures of chapter 3, § 1. Each is a function called by the text:
// `#fig(fig-3-1()) <fig:…>`.
#import "common.typ": *

// Two charts of the circle of radius `radius` about the origin that project
// its open halves onto the diameter along the x-axis: the upper and the lower
// open arcs and the open interval of the diameter, bold, with arrowheads at
// their ends; thin arrows project the points of the upper and of the lower
// arc at the abscissas `upper`, `lower` (in radii) onto the diameter. The
// arrows are named `upper-k`, `lower-k`.
#let half-circle-charts(radius, upper, lower) = {
  import cetz.draw: *
  let open-ends = (stroke: thick-line, mark: (start: "stealth", end: "stealth"))
  for start in (0deg, 180deg) {
    arc(
      (0, 0),
      start: start,
      delta: 180deg,
      radius: radius,
      anchor: "origin",
      ..open-ends,
    )
  }
  line((-radius, 0), (radius, 0), ..open-ends)
  for (side, abscissas) in (("upper", upper), ("lower", lower)) {
    let sign = if side == "upper" { 1 } else { -1 }
    for (k, u) in abscissas.enumerate() {
      arrowed(
        (u * radius, sign * radius * calc.sqrt(1 - u * u)),
        (u * radius, 0),
        name: side + "-" + str(k),
      )
    }
  }
}

// Figure 1: the atlas of four charts of the circle x² + y² = 1. Left,
// φ₁, φ₂ project the upper and the lower halves U₁, U₂ onto the x-axis;
// right, φ₃, φ₄ project the right and the left halves U₃, U₄ onto the
// y-axis: the same construction turned by a right angle.
#let fig-3-1() = slim-drawing({
  import cetz.draw: *
  let radius = 10.45
  let centre = (31.71, 0)
  let on-circle(at, turn) = (rel: (turn, radius), to: at)
  plane-axes(x-start: -radius, y-start: -15, 16.75, 16.35, origin-name: none)
  group(name: "left", half-circle-charts(
    radius,
    (-0.47, -0.24, 0.77),
    (0.11, 0.39),
  ))
  content(on-circle((0, 0), 60deg), $U_1$, anchor: "south-west")
  content(on-circle((0, 0), -50deg), $U_2$, anchor: "north-west")
  content("left.upper-0.mid", $phi_1$, anchor: "east")
  content("left.lower-1.mid", $phi_2$, anchor: "west")
  content((0, 0), $V_1 class("normal", =) V_2$, anchor: "north-east")
  group({
    translate(centre)
    plane-axes(x-start: -12.95, y-start: -15, 16.75, 16.35, origin-name: none)
    group(name: "right", {
      rotate(90deg)
      half-circle-charts(radius, (-0.29, -0.52), (0.37, 0.10))
    })
    content(on-circle((0, 0), 38deg), $U_3$, anchor: "south-west")
    content(on-circle((0, 0), 142deg), $U_4$, anchor: "south-east")
    content("right.lower-0.mid", $phi_3$, anchor: "south")
    content("right.upper-0.mid", $phi_4$, anchor: "south")
    content((0, 0), $V_3 class("normal", =) V_4$, anchor: "south-east")
  })
})

// Figure 2: the charts U₁ (upper half) and U₃ (right half) of the circle
// and their overlap U₁ ∩ U₃. The circle is thin; U₁ is drawn as an arc
// outside it, U₃ inside, the overlap on it; a point of the overlap has both
// coordinates x₁ = φ₁(P) and x₃ = φ₃(P).
#let fig-3-2() = slim-drawing({
  import cetz.draw: *
  let radius = 11.56
  // How far the arcs of U₁ and U₃ stand off the circle.
  let gap = 1.65
  let open-arc(size, start, delta) = arc(
    (0, 0),
    start: start,
    delta: delta,
    radius: size,
    anchor: "origin",
    stroke: thick-line,
    mark: (start: "stealth", end: "stealth"),
  )
  plane-axes(x-start: -15.41, y-start: -14.99, 19.01, 18.08, origin-name: none)
  circle((0, 0), radius: radius)
  open-arc(radius + gap, 0deg, 180deg)
  open-arc(radius - gap, -90deg, 180deg)
  open-arc(radius, 90deg, -90deg)
  let point = (45deg, radius)
  arrowed(point, (point, "|-", (0, 0)), name: "phi1")
  arrowed(point, (point, "-|", (0, 0)), name: "phi3")
  content((120deg, radius + gap), $U_1$, anchor: "south-east")
  content((50deg, radius + gap), $U_1 inter U_3$, anchor: "south-west")
  content((-37deg, radius - gap), $U_3$, anchor: "east")
  content("phi1.end", $phi_1$, anchor: "south-east")
  content("phi3.end", $phi_3$, anchor: "north-west")
})

// The chart of the circle of radius `radius` that leaves out the point at
// the angle `missing`: the circle with arrowheads on either side of the gap,
// the point left out as a small ring, the angle φ of a point at 45°
// (its arc at three quarters of the radius, its label at half).
#let angle-chart(radius, missing, label) = {
  import cetz.draw: *
  let hole = spot-radius / 2 / 1mm
  let opening = hole / radius * 1rad
  plane-axes(x-start: -15.3, y-start: -15, 19, 18, origin-name: none)
  arc(
    (0, 0),
    start: missing + opening,
    delta: 360deg - 2 * opening,
    radius: radius,
    anchor: "origin",
    mark: (start: "stealth", end: "stealth"),
  )
  circle((missing, radius), radius: hole, fill: white)
  let point = (45deg, radius)
  line((0, 0), point)
  cetz.angle.angle(
    (0, 0),
    (1, 0),
    point,
    radius: 0.75 * radius,
    label-radius: 0.5 * radius,
    label: $phi$,
    mark: (end: "stealth"),
  )
  content(point, label, anchor: "south-west")
}

// Figure 3: the charts U₁ = S¹ ∖ {(−1, 0)} and U₂ = S¹ ∖ {(1, 0)} with the
// polar angle φ as the coordinate.
#let fig-3-3() = slim-drawing({
  import cetz.draw: *
  let radius = 11.47
  angle-chart(radius, 180deg, $U_1$)
  group({
    translate((0, -34.69))
    angle-chart(radius, 0deg, $U_2$)
  })
})

// Figure 4: the charts φ₁ ∈ (−π, π) and φ₂ ∈ (0, 2π) of the circle by the
// polar angle, as pieces of the helix (cos φ, sin φ, φ) over the circle on
// the cylinder S¹ × ℝ, φ up; the discs at φ = −π and φ = 2π carry the axes
// x, y. Where the charts overlap (0 < φ < π, y > 0) φ₁ is drawn a little
// higher to keep the two apart; their open ends carry arrowheads. Dashed:
// the parts hidden by the cylinder, seen as a solid, and the generators
// over the points left out, (−1, 0) up to the end of φ₁ and (1, 0) through.
#let fig-3-4() = slim-drawing({
  import cetz.draw: *
  let radius = 11.92
  // Millimetres of height per radian of φ, the discs, the lift of φ₁.
  let pitch = 3.947
  let (bottom, top) = (-calc.pi * pitch, 2 * calc.pi * pitch)
  let lift = 0.64
  let view = orthographic(45deg, 30.3deg)
  let at = view.project
  let (tx, ty, tz) = view.toward
  // Whether the line of sight from p towards the viewer passes through
  // the solid cylinder.
  let seen((x, y, z)) = {
    let a = tx * tx + ty * ty
    let b = x * tx + y * ty
    let d = b * b - a * (x * x + y * y - radius * radius)
    if d <= 0 { return true }
    let enter = calc.max((-b - calc.sqrt(d)) / a, (bottom - z) / tz, 1e-4)
    let leave = calc.min((-b + calc.sqrt(d)) / a, (top - z) / tz)
    enter >= leave
  }
  let on-cylinder(t, z) = (radius * calc.cos(t), radius * calc.sin(t), z)
  let rim(z) = sample(t => on-cylinder(t, z), 0, 2 * calc.pi, n: 240)
  // The axes x, y in the discs, the φ-axis, the outline of the cylinder.
  for z in (bottom, top) {
    for (u, v) in ((1, 0), (0, 1)) {
      seen-hidden(at, seen, sample(
        s => (s * u, s * v, z),
        -22.46,
        22.46,
        n: 400,
      ))
    }
  }
  seen-hidden(at, seen, rim(bottom))
  line(..rim(top).map(at), close: true)
  for t in (45deg, 225deg) {
    line(at(on-cylinder(t, bottom)), at(on-cylinder(t, top)))
  }
  seen-hidden(at, seen, sample(z => (0, 0, z), bottom - 12.06, top, n: 400))
  arrowed(at((0, 0, top)), at((0, 0, top + 13.39)), name: "phi")
  // The generators over (−1, 0) and (1, 0).
  line(
    at(on-cylinder(180deg, bottom)),
    at(on-cylinder(180deg, calc.pi * pitch + lift)),
    ..hidden,
  )
  line(at(on-cylinder(0deg, bottom)), at(on-cylinder(0deg, top)), ..hidden)
  // The charts on the helix, bold where seen, with arrowheads at both open
  // ends.
  let helix(raise) = t => on-cylinder(t * 1rad, pitch * t + raise)
  let chart(from, to, raise) = {
    let point = helix(raise)
    seen-hidden(at, seen, sample(point, from, to, n: 360), stroke: thick-line)
    let step = 0.05
    mark(at(point(from + step)), at(point(from)), symbol: "stealth")
    mark(at(point(to - step)), at(point(to)), symbol: "stealth")
  }
  chart(-calc.pi, calc.pi, lift)
  chart(0, 2 * calc.pi, 0)
  content(at((22.46, 0, bottom)), $x$, anchor: "north-east")
  content(at((0, 22.46, bottom)), $y$, anchor: "north-east")
  content("phi.end", $phi$, anchor: "north-east")
  content(at(helix(lift)(-0.4)), $phi_1$, anchor: "south")
  content(at(helix(0)(4.95)), $phi_2$, anchor: "north")
})

// Figure 5: two charts of a manifold M and the change of coordinates. The
// domains U_i, U_j in M, their images V_i = φ_i(U_i), V_j = φ_j(U_j) in ℝⁿ
// and the overlaps are ovals (ellipses, given by centre, semi-axes and the
// turn of the first axis); the stippled parts are the common parts of two
// of them: U_ij = U_i ∩ U_j, and V_ji = φ_j(U_ij), V_ij = φ_i(U_ij) cut off
// V_j and V_i by a disc each. A point of U_ij goes to x⃗_j ∈ V_ji and to
// x⃗_i ∈ V_ij, linked by the change of coordinates x⃗_i = x⃗_i(x⃗_j). Each
// space is framed by a corner of its own; the maps cross from one to the
// other, labelled midway between the frames.
#let fig-3-5() = slim-drawing({
  import cetz.draw: *
  // A point (u, v) of an oval in units of its semi-axes along its axes.
  let oval-point((centre, a, b, turn), u, v) = (
    centre.at(0) + a * u * calc.cos(turn) - b * v * calc.sin(turn),
    centre.at(1) + a * u * calc.sin(turn) + b * v * calc.cos(turn),
  )
  let boundary(oval) = range(360).map(k => oval-point(
    oval,
    calc.cos(k * 1deg),
    calc.sin(k * 1deg),
  ))
  let contains((centre, a, b, turn), p) = {
    let (dx, dy) = (p.at(0) - centre.at(0), p.at(1) - centre.at(1))
    let u = (dx * calc.cos(turn) + dy * calc.sin(turn)) / a
    let v = (dy * calc.cos(turn) - dx * calc.sin(turn)) / b
    u * u + v * v <= 1
  }
  let centroid(points) = (
    points.map(z => z.at(0)).sum() / points.len(),
    points.map(z => z.at(1)).sum() / points.len(),
  )
  // The common part of two ovals: the points of either boundary inside the
  // other, in the order of their angle about the centroid.
  let meet(p, q) = {
    let points = (
      boundary(p).filter(contains.with(q))
        + boundary(q).filter(contains.with(p))
    )
    let (cx, cy) = centroid(points)
    points.sorted(key: ((x, y)) => calc.atan2(x - cx, y - cy))
  }
  let u-i = ((-15.36, 14.08), 10.58, 8.24, 57.5deg)
  let u-j = ((-12.43, 29.11), 12.96, 6.49, 69.8deg)
  let v-i = ((22.78, 8.89), 10.83, 7.08, 0deg)
  let v-j = ((22.78, 30.06), 10.93, 10.93, 0deg)
  let u-ij = meet(u-i, u-j)
  let v-ji = meet(v-j, ((24.76, 14.44), 12.51, 12.51, 0deg))
  let v-ij = meet(v-i, ((22.40, 20.33), 10.21, 10.21, 0deg))
  // The images x⃗_j ∈ V_ji and x⃗_i ∈ V_ij of a point of U_ij.
  let (x-j, x-i) = ((22.95, 24.32), (22.95, 12.34))
  // The stippled parts with their labels in cut-outs (those of V_ji and
  // V_ij beside the ends of the change of coordinates), then the outlines.
  for part in (u-ij, v-ji, v-ij) {
    line(..part, close: true, fill: stipple, stroke: none)
  }
  content(centroid(u-ij), cutout($U_(i j)$))
  content((x-j, 8%, x-i), cutout($V_(j i)$), anchor: "west")
  content((x-j, 92%, x-i), cutout($V_(i j)$), anchor: "west")
  for oval in (u-i, u-j, v-i, v-j) { line(..boundary(oval), close: true) }
  for part in (v-ji, v-ij) { line(..part, close: true) }
  content(oval-point(u-j, 0.71, 0.02), $U_j$)
  content(oval-point(u-i, -0.69, -0.19), $U_i$)
  content(oval-point(v-j, 0.42, 0.57), $V_j$)
  content(oval-point(v-i, 0.42, -0.56), $V_i$)
  // The frames: M with its corner at the origin, ℝⁿ to the right.
  let corner = (7.98, 0)
  line((0, 37.87), (0, 0), (-23.83, 0))
  line((corner.at(0), 36), corner, (32.68, 0))
  content((0, 0), $M$, anchor: "south-east")
  content(corner, $RR^n$, anchor: "south-west")
  let maps = (
    ((-9.57, 30.33), (21.67, 35.54), $phi_j$),
    ((-12.36, 22.50), x-j, $phi_j$),
    ((-12.91, 19.62), x-i, $phi_i$),
    ((-9.31, 14.46), (18.67, 5.91), $phi_i$),
  )
  let midway = corner.at(0) / 2
  for (from, to, name) in maps {
    arrowed(from, to)
    let t = (midway - from.at(0)) / (to.at(0) - from.at(0))
    content(
      (midway, from.at(1) + t * (to.at(1) - from.at(1))),
      name,
      anchor: "south",
    )
  }
  line(x-j, x-i, mark: (start: "stealth", end: "stealth"))
  content(
    (26.2, 17.44),
    $arrow(x)_i = arrow(x)_i lr((arrow(x)_j))$,
    anchor: "west",
  )
})
