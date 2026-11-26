// Figures of chapter 4, § 2. Each is a function called by the text:
// `#fig(fig-4-6()) <fig:…>`.
#import "common.typ": *
#import "04-02-surfaces-b.typ": *

// The intervals of [a, b] where `holds(s)`, their ends found by bisection.
#let surface-runs(holds, a, b, n: 90) = {
  let edge(lo, hi) = {
    let inside = holds(lo)
    for _ in range(24) {
      let mid = (lo + hi) / 2
      if holds(mid) == inside { lo = mid } else { hi = mid }
    }
    (lo + hi) / 2
  }
  let runs = ()
  let start = if holds(a) { a } else { none }
  let previous = a
  for i in range(1, n + 1) {
    let s = a + (b - a) * i / n
    let inside = holds(s)
    if inside and start == none { start = edge(previous, s) }
    if not inside and start != none {
      runs.push((start, edge(previous, s)))
      start = none
    }
    previous = s
  }
  if start != none { runs.push((start, b)) }
  runs
}

// The parts of the curve s ↦ curve(s), s in [a, b], where `holds(s)`,
// under the projection `at`.
#let surface-curve(at, curve, holds, a, b, n: 60, ..style) = {
  for (from, to) in surface-runs(holds, a, b) {
    cetz.draw.line(..sample(s => at(curve(s)), from, to, n: n), ..style)
  }
}

// A surface of revolution about the axis z, of radius r = f(z) with the
// slope f′ = `slope`, seen in the orthographic `view`. Its point at the
// height z and the angle t; whether it faces the viewer, that is, whether
// the normal (cos t, sin t, −f′(z)) points towards the viewer; the angle
// `front` of the meridian facing the viewer; and the outline at the height
// z, where the normal is at a right angle to the line of sight: the angles
// front ∓ δ, between them the side facing the viewer.
#let revolution-about-z(radius, slope, view) = {
  let (wx, wy, wz) = view.toward
  let across = calc.sqrt(wx * wx + wy * wy)
  let front = calc.atan2(wx, wy)
  (
    point: (z, t) => (
      radius(z) * calc.cos(t),
      radius(z) * calc.sin(t),
      z,
    ),
    faces: (z, t) => calc.cos(t) * wx + calc.sin(t) * wy - slope(z) * wz > 0,
    front: front,
    outline: z => {
      let half = calc.acos(slope(z) * wz / across)
      (front - half, front + half)
    },
  )
}

// Figure 6: the hyperboloid of one sheet r² = a² + k²(z − z₀)², a surface of
// revolution φ = u, z = v, r = r(v), with its coordinate lines: parallels
// z = const at equal steps, meridians φ = const at equal angles. The opening
// at the top shows the black inside, the meridians white along its rim; the
// lower edge is a band, widest in front. Only the outer side is seen.
#let fig-4-6() = drawing({
  import cetz.draw: *
  let view = orthographic(12deg, 21deg)
  let at = view.project
  // The radius of the waist, the slope k of the asymptotic cone, the
  // height of the waist and the whole height; the steps of the grid.
  let (waist, spread, waist-height, height) = (7, 0.5815, 31.85, 47.1)
  let (layers, meridians) = (17, 24)
  let radius(z) = calc.sqrt(
    waist * waist + calc.pow(spread * (z - waist-height), 2),
  )
  let slope(z) = spread * spread * (z - waist-height) / radius(z)
  let surface = revolution-about-z(radius, slope, view)
  let point = surface.point
  let faces = surface.faces
  set-style(stroke: thick-line)
  for i in range(layers) {
    let z = i * height / layers
    surface-curve(at, t => point(z, t), t => faces(z, t), 0deg, 360deg)
  }
  for j in range(meridians) {
    let t = surface.front + j * 360deg / meridians
    surface-curve(at, z => point(z, t), z => faces(z, t), 0, height)
  }
  for side in (0, 1) {
    line(..sample(
      z => at(point(z, (surface.outline)(z).at(side))),
      0,
      height,
      n: 60,
    ))
  }
  let rim(z, t) = at(point(z, t))
  // The opening and the meridians inside it, seen at its rim.
  let (top-r, mouth) = (radius(height), 0.8)
  line(..sample(t => rim(height, t), 0deg, 360deg, n: 120), fill: black)
  line(
    ..sample(
      t => at((
        (top-r - mouth) * calc.cos(t),
        (top-r - mouth) * calc.sin(t),
        height,
      )),
      0deg,
      360deg,
      n: 120,
    ),
    stroke: (
      paint: white,
      thickness: 0.5mm,
      cap: "butt",
      dash: (array: (0.22mm, 0.62mm)),
    ),
  )
  // The lower edge, as a band below the seen arc of the lower rim.
  let band = 1.1
  let (from, to) = (surface.outline)(0)
  line(
    ..sample(t => rim(0, t), from, to),
    ..sample(
      t => {
        let (x, y) = rim(0, t)
        (x, y - band * calc.sin((t - from) / (to - from) * 180deg))
      },
      to,
      from,
    ),
    close: true,
    fill: black,
  )
  // The axes from the centre of the lower rim; z drawn from the centre of
  // the opening, white over it.
  let reach-x = radius(0) + 7.6
  let reach-y = radius(0) + 13
  let top-centre = at((0, 0, height))
  arrowed(
    at((radius(0), 0, 0)),
    at((reach-x, 0, 0)),
    name: "x",
    stroke: thin-line,
  )
  arrowed(
    at((0, -radius(0), 0)),
    at((0, -reach-y, 0)),
    name: "y",
    stroke: thin-line,
  )
  arrowed(top-centre, at((0, 0, height + 17.8)), name: "z", stroke: thin-line)
  line(
    top-centre,
    (rel: (0, top-r * calc.sin(21deg) - mouth), to: top-centre),
    stroke: (paint: white, thickness: thin-line),
  )
  circle(top-centre, radius: 0.7, stroke: (paint: white, thickness: 0.35mm))
  content("x.end", $x$, anchor: "north-east")
  content("y.end", $y$, anchor: "south-east")
  content("z.end", $z$, anchor: "north-west")
  content(rim(height, 25deg), $V^2$, anchor: "south-west")
})

