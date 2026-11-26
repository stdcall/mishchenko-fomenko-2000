// Figures of chapter 1, § 3. Each is a function called by the text:
// `#fig(fig-1-18()) <fig:…>`.
#import "common.typ": *

// The central projection of space, z up, from a viewpoint `distance` from
// the origin, in front of it (towards −y) and raised by `elevation`; a unit
// length at the origin is `scale` mm. Besides the projection it gives the
// viewpoint.
#let central-view(distance, elevation, scale) = {
  let (ce, se) = (calc.cos(elevation), calc.sin(elevation))
  (
    project: ((x, y, z)) => {
      let k = scale * distance / (distance + y * ce - z * se)
      (k * x, k * (y * se + z * ce))
    },
    eye: (0, -distance * ce, distance * se),
  )
}

// Figure 18: the stereographic projection of the unit sphere from its north
// pole N onto the plane ℝ²(x, y) through its centre O: the point P goes to
// the point Q where the ray NP meets the plane; Q = `q` · (cos `turn`,
// sin `turn`), P computed from it. Central projection; the plane is a plate
// of thickness `plate` over the rectangle [x0, x1] × [y0, y1]. The
// equatorial disc is stippled, its near rim bold; the lines hidden by the
// sphere or the plate dashed, the chord NP dotted.
#let fig-1-18() = drawing({
  import cetz.draw: *
  set-style(stroke: (thickness: 1.5 * thin-line))
  let (radius, distance, elevation) = (11.85, 12, 30deg)
  let view = central-view(distance, elevation, radius)
  let at = view.project
  // A point of the sphere faces the viewpoint, a point of space projects
  // inside the outline of the sphere.
  let facing-eye(p) = vec-dot(p, view.eye) > 1
  let outline = radius * distance / calc.sqrt(distance * distance - 1)
  let inside(p) = calc.norm(..at(p)) < outline
  let (q, turn, plate) = (1.85, -20deg, 0.11)
  let ((x0, x1), (y0, y1)) = ((-1.55, 2.1), (-2.1, 1.22))
  let q-point = (q * calc.cos(turn), q * calc.sin(turn), 0)
  let p-point = (
    2 * q-point.at(0) / (q * q + 1),
    2 * q-point.at(1) / (q * q + 1),
    (q * q - 1) / (q * q + 1),
  )
  assert(calc.abs(vec-dot(p-point, p-point) - 1) < 1e-9)
  let equator(s) = (calc.cos(s), calc.sin(s), 0)
  // The plate: its front face black, its far edge hidden behind the sphere.
  line(
    at((x0, y0, 0)),
    at((x1, y0, 0)),
    at((x1, y0, -plate)),
    at((x0, y0, -plate)),
    close: true,
    fill: black,
  )
  line(at((x0, y0, 0)), at((x0, y1, 0)))
  line(at((x1, y0, 0)), at((x1, y1, 0)))
  seen-hidden(
    at,
    p => not inside(p),
    sample(
      s => (s, y1, 0),
      x0,
      x1,
      n: 400,
    ),
  )
  // The sphere: the disc, the rim, the outline, above the plate solid.
  line(..sample(s => at(equator(s)), 0deg, 360deg), fill: stipple, stroke: none)
  let near = sample(equator, 180deg, 360deg).filter(facing-eye)
  seen-hidden(at, facing-eye, sample(equator, 0deg, 360deg, n: 400))
  brush-stroke(near.map(at), u => 0.45 + calc.sin(u * 180deg))
  let silhouette(s) = {
    let (ce, se) = (calc.cos(elevation), calc.sin(elevation))
    let rho = calc.sqrt(1 - 1 / (distance * distance))
    (
      rho * calc.cos(s),
      -ce / distance + rho * calc.sin(s) * se,
      se / distance + rho * calc.sin(s) * ce,
    )
  }
  seen-hidden(at, p => p.at(2) > 0, sample(silhouette, 0deg, 360deg, n: 400))
  // The chord NP inside the ball, the ray from P to Q over the outline.
  line(at((0, 0, 1)), at(p-point), stroke: (
    thickness: thick-line,
    dash: "dotted",
  ))
  bridge((at(p-point), at(q-point)))
  mark(
    (at(p-point), 86%, at(q-point)),
    (at(p-point), 87%, at(q-point)),
    symbol: "stealth",
  )
  for point in ((0, 0, 1), (0, 0, 0), (0, 0, -1), q-point) {
    spot(at(point), radius: 0.85)
  }
  spot(at(p-point), radius: 0.7)
  content(at((0, 0, 1)), $N$, anchor: "north-east", padding: 0.9)
  content(at(p-point), cutout($P$), anchor: "south-west", padding: 1.2)
  content(at((0, 0, 0)), $O$, anchor: "west", padding: 1.4)
  content(at((0, 0, -1)), $S$, anchor: "east", padding: 1.4)
  content(at(q-point), $Q$, anchor: "north", padding: 1.6)
  content(at((x1, y1, 0)), $RR^2 lr((x, y))$, anchor: "south", padding: 1.6)
})

