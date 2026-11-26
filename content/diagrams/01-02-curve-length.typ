// Figures of chapter 1, § 2. Each is a function called by the text:
// `#fig(fig-1-12()) <fig:…>`.
#import "common.typ": *

// Figure 12: the angle between two curves at a point P where one of them
// has a corner. The bold γ₁ comes in along `incoming` and leaves along
// `outgoing`: its two one-sided tangents (the arrows ?) make two different
// angles with the tangent γ̇₂ of the smooth curve γ₂ (along `smooth`), both
// stippled. γ₂ is the cubic s ↦ P + s e + (a s² + b s³) n over its tangent
// line, e and n the unit tangent and normal.
#let fig-1-12() = drawing({
  import cetz.draw: *
  let (incoming, outgoing, smooth) = (30.5deg, -58deg, -13.7deg)
  // The drawn length of the one-sided tangents.
  let unit = 13.7
  let bold = 3 * thick-line
  let head(width) = (
    end: "stealth",
    length: 5.5,
    width: width,
    inset: 1.6,
    stroke: thin-line,
  )
  cetz.angle.angle(
    (0, 0),
    (smooth, 1),
    (incoming, 1),
    fill: stipple,
    radius: 7.2,
  )
  cetz.angle.angle(
    (0, 0),
    (outgoing, 1),
    (smooth, 1),
    fill: stipple,
    radius: 5.1,
  )
  let (e, n) = ((smooth, 1), (smooth + 90deg, 1)).map(((a, r)) => (
    r * calc.cos(a),
    r * calc.sin(a),
  ))
  let (a, b) = (0.0117, 0.0004)
  let curve(s) = {
    let h = a * s * s + b * s * s * s
    (s * e.at(0) + h * n.at(0), s * e.at(1) + h * n.at(1))
  }
  let (from, to) = (-18.1, 17.5)
  brush-stroke(sample(curve, from, to), u => (
    0.45 + 0.5 * calc.pow(2 * u - 1, 2)
  ))
  arrowed((0, 0), (smooth, 16.1), name: "velocity")
  line((incoming + 180deg, 19.7), (0, 0), stroke: (
    thickness: bold,
    cap: "butt",
  ))
  line((0, 0), (incoming, unit), mark: head(2))
  line((0, 0), (outgoing, unit), stroke: bold, mark: head(2.8))
  circle((0, 0), radius: 0.85, fill: white, stroke: thick-line)
  content((incoming, 11.4), $?$, anchor: "south-east", padding: 0.8)
  content((outgoing, 10.2), $?$, anchor: "west", padding: 2.2)
  content(
    (incoming + 180deg, 13),
    $gamma_1 lr((t))$,
    anchor: "south-east",
    padding: 1,
  )
  content(curve(to - 1.2), $gamma_2 lr((tau))$, anchor: "south", padding: 1.8)
  content("velocity.end", $dot(gamma)_2$, anchor: "north", padding: 1.4)
})

// Figure 13: a smooth curve with a corner, γ(t) = (x(t), y(t)) with
// x(t) = f(t), y(t) = f(−t), where f(t) = e^(t − 1/(2t)) for t > 0 and
// f(t) = 0 for t ≤ 0: f vanishes at 0 with all its derivatives, so γ is
// smooth and turns through π/2 at the origin. The graphs of x and y on
// [−t-max, t-max] and the image of γ, side by side with gaps `gap`.
#let fig-1-13() = drawing({
  import cetz.draw: *
  // The drawn lengths of a unit of t and of a unit of value.
  let (t-unit, value-unit, t-max) = (4.1, 0.74, 3.2)
  let flat(t) = if t > 0 { calc.exp(t - 1 / (2 * t)) } else { 0 }
  // The axes run `reach` past the curves; `gap` parts the panels.
  let (reach, gap) = (4, 4.3)
  let side = t-max * t-unit
  let top = value-unit * flat(t-max)
  let bold = (stroke: (thickness: 3 * thick-line, join: "miter"))
  let graph(f, name) = {
    arrowed((-side, 0), (side + reach, 0))
    arrowed((0, -reach), (0, top + reach))
    line(..sample(t => (t * t-unit, value-unit * f(t)), -t-max, t-max), ..bold)
    content((0, top + reach), name, anchor: "north-west")
    content((side + reach, 0), $t$, anchor: "north-east")
  }
  graph(flat, $x lr((t))$)
  translate((2 * side + reach + gap, 0))
  graph(t => flat(-t), $y lr((t))$)
  translate((side + 2 * reach + gap, 0))
  arrowed((-reach, 0), (top + reach, 0))
  arrowed((0, -reach), (0, top + reach))
  line(
    ..sample(t => (value-unit * flat(t), value-unit * flat(-t)), -t-max, t-max),
    ..bold,
  )
  content((0, top + reach), $y$, anchor: "north-west")
  content((top + reach, 0), $x$, anchor: "north-east")
  content(
    (0, 0.58 * top),
    $gamma lr((t)) = lr((x lr((t)), y lr((t))))$,
    anchor: "west",
    padding: 4.6,
  )
})

