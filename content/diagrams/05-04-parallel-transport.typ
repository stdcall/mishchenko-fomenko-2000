// Figures of chapter 5, § 4. Each is a function called by the text:
// `#fig(fig-5-11()) <fig:…>`.
#import "common.typ": *

// A thin square plate of `half` its side and of `depth`, its face in the
// plane through `centre` spanned by the unit vectors u, v, its thickness
// along −n (n = u × v, towards the viewer), under the view `view`: the side
// faces seen are black, the face stippled. Gives the drawing `body` and
// the outline `face` of the face on the page.
#let tangent-plate(view, centre, u, v, half, depth) = {
  let at = view.project
  let n = vec-cross(u, v)
  let point(a, b, c) = range(3).map(i => (
    centre.at(i) + a * u.at(i) + b * v.at(i) - c * n.at(i)
  ))
  let corners = ((1, 1), (-1, 1), (-1, -1), (1, -1))
  let face = corners.map(((a, b)) => at(point(half * a, half * b, 0)))
  // The side between corners i and i + 1 and its outward normal.
  let body = for (i, (a, b)) in corners.enumerate() {
    let (c, d) = corners.at(calc.rem(i + 1, 4))
    let outward = range(3).map(k => (a + c) * u.at(k) + (b + d) * v.at(k))
    if vec-dot(outward, view.toward) > 0 {
      cetz.draw.line(
        at(point(half * a, half * b, 0)),
        at(point(half * c, half * d, 0)),
        at(point(half * c, half * d, depth)),
        at(point(half * a, half * b, depth)),
        close: true,
        fill: black,
      )
    }
  }
  body += cetz.draw.line(..face, close: true, fill: white)
  body += cetz.draw.line(..face, close: true, fill: stipple)
  (body: body, face: face)
}

// Figure 11: parallel transport in ℝⁿ does not depend on the path. A vector
// a⃗ standing at P is carried, parallel to itself, along two paths γ from P
// to Q (bold, free-hand curves through a few points, one with a loop), and
// gives the same a⃗(1) at Q. The parallel vectors are seen in perspective:
// each lies on the line from its foot b to the vanishing point V, its tip
// at V + μ(b − V); so the tips (dashed) trace the images of the paths under
// the homothety about V. The arrows of the near path pass over the far
// one. A man carries the vector along the far path (a drawing).
#let fig-5-11() = drawing({
  import cetz.draw: *
  let (p, q) = ((0, 0), (69, 0.7))
  let far-path = (
    p,
    (6.7, 2.2),
    (13, 3.5),
    (25.7, 5.4),
    (38.4, 6.1),
    (52.5, 4.7),
    (65.2, 1.9),
    q,
  )
  let near-path = (
    p,
    (6.7, 0.3),
    (13, -0.1),
    (19.4, -1.6),
    (24.9, -4.1),
    (28.5, -6.9),
    (32.1, -11.3),
    (35.5, -17.7),
    (36.1, -21.9),
    (35.9, -26.1),
    (34.2, -29.9),
    (31.9, -31.4),
    (29.3, -29.5),
    (28.3, -26.1),
    (28.5, -23.2),
    (30, -20),
    (33.8, -13.4),
    (38.4, -9.7),
    (45.5, -5.2),
    (52.5, -2),
    (59.6, -0.2),
    q,
  )
  let (v, mu) = ((34.9, -107.8), 110.8%)
  let tip(b) = (v, mu, b)
  // The arrows of a path: `count` of them, evenly spaced along it.
  let head = (end: "stealth", length: 2.4, width: 1.1, inset: 0.7)
  let field(name, count, over: false) = {
    for k in range(count) {
      let foot = (name: name, anchor: k / (count - 1) * 100%)
      if over { bridge((foot, tip(foot)), gap: 0.9) }
      line(foot, tip(foot), mark: head)
    }
  }
  hobby(..far-path.map(tip), ..hidden)
  hobby(..near-path.map(tip), ..hidden)
  hobby(..far-path, stroke: 2 * thick-line, name: "far")
  field("far", 15)
  hide(hobby(..near-path, name: "near"))
  field("near", 35, over: true)
  hobby(..near-path, stroke: 2 * thick-line)
  // The rising branch of the loop passes over the falling one.
  let crossing = range(64, 71).map(k => (name: "near", anchor: k * 1%))
  bridge(crossing, gap: 1.6)
  line(..crossing, stroke: 2 * thick-line)
  spot(p, radius: 1)
  spot(q, radius: 1)
  // The man walks at the middle of the far path holding its middle arrow.
  book-picture(
    "/assets/figures/05-11-walker.svg",
    6.52,
    corner: (rel: (-6.48, 6.82), to: (name: "far", anchor: 50%)),
    anchor: "north-west",
  )
  content(tip(p), $arrow(a)$, anchor: "south")
  content(
    tip((name: "far", anchor: 13 / 14 * 100%)),
    $arrow(a)(1)$,
    anchor: "south",
  )
  content(p, $gamma(0) = P$, anchor: "north", padding: 1.6)
  content(q, $Q = gamma(1)$, anchor: "north", padding: 1.6)
})

// Figure 12: transport by projection on a surface M² ⊂ ℝ³: a⃗ ∈ T_P M²
// carried along γ in ℝ³ gives b⃗ at Q, projected to πb⃗ ∈ T_Q M². A drawing
// of a bent sheet; the labels over it, at the points they name (mm from
// its top left corner).
#let fig-5-12() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/05-12-tangent-planes.svg",
    66.72,
    anchor: "north-west",
  )
  for (x, y, label) in (
    (61.91, 0.49, cutout($M^2 subset RR^3$)),
    (21.51, 7.32, $P$),
    (34.65, 7.37, cutout($gamma$)),
    (50.65, 9.12, $Q$),
    (12.47, 15.47, $arrow(a)$),
    (54.08, 15.39, $arrow(b)$),
    (46.31, 22.25, $pi arrow(b)$),
    (20.19, 21.65, cutout($T_P M^2$)),
    (51.35, 30.46, cutout($T_Q M^2$)),
  ) {
    content((x, -y), label)
  }
})