// Figure 7: a piece of the hypersurface V^(n−1), a curve γ(t) on it through
// P with the velocity a⃗ = γ̇(0), the normal n⃗(P) and the radius vector r⃗
// from O, hidden under the piece. A drawing.
#let fig-4-7() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-07-surface-curve.svg",
    40.81,
    corner: (0.89, 0.97),
  )
  content((18.5, 31.3), $arrow(n) lr((P))$, anchor: "west")
  content((16.4, 22.1), cutout($P$), anchor: "south-east")
  content(
    (22.6, 23),
    cutout($arrow(a) = dot(gamma) lr((0))$),
    anchor: "south-west",
  )
  content((32.1, 14.4), cutout($gamma lr((t))$))
  content(
    (7.9, 4.7),
    $arrow(r) = arrow(r) lr((u^1, dots, u^(n-1)))$,
    anchor: "west",
  )
  content((3.3, 1.4), $O$, anchor: "east")
  content((33, 1.5), $V^(n-1) subset RR^n$, anchor: "west")
})
// Figure 8: q(a⃗, a⃗) = ⟨r̈_a⃗, n⃗⟩ is the projection of r̈_a⃗ on the unit
// normal n⃗ at P: the foot of the perpendicular from the end of r̈_a⃗ to the
// line of n⃗, which runs on past it.
#let fig-4-8() = drawing({
  import cetz.draw: *
  let (origin, p) = ((1.8, 6), (24.9, 13.1))
  // The drawn n⃗ and r̈_a⃗, and how far the line of n⃗ runs past the foot.
  let (normal, second, beyond) = ((0, 12.4), (9.4, 16.9), 3.5)
  let shift(q, v, c) = q.zip(v).map(((a, b)) => a + c * b)
  let length = calc.sqrt(normal.map(v => v * v).sum())
  let along = vec-dot(second, normal) / length
  let foot = shift(p, normal, along / length)
  let dot-radius = 1
  set-style(stroke: thick-line)
  line(shift(p, normal, 1), shift(foot, normal, beyond / length), ..hidden)
  line(foot, shift(p, second, 1), ..hidden)
  arrowed(origin, (p, dot-radius, origin), name: "r")
  arrowed(p, shift(p, second, 1), name: "second")
  arrowed(p, shift(p, normal, 1), stroke: 2 * thick-line, name: "n")
  spot(origin, radius: dot-radius)
  spot(p, radius: dot-radius)
  spot(foot)
  content("n.85%", $arrow(n)$, anchor: "east")
  content(p, $P$, anchor: "west", padding: 1 + dot-radius)
  content("r.72%", $arrow(r)$, anchor: "north")
  content(origin, $O$, anchor: "north-west", padding: 0.8 * dot-radius)
  content("second.80%", $dot.double(arrow(r))_(arrow(a))$, anchor: "north-west")
})

// Figure 9: a piece of the plane V², r⃗(u, v) linear, with the frame x = u,
// y = v, z: a slab whose top is stippled and whose front face is black, in
// an oblique view (x towards the viewer, down to the left). The piece is
// the trapezoid between the lines x = `back` and x = `front`.
#let fig-4-9() = drawing({
  import cetz.draw: *
  let at = projection((-0.402, -0.916), (1, 0), (0, 1))
  let (back, front) = (-8, 10.8)
  let (back-y, front-y) = ((-11.3, 4.7), (-15.75, 18.25))
  let thickness = 3
  let origin = (20.6, 13.7)
  translate(origin)
  let corners = (
    (back, back-y.at(0)),
    (back, back-y.at(1)),
    (front, front-y.at(1)),
    (front, front-y.at(0)),
  ).map(((x, y)) => at((x, y, 0)))
  let (left-front, right-front) = (corners.at(3), corners.at(2))
  let below((x, y)) = (x, y - thickness)
  line(..corners, close: true, fill: stipple, stroke: thick-line)
  line(
    left-front,
    right-front,
    below(right-front),
    below(left-front),
    close: true,
    fill: black,
    stroke: thick-line,
  )
  arrowed((0, 0), at((9, 0, 0)), stroke: thick-line, name: "x")
  arrowed((0, 0), at((0, 7.9, 0)), stroke: thick-line, name: "y")
  bridge(((0, 0), at((0, 0, 14.5))), gap: 1.6)
  arrowed((0, 0), at((0, 0, 16.1)), stroke: thick-line, name: "z")
  spot((0, 0), radius: 0.9)
  content("z.end", $z$, anchor: "north-west")
  content((corners.at(0), 62%, left-front), $V^2$, anchor: "east")
  content("x.80%", cutout($x = u$), anchor: "east", padding: 1.5)
  content(at((0, 6, -2.2)), cutout($y = v$))
})
// Figure 10: the plane rolled into a cylinder of radius R about an axis
// parallel to Ox, with the frame x = u, y = v, z at a point of its top
// generator. A central projection looking along the axis: the sections
// X = const are circles shrinking towards the vanishing point of the axis,
// the outline the tangents from it to the open front end, which shows the
// black inside. The outer side is seen between the outline, up to the far
// rim; the section through the frame is drawn there.
#let fig-4-10() = drawing({
  import cetz.draw: *
  // The front centre and radius on the page, the vanishing point; the
  // distance of the eye from the front end, the length, the section.
  let (centre, radius, vanish) = ((12.3, 19.4), 12.2, (43.5, 66.5))
  let (distance, length, section) = (40, 80, 17.4)
  // A point at depth X behind the front end, (Y, Z) from the axis.
  let at((depth, y, z)) = {
    let k = distance / (distance + depth)
    (
      vanish.at(0) + (centre.at(0) + y - vanish.at(0)) * k,
      vanish.at(1) + (centre.at(1) + z - vanish.at(1)) * k,
    )
  }
  let rim(depth, t) = at((depth, radius * calc.cos(t), radius * calc.sin(t)))
  // The outline generators: the tangents from the vanishing point.
  let (dx, dy) = (vanish.at(0) - centre.at(0), vanish.at(1) - centre.at(1))
  let toward = calc.atan2(dx, dy)
  let half = calc.acos(radius / calc.sqrt(dx * dx + dy * dy))
  let seen = (toward - half, toward + half)
  set-style(stroke: thick-line)
  for t in seen { line(rim(0, t), rim(length, t)) }
  line(..sample(t => rim(length, t), ..seen))
  line(..sample(t => rim(section, t), ..seen))
  circle(centre, radius: radius, fill: black)
  circle(centre, radius: radius - 0.7, stroke: (
    paint: white,
    thickness: 0.45mm,
    cap: "butt",
    dash: (array: (0.3mm, 0.62mm)),
  ))
  // The frame at the top generator: x = u towards the eye, along the axis.
  let top = (section, 0, radius)
  let shifted(dx, dy, dz) = at(top.zip((dx, dy, dz)).map(((a, b)) => a + b))
  arrowed(at(top), shifted(-12.5, 0, 0), name: "x")
  arrowed(at(top), shifted(0, 25, 0), name: "y")
  arrowed(at(top), shifted(0, 0, 20.7), name: "z")
  spot(at(top), radius: 0.9)
  content("x.75%", $x = u$, anchor: "west", padding: 1.5)
  content("y.end", $y = v$, anchor: "north")
  content("z.end", $z$, anchor: "north-west")
})

