// Figures of chapter 4, § 5. Each is a function called by the text:
// `#fig(fig-4-84()) <fig:…>`.
#import "common.typ": *

// Cross-hatching: two families of lines along the diagonals of a narrow
// cell, as printed over a chart domain.
#let cross-hatch = tiling(size: (1.05mm, 1.55mm), {
  place(line(start: (0%, 0%), end: (100%, 100%), stroke: 0.7pt))
  place(line(start: (100%, 0%), end: (0%, 100%), stroke: 0.7pt))
})

// Figure 84: orientation of the disc D² and of its boundary. At a point of
// the circle at the polar angle θ the basis is e⃗₁ along the tangent line,
// counterclockwise, and e⃗₂ along the inward normal; inside, a basis of the
// same orientation and the turn from e⃗₁ to e⃗₂ by the smaller angle. A
// chart U_α with its axes x¹_α, x²_α overlaps the disc.
#let fig-4-84() = lettered-drawing({
  import cetz.draw: *
  let radius = 16.3
  // Basis vectors at the boundary and inside; the tangent lines run on
  // past the arrowheads by the factors of `boundary-points`.
  let (unit, inner-unit) = (12.3, 8.7)
  let boundary-points = ((33deg, 1.35), (210deg, 1.3))
  let (inner-point, inner-turn) = ((1.5, 7.2), 49deg)
  let (chart, chart-radius, chart-turn, axis-length) = (
    (9.6, -12.6),
    11.6,
    30deg,
    15,
  )
  let along(p, angle, length) = (rel: (angle, length), to: p)
  set-style(line: (stroke: thick-line))
  circle((0, 0), radius: radius, fill: stipple)
  circle(chart, radius: chart-radius, fill: white)
  circle(chart, radius: chart-radius, fill: cross-hatch, stroke: thick-line)
  for (i, (theta, reach)) in boundary-points.enumerate() {
    let p = (theta, radius)
    let tangent = theta + 90deg
    line(p, along(p, tangent, reach * unit))
    arrowed(p, along(p, tangent, unit), name: "e1")
    arrowed(p, along(p, theta + 180deg, unit), name: "e2")
    spot(p)
    if i == 0 {
      content("e1.70%", $arrow(e)_1$, anchor: "south-west")
      content("e2.35%", cutout($arrow(e)_2$), anchor: "north", padding: 1.6)
    }
  }
  arrowed(inner-point, along(inner-point, inner-turn, inner-unit), name: "e1")
  arrowed(
    inner-point,
    along(inner-point, inner-turn + 90deg, inner-unit),
    name: "e2",
  )
  cetz.angle.angle(
    inner-point,
    "e1.end",
    "e2.end",
    radius: 2.6,
    stroke: thin-line,
    mark: (end: "stealth", length: 1.4mm, width: 0.9mm, inset: 0.4mm),
  )
  spot(inner-point)
  content("e1.55%", cutout($arrow(e)_1$), anchor: "north-west", padding: 1.2)
  content("e2.55%", cutout($arrow(e)_2$), anchor: "north-east", padding: 1.2)
  arrowed(chart, along(chart, chart-turn, axis-length), name: "x1")
  arrowed(chart, along(chart, chart-turn + 90deg, axis-length), name: "x2")
  content("x1.end", $x_alpha^1$, anchor: "west")
  content("x2.85%", cutout($x_alpha^2$), anchor: "east", padding: 1.2)
  content(along(chart, -28deg, 0.65 * chart-radius), cutout($U_alpha$))
})
// Figure 85: the orientation of the ball D³ and of its boundary S². At a
// point P of the sphere the basis e⃗₁, e⃗₂ of the tangent plane and e⃗₃
// towards the centre form a right-handed frame; the screw rule about an
// axis along e⃗₃ (the turn from e⃗₁ to e⃗₂) and the rule of three fingers.
// Built in the coordinates of the view (x right, y up, z towards the
// viewer), the radius of the ball the unit. The tangent plane, a rectangle
// about P, is opaque: what of the ball it hides is dashed. The hand is a
// drawing.
#let fig-4-85() = lettered-drawing({
  import cetz.draw: *
  let radius = 19.2
  let at(p) = (radius * p.at(0), radius * p.at(1))
  // The view looks down on the equator by the angle `tilt`.
  let tilt = calc.asin(0.28)
  // P as seen, and the direction of e⃗₁ as seen.
  let (px, py) = (0.112, 0.705)
  let normal = (px, py, calc.sqrt(1 - px * px - py * py))
  let along-e1 = (0.524, -0.641)
  let e1 = vec-unit((
    ..along-e1,
    -(px * along-e1.at(0) + py * along-e1.at(1)) / normal.at(2),
  ))
  let e2 = vec-cross(e1, normal)
  let e3 = vec-scale(-1, normal)
  assert(calc.abs(vec-dot(vec-cross(e1, e2), e3) - 1) < 1e-9)
  let basis-length = 0.75
  // The tangent plane: a rectangle about P + 0.173 e⃗₁ + 0.04 e⃗₂, its
  // sides turned by −12.4° from e⃗₁, e⃗₂, of half-lengths 1.04 and 0.71.
  let (turn, half-u, half-v) = (-12.4deg, 1.037, 0.713)
  let u = vec-add(vec-scale(calc.cos(turn), e1), vec-scale(calc.sin(turn), e2))
  let v = vec-cross(normal, u)
  let middle = vec-add(normal, vec-scale(0.173, e1), vec-scale(0.04, e2))
  let corner(su, sv) = at(vec-add(
    middle,
    vec-scale(su * half-u, u),
    vec-scale(sv * half-v, v),
  ))
  // Left, top, right and front corners.
  let plane = (corner(-1, -1), corner(-1, 1), corner(1, 1), corner(1, -1))
  let open(p) = not inside-polygon(at(p), plane)
  circle((0, 0), radius: radius, fill: stipple, stroke: none)
  line(..plane, close: true, fill: white, stroke: none)
  let rim = sample(t => (calc.cos(t), calc.sin(t), 0), 0deg, 360deg, n: 360)
  group({
    set-style(stroke: (thickness: thick-line))
    seen-hidden(at, open, rim)
  })
  let equator = sample(
    t => (
      calc.cos(t),
      -calc.sin(tilt) * calc.sin(t),
      calc.cos(tilt) * calc.sin(t),
    ),
    0deg,
    360deg,
    n: 360,
  )
  seen-hidden(at, p => p.at(2) > 0 and open(p), equator, stroke: 0.9pt)
  // The plane is a thin slab: its near edges bold.
  line(plane.at(0), plane.at(1), plane.at(2), stroke: 0.9pt)
  line(plane.at(2), plane.at(3), stroke: 1.9pt)
  line(plane.at(3), plane.at(0), stroke: 3pt)
  let tip(e, length) = at(vec-add(normal, vec-scale(length, e)))
  let p = at(normal)
  arrowed(
    p,
    tip(e3, 1),
    stroke: (thickness: thick-line, dash: hidden.stroke.dash),
    name: "e3",
  )
  arrowed(p, tip(e1, basis-length), stroke: thick-line, name: "e1")
  arrowed(p, tip(e2, basis-length), stroke: thick-line, name: "e2")
  spot(p, radius: 1)
  content("e1.end", $arrow(e)_1$, anchor: "north-west")
  content("e2.55%", $arrow(e)_2$, anchor: "north", padding: 1.4)
  content("e3.75%", $arrow(e)_3$, anchor: "west")
  // The screw: an axis along e⃗₃ and a turn about it from e⃗₁ to e⃗₂,
  // broken where it passes behind the axis.
  let axis = (-1.24, 0.75, 0)
  let on-axis(t) = at(vec-add(axis, vec-scale(t, e3)))
  arrowed(on-axis(-1.09), on-axis(1.95), ..hidden)
  let screw = 0.165
  let front = calc.atan2(e1.at(2), e2.at(2))
  line(
    ..sample(
      t => at(vec-add(
        axis,
        vec-scale(screw * calc.cos(t), e1),
        vec-scale(screw * calc.sin(t), e2),
      )),
      front + 35deg,
      front + 352deg,
      n: 60,
    ),
    stroke: 1.5pt,
    mark: (end: "stealth", length: 2mm, width: 1.6mm, inset: 0.5mm),
  )
  book-picture(
    "/assets/figures/04-85-hand.svg",
    54.74,
    corner: (16.51, 26.54),
    anchor: "north-west",
  )
})

// Labels at their places: an array of (place, body).
#let labels-at(places) = for (at, body) in places {
  cetz.draw.content(at, body)
}

// A side of a polygon glued to another: a segment with the arrowhead of
// its direction, the tip at `tip` along it.
#let glued-side(from, to, tip: 85%, stroke: thick-line, mark: (:)) = {
  cetz.draw.line(from, to, stroke: stroke)
  cetz.draw.mark(
    (from, tip - 1%, to),
    (from, tip, to),
    symbol: "stealth",
    ..mark,
  )
}

// The square lattice of the plane ℝ²(x, y) with the step `step` about
// the origin `origin`: the lines through the integer points from −1.25 to
// 2.4 steps, the axes with arrows; the unit square stippled. Its sides are
// bold with the arrows of the gluing: the bottom and the left side point
// along the axes, the top and the right side the same way (`top`, `right`
// 1) or reversed (−1). Then `points` on the bottom side, given by their
// abscissas, are joined to their images on the top side.
#let unit-lattice(origin, step, top: 1, right: 1, points: ()) = {
  import cetz.draw: *
  let (from, to) = (-1.25, 2.4)
  let at(x, y) = (rel: (x * step, y * step), to: origin)
  for k in range(-1, 3) {
    if k != 0 {
      line(at(from, k), at(to, k), stroke: 1pt)
      line(at(k, from), at(k, to), stroke: 1pt)
    }
  }
  let axis = (stroke: 1pt, mark: (end: "stealth"))
  line(at(from, 0), at(to, 0), ..axis, name: "x")
  line(at(0, from), at(0, to), ..axis, name: "y")
  rect(at(0, 0), at(1, 1), fill: stipple, stroke: none)
  let side = (stroke: 2pt, mark: (length: 3.2mm, width: 1.9mm))
  let ends(sign, p, q) = if sign > 0 { (p, q) } else { (q, p) }
  glued-side(at(0, 0), at(1, 0), ..side)
  glued-side(at(0, 0), at(0, 1), ..side)
  glued-side(..ends(top, at(0, 1), at(1, 1)), ..side)
  glued-side(..ends(right, at(1, 0), at(1, 1)), ..side)
  for x in points {
    let image = if top > 0 { x } else { 1 - x }
    line(at(x, 0), at(image, 1))
    spot(at(x, 0), radius: 0.9)
    spot(at(image, 1), radius: 0.9)
  }
}

// The number of a part of these figures, larger than their labels.
#let stage-number = part-number.with(size: 10pt)

// A label of two glued edges, x = x, set close as the hand-lettered labels.
#let glued-label(x) = $#x thin class("normal", =) thin #x$

