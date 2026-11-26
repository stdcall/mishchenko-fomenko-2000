// Figures of chapter 5, § 2. Each is a function called by the text:
// `#fig(fig-5-1()) <fig:…>`.
#import "common.typ": *

// A white band under a line that passes over the lines it crosses, drawn
// before it.
#let crossing-band = (stroke: (paint: white, thickness: 1.4mm, cap: "butt"))

// Light falling on a stippled area: a disc about `centre` of `radius`,
// white within 0.45 of the radius and fading out to clear at the rim in
// `steps` rings, kept within `area` (a closed path). The m outer discs
// together whiten their common part by m/steps. Drawn over the stipple and
// under the lines.
#let light-spot(area, centre, radius, steps: 12) = {
  for m in range(1, steps + 1) {
    cetz.draw.clip(area, cetz.draw.circle(
      centre,
      radius: radius * (1 - 0.55 * (m - 1) / (steps - 1)),
      stroke: none,
      fill: white.transparentize(100% * (1 - 1 / (steps - m + 1))),
    ))
  }
}

// Figure 1: a deformation of a medium. The points P and P′ at the distance
// Δl move by u(x) to P̃ and P̃′ at the distance Δl′; each displacement is
// drawn as a bold arc of one bow with its arrowhead before the end. The
// medium is a free-hand blob, a smooth closed curve through a few points,
// stippled, the stipple thinning out to white at its right end.
#let fig-5-1() = lettered-drawing({
  import cetz.draw: *
  let p = (0, 0)
  let p-prime = (0, 9.9)
  let p-moved = (30.6, -0.4)
  let p-prime-moved = (48.3, 10.1)
  let medium = (
    (-16.6, 6.0),
    (-14.6, -3.8),
    (-7.4, -11.0),
    (3.6, -12.4),
    (17.8, -9.6),
    (29.3, -6.7),
    (41.0, -8.6),
    (52.0, -11.8),
    (60.4, -9.7),
    (62.6, -3.5),
    (58.0, 5.7),
    (47.2, 14.8),
    (31.4, 22.3),
    (16.8, 25.4),
    (3.1, 24.9),
    (-9.5, 19.0),
  )
  hobby(..medium, close: true, fill: stipple, stroke: none)
  light-spot(hobby(..medium, close: true), (60, -3), 18)
  hobby(..medium, close: true)
  // A displacement: an arc of the bow `bow` (sagitta to chord).
  let bow = 0.083
  let displacement(from, to, name) = {
    let (dx, dy) = (to.at(0) - from.at(0), to.at(1) - from.at(1))
    let top = (
      (from.at(0) + to.at(0)) / 2 - bow * dy,
      (from.at(1) + to.at(1)) / 2 + bow * dx,
    )
    arc-through(from, top, to, stroke: thick-line, name: name, mark: (
      end: "stealth",
      offset: 3,
      shorten-to: none,
    ))
  }
  displacement(p, p-moved, "u")
  displacement(p-prime, p-prime-moved, "u-prime")
  let dashed = (thickness: thick-line, dash: (array: (1.2mm, 1.1mm)))
  line(p, p-prime, stroke: dashed, name: "dl")
  line(p-moved, p-prime-moved, stroke: dashed, name: "dl-moved")
  for q in (p, p-prime, p-moved, p-prime-moved) { spot(q, radius: 1) }
  content(p, cutout($P = (x^i)$), anchor: "north", padding: 1.9)
  content(p-prime, cutout($P' = (x^(i'))$), anchor: "south", padding: 3)
  content(
    p-moved,
    cutout($tilde(P)(x^i + u^i (x))$),
    anchor: "north",
    padding: 1.4,
  )
  content(
    "u-prime.mid",
    cutout($tilde(P)'(x^(i') + u^i (x'))$),
    anchor: "south",
    padding: 0.8,
  )
  content("dl.mid", cutout($Delta l$), anchor: "east")
  content("dl-moved.mid", cutout($Delta l'$), anchor: "north-west")
})

// Figure 2: a small plate dσ through the point P of a medium, the normal
// n⃗(P) to it and the force F⃗(n⃗) on it. The plate is a parallelogram about P
// spanned by the pictures of its edges, a thin slab: its back face lies
// behind along the normal, so the sides that show are those the shift
// exposes. The medium is a free-hand body, a closed outline through a few
// points with corners where the two folds of its rim start; under the folds
// the light falls on it.
#let fig-5-2() = lettered-drawing({
  import cetz.draw: *
  let p = (0, 0)
  let (edge-a, edge-b) = ((10.45, 2.85), (10.25, -20.55))
  let normal = (17.6, 11.7)
  let force = (37.5, 4.7)
  // The picture of the slab's thickness.
  let thickness = 0.7
  let (left-corner, right-corner) = ((-17.9, -11.6), (37.3, -4.2))
  let rim = (
    right-corner,
    (40.4, -1.0),
    (43.6, 5.5),
    (39.9, 11.7),
    (31.9, 14.5),
    (19.1, 15.8),
    (5.0, 15.7),
    (-7.5, 13.9),
    (-16.0, 11.1),
    (-25.2, 4.3),
    (-31.9, -7.5),
    (-31.3, -13.1),
    (-29.0, -13.8),
    (-25.0, -12.9),
    left-corner,
  )
  let bottom = (
    left-corner,
    (-15.0, -13.0),
    (-11.0, -14.9),
    (-4.4, -17.3),
    (5.0, -18.2),
    (14.4, -17.3),
    (21.0, -16.7),
    (27.0, -16.7),
    (33.0, -15.3),
    (36.9, -11.9),
    (37.9, -8.4),
    right-corner,
  )
  let left-fold = (left-corner, (-20.0, -10.1), (-22.8, -7.9), (-25.1, -4.5))
  let right-fold = (right-corner, (35.0, -6.0), (33.0, -7.9), (29.7, -12.1))
  let outline(..style) = merge-path(close: true, ..style, {
    hobby(..rim)
    hobby(..bottom)
  })
  outline(fill: stipple, stroke: none)
  // The light under each fold: kept to the side of the fold away from the
  // top, which is closed far outside the body.
  let under(fold, outside, centre, radius) = clip(
    merge-path(close: true, {
      hobby(..fold)
      line(fold.last(), ..outside, fold.first())
    }),
    light-spot(outline(), centre, radius),
  )
  under(left-fold, ((-36, -3), (-36, -20), (-15, -20)), (-25, -10.5), 8)
  under(right-fold, ((26, -20), (46, -20), (46, -4)), (34, -11), 6.5)
  outline()
  hobby(..left-fold)
  hobby(..right-fold)
  // The slab: its four sides, white, under its black face.
  let at(s, t) = (
    p.at(0) + s * edge-a.at(0) + t * edge-b.at(0),
    p.at(1) + s * edge-a.at(1) + t * edge-b.at(1),
  )
  let face = (at(-0.5, -0.5), at(0.5, -0.5), at(0.5, 0.5), at(-0.5, 0.5))
  let length = calc.sqrt(normal.map(c => c * c).sum())
  let shift = normal.map(c => -thickness * c / length)
  let behind(q) = (q.at(0) + shift.at(0), q.at(1) + shift.at(1))
  for i in range(4) {
    let (q, r) = (face.at(i), face.at(calc.rem(i + 1, 4)))
    line(q, r, behind(r), behind(q), close: true, fill: white)
  }
  line(..face, close: true, fill: black, stroke: none)
  let tips = (
    (p.at(0) + normal.at(0), p.at(1) + normal.at(1)),
    (p.at(0) + force.at(0), p.at(1) + force.at(1)),
  )
  // White edges of the vectors over the plate.
  clip(line(..face, close: true), {
    for tip in tips {
      line(p, tip, stroke: (paint: white, thickness: 3 * thin-line))
    }
  })
  arrowed(p, tips.at(0), name: "n")
  arrowed(p, tips.at(1), name: "f")
  spot(p, radius: 0.6, fill: white)
  content(p, text(fill: white, $P$), anchor: "north", padding: 3)
  content("n.end", cutout($arrow(n)(P)$), anchor: "south-east")
  content(
    "f.60%",
    cutout($arrow(F)(arrow(n)) = Q_P (arrow(n)) dot d sigma$),
    anchor: "north",
    angle: "f.end",
    padding: 0.8,
  )
})

