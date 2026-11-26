// Figures of chapter 5, § 5. Each is a function called by the text:
// `#fig(fig-5-33()) <fig:…>`.
#import "common.typ": *

// A cell of parallel transports. The `sides` (from, through, to) are bold
// circular arcs through three points, each with its arrowhead near its
// end, named "side-0", "side-1", …; their ends are open circles. The cell
// bounded by the sides taken in `order` ((index, reversed) pairs) is
// stippled; where two sides of the outline do not meet, the dashed gap
// between the ends `gap`, named "gap", closes it.
#let transport-cell(sides, order, gap) = {
  import cetz.draw: *
  merge-path(close: true, fill: stipple, stroke: none, {
    for (k, reversed) in order {
      let (a, m, b) = sides.at(k)
      if reversed { arc-through(b, m, a) } else { arc-through(a, m, b) }
    }
  })
  line(..gap, stroke: (thickness: thick-line, ..hidden.stroke), name: "gap")
  for (k, (a, m, b)) in sides.enumerate() {
    let name = "side-" + str(k)
    arc-through(a, m, b, stroke: 1.5 * thick-line, name: name)
    mark(
      (name: name, anchor: 80%),
      (name: name, anchor: 82%),
      symbol: "stealth",
      length: 3.4,
      width: 2,
    )
  }
  for (a, m, b) in sides {
    for p in (a, b) {
      circle(p, radius: 0.85, fill: white, stroke: thick-line)
    }
  }
}

// Figure 33: the transports ∇ₖ∇ₗ and ∇ₗ∇ₖ from P along the coordinate
// lines: first along xᵏ, then along xˡ, gives Q; in the other order, Q′;
// the gap between them is ε. A schematic: each side is the circular arc
// through its ends and one point between them; the cell they bound is
// stippled.
#let fig-5-33() = drawing({
  import cetz.draw: *
  let (p, a, q) = ((0, 0), (13.8, 11.9), (48, 11.2))
  let (b, q-other) = ((28.4, -12.3), (61.8, -4.2))
  let sides = (
    (p, (5.9, 6.8), a),
    (a, (30.9, 13.1), q),
    (p, (14.4, -6.4), b),
    (b, (45.3, -5.7), q-other),
  )
  transport-cell(
    sides,
    ((0, false), (1, false), (3, true), (2, true)),
    (
      q,
      q-other,
    ),
  )
  content((name: "side-0", anchor: 50%), $nabla_k$, anchor: "south-east")
  content((name: "side-1", anchor: 50%), $nabla_l$, anchor: "south")
  content((name: "side-2", anchor: 50%), $nabla_l$, anchor: "north-east")
  content((name: "side-3", anchor: 50%), $nabla_k$, anchor: "north")
  content("gap.mid", $epsilon$, anchor: "south-west")
  content(p, $P$, anchor: "north", padding: 1.6)
  content(q, $Q$, anchor: "south-west", padding: 1.2)
  content(q-other, $Q'$, anchor: "north", padding: 1.6)
})

// Figure 34: the small «parallelogram» of transports from P: along xᵏ,
// along xˡ, back along xᵏ, back along xˡ; it ends at Q, not at P, the gap
// being ε′. A schematic: each side is the circular arc through its ends
// and one point between them; the cell is stippled.
#let fig-5-34() = drawing({
  import cetz.draw: *
  let (p, b, c) = ((0, 0), (17.8, -12.7), (36.7, -4.2))
  let (d, q) = ((28, 19.3), (4.9, 14.6))
  let sides = (
    (p, (8.7, -4.9), b),
    (b, (27.5, -7.4), c),
    (c, (34.3, 7.8), d),
    (d, (15.7, 18), q),
  )
  transport-cell(sides, range(4).map(k => (k, false)), (q, p))
  content((name: "side-0", anchor: 50%), $nabla_k$, anchor: "north-east")
  content((name: "side-1", anchor: 50%), $nabla_l$, anchor: "north-west")
  content((name: "side-2", anchor: 50%), $-nabla_k$, anchor: "west")
  content((name: "side-3", anchor: 50%), $-nabla_l$, anchor: "south")
  content("gap.mid", $epsilon'$, anchor: "east")
  content(p, $P$, anchor: "north-east", padding: 1.4)
  content(q, $Q$, anchor: "south-east", padding: 1.2)
})