// Figure 87: the torus T² = ℝ²/ℤ ⊕ ℤ. Left, the lattice of ℤ(a) ⊕ ℤ(b)
// and its fundamental square with the sides glued by a and b; right, the
// gluing in space: 1 the cylinder (b = b), 2 the cylinder bent round, 3
// the torus (a = a). The bodies are drawings.
#let fig-4-87() = lettered-drawing({
  import cetz.draw: *
  let (origin, step) = ((12.53, -28.19), 10.1)
  unit-lattice(origin, step)
  let at(x, y) = (rel: (x * step, y * step), to: origin)
  content(at(0, 1), $(0, 1)$, anchor: "south-east", padding: 1.2)
  content(at(0.5, 1), $a$, anchor: "south", padding: 1.6)
  content(at(0, 0.5), $b$, anchor: "east", padding: 1.6)
  content(at(1, 0.5), $b$, anchor: "west", padding: 1.6)
  content(at(0, 0), $0$, anchor: "north-east", padding: 1.2)
  content(at(0.5, 0), $a$, anchor: "north", padding: 1.4)
  content(at(1, 0), $(1, 0)$, anchor: "north-west", padding: 1.2)
  content("x.end", $x$, anchor: "north", padding: 1.4)
  content("y.end", $y$, anchor: "west", padding: 1)
  book-picture(
    "/assets/figures/04-87-torus.svg",
    56.13,
    corner: (39.29, 0.04),
    anchor: "north-west",
  )
  labels-at((
    ((37.89, -1.35), stage-number(1)),
    ((60.88, -1.90), stage-number(2)),
    ((51.73, -37.76), stage-number(3)),
    ((44.62, -19.73), glued-label($b$)),
    ((43.18, -35.94), $a$),
    ((52.87, -11.81), $a$),
    ((87.29, -9.91), $a$),
    ((96.01, -34.80), $T^2$),
  ))
  content((81.53, -36.15), glued-label($a$), anchor: "west")
  content((62.65, -5.76), glued-label($b$), angle: 40deg)
  content((70.78, -35.90), glued-label($b$), angle: 80deg)
})

// Figure 86: the Möbius band as a rectangle whose left and right sides are
// glued in opposite directions (bold arrows), and in space. A frame
// (e⃗₁, e⃗₂) carried along the midline from A to B comes back across the
// glued side upside down: the dashed strip left of the rectangle is the
// part beyond the right side, turned over. Right: the band in space, a
// drawing, with the frames carried round it.
#let fig-4-86() = lettered-drawing({
  import cetz.draw: *
  let (left, right, bottom, top) = (10.6, 51.0, -24.5, -0.3)
  let middle = (bottom + top) / 2
  // The width of the strip beyond the glued side; A from the left side,
  // B from the right one.
  let beyond = 8.5
  let (from-a, from-b) = (7.2, 4.5)
  let (e1-length, e2-length) = (8.5, 9)
  let dashed = (stroke: (thickness: 1.2pt, dash: hidden.stroke.dash))
  rect((left, bottom), (right, top), fill: stipple, stroke: 1pt)
  line(
    (left, top),
    (left - beyond, top),
    (left - beyond, bottom),
    (left, bottom),
    ..dashed,
  )
  line((left - beyond, middle), (right, middle), ..dashed)
  let side = (
    stroke: (thickness: 1.5mm, cap: "butt"),
    mark: (end: "stealth", length: 4.2mm, width: 3.3mm, inset: 0.6mm),
  )
  line((left, bottom), (left, top), ..side)
  line((right, top), (right, bottom), ..side)
  // A frame at p, e⃗₁ up or down, e⃗₂ to the right, of the lengths given.
  let frame(name, p, up, along) = {
    arrowed(p, (rel: (0, up)), stroke: thick-line, name: name + "1")
    arrowed(p, (rel: (along, 0)), stroke: thick-line, name: name + "2")
    spot(p, radius: 1)
  }
  frame("a", (left + from-a, middle), e1-length, e2-length)
  frame("b", (right - from-b, middle), e1-length, e2-length)
  frame("c", (left - from-b, middle), -e1-length, from-b)
  content("a1.80%", cutout($arrow(e)_1$), anchor: "west", padding: 2)
  content("a2.75%", cutout($arrow(e)_2$), anchor: "north", padding: 1.5)
  content("b1.80%", cutout($arrow(e)_1$), anchor: "east", padding: 1.5)
  content("b2.end", $arrow(e)_2$, anchor: "north", padding: 1.2)
  content("c2.50%", $arrow(e)_2$, anchor: "south", padding: 1.5)
  content("c1.end", $arrow(e)_1$, anchor: "south-west", padding: 0.5)
  content((left, middle - 2.5), cutout($A$), anchor: "north-west", padding: 1.6)
  content((right, middle - 2.5), cutout($B$), anchor: "north-east", padding: 2)
  content((left - beyond, middle), $B$, anchor: "east", padding: 1)
  book-picture(
    "/assets/figures/04-86-moebius.svg",
    40.30,
    corner: (61.30, -0.89),
    anchor: "north-west",
  )
  labels-at((((70.78, -4.78), $B$), ((69.64, -23.03), $A$)))
})
// Figure 88: the Klein bottle, ℝ² by the group of b(x, y) = (x + 1, y)
// and a(x, y) = (1 − x, y + 1). Left, the lattice and the fundamental
// square: b glues the side x = 0 to x = 1 the same way, a the bottom to the
// top reversed, a point (t, 0) to (1 − t, 1); right, the gluing in space:
// 1 the cylinder (b = b), 2 its ends brought together, 3–5 one end passed
// through the side and glued to the other from inside. The bodies are
// drawings.
#let fig-4-88() = lettered-drawing({
  import cetz.draw: *
  let (origin, step) = ((12.95, -24.47), 10.1)
  unit-lattice(origin, step, top: -1, points: (0.27,))
  let at(x, y) = (rel: (x * step, y * step), to: origin)
  content(at(0.5, 1), $a$, anchor: "south", padding: 1.6)
  content(at(0, 0.5), $b$, anchor: "east", padding: 1.6)
  content(at(1, 0.5), $b$, anchor: "west", padding: 1.6)
  content(at(0, 0), $0$, anchor: "north-east", padding: 1.2)
  content(at(0.5, 0), $a$, anchor: "north", padding: 1.4)
  content("x.end", $x$, anchor: "north", padding: 1.4)
  content("y.end", $y$, anchor: "west", padding: 1)
  book-picture(
    "/assets/figures/04-88-klein-bottle.svg",
    91.74,
    corner: (0.30, -0.93),
    anchor: "north-west",
  )
  labels-at((
    ((40.22, -1.65), stage-number(1)),
    ((44.96, -8.93), $a$),
    ((44.32, -32.05), $a$),
    ((67.31, -9.10), stage-number(2)),
    ((63.50, -19.35), $a$),
    ((56.35, -36.11), $a$),
    ((88.60, -25.87), $a$),
    ((78.70, -32.05), $a$),
    ((4.49, -42.38), stage-number(3)),
    ((42.80, -39.88), stage-number(4)),
    ((69.34, -41.49), stage-number(5)),
  ))
  content((50, -18.33), glued-label($b$), anchor: "east")
  content((68.66, -13.38), glued-label($b$), angle: 44deg)
})
// The sides of a polygon glued by its word: the side from corner i to
// corner i + 1 carries the i-th letter of the word, (name, exponent); its
// arrow points along the side for the exponent 1, against it for −1. A
// side that is not glued has `none` for its letter and is a plain line.
#let word-sides(corners, word, plain: (:), ..style) = {
  for (i, letter) in word.enumerate() {
    let p = corners.at(i)
    let q = corners.at(calc.rem(i + 1, corners.len()))
    if letter == none { cetz.draw.line(p, q, ..plain) } else if (
      letter.at(1) > 0
    ) { glued-side(p, q, ..style) } else { glued-side(q, p, ..style) }
  }
}

// The letters of the word beside the sides of a clockwise polygon, at
// `gap` from the midpoints, outside (`gap` > 0) or inside.
#let word-letters(corners, word, gap, body: x => x) = {
  for (i, letter) in word.enumerate() {
    if letter == none { continue }
    let (px, py) = corners.at(i)
    let (qx, qy) = corners.at(calc.rem(i + 1, corners.len()))
    let length = calc.sqrt(calc.pow(qx - px, 2) + calc.pow(qy - py, 2))
    let (nx, ny) = (-(qy - py) / length, (qx - px) / length)
    cetz.draw.content(
      ((px + qx) / 2 + gap * nx, (py + qy) / 2 + gap * ny),
      body(letter.at(0)),
    )
  }
}

// Figure 89: the square with the word b a b a (clockwise from the top
// left corner) is the projective plane; it is a disc whose boundary,
// marked at eight points, is glued antipodally.
// The corners of the square with the bottom left corner `corner` and the
// side `side`, clockwise from the top left one.
#let square-corners(corner, side) = {
  let (x, y) = corner
  ((x, y + side), (x + side, y + side), (x + side, y), (x, y))
}

// The bold sides of a square glued by its word, clockwise from the top
// left corner, as in figs. 89–91.
#let square-sides(corners, word) = word-sides(
  corners,
  word,
  stroke: 2pt,
  tip: 90%,
  mark: (length: 3.2mm, width: 1.9mm),
)

// The word of the projective plane on the square: b a b a.
#let projective-word = (($b$, 1), ($a$, 1), ($b$, 1), ($a$, 1))

// Figure 89: the square with the word b a b a (clockwise from the top
// left corner) is the projective plane; it is a disc whose boundary,
// marked at eight points, is glued antipodally.
#let fig-4-89() = lettered-drawing({
  import cetz.draw: *
  let (corner, side) = ((2.29, -21.76), 20.9)
  let square = square-corners(corner, side)
  rect(corner, (rel: (side, side)), fill: stipple, stroke: none)
  square-sides(square, projective-word)
  // The letters a outside, b inside in cut-outs.
  word-letters(square, projective-word, 1.8, body: x => if x == $a$ {
    x
  })
  word-letters(square, projective-word, -2.2, body: x => if x == $b$ {
    cutout(x)
  })
  content((33.78, -9.91), $tilde.equiv$)
  let (centre, radius) = ((34.46, -32.6), 13.3)
  circle(centre, radius: radius, fill: stipple, stroke: none)
  for k in range(4) {
    line(
      (rel: (k * 45deg, radius), to: centre),
      (rel: (k * 45deg + 180deg, radius), to: centre),
      stroke: 1.5pt,
    )
  }
  circle(centre, radius: radius, stroke: 2.6pt)
  for k in range(8) {
    spot((rel: (k * 45deg, radius), to: centre), radius: 1)
  }
})