// Figure 19: the stereographic projection in the plane through N, O, P: the
// circle of radius R, the line ℝ²(x, y) through its centre O, the point P at
// the angle θ from ON, the ray from N through P meeting the line at
// Q = (R ctg(θ/2), 0); T, the midpoint of NP, is the foot of the bisector OT
// of the angle θ.
#let fig-1-19() = drawing({
  import cetz.draw: *
  set-style(stroke: (thickness: thick-line, cap: "round", join: "round"))
  let (radius, polar) = (12.6, 52deg)
  let (o, n, s) = ((0, 0), (0, radius), (0, -radius))
  let p = (90deg - polar, radius)
  let t = (n, 50%, p)
  let q = (radius / calc.tan(polar / 2), 0)
  // N, P and Q lie on one line.
  let (px, py) = (radius * calc.sin(polar), radius * calc.cos(polar))
  assert(calc.abs(px * radius / (radius - py) - q.at(0)) < 1e-9)
  line((-radius - 4.1, 0), (q.at(0) + 5.4, 0))
  circle(o, radius: radius, stroke: 3 * thick-line)
  line(n, s)
  line(o, t)
  line(o, p)
  line(n, q)
  mark((p, 68%, q), (p, 69%, q), symbol: "stealth")
  cetz.angle.angle(o, p, n, fill: stipple, radius: 4.2, stroke: thin-line)
  for point in (n, s, p, q) { spot(point, radius: 1) }
  spot(o, radius: 0.8)
  spot(t, radius: 0.45)
  // N, T, P and S are named outside the circle, on their radii.
  let outside(angle) = (angle, radius + 3)
  content(outside(90deg), $N$)
  content(outside(90deg - polar / 2), $T$)
  content(outside(90deg - polar), $P$)
  content(outside(-90deg), $S$)
  content((90deg - polar / 4, 6.2), $theta$)
  content(o, $O$, anchor: "north-east", padding: 1.2)
  content(q, $Q$, anchor: "north", padding: 1.6)
  // The name of the line with a leader to it.
  let tag = (16.2, -6.6)
  bezier(tag, (17.4, -0.6), (16.2, -3), stroke: thin-line, mark: (
    end: "stealth",
    scale: 0.65,
  ))
  content(tag, $RR^2 lr((x, y))$, anchor: "north-west", padding: (
    left: -1.2,
    rest: 0.6,
  ))
})