// Figure 11: the invariants σ₁, …, σ_(n−1) as a row of cells, the
// «extreme» ones σ₁ and σ_(n−1) black, the others {σ_k} parted by dashes.
#let fig-4-11() = drawing({
  import cetz.draw: *
  let (cells, width, height) = (7, 5.16, 7.5)
  let middle(k) = ((k + 0.5) * width, 0)
  set-style(stroke: thick-line)
  for k in (0, cells - 1) {
    rect((k * width, 0), ((k + 1) * width, height), fill: black)
  }
  for k in range(2, cells - 1) {
    line((k * width, 0), (k * width, height), stroke: (
      dash: (array: (1.25mm, 0.55mm)),
    ))
  }
  rect((0, 0), (cells * width, height))
  content(middle(0), $sigma_1$, anchor: "north")
  content(middle((cells - 1) / 2), ${sigma_k}$, anchor: "north")
  content(middle(cells - 1), $sigma_(n-1)$, anchor: "north")
})

// Figure 12: the hypersurface V^(n−1) as the graph xⁿ = f(x¹, …, x^(n−1))
// over its tangent plane T_P V^(n−1) at P, the plane of x¹, …, x^(n−1);
// the normal n⃗(P) along xⁿ. A drawing.
#let fig-4-12() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-12-tangent-plane.svg",
    49.7,
    corner: (2.79, 0.89),
  )
  content((28.3, 35), $x^n$, anchor: "east")
  content((29.5, 35), $arrow(n) lr((P))$, anchor: "west")
  content((27.8, 22.6), cutout($P$), anchor: "south-east")
  content((39.3, 19.7), cutout($x^(n-1)$))
  content((26.9, 13.9), cutout($x^1$), anchor: "west", padding: 0)
  content((35.3, 4.7), $V^(n-1) subset RR^n$, anchor: "north", padding: 0.4)
})

// Figure 13: a plane ℝ² through P cuts V^(n−1) in the plane section γ; the
// normal m⃗(P) of γ in ℝ² makes the angle θ with the normal n⃗(P) of the
// hypersurface; the radius vector from O, hidden. A drawing.
#let fig-4-13() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-13-plane-section.svg",
    50.04,
    corner: (0.93, 0.8),
  )
  content((31.4, 45.9), $arrow(n) lr((P))$, anchor: "east")
  content(
    (25.4, 37.4),
    cutout($arrow(m) lr((P))$),
    anchor: "east",
    padding: 0.6,
  )
  content((44.6, 41.7), cutout($RR^2$))
  content((29.9, 29.1), cutout($theta$))
  content((26.8, 24.7), $P$, anchor: "north-west", padding: 1.2)
  content((13.3, 5), $O$, anchor: "east")
  content(
    (52.3, 4.3),
    $V^(n-1) subset RR^n$,
    anchor: "north-east",
    padding: 0,
  )
})

