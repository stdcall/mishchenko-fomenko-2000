// Figures of chapter 3, § 4. Each is a function called by the text:
// `#fig(fig-3-17()) <fig:…>`.
#import "common.typ": *

// Figure 17: the map f(x, y) = (x, y²) and the curves through P₀ = (0, 0)
// tangent to ξ⃗ along the x-axis: γ₁, γ₂ the parabolas y = a x², γ₃ the
// parabola y = −a x² to the left and a staircase descent
// y = −c (x − sin(ωx)/ω) to the right; on the right their images under f,
// all in the upper half-plane, with η = df_P₀(ξ⃗) = ξ⃗. Each plane is
// framed by the square |x|, |y| ≤ 1 (unit `unit`); the right one is
// stretched `stretch` times along y and shows longer or shorter pieces
// of the images, as printed.
#let fig-3-17() = slim-drawing({
  import cetz.draw: *
  let (unit, apart, stretch) = (14.18, 47.37, 1.8)
  let staircase(x) = -0.78 * (x - calc.sin(19.6 * x) / 19.6)
  // The curves by x ↦ y, each with the ends of its piece on the left
  // and of the piece of its image on the right.
  let curves = (
    (x => 2.36 * x * x, (-0.498, 0.498), (-0.49, 0.457)),
    (x => 0.74 * x * x, (-0.669, 0.666), (-0.675, 0.81)),
    (
      x => if x < 0 { -1.85 * x * x } else { staircase(x) },
      (-0.498, 0.633),
      (-0.55, 0.84),
    ),
  )
  let plane(origin, map, piece, name) = {
    let at((x, y)) = (origin + unit * x, unit * y)
    line(at((-1, -1)), at((1, -1)), at((1, 1)), at((-1, 1)), close: true)
    arrowed(at((-1.42, 0)), at((1.45, 0)), name: name + "-x")
    arrowed(at((0, -1.41)), at((0, 1.56)), name: name + "-y")
    content(name + "-x.end", $x$, anchor: "north-east")
    content(name + "-y.end", $y$, anchor: "east")
    for (i, curve) in curves.enumerate() {
      let (y, (from, to)) = (curve.at(0), curve.at(piece))
      line(
        ..sample(x => at(map((x, y(x)))), from, to, n: 120),
        name: name + "-" + str(i),
      )
    }
    arrowed(at((0, 0)), at((0.73, 0)), stroke: thick-line, name: name + "-v")
  }
  plane(0, p => p, 1, "left")
  plane(apart, ((x, y)) => (x, stretch * y * y), 2, "right")
  content("left-0.end", $gamma_1$, anchor: "east")
  content("left-1.end", $gamma_2$, anchor: "west")
  content("left-2.end", $gamma_3$, anchor: "north-east")
  content((0, 0), $P_0$, anchor: "north-east")
  content("left-v.end", $arrow(xi)$, anchor: "north")
  content("right-0.end", $f(gamma_1)$, anchor: "south-east")
  content("right-1.end", cutout($f(gamma_2)$), anchor: "west")
  content("right-2.end", $f(gamma_3)$, anchor: "south-east")
  content((apart, 0), $Q_0$, anchor: "north-east")
  content(
    (apart, 0),
    $eta class("normal", =) d f_(P_0)(arrow(xi))$,
    anchor: "north-west",
  )
  arrowed((1.114 * unit, 0.735 * unit), (2.157 * unit, 0.735 * unit), name: "f")
  content("f.mid", $f$, anchor: "south")
})