// Figure 13: transport by projection fails on the sphere S²: the vector a⃗
// at the pole P, tangent to the meridian γ, carried in ℝ³ along γ to the
// point Q of the equator is the normal b⃗ of S² there, so πb⃗ = 0. The
// sphere of `radius` in the orthographic view, the axes through P and
// through a point of the equator a quarter turn from Q, the tangent plates
// at P and Q; the vectors at `count` points of γ end on its translate
// (dashed), and the outline behind them is dashed. Hand shading strokes
// run along the lower left limb.
#let fig-5-13() = drawing({
  import cetz.draw: *
  let (radius, length, count) = (22, 35.6, 7)
  let view = orthographic(31deg, 30deg)
  let at = view.project
  let meridian(t) = (radius * calc.sin(t), 0, radius * calc.cos(t))
  let (pole, q, front) = ((0, 0, radius), (radius, 0, 0), (0, -radius, 0))
  let carried(p) = (p.at(0) + length, p.at(1), p.at(2))
  let path = sample(meridian, 0deg, 90deg, n: 90)
  let ribbon = path.map(at) + path.rev().map(p => at(carried(p)))
  // The outline, dashed behind the vectors; the shading strokes, from
  // horizontal on the left to a slant at the bottom.
  seen-hidden(
    p => p,
    p => not inside-polygon(p, ribbon),
    sample(s => (s, radius), 0deg, 360deg, n: 360),
  )
  for k in range(27) {
    let s = 140deg + k * 5.5deg
    let r = radius * (0.82 + 0.1 * (s - 140deg) / 145deg)
    let slant = (s - 180deg) * 0.2
    let middle = (s, r)
    line(
      (rel: (slant + 180deg, 1.1), to: middle),
      (rel: (slant, 1.1), to: middle),
    )
  }
  let plate-p = tangent-plate(view, pole, (1, 0, 0), (0, 1, 0), 7.7, 0.8)
  plate-p.body
  line(at(pole), (0, 0), ..hidden)
  line((0, 0), at(front), ..hidden)
  line(at(pole), at((0, 0, 1.45 * radius)))
  line(at(front), at((0, -1.9 * radius, 0)))
  line((0, 0), at(q), ..hidden)
  let plate-q = tangent-plate(view, q, (0, 1, 0), (0, 0, 1), 6.6, 0.8)
  plate-q.body
  seen-hidden(
    at,
    p => not inside-polygon(at(p), plate-q.face),
    path,
    stroke: 2 * thick-line,
  )
  mark(at(meridian(44deg)), at(meridian(46deg)), symbol: "stealth")
  line(..path.map(p => at(carried(p))), ..hidden)
  for k in range(count) {
    let p = meridian(k * 90deg / (count - 1))
    arrowed(at(p), at(carried(p)), name: "vector-" + str(k))
  }
  content((165deg, radius), $S^2$, anchor: "east")
  content(at(pole), cutout($P$), anchor: "east", padding: 1.4)
  content(at(q), cutout($Q$), anchor: "north", padding: 1.2)
  for p in (pole, q, front, (0, 0, 0)) { spot(at(p), radius: 0.8) }
  content(at(meridian(45deg)), $gamma$, anchor: "east", padding: 2)
  content("vector-0.end", $arrow(a)$, anchor: "south-west")
  content("vector-6.end", $arrow(b)$, anchor: "north-west")
  content("vector-6.60%", $pi arrow(b) = 0$, anchor: "north")
})

// Figure 14: transport along the central circle of the Möbius band depends
// on the path. The band is a rectangle whose sides c are glued with
// opposite orientations (the arrows on them); its central line runs
// through Q and P. Left, the band with the paths γ₁ from P to Q and γ₂ from
// P through the glued sides to Q. Right, enlarged: the vector a⃗ at P
// carried along γ₁ arrives at Q pointing up, along γ₂ pointing down (the
// field below the line, white, between the line and its translate,
// dashed). Three men carry the vectors (drawings).
#let fig-5-14() = drawing({
  import cetz.draw: *
  // A band of `width` and `height`, its corner at `corner`, the points Q
  // and P at `q` and `p` along its central line, `side` the width of its
  // sides; the labels of the paths above or below the line.
  let band(corner, width, height, q, p, side, path-labels) = {
    let (x0, y0) = corner
    let mid = y0 + height / 2
    let along(x) = (x0 + x, mid)
    rect(corner, (rel: (width, height)))
    let head = (end: "stealth", length: 3, width: 1.6, inset: 0.9)
    line((x0, y0), (x0, y0 + height), stroke: side, mark: head)
    line(
      (x0 + width, y0 + height),
      (x0 + width, y0),
      stroke: side,
      mark: head,
    )
    content((x0, y0 + height), $c$, anchor: "south-east")
    content((x0 + width, y0), $c$, anchor: "north-west")
    line(along(0), along(width))
    // The paths: γ₂ from the left side to Q, γ₁ from P to Q, γ₂ from P to
    // the right side; a mark at the middle of each.
    for ((from, to), (label, below)) in (
      ((0, q), path-labels.at(0)),
      ((p, q), path-labels.at(1)),
      ((p, width), path-labels.at(2)),
    ) {
      let (a, b) = ((from + to) / 2, (from + to) / 2 + (to - from) / 100)
      mark(along(a), along(b), symbol: "stealth", length: 2.2, width: 1.2)
      content(
        along(a),
        cutout(label),
        anchor: if below { "north" } else { "south" },
        padding: 1.4,
      )
    }
  }
  let small = (-32.6, 22.4)
  rect(small, (rel: (27.9, 14.6)), fill: stipple, stroke: none)
  band(small, 27.9, 14.6, 11, 18.2, 2 * thick-line, (
    ($gamma_2$, true),
    ($gamma_1$, true),
    ($gamma_2$, true),
  ))
  for (x, label) in ((11, $Q$), (18.2, $P$)) {
    let point = (rel: (x, 7.3), to: small)
    spot(point, radius: 0.9)
    content(point, cutout(label), anchor: "south", padding: 1.6)
  }
  // The enlarged band, the vector a⃗ of `size`, the field at a `step` of
  // an eighth of PQ.
  let (width, height, q, p, size) = (65.2, 28.6, 21.2, 41.1, 9.7)
  let mid = height / 2
  let step = (p - q) / 8
  rect((0, 0), (width, height), fill: stipple, stroke: none)
  rect((q, mid), (width, mid + size), fill: white, stroke: none)
  rect((0, mid - size), (q, mid), fill: white, stroke: none)
  line((q, mid + size), (width, mid + size), ..hidden)
  line((0, mid - size), (q, mid - size), ..hidden)
  band(
    (0, 0),
    width,
    height,
    q,
    p,
    thick-line,
    (
      ($gamma_2$, false),
      ($gamma_1$, true),
      ($gamma_2$, true),
    ),
  )
  // The men: each holds the arrow at the `index`-th step up (+) or down
  // (−) from Q; their drawings, the foot of that arrow in them (mm from
  // the top left corner), and the stretch of the line they cover.
  let men = (
    ("hanging", -4, (4.32, -0.3), 4.02),
    ("left", 1, (-0.42, 5.46), 4.87),
    ("right", 12, (6.18, 5.46), 5.97),
  )
  let covered(x) = men.any(((name, index, (fx, fy), w)) => {
    let left = q + index * step - fx
    x > left - 0.5 and x < left + w + 0.5 and calc.abs(x - left - fx) > 0.01
  })
  let field-head = (end: "stealth", length: 2, width: 1, inset: 0.6)
  for k in range(1, 18) {
    let x = q + k * step
    if x < width and not covered(x) {
      line((x, mid), (x, mid + size), mark: field-head)
    }
  }
  for k in range(1, 9) {
    let x = q - k * step
    if x > 0 and not covered(x) {
      line((x, mid), (x, mid - size), mark: field-head)
    }
  }
  let bold = (
    stroke: 2 * thick-line,
    mark: (
      end: "stealth",
      length: 3.6,
      width: 1.8,
      inset: 1,
    ),
  )
  line((q, mid), (q, mid + size), ..bold)
  line((q, mid), (q, mid - size), ..bold)
  line((p, mid), (p, mid + size), ..bold, name: "a")
  for (name, index, (fx, fy), w) in men {
    book-picture(
      "/assets/figures/05-14-man-" + name + ".svg",
      w,
      corner: (q + index * step - fx, mid + fy),
      anchor: "north-west",
    )
  }
  spot((q, mid), radius: 1)
  spot((p, mid), radius: 1)
  content((q, mid), cutout($Q$), anchor: "south-east", padding: 1.2)
  content((p, mid), cutout($P$), anchor: "north", padding: 1.6)
  content("a.end", cutout($arrow(a)$), anchor: "south-west")
})