// Figure 35: the «parallelogram» of Fig. 34 on S² in the coordinates
// (θ, φ): from P down the meridian by α to the equator, along it by the
// length β, up the meridian by α, back along the parallel θ = `top` by the
// length β. The parallel is shorter than the equator, so the last step
// turns by β / sin θ and ends at Q beyond P. The sphere of `radius` in the
// orthographic view; the equator, its back dashed; the meridians of the
// corners up to the pole N; hand shading strokes along the lower right
// limb.
#let fig-5-35() = drawing({
  import cetz.draw: *
  let radius = 25.8
  let view = orthographic(0deg, 40deg)
  let at = view.project
  let seen(p) = facing(view, p)
  // A point at the polar angle θ and the turn φ from the front.
  let on(polar, turn) = (
    radius * calc.sin(polar) * calc.cos(turn - 90deg),
    radius * calc.sin(polar) * calc.sin(turn - 90deg),
    radius * calc.cos(polar),
  )
  let (top, bottom) = (50deg, 90deg)
  let (turn-p, step) = (22deg, 62deg)
  let turn-left = turn-p - step
  let turn-q = turn-left + step / calc.sin(top)
  let parallel(polar, from, to) = sample(t => at(on(polar, t)), from, to, n: 60)
  let meridian(turn, from, to) = sample(t => at(on(t, turn)), from, to, n: 60)
  // The path, side by side, each with its arrowhead.
  let sides = (
    meridian(turn-p, top, bottom),
    parallel(bottom, turn-p, turn-left),
    meridian(turn-left, bottom, top),
    parallel(top, turn-left, turn-q),
  )
  let cell = (
    sides.at(0) + sides.at(1) + sides.at(2) + parallel(top, turn-left, turn-p)
  )
  line(..cell, close: true, fill: stipple, stroke: none)
  circle((0, 0), radius: radius, stroke: thick-line)
  for k in range(30) {
    let s = -8deg - k * 3.4deg
    let middle = (s, (0.875 + 0.04 * calc.rem(k, 2)) * radius)
    line(
      (rel: (s - 90deg, 0.55), to: middle),
      (rel: (s + 90deg, 0.55), to: middle),
    )
  }
  seen-hidden(at, seen, sample(t => on(90deg, t), 0deg, 360deg, n: 180))
  for turn in (turn-p, turn-left) { line(..meridian(turn, 0deg, top)) }
  for (k, side) in sides.enumerate() {
    line(..side, stroke: 1.5 * thick-line)
    let n = side.len()
    let tip = if k == 3 { calc.floor(n * 0.45) } else { calc.floor(n * 0.75) }
    mark(
      side.at(tip - 1),
      side.at(tip),
      symbol: "stealth",
      length: 3.4,
      width: 2,
    )
  }
  let p = at(on(top, turn-p))
  let q = at(on(top, turn-q))
  let n = at(on(0deg, 0deg))
  for corner in (
    p,
    sides.at(0).last(),
    sides.at(1).last(),
    sides.at(2).last(),
  ) {
    spot(corner, radius: 0.9)
  }
  spot(q, radius: 1)
  circle(n, radius: 0.85, fill: white, stroke: thick-line)
  content(n, $N$, anchor: "south-east", padding: 1)
  content(q, $Q$, anchor: "west", padding: 1.4)
  content(p, cutout($P$), anchor: "north-west", padding: 1.2)
  content(sides.at(0).at(30), $alpha$, anchor: "west", padding: 1.6)
  content(sides.at(1).at(40), $beta$, anchor: "north", padding: 1.6)
  content(sides.at(2).at(30), $-alpha$, anchor: "east", padding: 1.6)
  content(sides.at(3).at(18), $-beta$, anchor: "south", padding: 1.4)
  content((40deg, radius), $S^2$, anchor: "south-west", padding: 1)
})