// Figure 14: the angles φ_k between a unit vector α⃗ of T_P V^(n−1) and the
// principal directions e⃗₁, e⃗ᵢ, e⃗_(n−1), drawn as stippled sectors of radius
// R in the planes of α⃗ and e⃗_k. Space in an oblique view: e⃗ᵢ to the right,
// e⃗_(n−1) up, e⃗₁ towards the viewer, down to the left; α⃗ by its
// direction cosines.
#let fig-4-14() = drawing({
  import cetz.draw: *
  let at = projection((-0.562, -0.614), (1, 0), (0, 1))
  let (cos-i, cos-top) = (calc.cos(26deg), calc.cos(65.7deg))
  let direction = (
    calc.sqrt(1 - cos-i * cos-i - cos-top * cos-top),
    cos-i,
    cos-top,
  )
  let radius = 9.5
  let axes = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
  // The sector from the axis e towards α⃗: the unit vector u of its plane
  // at a right angle to e, the arc from e to α⃗.
  let arc(e) = {
    let c = vec-dot(direction, e)
    let u = vec-scale(
      1 / calc.sqrt(1 - c * c),
      vec-add(direction, vec-scale(-c, e)),
    )
    sample(
      t => at(vec-scale(radius, vec-add(
        vec-scale(calc.cos(t), e),
        vec-scale(calc.sin(t), u),
      ))),
      0deg,
      calc.acos(c),
      n: 30,
    )
  }
  let arcs = axes.map(arc)
  set-style(stroke: thick-line)
  for points in arcs {
    line((0, 0), ..points, close: true, fill: stipple)
  }
  // The vectors, their arrowheads short of their ends.
  let vectors = (
    ("e1", vec-scale(2.41 * radius, axes.at(0))),
    ("ei", vec-scale(2.58 * radius, axes.at(1))),
    ("en", vec-scale(1.81 * radius, axes.at(2))),
    ("alpha", vec-scale(3.2 * radius, direction)),
  )
  for (name, v) in vectors {
    line((0, 0), at(v), name: name)
    mark(name + ".86%", name + ".88%", symbol: "stealth")
  }
  spot((0, 0), radius: 0.85)
  spot(at(vec-scale(radius, direction)), radius: 0.85)
  content("en.end", $arrow(e)_(n-1)$, anchor: "north-west")
  content("ei.end", $arrow(e)_i$, anchor: "north-east")
  content("e1.85%", $arrow(e)_1$, anchor: "west", padding: 2)
  content("alpha.end", $arrow(alpha)$, anchor: "south-east")
  content((0, 0), $P$, anchor: "south-east", padding: 1.5)
  content(arcs.at(2).at(18), $phi_(n-1)$, anchor: "south-west")
  content(arcs.at(1).at(15), $phi_i$, anchor: "west")
  content(arcs.at(0).at(18), $phi_1$, anchor: "north", padding: 1.5)
})

// Figure 15: the sphere S^(n−2) about O, its tangent plane T_(x₀) S^(n−2) at
// x₀ with the vector B x⃗₀, a curve γ(t) on the sphere from x₀ with the
// velocity b⃗. A drawing.
#let fig-4-15() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-15-sphere-tangent.svg",
    41.36,
    corner: (2.12, 1.9),
  )
  set-style(content: (padding: 0))
  content((24.4, 55.2), $B arrow(x)_0$, anchor: "west")
  content((30.5, 48.7), $T_(x_0) S^(n-2)$, anchor: "west")
  content((21.9, 38.9), $x_0$, anchor: "east")
  content((30.6, 39.4), $arrow(b)$)
  content((24.4, 24), cutout($arrow(x)_0$), anchor: "west")
  content((21.6, 21.8), $O$, anchor: "east")
  content((35.2, 16.2), $gamma lr((t))$, anchor: "east")
  content((39.3, 9.3), $S^(n-2)$, anchor: "west")
})

