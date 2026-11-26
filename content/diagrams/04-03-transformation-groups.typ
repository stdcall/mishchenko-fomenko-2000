// Figures of chapter 4, § 3. Each is a function called by the text:
// `#fig(fig-4-50()) <fig:…>`.
#import "common.typ": *
#import "../main-defs.typ": SO

// The direction from the point `from` of the plane to the point `to`.
#let plane-direction(from, to) = calc.atan2(
  to.at(0) - from.at(0),
  to.at(1) - from.at(1),
)
// The point at `length` from `from` towards `to`.
#let plane-towards(from, to, length) = {
  let heading = plane-direction(from, to)
  vec-add(from, (length * calc.cos(heading), length * calc.sin(heading)))
}

// A heavy arrow from `from` to `to`, its head `length` by `width` mm: a
// broad black shaft and head. An image vector is drawn with a white `core`
// along the shaft; a `hollow` head is white in a black outline.
#let heavy-arrow(
  from,
  to,
  shaft: 0.9,
  length: 3.8,
  width: 2.3,
  core: false,
  hollow: false,
) = {
  import cetz.draw: *
  line(from, plane-towards(to, from, 0.8 * length), stroke: (
    thickness: shaft * 1mm,
    cap: "butt",
  ))
  if core {
    let reach = if hollow { 0.8 * length } else { 0.45 * length }
    line(
      plane-towards(from, to, shaft),
      plane-towards(to, from, reach),
      stroke: (
        paint: white,
        thickness: 0.3 * shaft * 1mm,
      ),
    )
  }
  mark(
    to,
    plane-direction(from, to),
    symbol: "stealth",
    length: length * 1mm,
    width: width * 1mm,
    inset: 0.2 * length * 1mm,
    fill: if hollow { white } else { black },
    stroke: if hollow { 0.3mm } else { none },
  )
}

// The hyperbola x² − y² = 1 drawn at `unit` mm: its right branch at the
// parameter t, and its image under the matrix `g`.
#let hyperbola-point(unit, t, g: ((1, 0), (0, 1))) = {
  let (x, y) = (unit * calc.cosh(t), unit * calc.sinh(t))
  (g.at(0).at(0) * x + g.at(0).at(1) * y, g.at(1).at(0) * x + g.at(1).at(1) * y)
}

// An axis from `from` to `to` with the arrowhead of the book `before` mm
// short of its end.
#let axis-line(from, to, before: 0) = {
  import cetz.draw: *
  line(from, to)
  mark(
    plane-towards(to, from, before),
    plane-direction(from, to),
    symbol: "stealth",
    length: 2.6mm,
    width: 1.3mm,
    inset: 0.8mm,
  )
}

// Figure 50: the group O(2), two circles drawn as broad rings: the
// rotations SO(2), a rotation given by its angle φ from the unit 1, and the
// coset of the reflection diag(1, −1). The label O(2) points at both.
#let fig-4-50() = lettered-drawing({
  import cetz.draw: *
  let centre = (9.7, 14.0)
  // The circle of radius `radius` drawn as a ring of width `ring`; the
  // coset is its translate by `shift`.
  let (radius, ring, shift) = (8.1, 3.2, 20.6)
  let other = (rel: (shift, 0), to: centre)
  let outer = radius + ring / 2
  let inner = radius - ring / 2
  for c in (centre, other) {
    circle(c, radius: radius, stroke: (thickness: ring * 1mm))
  }
  // The rotation by φ: the rays from the centre to the unit and to the
  // angle φ, dashed, the angle stippled.
  let turn = 54deg
  let ray = (
    stroke: (dash: (array: (1.4mm, 0.6mm)), thickness: 0.4mm, cap: "butt"),
  )
  let unit-ray = (rel: (inner - 0.3, 0), to: centre)
  let turn-ray = (rel: (turn, inner - 0.3), to: centre)
  cetz.angle.angle(
    centre,
    unit-ray,
    turn-ray,
    radius: 3.2,
    label-radius: 5.1,
    label: $phi$,
    fill: stipple,
    stroke: 0.4mm,
  )
  line(centre, unit-ray, ..ray)
  line(centre, turn-ray, ..ray)
  spot(centre, radius: 0.75)
  circle((rel: (radius, 0), to: centre), radius: 0.5, fill: white, stroke: none)
  content((rel: (5, 0), to: centre), $1$, anchor: "north")
  content((rel: (110deg, outer), to: centre), $SO(2)$, anchor: "south")
  content(
    (rel: (95deg, outer), to: other),
    $mat(1, 0; 0, -1) dot SO(2)$,
    anchor: "south",
  )
  // O(2) under the gap, pointing at both rings, symmetric about the gap.
  let middle = (centre.at(0) + shift / 2, centre.at(1))
  let foot = (rel: (0, -12.1), to: middle)
  content(foot, $upright(O)(2)$)
  for side in (-1, 1) {
    let rim = (
      rel: (90deg + side * 147deg, outer + 0.6),
      to: (
        rel: (side * shift / 2, 0),
        to: middle,
      ),
    )
    line((rel: (side * 2.3, 1.4), to: foot), rim, mark: leader-mark)
  }
})

