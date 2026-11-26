// Figures of chapter 1, § 1. Each is a function called by the text:
// `#fig(fig-1-3()) <fig:…>`.
#import "common.typ": *

// Figure 1: the ellipse (x − A¹)²/a² + (y − A²)²/b² = 1 with centre
// A = (A¹, A²) and semi-axes a, b; its axes of symmetry dashed.
#let fig-1-1() = drawing({
  import cetz.draw: *
  let centre = (26.6, 16.1)
  let (a, b) = (19.1, 9.0)
  // How far the axes of symmetry run past the ellipse.
  let reach = 3.6
  plane-axes(x-start: -3.4, y-start: -3.8, 51.2, 33.2)
  circle(centre, radius: (a, b), fill: stipple)
  let vertex(dx, dy) = (rel: (dx, dy), to: centre)
  content((centre, 50%, vertex(0, b)), cutout($b$), anchor: "west")
  content((centre, 55%, vertex(a, 0)), cutout($a$), anchor: "north")
  content(centre, cutout($A$), anchor: "north-east")
  line(vertex(-a - reach, 0), vertex(a + reach, 0), ..fine-dash)
  line(vertex(0, -b - reach), vertex(0, b + reach), ..fine-dash)
  for v in (vertex(a, 0), vertex(-a, 0), vertex(0, b), vertex(0, -b)) {
    spot(v)
  }
  spot(centre)
  spot((0, 0))
})

// Figure 2: the logarithmic spiral r = e^(λφ) about the origin, from its
// inner to its outer end, with the turns between as printed.
#let fig-1-2() = drawing({
  import cetz.draw: *
  let (r-inner, r-outer) = (8.5, 19)
  let (phi-inner, phi-outer) = (229deg, 135deg + 9 * 360deg)
  let growth = calc.ln(r-outer / r-inner) / (phi-outer - phi-inner).rad()
  let spiral(t) = (
    t,
    r-inner * calc.exp(growth * (t - phi-inner).rad()),
  )
  line(..sample(spiral, phi-inner, phi-outer, n: 720))
  plane-axes(
    x-start: -23.7,
    y-start: -24.2,
    23.5,
    24,
    origin-name: none,
  )
})

// The polar angle φ of a point p: a solid black sector from the x-axis.
#let polar-angle(p, radius, label-radius, label) = cetz.angle.angle(
  (0, 0),
  (1, 0),
  p,
  fill: black,
  stroke: none,
  radius: radius,
  label-radius: label-radius,
  label: label,
)

// Figure 3: polar coordinates (r, φ) of a point, x = r cos φ, y = r sin φ.
#let fig-1-3() = drawing({
  import cetz.draw: *
  let p = (34.6deg, 31)
  plane-axes(x-start: -4.1, y-start: -4.7, 37.1, 29.5)
  polar-angle(p, 6.4, 9.5, $phi$)
  line((0, 0), p, name: "r")
  spot((0, 0))
  spot(p)
  content("r.mid", $r$, anchor: "south-east")
})

// Figure 4: the radius vector r⃗ of a point and the unit vectors e⃗_r along it
// and e⃗_φ at a right angle to it, in the direction of growing φ.
#let fig-1-4() = drawing({
  import cetz.draw: *
  let azimuth = 34.3deg
  let p = (azimuth, 31)
  // The drawn length of a unit vector.
  let unit = 16.3
  plane-axes(x-start: -4.1, y-start: -4.7, 37.6, 32.9)
  polar-angle(p, 7.4, 11, $phi$)
  arrowed((0, 0), p, name: "r")
  arrowed(p, (rel: (azimuth, unit)), stroke: thick-line, name: "e-r")
  arrowed(p, (rel: (azimuth + 90deg, unit)), stroke: thick-line, name: "e-phi")
  spot((0, 0))
  spot(p)
  content("r.mid", $arrow(r)$, anchor: "south-east")
  content("e-r.end", $arrow(e)_r$, anchor: "south-east")
  content("e-phi.end", $arrow(e)_phi$, anchor: "north-east")
})