// Figure 90: a model of ℝP² in ℝ³. 1 the square b a b a; 2 a sphere
// with the square cut in it; 3 the cut opened; 4 the sides a glued, the
// sides b about to be; 5 the model with its singular segment AB; below,
// the model with its sections across AB, and the sections themselves.
// The bodies are drawings.
#let fig-4-90() = lettered-drawing({
  import cetz.draw: *
  let (corner, side) = ((2.29, -24.21), 20.3)
  let square = square-corners(corner, side)
  rect(corner, (rel: (side, side)), fill: stipple, stroke: none)
  square-sides(square, projective-word)
  word-letters(square, projective-word, 1.8)
  content((3.43, -1.31), stage-number(1))
  book-picture(
    "/assets/figures/04-90-projective-plane.svg",
    95.46,
    corner: (3.98, -1.06),
    anchor: "north-west",
  )
  labels-at((
    ((34.21, -2.46), stage-number(2)),
    ((37.72, -5.25), $b$),
    ((47.46, -2.88), $a$),
    ((40.72, -12.15), $a$),
    ((53.42, -12.06), $b$),
    ((71.80, -2.96), stage-number(3)),
    ((80.77, -5.00), $b$),
    ((88.31, -6.56), $a$),
    ((79.93, -17.70), $a$),
    ((90.68, -16.85), $b$),
    ((5.42, -30.69), stage-number(4)),
    ((19.94, -31.16), glued-label($a$)),
    ((13.46, -38.44), $b$),
    ((25.61, -38.02), $b$),
    ((46.06, -38.02), stage-number(5)),
    ((62.70, -25.87), $A$),
    ((63.58, -45.64), $B$),
  ))
})
// Figure 91: ℝP² is a disc and a Möbius band glued along their boundary.
// 1 the square b a b a; 2 the disc D² about the glued midpoints p of the
// sides a, two half-discs; the disc ∪ 3 the rest; 4 the rest cut and
// reglued: a rectangle whose top a b a is glued to its bottom reversed;
// 5 D² ∪ the Möbius band μ₂.
#let fig-4-91() = lettered-drawing({
  import cetz.draw: *
  let (width, height) = (16.76, 15.75)
  // The half-discs about the midpoints of the sides a, of the radius
  // `notch`.
  let notch = 5.2
  let box-corners((x, y), w, h) = (
    (x, y + h),
    (x + w, y + h),
    (x + w, y),
    (x, y),
  )
  let bold = (stroke: 2pt, tip: 90%, mark: (length: 3.2mm, width: 1.9mm))
  let midpoints((x, y)) = ((x, y + height / 2), (x + width, y + height / 2))
  // A disc D², black, with its label below.
  let disc(centre, radius, label-at) = {
    circle(centre, radius: radius, fill: black, stroke: none)
    content(label-at, $D^2$)
  }
  // 1: the square.
  let first = (2.2, -20.15)
  let square = box-corners(first, width, height)
  rect(first, (rel: (width, height)), fill: stipple, stroke: none)
  square-sides(square, projective-word)
  word-letters(square, projective-word.slice(0, 1), 2.2)
  word-letters(
    square.slice(2) + square.slice(0, 2),
    projective-word.slice(2),
    2.2,
  )
  content(
    (rel: (-2, 0), to: square.at(1)),
    $a$,
    anchor: "north-east",
    padding: (
      top: height / 2 - 1.5,
    ),
  )
  content((2.37, -2.03), stage-number(1))
  // 2: the square and the half-discs about p.
  let second = (22.27, -20.15)
  let square = box-corners(second, width, height)
  rect(second, (rel: (width, height)), fill: stipple, stroke: none)
  for (k, p) in midpoints(second).enumerate() {
    arc(
      p,
      start: 90deg + k * 180deg,
      delta: -180deg,
      radius: notch,
      anchor: "origin",
      mode: "PIE",
      fill: black,
      stroke: none,
    )
  }
  square-sides(square, projective-word)
  for p in midpoints(second) {
    spot(p, radius: 1.1)
    circle(p, radius: 0.5, fill: white, stroke: none)
  }
  content((23.20, -2.20), stage-number(2))
  labels-at((
    ((30.56, -3.30), $b$),
    ((24.13, -6.09), $a$),
    ((40.05, -6.09), $a$),
    ((20.2, -13.89), $p$),
    ((40.9, -14.06), $p$),
    ((30.73, -21.25), $b$),
  ))
  // The disc of the half-discs, glued along the diameter through p.
  let centre = (49.45, -12.70)
  disc(centre, notch, (50.12, -19.47))
  line(
    (rel: (0, notch), to: centre),
    (rel: (0, -notch), to: centre),
    stroke: (
      paint: white,
      thickness: 0.6pt,
    ),
  )
  circle(centre, radius: 0.5, fill: white, stroke: none)
  content((56.13, -12.78), $union$)
  // 3: the rest of the square.
  let third = (58.68, -20.15)
  let (x0, y0) = third
  let (x1, y1) = (x0 + width, y0 + height)
  let ym = y0 + height / 2
  rect(third, (x1, y1), fill: stipple, stroke: none)
  for (k, p) in midpoints(third).enumerate() {
    arc(
      p,
      start: 90deg + k * 180deg,
      delta: -180deg,
      radius: notch,
      anchor: "origin",
      mode: "PIE",
      fill: white,
      stroke: none,
    )
    arc(
      p,
      start: 90deg + k * 180deg,
      delta: -180deg,
      radius: notch,
      anchor: "origin",
      stroke: 2pt,
    )
  }
  glued-side((x0, y1), (x1, y1), ..bold)
  glued-side((x1, y0), (x0, y0), ..bold)
  let short = (stroke: 2pt, tip: 100%, mark: (length: 2.6mm, width: 1.7mm))
  glued-side((x0, ym + notch), (x0, y1), ..short)
  glued-side((x0, y0), (x0, ym - notch), ..short)
  glued-side((x1, y1), (x1, ym + notch), ..short)
  glued-side((x1, ym - notch), (x1, y0), ..short)
  content((59.52, -2.71), stage-number(3))
  labels-at((
    ((66.38, -2.88), $b$),
    ((56.39, -7.11), $a$),
    ((77.89, -7.11), $a$),
    ((56.39, -19.56), $a$),
    ((77.89, -19.56), $a$),
    ((66.80, -21.25), $b$),
  ))
  // 4: D² ∪ the rectangle with the top a b a, the bottom reversed.
  disc((10.75, -38.36), 5.4, (11.77, -45.21))
  content((18.12, -38.10), $union$)
  let fourth = (22.01, -47.67)
  let (w4, h4) = (18.8, 16.34)
  let (x0, y0) = fourth
  rect(fourth, (rel: (w4, h4)), fill: stipple, stroke: 1.2pt)
  for k in range(3) {
    let (s, t) = (x0 + k * w4 / 3, x0 + (k + 1) * w4 / 3)
    glued-side((s, y0 + h4), (t, y0 + h4), ..bold)
    glued-side((t, y0), (s, y0), ..bold)
  }
  for k in range(4) {
    spot((x0 + k * w4 / 3, y0 + h4), radius: 0.8)
    spot((x0 + k * w4 / 3, y0), radius: 0.8)
  }
  content((20.74, -29.13), stage-number(4))
  labels-at((((24.81, -29.80), $a$), ((31.84, -29.38), $b$)))
  // 5: D² ∪ the Möbius band μ₂.
  disc((56.73, -40.05), 5.3, (58.85, -47.08))
  content((64.27, -39.79), $union$)
  let fifth = (67.48, -53.0)
  let (w5, h5) = (12.1, 25.06)
  let (x0, y0) = fifth
  rect(fifth, (rel: (w5, h5)), fill: stipple, stroke: 1.2pt)
  let band = (stroke: 2.6pt, tip: 92%, mark: (length: 4mm, width: 2.6mm))
  glued-side((x0, y0 + h5), (x0 + w5, y0 + h5), ..band)
  glued-side((x0 + w5, y0), (x0, y0), ..band)
  content((62.15, -27.52), stage-number(5))
  content((81.37, -38.44), $mu_2$)
})
// Figure 92: the cross-cap: the Möbius band μ₂ in ℝ³ with its boundary
// circle in a plane, the singular segment AB; glued to the disc D² it
// gives ℝP². A drawing.
#let fig-4-92() = lettered-drawing({
  book-picture(
    "/assets/figures/04-92-cross-cap.svg",
    29.29,
    corner: (-0.13, -1.57),
    anchor: "north-west",
  )
  labels-at((
    ((11.09, -1.06), $A$),
    ((29.08, -15.66), $mu_2$),
    ((15.16, -23.07), $B$),
    ((31.28, -45.30), $D^2$),
  ))
})
// Figure 93: the torus is a sphere with a handle S¹ × D¹ glued into two
// holes (top row); ℝP² is a sphere with a Möbius film glued into a hole,
// the cross-cap μ₂ closing it (middle and bottom rows). Drawings.
#let fig-4-93() = lettered-drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-93-handle-film.svg",
    92.58,
    corner: (-0.08, 0.08),
    anchor: "north-west",
  )
  labels-at((
    ((5.25, -9.69), $T^2$),
    ((17.65, -7.32), stage-number(1)),
    ((39.33, -6.77), stage-number(2)),
    ((64.90, -6.22), stage-number(3)),
    ((72.86, -1.57), emph[ручка]),
    ((4.95, -29.25), $RR PP^2$),
    ((21.38, -28.19), stage-number(1)),
    ((52.20, -33.10), stage-number(2)),
    ((56.30, -36.91), $mu_2$),

    ((55.63, -60.20), $D^2$),
    ((25.10, -62.36), stage-number(3)),
    ((43.43, -64.73), emph[Пленка]),
    ((75.86, -59.01), emph[Ручка]),
    ((75.18, -91.78), [_Цилиндр_ $= S^1 times D^1$]),
    ((75.10, -94.66), [(_$D^1$~— отрезок_)]),
  ))
  content((55.4, -70.10), emph[Мёбиуса], angle: -63deg)
  content((57.66, -48.68), emph[Склейка], anchor: "west")
})
// The corners of the regular polygon with `n` sides about `centre`, of
// the circumradius `radius`, clockwise from the angle `start`.
#let regular-corners(centre, radius, n, start) = range(n).map(k => {
  let angle = start - k * 360deg / n
  (
    centre.at(0) + radius * calc.cos(angle),
    centre.at(1) + radius * calc.sin(angle),
  )
})