// Figure 51: a hyperbolic rotation A of the pseudo-Euclidean plane takes
// the frame e⃗₁ = (1, 0), e⃗₂ = (0, 1) to Ae⃗₁ = (ch ψ, sh ψ),
// Ae⃗₂ = (sh ψ, ch ψ) on the pseudocircles x² − y² = ±1 (dashed, with
// their asymptotes); the hyperbolic sectors swept are black.
#let fig-4-51() = lettered-drawing({
  import cetz.draw: *
  let (unit, psi) = (13.2, 0.46)
  let swap = ((0, 1), (1, 0))
  let identity = ((1, 0), (0, 1))
  let asymptote = (stroke: (dash: (array: (1.5mm, 0.9mm)), thickness: 0.4mm))
  let branch = (stroke: (dash: (array: (1mm, 0.8mm)), thickness: 0.35mm))
  line(..sample(t => hyperbola-point(unit, t), -1.05, 1.08), ..branch)
  line(
    ..sample(t => hyperbola-point(unit, t, g: swap), -0.99, 1.05),
    ..branch,
  )
  line((-18.3, 18.3), (17.8, -17.8), ..asymptote)
  line((0, 0), (19.6, 19.6), ..asymptote)
  for g in (identity, swap) {
    line(
      (0, 0),
      ..sample(t => hyperbola-point(unit, t, g: g), 0, psi, n: 24),
      close: true,
      fill: black,
      stroke: none,
    )
  }
  axis-line((0, 0), (25.5, 0))
  axis-line((0, 0), (0, 21.5))
  let frame = (identity, swap).map(g => hyperbola-point(unit, 0, g: g))
  let image = (identity, swap).map(g => hyperbola-point(unit, psi, g: g))
  for tip in frame + image {
    heavy-arrow(
      (0, 0),
      tip,
      shaft: 0.8,
      length: 2.4,
      width: 1.4,
      core: true,
      hollow: true,
    )
  }
  spot((0, 0), radius: 1.1)
  content(vec-scale(0.55, frame.at(0)), $arrow(e)_1$, anchor: "north")
  content(vec-scale(0.8, frame.at(1)), $arrow(e)_2$, anchor: "east")
  content(image.at(0), $A arrow(e)_1$, anchor: "west", padding: 1.5)
  content(image.at(1), $A arrow(e)_2$, anchor: "south", padding: 2.2)
  content((25.5, 0), $x$, anchor: "north-east")
  content((0, 21.5), $y$, anchor: "north-west")
})

// Figure 52: the four components 𝔊₁, …, 𝔊₄ of the group of hyperbolic
// rotations, each a line oriented by ψ with its point g_i (ψ = 0) marked;
// drawn as one branch of a hyperbola, with asymptotes x = −a and y = 0, and
// its reflections in the two axes.
#let fig-4-52() = lettered-drawing({
  import cetz.draw: *
  // The branch t ↦ (−a − p e^(−t), q e^t), reflected by the signs
  // (sx, sy); ψ decreases along the arrows.
  let (a, p, q) = (2.1, 3.3, 9.8)
  let branch(t, (sx, sy)) = (sx * (-a - p * calc.exp(-t)), sy * q * calc.exp(t))
  // Each component with the label of its point, centred `drop` mm below
  // (above) it: the wide e = g₁ lower, clear of its branch.
  let components = (
    ((1, 1), $frak(G)_1$, $e = g_1$, 7),
    ((-1, 1), $frak(G)_2$, $g_2$, 3),
    ((-1, -1), $frak(G)_3$, $g_3$, 3),
    ((1, -1), $frak(G)_4$, $g_4$, 3),
  )
  for (signs, name, unit, drop) in components {
    let (sx, sy) = signs
    line(..sample(t => branch(t, signs), -1.6, 0.8), stroke: 0.75mm)
    for t in (0.5, -1.4) {
      mark(
        branch(t, signs),
        plane-direction(branch(t, signs), branch(t - 0.01, signs)),
        symbol: "stealth",
        length: 3mm,
        width: 2mm,
        inset: 0.4mm,
      )
    }
    spot(branch(0, signs), radius: 1)
    let side = if sx > 0 { "east" } else { "west" }
    content(branch(0.55, signs), name, anchor: side, padding: 1.2)
    content(vec-add(branch(0, signs), (sx * 1.4, -sy * drop)), unit)
  }
})