// Figure 36: the geodesics orthogonal to a geodesic γ. On S², the
// meridians through the arc AB of the equator γ, from N to S (the front
// halves, every `meridian-step`); the sphere in the orthographic view, the
// back of γ dashed, hand shading strokes along the right limb. On the
// half plane L₂, γ is the half circle of radius `radius` about the origin;
// the geodesics orthogonal to it are the half circles through a point a
// of the axis inside γ and its inverse r²/a, every `foot-step` of a, and
// the vertical line a = 0; they are cut off by an ellipse. The cell
// between γ and the geodesics through A and B (meeting the axis at C and
// D) is stippled. The sphere stands over the half plane.
#let fig-5-36() = drawing({
  import cetz.draw: *
  let (radius, foot-step, turn-a, turn-b) = (24.5, 1.1, 124deg, 56deg)
  // The ellipse cutting the lines off: its centre on the axis and its
  // semi-axes.
  let (cut-centre, cut-x, cut-y) = (-9.3, 45.5, 74.5)
  let inside((x, y)) = (
    calc.pow((x - cut-centre) / cut-x, 2) + calc.pow(y / cut-y, 2) < 1
  )
  // The geodesic with the foot a inside γ: from the foot along `length`.
  let geodesic(a, length: 150) = {
    let centre = (a + radius * radius / a) / 2
    let size = calc.abs(radius * radius / a - a) / 2
    let (start, sense) = if a < 0 { (0deg, 1) } else { (180deg, -1) }
    let reach = calc.min(180deg, length / size * 1rad)
    sample(
      s => (
        centre + size * calc.cos(start + sense * s),
        size * calc.sin(start + sense * s),
      ),
      0deg,
      reach,
      n: 160,
    )
  }
  let clipped(points) = {
    let out = points.position(p => not inside(p))
    if out == none { points } else { points.slice(0, out) }
  }
  // The foot of the geodesic through the point of γ at the turn t.
  let foot(t) = radius * (1 - calc.sin(t)) / calc.cos(t)
  let on-gamma(t) = (radius * calc.cos(t), radius * calc.sin(t))
  // The piece of the geodesic through γ(t) from its foot to γ.
  let inner(t) = {
    let points = geodesic(foot(t), length: radius)
    let x = on-gamma(t)
    points.filter(p => calc.norm(..p) <= radius) + (x,)
  }
  let along-gamma(from, to) = sample(on-gamma, from, to, n: 90)
  line(
    ..inner(turn-a),
    ..along-gamma(turn-a, turn-b),
    ..inner(turn-b).rev(),
    close: true,
    fill: stipple,
    stroke: none,
  )
  let count = int(calc.floor(radius / foot-step))
  for k in range(-count, count + 1).filter(k => k != 0) {
    line(..clipped(geodesic(k * foot-step)))
  }
  line((0, 0), (0, cut-y * calc.sqrt(1 - calc.pow(cut-centre / cut-x, 2))))
  line((cut-centre - cut-x, 0), (cut-centre + cut-x, 0))
  line(..along-gamma(0deg, 180deg))
  line(..along-gamma(turn-a, turn-b), stroke: 2 * thick-line)
  line(..inner(turn-a), stroke: 2 * thick-line)
  line(..inner(turn-b), stroke: 2 * thick-line)
  let (a, b) = (on-gamma(turn-a), on-gamma(turn-b))
  let (c, d) = ((foot(turn-a), 0), (foot(turn-b), 0))
  for p in (a, b, c, d) { spot(p, radius: 1) }
  content(a, cutout($A$), anchor: "south-east", padding: 1.2)
  content(b, cutout($B$), anchor: "south-west", padding: 1.2)
  content(c, $C$, anchor: "north", padding: 1.6)
  content(d, $D$, anchor: "north", padding: 1.6)
  content(on-gamma(150deg), cutout($gamma$), anchor: "south-east", padding: 1)
  content((5.6, 66), cutout($L_2$))
  // The sphere.
  group({
    translate((-41.6, 53.5))
    let size = 24.2
    let view = orthographic(0deg, 12deg)
    let at = view.project
    let seen(p) = facing(view, p)
    let on(polar, turn) = (
      size * calc.sin(polar) * calc.cos(turn - 90deg),
      size * calc.sin(polar) * calc.sin(turn - 90deg),
      size * calc.cos(polar),
    )
    let meridian-step = 56deg / 24
    circle((0, 0), radius: size, fill: white, stroke: thick-line)
    for k in range(17) {
      let s = 36deg - k * 5.6deg
      let middle = (s, 0.86 * size)
      line(
        (rel: (s - 90deg, 0.55), to: middle),
        (rel: (s + 90deg, 0.55), to: middle),
      )
    }
    for k in range(25) {
      let turn = -28deg + k * meridian-step
      line(..sample(t => on(t, turn), 0deg, 180deg, n: 90).filter(seen).map(at))
    }
    seen-hidden(at, seen, sample(t => on(90deg, t), -180deg, 180deg, n: 180))
    line(
      ..sample(t => at(on(90deg, t)), -28deg, 28deg, n: 40),
      stroke: 2 * thick-line,
    )
    spot(at(on(0deg, 0deg)), radius: 1.2)
    let (a, b) = (at(on(90deg, -28deg)), at(on(90deg, 28deg)))
    spot(a, radius: 1)
    spot(b, radius: 1)
    content(a, cutout($A$), anchor: "east", padding: 1.6)
    content(b, cutout($B$), anchor: "north-west", padding: 1.2)
    content(at(on(90deg, -56deg)), $gamma$, anchor: "north", padding: 1.4)
  })
})