// Figure 94: the pretzel. 1 the octagon with the word
// W = a b a⁻¹ b⁻¹ c d c⁻¹ d⁻¹ read clockwise; 2–5 its sides glued,
// a = a and c = c first, then b and d; 6 the surface obtained, 7 the
// sphere with two handles S² + 2r. The bodies are drawings.
#let fig-4-94() = lettered-drawing({
  import cetz.draw: *
  let word = (
    ($a$, 1),
    ($b$, 1),
    ($a$, -1),
    ($b$, -1),
    ($c$, 1),
    ($d$, 1),
    ($c$, -1),
    ($d$, -1),
  )
  let centre = (18.71, -21.34)
  let octagon = regular-corners(centre, 17.78, 8, 135deg)
  line(..octagon, close: true, fill: stipple, stroke: none)
  word-sides(octagon, word, stroke: 1.2pt)
  word-letters(octagon, word, 2.6)
  content((19.56, -16.85), cutout(text(size: 7pt, emph[
    Фундаментальный\ многоугольник
  ])))
  content((7.54, -3.81), stage-number(1))
  book-picture(
    "/assets/figures/04-94-pretzel.svg",
    95.59,
    corner: (-0.08, -0.13),
    anchor: "north-west",
  )
  labels-at((
    ((41.40, -4.95), stage-number(2)),
    ((49.78, -1.44), $b$),
    ((54.99, -11.13), glued-label($a$)),
    ((44.37, -21.84), $d$),
    ((64.77, -22.61), $b$),
    ((54.61, -34.71), glued-label($c$)),
    ((61.51, -44.92), $d$),
    ((74.76, -3.34), stage-number(3)),
    ((78.99, -1.44), $b$),
    ((82.80, -16.34), glued-label($a$)),
    ((73.24, -20.87), $d$),
    ((93.22, -23.96), $b$),
    ((82.68, -31.58), glued-label($c$)),
    ((86.70, -45.68), $d$),
    ((10.88, -47.20), stage-number(4)),
    ((16.93, -51.82), glued-label($a$)),
    ((32.22, -61.21), $b$),
    ((6.65, -69.98), $d$),
    ((26.63, -70.74), $b$),
    ((1.90, -74.72), $d$),
    ((16.85, -79.21), glued-label($c$)),
    ((41.02, -48.01), stage-number(5)),
    ((54.06, -79.21), stage-number(6)),
    ((62.70, -84.79), $d$),
    ((57.95, -89.03), $c$),
    ((87.71, -87.42), $a$),
    ((64.81, -52.49), stage-number(7)),
    ((85.51, -74.97), $S^2 + 2 dot r$),
  ))
})
// Figure 95: the Klein bottle is two Möbius bands glued along their
// boundary. 1 the square b a⁻¹ b⁻¹ a⁻¹ (clockwise from the top left
// corner); 2 the side a halved into a″, a′ and the square cut along the
// two diagonals from the midpoints: the band between them (stippled) and
// two triangles; 3 the pieces apart; 4 the band is the Möbius band of a′,
// the triangles glued along b the Möbius band of a″.
#let fig-4-95() = lettered-drawing({
  import cetz.draw: *
  let side = 20.3
  let bold = (stroke: 1.4pt, mark: (length: 2.6mm, width: 1.6mm))
  let plain = (stroke: 1.4pt)
  let once(x) = $#x'$
  let twice(x) = $#x''$
  // A piece of the unit square: its corners (u, v), clockwise, mapped by
  // `at`, and its word.
  let piece(at, corners, word, gap: 2, fill: none, tip: 75%) = {
    let corners = corners.map(at)
    if fill != none { line(..corners, close: true, fill: fill, stroke: none) }
    word-sides(corners, word, plain: plain, tip: tip, ..bold)
    word-letters(corners, word, gap)
  }
  let upper = (
    ((0, 1), (1, 1), (0, 0.5)),
    (($b$, 1), none, (twice($a$), -1)),
  )
  let band = (
    ((0, 0.5), (1, 1), (1, 0.5), (0, 0)),
    (none, (once($a$), -1), none, (once($a$), -1)),
  )
  let lower = (
    ((0, 0), (1, 0.5), (1, 0)),
    (none, (twice($a$), -1), ($b$, -1)),
  )
  let square-at(corner, shift: 0) = ((u, v)) => (
    corner.at(0) + u * side,
    corner.at(1) + (v - 1) * side - shift,
  )
  // 1: the square.
  let first = square-corners((9.91, -3.47 - side), side)
  rect(first.at(3), first.at(1), fill: stipple, stroke: none)
  let word = (($b$, 1), ($a$, -1), ($b$, -1), ($a$, -1))
  word-sides(first, word, tip: 85%, ..bold)
  word-letters(first, word, 2)
  content((8.55, -2.29), stage-number(1))
  // 2: the square cut, the cut ends marked.
  let at = square-at((40.81, -3.39))
  piece(at, ..upper)
  piece(at, ..band, fill: stipple)
  piece(at, ..lower)
  line(at((0, 0.5)), at((1, 0.5)), stroke: (
    thickness: 1.4pt,
    dash: hidden.stroke.dash,
  ))
  for p in ((1, 1), (0, 0.5), (1, 0.5), (0, 0)) { spot(at(p), radius: 0.9) }
  content((41.66, -1.95), stage-number(2))
  // 3: the pieces apart, each lower by `apart`.
  let apart = 2.46
  for (k, (corners, word)) in (upper, band, lower).enumerate() {
    let fill = if k == 1 { stipple } else { none }
    piece(
      square-at((67.82, -3.81), shift: k * apart),
      corners,
      word,
      fill: fill,
    )
  }
  content((68.67, -1.95), stage-number(3))
  // 4: the Möbius band of a′, and the triangles glued along b: the lower
  // triangle with its side b on the top side b of the upper one.
  let (x0, y0, x1, y1) = (9.99, -30.40, 35.39, -40.81)
  piece(
    p => p,
    ((x0, y0), (x1, y0), (x1, y1), (x0, y1)),
    (none, (once($a$), -1), none, (once($a$), -1)),
    gap: 1.5,
    fill: stipple,
  )
  let glued = (38.01, -35.90 + side)
  piece(square-at(glued), ..lower, gap: -2.2)
  piece(square-at(glued, shift: side), ..upper, gap: -2.2)
  content((37.51, -29.13), stage-number(4))
})
// Figure 96: 1 the Klein bottle in ℝ³; 2 cut into two halves, each a
// Möbius band μ₂; 3 the sphere with two Möbius films, μ₂ + μ₂.
// Drawings.
#let fig-4-96() = lettered-drawing({
  book-picture(
    "/assets/figures/04-96-klein-halves.svg",
    101.05,
    corner: (1.90, 0.04),
    anchor: "north-west",
  )
  labels-at((
    ((8.21, -1.65), stage-number(1)),
    ((56.30, -2.71), stage-number(2)),
    ((83.14, -1.65), stage-number(3)),
    ((33.95, -41.36), $mu_2$),
    ((83.74, -43.77), $mu_2$),
    ((93.81, -24.21), $mu_2 + mu_2$),
  ))
})
// Figure 97: the immersion of ℝP² in ℝ³: the Möbius band with its
// boundary in a plane, the plane carried towards the viewer while the
// boundary curve is deformed into a round circle, which is closed by the
// disc D²; last, the self-intersection set. A drawing.
#let fig-4-97() = lettered-drawing({
  book-picture(
    "/assets/figures/04-97-boy-immersion.svg",
    104.65,
    corner: (3.51, 0.42),
    anchor: "north-west",
  )
  labels-at((
    ((61.64, -76.79), emph[Заклеить]),
    ((70.87, -89.75), $D^2$),
    ((98.89, -81.87), $0$),
  ))
})
// Figure 98: the two series: the sphere with three handles M²_(g=3) and
// the sphere with four Möbius films M²_(μ=4). Drawings.
#let fig-4-98() = lettered-drawing({
  book-picture(
    "/assets/figures/04-98-two-series.svg",
    96.44,
    corner: (-0.08, 0.08),
    anchor: "north-west",
  )
  labels-at((
    ((9.44, -27.60), $M_(g = 3)^2$),
    ((90.76, -39.62), $M_(mu = 4)^2$),
  ))
})
// Figure 99: a foot of a handle carried along the axis of a Möbius film
// comes back turned over: the handle becomes a turned-out handle. Below,
// a sphere with a handle and a sphere with a turned-out handle. A
// drawing.
#let fig-4-99() = lettered-drawing({
  book-picture(
    "/assets/figures/04-99-turned-out-handle.svg",
    85.01,
    corner: (-0.08, 0.08),
    anchor: "north-west",
  )
  labels-at((
    ((12.78, -60.07), emph[ручка]),
    (
      (84.96, -67.10),
      align(center, {
        set par(leading: 0.35em)
        emph[Вывернутая\ ручка]
      }),
    ),
  ))
})
// Figure 100: the sphere with a turned-out handle ≅ the Klein bottle ≅
// the sphere with two Möbius films S² + 2μ. Drawings.
#let fig-4-100() = lettered-drawing({
  book-picture(
    "/assets/figures/04-100-handle-klein.svg",
    98.26,
    corner: (-0.08, -1.57),
    anchor: "north-west",
  )
  labels-at((
    ((39.12, -20.70), $tilde.equiv$),
    ((89.37, -38.10), $S^2 + 2 mu$),
  ))
  // The name of the bottle along its outline.
  cetz.draw.content((47.20, -11.56), emph[Бутылка], angle: 62deg)
  cetz.draw.content((58.59, -2.29), emph[Клейна], angle: 16deg)
})
// Figure 101: M²_μ as a connected sum of projective planes: spheres
// with a Möbius film each, joined by tubes, and the same pieces apart.
// A drawing.
#let fig-4-101() = lettered-drawing({
  book-picture(
    "/assets/figures/04-101-projective-planes-sum.svg",
    98.26,
    corner: (-0.04, 0.08),
    anchor: "north-west",
  )
})
// Figure 102: what a triangulation forbids. Left, triangles Δ₁ and Δ₂
// meeting along part of a side; middle, curvilinear triangles with two
// common vertices joined by different sides; right, a triangle with a
// side closed into a loop at one vertex, and a triangle glued to itself.
// The curvilinear figures are free-hand: smooth curves through a few
// points.
#let fig-4-102() = lettered-drawing({
  import cetz.draw: *
  set-style(stroke: 1.8pt, hobby: (omega: 0))
  let mark = 1.2
  let region(..points) = {
    hobby(..points, close: true, fill: stipple, stroke: none)
  }
  // Straight triangles: Δ₁ = TLM, Δ₂ = LRB, M inside the side LR.
  let level = -19.2
  let (top, left, middle, right, bottom) = (
    (8.97, -3.98),
    (1.27, level),
    (19.98, level),
    (27.43, level),
    (15.32, -37.25),
  )
  line(top, left, middle, close: true, fill: stipple)
  line(left, right, bottom, close: true, fill: stipple)
  for p in (top, left, middle, right, bottom) { spot(p, radius: mark) }
  content((9.06, -12.95), cutout($Delta_1$))
  content((15.32, -25.32), cutout($Delta_2$))
  // Curvilinear triangles ABC and ABD on different sides AB.
  let (a, b, c, d) = (
    (38.86, -15.92),
    (55.96, -15.58),
    (61.98, -1.52),
    (
      55.80,
      -37.08,
    ),
  )
  let arc-ac = (a, (41.15, -12.62), (47.67, -7.45), (55.46, -3.81), c)
  let arc-cb = (c, (58.76, -9.99), b)
  // The two sides AB, a lens of circular arcs.
  let upper = (b, (47.41, -14.10), a)
  let lower = (a, (47.41, -17.40), b)
  let arc-bd = (b, (55.37, -26.33), d)
  let arc-da = (d, (49.61, -30.82), (44.37, -24.98), a)
  merge-path(fill: stipple, stroke: none, {
    hobby(..arc-ac)
    hobby(..arc-cb)
    arc-through(..upper)
  })
  merge-path(fill: stipple, stroke: none, {
    arc-through(..lower)
    hobby(..arc-bd)
    hobby(..arc-da)
  })
  for curve in (arc-ac, arc-cb, arc-bd, arc-da) { hobby(..curve) }
  arc-through(..upper)
  arc-through(..lower)
  for p in (a, b, c, d) { spot(p, radius: mark) }
  content((50.55, -9.99), cutout($Delta_1$))
  content((48.60, -24.64), cutout($Delta_2$))
  // A triangle PQ… whose side is a loop at P.
  let p = (60.54, -32.94)
  let q = (78.91, -0.42)
  let outer = (
    p,
    (62.06, -23.11),
    (66.29, -12.87),
    (72.98, -4.40),
    q,
    (79.93, -12.87),
    (78.40, -21.93),
    (76.62, -26.75),
    (72.73, -31.16),
    (67.65, -33.53),
    (63.42, -33.70),
  )
  let loop = (
    p,
    (62.15, -28.19),
    (64.69, -23.11),
    (69.34, -19.90),
    (72.73, -21.00),
    (73.74, -23.96),
    (72.73, -28.19),
    (69.34, -30.73),
    (65.11, -32.26),
  )
  merge-path(fill: stipple, stroke: none, close: true, {
    hobby(..outer.slice(0, 5))
    hobby(..outer.slice(4), p)
  })
  hobby(..loop, close: true, fill: white)
  hobby(..outer.slice(0, 5))
  hobby(..outer.slice(4), p)
  spot(p, radius: mark)
  content((69.68, -4.40), $Delta$)
  // A triangle glued to itself: its sides from S meet the black drop.
  let s = (93.89, -1.10)
  let (foot-left, foot-right) = ((85.6, -23.5), (91.6, -29.8))
  let drop = (
    (87.29, -20.32),
    foot-left,
    (82.6, -28.0),
    (80.6, -33.0),
    (81.6, -38.0),
    (85.3, -40.4),
    (89.0, -39.8),
    (91.6, -37.0),
    (92.3, -33.0),
    foot-right,
    (89.6, -24.5),
  )
  line(
    s,
    foot-left,
    (87.29, -20.32),
    foot-right,
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(s, foot-left)
  line(s, foot-right)
  // The drop has a corner at its tip.
  catmull(..drop, drop.first(), fill: black, stroke: none)
  spot(s, radius: mark)
})
// Figure 103: a triangulation of ℝP² with 24 triangles and 13 vertices:
// the disc, its rim glued antipodally (the rim vertices 1–4 twice), with
// the edges of the lines of ℝP²: the four diameters and two circular arcs
// through antipodal rim points, crossing the axes at the distance `inner`
// from the centre. The arcs meet in 5, 7, 9, 11 and cross the axes in 6,
// 8, 10, 12.
#let fig-4-103() = lettered-drawing({
  import cetz.draw: *
  let (radius, inner) = (24.0, 11.6)
  let rim(angle) = (radius * calc.cos(angle), radius * calc.sin(angle))
  on-layer(-2, circle((0, 0), radius: radius, fill: stipple, stroke: none))
  set-style(stroke: 1.2pt)
  for k in range(4) { line(rim(k * 45deg), rim(k * 45deg + 180deg)) }
  for side in (1, -1) {
    arc-through(rim(90deg), (side * inner, 0), rim(-90deg))
    arc-through(rim(0deg), (0, side * inner), rim(180deg))
  }
  circle((0, 0), radius: radius, stroke: 1.8pt)
  // The arcs meet on the diagonals at (±meet, ±meet): the arc through
  // (−inner, 0) is the circle about (centre, 0) of the radius
  // centre + inner, and (meet + centre)² + meet² = (centre + inner)².
  let centre = (radius * radius - inner * inner) / (2 * inner)
  let meet = (
    (
      calc.sqrt(centre * centre + 4 * inner * centre + 2 * inner * inner)
        - centre
    )
      / 2
  )
  // The ring of vertices with their names and the directions of the names.
  let ring = (
    ((0, inner), $8$, 45deg),
    ((meet, meet), $7$, -105deg),
    ((inner, 0), $6$, -60deg),
    ((meet, -meet), $5$, -78deg),
    ((0, -inner), $12$, -145deg),
    ((-meet, -meet), $11$, 180deg),
    ((-inner, 0), $10$, -45deg),
    ((-meet, meet), $9$, 168deg),
    ((0, 0), $13$, -113deg),
  )
  let rim-vertices = (
    (90deg, $4$, "south-east"),
    (45deg, $3$, "south-west"),
    (0deg, $2$, "west"),
    (-45deg, $1$, "west"),
    (-90deg, $4$, "north-east"),
    (-135deg, $3$, "east"),
    (180deg, $2$, "east"),
    (135deg, $1$, "south-east"),
  )
  for (p, name, direction) in ring {
    spot(p, radius: 0.9)
    // The names stand on white cut-outs of the stipple, under the edges.
    on-layer(-1, content((rel: (direction, 3.4), to: p), cutout(text(
      size: 7.5pt,
      name,
    ))))
  }
  for (angle, name, side) in rim-vertices {
    spot(rim(angle), radius: 0.9)
    content(rim(angle), name, anchor: side, padding: 1.2)
  }
  content(rim(31deg), $RR PP^2$, anchor: "south-west", padding: 1.5)
})
// Figure 104: a triangulated torus cut along its edges into triangles;
// both banks of a cut carry the letter of the edge, each side its arrow.
// A drawing.
#let fig-4-104() = lettered-drawing({
  book-picture(
    "/assets/figures/04-104-torus-cut.svg",
    101.56,
    corner: (-0.04, 0.08),
    anchor: "north-west",
  )
  labels-at((
    ((19.56, -22.18), $a$),
    ((25.32, -25.61), $a$),
    ((82.89, -1.40), $a$),
    ((53.51, -5.50), $a$),
    ((63.97, -6.60), $b$),
    ((88.82, -9.48), $b$),
    ((72.81, -12.78), $c$),
    ((54.69, -15.79), $c$),
    ((51.18, -19.05), $d$),
    ((68.07, -23.62), $q$),
    ((90.97, -24.72), $d$),
    ((70.91, -26.20), $r$),
    ((55.67, -31.41), $r$),
    ((89.07, -36.83), $q$),
  ))
})
// Figure 105: the regular decagon with the word
// W = a₁ a₂ a₁⁻¹ a₂⁻¹ a₃ a₄ a₃⁻¹ a₄⁻¹ a₅ a₅ read clockwise from its left
// side; the bold circle inside shows the clockwise reading.
#let fig-4-105() = lettered-drawing({
  import cetz.draw: *
  let (centre, radius) = ((0, 0), 19.2)
  let word = (
    ($a_1$, 1),
    ($a_2$, 1),
    ($a_1$, -1),
    ($a_2$, -1),
    ($a_3$, 1),
    ($a_4$, 1),
    ($a_3$, -1),
    ($a_4$, -1),
    ($a_5$, 1),
    ($a_5$, 1),
  )
  let decagon = regular-corners(centre, radius, 10, -162deg)
  line(..decagon, close: true, fill: stipple, stroke: none)
  word-sides(decagon, word, stroke: 1.6pt, tip: 72%, mark: (
    length: 3.4mm,
    width: 2.2mm,
  ))
  word-letters(decagon, word, 2.5)
  // The reading: a clockwise arc of 337° ending at the bottom.
  arc(
    centre,
    start: 245deg,
    stop: -92deg,
    radius: 12.1,
    anchor: "origin",
    stroke: 2.2pt,
    mark: (end: "stealth", length: 4mm, width: 2.8mm, inset: 0.6mm),
  )
})
// The polyline `points` rippled: each point moved along the normal by
// amplitude · sin(2π s / λ), s its length along the polyline, λ near
// `wavelength` with a whole number of waves, so that the ends stay.
#let rippled(points, amplitude: 0.45, wavelength: 2.3) = {
  let lengths = (0,)
  for i in range(1, points.len()) {
    let ((x0, y0), (x1, y1)) = (points.at(i - 1), points.at(i))
    lengths.push(
      lengths.last()
        + calc.sqrt(
          calc.pow(x1 - x0, 2)
            + calc.pow(
              y1 - y0,
              2,
            ),
        ),
    )
  }
  let total = lengths.last()
  let wave = total / calc.max(1, calc.round(total / wavelength))
  range(points.len()).map(i => {
    let (x0, y0) = points.at(calc.max(i - 1, 0))
    let (x1, y1) = points.at(calc.min(i + 1, points.len() - 1))
    let d = calc.sqrt(calc.pow(x1 - x0, 2) + calc.pow(y1 - y0, 2))
    let shift = amplitude * calc.sin(2 * calc.pi * lengths.at(i) / wave)
    let (x, y) = points.at(i)
    (x - shift * (y1 - y0) / d, y + shift * (x1 - x0) / d)
  })
}