// Figure 15: parallel transport along a piecewise smooth curve with a
// corner at A: the arc from P to A and the arc through A, B and Q (bold).
// The vector a⃗ at P is carried along the first arc to b⃗ at A, parallel to
// it; b⃗ starts a new parallel field along the second arc, which turns by
// `turn` on the way to Q. The vectors, of length `size`, are drawn at even
// steps along each arc; those at P, A and Q bold.
#let fig-5-15() = drawing({
  import cetz.draw: *
  let (p, a, b, q) = ((0, 0), (24.1, 24), (35.6, 13.6), (43.7, -9))
  let (size, turn) = (12.1, -8deg)
  let bold-head = (end: "stealth", length: 3.6, width: 1.8, inset: 1)
  let bold = (stroke: 2 * thick-line, mark: bold-head)
  let head = (end: "stealth", length: 2.4, width: 1.2, inset: 0.7)
  hide({
    arc-through(p, (12, 14.4), a, name: "first")
    arc-through(a, b, q, name: "second")
  })
  // The thin vectors along an arc, `steps` between its ends, turned by
  // `angle(u)` at the fraction u of the way.
  let field(name, steps, angle) = {
    for k in range(1, steps) {
      let u = k / steps
      let foot = (name: name, anchor: u * 100%)
      line(foot, (rel: (90deg + angle(u), size), to: foot), mark: head)
    }
  }
  field("first", 13, u => 0deg)
  field("second", 12, u => u * turn)
  arc-through(p, (12, 14.4), a, stroke: 2 * thick-line)
  arc-through(a, b, q, stroke: 2 * thick-line)
  line(p, (rel: (0, size)), ..bold, name: "a")
  line(a, (rel: (0, size)), ..bold, name: "b")
  line(q, (rel: (90deg + turn, size)), ..bold)
  for point in (p, a, b, q) { spot(point, radius: 1) }
  content("a.70%", $arrow(a)$, anchor: "east", padding: 1.6)
  content("b.end", $arrow(b)$, anchor: "south-west", padding: 0.6)
  content(p, $P$, anchor: "north", padding: 2)
  content(a, $A$, anchor: "north", padding: 2.6)
  content(b, $B$, anchor: "north-east", padding: 1.6)
  content(q, $Q$, anchor: "north-east", padding: 1.6)
})

// Figure 16: along a geodesic γ the parallel field T⃗(t) keeps its length
// and its angle α with the velocity γ̇: at three points of the curve, an
// arc of the circle about `centre` run clockwise (a brush stroke
// narrowing from P), the vectors of length `size` make the angle α with
// the tangent.
#let fig-5-16() = drawing({
  import cetz.draw: *
  let (centre, radius) = ((24.5, -34.2), 42)
  let (size, opening) = (12, 35deg)
  let at(t) = (
    centre.at(0) + radius * calc.cos(t),
    centre.at(1) + radius * calc.sin(t),
  )
  brush-stroke(sample(at, 125.6deg, 81.5deg, n: 60), u => 1.1 - 0.75 * u)
  for (k, t) in (125.6deg, 110.2deg, 96deg).enumerate() {
    let (tangent, field) = (t - 90deg, t - 90deg + opening)
    let foot = at(t)
    let along(d) = (
      foot.at(0) + d * calc.cos(field),
      foot.at(1) + d * calc.sin(field),
    )
    let tip = along(size)
    // The arrowhead stands three quarters of the way.
    line(foot, tip, name: "field-" + str(k))
    arrowed(foot, along(0.75 * size))
    cetz.angle.angle(
      foot,
      (rel: (tangent, 1), to: foot),
      tip,
      radius: 4.2,
      label-radius: 6.4,
      label: $alpha$,
    )
    spot(foot, radius: if k == 0 { 1.1 } else { 0.9 })
  }
  content("field-0.end", $arrow(a) = arrow(T)(0)$, anchor: "south")
  content(at(81.5deg), $gamma(t)$, anchor: "north", padding: 1.6)
  content(at(125.6deg), $P$, anchor: "north-east", padding: 1.4)
})

// Figure 17: the right circular cone with the apex O and the apex angle θ
// (black), cut by the plane through S at right angles to the axis along the
// circle γ(t); the vector a⃗ at P is tangent to the generatrix OP and
// points to O. The cone of base `base` and height `height` stands on a
// stippled plate; its outline is the pair of generatrices touching the
// base ellipse, which also part the seen arcs from the hidden ones
// (dashed). Orthographic view from slightly above.
#let fig-5-17() = drawing({
  import cetz.draw: *
  let (base, height, section, plate) = (29.4, 30.3, 14, 1)
  let view = orthographic(0deg, 14deg)
  let at = view.project
  let level = height * (1 - section / base)
  let rim(radius, z) = s => (radius * calc.cos(s), radius * calc.sin(s), z)
  let (apex, centre) = ((0, 0, height), (0, 0, level))
  // The generatrices touching the base outline from the apex, at the turns
  // s with sin s = sin(elevation) · base / (height cos(elevation)).
  let touch = calc.asin(
    calc.sin(14deg) * base / (height * calc.cos(14deg)),
  )
  let (front-from, front-to) = (180deg - touch, 360deg + touch)
  let turn-p = 233.5deg
  let p = rim(section, level)(turn-p)
  let far = rim(section, level)(turn-p - 180deg)
  // The plate under the base: its disc stippled, its front edge black.
  let floor = rim(base, 0)
  let edge = sample(s => at(floor(s)), front-from, front-to, n: 90)
  line(
    ..edge,
    ..edge.rev().map(((x, y)) => (x, y - plate)),
    close: true,
    fill: black,
  )
  line(
    ..sample(s => at(floor(s)), 0deg, 360deg, n: 180),
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(..sample(s => at(floor(s)), touch, 180deg - touch), ..hidden)
  line(..edge)
  for s in (touch, 180deg - touch) { line(at(apex), at(floor(s))) }
  // The section γ, its front bold; the generatrix OP to the base, the
  // opposite one and the diameter through S hidden.
  let ring = rim(section, level)
  line(..sample(s => at(ring(s)), touch, 180deg - touch), ..hidden)
  line(
    ..sample(s => at(ring(s)), front-from, front-to, n: 90),
    stroke: 1.5 * thick-line,
  )
  mark(at(ring(318deg)), at(ring(320deg)), symbol: "stealth")
  line(at(apex), at(floor(turn-p)))
  line(at(apex), at(far), ..hidden)
  line(at(p), at(far), ..hidden)
  cetz.angle.angle(
    at(apex),
    at(p),
    at(far),
    radius: 4.5,
    fill: black,
    stroke: none,
    label: none,
    name: "theta",
  )
  arrowed(at(p), (at(p), 5.3, at(apex)), stroke: thick-line, name: "a")
  content(at(apex), $O$, anchor: "south-west", padding: 0.8)
  content((at(apex), 7.2, ("theta.start", 50%, "theta.end")), $theta$)
  content("a.end", $arrow(a)$, anchor: "west", padding: 1.2)
  content(at(centre), cutout($S$), anchor: "west", padding: 1)
  content(at(p), $P = Q$, anchor: "north-west", padding: 1.4)
  content(at(ring(325deg)), $gamma(t)$, anchor: "north-west", padding: 1.2)
  spot(at(apex), radius: 1)
  spot(at(centre), radius: 0.9)
  spot(at(p), radius: 0.9)
})