// The point Σ sᵢ vᵢ of the cell spanned by the pictures `vectors` at the
// origin, for the weights `s`.
#let spanned(vectors, s) = (0, 1).map(k => vectors
  .zip(s)
  .map(((v, w)) => w * v.at(k))
  .sum())

// The edges of the parallelepiped spanned by three `vectors` at the
// origin, those at its hidden vertex `back` (weights in {0, 1}) dashed;
// the edges from the origin along the vectors numbered in `skip` are left
// to the caller.
#let spanned-edges(vectors, back, skip: ()) = {
  let corners = range(8).map(m => range(3).map(i => calc.rem(
    calc.quo(m, calc.pow(2, i)),
    2,
  )))
  for i in range(3) {
    for s in corners.filter(s => s.at(i) == 0) {
      let e = s
      e.at(i) = 1
      if not (s == (0, 0, 0) and i in skip) {
        cetz.draw.line(
          spanned(vectors, s),
          spanned(vectors, e),
          ..if back in (s, e) { hidden },
        )
      }
    }
  }
}

// Figure 3: the parallelepiped Π(a⃗₁, …, a⃗ₙ) spanned by three vectors at
// the origin, in a parallel projection given by the pictures of the
// vectors; the middle vector and the edges at its end are hidden.
#let fig-5-3() = lettered-drawing({
  import cetz.draw: *
  let vectors = ((11.1, -12.0), (6.1, 15.4), (23.8, 0.3))
  let vertex(s) = spanned(vectors, s)
  let back = (0, 0, 1)
  spanned-edges(vectors, back, skip: range(3))
  let origin = vertex((0, 0, 0))
  arrowed(origin, vertex(back), stroke: (
    thickness: thick-line,
    dash: (array: (2.4mm, 1.4mm)),
  ))
  arrowed(origin, vertex((1, 0, 0)), stroke: thick-line, name: "a1")
  arrowed(origin, vertex((0, 1, 0)), stroke: thick-line, name: "an")
  spot(origin, radius: 1)
  for s in ((0, 1, 1), (1, 1, 1), (1, 0, 1)) { spot(vertex(s)) }
  content("an.end", $arrow(a)_n$, anchor: "south-east", padding: 0.6)
  content("a1.45%", $arrow(a)_1$, anchor: "north-east")
  content(
    (vertex((0, 1, 0)), 50%, vertex((0, 1, 1))),
    $Pi(arrow(a)_1, dots, arrow(a)_n)$,
    anchor: "south",
  )
})