// The rest of a word on the boundary of a polygon, drawn as a wavy line
// along the smooth curve through `points`.
#let word-rest(points) = rippled(spline-through(points))

// A vertex of a polygon: an open circle.
#let polygon-vertex(at) = cetz.draw.circle(
  at,
  radius: 1,
  fill: white,
  stroke: 1pt,
)

// The bold side of the polygons of figs. 106–113 with the arrowhead of the
// book near its end.
#let cut-side = (stroke: 1.5pt, tip: 90%, mark: (length: 3mm, width: 1.9mm))

// A stippled polygon whose outline runs through `pieces` in turn: arrays
// of corners joined by straight sides, or wavy lines (`word-rest`) for the
// rest of the word, which are drawn.
#let word-polygon(..pieces) = {
  let outline = pieces.pos().map(piece => piece.points).join()
  cetz.draw.line(..outline, close: true, fill: stipple, stroke: none)
  for piece in pieces.pos().filter(piece => piece.wavy) {
    cetz.draw.line(..piece.points, stroke: 1.5pt)
  }
}
#let straight-run(..points) = (points: points.pos(), wavy: false)
#let wavy-run(..points) = (points: word-rest(points.pos()), wavy: true)

// Figure 106: moving a vertex of the class {P} away. Left, the edge a from
// P to Q and the side c before it; cut along the diagonal d from the start
// of c to Q, the triangle c a d⁻¹ is glued back along c at the other side
// c (right): the vertex P between c and a is gone.
#let fig-4-106() = lettered-drawing({
  import cetz.draw: *
  // Left.
  let (top, left, right) = ((22.27, -2.46), (1.44, -18.80), (42.76, -19.39))
  let (bottom-left, bottom-right) = ((10.24, -42.67), (35.31, -41.57))
  word-polygon(
    straight-run(left, top),
    wavy-run(
      right,
      (43.10, -25.74),
      (41.32, -32.77),
      (38.52, -39.79),
      bottom-right,
    ),
    wavy-run(bottom-left, (6.01, -40.56), (2.12, -35.56), (1.10, -27.09), left),
  )
  glued-side(left, top, ..cut-side)
  glued-side(top, right, ..cut-side)
  glued-side(left, right, ..cut-side)
  glued-side(bottom-left, bottom-right, ..cut-side)
  arc-through(left, (22.27, -23.45), right, stroke: 1.5pt, mark: (
    end: "stealth",
    length: 3mm,
    width: 1.9mm,
  ))
  for p in (top, left, right, bottom-left, bottom-right) { polygon-vertex(p) }
  labels-at((
    ((9.91, -9.48), $c$),
    ((33.53, -8.81), $a$),
    ((29.63, -17.36), cutout($d$)),
    ((31.41, -24.89), cutout($a$)),
    ((25.06, -44.03), $c$),
    ((27.52, -1.02), ${P}$),
    ((39.54, -41.57), ${P}$),
    ((45.13, -15.83), ${Q}$),
  ))
  // Right: the triangle glued along c.
  let (top-left, top-right) = ((60.79, -5.25), (81.96, -5.25))
  let (left, right, bottom) = (
    (51.31, -30.65),
    (92.54, -31.50),
    (71.80, -45.47),
  )
  word-polygon(
    straight-run(top-left),
    wavy-run(
      top-right,
      (87.04, -9.91),
      (91.27, -16.68),
      (92.96, -24.30),
      right,
    ),
    straight-run(bottom),
    wavy-run(left, (50.63, -24.30), (52.15, -16.68), (55.71, -9.91), top-left),
  )
  glued-side(top-left, top-right, ..cut-side)
  glued-side(left, right, ..cut-side)
  glued-side(left, bottom, ..cut-side)
  glued-side(right, bottom, ..cut-side)
  for p in (top-left, top-right, left, right, bottom) { polygon-vertex(p) }
  labels-at((
    ((71.80, -3.13), $d$),
    ((87.46, -4.40), ${Q}$),
    ((81.53, -28.96), cutout($c$)),
    ((92.54, -35.73), ${P}$),
    ((58.67, -39.96), $d$),
    ((83.65, -40.39), $a$),
    ((76.88, -45.72), ${Q}$),
  ))
})
// The mark of two edges glued together: two short bars across the
// segment from `from` to `to` at the ratio `at` along it.
#let glued-mark(from, to, at: 0.5, bar: 1.2, gap: 0.45) = {
  let ((x0, y0), (x1, y1)) = (from, to)
  let length = calc.sqrt(calc.pow(x1 - x0, 2) + calc.pow(y1 - y0, 2))
  let (ux, uy) = ((x1 - x0) / length, (y1 - y0) / length)
  for side in (-1, 1) {
    let (cx, cy) = (
      x0 + at * (x1 - x0) + side * gap * ux,
      y0 + at * (y1 - y0) + side * gap * uy,
    )
    cetz.draw.line(
      (cx - bar * uy, cy + bar * ux),
      (cx + bar * uy, cy - bar * ux),
    )
  }
}