// Figure 14: a smooth curve whose corner is the angle π, the cusp
// (x, y) = (−length u², height u⁵), u ∈ [−1, 1]: both branches touch the
// x-axis at the cusp from the same side.
#let fig-1-14() = drawing({
  import cetz.draw: *
  let (length, height) = (16.7, 6.2)
  line(
    ..sample(u => (-length * u * u, height * calc.pow(u, 5)), -1, 1),
    stroke: 2.25 * thick-line,
  )
})

// Figure 15: the coordinate lines z^m = t and z^p = t through a point P and
// their tangent vectors e⃗_m, e⃗_p, whose scalar product is g_mp; the angle
// between them stippled; dashed, a third coordinate line. Each line is the
// parabola t ↦ P + t u + t² w, u its unit tangent at P (at the angle `turn`)
// and w its bend, over [`from`, `to`].
#let fig-1-15() = drawing({
  import cetz.draw: *
  let at(turn, w) = t => (
    t * calc.cos(turn) + t * t * w.at(0),
    t * calc.sin(turn) + t * t * w.at(1),
  )
  let (turn-m, turn-p) = (42.5deg, -16deg)
  let line-m = at(turn-m, (0.0134, -0.0126))
  let line-p = at(turn-p, (-0.0099, -0.0255))
  let third = at(-50deg, (-0.0126, -0.017))
  let curve = (stroke: 1.5 * thin-line)
  let dashed = (stroke: (thickness: 1.5 * thin-line, dash: hidden.stroke.dash))
  cetz.angle.angle(
    (0, 0),
    (turn-p, 1),
    (turn-m, 1),
    fill: stipple,
    radius: 8.9,
    ..curve,
  )
  line(..sample(line-m, -21.8, 21), ..curve)
  line(..sample(line-p, -12.8, 22), ..curve)
  line(..sample(third, -7.6, 19.2), ..dashed)
  arrowed((0, 0), (turn-m, 20), stroke: thick-line, name: "e-m")
  arrowed((0, 0), (turn-p, 23.2), stroke: thick-line, name: "e-p")
  circle((0, 0), radius: 1.2, stroke: 1.5 * thick-line)
  content("e-m.end", $arrow(e)_m$, anchor: "east", padding: 3)
  content("e-p.end", $arrow(e)_p$, anchor: "north-east", padding: 1)
  content(line-m(14), $z^m = t$, anchor: "north-west", padding: 1.5)
  content(line-p(22), $z^p = t$, anchor: "north-west", padding: (
    left: -1.5,
    top: 2.2,
  ))
  content((190deg, 3.6), $P$, anchor: "north-east", padding: 0)
})