// Figure 5: two coordinate maps of a domain C, f: C → A ⊂ ℝⁿ(x) and
// g: C → B ⊂ ℝⁿ(z), and the change of coordinates g∘f⁻¹: A → B. The
// domains are free-hand blobs, smooth closed curves through a few points;
// each space is shown by a corner of its axes, which pass over the arrows.
#let fig-1-5() = drawing({
  import cetz.draw: *
  // Where the maps leave C and reach A and B.
  let (c-f, c-g) = ((-30.3, 2.0), (-36.8, -3.1))
  let (a-f, b-g) = ((5.5, 8.6), (6.6, -13.4))
  let domain-c = (
    (-44.0, 5.2),
    (-42.5, 7.2),
    (-40.3, 6.1),
    (-38.7, 7.1),
    (-37.0, 8.1),
    (-35.4, 7.4),
    (-33.2, 6.4),
    (-31.1, 8.0),
    (-29.5, 9.8),
    (-28.2, 9.4),
    (-28.2, 6.9),
    (-29.6, 3.3),
    c-f,
    (-32.8, 0.3),
    (-35.3, -1.2),
    c-g,
    (-38.0, -4.6),
    (-39.2, -5.4),
    (-40.0, -4.1),
    (-40.3, -2.0),
    (-41.1, 0.1),
    (-43.0, 2.4),
  )
  let domain-a = (
    a-f,
    (6.8, 10.9),
    (9.5, 13.2),
    (13.3, 15.1),
    (18.0, 16.2),
    (23.1, 16.2),
    (27.3, 14.9),
    (29.0, 13.2),
    (28.2, 11.9),
    (24.3, 10.0),
    (24.6, 9.2),
    (28.2, 7.1),
    (28.1, 6.0),
    (26.5, 5.5),
    (24.8, 5.7),
    (23.7, 4.7),
    (22.4, 5.2),
    (18.4, 5.2),
    (14.6, 4.4),
    (10.4, 4.7),
    (7.4, 5.8),
    (5.9, 7.3),
  )
  let domain-b = (
    b-g,
    (8.3, -11.3),
    (11.2, -10.1),
    (15.5, -9.4),
    (20.5, -9.7),
    (24.8, -10.9),
    (28.2, -13.3),
    (30.1, -16.0),
    (30.3, -19.0),
    (28.6, -21.7),
    (24.3, -23.0),
    (18.4, -23.3),
    (12.9, -22.9),
    (9.5, -21.9),
    (7.8, -19.8),
    (9.9, -20.1),
    (11.6, -19.6),
    (10.8, -18.9),
    (8.5, -18.5),
    (11.2, -18.1),
    (15.5, -17.8),
    (16.9, -16.8),
    (14.6, -15.8),
    (9.5, -14.9),
    (7.6, -14.0),
  )
  hobby(..domain-c, close: true, fill: stipple)
  hobby(..domain-a, close: true, fill: black, stroke: none)
  hobby(..domain-b, close: true, fill: black, stroke: none)
  let point-p = (-37.7, 3.3)
  spot(point-p, radius: 0.5)
  content(point-p, $P$, anchor: "west", padding: 0.5)
  // The maps, the arrowheads of f and g inside the segments.
  line(c-f, a-f, name: "f")
  line(c-g, b-g, name: "g")
  mark((c-f, 62%, a-f), (c-f, 63%, a-f), symbol: "stealth")
  mark((c-g, 58%, b-g), (c-g, 59%, b-g), symbol: "stealth")
  arrowed((-2.1, 9.1), (-23.3, 5.6), ..hidden, name: "f-inverse")
  arrowed((22.0, 4.2), (22.0, -9.9), name: "gf-inverse")
  content("f.mid", $f$, anchor: "north")
  content("g.mid", $g$, anchor: "north-east")
  content("f-inverse.60%", $f^(-1)$, anchor: "south")
  // The corners of the axes: ℝⁿ(y) about C, ℝⁿ(x) and ℝⁿ(z) on one
  // vertical axis. An axis through `p` from `from` to `to` along it.
  let (corner-y, corner-x, corner-z) = ((-47.7, -8.8), (0, 0), (0, -24.6))
  let horizontal((x, y), from, to) = ((x + from, y), (x + to, y))
  let vertical((x, y), from, to) = ((x, y + from), (x, y + to))
  let axis-y = vertical(corner-y, -2.1, 22.6)
  bridge(
    axis-y,
    horizontal(corner-y, -3.1, 23.8),
    horizontal(corner-x, -7.0, 33.2),
    horizontal(corner-z, -6.3, 33.4),
    vertical(corner-x, -27.2, 17.2),
  )
  content(axis-y.last(), $C$, anchor: "north-west")
  content(corner-y, $RR^n lr((y))$, anchor: "north-west")
  content(corner-x, $RR^n lr((x))$, anchor: "north-west")
  content(corner-z, $RR^n lr((z))$, anchor: "south-east")
  content(
    ("gf-inverse.start", "|-", corner-x),
    $g compose f^(-1)$,
    anchor: "north-west",
  )
  content((31.5, 9.6), $A$)
  content((30.5, -12.2), $B$)
})