// Figure 107: the last vertex of the class {P}: its edges a⁻¹ a (both
// arrows away from it) are folded together, the vertex goes inside, and
// the edge a becomes a segment from the boundary to an inner point.
#let fig-4-107() = lettered-drawing({
  import cetz.draw: *
  let side = (..cut-side, tip: 55%)
  // 1: the vertex P between the edges a⁻¹ and a.
  let (left, top, right) = ((0.51, -12.11), (16.00, -1.10), (27.35, -15.24))
  word-polygon(straight-run(left, top), wavy-run(
    right,
    (26.75, -20.83),
    (20.83, -24.81),
    (11.51, -25.48),
    (4.32, -22.52),
    (1.19, -17.86),
    left,
  ))
  glued-side(top, left, ..side)
  glued-side(top, right, ..side)
  for p in (left, top, right) { polygon-vertex(p) }
  labels-at((((6.18, -4.32), $a$), ((20.91, -4.32), $a$)))
  // 2: the edges folded in.
  let (top-left, inner, top-right) = (
    (39.71, -1.27),
    (44.28, -13.97),
    (
      49.70,
      -1.27,
    ),
  )
  word-polygon(straight-run(inner), wavy-run(
    top-right,
    (53.42, -3.05),
    (56.22, -8.97),
    (56.05, -17.02),
    (52.15, -23.11),
    (45.38, -25.65),
    (38.61, -24.21),
    (33.10, -17.86),
    (32.43, -9.40),
    (35.64, -3.05),
    top-left,
  ))
  glued-side(inner, top-left, ..side)
  glued-side(inner, top-right, ..side)
  for p in (top-left, inner, top-right) { polygon-vertex(p) }
  labels-at((((41.91, -2.71), $a$), ((47.58, -2.71), $a$)))
  // 3: glued: a disc with the segment a = a from its rim to P inside.
  let (centre, top, point) = ((77.89, -13.21), (76.71, -0.85), (76.96, -14.99))
  let radius = calc.sqrt(
    calc.pow(top.at(0) - centre.at(0), 2)
      + calc.pow(top.at(1) - centre.at(1), 2),
  )
  let start = calc.atan2(top.at(0) - centre.at(0), top.at(1) - centre.at(1))
  let rim = rippled(sample(
    t => (
      centre.at(0) + radius * calc.cos(t),
      centre.at(1) + radius * calc.sin(t),
    ),
    start,
    start + 360deg,
    n: 160,
  ))
  line(..rim, close: true, fill: stipple, stroke: 1.5pt)
  line(top, point, stroke: 1.5pt)
  glued-mark(top, point, at: 0.66)
  polygon-vertex(top)
  circle(point, radius: 1.2, fill: white, stroke: 2.2pt)
  labels-at((((74.34, -10.24), $a$), ((79.08, -10.24), $a$)))
})
// The arrowhead of a piece of the word on its wavy line through
// `points`: at the ratio `at` along it, pointing along it or back.
#let rest-arrow(points, at, back: false) = {
  let curve = spline-through(points)
  let i = calc.max(4, int(calc.round(at * (curve.len() - 1))))
  let (from, to) = (curve.at(i - 4), curve.at(i))
  cetz.draw.mark(
    ..if back { (to, from) } else { (from, to) },
    symbol: "stealth",
    length: 3mm,
    width: 2mm,
    fill: black,
  )
}

// Figure 108: W = B a A a C becomes B A⁻¹ a a C. Left, cut along the
// diagonal c from the start of the first a to the end of the second; the
// triangle a A c⁻¹ is turned over and glued along the first a (right):
// the two sides c now stand together and are renamed a.
#let fig-4-108() = lettered-drawing({
  import cetz.draw: *
  // Left.
  let (v1, v2, v3, v4, v5) = (
    (0.42, -35.64),
    (9.40, -15.16),
    (32.26, -15.16),
    (39.88, -36.91),
    (16.34, -50.88),
  )
  let piece-a = (v2, (13.80, -13.46), (19.73, -12.78), (26.50, -13.04), v3)
  let piece-c = (
    v4,
    (39.20, -41.40),
    (35.81, -46.48),
    (29.04, -49.87),
    (
      22.27,
      -51.14,
    ),
    v5,
  )
  let piece-b = (
    v5,
    (10.41, -49.87),
    (5.76, -47.33),
    (2.79, -43.10),
    (
      0.93,
      -38.86,
    ),
    v1,
  )
  let low = (22.27, -29.97)
  word-polygon(wavy-run(..piece-a), straight-run(v4))
  merge-path(fill: stipple, stroke: none, close: true, {
    line(v1, v2)
    arc-through(v2, low, v4)
    line(..word-rest(piece-c), ..word-rest(piece-b))
  })
  line(..word-rest(piece-c), stroke: 1.5pt)
  line(..word-rest(piece-b), stroke: 1.5pt)
  glued-side(v1, v2, ..cut-side)
  glued-side(v3, v4, ..cut-side)
  glued-side(v2, v4, ..cut-side, tip: 75%)
  arc-through(v2, low, v4, stroke: 1.5pt)
  mark(
    low,
    (rel: (2, -0.25), to: low),
    symbol: "stealth",
    length: 3mm,
    width: 2mm,
    fill: black,
  )
  rest-arrow(piece-a, 0.8)
  rest-arrow(piece-c, 0.55)
  rest-arrow(piece-b, 0.7, back: true)
  for p in (v1, v2, v3, v4, v5) { polygon-vertex(p) }
  labels-at((
    ((3.22, -23.62), $a$),
    ((19.73, -9.23), $A$),
    ((36.66, -23.62), $a$),
    ((25.65, -23.20), cutout($c$)),
    ((19.73, -33.36), cutout($c$)),
    ((5.50, -48.18), $B$),
    ((30.31, -50.72), $C$),
  ))
  // Right.
  let (bottom-left, middle, bottom-right) = (
    (49.36, -47.50),
    (69.68, -47.50),
    (90.17, -47.50),
  )
  let (top-left, top-right) = ((54.61, -23.20), (81.36, -20.24))
  let piece-a = (
    bottom-left,
    (48.51, -41.40),
    (48.09, -33.78),
    (
      49.36,
      -27.86,
    ),
    top-left,
  )
  let piece-b = (
    top-left,
    (57.83, -18.97),
    (64.60, -16.85),
    (73.07, -17.02),
    (
      78.99,
      -18.54,
    ),
    top-right,
  )
  let piece-c = (
    top-right,
    (85.77, -22.78),
    (89.15, -27.86),
    (90.85, -35.48),
    (
      90.85,
      -42.25,
    ),
    bottom-right,
  )
  word-polygon(
    wavy-run(..piece-a),
    wavy-run(..piece-b),
    wavy-run(..piece-c),
    straight-run(
      middle,
    ),
  )
  glued-side(bottom-left, middle, ..cut-side)
  glued-side(middle, bottom-right, ..cut-side)
  glued-side(top-left, middle, ..cut-side, tip: 70%)
  rest-arrow(piece-a, 0.45, back: true)
  rest-arrow(piece-b, 0.45, back: true)
  rest-arrow(piece-c, 0.45)
  for p in (bottom-left, middle, bottom-right, top-left, top-right) {
    polygon-vertex(p)
  }
  labels-at((
    ((45.55, -29.13), $A$),
    ((61.04, -16.00), $B$),
    ((90.59, -27.86), $C$),
    ((58.50, -36.32), cutout($a$)),
    ((56.73, -49.02), $c$),
    ((80.86, -49.02), $c$),
    ((49.53, -50.72), [$c -> a$ (_переобозначить!_)]),
  ))
})
// The outline of a round polygon about `centre` from the corner `from`
// clockwise to the corner `to`: an arc whose radius goes over from that of
// `from` to that of `to`.
#let round-piece(centre, from, to, n: 24) = {
  let (cx, cy) = centre
  let polar((x, y)) = (
    calc.atan2(x - cx, y - cy),
    calc.sqrt(calc.pow(x - cx, 2) + calc.pow(y - cy, 2)),
  )
  let ((a0, r0), (a1, r1)) = (polar(from), polar(to))
  if a1 >= a0 { a1 -= 360deg }
  range(n + 1).map(k => {
    let (a, r) = (a0 + (a1 - a0) * k / n, r0 + (r1 - r0) * k / n)
    (cx + r * calc.cos(a), cy + r * calc.sin(a))
  })
}