// A flat slab seen from the front right: its top face spanned by the
// pictures `width` and `depth` at its near left `corner`; the bottom face
// lies `thickness` lower, so its near and right sides show, black. The top
// face is filled with `paint`; its far edge is drawn unless `far-edge` is
// false.
#let flat-slab(corner, width, depth, thickness, paint: none, far-edge: true) = {
  import cetz.draw: *
  let at(s, t) = spanned((width, depth), (s, t))
    .zip(corner)
    .map(((p, q)) => p + q)
  let down(p) = (p.at(0), p.at(1) - thickness)
  for (from, to) in (((0, 0), (1, 0)), ((1, 0), (1, 1))) {
    line(
      at(..from),
      at(..to),
      down(at(..to)),
      down(at(..from)),
      close: true,
      fill: black,
    )
  }
  line(at(0, 0), at(1, 0), at(1, 1), at(0, 1), fill: paint, stroke: none)
  line(at(1, 1), at(1, 0), at(0, 0), at(0, 1), ..if far-edge { (close: true) })
}

// Figure 4: the parallelepiped spanned by a⃗₁, …, a⃗ₙ₋₁ in the plane of
// e⃗₁, …, e⃗ₙ₋₁ and by a⃗ₙ, whose projection on e⃗ₙ is (a′)ⁿₙ. An oblique
// view given by pictures: the plane a stippled slab, its width horizontal,
// its depth receding to the right, e⃗ₙ up; two base vectors of the cell in
// the plane, a⃗ₙ rising from it. The cell is opaque: the slab and the cell's
// back vertex and the edges there are hidden behind it.
#let fig-5-4() = lettered-drawing({
  import cetz.draw: *
  // The slab: its front left corner, width, depth and thickness.
  let corner = (-26.7, -5.1)
  let (width, depth) = ((74.6, 0), (20.75, 16.5))
  let slab(s, t) = spanned((width, depth), (s, t))
    .zip(corner)
    .map(((p, q)) => p + q)
  // The cell: base vectors in the plane, then a⃗ₙ; its back vertex hidden.
  let vectors = ((37.7, 0), (12.0, 7.1), (8.0, 14.6))
  let vertex(s) = spanned(vectors, s)
  let back = (0, 1, 0)
  let outline = (
    (0, 0, 0),
    (1, 0, 0),
    (1, 1, 0),
    (1, 1, 1),
    (0, 1, 1),
    (0, 0, 1),
  ).map(vertex)
  let thickness = 3
  flat-slab(corner, width, depth, thickness, paint: stipple, far-edge: false)
  line(..outline, close: true, fill: white, stroke: none)
  // The back edge of the slab, dashed behind the cell.
  let cell = line(..outline, close: true)
  clip(cell, line(slab(0, 1), slab(1, 1)), mode: "outside")
  clip(cell, line(slab(0, 1), slab(1, 1), ..hidden))
  spanned-edges(vectors, back, skip: (2,))
  // The axis of e⃗ₙ passes over the back edge.
  let top = 29.8
  line((0, 0), (0, top), ..crossing-band)
  arrowed((0, 0), (0, top))
  let height = vertex((0, 0, 1))
  line((0, height.at(1)), height)
  arrowed((0, 0), (0, 6.0), stroke: thick-line, name: "e")
  arrowed((0, 0), height, stroke: thick-line, name: "an")
  spot((0, 0), radius: 1)
  spot((0, height.at(1)), radius: 0.9)
  for s in ((1, 0, 0), (0, 1, 0), (1, 1, 0), (1, 0, 1), (0, 1, 1), (1, 1, 1)) {
    spot(vertex(s), radius: 0.5)
  }
  content((0, height.at(1)), $(a')^n_n$, anchor: "east")
  content("an.50%", $arrow(a)_n$, anchor: "west")
  content("e.mid", cutout($arrow(e)_n$), anchor: "east")
  content(
    (
      (rel: (0, -thickness), to: slab(1, 0)),
      50%,
      (rel: (0, -thickness), to: slab(1, 1)),
    ),
    $arrow(e)_1, dots, arrow(e)_(n - 1)$,
    anchor: "north",
    angle: (rel: (0, -thickness), to: slab(1, 1)),
    padding: 2,
  )
})