// Figure 16: the indicatrix of normal curvatures in T_P V², with the unit
// circle of directions (dashed) and the principal axes x¹, x² along e⃗₁, e⃗₂;
// stippled between the circle and the indicatrix. Above, λ₁, λ₂ > 0: the
// ellipse λ₁(x¹)² + λ₂(x²)² = 1 with the semi-axes 1/√λ₁, 1/√λ₂ and a
// direction α⃗ at the angle φ₁. Below, λ₁ > 0 > λ₂: the hyperbolas
// λ₁(x¹)² − |λ₂|(x²)² = ±1 with their asymptotes (dashed), cut off at
// |x¹| = `reach`.
#let fig-4-16() = drawing({
  import cetz.draw: *
  let unit = 11.4
  // The relations written in the figure, smaller, as printed.
  let relation(body) = text(size: 8pt, body)
  let semi(lambda) = unit / calc.sqrt(calc.abs(lambda))
  set-style(stroke: thick-line)
  let unit-circle() = circle((0, 0), radius: unit, fill: white, ..hidden)
  let vector(to, name) = {
    arrowed((0, 0), to, name: name)
    spot(to)
  }
  let axes(x-from, x-to, y-from, y-to) = {
    arrowed((x-from, 0), (x-to, 0), stroke: thin-line, name: "x1")
    arrowed((0, y-from), (0, y-to), stroke: thin-line, name: "x2")
  }
  // The ellipse.
  group({
    translate((0, 40))
    let (first, second) = (0.1504, 0.5776)
    let (a, b) = (semi(first), semi(second))
    let turn = 27.9deg
    circle((0, 0), radius: (a, b), fill: stipple)
    unit-circle()
    axes(-39.5, 39, -18.5, 26)
    cetz.angle.angle(
      (0, 0),
      (1, 0),
      (turn, 1),
      fill: black,
      stroke: none,
      radius: 4.5,
    )
    vector((unit, 0), "e1")
    vector((0, unit), "e2")
    vector((turn, unit), "alpha")
    for p in ((0, 0), (a, 0), (0, b)) { spot(p) }
    content("x1.end", $x^1$, anchor: "south-east")
    content("x2.end", $x^2$, anchor: "north-west")
    content((0, b), $1 / sqrt(lambda_2)$, anchor: "south-west")
    content((a, 0), $1 / sqrt(lambda_1)$, anchor: "north-west")
    content((0, 0), $O$, anchor: "north-east")
    content("e1.55%", $arrow(e)_1$, anchor: "north")
    content("e2.55%", $arrow(e)_2$, anchor: "east")
    content("alpha.60%", $arrow(alpha)$, anchor: "south-east")
    content((turn / 2, 5), $phi_1$, anchor: "west", padding: 0.3)
    content(
      (-2, 21.5),
      relation($lambda_1 (x^1)^2 + lambda_2 (x^2)^2 = k(arrow(alpha)) > 0$),
      anchor: "east",
    )
    content((0, -b), [Эллипс], anchor: "north-east", padding: (right: 5))
    content((0, -b), [кривизны], anchor: "north-west", padding: (left: 1.5))
    content((-3.4, -21), $lambda_1 > 0$, anchor: "east")
    content((10.5, -19.5), $lambda_2 > 0$, anchor: "west")
  })
  // The hyperbolas, λ₁ from λ₂ and the slope √(λ₁/|λ₂|) of the asymptotes.
  group({
    let (second, slope, reach) = (-0.769, 0.65, 34)
    let first = slope * slope * calc.abs(second)
    let (a, b) = (semi(first), semi(second))
    // The branches: across x¹ (sides 1, −1) and across x² (sides 1, −1).
    let across(side, t) = (side * a * calc.cosh(t), b * calc.sinh(t))
    let along(side, t) = (a * calc.sinh(t), side * b * calc.cosh(t))
    let end-across = calc.asinh(calc.sqrt(calc.pow(reach / a, 2) - 1))
    let end-along = calc.asinh(reach / a)
    let branch(f, side, ends) = sample(t => f(side, t), ..ends, n: 60)
    let rising = (-end-across, end-across)
    let flat = (-end-along, end-along)
    line(
      ..branch(along, 1, flat).rev(),
      ..branch(across, -1, rising).rev(),
      ..branch(along, -1, flat),
      ..branch(across, 1, rising),
      close: true,
      fill: stipple,
      stroke: none,
    )
    unit-circle()
    for (f, ends) in ((across, rising), (along, flat)) {
      for side in (1, -1) { line(..branch(f, side, ends)) }
    }
    for side in (1, -1) {
      line(
        (-reach, -side * slope * reach),
        (reach, side * slope * reach),
        ..hidden,
      )
    }
    axes(-36, 39, -25, 23.5)
    arrowed((0, 0), (unit, 0), name: "e1")
    arrowed((0, 0), (0, unit), name: "e2")
    for p in ((0, 0), (a, 0), (0, b)) { spot(p) }
    content("x1.end", $x^1$, anchor: "north-east")
    content("x2.end", $x^2$, anchor: "north-west")
    content((0, b), $1 / sqrt(|lambda_2|)$, anchor: "south-west", padding: (
      left: 4,
    ))
    content((a, 0), $1 / sqrt(lambda_1)$, anchor: "south-west")
    content((-unit, 0), cutout($1$), anchor: "south-east")
    content("e1.end", cutout($arrow(e)_1$), anchor: "north-west")
    content("e2.55%", $arrow(e)_2$, anchor: "east")
    // The words outside the left branch, along it, upright towards it.
    for (word, t) in (([Гипербола], 0.85), ([кривизны], -0.85)) {
      let (x, y) = across(-1, t)
      let along-branch = calc.atan2(a * calc.sinh(t), -b * calc.cosh(t))
      content(
        (rel: (along-branch - 90deg, 2.4), to: (x, y)),
        word,
        angle: along-branch,
      )
    }
    let below = -b - 7
    content((-4, below), relation($lambda_1 >= lambda_2 ;$), anchor: "east")
    content(
      (2, below),
      relation($lambda_1 > 0 ; lambda_2 < 0$),
      anchor: "west",
    )
    content(
      (39, -26.5),
      relation($lambda_1 (x^1)^2 - |lambda_2| (x^2)^2 = "const" > 0$),
      anchor: "north-east",
    )
  })
})

// Figure 17: near a point P with λ₁, λ₂ > 0 the surface V² lies on one side
// of its tangent plane T_P(V²). A drawing.
#let fig-4-17() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-17-elliptic-point.svg",
    49.66,
    corner: (0.76, 0.8),
  )
  content((23.8, 19.6), cutout($P$))
  content((45.2, 21.8), $T_P lr((V^2))$, anchor: "west", padding: 0)
})

// Figure 18: near a point P with λ₁ > 0 > λ₂ the surface V² lies on both
// sides of T_P V²: a saddle, its principal sections λ₁, λ₂. A drawing.
#let fig-4-18() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-18-saddle-point.svg",
    71.71,
    corner: (1.65, 0.8),
  )
  set-style(content: (padding: 0))
  content((67.2, 43.4), $lambda_1$, anchor: "west")
  content((6.3, 14.1), $T_P V^2$, angle: -41deg)
  content((49.8, 3.8), $lambda_2$)
})

// Figure 19: near a point P with λ₁ = 0, λ₂ ≠ 0: a parabolic cylinder
// touching T_P V² along a line, its principal sections λ₁, λ₂. A drawing.
#let fig-4-19() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-19-parabolic-point.svg",
    104.18,
    corner: (1.52, 0.85),
  )
  set-style(content: (padding: 0))
  content((48.3, 42.1), $lambda_2$)
  content((55.8, 19.9), cutout($P$))
  content((41.6, 13.4), $lambda_1$)
  content((21.6, 8.3), $T_P V^2$, angle: -19.8deg)
})

// Figure 20: the monkey saddle z = x³ − 3xy² crossing its tangent plane at
// the origin, where λ₁ = λ₂ = 0. A drawing.
#let fig-4-20() = image(
  "/assets/figures/04-20-monkey-saddle.svg",
  width: 84.92mm,
)