// Figure 6: the map w = z², in polar coordinates f(r, φ) = (r², 2φ): the
// point z (thin radius) goes to w (bold radius), the angle φ doubles.
#let fig-1-6() = drawing({
  import cetz.draw: *
  // The unit of length and the point z = ρ e^(iφ).
  let unit = 15
  let (modulus, turn) = (1.43, 20deg)
  let z = (turn, modulus * unit)
  let w = (2 * turn, modulus * modulus * unit)
  plane-axes(x-start: -5.9, y-start: -3.6, 37.9, 24.9)
  let sector(from, to) = cetz.angle.angle(
    (0, 0),
    from,
    to,
    fill: black,
    stroke: none,
    radius: 8.3,
    label-radius: 11.9,
    label: $phi$,
  )
  sector((1, 0), z)
  sector(z, w)
  // The thin radius to z parts the two black sectors.
  bridge(((0, 0), z), gap: 4 * thin-line)
  line((0, 0), w, stroke: thick-line)
  arrowed(z, w, ..fine-dash, name: "f")
  spot((0, 0))
  spot(z)
  spot(w)
  content(z, $r$, anchor: "north")
  content(w, $r^2$, anchor: "west")
  content("f.mid", $f$, anchor: "west")
})

// Figure 7: a giraffe on a square grid and its image under a curvilinear
// change of coordinates, which bends the grid and the animal. A drawing.
#let fig-1-7() = image("/assets/figures/01-07-giraffe.svg", width: 100.75mm)

// Figure 8: the map f(r, φ) = (r cos φ, r sin φ) of the strip
// C = {r > 0, 0 < φ < 2π} onto the plane A without the ray x¹ ≥ 0, x² = 0:
// the grid lines r = const go to circles, φ = const to rays. The removed ray
// is drawn as a slit of half-width `slit`, the origin as a small hole.
#let fig-1-8() = drawing({
  import cetz.draw: *
  // The strip: its grid steps, columns and rows; 2π at the top.
  let (r-step, phi-step) = (3.19, 2.87)
  let (columns, rows) = (14, 8)
  let top = rows * phi-step
  let reach = 47
  for i in range(1, rows + 1) {
    line((0, i * phi-step), (reach, i * phi-step))
  }
  for j in range(1, columns + 1) {
    line((j * r-step, 0), (j * r-step, top))
  }
  arrowed((-2.75, 0), (51.1, 0))
  line((0, -2.75), (0, 35.4))
  spot((0, 0))
  spot((0, top))
  content((0, 35.4), $phi$, anchor: "north-east")
  content((0, 0), $O$, anchor: "north-east")
  content((51.1, 0), $r$, anchor: "north-east")
  content((0, top), $2 pi$, anchor: "south-west")
  content(((0, top), 45%, (reach, top)), $C$, anchor: "south")
  content((7.4, 32.4), $RR^2 lr((r, phi))$, anchor: "west")
  arrowed((33.9, 31), (51.4, 31), name: "f")
  content("f.mid", $f$, anchor: "south")
  // The image: circles about the origin of A, the hole and `rings` more,
  // and rays at the angles of `sectors`, all cut off by the slit.
  group({
    translate((76.8, 17.9))
    let (hole, ring-step, rings, sectors) = (3.39, 3.32, 6, 18)
    let slit = 1.9
    let outer = hole + rings * ring-step
    for k in range(rings + 1) {
      let radius = hole + k * ring-step
      let start = calc.asin(slit / radius)
      arc(
        (0, 0),
        start: start,
        stop: 360deg - start,
        radius: radius,
        anchor: "origin",
      )
    }
    for j in range(1, sectors) {
      let angle = j * 360deg / sectors
      // A ray in the right half-plane starts where it leaves the slit.
      let start = if calc.cos(angle) > 0 {
        calc.max(hole, slit / calc.abs(calc.sin(angle)))
      } else { hole }
      line((angle, start), (angle, outer))
    }
    for side in (1, -1) {
      let y = side * slit
      line(
        (calc.sqrt(hole * hole - slit * slit), y),
        (calc.sqrt(outer * outer - slit * slit), y),
      )
    }
    arrowed((9.8, 0), (27.3, 0))
    spot((0, 0))
    content((27.3, 0), $x^1$, anchor: "north")
    content((0, outer), $x^2$, anchor: "north-west")
    content((-outer, outer), $RR^2 lr((x^1, x^2))$, anchor: "south")
    content((0.64 * outer, outer), $A$, anchor: "south")
  })
})