// Figure 18: the differential of y = f(x): the graph (bold), its tangent
// at (x, f(x)), the increment Δx = dx, the increment dy along the tangent
// (bold) and Δy along the graph (the brace). The graph is the exponential
// f(x + u) = f(x) + f′(x) (e^(k u) − 1) / k with the printed value and
// slope at the point x and the printed bend.
#let fig-3-18() = slim-drawing({
  import cetz.draw: *
  let (x0, y0, slope, bend, step) = (8.42, 20.15, 0.84, 0.0402, 12.40)
  let graph(u) = y0 + slope * (calc.exp(bend * (u - x0)) - 1) / bend
  let tangent(u) = y0 + slope * (u - x0)
  let x1 = x0 + step
  arrowed((-15.15, 0), (30.14, 0), name: "x")
  arrowed((0, -6.0), (0, 39.9), name: "y")
  line(..sample(u => (u, graph(u)), -14.73, 24.64), stroke: thick-line)
  line((x0 - y0 / slope, 0), (25.7, tangent(25.7)))
  line((0, y0), (x0, y0), ..hidden)
  line((x0, 0), (x0, y0), (x1, y0), name: "dx")
  line((x1, 0), (x1, y0), ..hidden)
  line((x1, y0), (x1, tangent(x1)), stroke: thick-line, name: "dy")
  line((x1, tangent(x1)), (x1, graph(x1)))
  for p in ((x0, y0), (x1, y0), (x1, tangent(x1))) { spot(p) }
  cetz.decorations.flat-brace(
    (x1 + 1.5, graph(x1)),
    (x1 + 1.5, y0),
    amplitude: 1.2,
    content-offset: 0.6,
    name: "brace",
  )
  content("brace.content", $Delta y$, anchor: "west")
  content("dy.mid", $d y$, anchor: "east")
  content((x0, y0), $Delta x class("normal", =) d x$, anchor: "north-west")
  content((x0, 0), $x$, anchor: "north")
  content((x1, 0), $x class("normal", +) Delta x$, anchor: "north")
  content("x.end", $x$, anchor: "north-east")
  content("y.end", $y$, anchor: "north-west")
})

// Figure 19: the height f = z on the sphere S² resting on the plane
// (x, y). At the top P₀ the tangent plane T_P₀(S²) is horizontal and
// df_P₀ = 0; at P₁ on the parallel of latitude 40° the vector up the
// meridian rises by df_P₁ (the arrow on the z-axis), the vector along the
// parallel not at all. The tangent planes are squares about their points
// along the vectors drawn; T_P₀ covers the contour of the sphere beneath
// it, as printed. Dashed: the hidden halves of the equator and of the
// parallel, the y-axis behind the sphere, the levels carried to the z-axis
// in their horizontal planes.
#let fig-3-19() = slim-drawing({
  import cetz.draw: *
  let view = orthographic(30deg, 19deg)
  let at = view.project
  let radius = 19.0
  let centre = (22.73, 13.12, radius)
  let on-sphere(lat, lon) = vec-add(centre, vec-scale(radius, (
    calc.cos(lat) * calc.cos(lon),
    calc.cos(lat) * calc.sin(lon),
    calc.sin(lat),
  )))
  let from-centre(p) = vec-add(p, vec-scale(-1, centre))
  // A point of the sphere faces the viewer; a point lies behind it.
  let seen-on-sphere(p) = facing(view, from-centre(p))
  let behind(p) = {
    let w = from-centre(p)
    let s = vec-dot(w, view.toward)
    s < 0 and vec-dot(w, w) - s * s < radius * radius
  }
  arrowed((0, 0), (0, 50.16), name: "z")
  arrowed((0, 0), at((52.05, 0, 0)), name: "x")
  seen-hidden(at, p => not behind(p), sample(t => (0, t, 0), 0, 99, n: 200))
  arrowed(at((0, 98, 0)), at((0, 100.7, 0)), name: "y")
  // P₀ at the top with its square and vectors along the azimuths
  // `turn` and `turn` + 90°; P₁ with its square and vectors along the
  // parallel and up the meridian.
  let top = vec-add(centre, (0, 0, radius))
  let turn = -20deg
  let flat = (
    (calc.cos(turn), calc.sin(turn), 0),
    (-calc.sin(turn), calc.cos(turn), 0),
  )
  let (lat, lon) = (40deg, -94.5deg)
  let low = on-sphere(lat, lon)
  let tilted = (
    (-calc.sin(lon), calc.cos(lon), 0),
    (
      -calc.sin(lat) * calc.cos(lon),
      -calc.sin(lat) * calc.sin(lon),
      calc.cos(lat),
    ),
  )
  let square(p, (u, v), half) = ((1, 1), (1, -1), (-1, -1), (-1, 1)).map(
    ((a, b)) => at(vec-add(p, vec-scale(a * half, u), vec-scale(b * half, v))),
  )
  let cover = square(top, flat, 10.5)
  let patch = square(low, tilted, 7.0)
  // The contour of the sphere, dashed beneath the square at P₀.
  let (cx, cy) = at(centre)
  seen-hidden(
    q => q,
    q => not inside-convex(q, cover),
    sample(
      t => (cx + radius * calc.cos(t), cy + radius * calc.sin(t)),
      0deg,
      360deg,
      n: 360,
    ),
  )
  for latitude in (0deg, lat) {
    seen-hidden(at, seen-on-sphere, sample(
      t => on-sphere(latitude, t),
      -150deg,
      210deg,
      n: 180,
    ))
  }
  line(..cover, close: true)
  line(..patch, close: true)
  // The vectors at P₀ and P₁, the levels of the points on the z-axis.
  let rise = vec-add(low, vec-scale(5.3, tilted.at(1)))
  for (p, v) in (
    (top, vec-scale(10, flat.at(0))),
    (top, vec-scale(10, flat.at(1))),
    (low, vec-scale(8.2, tilted.at(0))),
    (low, vec-scale(5.3, tilted.at(1))),
  ) {
    arrowed(at(p), at(vec-add(p, v)), stroke: thick-line)
  }
  let bottom = vec-add(centre, (0, 0, -radius))
  let level(p) = at((0, 0, p.at(2)))
  for p in (top, low, rise, bottom) { line(at(p), level(p), ..hidden) }
  mark(level(low), level(rise), symbol: "stealth")
  for p in (top, low, bottom) { spot(at(p)) }
  spot(level(top))
  spot(at(centre), radius: 0.3)
  content("z.end", $z$, anchor: "north-east")
  content("x.end", $x$, anchor: "north-east")
  content("y.end", $y$, anchor: "north-west")
  content(at(top), $P_0$, anchor: "north")
  content(at(low), $P_1$, anchor: "north")
  content(level(top), $f(P_0)$, anchor: "east")
  content((level(low), 50%, level(rise)), $f(P_1)$, anchor: "east")
  let rightmost = cover.sorted(key: q => q.at(0)).last()
  content(rightmost, $T_(P_0)(S^2)$, anchor: "south")
  content(patch.at(1), $T_(P_1)(S^2)$, anchor: "north-east")
})