// Figure 18: parallel transport around the cone by its development. Left,
// a cone (half the apex angle `half`) cut along a generatrix:
// the cut is opened between the turns `cut`, and the inside shows black
// through it down to the far rim of the base; the circle γ through P and Q
// on the two edges of the cut. The surface is stippled down to the far
// rim. Right, the development, of the radius `outer`: a sector of the
// angle 2π sin(θ/2), stippled within the radius OP and black beyond it;
// the gap between its edges OP and OQ is φ = 2π(1 − sin(θ/2)). The vector
// a⃗ at P points to O; carried in the plane to Q = P it gives b⃗, at the
// angle φ to QO.
#let fig-5-18() = drawing({
  import cetz.draw: *
  let (half, base, level, elevation) = (52.3deg, 26.7, 0.41, 10deg)
  let height = base / calc.tan(half)
  let at = orthographic(0deg, elevation).project
  let section = base * (1 - level)
  let rim(radius, z) = s => at((radius * calc.cos(s), radius * calc.sin(s), z))
  let apex = at((0, 0, height))
  let floor = rim(base, 0)
  let ring = rim(section, level * height)
  // The outline generatrices touch the base at the turns ±touch.
  let touch = calc.asin(
    calc.sin(elevation) * base / (height * calc.cos(elevation)),
  )
  let cut = (237deg, 275deg)
  let mix(p, q, t) = (
    p.at(0) + t * (q.at(0) - p.at(0)),
    p.at(1)
      + t
        * (
          q.at(1) - p.at(1)
        ),
  )
  // Where the cut edge at the turn s passes behind the far rim of the base.
  let far-rim(x) = (
    base * calc.sin(elevation) * calc.sqrt(1 - calc.pow(x / base, 2))
  )
  let behind(s) = {
    let (low, high) = (0, 1)
    for _ in range(30) {
      let t = (low + high) / 2
      let (x, y) = mix(apex, floor(s), t)
      if y > far-rim(x) { low = t } else { high = t }
    }
    mix(apex, floor(s), low)
  }
  let (left, right) = cut.map(behind)
  let far = sample(floor, 180deg - touch, touch, n: 90)
  let slit = (
    apex,
    left,
    ..far.filter(((x, y)) => x > left.at(0) and x < right.at(0)),
    right,
  )
  // The stippled surface, the inside through the cut, the hidden arcs.
  line(apex, ..far, close: true, fill: stipple, stroke: none)
  line(..far, ..hidden)
  line(..sample(ring, 180deg - touch, touch), ..hidden)
  line(..slit, close: true, fill: black, stroke: none)
  line(
    ..sample(ring, 180deg - touch, touch, n: 180).filter(p => (
      inside-polygon(p, slit)
    )),
    stroke: (paint: white, thickness: thick-line),
  )
  for s in (180deg - touch, 360deg + touch) { line(apex, floor(s)) }
  for s in cut { line(apex, floor(s)) }
  line(..sample(floor, 180deg - touch, cut.at(0)))
  line(..sample(floor, cut.at(1), 360deg + touch))
  let bold = 1.5 * thick-line
  line(..sample(ring, 180deg - touch, cut.at(0)), stroke: bold)
  line(..sample(ring, cut.at(1), 360deg + touch), stroke: bold)
  let (p, q) = cut.map(ring)
  arrowed(p, (p, 8, apex), stroke: thick-line)
  let ring-dot = (radius: 0.9, stroke: (paint: white, thickness: 0.3mm))
  spot(apex, radius: 1)
  spot(p, ..ring-dot)
  spot(q, ..ring-dot)
  content(apex, $O$, anchor: "south-west", padding: 0.8)
  content(p, cutout($P$), anchor: "east", padding: 1.4)
  content(q, cutout($Q$), anchor: "north-west", padding: 1.4)
  content(ring(300deg), cutout($gamma$), anchor: "north-west", padding: 1.2)
  // The development, its centre O at `centre`.
  let outer = 22.9
  let inner = (1 - level) * outer
  let gap = 360deg * (1 - calc.sin(half))
  let (turn-p, turn-q) = (256deg - gap / 2, 256deg + gap / 2)
  group({
    translate((52.1, 10.8))
    let o = (0, 0)
    let sector(radius, fill) = arc(
      o,
      start: turn-q,
      stop: turn-p + 360deg,
      radius: radius,
      anchor: "origin",
      mode: "PIE",
      fill: fill,
      stroke: none,
    )
    sector(outer, black)
    sector(inner, white)
    sector(inner, stipple)
    let (p, q) = ((turn-p, inner), (turn-q, inner))
    arc(
      o,
      start: turn-p,
      stop: turn-q,
      radius: inner,
      anchor: "origin",
      ..hidden,
    )
    let angle-mark = (
      radius: 2.6,
      label-radius: 5,
      direction: "near",
      fill: black,
      stroke: none,
    )
    cetz.angle.angle(o, p, q, ..angle-mark, name: "at-o")
    // a⃗ points to O; b⃗ is a⃗ carried to Q.
    let reach = 0.7
    let vector = (
      -reach * inner * calc.cos(turn-p),
      -reach * inner * calc.sin(turn-p),
    )
    line(p, o)
    line(q, o)
    let tip-a = (rel: vector, to: p)
    let tip-b = (rel: vector, to: q)
    // The vectors stand out of the black in white casings.
    let vector-style = (
      stroke: thick-line,
      mark: (end: "stealth", stroke: (paint: white, thickness: 0.4pt)),
    )
    bridge((p, tip-a), (q, tip-b), gap: 3 * thick-line)
    line(p, tip-a, ..vector-style, name: "a")
    cetz.angle.angle(q, o, tip-b, ..angle-mark, name: "at-q")
    line(q, tip-b, ..vector-style, name: "b")
    spot(o, radius: 1)
    spot(p, ..ring-dot)
    spot(q, ..ring-dot)
    content(o, cutout($O$), anchor: "south", padding: 1.4)
    content("a.50%", cutout($arrow(a)$), anchor: "south", padding: 1.2)
    content("b.end", cutout($arrow(b)$), anchor: "north-west", padding: 0.8)
    content("at-o.label", $phi$)
    content("at-q.label", $phi$)
    content(p, $P$, anchor: "north-east", padding: 1.4)
    content(q, $Q = P$, anchor: "north-east", padding: 1.4)
  })
})

// Figure 19: a geodesic γ of the sphere S² and the great circle through
// one of its points with the same velocity γ̇: the plane of the circle
// through the centre O is stippled, its far half dashed; it projects to
// the ellipse with the semi-axes `radius` along `axis` and `minor` across
// it. γ (bold) touches the circle at the point (the end of the minor
// axis) and parts from it by `bend` · Δ³ along the normal.
#let fig-5-19() = drawing({
  import cetz.draw: *
  let (radius, minor, axis, bend) = (20.1, 11.6, 69deg, 45)
  let (u, v) = (
    (calc.cos(axis), calc.sin(axis)),
    (
      calc.cos(axis + 90deg),
      calc.sin(axis + 90deg),
    ),
  )
  let combine(p, q) = (
    p * u.at(0) + q * v.at(0),
    p * u.at(1) + q * v.at(1),
  )
  let circle-at(t) = combine(radius * calc.cos(t), minor * calc.sin(t))
  let normal(t) = {
    let n = combine(minor * calc.cos(t), radius * calc.sin(t))
    let size = calc.norm(..n)
    n.map(c => c / size)
  }
  let gamma-at(d) = {
    let t = 90deg - d * 1rad
    let (p, n) = (circle-at(t), normal(t))
    (
      p.at(0) + bend * calc.pow(d, 3) * n.at(0),
      p.at(1)
        + bend
          * calc.pow(
            d,
            3,
          )
          * n.at(1),
    )
  }
  line(
    ..sample(circle-at, 0deg, 360deg, n: 180),
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(..sample(circle-at, 0deg, 180deg, n: 90))
  line(..sample(circle-at, 180deg, 360deg, n: 90), ..hidden)
  circle((0, 0), radius: radius, stroke: thick-line)
  line(..sample(gamma-at, -0.45, 0.42, n: 60), stroke: 2 * thick-line)
  let point = circle-at(90deg)
  arrowed(point, (rel: (axis, 12), to: point), name: "velocity")
  content("velocity.end", $dot(gamma)$, anchor: "south-west", padding: 0.6)
  content(gamma-at(-0.38), cutout($gamma$), anchor: "west", padding: 1.6)
  content((0, 0), cutout($O$), anchor: "west", padding: 1.4)
  content((25deg, radius), $S^2$, anchor: "west", padding: 2)
  spot(point, radius: 1)
  spot((0, 0), radius: 1.1)
})