// Figure 21: the level lines of the monkey saddle f = x³ − 3xy² about the
// origin, drawn with the axis x up and y to the right: in polar
// coordinates of the page f = −r³ sin 3θ. The zero level is three lines
// through the origin; in each of the six sectors two levels |f| = c, whose
// vertices on the bisector lie at r = c^(1/3); the sectors f > 0
// stippled. All within the frame; the signs midway between the outer
// level and the frame.
#let fig-4-21() = drawing({
  import cetz.draw: *
  let (left, bottom, right, top) = (-23.3, -18, 23.7, 18.5)
  let vertices = (8.2, 12.6)
  // The levels stop where they come this close to the zero lines.
  let parting = 0.9
  let inside((x, y)) = left <= x and x <= right and bottom <= y and y <= top
  // Where the ray at the angle t leaves the frame.
  let reach(t) = {
    let (c, s) = (calc.cos(t), calc.sin(t))
    let across = if c > 1e-9 { right / c } else if c < -1e-9 { left / c } else {
      calc.inf
    }
    let up = if s > 1e-9 { top / s } else if s < -1e-9 { bottom / s } else {
      calc.inf
    }
    calc.min(across, up)
  }
  let corners = (
    (right, top),
    (left, top),
    (left, bottom),
    (right, bottom),
  ).map(((x, y)) => (calc.atan2(x, y), (x, y)))
  set-style(stroke: thick-line)
  for k in range(6) {
    let (from, to) = (k * 60deg, (k + 1) * 60deg)
    // The sign of f in the sector: −sin 3θ at its bisector.
    if calc.sin(3 * (from + 30deg)) < 0 {
      let within = corners
        .map(((t, p)) => (if t < 0deg { t + 360deg } else { t }, p))
        .filter(((t, p)) => from < t and t < to)
        .sorted(key: ((t, p)) => t)
        .map(((t, p)) => p)
      line(
        (0, 0),
        (from, reach(from)),
        ..within,
        (to, reach(to)),
        close: true,
        fill: stipple,
        stroke: none,
      )
    }
    for vertex in vertices {
      let level(t) = vertex / calc.pow(calc.abs(calc.sin(3 * t)), 1 / 3)
      surface-curve(
        p => p,
        t => (t, level(t)),
        t => {
          let r = level(t)
          let off = r * calc.sin(calc.min(t - from, to - t))
          inside((r * calc.cos(t), r * calc.sin(t))) and off > parting
        },
        from + 0.5deg,
        to - 0.5deg,
        n: 80,
      )
    }
  }
  for t in (0deg, 60deg, 120deg) {
    line((t, reach(t)), (t + 180deg, reach(t + 180deg)))
  }
  spot((0, 0))
  for (t, sign) in (
    (90deg, $+$),
    (210deg, $+$),
    (330deg, $+$),
    (30deg, $-$),
    (270deg, $-$),
  ) {
    content((t, (vertices.last() + reach(t)) / 2), cutout(sign))
  }
})
// The tractrix of the tangent length a from (0, a), tangent to Ox at
// infinity: the abscissa of its point at the height y.
#let tractrix-abscissa(a, y) = {
  let leg = calc.sqrt(a * a - y * y)
  a * calc.ln((a + leg) / y) - leg
}

// Figure 22: the tractrix γ of the tangent length a: A₀ = (0, a), and
// x = a ln((a + √(a² − y²)) / y) − √(a² − y²). A point A on it, at the
// angle φ of the tangent AB to the axis Ox, has y = a sin φ and the
// tangent meets Ox at B, a cos φ further.
#let fig-4-22() = drawing({
  import cetz.draw: *
  let (a, angle) = (20.5, 25deg)
  let abscissa(y) = tractrix-abscissa(a, y)
  let point-a = (abscissa(a * calc.sin(angle)), a * calc.sin(angle))
  let point-b = (point-a.at(0) + a * calc.cos(angle), 0)
  let foot = (point-a.at(0), 0)
  let height = (0, point-a.at(1))
  let dot = 1
  cetz.angle.angle(
    point-b,
    point-a,
    foot,
    fill: stipple,
    stroke: thick-line,
    radius: 6.8,
  )
  arrowed((-6.3, 0), (68, 0), name: "x")
  arrowed((0, -3), (0, 28.7), name: "y")
  line(
    ..sample(y => (abscissa(y), y), a, 1, n: 160),
    stroke: 2 * thick-line,
    name: "gamma",
  )
  line(point-a, point-b, name: "ab")
  line(height, point-a, ..hidden)
  line(point-a, foot, ..hidden)
  for p in ((0, a), height, (0, 0), foot, point-a, point-b) {
    spot(p, radius: dot)
  }
  set-style(content: (padding: 1 + dot))
  content("y.end", $y$, anchor: "north-west", padding: 1)
  content((0, a), $A_0$, anchor: "north-east", padding: 0.5)
  content(height, $y$, anchor: "east")
  content((0, 0), $B_0$, anchor: "south-east", padding: 0.5)
  content(foot, $x$, anchor: "north")
  content(point-b, $B$, anchor: "north")
  content(point-a, $A$, anchor: "south-west", padding: 0.6)
  content("ab.55%", $a$, anchor: "north-east", padding: 1)
  content(
    (point-b, 6.8, point-a),
    $phi$,
    anchor: "north",
    padding: (top: 5.3),
  )
  content((abscissa(2.5), 2.5), $gamma$, anchor: "south", padding: 1.2)
  // The two relations in two lines above the curve, right of A.
  let relations = (point-b.at(0) - 6.2, point-a.at(1) + 3.5)
  content(relations, $|A B| = a = "const"$, anchor: "south-west", padding: (
    bottom: 0.3,
  ))
  content(relations, $|A_0 B_0| = a$, anchor: "north-west", padding: (
    top: 0.3,
  ))
})