// Figure 53: the action of the representatives g₁, …, g₄ of the components
// on the pseudocircle x² − y² = 1 (with its dashed asymptotes): each panel
// shows the frame e⃗₁, e⃗₂ (black) and its image (white core), and joins
// the points of one orbit {(±ch t, ±sh t)} to their images.
#let fig-4-53() = lettered-drawing({
  import cetz.draw: *
  let (unit, orbit) = (10.3, 0.9)
  // Panels: matrix, origin, letter, how far the panel reaches above its
  // x-axis and its y-axis below: the rows stop short of each other.
  let panels = (
    (((1, 0), (0, 1)), (0, 0), [а)], 22, 20.5),
    (((-1, 0), (0, -1)), (51.2, 0), [б)], 22, 20.5),
    (((1, 0), (0, -1)), (0, -39.3), [в)], 17.2, 23),
    (((-1, 0), (0, 1)), (51.2, -39.3), [г)], 17.2, 23),
  )
  let apply(g, (x, y)) = (
    g.at(0).at(0) * x + g.at(0).at(1) * y,
    g.at(1).at(0) * x + g.at(1).at(1) * y,
  )
  let mirror = ((-1, 0), (0, 1))
  let points = ((1, 1), (-1, 1), (-1, -1), (1, -1)).map(((sx, sy)) => (
    sx * unit * calc.cosh(orbit),
    sy * unit * calc.sinh(orbit),
  ))
  let asymptote = (stroke: (dash: (array: (1.6mm, 0.8mm)), thickness: 0.45mm))
  let (left, right, below) = (21.5, 23.7, 20.5)
  for (g, origin, letter, above, foot) in panels {
    group({
      translate(origin)
      // The asymptotes and the branches between the heights −below and
      // above, the branches a little short of them.
      line((-below, -below), (above, above), ..asymptote)
      line((-above, above), (below, -below), ..asymptote)
      let (first, last) = (
        calc.asinh(-(below - 1) / unit),
        calc.asinh((above - 1) / unit),
      )
      for h in (((1, 0), (0, 1)), mirror) {
        line(
          ..sample(t => hyperbola-point(unit, t, g: h), first, last),
          stroke: thick-line,
        )
      }
      axis-line((-left, 0), (right, 0), before: 2.5)
      axis-line((0, -foot), (0, above), before: 2.5)
      for e in ((unit, 0), (0, unit)) {
        heavy-arrow((0, 0), e)
        let image = apply(g, e)
        if image != e { heavy-arrow((0, 0), image, core: true) }
      }
      for p in points {
        let image = apply(g, p)
        if image != p {
          line(p, image)
          mark(
            plane-towards(image, p, 1.6),
            plane-direction(p, image),
            symbol: "stealth",
            length: 2.3mm,
            width: 1.2mm,
            inset: 0.7mm,
          )
        }
        spot(p, radius: 1)
      }
      content((right, 0), $x$, anchor: "north-east")
      content((0, above - 1), $y$, anchor: "north-west")
      content((0, -foot), emph(letter), anchor: "south-west", padding: 1.5)
    })
  }
})
// Figure 54: a rotation A ∈ SO(3) about the axis l(A): the plane Π(A)
// through O orthogonal to l(A), e⃗₁ in it, e⃗₂ = e⃗₁ turned by φ, e⃗₃ along
// l(A) completing a frame oriented as the fixed frame a⃗₁, a⃗₂, a⃗₃ at O′; the
// point P(l, φ) on the axis. Π(A) is the plane z = 0 with x along e⃗₁ and
// l(A) the z-axis, seen from the side of e⃗₃, a square piece of Π(A) stippled;
// the part of l(A) behind it dashed.
#let fig-4-54() = lettered-drawing({
  import cetz.draw: *
  // The view: the images of the unit vectors of x, y, z.
  let at = projection((-0.852, -0.119), (0.433, -0.706), (0.293, 0.698))
  let (unit, turn) = (13.7, 107deg)
  let in-plane(radius, angle) = (
    radius * calc.cos(angle),
    radius * calc.sin(angle),
    0,
  )
  // The square piece of Π: diagonals 2 × `reach` along x and y about
  // `middle`.
  let (middle, reach) = ((2.9, 2.5), 22.3)
  let square = ((1, 0), (0, 1), (-1, 0), (0, -1)).map(((u, v)) => at((
    middle.at(0) + reach * u,
    middle.at(1) + reach * v,
    0,
  )))
  line(..square, close: true, fill: stipple, stroke: thick-line)
  // The axis from z = `low` to z = `high`; behind the square it is hidden.
  let (low, high, point) = (-30.3, 31.7, 25.1)
  let foot = at((0, 0, low))
  intersections("exit", {
    hide(line((0, 0), foot))
    hide(line(..square, close: true))
  })
  line((0, 0), "exit.0", ..hidden)
  line("exit.0", foot)
  bridge(((0, 0), at((0, 0, high))), gap: 1mm)
  // The angle φ from e⃗₁ to e⃗₂ in Π.
  let arc = sample(s => at(in-plane(7.3, s)), 0deg, turn, n: 40)
  line(..arc)
  mark(arc.last(), plane-direction(arc.at(-2), arc.last()), symbol: "stealth")
  content(at(in-plane(9.6, 0.62 * turn)), cutout($phi$), anchor: "north-west")
  let frame = (in-plane(unit, 0deg), in-plane(unit, turn), (0, 0, unit))
  for e in frame {
    heavy-arrow((0, 0), at(e), shaft: 0.7, length: 3.6, width: 2.2)
  }
  spot((0, 0))
  spot(at((0, 0, point)), radius: 1)
  content((0, 0), cutout($O$), anchor: "south-east", padding: 1.5)
  content(
    at(frame.at(0)).map(c => 0.62 * c),
    cutout($arrow(e)_1$),
    anchor: "south",
    padding: 2,
  )
  content(
    at(frame.at(1)),
    cutout($arrow(e)_2$),
    anchor: "north-east",
    padding: 1,
  )
  content(at(frame.at(2)), $arrow(e)_3$, anchor: "west", padding: 2.5)
  content(at((0, 0, point)), $P(l, phi)$, anchor: "west", padding: 1.8)
  content(at((0, 0, 0.9 * low)), $l(A)$, anchor: "east", padding: 1.5)
  content((square.at(2), 75%, square.at(1)), $Pi(A)$, anchor: "west")
  // The fixed frame at O′: the frame x, y, z turned by the angles
  // `tilts` about z, y and x in turn.
  let rotate-pair(p, (i, j), angle) = {
    let q = p
    q.at(i) = p.at(i) * calc.cos(angle) - p.at(j) * calc.sin(angle)
    q.at(j) = p.at(i) * calc.sin(angle) + p.at(j) * calc.cos(angle)
    q
  }
  let tilts = (((0, 1), 35.3deg), ((2, 0), 24.5deg), ((1, 2), 23.8deg))
  let fixed(p) = tilts.fold(p, (q, (pair, angle)) => rotate-pair(
    q,
    pair,
    angle,
  ))
  group({
    translate((-27.0, 13.3))
    let names = ($arrow(a)_1$, $arrow(a)_2$, $arrow(a)_3$)
    let sides = ("north-west", "south-west", "west")
    for (k, name) in names.enumerate() {
      let tip = at(fixed(range(3).map(i => if i == k { 11.6 } else { 0 })))
      line((0, 0), tip, mark: (
        end: "stealth",
        length: 2.6mm,
        width: 1.3mm,
        inset: 0.8mm,
      ))
      content(tip, name, anchor: sides.at(k), padding: 0.8)
    }
    spot((0, 0))
    content((0, 0), $O'$, anchor: "east", padding: 1.5)
  })
})