// Figure 20: the fractional linear map f of the disc onto the upper half
// plane, f(z) = s·i(A + z)/(A − z) (|A| = 1), which sends the circle to the
// real axis, A to ∞, B = −A to 0 and the diameter AB to the positive
// imaginary axis. On the right, the regions x > f(Q) (cross-hatched),
// 0 < x < f(Q) (hatched) and x < 0 (stippled) with the half disc over
// [f(C), f(D)] (black); on the left, their preimages under
// f⁻¹(w) = A(w − is)/(w + is), bounded by the arcs orthogonal to the
// circle through A and Q and through D and C.
#let fig-5-20() = drawing({
  import cetz.draw: *
  let (radius, scale, turn-a) = (19.05, 14, 218deg)
  let unit-a = (calc.cos(turn-a), calc.sin(turn-a))
  let (image-q, image-d, image-c) = (9.5, -6.8, -32.6)
  // The half plane: its origin, its reach to the left, right and up.
  let (origin, left, right, top) = ((60.3, -21.8), -35.8, 21.4, 47.2)
  let back(w) = complex-times(
    unit-a,
    complex-over((w.at(0), w.at(1) - scale), (w.at(0), w.at(1) + scale)),
  ).map(c => radius * c)
  let turn-of(p) = calc.atan2(..p)
  let rim(from, to) = {
    let (s, e) = (turn-of(from), turn-of(to))
    if e <= s { e += 360deg }
    sample(t => (radius * calc.cos(t), radius * calc.sin(t)), s, e)
  }
  let up-from(x) = sample(t => back((x, scale * calc.tan(t))), 0deg, 89.5deg)
  let half-circle(from, to) = sample(
    t => (
      (from + to) / 2 + (to - from) / 2 * calc.cos(t),
      (to - from) / 2 * calc.sin(t),
    ),
    0deg,
    180deg,
  )
  let (a, b, q, d, c) = (
    unit-a.map(v => radius * v),
    back((0, 0)),
    back((image-q, 0)),
    back((image-d, 0)),
    back((image-c, 0)),
  )
  let hatch(lines) = tiling(size: (0.8mm, 0.8mm), {
    for (start, end) in lines {
      place(std.line(start: start, end: end, stroke: 0.35pt))
    }
  })
  let diagonal = ((0mm, 0.8mm), (0.8mm, 0mm))
  let cross = hatch((diagonal, ((0mm, 0mm), (0.8mm, 0.8mm))))
  let upright = hatch((((0.4mm, 0mm), (0.4mm, 0.8mm)),))
  let slanted = hatch((diagonal,))
  let rimmed = (fill: black, stroke: (paint: white, thickness: 1.8pt))
  // The disc.
  let geodesic-qa = up-from(image-q)
  let geodesic-cd = half-circle(image-c, image-d).map(back)
  line(..rim(q, a), ..geodesic-qa.rev(), close: true, fill: cross)
  line(..rim(b, q), ..geodesic-qa, a, close: true, fill: upright)
  line(..rim(a, b), close: true, fill: stipple)
  line(..rim(c, d), ..geodesic-cd, close: true, ..rimmed)
  line(..geodesic-cd)
  line(a, b)
  line(..geodesic-qa)
  circle((0, 0), radius: radius, stroke: thick-line)
  for p in (a, b, q, d, c) { spot(p, radius: 0.9) }
  spot((0, 0), radius: 0.9)
  for (p, label) in (
    (a, $A$),
    (b, $B$),
    (q, $Q$),
    (d, $D$),
    (c, $C$),
  ) {
    content(((0, 0), radius + 2.8, p), label)
  }
  content((0, 0), $O$, anchor: "north-east")
  // The map.
  let level = -10.8
  arrowed(
    (calc.sqrt(radius * radius - level * level) + 0.8, level),
    (origin.at(0) + left - 0.8, level),
    name: "f",
  )
  content("f.mid", $f$, anchor: "north")
  // The half plane.
  group({
    translate(origin)
    rect((image-q, 0), (right, top), fill: cross, stroke: none)
    rect((0, 0), (image-q, top), fill: slanted, stroke: none)
    rect((left, 0), (0, top), fill: stipple, stroke: none)
    line(..half-circle(image-c, image-d), close: true, ..rimmed)
    line(..half-circle(image-c, image-d))
    line((left, 0), (right, 0), stroke: thick-line)
    arrowed((0, 0), (0, top), name: "axis")
    for x in (image-q, 0, image-d, image-c) { spot((x, 0), radius: 0.9) }
    content("axis.end", cutout($oo = f(A)$), anchor: "north-east")
    content((image-q, 0), cutout($f(Q)$), anchor: "south-west", padding: 1.6)
    content((0, 0), $0 = f(B)$, anchor: "north", padding: 1.6)
    content((image-d, 0), $f(D)$, anchor: "north-east", padding: 1.6)
    content((image-c, 0), $f(C)$, anchor: "north", padding: 1.6)
  })
})

// Figure 21: every half circle orthogonal to the axis z is carried to the
// axis y: first the shift z ↦ z − A takes the half disc on [A, A + d]
// (black) to the one on [0, B′], then z ↦ −1/z. The half circles through
// 0, centred on the axis, of the radii `first` + k · `step`, fan out over
// it; each is drawn from 0 to the turn `end(k)` about its centre or to the
// top line of the figure, and those beyond the `count`-th merge with the
// axis y into black.
#let fig-5-21() = drawing({
  import cetz.draw: *
  let (d, a, top, right) = (35.1, 45.5, 44.2, 89.7)
  let (first, step, count) = (22.7, 5.08, 80)
  let rimmed = (fill: black, stroke: (paint: white, thickness: 1.8pt))
  let half-disc(from) = {
    arc(
      (from + d / 2, 0),
      start: 0deg,
      stop: 180deg,
      radius: d / 2,
      anchor: "origin",
      mode: "CLOSE",
      ..rimmed,
    )
    arc(
      (from + d / 2, 0),
      start: 0deg,
      stop: 180deg,
      radius: d / 2,
      anchor: "origin",
    )
  }
  // The half circle of radius r through 0, from 0 to the turn `stop`.
  let fan-arc(r, stop) = sample(
    t => (r + r * calc.cos(t), r * calc.sin(t)),
    180deg,
    stop,
    n: 60,
  )
  let end(k) = calc.min(20deg + 18deg * k, 90deg)
  let last = first + (count - 1) * step
  // Beyond the last arc, up to the axis y, all black.
  line(
    (0, 0),
    ..fan-arc(last, 180deg - calc.asin(top / last)),
    (0, top),
    close: true,
    fill: black,
    stroke: none,
  )
  for k in range(count) {
    let r = first + k * step
    let stop = if r > top {
      calc.max(end(k), 180deg - calc.asin(top / r))
    } else {
      end(k)
    }
    line(..fan-arc(r, stop), stroke: thick-line)
  }
  // The arcs cut by the top end on a line.
  let widest = range(count).map(k => first + k * step).find(r => r > top)
  line((0, top), (widest - calc.sqrt(widest * widest - top * top), top))
  half-disc(0)
  half-disc(a)
  arrowed((-3, 0), (right, 0), name: "z")
  arrowed((0, 0), (0, top), name: "y")
  arrowed((a, 3), (a - 6.8, 3), stroke: thick-line)
  for x in (0, d, a, a + d) { spot((x, 0), radius: 0.9) }
  content("z.end", $z$, anchor: "north-east", padding: 1.6)
  content("y.end", $y$, anchor: "north-east", padding: 1.4)
  content((0, 0), $0 = A'$, anchor: "north", padding: 1.6)
  content((d, 0), $B'$, anchor: "north-east", padding: 1.6)
  content((a, 0), $A$, anchor: "north", padding: 1.6)
})