// Figure 20: the height function on an upright torus, the tube of radius
// `tube` about a stadium in the plane of the page (two half-circles of
// radius `bend` joined by uprights of length 2 `half`), seen from the
// front and a little above (`tilt`). Its contours are the curves parallel
// to the seen stadium at the distance `tube`. The four critical points
// (top, top and bottom of the hole, bottom) carry horizontal tangent
// squares; their levels go to the z-axis. The squares through the hole
// cut the tube in two ovals each (stippled); the parts of the squares
// behind the tube are dashed, and the top square covers the contour
// beneath it, as printed. The axes x, y stand in the page, as printed.
#let fig-3-20() = slim-drawing({
  import cetz.draw: *
  let tilt = 15deg
  let (sine, cosine) = (calc.sin(tilt), calc.cos(tilt))
  let (across, middle) = (26.14, 26.9)
  let (bend, tube, half) = (5.93, 3.92, 14.5)
  // A point (x across, y in depth, z up) about the centre of the torus.
  let at((x, y, z)) = (across + x, (middle + z) * cosine + y * sine)
  // The distance of a point from the stadium, and whether the line of
  // sight from it towards the viewer passes through the tube.
  let from-core((x, y, z)) = {
    let (u, w) = (calc.abs(x), calc.abs(z))
    let flat = if w <= half { calc.abs(u - bend) } else {
      calc.abs(calc.sqrt(u * u + (w - half) * (w - half)) - bend)
    }
    calc.sqrt(flat * flat + y * y)
  }
  let blocked((x, y, z)) = range(1, 121).any(k => {
    let t = 30 * k / 120
    from-core((x, y - t * cosine, z + t * sine)) < tube
  })
  // The seen stadium, its half-circles flattened by the tilt, and the
  // curves parallel to it at ± `tube`, by the angle φ along each
  // half-circle and the uprights between.
  let seen-core(phi) = {
    let (dx, dz) = (bend * calc.cos(phi), bend * calc.sin(phi))
    let top = calc.sin(phi) >= 0
    let lift = if top { half } else { -half }
    let (px, py) = at((dx, 0, lift + dz))
    let (nx, ny) = (cosine * calc.cos(phi), calc.sin(phi))
    let size = calc.sqrt(nx * nx + ny * ny)
    ((px, py), (nx / size, ny / size))
  }
  let parallel(offset) = range(0, 361, step: 2).map(k => {
    let ((px, py), (nx, ny)) = seen-core(k * 1deg)
    (px + offset * nx, py + offset * ny)
  })
  // The levels: the critical heights and the half-diagonals of their
  // squares.
  let top-hole = half + bend - tube
  let levels = (
    (half + bend + tube, 10.67),
    (top-hole, 16.4),
    (-top-hole, 16.4),
    (-half - bend - tube, 10.67),
  )
  let corners(z, d) = ((-d, 0, z), (0, d, z), (d, 0, z), (0, -d, z))
  let cover = corners(..levels.first()).map(at)
  let outer = parallel(tube)
  seen-hidden(
    q => q,
    q => not inside-convex(q, cover),
    outer + (outer.first(),),
  )
  line(..parallel(-tube), close: true)
  // The ovals cut out of the tube by the squares through the hole:
  // (√(x² + d²) − bend)² + y² = tube², d = bend − tube, each touching
  // the other at the critical point.
  let reach = 2 * calc.sqrt(bend * tube)
  for z in (top-hole, -top-hole) {
    for side in (-1, 1) {
      let depth(x) = {
        let r = calc.sqrt(x * x + (bend - tube) * (bend - tube)) - bend
        calc.sqrt(calc.max(tube * tube - r * r, 0))
      }
      let edge(sign) = sample(
        x => at((side * x, sign * depth(x), z)),
        0,
        reach,
        n: 60,
      )
      line(..edge(-1), ..edge(1).rev(), fill: stipple, stroke: none)
      line(..edge(-1))
      line(..edge(1), ..hidden)
    }
  }
  // The tangent squares, dashed behind the tube; the levels.
  for (z, d) in levels {
    let ends = corners(z, d) + (corners(z, d).first(),)
    for i in range(4) {
      seen-hidden(
        at,
        p => not blocked(p),
        sample(
          t => ends.at(i).zip(ends.at(i + 1)).map(((a, b)) => a + t * (b - a)),
          0,
          1,
          n: 60,
        ),
      )
    }
    let point = at((0, 0, z))
    line(point, (0, point.at(1)), ..hidden, mark: (
      end: "stealth",
      stroke: (dash: none),
    ))
    spot(point)
  }
  arrowed((0, 0), (0, 53.97), name: "z")
  arrowed((0, 0), (13.76, 4.44), name: "y")
  arrowed((0, 0), (9.74, -5.71), name: "x")
  content("z.end", $z$, anchor: "north-west")
  content("y.end", $y$, anchor: "south-east")
  content("x.end", $x$, anchor: "north-east")
})

// Figure 21: the immersion f(φ) = (cos φ, sin 2φ) of the circle, a figure
// of Lissajous, in units `wide` along x and `high` along y.
#let fig-3-21() = slim-drawing({
  import cetz.draw: *
  let (wide, high) = (9.19, 4.15)
  arrowed((-10.79, 0), (14.60, 0), name: "x")
  arrowed((0, -10.03), (0, 10.07), name: "y")
  line(
    ..sample(
      t => (wide * calc.cos(t), high * calc.sin(2 * t)),
      0deg,
      360deg,
      n: 240,
    ),
    close: true,
    stroke: thick-line,
  )
  content("x.end", $x$, anchor: "north-east")
  content("y.end", $y$, anchor: "north-east")
})