// Figure 55: ℝP³ as S³ with antipodal points x, −x identified, as the
// hemisphere S³₊ with antipodal points of its equator identified, and as the
// disc D³ with antipodal boundary points identified, the hemisphere
// projected orthogonally onto D³ ⊂ ℝ³. A drawing.
#let fig-4-55() = lettered-drawing(book-picture(
  "/assets/figures/04-55-projective-space.svg",
  104.52,
  labels: (
    ((4.0, 35.1), $S^3$),
    ((11.9, 24.6), $O$),
    ((20.5, 27.6), $x$),
    ((10.4, 15.9), $-x$),
    ((29.0, 23.9), $tilde.equiv$),
    ((58.9, 31.4), $S_+^3$),
    ((44.8, 12.3), rotate(90deg, $tilde.equiv$)),
    ((57.6, 12.6), $D^3$),
    ((75.2, 24.4), $S_+^3$),
    ((66.5, 6.6), $RR^3$),
    ((92.9, 7.1), $D^3$),
  ),
))
// A filled arrowhead inside a segment, `at` of its way from `from` to
// `to`, pointing towards `to`.
#let mid-mark(from, to, at, ..style) = cetz.draw.mark(
  (from, at, to),
  to,
  symbol: "stealth",
  ..style,
)

// Figure 56: the map f of the plane ℝ² = ℂ¹ and its differential at z,
// dw = λ(z) dz, a rotation and a dilation. Each plane is a stippled slab
// in perspective, its face a free-hand quadrilateral (corners as printed),
// the second the mirror image of the first; w is the mirror image of z,
// dw = λ dz with λ = 1.35 e^(−iπ/2).
#let fig-4-56() = lettered-drawing({
  import cetz.draw: *
  let axis = 42.3
  let face = ((0.65, 2.3), (9.45, 26.75), (26.6, 31.35), (37.7, 13.5))
  let depth = 2.1
  let (z, dz) = ((17.3, 18.4), (9.2, 8.8))
  let (modulus, argument) = (1.35, -90deg)
  let dw = (
    modulus * (dz.at(0) * calc.cos(argument) - dz.at(1) * calc.sin(argument)),
    modulus * (dz.at(0) * calc.sin(argument) + dz.at(1) * calc.cos(argument)),
  )
  let mirror((x, y)) = (2 * axis - x, y)
  let w = mirror(z)
  for reflect in (p => p, mirror) {
    let (near, far, top, edge) = face.map(reflect)
    line(near, far, top, edge, close: true, fill: stipple, stroke: thick-line)
    line(
      near,
      edge,
      (rel: (0, -depth), to: edge),
      (rel: (0, -depth), to: near),
      close: true,
      fill: black,
      stroke: none,
    )
    content((far, 45%, top), $RR^2 = CC^1$, anchor: "south", padding: 1.6)
  }
  for (p, v, name) in ((z, dz, $d z$), (w, dw, $d w$)) {
    let tip = vec-add(p, v)
    line(p, tip, stroke: 0.45mm)
    mid-mark(p, tip, 80%)
    spot(p, radius: 1)
  }
  content(
    vec-add(z, vec-scale(0.8, dz)),
    cutout($d z$),
    anchor: "north-west",
  )
  content(
    vec-add(w, vec-scale(0.8, dw)),
    cutout($d w$),
    anchor: "north-east",
  )
  content(z, cutout($z$), anchor: "north-east", padding: 1.6)
  content(w, cutout($w$), anchor: "east", padding: 1.8)
  // The map above, its differential below.
  line((axis - 12.25, 28.5), (axis + 12.25, 28.5), name: "f")
  mid-mark("f.start", "f.end", 90%)
  content("f.mid", $f$, anchor: "south", padding: 1.5)
  line((36, 3.4), (50.5, 3.4), name: "df")
  mid-mark("df.start", "df.end", 90%)
  content("df.mid", $d f|_z$, anchor: "south", padding: 1.2)
  content("df.start", $T_z RR^2 = RR^2$, anchor: "east")
  content("df.end", $T_w RR^2 = RR^2$, anchor: "west")
})