// Figure 22: a geodesic γ of the upper half plane through P and the half
// circle orthogonal to the axis x with the same velocity γ̇ at P, its
// radius to P at a right angle to γ̇. The half circle has the centre
// `centre` and passes through P at the turn `turn`; γ (a brush stroke)
// touches it at P and parts from it by the offset b₂s² + b₃s³ along the
// normal.
#let fig-5-22() = drawing({
  import cetz.draw: *
  let (centre, radius, turn) = ((21.7, 0), 16.6, 121deg)
  let (b2, b3) = (0.037, -0.00126)
  let p = (rel: (turn, radius), to: centre)
  let (tx, ty) = (calc.cos(turn - 90deg), calc.sin(turn - 90deg))
  let (nx, ny) = (calc.cos(turn), calc.sin(turn))
  let (px, py) = (
    centre.at(0) + radius * nx,
    centre.at(1) + radius * ny,
  )
  let gamma-at(s) = {
    let off = b2 * s * s + b3 * s * s * s
    (px + s * tx + off * nx, py + s * ty + off * ny)
  }
  arrowed((0, -3.6), (0, 29.4), name: "y")
  line((-2, 0), (centre.at(0) + radius + 3, 0), name: "x")
  arc(
    centre,
    start: 0deg,
    stop: 180deg,
    radius: radius,
    anchor: "origin",
    stroke: thick-line,
  )
  line(p, centre, ..hidden)
  cetz.angle.right-angle(
    p,
    centre,
    (rel: (tx, ty), to: p),
    radius: 2.2,
    label: none,
  )
  brush-stroke(sample(gamma-at, -9.6, 13.9, n: 60), u => 0.35 + 1.1 * u)
  arrowed(p, (rel: (11.7 * tx, 11.7 * ty), to: p), name: "velocity")
  for point in ((0, 0), centre, p) { spot(point, radius: 1) }
  content("y.end", $y$, anchor: "north-west", padding: 1)
  content("x.end", $x$, anchor: "north-east", padding: 1.4)
  content((0, 0), $0$, anchor: "north-east", padding: 1.4)
  content(p, $P$, anchor: "south-east", padding: 1.6)
  content(gamma-at(13.9), $gamma$, anchor: "east", padding: 1.6)
  content("velocity.end", $dot(gamma)$, anchor: "west", padding: 1)
  content((rel: (turn - 135deg, 5), to: p), $pi / 2$)
})

// Figure 23: the line y = y₀ of the upper half plane, not a geodesic, from
// P to Q, and its approximation by a broken geodesic: arcs of the half
// circles of radius y₀ about the points k·`step` of the axis x (dashed),
// each touching the line at its top. A vector carried along a geodesic
// keeps its angle with the velocity (the metric is conformal), so on the
// k-th arc, at the turn φ about its centre, the vector a⃗ standing upright
// at P has the direction φ − 2kα, α = arcsin(step / 2y₀).
#let fig-5-23() = drawing({
  import cetz.draw: *
  let (level, step, size, q) = (16.9, 14.6, 8.7, 54)
  let alpha = calc.asin(step / (2 * level))
  let on(k, t) = (k * step + level * calc.cos(t), level * calc.sin(t))
  // The broken geodesic: the arc k from its left corner to its right one.
  let piece(k) = (if k == 0 { 90deg } else { 90deg + alpha }, 90deg - alpha)
  for k in range(4) {
    arc(
      (k * step, 0),
      start: 0deg,
      stop: 180deg,
      radius: level,
      anchor: "origin",
      ..hidden,
    )
  }
  arrowed((-19.5, 0), (64.6, 0), name: "x")
  arrowed((0, -3.6), (0, 27.9), name: "y")
  line((0, level), (59, level))
  line((0, 0), on(0, 90deg - alpha))
  for k in range(4) {
    let (from, to) = piece(k)
    line(..sample(t => on(k, t), from, to, n: 30), stroke: 2 * thick-line)
  }
  // The field at even steps of x up to `reach`.
  let reach = 1.75 * step
  let head = (end: "stealth", length: 2, width: 1, inset: 0.6)
  let vector-at(x) = {
    let k = calc.round(x / step)
    let t = calc.acos((x - k * step) / level)
    let (fx, fy) = on(k, t)
    let turn = t - 2 * k * alpha
    ((fx, fy), (fx + size * calc.cos(turn), fy + size * calc.sin(turn)))
  }
  for i in range(1, 17) {
    let (foot, tip) = vector-at(i * reach / 16)
    line(foot, tip, mark: head)
  }
  // The tips trace a curve, closed down to the path at the last vector.
  line(
    ..sample(x => vector-at(x).at(1), 0, reach, n: 60),
    vector-at(reach).at(0),
  )
  arrowed((0, level), (0, level + size), stroke: 2 * thick-line, name: "a")
  for k in range(3) { spot(on(k, 90deg - alpha), radius: 0.9) }
  for p in ((0, 0), (0, level), (q, level)) { spot(p, radius: 1) }
  content("x.end", $x$, anchor: "north-east", padding: 1.4)
  content("y.end", $y$, anchor: "north-east", padding: 1)
  content("a.mid", $arrow(a)$, anchor: "east", padding: 1.4)
  content((0, level), $P$, anchor: "north-east", padding: 1.4)
  content((0, 0), $0$, anchor: "north-east", padding: 1.4)
  content((q, level), $Q$, anchor: "south-west", padding: 1.2)
})

// Figure 24: parallel transport along the line y = y₀ of the upper half
// plane from P to Q. A parallel field there keeps its Euclidean length
// and turns clockwise at the rate 1/y₀: at the distance x from P the
// vector upright at P has the direction 90° − x/y₀. The tips (thin line)
// trace the field; the vectors at P and Q bold.
#let fig-5-24() = drawing({
  import cetz.draw: *
  let (level, length, size, count) = (16.2, 91.4, 10.6, 25)
  let vector-at(x) = {
    let turn = 90deg - x / level * 1rad
    ((x, level), (x + size * calc.cos(turn), level + size * calc.sin(turn)))
  }
  let head = (end: "stealth", length: 2.4, width: 1.2, inset: 0.7)
  let bold = (
    stroke: 2 * thick-line,
    mark: (
      end: "stealth",
      length: 3.2,
      width: 1.6,
      inset: 0.9,
    ),
  )
  arrowed((0, 0), (95.3, 0), name: "x")
  line((0, -1.6), (0, level + size))
  line(..sample(x => vector-at(x).at(1), 0, length, n: 120))
  for i in range(1, count) {
    let (foot, tip) = vector-at(i * length / count)
    line(foot, tip, mark: head)
  }
  line((0, level), (length, level), stroke: 2 * thick-line)
  line(..vector-at(0), ..bold, name: "a")
  line(..vector-at(length), ..bold)
  for p in ((0, 0), (0, level), (length, level)) { spot(p, radius: 1) }
  content("x.end", $x$, anchor: "north-east", padding: 1.4)
  content("a.end", $arrow(a)$, anchor: "south-west", padding: 0.6)
  content((0, level), $P$, anchor: "north-west", padding: 1.4)
  content((length, level), $Q$, anchor: "north", padding: 1.6)
  content((0, 0), $0$, anchor: "south-west", padding: 1.4)
})