// Two cut banks from `from` to `to` through `left` and `right` (`none`
// for a straight bank): arcs with the arrowhead of the book, the slit
// between them white.
#let cut-banks(from, left, right, to) = {
  import cetz.draw: *
  let bank(middle, ..style) = if middle == none {
    line(from, to, ..style)
  } else { arc-through(from, middle, to, ..style) }
  merge-path(close: true, fill: white, stroke: none, {
    bank(left)
    if right == none { line(to, from) } else {
      arc-through(to, right, from)
    }
  })
  for middle in (left, right) {
    bank(middle, stroke: 1.5pt, mark: (
      end: "stealth",
      pos: 30%,
      shorten-to: none,
      length: 3mm,
      width: 1.9mm,
    ))
  }
}

// Figure 109: W = A a R b P a⁻¹ Q b⁻¹ B becomes A Q P a b a⁻¹ b⁻¹ R B in
// two cuts and gluings: the cut c (top left) and the gluing along a (top
// right), the cut d (bottom left) and the gluing along b (bottom right),
// then the sides are renamed. The polygons are round: their free pieces
// follow arcs about the centres.
#let fig-4-109() = lettered-drawing({
  import cetz.draw: *
  let side = cut-side
  // A wavy piece of the outline with its arrowhead.
  let piece(centre, from, to, arrow: 0.5) = {
    let points = round-piece(centre, from, to)
    (points: word-rest(points), wavy: true, arrow: arrow, control: points)
  }
  let arrows(..pieces) = for p in pieces.pos() {
    if p.wavy and p.arrow != none { rest-arrow(p.control, p.arrow) }
  }
  // 1: the cut c.
  let centre = (18.8, -19.56)
  let (t1, t2, r1, r2) = (
    (15.16, -3.39),
    (27.09, -5.16),
    (34.97, -16.34),
    (
      33.19,
      -27.09,
    ),
  )
  let (b2, b1, l2, l1, v) = (
    (22.52, -35.73),
    (10.75, -33.87),
    (3.73, -25.74),
    (2.62, -16.34),
    (6.35, -8.30),
  )
  let pieces = (
    straight-run(t1),
    piece(centre, t2, r1),
    piece(centre, r2, b2),
    piece(centre, b1, l2),
    piece(centre, l1, v),
    piece(centre, v, t1),
  )
  word-polygon(..pieces)
  arrows(..pieces)
  cut-banks(t2, (20.24, -20.07), (24.89, -20.07), b2)
  glued-side(t1, t2, ..side)
  glued-side(r1, r2, ..side)
  glued-side(b1, b2, ..side)
  glued-side(l1, l2, ..side)
  for p in (t1, t2, r1, r2, b2, b1, l2, l1, v) { polygon-vertex(p) }
  labels-at((
    ((20.83, -2.71), $a$),
    ((16.51, -36.41), $a$),
    ((0.34, -20.24), $b$),
    ((36.32, -20.91), $b$),
    ((18.37, -16.09), cutout($c$)),
    ((29.21, -16.93), cutout($c$)),
    ((8.55, -3.81), $A$),
    ((2.71, -10.75), $B$),
    ((33.78, -9.06), $R$),
    ((31.24, -33.19), $P$),
    ((3.89, -32.17), $Q$),
  ))
  // 2: glued along a.
  let centre = (68.6, -18.6)
  let (u1, u2, u3, r1, r2) = (
    (58.42, -6.27),
    (67.48, -2.54),
    (76.88, -4.66),
    (83.06, -11.60),
    (84.58, -23.45),
  )
  let (d1, d0, l2, l1) = (
    (77.13, -32.85),
    (63.67, -34.63),
    (53.00, -24.38),
    (
      52.66,
      -12.87,
    ),
  )
  let pieces = (
    piece(centre, u1, u2),
    piece(centre, u2, u3),
    straight-run(r1, r2),
    piece(centre, d1, d0),
    piece(centre, d0, l2),
    piece(centre, l1, u1),
  )
  word-polygon(..pieces)
  arrows(..pieces)
  glued-side(u3, r1, ..side)
  glued-side(r1, r2, ..side)
  glued-side(r2, d1, ..side)
  glued-side(l1, l2, ..side)
  glued-side(u1, d0, ..side)
  for p in (u1, u2, u3, r1, r2, d1, d0, l2, l1) { polygon-vertex(p) }
  labels-at((
    ((64.52, -16.85), cutout($b$)),
    ((81.36, -6.52), $a$),
    ((85.17, -16.93), $c$),
    ((81.45, -30.65), $a$),
    ((50.55, -18.37), $c$),
    ((60.20, -2.71), $B$),
    ((72.14, -1.44), $A$),
    ((52.66, -6.52), $R$),
    ((54.95, -32.77), $P$),
    ((70.19, -37.25), $Q$),
  ))
  // 3: the cut d.
  let centre = (20.66, -61.3)
  let (p1, p2, p3, p4, p5, p6) = (
    (21.76, -45.04),
    (33.78, -52.24),
    (36.58, -65.11),
    (24.47, -77.47),
    (4.74, -66.80),
    (5.67, -53.51),
  )
  let pieces = (
    straight-run(p1, p2, p3),
    piece(centre, p4, p5, arrow: 0.3),
    piece(centre, p6, p1),
  )
  word-polygon(..pieces)
  arrows(..pieces)
  rest-arrow(pieces.at(1).control, 0.8)
  cut-banks(p5, (21.0, -64.9), (16.00, -68.50), p3)
  glued-side(p1, p2, ..side)
  glued-side(p2, p3, ..side)
  glued-side(p4, p3, ..side)
  glued-side(p6, p5, ..side)
  for p in (p1, p2, p3, p4, p5, p6) { polygon-vertex(p) }
  labels-at((
    ((29.13, -47.58), $a$),
    ((37.34, -57.74), $c$),
    ((2.62, -58.42), $c$),
    ((21.67, -62.15), cutout($d$)),
    ((18.37, -71.46), cutout($d$)),
    ((31.24, -73.15), $a$),
    ((8.81, -45.72), $R B A$),
    ((5.67, -72.64), $P$),
    ((17.27, -79.76), $Q$),
    (
      (48.18, -76.20),
      [$d -> a$, $c -> b$ (_переобозначить!_)],
    ),
  ))
  // 4: glued along b, the word … d c d⁻¹ c⁻¹.
  let centre = (68.5, -59.1)
  let (q1, q2, q3, q4, q6, q7, q8) = (
    (63.84, -43.43),
    (76.12, -45.30),
    (84.16, -55.63),
    (82.21, -68.50),
    (63.67, -74.68),
    (53.09, -68.83),
    (52.83, -53.34),
  )
  let pieces = (
    piece(centre, q1, q2),
    straight-run(q3, q4, q6),
    piece(centre, q7, q8),
    piece(centre, q8, q1),
  )
  word-polygon(..pieces)
  arrows(..pieces)
  glued-side(q2, q3, ..side)
  glued-side(q3, q4, ..side)
  glued-side(q6, q4, ..side)
  glued-side(q7, q6, ..side)
  glued-side(q8, q3, ..side)
  for p in (q1, q2, q3, q4, q6, q7, q8) { polygon-vertex(p) }
  labels-at((
    ((80.60, -48.01), $d$),
    ((67.65, -56.90), cutout($a$)),
    ((84.58, -63.25), $c$),
    ((76.79, -73.41), $d$),
    ((57.91, -71.88), $c$),
  ))
  content((48.60, -63.25), $R B A$, angle: 90deg)
})
// Figure 110: the word glued along a gives a cylinder whose ends hold the
// vertex classes {P} and {Q}. A drawing.
#let fig-4-110() = lettered-drawing({
  book-picture(
    "/assets/figures/04-110-cylinder.svg",
    33.57,
    corner: (3.01, -0.21),
    anchor: "north-west",
  )
  labels-at((((19.64, -4.02), $a$),))
  // The classes stand close to the ends, small as printed.
  let small(body) = text(size: 7pt, body)
  cetz.draw.content((3.0, -5.42), small(${P}$), anchor: "east", padding: 0.3)
  cetz.draw.content((36.6, -5.5), small(${Q}$), anchor: "west", padding: 0.3)
})
// Figure 111: a commutator next to a square, W = A a b a⁻¹ b⁻¹ B c c Q.
// Left, the cut d from the vertex between the sides c to the end of b;
// right, the triangle glued back along c: W̃ = A a b d⁻¹ B⁻¹ b a d⁻¹ Q,
// cut along the new diagonal c.
#let fig-4-111() = lettered-drawing({
  import cetz.draw: *
  let side = cut-side
  // Left.
  let (v1, v2, v3, v4, v5, v6, v7, v8) = (
    (3.98, -10.08),
    (12.45, -2.96),
    (25.15, -3.47),
    (32.51, -10.50),
    (34.12, -19.73),
    (28.19, -30.48),
    (15.58, -33.70),
    (5.67, -27.94),
  )
  let piece-b = (v5, (34.21, -23.28), (32.00, -27.52), v6)
  let v9 = (1.52, -18.63)
  let piece-q = (v8, (2.62, -23.71), v9)
  let piece-a = (v9, (1.78, -14.39), v1)
  word-polygon(
    straight-run(v1, v2, v3, v4),
    wavy-run(..piece-b),
    straight-run(v7),
    wavy-run(..piece-q),
    wavy-run(..piece-a),
  )
  cut-banks(v7, none, (23.1, -18.2), v3)
  glued-side(v1, v2, ..side)
  glued-side(v2, v3, ..side)
  glued-side(v4, v3, ..side)
  glued-side(v5, v4, ..side)
  glued-side(v7, v6, ..side)
  glued-side(v8, v7, ..side)
  rest-arrow(piece-b, 0.85)
  rest-arrow(piece-q, 0.6)
  rest-arrow(piece-a, 0.6)
  for p in (v1, v2, v3, v4, v5, v6, v7, v8, v9) { polygon-vertex(p) }
  labels-at((
    ((6.27, -4.06), $a$),
    ((21.08, -0.59), $b$),
    ((33.95, -6.10), $a$),
    ((35.81, -16.09), $b$),
    ((34.37, -26.67), $B$),
    ((9.65, -32.09), $c$),
    ((22.35, -33.10), $c$),
    ((18.03, -16.51), cutout($d$)),
    ((25.6, -21.4), cutout($d$)),
    ((-0.9, -13.8), $A$),
    ((-0.6, -23.6), $Q$),
  ))
  // Right.
  let (u1, u2, u3, u4, u5, u6, u7, u8, w) = (
    (59.35, -5.00),
    (70.02, -1.61),
    (81.70, -6.52),
    (85.85, -16.26),
    (83.82, -26.08),
    (76.37, -31.92),
    (65.79, -32.85),
    (55.37, -24.38),
    (53.59, -14.65),
  )
  let piece-b = (u4, (86.53, -21.17), u5)
  let piece-q = (u8, (53.68, -19.64), w)
  let piece-a = (w, (55.54, -8.89), u1)
  word-polygon(
    straight-run(u1, u2, u3),
    wavy-run(..piece-b),
    straight-run(u6, u7),
    wavy-run(..piece-q),
    wavy-run(..piece-a),
  )
  glued-side(u1, u2, ..side)
  glued-side(u2, u3, ..side)
  glued-side(u4, u3, ..side)
  glued-side(u5, u6, ..side)
  glued-side(u6, u7, ..side)
  glued-side(u8, u7, ..side)
  glued-side(u8, u4, ..side)
  rest-arrow(piece-b, 0.4, back: true)
  rest-arrow(piece-q, 0.6)
  rest-arrow(piece-a, 0.6)
  for p in (u1, u2, u3, u4, u5, u6, u7, u8, w) { polygon-vertex(p) }
  labels-at((
    ((63.84, -1.61), $a$),
    ((75.35, -1.95), $b$),
    ((85.94, -11.43), $d$),
    ((88.4, -23.45), $B$),
    ((81.70, -30.31), $b$),
    ((72.64, -33.87), $a$),
    ((57.91, -30.31), $d$),
    ((51.3, -20.49), $Q$),
    ((51.6, -9.74), $A$),
    ((68.50, -18.20), cutout($c$)),
  ))
})
// Figure 112: the word W = a a⁻¹ is not a triangulation, but glued it
// gives the sphere. 1 the disc with its two sides a, both arrows from the
// top vertex to the bottom one; 2 the disc on the sphere, its sides about
// to close; 3 closed into the arc a. The spheres are drawings.
#let fig-4-112() = lettered-drawing({
  import cetz.draw: *
  let (centre, radius) = ((16.85, -17.19), 15.6)
  circle(centre, radius: radius, fill: black, stroke: none)
  // The arrows of the sides a halfway down, outlined in white over the
  // disc.
  for side in (180deg, 0deg) {
    let at(t) = (
      rel: (side + t * (if side == 0deg { 1 } else { -1 }), radius),
      to: centre,
    )
    mark(
      at(2deg),
      at(-4deg),
      symbol: "stealth",
      length: 4.2mm,
      width: 2.4mm,
      fill: black,
      stroke: (
        paint: white,
        thickness: 0.4pt,
      ),
    )
  }
  for p in ((rel: (0, radius), to: centre), (rel: (0, -radius), to: centre)) {
    circle(p, radius: 1.4, fill: black, stroke: none)
    circle(p, radius: 0.75, fill: white, stroke: none)
  }
  content((rel: (130deg, radius + 3.2), to: centre), emph[Диск], angle: 40deg)
  content((27.01, -1.27), stage-number(1))
  for angle in (195deg, -15deg) {
    content((rel: (angle, radius + 1.8), to: centre), $a$)
  }
  book-picture(
    "/assets/figures/04-112-sphere-word.svg",
    64.30,
    corner: (35.52, -0.59),
    anchor: "north-west",
  )
  labels-at((
    ((63.20, -1.86), stage-number(2)),
    ((57.70, -8.97), $a$),
    ((51.69, -10.33), $a$),
    ((96.18, -2.88), stage-number(3)),
    ((90.51, -10.58), $a$),
  ))
})
// The centre of the circle through the points p, q and r.
#let circle-centre((px, py), (qx, qy), (rx, ry)) = {
  let d = 2 * (px * (qy - ry) + qx * (ry - py) + rx * (py - qy))
  let (p2, q2, r2) = (px * px + py * py, qx * qx + qy * qy, rx * rx + ry * ry)
  (
    (p2 * (qy - ry) + q2 * (ry - py) + r2 * (py - qy)) / d,
    (p2 * (rx - qx) + q2 * (px - rx) + r2 * (qx - px)) / d,
  )
}