// Figure 5: vectors a⃗₁, a⃗ₖ at a point of the plane ℝᵏ(e⃗ᵢ₁, …, e⃗ᵢₖ) and
// their orthogonal projections b⃗₁, b⃗ₖ on it. The plane, a stippled slab,
// is seen in perspective: its sides run to the vanishing point, verticals
// stay vertical. Each vector is given by the picture of its projection and
// the picture of its height; the vectors and their verticals pass over the
// lines they cross.
#let fig-5-5() = lettered-drawing({
  import cetz.draw: *
  // The slab: its front edge, the height of its back edge, its thickness
  // and the vanishing point.
  let (front-left, front-right) = ((-8.3, -11.05), (36.1, -11.05))
  let (back, thickness) = (9.15, 2.7)
  let vanishing = (9.1, 44.5)
  let toward(p) = {
    let t = (back - p.at(1)) / (vanishing.at(1) - p.at(1))
    (p.at(0) + t * (vanishing.at(0) - p.at(0)), back)
  }
  let (back-left, back-right) = (toward(front-left), toward(front-right))
  let down(p) = (p.at(0), p.at(1) - thickness)
  line(
    front-left,
    front-right,
    down(front-right),
    down(front-left),
    close: true,
    fill: black,
  )
  line(
    front-left,
    back-left,
    back-right,
    front-right,
    close: true,
    fill: stipple,
  )
  // The projections b⃗₁, b⃗ₖ and the heights of a⃗₁, a⃗ₖ.
  let projections = ((17.0, -7.4), (24.0, -2.7))
  let heights = (13.2, 18.4)
  let ends = projections.zip(heights).map(((b, h)) => (b.at(0), b.at(1) + h))
  let origin = (0, 0)
  // The heads of the projections: long, open above, black below.
  for b in projections {
    let head = (symbol: ">", length: 5, width: 1.7)
    let beyond = (origin, 120%, b)
    line(origin, (b, head.length, origin))
    mark(b, beyond, ..head, fill: white)
    mark(b, beyond, ..head, fill: black, harpoon: true, flip: true)
  }
  // White bands where the lines pass over: the vector a⃗ₖ and its vertical
  // over the back edge, the vertical of a⃗₁ over b⃗ₖ.
  clip(rect((-20, back - 0.6), (50, back + 0.6)), {
    line(origin, ends.at(1), ..crossing-band)
    line(projections.at(1), ends.at(1), ..crossing-band)
  })
  clip(
    line(
      (rel: (0, 0.5), to: origin),
      (rel: (0, 0.5), to: projections.at(1)),
      (rel: (0, -0.5), to: projections.at(1)),
      (rel: (0, -0.5), to: origin),
      close: true,
    ),
    line(projections.at(0), ends.at(0), ..crossing-band),
  )
  for (b, a) in projections.zip(ends) { line(b, a) }
  for (i, a) in ends.enumerate() {
    line(origin, a, stroke: thick-line, name: "a" + str(i), mark: (
      end: "stealth",
      offset: 2,
      shorten-to: none,
    ))
  }
  spot(origin, radius: 1)
  content("a1.end", $arrow(a)_k$, anchor: "north-west")
  content("a0.end", cutout($arrow(a)_1$), anchor: "west")
  content(projections.at(1), cutout($arrow(b)_k$), anchor: "west")
  content(projections.at(0), cutout($arrow(b)_1$), anchor: "west")
  content(
    (front-left, 70%, back-left),
    $RR^k (arrow(e)_(i_1), dots, arrow(e)_(i_k))$,
    anchor: "east",
  )
})