// Figure 25: parallel transport of a⃗ along a plane section γ of S² that
// does not pass through the centre: the circle at the height `height` on
// the axis n through its pole N. Seen from the front (x right, z up); the
// meridians from N through P and through the point where γ goes behind
// the sphere, hidden arcs dashed; hand shading strokes along the right
// limb.
#let fig-5-25() = drawing({
  import cetz.draw: *
  let radius = 16.9
  let view = orthographic(0deg, 0deg)
  let at = view.project
  let seen(p) = facing(view, p)
  let unit(v) = {
    let size = calc.sqrt(v.map(c => c * c).sum())
    v.map(c => c / size)
  }
  let mix(s, u, t, v) = range(3).map(i => s * u.at(i) + t * v.at(i))
  let n = unit((-0.369, -0.293, 0.882))
  let height = 0.7 * radius
  let size = calc.sqrt(radius * radius - height * height)
  let e1 = unit(vec-cross(n, (0, 1, 0)))
  let e2 = vec-cross(n, e1)
  let section(t) = mix(1, n.map(c => height * c), size, mix(
    calc.cos(t),
    e1,
    calc.sin(t),
    e2,
  ))
  // The meridian from N through the point x of the sphere, to the south
  // pole −N.
  let meridian(x) = {
    let along = vec-dot(x, n)
    let w = unit(mix(1, x, -along, n))
    sample(
      s => mix(radius * calc.cos(s), n, radius * calc.sin(s), w),
      0deg,
      180deg,
      n: 120,
    )
  }
  let (turn-p, turn-back) = (61.3deg, 215deg)
  let p = section(turn-p)
  let pole = n.map(c => radius * c)
  circle((0, 0), radius: radius, stroke: thick-line)
  for k in range(22) {
    let s = 25deg - k * 5.6deg
    let middle = (s, radius * (0.87 - 0.04 * calc.sin(-s)))
    let slant = -calc.min(0deg, s) * 0.3
    line(
      (rel: (slant + 180deg, 0.9), to: middle),
      (rel: (slant, 0.9), to: middle),
    )
  }
  seen-hidden(at, seen, meridian(p))
  seen-hidden(at, seen, meridian(section(turn-back)))
  seen-hidden(
    at,
    seen,
    sample(section, 0deg, 360deg, n: 180),
    stroke: 2 * thick-line,
  )
  // a⃗ is tangent to the meridian at P, towards N.
  let along = vec-dot(p, pole) / (radius * radius)
  let toward = unit(mix(1, pole, -along, p))
  arrowed(
    at(p),
    (at(p), 8.3, at(mix(1, p, 1, toward))),
    stroke: 2 * thick-line,
    name: "a",
  )
  spot(at(p), radius: 1)
  spot(at(pole), radius: 1)
  spot(at(n.map(c => height * c)), radius: 1)
  content("a.end", $arrow(a)$, anchor: "south-east", padding: 1)
  content(at(p), $P$, anchor: "north-east", padding: 1.6)
  content(at(section(150deg)), $gamma$, anchor: "north-west", padding: 1.4)
})

// Figure 26: the torus T² = ℝ²/ℤ ⊕ ℤ with the flat metric dφ² + dψ²: the
// lattice of the points (2πm, 2πn) of the plane ℝ²(φ, ψ) with the axes
// bold, the square [0, 2π]² stippled (its sides glued as the arrows show),
// a line l; f maps it onto the geodesic f(l) of the torus. The grid step
// is `step` mm; the torus is a drawing, its labels over it (mm from its
// top left corner).
#let fig-5-26() = drawing({
  import cetz.draw: *
  let step = 7.45
  let at(u, v) = (u * step, v * step)
  rect(at(0, 0), at(1, 1), fill: stipple, stroke: none)
  for i in range(-1, 5) { line(at(i, -1.22), at(i, 2.36)) }
  for j in range(-1, 3) { line(at(-1.3, j), at(4.2, j)) }
  let bold = 2 * thick-line
  line(at(-1.3, 0), at(4.2, 0), stroke: bold, name: "phi")
  line(at(0, -1.4), at(0, 2.6), stroke: bold, name: "psi")
  line(at(1, 0), at(1, 1), stroke: bold)
  let head = (symbol: "stealth", fill: black)
  mark(at(0, 0.9), at(0, 1), ..head)
  mark(at(0.9, 1), at(1, 1), ..head)
  mark(at(0.9, 0), at(1, 0), ..head)
  line(at(-0.34, -0.9), at(1.77, 1.86), stroke: bold, name: "l")
  content("psi.end", $psi$, anchor: "north-east", padding: 1.2)
  content(at(0, 1), $2 pi$, anchor: "south-east", padding: 1.6)
  content(at(1, 0), $2 pi$, anchor: "north-west", padding: 1.6)
  content("l.end", $l$, anchor: "north-west", padding: 1.2)
  content("phi.end", $phi$, anchor: "north-east", padding: 1.6)
  arrowed((32.2, 12.5), (44.4, 12.5), stroke: thick-line, name: "f")
  content("f.mid", $f$, anchor: "south", padding: 1.6)
  // The torus.
  let corner = (41.4, 17.6)
  book-picture(
    "/assets/figures/05-26-torus.svg",
    49.95,
    corner: corner,
    anchor: "north-west",
  )
  for (x, y, label) in (
    (12.95, 15.54, $f(l)$),
    (31.24, 17.06, $(0, 0)$),
    (7.51, 25.74, cutout($T^2$)),
  ) {
    content((rel: (x, -y), to: corner), label)
  }
})

// Figure 27: the lattice (2πm, 2πn) of the plane ℝ²(φ, ψ), its points on
// the axes marked, the square [0, 2π]² stippled; the line l through 0 and
// the lattice point (3, 2), so tg α = 2/3, passes through (6, 4) as well.
// The grid step is `step` mm.
#let fig-5-27() = drawing({
  import cetz.draw: *
  let step = 7.53
  let at(u, v) = (u * step, v * step)
  let (left, right, bottom, top) = (-2.6, 7.3, -2.2, 5.5)
  rect(at(0, 0), at(1, 1), fill: stipple, stroke: 2 * thick-line)
  for i in range(-2, 8) { line(at(i, bottom), at(i, top), stroke: thick-line) }
  for j in range(-2, 6) { line(at(left, j), at(right, j), stroke: thick-line) }
  line(at(left, 0), at(right, 0), stroke: 2 * thick-line)
  line(at(0, bottom), at(0, top), stroke: 2 * thick-line)
  line(at(0, 0), at(7, 14 / 3), name: "l")
  cetz.angle.angle(
    at(0, 0),
    at(1, 0),
    at(3, 2),
    radius: 3,
    fill: black,
    stroke: none,
  )
  for i in range(1, 8) { spot(at(i, 0), radius: 0.95) }
  for j in range(1, 6) { spot(at(0, j), radius: 0.95) }
  for p in (at(0, 0), at(1, 1), at(3, 2), at(6, 4)) { spot(p, radius: 0.95) }
  content(at(0, 4.4), $psi$, anchor: "east", padding: 1.4)
  content(at(0, 0), $0$, anchor: "north-east", padding: 1.4)
  content(at(0.75, 0), $alpha$, anchor: "north", padding: 1.6)
  content(at(2.4, 1.6), $l$, anchor: "north-west", padding: 1.4)
  content(at(3, 2), $(3, 2)$, anchor: "north-west", padding: 1.2)
  content(at(6.75, 0), $phi$, anchor: "north", padding: 1.8)
})