// Figure 37: the geodesics orthogonal to the arc AB of a geodesic. Left,
// on S² seen from the side: the meridians through AB meet at N and S.
// Right, on L₂ in the disc model: the half plane of Fig. 36 (γ the unit
// half circle, the orthogonal geodesics through the feet a and 1/a) carried
// to the disc by w = i(z − it)/(z + it), which puts γ at the distance
// (t − 1)/(t + 1) under the centre. The geodesics through A and B reach the
// circle at R, C and T, D: they part without bound both ways. The cells
// between them are stippled.
#let fig-5-37() = drawing({
  import cetz.draw: *
  // The lens: the sphere of `lens` mm seen along the equator, the
  // meridians up to the turn `spread` either way from the front.
  let (lens, spread, count) = (21.7, 18deg, 31)
  let meridian(turn) = sample(
    s => (lens * calc.sin(s) * calc.sin(turn), lens * calc.cos(s)),
    0deg,
    180deg,
    n: 90,
  )
  for k in range(count) {
    line(..meridian(-spread + k * 2 * spread / (count - 1)))
  }
  let (a, b) = ((-lens * calc.sin(spread), 0), (lens * calc.sin(spread), 0))
  line(a, b, stroke: 2 * thick-line)
  for p in (a, b, (0, lens), (0, -lens)) { spot(p, radius: 1.1) }
  content((0, lens), $N$, anchor: "south-west", padding: 0.8)
  content((0, -lens), $S$, anchor: "north-west", padding: 0.8)
  content(a, $A$, anchor: "east", padding: 1.6)
  content(b, $B$, anchor: "west", padding: 1.6)
  content((-lens * 0.62, -lens * 0.72), [на $S^2$], anchor: "east")
  // The disc.
  group({
    translate((46.1, -1.8))
    let (size, t, foot-a) = (23.5, 2.096, calc.sqrt(2) - 1)
    let to-disc((x, y)) = {
      let (dx, dy) = (x, y + t)
      let den = dx * dx + dy * dy
      let (qx, qy) = (
        (x * dx + (y - t) * dy) / den,
        ((y - t) * dx - x * dy) / den,
      )
      (-qy * size, qx * size)
    }
    // The orthogonal geodesic with the inner foot a: the point where it
    // crosses γ, and its pieces from the foot to γ and from γ on.
    let geodesic(a) = {
      if a == 0 {
        let cross = to-disc((0, 1))
        return (((0, -size), cross), (cross, (0, size)))
      }
      let (centre, radius) = ((a + 1 / a) / 2, calc.abs(1 / a - a) / 2)
      let (from, sense) = if a < 0 { (0deg, 1) } else { (180deg, -1) }
      let at-gamma = calc.atan2(
        1 / centre - centre,
        calc.sqrt(1 - 1 / (centre * centre)),
      )
      let reach = calc.abs(at-gamma - from)
      let point(s) = to-disc((
        centre + radius * calc.cos(from + sense * s),
        radius * calc.sin(from + sense * s),
      ))
      (sample(point, 0deg, reach, n: 40), sample(point, reach, 180deg, n: 300))
    }
    let gamma-arc(from, to) = sample(
      s => to-disc((calc.cos(s), calc.sin(s))),
      from,
      to,
      n: 90,
    )
    let rim(from, to) = sample(
      s => (size * calc.cos(s), size * calc.sin(s)),
      from,
      to,
      n: 90,
    )
    let turn-of(p) = calc.atan2(..p)
    let (inner-a, outer-a) = geodesic(-foot-a)
    let (inner-b, outer-b) = geodesic(foot-a)
    let (pa, pb) = (inner-a.last(), inner-b.last())
    let (r, c) = (outer-a.last(), inner-a.first())
    let (t-point, d) = (outer-b.last(), inner-b.first())
    line(
      ..outer-a.rev(),
      ..gamma-arc(135deg, 45deg),
      ..outer-b,
      ..rim(turn-of(t-point), turn-of(r)),
      close: true,
      fill: stipple,
      stroke: none,
    )
    line(
      ..inner-a,
      ..gamma-arc(135deg, 45deg),
      ..inner-b.rev(),
      close: true,
      fill: stipple,
      stroke: none,
    )
    for k in range(-8, 9) {
      let (inner, outer) = geodesic(k * foot-a / 9)
      line(..inner, ..outer)
    }
    circle((0, 0), radius: size, stroke: thick-line)
    line(..gamma-arc(180deg, 0deg))
    line(..gamma-arc(135deg, 45deg), stroke: 2 * thick-line)
    line(..outer-a, stroke: 1.5 * thick-line)
    line(..outer-b, stroke: 1.5 * thick-line)
    line(..inner-a, stroke: 2 * thick-line)
    line(..inner-b, stroke: 2 * thick-line)
    for p in (pa, pb, r, c, t-point, d) { spot(p, radius: 1.1) }
    content(pa, $A$, anchor: "north-east", padding: 1.4)
    content(pb, $B$, anchor: "north-west", padding: 1.4)
    content(r, $R$, anchor: "north-east", padding: 1.4)
    content(t-point, $T$, anchor: "south-west", padding: 1.2)
    content(c, $C$, anchor: "north-east", padding: 1.2)
    content(d, $D$, anchor: "north-west", padding: 1.2)
    content((50deg, size), [на $L_2$], anchor: "south-west", padding: 1.6)
  })
})