// Figure 6: a domain D on Mⁿ, a black ellipse with its point x, and its
// image U(x) ⊂ ℝⁿ in the coordinates x¹, …, xⁿ; an arc joins them. The
// sheet Mⁿ and U are free-hand: smooth curves through a few points.
#let fig-5-6() = lettered-drawing({
  import cetz.draw: *
  let far-edge = (
    (-41.8, 28.3),
    (-35.2, 30.2),
    (-28.3, 30.6),
    (-19.8, 29.7),
    (-14.0, 28.0),
  )
  let right-edge = ((-14.0, 28.0), (-17.7, 21.7), (-20.9, 10.6), (-22.5, -1.1))
  let near-edge = (
    (-22.5, -1.1),
    (-28.3, 1.1),
    (-38.9, 3.4),
    (-51.1, 1.9),
    (-55.2, 0.3),
  )
  let left-edge = ((-55.2, 0.3), (-51.1, 12.7), (-45.0, 25.1), (-41.8, 28.3))
  let thickness = (0.5, -2.0)
  curved-sheet(far-edge, right-edge, near-edge, left-edge, thickness)
  // D: an ellipse about its centre, turned; the point x in it.
  let (centre, semi-axes, turn) = ((-34.4, 18.6), (9.6, 7.0), 14deg)
  let on-ellipse(t) = {
    let (u, v) = (semi-axes.at(0) * calc.cos(t), semi-axes.at(1) * calc.sin(t))
    (
      centre.at(0) + u * calc.cos(turn) - v * calc.sin(turn),
      centre.at(1) + u * calc.sin(turn) + v * calc.cos(turn),
    )
  }
  line(..sample(on-ellipse, 0deg, 360deg, n: 120), close: true, fill: black)
  let point = (-35.3, 19.3)
  spot(point, radius: 0.5, fill: white)
  content(point, text(fill: white, $x$), anchor: "north", padding: 0.8)
  content(on-ellipse(-65deg), cutout($D$), anchor: "north", padding: 1.6)
  content(
    sheet-shifted(near-edge, thickness).at(2),
    $M^n$,
    anchor: "north",
    padding: 0.8,
  )
  // The axes x¹, xⁿ and U with its point (x¹, …, xⁿ).
  let image-of-d = (
    (6.7, 18.2),
    (5.4, 12.0),
    (4.8, 7.95),
    (4.9, 5.2),
    (10.1, 5.9),
    (20.0, 6.25),
    (25.3, 5.3),
    (25.9, 7.3),
    (23.6, 11.3),
    (22.0, 15.4),
    (22.3, 18.1),
    (24.1, 22.5),
    (23.3, 24.2),
    (20.25, 24.7),
    (13.5, 23.2),
    (7.7, 19.5),
  )
  hobby(..image-of-d, close: true, fill: black, stroke: none)
  let image-point = (19.1, 16.4)
  spot(image-point, radius: 0.5, fill: white)
  content(image-point, $(x^1, dots, x^n)$, anchor: "west", padding: 3)
  content(
    (image-of-d.at(13), 50%, image-of-d.at(14)),
    $U(x) subset RR^n$,
    anchor: "south",
  )
  // The arc from U to D passes over the right side of the sheet and under
  // the axis xⁿ.
  let arc-points = (image-of-d.first(), (-8.7, 22.9), on-ellipse(0deg))
  clip(
    sheet-side(right-edge, thickness),
    arc-through(..arc-points, ..crossing-band),
  )
  arc-through(..arc-points, mark: (end: "stealth", length: 5, width: 1.4))
  line((0, -5.0), (0, 30.7), ..crossing-band)
  arrowed((0, -5.0), (0, 30.7), name: "xn")
  arrowed((-6.3, 0), (29.8, 0), name: "x1")
  content("x1.end", $x^1$, anchor: "north-east")
  content("xn.end", $x^n$, anchor: "south-west")
})