// Figure 28: the line through 0 of slope tg α = 2/3 (through the lattice
// point (3, 2)) cut into the square [0, 2π]² of `side` mm: the pieces run
// from 1 to 2, 2 to 3, 3 to 4, 4 to 5 = 1, the like numbers glued; the
// dashed lines are the lines φ = π, ψ = 2π/3, ψ = 4π/3 through the ends.
// Right, the closed geodesic it gives on the torus T² (a drawing).
#let fig-5-28() = drawing({
  import cetz.draw: *
  let side = 40.1
  let at(u, v) = (u * side, v * side)
  // The pieces of the line between the sides, in turn.
  let pieces = (
    ((0, 0), (1, 2 / 3)),
    ((0, 2 / 3), (1 / 2, 1)),
    ((1 / 2, 0), (1, 1 / 3)),
    ((0, 1 / 3), (1, 1)),
  )
  rect(at(0, 0), at(1, 1))
  line(at(1 / 2, 0), at(1 / 2, 1), ..hidden)
  for v in (1 / 3, 2 / 3) { line(at(0, v), at(1, v), ..hidden) }
  for (a, b) in pieces { line(at(..a), at(..b), stroke: 2 * thick-line) }
  cetz.angle.angle(
    at(0, 0),
    at(1, 0),
    at(1, 2 / 3),
    radius: 5.5,
    label: $alpha$,
    label-radius: 8,
  )
  for (u, v) in (
    (0, 0),
    (1, 0),
    (0, 1),
    (1, 1),
    (1 / 2, 0),
    (1 / 2, 1),
    (0, 1 / 3),
    (0, 2 / 3),
    (1, 1 / 3),
    (1, 2 / 3),
  ) {
    spot(at(u, v), radius: 1.1)
  }
  for (u, v, label, anchor) in (
    (0, 0, $1$, "north-east"),
    (0, 2 / 3, $2$, "north-east"),
    (0, 1 / 3, $4$, "south-east"),
    (1 / 2, 1, $3$, "south-west"),
    (1, 1, $5 = 1$, "south"),
    (1, 2 / 3, $2$, "south-west"),
    (1, 1 / 3, $4$, "north-west"),
  ) {
    content(at(u, v), cutout(label), anchor: anchor, padding: 1.4)
  }
  // The torus.
  let corner = (40.81, 47.79)
  book-picture(
    "/assets/figures/05-28-torus.svg",
    59.35,
    corner: corner,
    anchor: "north-west",
  )
  for (x, y, label) in ((40.38, 39.43, $0$), (19.54, 59.56, cutout($T^2$))) {
    content((rel: (x, -y), to: corner), label)
  }
})

// Figure 29: a line of slope tg α through a corner of the square of
// `side` mm with its opposite sides glued (the torus). Left, tg α = p/q =
// 3/10: the line closes up after q crossings of the vertical sides and p of
// the horizontal ones, its pieces start on the left side at the heights
// k/q and on the bottom at k/p; the angles α at the bottom black. Right,
// tg α = (√5 − 1)/2, irrational: its pieces fill the square densely (black),
// the line itself white.
#let fig-5-29() = drawing({
  import cetz.draw: *
  let side = 30.5
  let (p, q) = (3, 10)
  let slope = p / q
  let at(u, v) = (u * side, v * side)
  // The pieces: from the left side at k/q (k = 1 … q − 1) and from the
  // bottom at j/p (j = 0 … p − 1), each to the side it meets first.
  let piece((u, v)) = {
    let rise = (1 - u) * slope
    if v + rise <= 1 + 1e-9 { ((u, v), (1, v + rise)) } else {
      ((u, v), (u + (1 - v) / slope, 1))
    }
  }
  let starts = (
    range(1, q).map(k => (0, k / q)) + range(p).map(j => (j / p, 0))
  )
  for start in starts {
    let (a, b) = piece(start)
    line(at(..a), at(..b), stroke: 1.5 * thick-line)
  }
  for j in range(p) {
    cetz.angle.angle(
      at(j / p, 0),
      at(1, 0),
      at(j / p + 1, slope),
      radius: 6,
      fill: black,
      stroke: none,
    )
  }
  rect(at(0, 0), at(1, 1), stroke: 2 * thick-line)
  for start in starts {
    for point in piece(start) { spot(at(..point), radius: 0.8) }
  }
  spot(at(0, 1), radius: 0.8)
  // The irrational slope.
  group({
    translate((side + 5.1, 0))
    rect(at(0, 0), at(1, 1), fill: black)
    line(at(0, 0), at(1, (calc.sqrt(5) - 1) / 2), stroke: (
      paint: white,
      thickness: thick-line,
    ))
  })
})

// Figure 30: the irrational winding of the torus: its closure is the whole
// torus (left, black); right, its many turns. A drawing.
#let fig-5-30() = image("/assets/figures/05-30-tori.svg", width: 76.45mm)

// Figure 31: the geodesic through two points of the upper half plane.
// Left, P and Q on a vertical line: the segment of it. Right, the arc of
// the half circle centred where the perpendicular bisector of the chord PQ
// (dashed from the centre) meets the axis x.
#let fig-5-31() = drawing({
  import cetz.draw: *
  let (p, q) = ((9.31, 7.83), (36.6, 19.9))
  let (low, high) = ((0, 9.52), (0, 29.84))
  // The centre on the axis is as far from P as from Q.
  let centre = (
    (
      q.at(0) * q.at(0)
        + q.at(1) * q.at(1)
        - p.at(0) * p.at(0)
        - p.at(1) * p.at(1)
    )
      / (2 * (q.at(0) - p.at(0))),
    0,
  )
  let radius = calc.norm(p.at(0) - centre.at(0), p.at(1))
  let turn(z) = calc.atan2(z.at(0) - centre.at(0), z.at(1))
  line((-3.8, 0), (52.1, 0), name: "x")
  line((0, -0.4), (0, 39.9))
  line(low, high, stroke: 2 * thick-line)
  let ring = (radius: radius, anchor: "origin")
  arc(centre, start: 0deg, stop: 180deg, ..ring, stroke: thick-line)
  arc(centre, start: turn(q), stop: turn(p), ..ring, stroke: 2 * thick-line)
  line(p, q, stroke: thick-line)
  line(
    centre,
    (rel: ((turn(p) + turn(q)) / 2, radius), to: centre),
    ..hidden,
  )
  for z in (p, q, low, high) { spot(z, radius: 1.1) }
  spot(centre, radius: 0.9)
  content("x.end", $x$, anchor: "north-east", padding: 1.4)
  content(low, $P$, anchor: "west", padding: 1.6)
  content(high, $Q$, anchor: "west", padding: 1.6)
  content(p, $P$, anchor: "south-east", padding: 1.4)
  content(q, $Q$, anchor: "south-west", padding: 1.4)
})

// Figure 32: the exponential map at P: the vector a⃗ of the tangent plane
// T_P Mⁿ (a slab over the manifold Mⁿ) goes along the geodesic (dashed)
// to a point of Mⁿ near P₀. A drawing; the labels over it, at the points
// they name (mm from its top left corner).
#let fig-5-32() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/05-32-tangent-slab.svg",
    91.69,
    anchor: "north-west",
  )
  for (x, y, label) in (
    (53.85, 14.05, $arrow(a)$),
    (59.05, 17.44, $P$),
    (31.43, 18.99, cutout($P_0$)),
    (67.73, 29.36, $T_P M^n$),
    (89.2, 31.6, cutout($M^n$)),
  ) {
    content((x, -y), label)
  }
})