// Figure 20: the circle of radius ρ about the south pole S of the sphere S²
// of radius R: the points at the spherical distance ρ = R · `cap` from S,
// the meridians from S to some of them (bold, the arc ρ to the point Q), and
// dashed inside the ball the axis from S to O through the centre of the
// circle, the radius of the circle and the radius R to Q. Orthographic view,
// the pole tilted towards the viewer by `elevation`, hidden arcs dashed.
#let fig-1-20() = drawing({
  import cetz.draw: *
  set-style(stroke: (thickness: 1.5 * thin-line))
  let (radius, cap, elevation) = (16.85, 56deg, 27deg)
  let view = orthographic(0deg, elevation)
  let at(p) = (view.project)(p.map(c => radius * c))
  let seen(p) = facing(view, p)
  let on-sphere(polar, turn) = (
    calc.sin(polar) * calc.cos(turn),
    calc.sin(polar) * calc.sin(turn),
    calc.cos(polar),
  )
  let (pole, centre, origin) = ((0, 0, 1), (0, 0, calc.cos(cap)), (0, 0, 0))
  let target = on-sphere(cap, -40deg)
  let dashed = (stroke: (thickness: 1.5 * thin-line, dash: hidden.stroke.dash))
  // The shading: arcs of small circles 3° and 9° past the terminator of a
  // light from `light` (in the picture frame right, up, towards the
  // viewer), each 10° long in polar angle, in 14 equal steps from -100° to
  // 8°.
  let light = (-0.75, 0.05, 0.66)
  let (lx, ly, lz) = light
  let across = calc.norm(lx, ly)
  // Unit vectors across the light: one in the picture, one towards the
  // viewer.
  let side = (ly / across, -lx / across, 0)
  let back = (-lz * lx / across, -lz * ly / across, across)
  for k in range(14) {
    let depth = if calc.even(k) { 3deg } else { 9deg }
    let start = -100deg + k * 98deg / 13
    let points = sample(
      s => range(3).map(i => (
        -calc.sin(depth) * light.at(i)
          + calc.cos(depth)
            * (calc.cos(s) * side.at(i) + calc.sin(s) * back.at(i))
      )),
      -90deg,
      270deg,
      n: 720,
    ).filter(((x, y, z)) => {
      let angle = calc.atan2(x, y)
      let angle = if angle < start { angle + 360deg } else { angle }
      z > 0 and angle < start + 10deg
    })
    if points.len() > 1 {
      line(
        ..points.map(((x, y, z)) => (radius * x, radius * y)),
        stroke: thick-line,
      )
    }
  }
  // The circle, the meridians, the outline.
  seen-hidden(at, seen, sample(t => on-sphere(cap, t), 0deg, 360deg))
  for turn in (-160deg, -125deg, 25deg, 70deg, 110deg) {
    seen-hidden(at, seen, sample(t => on-sphere(t, turn), 0deg, cap, n: 60))
  }
  circle((0, 0), radius: radius)
  line(..sample(t => at(on-sphere(t, -40deg)), 0deg, cap), stroke: (
    thickness: 3 * thick-line,
  ))
  line(at(pole), at(origin), at(target), ..dashed)
  line(at(centre), at(target), ..dashed)
  for point in (pole, centre, origin, target) { spot(at(point), radius: 0.9) }
  content(at(pole), cutout($S$), anchor: "north-east", padding: 0.7)
  content(
    at(on-sphere(cap / 2, -40deg)),
    $rho$,
    anchor: "west",
    padding: 1.2,
  )
  content(
    (at(origin), 50%, at(target)),
    $R$,
    anchor: "north-west",
    padding: 0.8,
  )
  content(at(origin), $O$, anchor: "north-east", padding: 1)
  content((-45deg, radius), $S^2$, anchor: "north-west", padding: 0.8)
})

// Figure 21: the sphere in the spherical coordinates (θ, φ) as the disc
// θ ≤ π of the plane, θ the distance from the centre N = 0: the circle of
// radius θ about N, and the boundary circle θ = π, all of whose points are
// the south pole S. The letters S stand at `names` equal steps around the
// boundary, π in the place of one of them, at the end of the radius.
#let fig-1-21() = drawing({
  import cetz.draw: *
  let (boundary, inner, names) = (14.7, 0.6 * 14.7, 14)
  let step = 360deg / names
  let turn = 90deg - 2 * step
  let sparse = tiling(size: (0.75mm, 0.75mm), place(
    dx: 0.27mm,
    dy: 0.27mm,
    std.circle(radius: 0.1mm, fill: black),
  ))
  let ring = 1.5 * thin-line
  circle((0, 0), radius: boundary, fill: sparse, stroke: ring)
  circle((0, 0), radius: inner, fill: stipple, stroke: ring)
  line((0, 0), (turn, boundary), stroke: thick-line)
  for point in ((0, 0), (turn, inner), (turn, boundary)) {
    spot(point, radius: 0.9)
  }
  for k in range(names) {
    let angle = 90deg - k * step
    content((angle, boundary + 2.1), if k == 2 { $pi$ } else { $S$ })
  }
  content((turn, inner), cutout($theta$), anchor: "south", padding: 2.1)
  content((0, -3.9), cutout($N = 0$))
})