// The Beltrami surface: the tractrix of `a` turned about Ox, either half
// (`half` = 1 for x > 0, −1 for x < 0) a funnel from the circle of cusps
// r = a at x = 0. Seen nearly across the axis, turned by β, from the side
// x < 0: x on the page is x cos β + w sin β, w the depth towards the
// viewer. `at(half, r, t)` is the page point of radius r at the angle t;
// `outline(half, side, thin)` the outline of a half, side ±1 above and
// below, from r = a cos β down to `thin`: there the normal (∓r′, cos t,
// sin t) is at a right angle to the line of sight (−sin β, cos β, 0).
#let beltrami-view(a, beta) = {
  let (cb, sb) = (calc.cos(beta), calc.sin(beta))
  let at(half, r, t) = (
    half * tractrix-abscissa(a, r) * cb + r * calc.cos(t) * sb,
    r * calc.sin(t),
  )
  (
    at: at,
    outline: (half, side, thin) => sample(
      r => {
        let steep = r / calc.sqrt(a * a - r * r)
        at(half, r, side * calc.acos(half * steep * sb / cb))
      },
      a * cb,
      thin,
      n: 160,
    ),
  )
}

// Figure 23: the Beltrami surface, the tractrix of Fig. 22 turned about
// Ox, its half x > 0 down to the radius `thin`; the circle of cusps of
// radius a. Seen into the wide end: the inside seen through the circle of
// cusps is stippled; the lower front is hatched by arcs of parallels
// between the angles `band`; a parallel marked near the end.
#let fig-4-23() = drawing({
  import cetz.draw: *
  let (a, beta, thin, marked) = (17.5, 10.2deg, 0.8, 1.3)
  let band = (-49deg, -27deg)
  let view = beltrami-view(a, beta)
  let at(r, t) = (view.at)(1, r, t)
  let rim = sample(t => at(a, t), 0deg, 360deg, n: 120)
  line(..rim, close: true, fill: stipple, stroke: 1.5 * thick-line)
  set-style(stroke: thick-line)
  for side in (1, -1) { line(..(view.outline)(1, side, thin)) }
  line(..sample(t => at(marked, t), 0deg, 360deg, n: 60), close: true)
  // The hatching, right of the circle of the cusps; the arcs the farther
  // apart the farther right.
  let last = a * calc.sin(beta)
  for r in sample(r => r, 0.97 * a, 2.5, n: 600) {
    let arc = sample(t => at(r, t), ..band, n: 6)
    let x = arc.last().at(0)
    if x > last + 0.6 + 0.022 * x {
      line(..arc, stroke: 0.3mm)
      last = x
    }
  }
  // The axis: solid up to the circle of the cusps, then hidden.
  let edge = a * calc.sin(beta)
  line((-6, 0), (edge, 0))
  line((edge, 0), (at(thin, 90deg).at(0) + 3, 0), ..hidden)
  spot((0, 0), radius: 0.85)
})

// Figure 24: a surface of revolution about Ox with its net of parallels
// and meridians: a meridian, a parallel, the radius of the parallel to a
// point of the meridian. A drawing.
#let fig-4-24() = image(
  "/assets/figures/04-24-revolution-net.svg",
  width: 56.39mm,
)
// Figure 25: cylindrical coordinates (x, r, φ) about the axis x, y = r cos φ,
// z = r sin φ, and a surface of revolution by its generatrix r = r(x) in
// the half-plane φ = `meridian`. At the height `level` the parallel of
// radius r(x) through the generatrix, the point (x, r, φ) on it and its
// foot in the plane x = 0 with the angle φ from the axis y. The x axis up,
// seen in the orthographic view of elevation `elevation`, turned so that
// the axis y runs down to the left at 45°. The generatrix is a free curve
// through a few points (x, r).
#let fig-4-25() = drawing({
  import cetz.draw: *
  let elevation = 16deg
  let view = orthographic(calc.atan(calc.sin(elevation)), elevation)
  let at((x, y, z)) = (view.project)((z, -y, x))
  let cylindrical(x, r, t) = at((x, r * calc.cos(t), r * calc.sin(t)))
  let (meridian, angle, level) = (-25deg, 50deg, 27)
  let profile = (
    (-9.2, 21.6),
    (-2.5, 16.2),
    (6.6, 10),
    (12.5, 8.5),
    (18.2, 10.8),
    (level, 14.5),
    (33.4, 13.9),
    (41.2, 11.6),
  )
  let radius = profile.find(((x, r)) => x == level).at(1)
  let ring(from, to) = sample(t => cylindrical(level, radius, t), from, to)
  let centre = at((level, 0, 0))
  let point = cylindrical(level, radius, angle)
  let foot = cylindrical(0, radius, angle)
  let seat = cylindrical(level, radius, meridian)
  let sector = 9
  line(
    (0, 0),
    ..sample(t => cylindrical(0, sector, t), 0deg, angle, n: 30),
    close: true,
    fill: stipple,
  )
  // The back of the parallel, the axes; then what passes in front of them.
  line(..ring(angle, 360deg + meridian))
  arrowed((0, 0), at((0, 60, 0)), name: "y")
  arrowed((0, 0), at((0, 0, 23.9)), name: "z")
  bridge(((0, 0), at((39.2, 0, 0))))
  arrowed(at((38, 0, 0)), at((39.2, 0, 0)), name: "x")
  line((0, 0), foot, name: "foot")
  bridge((point, foot))
  bridge(ring(meridian, angle), gap: 2.2)
  line(..ring(meridian, angle), stroke: 2 * thick-line)
  line(centre, seat)
  line(centre, point, name: "radius")
  hobby(
    ..profile.map(((x, r)) => cylindrical(x, r, meridian)),
    stroke: 2 * thick-line,
  )
  for p in ((0, 0), centre, point, foot, seat) { spot(p, radius: 0.9) }
  content("x.end", $x$, anchor: "west")
  content("z.end", $z$, anchor: "south-east")
  content("y.end", $y$, anchor: "east")
  content(centre, $x$, anchor: "south-west")
  content("radius.60%", $r(x)$, anchor: "south-west", padding: 0.5)
  content(point, $(x, r, phi)$, anchor: "north-west")
  content(foot, $r(x)$, anchor: "north-west", padding: 1)
  content(cylindrical(0, sector, angle / 2), $phi$, anchor: "north")
  // The equation of the generatrix along it.
  let (lower, upper) = (6.6, 18.2).map(x => cylindrical(
    x,
    profile.find(p => p.at(0) == x).at(1),
    meridian,
  ))
  content(
    (lower, 50%, upper),
    $r = r(x)$,
    angle: 90deg,
    anchor: "south",
    padding: 1.6,
  )
})