// Figure 38: the geodesics through one point. On S² (orthographic view)
// the great circles through P meet again at −P: the circles of the frame
// (P, e₁, e₂) a quarter of a half turn apart, the hidden arcs dashed. On L₂
// in the disc model, the geodesics through the point p are the images of
// the diameters under the automorphism z ↦ (z + p)/(1 + p̄z) of the disc,
// at the turns `step` apart; they crowd into black about p.
#let fig-5-38() = drawing({
  import cetz.draw: *
  let radius = 19.35
  let view = orthographic(0deg, 0deg)
  let at = view.project
  let seen(q) = facing(view, q)
  // The point P on the near side, from its place on the page.
  let (px, pz) = (-0.683, -0.236)
  let pole = (px, -calc.sqrt(1 - px * px - pz * pz), pz)
  let unit(v) = {
    let size = calc.sqrt(v.map(c => c * c).sum())
    v.map(c => c / size)
  }
  let e1 = unit(vec-cross(pole, (0, 0, 1)))
  let e2 = vec-cross(pole, e1)
  let great(turn) = sample(
    s => range(3).map(i => (
      radius
        * (
          calc.cos(s) * pole.at(i)
            + calc.sin(s)
              * (calc.cos(turn) * e1.at(i) + calc.sin(turn) * e2.at(i))
        )
    )),
    0deg,
    360deg,
    n: 240,
  )
  // No circle is seen edge-on: their planes stay clear of the line of
  // sight by half the turn between them.
  let edge-on = calc.atan2(
    vec-dot(view.toward, e1),
    vec-dot(view.toward, e2),
  )
  for k in range(4) {
    seen-hidden(at, seen, great(edge-on + 22.5deg + k * 45deg))
  }
  circle((0, 0), radius: radius, stroke: thick-line)
  spot(at(pole.map(c => radius * c)), radius: 0.9)
  spot(at(pole.map(c => -radius * c)), radius: 0.9)
  content((-100deg, radius), $S^2$, anchor: "north", padding: 1.2)
  // The disc.
  group({
    translate((52.2, -1.1))
    let (size, p, step) = (23.3, (0.109, -0.495), 2.25deg)
    let move(z) = complex-over(
      (z.at(0) + p.at(0), z.at(1) + p.at(1)),
      {
        let (x, y) = complex-times((p.at(0), -p.at(1)), z)
        (1 + x, y)
      },
    )
    for k in range(int(180deg / step)) {
      let turn = k * step
      line(
        ..sample(
          s => move((s * calc.cos(turn), s * calc.sin(turn))).map(c => (
            size * c
          )),
          -1,
          1,
          n: 120,
        ),
        stroke: 0.9pt,
      )
    }
    circle((0, 0), radius: size, stroke: 2 * thick-line)
    content((-25deg, size), $L_2$, anchor: "west", padding: 1.6)
  })
})