// A hexagon of fig. 113: its corners `corners`, stippled, the sides given
// as pairs of corner indices (from, to) in the direction of their arrows.
#let arrowed-hexagon(corners, sides) = {
  cetz.draw.line(..corners, close: true, fill: stipple, stroke: none)
  for (i, j) in sides {
    glued-side(corners.at(i), corners.at(j), ..cut-side, tip: 80%)
  }
}

// Figure 113: the reduction to the symmetric form. 1 the hexagon
// a₁ a₂ Q a₁⁻¹ a₂⁻¹ P (Q, P the rest of the word) cut along c; 2 glued
// along a₂ (the diagonal a₂ = a₂); 3 cut along d; 4 glued along a₁; 5 the
// result: a word α β … α β … whose remaining part is a disc.
#let fig-4-113() = lettered-drawing({
  import cetz.draw: *
  let numbers(..places) = for (n, at) in places.pos().enumerate(start: 1) {
    content(at, stage-number(n))
  }
  numbers(
    (37.34, -2.79),
    (82.21, -4.40),
    (30.40, -42.25),
    (102.62, -41.91),
    (84.58, -79.93),
  )
  // 1. Corners clockwise from the top: top, top right, bottom right,
  // bottom, bottom left, top left.
  let first = (
    (23.37, -3.81),
    (37.00, -11.26),
    (37.85, -28.11),
    (22.10, -37.59),
    (7.70, -27.01),
    (9.57, -10.84),
  )
  arrowed-hexagon(first, ((5, 0), (0, 1), (2, 1), (3, 2), (4, 3), (4, 5)))
  cut-banks(first.at(5), none, (23.28, -14.48), first.at(1))
  labels-at((
    ((15.92, -4.91), $a_2$),
    ((30.48, -4.40), $Q$),
    ((23.20, -9.65), cutout($c$)),
    ((22.61, -16.34), cutout($c$)),
    ((6.77, -18.29), $a_1$),
    ((39.29, -19.05), $a_1$),
    ((11.26, -32.77), $p$),
    ((32.85, -33.53), $a_2$),
  ))
  // 2.
  let second = (
    (69.34, -3.98),
    (83.31, -11.26),
    (83.82, -29.38),
    (68.92, -37.42),
    (54.44, -27.94),
    (55.46, -11.35),
  )
  arrowed-hexagon(second, ((5, 0), (0, 1), (2, 1), (2, 3), (4, 3), (5, 4)))
  glued-side(second.at(4), second.at(2), ..cut-side, tip: 75%)
  glued-mark(second.at(4), second.at(2), at: 0.42)
  labels-at((
    ((60.62, -5.84), $a_1$),
    ((75.86, -5.50), $c$),
    ((52.83, -17.70), $p$),
    ((86.28, -19.90), $a_1$),
    ((68.75, -26.42), cutout($a_2$)),
    ((68.50, -31.58), cutout($a_2$)),
    ((60.03, -34.04), $c$),
    ((78.99, -34.12), $Q$),
  ))
  // 3.
  let third = (
    (48.18, -36.58),
    (62.74, -44.37),
    (63.58, -60.45),
    (47.16, -70.10),
    (32.85, -59.61),
    (34.21, -44.20),
  )
  arrowed-hexagon(third, ((5, 0), (0, 1), (2, 1), (2, 3), (4, 3), (5, 4)))
  cut-banks(third.at(1), (52.6, -56.5), none, third.at(3))
  labels-at((
    ((40.56, -38.18), $a_1$),
    ((55.54, -38.52), $c$),
    ((31.67, -49.78), $p$),
    ((64.52, -52.92), $a_1$),
    ((48.60, -57.07), cutout($d$)),
    ((53.76, -62.48), cutout($d$)),
    ((37.51, -65.28), $c$),
    ((57.07, -66.55), $Q$),
  ))
  // 4.
  let fourth = (
    (88.90, -38.86),
    (101.85, -46.14),
    (103.12, -63.50),
    (87.55, -72.90),
    (72.81, -62.74),
    (73.91, -46.23),
  )
  arrowed-hexagon(fourth, ((0, 5), (1, 0), (1, 2), (3, 2), (3, 4), (4, 5)))
  glued-side(fourth.at(1), fourth.at(3), ..cut-side, tip: 75%)
  glued-mark(fourth.at(1), fourth.at(3), at: 0.6)
  labels-at((
    ((81.62, -40.13), $c$),
    ((96.44, -40.22), $p$),
    ((104.31, -53.26), $Q$),
    ((71.46, -54.95), $d$),
    ((80.18, -70.02), $c$),
    ((96.69, -69.17), $d$),
    ((92.71, -58.50), cutout($a_1$)),
    ((97.2, -60.20), cutout($a_1$)),
  ))
  // 5. The polygon α β … and the disc of the rest of the word, through
  // the junctions and its right point.
  let (left, top, joint-top, joint-bottom, bottom, right) = (
    (22.94, -86.95),
    (37.93, -72.56),
    (51.82, -80.69),
    (51.90, -95.33),
    (38.35, -103.72),
    (83.99, -88.48),
  )
  let centre = circle-centre(joint-top, right, joint-bottom)
  let radius = calc.sqrt(
    calc.pow(right.at(0) - centre.at(0), 2)
      + calc.pow(right.at(1) - centre.at(1), 2),
  )
  let angle(p) = calc.atan2(p.at(0) - centre.at(0), p.at(1) - centre.at(1))
  let on-circle(t) = (
    centre.at(0) + radius * calc.cos(t),
    centre.at(1) + radius * calc.sin(t),
  )
  let (from, to) = (angle(joint-top), angle(joint-bottom))
  line(
    left,
    top,
    joint-top,
    ..sample(on-circle, from, to, n: 90),
    bottom,
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(..sample(on-circle, from, to, n: 90), stroke: 1.5pt)
  for (p, q) in (
    (joint-top, top),
    (top, left),
    (bottom, left),
    (
      joint-bottom,
      bottom,
    ),
  ) { glued-side(p, q, ..cut-side, tip: 80%) }
  // The arrows of Q and p at the junctions.
  for (end, back) in ((from, -1), (to, 1)) {
    mark(
      on-circle(end + back * 12deg),
      on-circle(end + back * 5deg),
      symbol: "stealth",
      length: 3mm,
      width: 1.9mm,
      fill: black,
    )
  }
  for p in (left, top, joint-top, joint-bottom, bottom, right) {
    polygon-vertex(p)
  }
  labels-at((
    ((29.80, -77.39), $alpha$),
    ((46.99, -75.52), $beta$),
    ((56.56, -71.54), $Q$),
    ((28.62, -97.20), $beta$),
    ((46.74, -100.25), $alpha$),
    ((52.07, -101.94), $p$),
  ))
  for corners in (first, second, third, fourth) {
    for p in corners { polygon-vertex(p) }
  }
})