// A stippled angle at the origin of space between the unit vectors `a` and
// `b` (b at a right angle to a), of `angle` and `radius`, under the
// projection `at`.
#let space-angle(at, a, b, angle, radius) = {
  let arm(t) = at(
    a.zip(b).map(((p, q)) => radius * (calc.cos(t) * p + calc.sin(t) * q)),
  )
  cetz.draw.line(
    (0, 0),
    ..sample(arm, 0deg, angle, n: 24),
    close: true,
    fill: stipple,
  )
}

// Figure 9: cylindrical coordinates x¹ = r cos φ, x² = r sin φ, x³ = z.
// Left, the slab C = {r > 0, 0 < φ < 2π} of ℝ³(r, φ, z); in the middle, its
// image A, a box of ℝ³(x¹, x², x³) without the half-plane φ = 0, drawn as a
// slot, and the axis, drawn as a hole about it; right, the coordinates of a
// point. Hidden lines dashed.
#let fig-1-9() = drawing({
  import cetz.draw: *
  // The slab: r to the right and back, φ to the left and back, z up; its
  // edges along r end at `reach`, those of the hidden face φ = 2π sooner.
  group({
    let at = projection((0.799, 0.603), (-0.821, 0.471), (0, 1))
    let (reach, bottom, top) = (18.5, -12.4, 11.9)
    let turn = 2 * calc.pi
    line(at((0, turn, 0)), at((0.95 * reach, turn, 0)), ..hidden)
    line(at((0, turn, bottom)), at((0.95 * reach, turn, bottom)), ..hidden)
    line(at((0, turn, top)), at((0.74 * reach, turn, top)))
    line(at((0, 0, top)), at((reach, 0, top)))
    line(at((0, 0, bottom)), at((reach, 0, bottom)))
    line(
      at((0, 0, bottom)),
      at((0, turn, bottom)),
      at((0, turn, top)),
      at((0, 0, top)),
    )
    arrowed(at((0, 0, bottom)), at((0, 0, 17.9)), name: "z")
    arrowed((0, 0), at((reach, 0, 0)), name: "r")
    arrowed((0, 0), at((0, 1.84 * turn, 0)), name: "phi")
    spot((0, 0))
    spot(at((0, turn, 0)))
    content("z.end", $z$, anchor: "north-west")
    content("r.end", $r$, anchor: "north")
    content("phi.end", $phi$, anchor: "south")
    content(at((0, turn, top)), $C$, anchor: "east")
    content(at((0, turn, 0)), $2 pi$, anchor: "north-east")
    content((0, 0), $O$, anchor: "north-east")
    content(at((0, 0, bottom)), $RR^3 lr((r, phi, z))$, anchor: "north")
  })
  arrowed((16.1, 19.9), (25.2, 19.9), name: "f")
  content("f.mid", $f$, anchor: "north")
  // The box A: width, depth and height along u, v, w, seen from the front
  // right; the axis at (u, v) = `axis` with the hole of radius `hole` about
  // it, the slot of half-width `slot` from it to the back.
  group({
    translate((18.62, -4.02))
    let azimuth = 41.6deg
    let view = orthographic(azimuth, 31deg)
    let at = view.project
    let (width, depth, height) = (22.65, 29.33, 17.78)
    let axis = (9.97, 6.86)
    let (hole, slot) = (3.74, 1.79)
    let (u1, u2) = (axis.at(0) - slot, axis.at(0) + slot)
    // Where the sides of the slot leave the hole.
    let v-slot = axis.at(1) + calc.sqrt(hole * hole - slot * slot)
    let rim(s, w) = at((
      axis.at(0) + hole * calc.cos(s),
      axis.at(1) + hole * calc.sin(s),
      w,
    ))
    // Hidden: the back corner, the hole's outline at the bottom with the
    // slot, the hole's contour, the back edges of the slot.
    line(at((0, 0, 0)), at((0, depth, 0)), at((0, depth, height)), ..hidden)
    line(at((0, depth, 0)), at((u1, depth, 0)), ..hidden)
    line(at((u2, depth, 0)), at((width, depth, 0)), ..hidden)
    let opening = calc.acos(slot / hole)
    line(..sample(s => rim(s, 0), 180deg - opening, 360deg + opening), ..hidden)
    for u in (u1, u2) {
      line(at((u, v-slot, 0)), at((u, depth, 0)), ..hidden)
      line(at((u, depth, 0)), at((u, depth, height)), ..hidden)
    }
    // The contour of the hole: its tangents along the line of sight.
    for s in (azimuth, azimuth + 180deg) {
      line(rim(s, 0), rim(s, height), ..hidden)
    }
    // The hole and the slot open black at the top; through the slot one
    // sees its wall u = u1 as far as its back edge.
    let v-wall = depth - 2 * slot / calc.tan(azimuth)
    let cut = (fill: black, stroke: none)
    line(..sample(s => rim(s, height), 0deg, 360deg, n: 72), close: true, ..cut)
    line(
      at((u1, axis.at(1), height)),
      at((u1, depth, height)),
      at((u2, v-wall, height)),
      at((u2, axis.at(1), height)),
      close: true,
      ..cut,
    )
    // Visible edges.
    line(
      at((0, depth, height)),
      at((0, 0, height)),
      at((0, 0, 0)),
      at((width, 0, 0)),
      at((width, depth, 0)),
      at((width, depth, height)),
      at((width, 0, height)),
      at((0, 0, height)),
    )
    line(at((width, 0, 0)), at((width, 0, height)))
    line(at((0, depth, height)), at((u1, depth, height)))
    line(at((u2, depth, height)), at((width, depth, height)))
    for u in (u1, u2) {
      line(at((u, v-slot, height)), at((u, depth, height)))
    }
    content(at((width, 0, 0)), $RR^3 lr((x^1, x^2, x^3))$, anchor: "north")
  })
  content((52.5, 20.5), $A$)
  // The coordinates (r, φ, z) of a point: x¹ to the front, x² to the right.
  group({
    translate((67.85, 0.85))
    let at = projection((-0.447, -0.352), (1, 0), (0, 1))
    let (r, turn, height) = (23.45, 45deg, 13.42)
    let foot = (r * calc.cos(turn), r * calc.sin(turn), 0)
    let point = (foot.at(0), foot.at(1), height)
    space-angle(at, (1, 0, 0), (0, 1, 0), turn, 7.2)
    arrowed((0, 0), at((27.1, 0, 0)), name: "x1")
    arrowed((0, 0), at((0, 14.7, 0)), name: "x2")
    arrowed((0, 0), at((0, 0, 19.5)), name: "x3")
    line((0, 0), at(foot), name: "r")
    line(at((0, 0, height)), at(point), at(foot))
    line((0, 0), at(point))
    for p in (point, foot, (0, 0, height)) { spot(at(p)) }
    content("x1.end", $x^1$, anchor: "north-west")
    content("x2.end", $x^2$, anchor: "north-east")
    content("x3.end", $x^3$, anchor: "north-west")
    content(at((0, 0, height)), $z$, anchor: "east")
    content("r.50%", $r$, anchor: "south", padding: 0.4)
    content(
      at((7.2 * calc.cos(turn / 2), 7.2 * calc.sin(turn / 2), 0)),
      $phi$,
      anchor: "north",
    )
  })
})
// Figure 10: spherical coordinates x¹ = r sin θ cos φ, x² = r sin θ sin φ,
// x³ = r cos θ. Left, the domain C = {r > 0, 0 < θ < π, 0 < φ < 2π} of
// ℝ³(r, θ, φ), its face r = 0 black; in the middle, a ball of ℝ³(x¹, x², x³)
// without the axis x³, drawn as a hole about it, and the half-plane x² = 0,
// x¹ ≥ 0, drawn as a slot; right, the coordinates of a point.
#let fig-1-10() = drawing({
  import cetz.draw: *
  // The domain: θ to the left, φ up, r to the right and back; it goes on
  // past r = `depth`.
  group({
    let at = projection((0.958, 0.286), (-4.177, 1.280), (0, 2.506))
    let (half-turn, turn) = (calc.pi, 2 * calc.pi)
    let (depth, beyond) = (22.2, 7)
    let corners = ((half-turn, turn), (0, turn), (half-turn, 0))
    line(at((0, half-turn, 0)), at((depth, half-turn, 0)), ..hidden)
    line(
      at((depth, half-turn, turn)),
      at((depth, half-turn, 0)),
      at((depth, 0, 0)),
      ..hidden,
    )
    for (a, b) in corners {
      line(at((depth, a, b)), at((depth + beyond, a, b)), ..hidden)
    }
    line(
      (0, 0),
      at((0, half-turn, 0)),
      at((0, half-turn, turn)),
      at((0, 0, turn)),
      close: true,
      fill: black,
    )
    line(at((0, half-turn, turn)), at((depth, half-turn, turn)), at((
      depth,
      0,
      turn,
    )))
    line(at((0, 0, turn)), at((depth, 0, turn)), at((depth, 0, 0)))
    arrowed((0, 0), at((28.4, 0, 0)))
    arrowed((0, 0), at((0, 1.35 * half-turn, 0)), name: "theta")
    arrowed((0, 0), at((0, 0, 1.35 * turn)), name: "phi")
    for p in ((0, 0, 0), (0, half-turn, 0), (0, 0, turn)) {
      spot(at(p), radius: 0.8, stroke: (paint: white, thickness: 0.35mm))
    }
    content("theta.end", $theta$, anchor: "south-west")
    content("phi.end", $phi$, anchor: "north-west")
    content(at((0, half-turn, 0)), $pi$, anchor: "north")
    content((0, 0), $O$, anchor: "north-west")
    content(at((0, 0, turn)), $2 pi$, anchor: "north-west")
    content(
      (14.5, -6.8),
      $C lr((r, theta, phi)) limits(arrow.r)_f A lr((x^1, x^2, x^3))$,
    )
  })
  // The ball of radius `radius`, seen from above; the hole of radius
  // `hole` about the axis x³, the slot of half-width `slot` from it along
  // x¹. The frame x¹, x², x³ is drawn as printed: x¹ to the front right.
  group({
    translate((47.20, 10.71))
    let azimuth = 38.4deg
    let view = orthographic(azimuth, 27.4deg)
    let at = view.project
    let seen(p) = facing(view, p)
    let (radius, hole, slot) = (17.78, 3.2, 2.0)
    let rim = calc.sqrt(radius * radius - hole * hole)
    let slot-radius = calc.sqrt(radius * radius - slot * slot)
    let leave = calc.asin(rim / slot-radius)
    // The rims of the slot on the sphere, from the hole at the top to the
    // hole at the bottom.
    let slot-rim(side) = sample(
      t => (slot-radius * calc.cos(t), side * slot, slot-radius * calc.sin(t)),
      leave,
      -leave,
      n: 90,
    )
    let rims = (slot-rim(1), slot-rim(-1))
    // Hidden: the hole at the bottom and its contour, the slot's rims
    // behind the ball.
    let opening = calc.asin(slot / hole)
    line(
      ..sample(
        s => at((hole * calc.cos(s), hole * calc.sin(s), -rim)),
        opening,
        360deg - opening,
      ),
      ..hidden,
    )
    for s in (azimuth, azimuth + 180deg) {
      let foot = (hole * calc.cos(s), hole * calc.sin(s))
      line(at((..foot, -rim)), at((..foot, rim)), ..hidden)
    }
    for side in (1, -1) {
      let corner = (calc.sqrt(hole * hole - slot * slot), side * slot)
      line(at((..corner, -rim)), at((..corner, rim)), ..hidden)
    }
    for points in rims {
      let behind = points.filter(p => not seen(p))
      line(
        ..(points.at(points.len() - behind.len() - 1), ..behind).map(at),
        ..hidden,
      )
    }
    // The hole and the slot open black on the front of the sphere.
    let cut = (fill: black, stroke: none)
    line(
      ..sample(
        s => at((hole * calc.cos(s), hole * calc.sin(s), rim)),
        0deg,
        360deg,
        n: 72,
      ),
      close: true,
      ..cut,
    )
    line(
      ..rims.at(0).filter(seen).map(at),
      ..rims.at(1).filter(seen).rev().map(at),
      close: true,
      ..cut,
    )
    circle((0, 0), radius: radius, stroke: 2 * thick-line)
    arrowed((0, 0), at((13.3, 0, 0)), name: "x1")
    arrowed((0, 0), at((0, -14.1, 0)), name: "x2")
    arrowed((0, 0), at((0, 0, 8.7)), name: "x3")
    spot((0, 0))
    content("x1.end", $x^1$, anchor: "north")
    content("x2.end", $x^2$, anchor: "north-west")
    content("x3.end", cutout($x^3$), anchor: "south")
  })
  // The coordinates (r, θ, φ) of a point: x¹ to the front, x² to the right.
  group({
    translate((69.72, -4.44))
    let at = projection((-0.489, -0.526), (1, 0), (0, 1))
    let (r, polar, turn) = (28.6, 49.3deg, 45deg)
    let across = (calc.cos(turn), calc.sin(turn), 0)
    let point = (
      r * calc.sin(polar) * calc.cos(turn),
      r * calc.sin(polar) * calc.sin(turn),
      r * calc.cos(polar),
    )
    let foot = (point.at(0), point.at(1), 0)
    space-angle(at, (1, 0, 0), (0, 1, 0), turn, 4.6)
    space-angle(at, (0, 0, 1), across, polar, 4.2)
    arrowed((0, 0), at((23, 0, 0)), name: "x1")
    arrowed((0, 0), at((0, 15, 0)), name: "x2")
    arrowed((0, 0), at((0, 0, 23.15)), name: "x3")
    line((0, 0), at(point), at(foot), (0, 0))
    spot(at(point))
    spot(at(foot))
    content("x1.end", $x^1$, anchor: "south-east")
    content("x2.end", $x^2$, anchor: "north-east")
    content("x3.end", $x^3$, anchor: "west")
    content(at((0, 0, 4.9)), $theta$, anchor: "east")
    content((2.3, 5.7), $r$)
    content(
      at((4.6 * calc.cos(turn / 2), 4.6 * calc.sin(turn / 2), 0)),
      $phi$,
      anchor: "north",
    )
  })
})
// Figure 11: the coordinate lines of θ and φ on a sphere r = const: three
// great circles through the poles, at longitudes `meridians`, and parallels
// about either pole, at the polar angles `parallels`; the north pole tilted
// towards the viewer, the hidden arcs dashed.
#let fig-1-11() = drawing({
  import cetz.draw: *
  let radius = 15.45
  let view = orthographic(0deg, 51deg)
  let at = view.project
  let seen(p) = facing(view, p)
  let on-sphere(polar, turn) = (
    radius * calc.sin(polar) * calc.cos(turn),
    radius * calc.sin(polar) * calc.sin(turn),
    radius * calc.cos(polar),
  )
  let meridians = range(3).map(k => -80deg + k * 60deg)
  let parallels = (7.5deg, 19deg, 34.5deg, 159deg, 170deg)
  for turn in meridians {
    seen-hidden(at, seen, sample(t => on-sphere(t, turn), 0deg, 360deg))
  }
  for polar in parallels {
    seen-hidden(at, seen, sample(t => on-sphere(polar, t), 0deg, 360deg))
  }
  circle((0, 0), radius: radius)
})