// Figure 7: a domain D on a sheet Mⁿ in ℝᴺ cut by the coordinate lines
// into small curvilinear parallelepipeds Πₖ, one of them black. The
// coordinate grid is the picture of the integer lattice under a quadratic
// map (i, j) ↦ g(i, j); the sheet and D are free-hand, smooth curves
// through a few points; the frame of ℝᴺ stands beside.
#let fig-5-7() = lettered-drawing({
  import cetz.draw: *
  arrowed((0, 0), (0, 14.7), name: "up")
  arrowed((0, 0), (11.6, 0))
  arrowed((0, 0), (-9.4, -12.1))
  content("up.27%", $RR^N$, anchor: "east")
  let far-right = (68.9, 10.1)
  curved-sheet(
    (
      (26.6, 11.7),
      (33.5, 13.2),
      (42.4, 13.9),
      (51.3, 13.7),
      (60.2, 12.1),
      far-right,
    ),
    (far-right, (66.3, 2.3), (63.4, -4.4), (59.6, -12.6)),
    (
      (59.6, -12.6),
      (51.3, -11.1),
      (42.4, -9.9),
      (33.5, -9.3),
      (24.6, -9.5),
      (15.7, -10.6),
      (10.3, -11.5),
    ),
    ((10.3, -11.5), (14.7, -3.9), (19.3, 3.7), (26.6, 11.7)),
    (0.4, -2.4),
  )
  content(far-right, $M^n$, anchor: "south")
  let domain = (
    (22.0, -1.4),
    (23.7, 3.7),
    (29.9, 8.2),
    (40.4, 10.6),
    (50.3, 10.7),
    (57.1, 9.0),
    (57.8, 7.3),
    (56.8, 5.7),
    (54.5, 4.8),
    (53.0, 2.0),
    (54.0, 0.3),
    (55.4, -1.4),
    (55.8, -3.1),
    (51.7, -5.9),
    (41.8, -6.9),
    (30.5, -6.2),
    (23.5, -4.7),
  )
  hobby(..domain, close: true, fill: white, stroke: none)
  // The grid: g(i, j) = o + i a + j b + i² c + i j e + j² f.
  let (o, a, b, c, e, f) = (
    (28.69, 0.42),
    (5.44, -0.53),
    (6.51, 5.39),
    (-0.01, -0.22),
    (0.02, -0.33),
    (-0.22, -0.33),
  )
  let g(i, j) = range(2).map(k => (
    o.at(k)
      + i * a.at(k)
      + j * b.at(k)
      + i * i * c.at(k)
      + i * j * e.at(k)
      + j * j * f.at(k)
  ))
  let (columns, rows) = ((-3, 7), (-3, 4))
  clip(hobby(..domain, close: true), {
    for i in range(..columns) {
      line(..sample(j => g(i, j), ..rows))
    }
    for j in range(..rows) {
      line(..sample(i => g(i, j), ..columns))
    }
  })
  // The black cell Πₖ.
  line(
    ..sample(i => g(i, 0), 0, 1, n: 10),
    ..sample(j => g(1, j), 0, 1, n: 10),
    ..sample(i => g(i, 1), 1, 0, n: 10),
    ..sample(j => g(0, j), 1, 0, n: 10),
    close: true,
    fill: black,
  )
  hobby(..domain, close: true, stroke: thick-line)
  content(g(0.5, -0.5), cutout($Pi_k$))
  content((58.5, 4.7), cutout($D$))
})