// Figure 26: the plane xOr with the meridian r = r(x) through P = (x, r(x))
// (a decreasing curve, here r_P e^(r′ (x − x_P) / r_P), given by its slope
// r′ at P); m⃗ = (0, 1) in the plane of the parallel, n⃗ = (−r′, 1) / √(1 +
// r′²) the normal, θ between them. The parallel, the circle of radius r
// about the axis, and the circle of curvature of the normal section along
// it, of radius r / cos θ about a point of the normal, both seen slightly
// obliquely: the direction across the page drawn as (`depth`, 0). Their
// arcs behind the page pass under the axis.
#let fig-4-26() = drawing({
  import cetz.draw: *
  let (p, slope, depth, unit) = ((16.2, 11.6), -0.44, 0.19, 10)
  let (px, pr) = p
  let meridian(x) = (x, pr * calc.exp(slope * (x - px) / pr))
  let length = calc.sqrt(1 + slope * slope)
  let normal = (-slope / length, 1 / length)
  let cosine = 1 / length
  // A circle through P about the point `centre` of the line of `toward`
  // (a unit vector of the page) at the distance `radius`, its plane that
  // of `toward` and the direction across the page; s = sin t.
  let circle-through(toward, radius, s-range) = {
    let centre = p.zip(toward).map(((a, b)) => a - radius * b)
    sample(
      t => (
        centre.at(0)
          + radius * (calc.cos(t) * toward.at(0) + calc.sin(t) * depth),
        centre.at(1) + radius * calc.cos(t) * toward.at(1),
      ),
      ..s-range,
      n: 90,
    )
  }
  set-style(stroke: thick-line)
  let circles = (((0, 1), pr), (normal, pr / cosine))
  // The back halves first, then the axes over them, then the front halves.
  for (toward, radius) in circles {
    line(..circle-through(toward, radius, (180deg, 360deg)))
  }
  bridge(((-5.3, 0), (39.8, 0)), ((0, -12.8), (0, 22.5)))
  arrowed((38.5, 0), (39.8, 0), name: "x")
  arrowed((0, 21), (0, 22.5), name: "r")
  for (toward, radius) in circles {
    line(..circle-through(toward, radius, (0deg, 180deg)))
  }
  line(..sample(meridian, 5.2, 30.2), stroke: 2 * thick-line)
  let tip(v) = p.zip(v).map(((a, b)) => a + unit * b)
  arrowed(p, tip((0, 1)), stroke: thick-line, name: "m")
  arrowed(p, tip(normal), stroke: thick-line, name: "n")
  cetz.angle.angle(p, tip(normal), tip((0, 1)), radius: 3.6, label: none)
  spot((0, 0), radius: 0.9)
  spot(p, radius: 1)
  content("r.end", $r$, anchor: "north-east", padding: 1.5)
  content("x.end", $x$, anchor: "north-east", padding: 1.5)
  content("m.end", $arrow(m)$, anchor: "north-east", padding: 1.5)
  content("n.end", $arrow(n)$, anchor: "west", padding: 1)
})
// Figure 27: the Beltrami surface continued by its mirror image in the
// plane yOz, with the circle of cusps between the halves, down to the
// radius `thin` at either end; below, its section by a plane through Ox,
// the tractrices ±y(x) on both sides, cusped at (0, ±a), the region
// between them stippled, cut at the height `ends`. The view as in Fig. 23:
// the left end open towards the viewer; either half hatched along
// meridians at the radii `band`.
#let fig-4-27() = drawing({
  import cetz.draw: *
  let (a, beta, thin, ends) = (11, 10.2deg, 0.8, 0.8)
  let band = (0.21 * a, 0.3 * a)
  let view = beltrami-view(a, beta)
  let abscissa(r) = tractrix-abscissa(a, r)
  set-style(stroke: thick-line)
  // The surface, above the section.
  group({
    translate((0, 2 * a + 5))
    let end(half) = sample(t => (view.at)(half, thin, t), 0deg, 360deg)
    line(..end(-1), close: true, fill: black)
    line(..end(1), close: true)
    for half in (1, -1) {
      for side in (1, -1) { line(..(view.outline)(half, side, thin)) }
      for k in range(9) {
        let t = calc.asin((k - 4) / 4.5)
        line(
          ..sample(r => (view.at)(half, r, t), ..band, n: 8),
          stroke: 0.3mm,
        )
      }
    }
    line(
      ..sample(t => (view.at)(1, a, t), 0deg, 360deg, n: 120),
      close: true,
    )
  })
  // The section.
  let branch(half, side) = sample(
    r => (half * abscissa(r), side * r),
    a,
    ends,
    n: 120,
  )
  line(
    ..branch(1, 1),
    ..branch(1, -1).rev(),
    ..branch(-1, -1),
    ..branch(-1, 1).rev(),
    close: true,
    fill: stipple,
    stroke: none,
  )
  for half in (1, -1) {
    for side in (1, -1) { line(..branch(half, side)) }
  }
  let reach = abscissa(ends) + 2.5
  line((-reach, 0), (reach, 0))
  line((0, -a - 7.5), (0, a + 3))
  spot((0, a), radius: 0.9)
  spot((0, -a), radius: 0.9)
})