// Figure 57: coefficients a, b, c, d of a transformation of the upper
// half-plane, all proportional to real numbers by one complex ρ: they lie
// on the line through O at the angle arg ρ, which turns onto the real axis.
#let fig-4-57() = lettered-drawing({
  import cetz.draw: *
  let turn = 22deg
  // The points as distances along the line, in mm.
  let points = (($a$, 16.5), ($c$, 20.6), ($b$, 31.9), ($d$, 40.0))
  cetz.angle.angle(
    (0, 0),
    (1, 0),
    (turn, 1),
    radius: 10.2,
    fill: stipple,
    stroke: 0.5mm,
    mark: (start: "stealth", length: 2mm, width: 1.4mm, inset: 0.6mm),
  )
  axis-line((-2.95, 0), (41.4, 0))
  axis-line((0, -8.6), (0, 32.9))
  line((180deg + turn, 3.1), (turn, 47.2), stroke: 0.6mm)
  for (name, distance) in points {
    spot((turn, distance), radius: 1.1)
    content((turn, distance), name, anchor: "south", padding: 1.8)
  }
  circle((0, 0), radius: 1, stroke: 0.45mm)
  content((0, 0), $O$, anchor: "north-west", padding: 1.4)
  content((41.4, 0), $x$, anchor: "north-east", padding: 1.4)
  content((0, 31), $y$, anchor: "east", padding: 1.4)
})