// Figure 16: the light cone ⟨ξ⃗, ξ⃗⟩_s = 0 of the pseudo-Euclidean space:
// the double cone about the axis x¹, …, x^s, its radius `slope` times the
// distance along the axis, cut at the distance `reach` on either side.
// Orthographic view, the axis turned towards the viewer by `turn`: the near
// base is a black disc (inside it ⟨ξ⃗, ξ⃗⟩_s < 0), the far base has its hidden
// half dashed. Shading: the front arcs of the cone's circles on the upper
// part of one nappe and the lower part of the other.
#let fig-1-16() = drawing({
  import cetz.draw: *
  let (reach, slope, turn) = (22.3, 0.57, 18deg)
  let view = orthographic(turn, 0deg)
  let at = view.project
  // The circle of the cone at the distance c along the axis; shrunk by
  // `part`, a circle inside it.
  let ring(c, s, part: 1) = {
    let r = part * slope * calc.abs(c)
    (c, r * calc.cos(s), r * calc.sin(s))
  }
  // Where the outline of the cone touches its circles.
  let touch = calc.acos(slope * calc.tan(turn))
  let medium = 1.5 * thin-line
  for k in range(1, 26) {
    let c = k * reach / 26
    let stroke = (thickness: (0.08 + 0.3 * c / reach) * 1mm, cap: "butt")
    line(..sample(s => at(ring(-c, s)), touch, 160deg, n: 30), stroke: stroke)
    line(
      ..sample(s => at(ring(c, s)), touch - 180deg, -175deg, n: 30),
      stroke: stroke,
    )
  }
  for (c, s) in (
    (-reach, touch),
    (-reach, -touch),
    (reach, 180deg - touch),
    (reach, touch - 180deg),
  ) {
    line((0, 0), at(ring(c, s)), stroke: medium)
  }
  // The far base: its visible arc bold, the rest dashed.
  line(..sample(s => at(ring(-reach, s)), touch, 360deg - touch), stroke: (
    thickness: 2 * thick-line,
  ))
  line(..sample(s => at(ring(-reach, s)), -touch, touch), stroke: (
    thickness: thick-line,
    dash: hidden.stroke.dash,
  ))
  // The axis, hidden up to the near base, white across it.
  let (near-left, near-right) = (at(ring(reach, 180deg)), at(ring(reach, 0deg)))
  line(at(ring(-reach, 180deg)), (rel: (-1.7, 0)), stroke: medium)
  line(
    (rel: (1.7, 0)),
    near-left,
    stroke: (
      thickness: medium,
      dash: hidden.stroke.dash,
    ),
  )
  spot((0, 0), radius: 0.85)
  let rim = sample(s => at(ring(reach, s)), 0deg, 360deg)
  line(..rim, close: true, fill: black, stroke: none)
  // Its rim, where ⟨ξ⃗, ξ⃗⟩_s = 0, dotted white inside its edge.
  let inner = sample(s => at(ring(reach, s, part: 0.95)), 0deg, 360deg)
  line(..inner, close: true, stroke: (
    paint: white,
    thickness: 0.3mm,
    dash: "densely-dotted",
  ))
  line(near-left, near-right, stroke: (paint: white, thickness: 0.35mm))
  arrowed(near-right, (rel: (6.6, 0)), stroke: medium, name: "axis")
  // The labels, two of them with leaders.
  content(
    near-right,
    $x^1, dots, x^s$,
    anchor: "north-west",
    padding: (left: 1.1, top: 3.5),
  )
  content((-9.7, 12.3), $lr(|arrow(xi)|)_s > 0$)
  let leader(from, to, control, inside) = {
    let points = sample(
      t => (
        calc.pow(1 - t, 2) * from.at(0)
          + 2 * t * (1 - t) * control.at(0)
          + t * t * to.at(0),
        calc.pow(1 - t, 2) * from.at(1)
          + 2 * t * (1 - t) * control.at(1)
          + t * t * to.at(1),
      ),
      0,
      1,
      n: 60,
    )
    let split = points.position(inside)
    let split = if split == none { points.len() } else { split }
    let head = (end: "stealth", scale: 0.6)
    if split < points.len() {
      line(..points.slice(0, split + 1), stroke: medium)
      line(
        ..points.slice(split),
        stroke: (paint: white, thickness: medium),
        mark: (
          ..head,
          fill: white,
          stroke: white,
        ),
      )
    } else {
      line(..points, stroke: medium, mark: head)
    }
  }
  let in-disc((x, y)) = {
    let (cx, a) = (reach * calc.cos(turn), slope * reach * calc.sin(turn))
    calc.pow((x - cx) / a, 2) + calc.pow(y / (slope * reach), 2) < 0.92
  }
  leader((24.9, 16.5), at(ring(reach, 97deg)), (20.9, 15.9), in-disc)
  content((24.9, 16.5), $lr(|arrow(xi)|)_s = 0$, anchor: "west", padding: 0.6)
  leader((23.8, -15.5), (21.4, -6.8), (24.2, -10.6), in-disc)
  content((23.8, -15.5), $lr(|arrow(xi)|)_s < 0$, anchor: "north", padding: 0.6)
})

// Figure 17: world lines in the plane (t, x) of special relativity, time to
// the right, in units of `half` mm: the light rays x ± t = c for even c
// across a square of side `cells`, and at four points of the world lines,
// lattice vertices, their future light cones along the rays, the inside
// stippled up to the time `slice` after the point. The upper world line is
// timelike throughout; the lower one turns back in time, its tangent at its
// marked point outside the cone. The world lines are free-hand: smooth
// curves through a few points.
#let fig-1-17() = drawing({
  import cetz.draw: *
  let (half, cells, slice) = (3.51, 14, 1.6)
  let at((t, x)) = (t * half, x * half)
  let ray = (stroke: thick-line)
  let bold = (stroke: 1.5 * thick-line)
  for c in range(2, 2 * cells, step: 2) {
    let (from, to) = (calc.max(0, c - cells), calc.min(c, cells))
    line(at((from, c - from)), at((to, c - to)), ..ray)
  }
  for c in range(2 - cells, cells, step: 2) {
    let (from, to) = (calc.max(0, c), calc.min(cells, cells + c))
    line(at((from, from - c)), at((to, to - c)), ..ray)
  }
  let points = ((2, 8), (5, 9), (10, 10), (9, 5))
  for (t, x) in points {
    line(
      at((t, x)),
      at((t + slice, x + slice)),
      at((t + slice, x - slice)),
      close: true,
      fill: stipple,
      stroke: none,
    )
  }
  hobby(
    ..(
      (1.3, 7.85),
      (2, 8),
      (3.55, 8.35),
      (5, 9),
      (7.75, 9.45),
      (10, 10),
      (11.85, 9.35),
      (13.8, 8.9),
    ).map(at),
    ..bold,
  )
  hobby(
    ..(
      (3.2, 3.75),
      (5.4, 4.5),
      (7.85, 6),
      (8.85, 6.45),
      (9.4, 5.95),
      (9, 5),
      (7.95, 2.55),
      (7.85, 1.4),
      (8.85, 1.15),
      (11.1, 1.9),
    ).map(at),
    ..bold,
  )
  for (t, x) in points {
    for side in (1, -1) {
      line(at((t, x)), at((t + 2, x + 2 * side)), ..bold, mark: (
        end: "stealth",
        stroke: thin-line,
      ))
    }
    spot(at((t, x)), radius: 0.8)
  }
})