// Figure 8: a small curvilinear parallelepiped Πₖ at its vertex P and the
// linear one Π̃ₖ in the tangent plane TₚMⁿ spanned by the same edges at P.
// Πₖ is the quadratic patch S(u, v) = P + u U + v V + u² a + 2uv b + v² c,
// 0 ≤ u, v ≤ 1, given by the pictures of its edges at P and of its second
// order terms; Π̃ₖ is its tangent parallelogram. Both are thin slabs. Seen
// through Π̃ₖ the patch is stippled and its edges are dashed; outside it the
// patch shows dark, black with white dots.
#let fig-5-8() = lettered-drawing({
  import cetz.draw: *
  let (edge-u, edge-v) = ((12.15, 15.85), (26.75, 4.45))
  let (a, b, c) = ((3.45, -3.05), (0.85, 0.425), (-1.05, -7.25))
  let patch(u, v) = range(2).map(k => (
    u * edge-u.at(k)
      + v * edge-v.at(k)
      + u * u * a.at(k)
      + 2 * u * v * b.at(k)
      + v * v * c.at(k)
  ))
  let thickness = (0, -1.2)
  let below(p) = (p.at(0) + thickness.at(0), p.at(1) + thickness.at(1))
  // The edges of the patch: at P along U, far, near along V, right.
  let along-u = sample(u => patch(u, 0), 0, 1, n: 40)
  let far = sample(v => patch(1, v), 0, 1, n: 40)
  let near = sample(v => patch(0, v), 0, 1, n: 40)
  let right = sample(u => patch(u, 1), 0, 1, n: 40)
  let surface(..style) = line(
    ..along-u,
    ..far,
    ..right.rev(),
    ..near.rev(),
    close: true,
    ..style,
  )
  let corner = (edge-u.at(0) + edge-v.at(0), edge-u.at(1) + edge-v.at(1))
  let plane = line((0, 0), edge-u, corner, edge-v, close: true)
  let dark = tiling(size: (0.45mm, 0.45mm), {
    place(std.rect(width: 0.45mm, height: 0.45mm, fill: black))
    place(dx: 0.12mm, dy: 0.12mm, std.circle(radius: 0.1mm, fill: white))
  })
  clip(plane, mode: "outside", {
    surface(fill: dark)
    line(..far)
  })
  for side in (near, right) {
    line(..side, ..side.rev().map(below), close: true, fill: black)
  }
  clip(plane, {
    surface(fill: stipple, stroke: none)
    line(..along-u, ..far, ..hidden)
  })
  // The tangent parallelogram: its right side thick.
  line(edge-v, (0, 0), edge-u, corner)
  line(edge-v, corner, stroke: 1.5 * thick-line)
  spot((0, 0), radius: 0.9)
  content((0, 0), $P$, anchor: "north", padding: 1.4)
  content(
    (edge-u, 42%, corner),
    $tilde(Pi)_k subset T_P M^n$,
    anchor: "south",
    angle: corner,
    padding: 1.1,
  )
  content(below(patch(0.6, 1)), $Pi_k$, anchor: "north-west")
})

// Figure 9: the parallelogram Π′ₖ spanned by a⃗₁ and a⃗ₙ and the small one
// Π̃ₖ, stippled, spanned by a⃗₁·dx¹ and a⃗ₙ·dxⁿ, at the origin beside the
// orthonormal vectors e⃗₁ and e⃗ₙ along the axes. Given by the pictures of
// a⃗₁, a⃗ₙ, of the unit vectors and the increments dx¹, dxⁿ.
#let fig-5-9() = lettered-drawing({
  import cetz.draw: *
  let vectors = ((30.0, 7.3), (7.1, 21.9))
  let increments = (0.71, 0.62)
  let small = vectors.zip(increments).map(((v, d)) => v.map(c => d * c))
  let (unit, unit-n) = ((16.0, -0.86), (0, 15.6))
  let origin = (0, 0)
  // The axes: e⃗ₙ up, e⃗₁ to the right.
  line((0, -4.4), (0, 37.0))
  line(origin, (37.0, -2.0))
  line(
    ..((0, 0), (1, 0), (1, 1), (0, 1)).map(s => spanned(small, s)),
    close: true,
    fill: stipple,
    stroke: thick-line,
  )
  line(
    vectors.at(1),
    spanned(vectors, (1, 1)),
    vectors.at(0),
    stroke: thick-line,
  )
  arrowed(origin, vectors.at(0), name: "a1")
  arrowed(origin, vectors.at(1), name: "an")
  for (name, to) in (
    ("a1-dx", small.at(0)),
    ("an-dx", small.at(1)),
    ("e", unit),
    ("en", unit-n),
  ) {
    arrowed(origin, to, stroke: thick-line, name: name)
  }
  spot(origin, radius: 1.2)
  content("an.end", $arrow(a)_n$, anchor: "south", padding: 1.5)
  content("a1.end", $arrow(a)_1$, anchor: "north-west")
  // The products stand along their vectors.
  content(
    "a1-dx.end",
    $arrow(a)_1 dot d x^1$,
    anchor: "north",
    angle: vectors.at(0),
  )
  content(
    (small.at(1), 44%, vectors.at(1)),
    $arrow(a)_n dot d x^n$,
    anchor: "south",
    angle: vectors.at(1),
  )
  content("en.end", $arrow(e)_n$, anchor: "east")
  content(("e.end", 15%, origin), $arrow(e)_1$, anchor: "north")
  content(spanned(vectors, (1, 1)), $Pi'_k$, anchor: "north-west")
  content(spanned(small, (1, 1)), $tilde(Pi)_k$, anchor: "west")
})