// Figure 58: the reflection g₀: z ↦ −z̄ in the axis Oy reverses oriented
// angles: the angle from the point 1 to the point 2 (stippled, its arc
// arrowed) goes to the angle from 1′ to 2′, turned the other way.
#let fig-4-58() = lettered-drawing({
  import cetz.draw: *
  let (one, two) = ((19.0, 30deg), (30.1, 54deg))
  let polar((r, a), side) = (side * r * calc.cos(a), r * calc.sin(a))
  let names = (($1$, $2$), ($1'$, $2'$))
  for (side, (first, second)) in (1, -1).zip(names) {
    let (p, q) = (polar(one, side), polar(two, side))
    let arc = sample(
      a => polar((one.at(0), a), side),
      one.at(1),
      two.at(1),
      n: 40,
    )
    line((0, 0), ..arc, close: true, fill: stipple, stroke: none)
    line(..arc, stroke: thick-line)
    mark(
      arc.at(-4),
      plane-direction(arc.at(-6), arc.at(-4)),
      symbol: "stealth",
      length: 2.6mm,
      width: 1.6mm,
      inset: 0.6mm,
    )
    for tip in (p, q) {
      let head = plane-towards((0, 0), tip, 0.92 * calc.norm(..tip))
      line((0, 0), tip, stroke: 0.8mm)
      heavy-arrow((0, 0), head, shaft: 0.8, length: 3.6, width: 2.3)
    }
    let side-anchor = if side > 0 { "west" } else { "east" }
    content(p, first, anchor: side-anchor, padding: 1.2)
    content(q, second, anchor: side-anchor, padding: 1.2)
  }
  for (r, a) in (one, two) {
    line(polar((r, a), -1), polar((r, a), 1))
  }
  axis-line((-25.6, 0), (25.2, 0))
  axis-line((0, -15.4), (0, 33.6))
  content((25.2, 0), $x$, anchor: "north-east", padding: 1.4)
  content((0, 33.6), $y$, anchor: "north-west", padding: 1.4)
})
// Figure 59: four isometries of ℝ³₁ preserving the pseudosphere, the
// two-sheeted hyperboloid, each with the plane between its sheets: а) the
// identity, б) the reflection in yz, в) in the point 0, г) in yx. A drawing.
#let fig-4-59() = lettered-drawing(book-picture(
  "/assets/figures/04-59-pseudosphere-reflections.svg",
  95.63,
  labels: (
    ((24.4, 30.6), emph[а)]),
    ((75.8, 31.1), emph[б)]),
    ((21.4, 2.2), emph[в)]),
    ((75.1, 4.0), emph[г)]),
  ),
))

// Figure 60: the group O(n) on the sphere S^(n²−1) of radius √n about O in
// the space ℝ^(n²) of matrices, through the unit matrix E. A drawing.
#let fig-4-60() = lettered-drawing(book-picture(
  "/assets/figures/04-60-orthogonal-group.svg",
  49.53,
  labels: (
    ((43.2, 45.7), $S^(n^2 - 1)$),
    ((27.5, 25.7), $O$),
    ((2.75, 8.85), $upright(O)(n)$),
    ((31.8, 6.2), $E$),
  ),
))