// Figure 39: the octahedron of the proof that ⟨R(X, Y)Z; W⟩ =
// ⟨R(Z, W)X; Y⟩: the scalar products stand at its vertices, and those of
// each hatched face sum to zero. The octahedron in an oblique view: the
// centre and the images of its three half-axes, α up, b right, d to the
// front; the vertices opposite are β, c, a. Left, its edges, the edges
// through the back vertex a parted where they pass behind; right, the faces
// α a c, α b d, c d β, a b β hatched parallel to one of their edges,
// crossed where they overlap.
#let fig-5-39() = drawing({
  import cetz.draw: *
  let (up, right, front) = ((0, 18), (15.3, 3.9), (4.2, -4.9))
  let at(centre, v, k) = (
    centre.at(0) + k * v.at(0),
    centre.at(1) + k * v.at(1),
  )
  let vertices(centre) = (
    alpha: at(centre, up, 1),
    beta: at(centre, up, -1),
    b: at(centre, right, 1),
    c: at(centre, right, -1),
    d: at(centre, front, 1),
    a: at(centre, front, -1),
  )
  // The edges of the octahedron: the back ones through a first, the
  // others passing over them.
  let edges(v, parted) = {
    let back = ("alpha", "beta", "b", "c").map(n => (v.a, v.at(n)))
    let others = (
      ("alpha", "b"),
      ("alpha", "c"),
      ("alpha", "d"),
      ("beta", "b"),
      ("beta", "c"),
      ("beta", "d"),
      ("b", "d"),
      ("c", "d"),
    ).map(((p, q)) => (v.at(p), v.at(q)))
    for (p, q) in back { line(p, q, stroke: thick-line) }
    if parted {
      bridge(..others, gap: 1.4)
    } else {
      for (p, q) in others { line(p, q) }
    }
  }
  set-style(stroke: (thickness: thick-line))
  let left = vertices((0, 0))
  edges(left, true)
  for v in left.values() { spot(v, radius: 1) }
  for (name, label, anchor) in (
    ("alpha", $alpha$, "south"),
    ("beta", $beta$, "north"),
    ("a", $a$, "south-east"),
    ("b", $b$, "north"),
    ("c", $c$, "east"),
    ("d", $d$, "north"),
  ) {
    content(left.at(name), label, anchor: anchor, padding: 1.4)
  }
  // The right octahedron and its hatched faces.
  let v = vertices((40, -0.2))
  let hatch(p, q, r, spacing: 1.05) = {
    // Lines parallel to pq, from it to the vertex r.
    let height = {
      let (ex, ey) = (q.at(0) - p.at(0), q.at(1) - p.at(1))
      (
        calc.abs(ex * (r.at(1) - p.at(1)) - ey * (r.at(0) - p.at(0)))
          / calc.norm(
            ex,
            ey,
          )
      )
    }
    let count = int(calc.ceil(height / spacing))
    for k in range(1, count) {
      let u = k / count
      line(
        at(p, (r.at(0) - p.at(0), r.at(1) - p.at(1)), u),
        at(
          q,
          (
            r.at(0) - q.at(0),
            r.at(1) - q.at(1),
          ),
          u,
        ),
        stroke: thin-line,
      )
    }
  }
  hatch(v.alpha, v.c, v.a)
  hatch(v.alpha, v.b, v.d)
  hatch(v.c, v.beta, v.d)
  hatch(v.b, v.beta, v.a)
  edges(v, false)
  for p in v.values() { spot(p, radius: 1) }
  // The products are set smaller, as printed, to stand clear of the edges.
  let product(x, y, z, w) = text(
    size: 7.5pt,
    $chevron.l R(#x, #y) #z ; #w chevron.r$,
  )
  content(
    v.alpha,
    product($X$, $Y$, $Z$, $W$),
    anchor: "south-west",
    padding: 0.8,
  )
  content(
    (v.alpha, 50%, v.c),
    product($Y$, $W$, $Z$, $X$),
    anchor: "south-east",
  )
  content((v.alpha, 62%, v.b), product($Y$, $Z$, $X$, $W$), anchor: "west")
  content(
    (rel: (3.6, -5), to: v.c),
    product($X$, $W$, $Y$, $Z$),
    anchor: "north-east",
    padding: 0,
  )
  content(
    (v.b, 55%, v.beta),
    product($Z$, $X$, $Y$, $W$),
    anchor: "west",
    padding: 1,
  )
  content(
    v.beta,
    product($Z$, $W$, $X$, $Y$),
    anchor: "north-west",
    padding: 0.8,
  )
})

// Figure 40: the geodesic surface M² of the plane H = (X⃗, Y⃗) at P: the
// geodesics from P in the directions Z⃗ ∈ H (dashed on the plate H) sweep
// the surface M² tangent to H. A drawing; the labels over it, at the points
// they name (mm from its top left corner).
#let fig-5-40() = drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/05-40-geodesic-surface.svg",
    90.13,
    anchor: "north-west",
  )
  for (x, y, label) in (
    (40.56, 5.59, cutout($P$)),
    (50.72, 5.97, cutout($arrow(X)$)),
    (55.96, 15.2, cutout($arrow(Y)$)),
    (38.99, 16.26, cutout($arrow(Z)$)),
    (65.45, 14.99, cutout($H$)),
    (81.87, 9.1, $M^2$),
  ) {
    content((x, -y), label)
  }
})