// Figure 10: a small piece dσ of the graph xⁿ = f(x¹, …, xⁿ⁻¹) over its
// projection dω on the plane ℝⁿ⁻¹, the normal m⃗ to dσ and the angle α
// between m⃗ and e⃗ₙ. An oblique view: x to the right, the depth receding at
// the angle φ, xⁿ up. A point (x, t, z), t the drawn depth, is drawn at
// (x + t cos φ, t sin φ + z); a unit of depth is drawn k long. dσ is the
// plane z = h + a x + c t over dω; its normal (−a, −c k, 1) in space.
#let fig-5-10() = lettered-drawing({
  import cetz.draw: *
  let (phi, k) = (72.3deg, 0.5)
  let at(x, t, z) = (x + t * calc.cos(phi), t * calc.sin(phi) + z)
  // The plane: its near left corner, width and depth; the axis xⁿ at its
  // far left corner, the origin.
  let (width, depth) = (40, 21.9)
  flat-slab(at(0, -depth, 0), (width, 0), at(0, depth, 0), 1.5)
  // dω: its near left corner (x, t) and its sides; dσ above it.
  let (corner, sides) = ((12.2, -15.2), (13.9, 10.2))
  let (h, a, c) = (30.2, 0.547, 0.206)
  let height(x, t) = h + a * (x - corner.at(0)) + c * (t - corner.at(1))
  let cell = ((0, 0), (1, 0), (1, 1), (0, 1), (0.5, 0.5)).map(((s, r)) => (
    corner.at(0) + s * sides.at(0),
    corner.at(1) + r * sides.at(1),
  ))
  let below = cell.map(((x, t)) => at(x, t, 0))
  let above = cell.map(((x, t)) => at(x, t, height(x, t)))
  for points in (below, above) {
    line(..points.slice(0, 4), close: true, fill: stipple, stroke: thick-line)
  }
  for (p, q) in above.zip(below) {
    line(p, q, stroke: (dash: (array: (2.2mm, 1.2mm))))
  }
  // The normal and e⃗ₙ at the centre of dσ, both of the length `unit`.
  let unit = 15.1
  let centre = above.last()
  let norm = calc.sqrt(a * a + c * c * k * k + 1)
  let normal = at(-a * unit / norm, -c * k * k * unit / norm, unit / norm)
  let tip(v) = (centre.at(0) + v.at(0), centre.at(1) + v.at(1))
  arrowed(centre, tip(normal), name: "m")
  arrowed(centre, tip((0, unit)), name: "en")
  cetz.angle.angle(
    centre,
    tip((0, unit)),
    tip(normal),
    label: $alpha$,
    radius: 6.4,
    label-radius: 8.5,
  )
  spot(centre, radius: 0.7)
  spot(below.last(), radius: 1)
  // The axis xⁿ and e⃗ₙ at the origin.
  let top = 40.5
  arrowed((0, 0), (0, top), name: "axis")
  arrowed((0, 0), (0, 16.6), stroke: thick-line, name: "e")
  spot((0, 0))
  content("axis.end", $x^n$, anchor: "south")
  content("e.70%", $arrow(e)_n$, anchor: "east")
  content("m.end", $arrow(m)$, anchor: "east")
  content("en.end", $arrow(e)_n$, anchor: "west")
  content(above.at(2), $d sigma$, anchor: "south")
  content((below.at(1), 70%, below.at(2)), $d omega$, anchor: "west")
  content(
    (at(0, -depth, 0), 55%, at(width, -depth, 0)),
    $RR^(n - 1) (x^1, dots, x^(n - 1))$,
    anchor: "south",
  )
})