// Figure 22: the stereographic projection φ₀ from the north pole of the
// unit sphere S² preserves angles. The curves q₁, q₂ of the plane through
// the point q = φ₀(P) are circles, given by their directions `beta` and
// curvatures `bend` at q; on the sphere their preimages γ₁, γ₂ cross at P
// at the same angle. Both pairs are brush strokes thinning to the crossing,
// with their tangent vectors and the angle between them. The sphere:
// orthographic, the pole tilted towards the viewer by 25°, P at the point
// `seen-at` of the picture, the light from the lower right; the plane: a
// central view of the rectangle [x0, x1] × [y0, y1] about q, turned by
// `azimuth`.
#let fig-1-22() = drawing({
  import cetz.draw: *
  set-style(stroke: (thickness: 1.5 * thin-line))
  let radius = 14.7
  let (beta, bend) = ((-45.6deg, 6.9deg), (-0.05, 0.4))
  // How far the curves run from the crossing, backwards and forwards, and
  // the drawn lengths of the tangent vectors on the sphere.
  let spans = ((-1, 1.2), (-1.6, 1.3))
  let arrows = (8, 15)
  // The picture frame of the sphere: right, up, towards the viewer.
  let (ce, se) = (calc.cos(25deg), calc.sin(25deg))
  let frame = ((1, 0, 0), (0, se, ce), (0, -ce, se))
  let seen-at = (0.49, 0.36)
  let depth = calc.sqrt(
    1
      - calc.pow(seen-at.at(0), 2)
      - calc.pow(
        seen-at.at(1),
        2,
      ),
  )
  let p = range(3).map(i => (
    seen-at.at(0) * frame.at(0).at(i)
      + seen-at.at(1) * frame.at(1).at(i)
      + depth * frame.at(2).at(i)
  ))
  let picture(w) = (
    radius * vec-dot(w, frame.at(0)),
    radius * vec-dot(w, frame.at(1)),
  )
  let projected((x, y, z)) = (x / (1 - z), y / (1 - z))
  let lifted((u, v)) = {
    let n = u * u + v * v
    (2 * u / (n + 1), 2 * v / (n + 1), (n - 1) / (n + 1))
  }
  let q = projected(p)
  let circle-through(i) = s => {
    let (b, k) = (beta.at(i), bend.at(i))
    let (along, across) = (calc.sin(k * s) / k, (1 - calc.cos(k * s)) / k)
    (
      q.at(0) + along * calc.cos(b) - across * calc.sin(b),
      q.at(1) + along * calc.sin(b) + across * calc.cos(b),
    )
  }
  // The tangent vectors of the preimages at P, and the same angle.
  let tangent(i) = {
    let h = 1e-5
    let (a, b) = (lifted(circle-through(i)(h)), lifted(circle-through(i)(-h)))
    let w = a.zip(b).map(((x, y)) => x - y)
    w.map(c => c / calc.norm(..w))
  }
  let (w1, w2) = (tangent(0), tangent(1))
  assert(
    calc.abs(calc.acos(vec-dot(w1, w2)).deg() - (beta.at(1) - beta.at(0)).deg())
      < 1e-3,
  )
  let brush(points) = brush-stroke(points, u => 0.12 + 1.1 * u)
  // The sphere. The shading: the parallels p · axis = h, h from -0.35 to
  // 0.85, where the sphere is in the shadow of a light from `light`, both
  // in the picture frame (right, up, towards the viewer); the axis is tilted
  // away from the viewer, so that the parallels bow upwards.
  let unit(v) = v.map(c => c / calc.norm(..v))
  let (axis, light) = (
    unit((-0.08, 0.906, -0.423)),
    unit((0.737, -0.337, 0.586)),
  )
  let across = unit((axis.at(1), -axis.at(0), 0))
  let rise = (
    axis.at(1) * across.at(2) - axis.at(2) * across.at(1),
    axis.at(2) * across.at(0) - axis.at(0) * across.at(2),
    axis.at(0) * across.at(1) - axis.at(1) * across.at(0),
  )
  let rise = if rise.at(2) < 0 { rise.map(c => -c) } else { rise }
  for k in range(12) {
    let h = -0.35 + 1.2 * k / 11
    let r = calc.sqrt(1 - h * h)
    let shaded = sample(
      s => range(3).map(i => (
        h * axis.at(i)
          + r * (calc.cos(s) * across.at(i) + calc.sin(s) * rise.at(i))
      )),
      -90deg,
      270deg,
      n: 720,
    ).map(p => if p.at(2) > 0.15 and vec-dot(p, light) < 0 { p } else { none })
    // The runs of shaded points.
    let runs = shaded.split(none).filter(run => run.len() > 1)
    for run in runs {
      line(..run.map(((x, y, z)) => (radius * x, radius * y)))
    }
  }
  circle((0, 0), radius: radius)
  let tips = range(2).map(i => {
    let (x, y) = picture((w1, w2).at(i))
    let n = calc.norm(x, y)
    (rel: (arrows.at(i) * x / n, arrows.at(i) * y / n), to: picture(p))
  })
  cetz.angle.angle(picture(p), tips.at(1), tips.at(0), fill: stipple, radius: 4)
  for i in range(2) {
    for end in spans.at(i) {
      brush(sample(s => picture(lifted(circle-through(i)(s))), 0, end, n: 60))
    }
  }
  arrowed(picture(p), tips.at(0), name: "gamma-1")
  arrowed(picture(p), tips.at(1), name: "gamma-2")
  spot(picture(p), radius: 0.85)
  content(
    "gamma-1.end",
    cutout($dot(gamma)_1$),
    anchor: "north-east",
    padding: 0.5,
  )
  content("gamma-2.end", $dot(gamma)_2$, anchor: "west", padding: 0.8)
  content((128deg, radius + 3.5), $d s^2$)
  content((217deg, radius), $S^2$, anchor: "north-east", padding: 0.6)
  arrowed((14.4, -4.3), (18.9, -6.8), name: "map")
  content("map.mid", $phi_0$, anchor: "north", padding: 1.6)
  // The plane.
  group({
    translate((30.8, -10.75))
    let view = central-view(2.82, 45deg, 6.4)
    let azimuth = 10deg
    let ((x0, x1), (y0, y1), plate) = ((-1.7, 2.4), (-1.29, 2.23), 0.06)
    let local((u, v)) = {
      let (du, dv) = (u - q.at(0), v - q.at(1))
      (
        du * calc.cos(azimuth) - dv * calc.sin(azimuth),
        du * calc.sin(azimuth) + dv * calc.cos(azimuth),
      )
    }
    let at((x, y), z: 0) = (view.project)((x, y, z))
    let on-plane(c) = at(local(c))
    let band(from, to, fill) = line(
      at((x0, from)),
      at((x1, from)),
      at((x1, to)),
      at((x0, to)),
      close: true,
      fill: fill,
      stroke: none,
    )
    band(0.35, y1, stipple)
    band(0.05, 0.35, tiling(size: (0.8mm, 0.8mm), place(
      dx: 0.3mm,
      dy: 0.3mm,
      std.circle(radius: 0.1mm, fill: black),
    )))
    line(
      at((x0, y0)),
      at((x1, y0)),
      at((x1, y0), z: -plate),
      at((x0, y0), z: -plate),
      close: true,
      fill: black,
    )
    line(at((x0, y0)), at((x0, y1)), at((x1, y1)), at((x1, y0)))
    let ends = range(2).map(i => {
      let (b, a) = (beta.at(i), azimuth)
      at((1.45 * calc.cos(b + a), 1.45 * calc.sin(b + a)))
    })
    cetz.angle.angle(
      at((0, 0)),
      ends.at(0),
      ends.at(1),
      fill: stipple,
      radius: 3.6,
    )
    for i in range(2) {
      for end in spans.at(i) {
        brush(sample(s => on-plane(circle-through(i)(s)), 0, end, n: 60))
      }
    }
    arrowed(at((0, 0)), ends.at(0), name: "q-1")
    arrowed(at((0, 0)), ends.at(1), name: "q-2")
    spot(at((0, 0)), radius: 0.85)
    content("q-1.end", $dot(q)_1$, anchor: "west", padding: 0.6)
    content("q-2.end", cutout($dot(q)_2$), anchor: "south", padding: 1.6)
    content(at((x1, y1)), $d l^2$, anchor: "north-west", padding: (
      left: 3.2,
      top: 0.5,
    ))
  })
})
