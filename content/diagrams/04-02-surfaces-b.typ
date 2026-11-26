// Figures of chapter 4, § 2, Рис. 28–49 (the rest of the section's figures;
// the section's file imports this one).
#import "common.typ": *

// The bold curves of the figures that stress a profile or a contour.
#let heavy-line = 3.6pt

// Figure 28: the generatrix of the Beltrami funnel, the tractrix
// x = a(t − th t), y = a / ch t, from its cusp A₀ = (0, a) on the axis Oy
// towards A, continued past A₀ by its mirror image in the line y = a, the
// arc A₀C, convex upwards.
#let fig-4-28() = lettered-drawing({
  import cetz.draw: *
  let a = 17.2
  // Where the arcs end: the abscissa of A and the ordinate of C.
  let (x-end, y-end) = (44.5, 27)
  let profile(t) = {
    let s = calc.abs(t)
    let y = a / calc.cosh(s)
    (a * (s - calc.tanh(s)), if t < 0 { 2 * a - y } else { y })
  }
  // The parameters of the ends: t − th t = x/a by Newton's method for A;
  // ch t = a / (2a − y) for C.
  let t-end = range(8).fold(3.0, (t, _) => {
    t - (t - calc.tanh(t) - x-end / a) / calc.pow(calc.tanh(t), 2)
  })
  let u = a / (2 * a - y-end)
  let t-start = -calc.acosh(u)
  arrowed((-2.3, 0), (49.6, 0), name: "x")
  arrowed((0, -6), (0, 27.6), name: "y")
  line(
    ..sample(profile, t-start, t-end, n: 300),
    stroke: (thickness: heavy-line, cap: "butt"),
  )
  spot((0, a), radius: 1)
  content("x.end", $x$, anchor: "north-east", padding: 1.6)
  content("y.end", $y$, anchor: "north-east", padding: 0.8)
  content((0, a), $A_0$, anchor: "east", padding: 1.6)
  content(profile(t-start), $C$, anchor: "west")
  content(profile(t-end), $A$, anchor: "south-east", padding: 1.8)
})

// The Beltrami funnel of radius a about the axis x: the surface of
// revolution of the tractrix x = a(t − th t), r = a / ch t, its point
// (x, r cos φ, r sin φ). The coordinates u = φ, v = a / r = ch t make its
// metric that of the Lobachevsky plane, (du² + dv²) / v².
#let funnel-point(a, t, turn) = {
  let r = a / calc.cosh(t)
  (a * (t - calc.tanh(t)), r * calc.cos(turn), r * calc.sin(turn))
}

// The parameter t where the tractrix is x = ratio · a: t − th t = ratio,
// by Newton's method.
#let funnel-parameter(ratio) = range(10).fold(calc.max(ratio + 1, 1.5), (
  t,
  _,
) => t - (t - calc.tanh(t) - ratio) / calc.pow(calc.tanh(t), 2))

// The Beltrami funnel seen by `view` from the plane z = 0 on the side of
// the rim. The outer side faces the viewer (w₁, w₂, 0) where its normal
// (1, sh t cos φ, sh t sin φ) does, cos φ < −w₁ / (w₂ sh t): between the
// outline φ = s(t) and 2π − s(t). On it, the net of the coordinate lines
// u = φ, v = a / r at the step 2π / `lines`, square cells; past
// v = `dense` the net thickens to black, up to the tip at x = `length`.
// With `cut` > 0° the funnel is cut along the meridian φ = π, which faces
// the viewer, and opened by the angle 2 · cut, the edges of the cut bold.
// The open rim is filled with `rim`.
#let funnel-net(
  view,
  a,
  length,
  lines,
  dense,
  cut: 0deg,
  rim: black,
  mesh: thick-line,
  edge: 1.6pt,
) = {
  import cetz.draw: *
  let (at, toward) = (view.project, view.toward)
  let cut = cut.rad()
  let ratio = -toward.at(0) / toward.at(1)
  let t-tip = funnel-parameter(length / a)
  let t-dense = calc.acosh(dense)
  let t-seen = calc.asinh(calc.abs(ratio))
  let outline(t) = calc.acos(calc.max(-1, ratio / calc.sinh(t))).rad()
  let sides = if cut > 0 {
    (
      (outline, t => calc.pi - cut),
      (
        t => calc.pi + cut,
        t => (
          2 * calc.pi - outline(t)
        ),
      ),
    )
  } else { ((outline, t => 2 * calc.pi - outline(t)),) }
  let along(turn, from, to) = sample(
    t => at(funnel-point(a, t, turn(t))),
    from,
    to,
    n: 120,
  )
  line(
    ..sample(s => at(funnel-point(a, 0, s)), 0, 2 * calc.pi, n: 90),
    close: true,
    fill: rim,
    stroke: edge,
  )
  for (from, to) in sides {
    line(
      ..along(from, t-dense, t-tip),
      ..along(to, t-dense, t-tip).rev(),
      close: true,
      fill: black,
      stroke: mesh,
    )
  }
  set-style(stroke: (thickness: mesh))
  let step = 2 * calc.pi / lines
  for k in range(1, int((dense - 1) / step) + 1) {
    let t = calc.acosh(1 + k * step)
    for (from, to) in sides.filter(((from, to)) => from(t) < to(t)) {
      line(..sample(s => at(funnel-point(a, t, s)), from(t), to(t), n: 40))
    }
  }
  let turns = range(lines + 1).map(j => (
    calc.pi + cut + j * (2 * calc.pi - 2 * cut) / lines
  ))
  for turn in turns.filter(s => calc.cos(s) < -1e-6) {
    let from = calc.max(t-seen, calc.asinh(ratio / calc.cos(turn)))
    let (to, style) = if (
      cut > 0 and turn in turns.slice(0, 1) + turns.slice(-1)
    ) {
      (t-tip, (stroke: edge))
    } else { (t-dense, (:)) }
    line(..along(t => turn, from, to), ..style)
  }
  line(..along(outline, t-seen, t-tip))
  line(..along(t => 2 * calc.pi - outline(t), t-seen, t-tip))
}

// Figure 29: were the Beltrami funnel isometric to a domain of the
// Lobachevsky plane, its point at infinity would go to a finite point p of
// the Poincaré disc (the boundary, the absolute, ringed by ∞): its rim to
// the circle about p, its meridians and parallels to the lines through p
// and the circles about p, the images of the rays and circles about 0
// under the motion z ↦ (z + p) / (1 + p z) of the unit disc.
#let fig-4-29() = lettered-drawing({
  import cetz.draw: *
  let radius = 14.4
  // The rim's image, its Euclidean centre and radius on the unit disc.
  let (centre, size) = (0.3125, 0.524)
  let (near, far) = (centre - size, centre + size)
  // Its hyperbolic centre p and the radius of its preimage about 0.
  let p = calc.tanh((calc.atanh(near) + calc.atanh(far)) / 2)
  let rim = calc.tanh((calc.atanh(far) - calc.atanh(near)) / 2)
  let motion((x, y)) = {
    let (re, im) = (x + p, y)
    let (c, d) = (1 + p * x, p * y)
    let den = c * c + d * d
    (radius * (re * c + im * d) / den, radius * (im * c - re * d) / den)
  }
  let polar(r, s) = motion((r * calc.cos(s), r * calc.sin(s)))
  let (rings, rays) = (8, 20)
  let bold = 2.3pt
  circle((0, 0), radius: radius, fill: stipple, stroke: none)
  line(
    ..sample(s => polar(rim, s), 0, 2 * calc.pi, n: 120),
    close: true,
    fill: white,
    stroke: none,
  )
  group({
    set-style(stroke: (thickness: thick-line))
    for k in range(1, rings) {
      line(..sample(s => polar(rim * k / rings, s), 0, 2 * calc.pi, n: 90))
    }
    for j in range(rays) {
      let s = j * 2 * calc.pi / rays
      line(..sample(r => polar(r, s), 0, rim, n: 30))
    }
  })
  line(
    ..sample(s => polar(rim, s), 0, 2 * calc.pi, n: 120),
    close: true,
    stroke: bold,
  )
  circle((0, 0), radius: radius, stroke: bold)
  let marks = 32
  for j in range(marks) {
    let s = j * 360deg / marks
    content(
      (s, radius + 0.4),
      text(size: 7pt, $oo$),
      anchor: s + 180deg,
      padding: 0.6,
    )
  }
  // The funnel, its axis level with the centre of the disc.
  group({
    translate((-68.4, 0))
    funnel-net(orthographic(-13deg, 0deg), 9.7, 50.6, 20, 12)
  })
  arrowed(
    (-25.7, 4.7),
    (-20.6, 4.7),
    mark: (end: "stealth", length: 2mm, width: 1mm),
    name: "f",
  )
  content("f.mid", $f$, anchor: "south")
  content((-20.8, 0.3), text(size: 7pt, $oo$), anchor: "south")
})

// The Poincaré model: the Cayley map w = (z − i) / (z + i) of the upper
// half-plane z = u + iv onto the unit disc, turned so that ∞ goes to the
// point of the boundary at the angle `infinity`. The lines u = const go to
// the lines of the Lobachevsky plane through ∞, arcs at right angles to the
// boundary; the lines v = const to the horocycles at ∞, circles touching
// the boundary there.
#let half-plane-to-disc(u, v, infinity: 0deg) = {
  let d = u * u + calc.pow(v + 1, 2)
  let (x, y) = ((u * u + v * v - 1) / d, -2 * u / d)
  let (c, s) = (calc.cos(infinity), calc.sin(infinity))
  (x * c - y * s, x * s + y * c)
}

// Figure 30: the Beltrami funnel (a = 1) cut along a meridian A₀B₀ is
// isometric to the strip (∞, A₀, B₀) of the Lobachevsky plane: in the
// half-plane the strip |u| ≤ π, v ≥ 1 of the coordinates u = φ, v = 1 / r,
// whose net it carries. Left, the cut funnel, opened a little; right, the
// strip in the Poincaré disc of radius `radius`, ∞ to the right, moved
// towards ∞ by the motion z ↦ h z of the half-plane.
#let fig-4-30() = lettered-drawing({
  import cetz.draw: *
  let lines = 16
  let step = 2 * calc.pi / lines
  let edge = 1.6pt
  group({
    translate((-5.65, 2.5))
    let view = orthographic(-16.5deg, 0deg)
    let (a, cut) = (12, 9.4deg)
    funnel-net(view, a, 45.2, lines, 9, cut: cut, rim: white, edge: edge)
    for (side, name) in ((1, $A_0$), (-1, $B_0$)) {
      let p = (view.project)(funnel-point(a, 0, 180deg - side * cut))
      spot(p, radius: 1)
      content(p, name, anchor: "east", padding: 1.6)
    }
  })
  content((36.9, -3.2), text(size: 14pt, $tilde.equiv$))
  // The strip: the disc's centre, its radius and the motion's h.
  group({
    translate((73.1, 2.5))
    let (radius, h, dense, tip) = (33, 0.0732, 9, 87 - 73.1)
    let at(u, v) = half-plane-to-disc(h * u, h * v).map(c => radius * c)
    // The parameter v where the line u = π reaches the tip, X = q on the
    // unit disc: (1 − q)V² − 2qV + (1 − q)U² − 1 − q = 0 for U + iV = h z.
    let (q, uu) = (tip / radius, calc.pow(h * calc.pi, 2))
    let v-tip = (
      (q + calc.sqrt(q * q - (1 - q) * ((1 - q) * uu - 1 - q))) / (1 - q) / h
    )
    line(
      ..sample(v => at(-calc.pi, v), dense, v-tip, n: 40),
      ..sample(v => at(calc.pi, v), dense, v-tip, n: 40).rev(),
      close: true,
      fill: black,
      stroke: thick-line,
    )
    set-style(stroke: (thickness: thick-line))
    for k in range(1, int((dense - 1) / step) + 1) {
      line(..sample(u => at(u, 1 + k * step), -calc.pi, calc.pi, n: 40))
    }
    for j in range(1, lines) {
      line(..sample(v => at(-calc.pi + j * step, v), 1, dense, n: 60))
    }
    for u in (-calc.pi, calc.pi) {
      line(..sample(v => at(u, v), 1, v-tip, n: 80), stroke: edge)
    }
    line(..sample(u => at(u, 1), -calc.pi, calc.pi, n: 60), stroke: 2.6pt)
    spot(at(-calc.pi, 1), radius: 1)
    spot(at(calc.pi, 1), radius: 1)
    content(at(-calc.pi, 1), $A_0$, anchor: "south", padding: 1.6)
    content(at(calc.pi, 1), $B_0$, anchor: "north", padding: 1.6)
  })
})
// The line u = const of the half-plane from v = `from` to ∞, sampled
// evenly in ln v, in the Poincaré disc of radius `radius` with ∞ at the top.
#let line-to-infinity(radius, u, from) = sample(
  s => half-plane-to-disc(u, from * calc.exp(s), infinity: 90deg).map(c => (
    radius * c
  )),
  0,
  9,
  n: 120,
)

// Figure 31: the strip (∞, A₀, B₀) of the Lobachevsky plane in the
// Poincaré disc, the half-plane's |u| ≤ w, v ≥ h with ∞ at the top: between
// the two lines through ∞ and A₀, B₀ (bold), continued to the boundary
// (thin), and the arc A₀B₀ of the horocycle v = h at ∞ (a circle touching
// the boundary there).
#let fig-4-31() = lettered-drawing({
  import cetz.draw: *
  let radius = 16.8
  // The horocycle has the radius R / (1 + h); the strip's half-width w.
  let h = radius / 11.5 - 1
  let w = 0.52
  let at(u, v) = half-plane-to-disc(u, v, infinity: 90deg).map(c => (
    radius * c
  ))
  let arc = sample(u => at(u, h), -w, w, n: 40)
  line(
    ..line-to-infinity(radius, w, h),
    ..line-to-infinity(radius, -w, h).rev(),
    ..arc,
    close: true,
    fill: stipple,
    stroke: none,
  )
  circle((0, 0), radius: radius, stroke: 1.8pt)
  circle((0, radius * h / (1 + h)), radius: radius / (1 + h), stroke: 1.6pt)
  for u in (-w, w) {
    line(..sample(v => at(u, v), 0, h, n: 20), stroke: thick-line)
    line(..line-to-infinity(radius, u, h), stroke: 2.3pt)
    spot(at(u, 0), radius: 1)
  }
  line(..arc, stroke: 3.4pt)
  spot((0, radius), radius: 1.2)
  content((0, radius), $oo$, anchor: "south", padding: 1.8)
  spot(at(-w, h), radius: 1.3)
  spot(at(w, h), radius: 1.3)
  content(at(-w, h), $A_0$, anchor: "north", padding: 2)
  content(at(w, h), $B_0$, anchor: "north", padding: 2)
})
// Figure 32. Left, an orthogonal net of the Poincaré disc of radius R, ∞ at
// the top: the lines through ∞ ending on the boundary at equal angles, and
// the horocycles at ∞, of radii R qᵏ; the strip (∞, A₀, B₀) between two
// lines of the net and a horocycle, stippled. In the half-plane the end at
// the angle θ from the bottom is u = tg(θ/2), the horocycle of radius ρ is
// v = R/ρ − 1. Right, the level lines Re 1/z = cos φ / r = C₁ and
// Im 1/z = −sin φ / r = C₂, circles through 0 of diameters 1/|C|, at equal
// steps of the levels; drawn within the four discs of the largest of them.
#let fig-4-32() = lettered-drawing({
  import cetz.draw: *
  let radius = 28.8
  let (angle-step, q, bold-ring, rings, black-ring) = (15deg, 0.915, 4, 20, 21)
  let at(u, v) = half-plane-to-disc(u, v, infinity: 90deg).map(c => (
    radius * c
  ))
  let horocycle(k) = (
    (0, radius * (1 - calc.pow(q, k))),
    radius * calc.pow(q, k),
  )
  let level(k) = 1 / calc.pow(q, k) - 1
  let end(j) = calc.tan(j * angle-step / 2)
  // A line through ∞ from v = `from` up, by v = tg s.
  let to-infinity(u, from) = sample(
    s => at(u, calc.tan(s)),
    calc.atan(from),
    89.6deg,
    n: 80,
  )
  let (u-a, v-a) = (end(-4), level(bold-ring))
  line(
    ..to-infinity(u-a, v-a),
    ..to-infinity(-u-a, v-a).rev(),
    ..sample(u => at(u, v-a), -u-a, u-a, n: 30),
    close: true,
    fill: stipple,
    stroke: none,
  )
  group({
    set-style(stroke: (thickness: thick-line))
    for k in range(1, rings + 1) {
      let (centre, size) = horocycle(k)
      circle(centre, radius: size)
    }
    for j in range(-11, 12) {
      line(..to-infinity(end(j), 0))
    }
  })
  let (centre, size) = horocycle(black-ring)
  circle(centre, radius: size, fill: black)
  circle((0, 0), radius: radius, stroke: 1.6pt)
  let (centre, size) = horocycle(bold-ring)
  circle(centre, radius: size, stroke: 2.3pt)
  for u in (u-a, -u-a) {
    line(..to-infinity(u, v-a), stroke: 2.3pt)
  }
  line(..to-infinity(0, 0), stroke: 2pt)
  line(..sample(u => at(u, v-a), u-a, -u-a, n: 30), stroke: 2.8pt)
  spot(at(u-a, v-a), radius: 0.9)
  spot(at(-u-a, v-a), radius: 0.9)
  content(at(u-a, v-a), cutout($A_0$), anchor: "north", padding: 2.2)
  content(at(-u-a, v-a), cutout($B_0$), anchor: "north", padding: 2.2)
  content((0, radius), $oo$, anchor: "south", padding: 1.4)
  // The level lines: diameters D₁ / k, the largest drawn whole D₁ / k₀,
  // their discs widened by `overshoot` for the crossing arcs.
  group({
    translate((48.1, 0))
    let (first, whole, last, overshoot) = (60, 4, 12, 1.6)
    let reach = first / whole / 2 + overshoot
    let centres = ((1, 0), (-1, 0), (0, 1), (0, -1)).map(((x, y)) => (
      (first / whole / 2) * x,
      (first / whole / 2) * y,
    ))
    let inside((x, y)) = centres.any(((cx, cy)) => (
      calc.pow(x - cx, 2) + calc.pow(y - cy, 2) < reach * reach
    ))
    set-style(stroke: (thickness: thick-line))
    for k in range(1, last + 1) {
      let r = first / k / 2
      for (x, y) in ((1, 0), (-1, 0), (0, 1), (0, -1)) {
        let circle-points = sample(
          s => (r * (x + calc.cos(s)), r * (y + calc.sin(s))),
          0deg,
          360deg,
          n: 360,
        )
        for run in runs-where(circle-points, inside) { line(..run) }
      }
    }
    line((-18.5, 0), (20.2, 0), stroke: 1.6pt)
    line((0, -29), (0, 30.6), stroke: 1.6pt)
  })
})
// Figure 33: the disc D² bounded by the horocycle v = h at ∞ (bold) cut
// into the strips (∞, A_k, A_{k−1}) and (∞, B_k, B_{k−1}): the strip
// (∞, A₀, B₀), |u| ≤ w (black), reflected in its sides u = ∓w, and so on;
// in the half-plane the reflection in u = c is u ↦ 2c − u, so
// A_k = (−(2k + 1) w, h) and B_k = ((2k + 1) w, h). The first two
// reflected strips are stippled, the arrows show the reflections. The lines
// through ∞ run on to the boundary.
#let fig-4-33() = lettered-drawing({
  import cetz.draw: *
  let radius = 36.2
  // The horocycle of radius 27.5 mm; the strip's half-width w.
  let h = radius / 27.5 - 1
  let w = 0.393
  let (strips, labelled, dotted) = (40, 4, 9)
  let at(u, v) = half-plane-to-disc(u, v, infinity: 90deg).map(c => (
    radius * c
  ))
  let side(k) = (2 * k + 1) * w
  let to-infinity(u, from) = sample(
    s => at(u, calc.tan(s)),
    calc.atan(from),
    89.7deg,
    n: 80,
  )
  let strip(u1, u2, ..style) = line(
    ..to-infinity(u1, h),
    ..to-infinity(u2, h).rev(),
    ..sample(u => at(u, h), u2, u1, n: 30),
    close: true,
    stroke: none,
    ..style,
  )
  strip(-side(1), -side(0), fill: stipple)
  strip(side(0), side(1), fill: stipple)
  strip(-side(0), side(0), fill: black)
  for k in range(strips) {
    for u in (-side(k), side(k)) {
      line(..sample(v => at(u, v), 0, h, n: 20), ..to-infinity(u, h), stroke: (
        thickness: thick-line,
      ))
    }
  }
  // The lines crowd to black at ∞, inside the horocycle v = 40 h.
  circle(
    (0, radius * 40 * h / (1 + 40 * h)),
    radius: radius / (1 + 40 * h),
    fill: black,
  )
  circle((0, radius * h / (1 + h)), radius: radius / (1 + h), stroke: 1.7pt)
  circle((0, 0), radius: radius, stroke: 2.3pt)
  // The reflections: an arrow of length 4 mm along the horocycle v = 2h
  // from each side u = ∓(2k + 1) w into the next strip; the map stretches
  // lengths at (u, v) by 2R / (u² + (v + 1)²).
  for k in range(labelled) {
    for sign in (-1, 1) {
      let c = sign * side(k)
      let length = 4 * (c * c + calc.pow(2 * h + 1, 2)) / (2 * radius)
      line(
        ..sample(u => at(u, 2 * h), c, c + sign * length),
        mark: (end: "stealth", length: 1.6mm, width: 1mm),
      )
    }
  }
  for k in range(1, dotted) {
    spot(at(-side(k), h), radius: 0.8)
    spot(at(side(k), h), radius: 0.8)
  }
  for (u, name) in ((-side(0), $A_0$), (side(0), $B_0$)) {
    circle(at(u, h), radius: 0.7, fill: white, stroke: 1pt)
    content(at(u, h), name, anchor: "north", padding: 1.6)
  }
  // The names stand inside D², in the strip (∞, A_k, A_{k−1}) under A_k.
  let centre = (0, radius * h / (1 + h))
  for k in range(1, labelled + 1) {
    for (sign, name) in ((-1, $A_#k$), (1, $B_#k$)) {
      let p = at(sign * side(k), h)
      let away = calc.atan2(p.at(0) - centre.at(0), p.at(1) - centre.at(1))
      content(p, cutout(name), anchor: away + sign * 30deg, padding: 1.2)
    }
  }
  content((0, radius), $oo$, anchor: "south", padding: 0.8)
  // The name D² of the disc, its arrow to the horocycle.
  let target = (rel: (15deg, radius / (1 + h)), to: centre)
  content((29.7, 32.4), $D^2$, anchor: "south")
  bezier(
    (29.9, 31.9),
    target,
    (30.6, 21),
    mark: (end: "stealth", length: 1.8mm, width: 1.1mm),
  )
})
// Figure 34: the disc D² wound round the Beltrami funnel infinitely many
// times, its strips laid on the funnel one over another. A drawing.
#let fig-4-34() = image(
  "/assets/figures/04-34-wound-funnel.svg",
  width: 51.14mm,
)
// Figure 35: a hypersurface Vⁿ⁻¹ ⊂ ℝⁿ (a bold arc through three points)
// and Ṽⁿ⁻¹, which differs from it only inside a small ball (dashed): there
// Vⁿ⁻¹ is pushed along its normal by a smooth bump vanishing with its
// derivatives at the ends, H (1 − cos 2π s^γ) / 2, s from 0 to 1 along the
// arc. Space is stippled, the ball white.
#let fig-4-35() = lettered-drawing({
  import cetz.draw: *
  let (centre, radius) = ((0.35, -0.8), 15)
  // The arc: its centre and radius through three points, and its points
  // by the angle about the centre.
  let (p1, p2, p3) = ((-23.6, -16.4), (8, 2), (27.2, -2.4))
  let (ax, ay) = p1
  let (bx, by) = p2
  let (cx, cy) = p3
  let d = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))
  let norm2(x, y) = x * x + y * y
  let o = (
    (
      norm2(ax, ay) * (by - cy)
        + norm2(bx, by) * (cy - ay)
        + norm2(cx, cy) * (ay - by)
    )
      / d,
    (
      norm2(ax, ay) * (cx - bx)
        + norm2(bx, by) * (ax - cx)
        + norm2(cx, cy) * (bx - ax)
    )
      / d,
  )
  let rho = calc.sqrt(norm2(ax - o.at(0), ay - o.at(1)))
  let angle((x, y)) = calc.atan2(x - o.at(0), y - o.at(1))
  let on-arc(t, lift: 0) = (
    o.at(0) + (rho + lift) * calc.cos(t),
    o.at(1) + (rho + lift) * calc.sin(t),
  )
  let (t1, t3) = (angle(p1), angle(p3))
  // The bump: from the angle `from` to `to`, its height and skew.
  let (from, to, height, skew) = (
    angle((-8, -1.5)),
    angle((12.6, 1.9)),
    8.6,
    0.89,
  )
  let band = heavy-line.mm()
  rect((-25.2, -17.6), (29.4, 17.6), fill: stipple, stroke: none)
  circle(centre, radius: radius, fill: white, stroke: none)
  content((23.3, -5.6), cutout($V^(n-1) subset RR^n$))
  let along(a, b, lift: 0) = sample(t => on-arc(t, lift: lift), a, b, n: 120)
  line(..along(t1, t3), stroke: (thickness: heavy-line, cap: "butt"))
  line(..along(from, to), stroke: (
    paint: white,
    thickness: heavy-line - 2 * thin-line,
    cap: "butt",
  ))
  line(
    ..sample(
      t => {
        let s = (t - from) / (to - from)
        on-arc(
          t,
          lift: band / 2
            + height * (1 - calc.cos(2 * calc.pi * calc.pow(s, skew))) / 2,
        )
      },
      from,
      to,
      n: 160,
    ),
    stroke: thick-line,
  )
  circle(centre, radius: radius, stroke: (
    thickness: 1.4pt,
    dash: (array: (3mm, 1.5mm)),
  ))
  content((-5.6, 9.6), $tilde(V)^(n-1)$)
})
// Figure 36: the right helicoid swept by the line l₂ through the axis l₁
// as it moves along l₁ and turns about it at constant speeds: the rulings
// (s cos φ, s sin φ, cφ), |s| ≤ L, for φ from the top ruling to the bottom
// one l₂, seen from slightly above.
#let fig-4-36() = lettered-drawing({
  import cetz.draw: *
  let view = orthographic(0deg, 10.5deg)
  let at = view.project
  // Half-length of the rulings; their angles and heights at the top and
  // at the bottom (l₂); the number of rulings.
  let reach = 53.5
  let (top, bottom) = ((-81deg, 28.1), (-112.5deg, -1.7))
  let count = 28
  let ruling(k) = {
    let t = k / count
    let turn = top.at(0) + t * (bottom.at(0) - top.at(0))
    let z = top.at(1) + t * (bottom.at(1) - top.at(1))
    let d = (calc.cos(turn), calc.sin(turn), 0)
    (
      at(d.map(c => -reach * c).zip((0, 0, z)).map(((p, q)) => p + q)),
      at((0, 0, z)),
      at(d.map(c => reach * c).zip((0, 0, z)).map(((p, q)) => p + q)),
    )
  }
  let rulings = range(count + 1).map(ruling)
  for (a, o, b) in rulings.slice(1, -1) {
    line(a, b, stroke: 1pt)
  }
  for side in (0, 2) {
    line(..rulings.map(r => r.at(side)), stroke: thick-line)
  }
  let (first, last) = (rulings.first(), rulings.last())
  line(first.at(0), first.at(2), stroke: 2.6pt)
  line(last.at(0), last.at(2), stroke: 1.8pt)
  // The axis l₁: dashed where it runs inside the swept surface.
  line(first.at(1), last.at(1), ..hidden)
  arrowed(first.at(1), (0, 41.5))
  line(last.at(1), (0, -12.5))
  for p in (first.at(1), rulings.at(int(count / 2)).at(1), last.at(1)) {
    spot(p, radius: 0.8)
  }
  for p in (first.at(0), first.at(2)) { spot(p, radius: 1.1) }
  for p in (last.at(0), last.at(2)) { spot(p, radius: 1.4) }
  content((0, 41.5), $l_1$, anchor: "north-west", padding: 1)
  content(last.at(0), $l_2$, anchor: "north", padding: 2)
})
// The catenary y = a ch(x/a) at the height y over its branch x ≥ 0.
#let catenary-abscissa(a, y) = (
  a * calc.ln(y / a + calc.sqrt(y * y / (a * a) - 1))
)

// The heavy chain of Figures 37 and 38: the catenary y = a ch(x/a), in mm
// of Figure 37, hung at A and B of the heights `low` and `high`, A to the
// left of the vertex, B to the right.
#let chain-ends = (a: 7, low: 14, high: 23)

// Figure 37: the catenary γ(t), y = a ch(x/a), the heavy chain hung at A
// and B (bold between them, dashed beyond), above the axis Ox.
#let fig-4-37() = lettered-drawing({
  import cetz.draw: *
  let (a, low: y-a, high: y-b) = chain-ends
  // The height of the ends of the dashed arcs.
  let y-end = 35
  let chain(x) = (x, a * calc.cosh(x / a))
  let (x-a, x-b) = (-catenary-abscissa(a, y-a), catenary-abscissa(a, y-b))
  let reach = catenary-abscissa(a, y-end)
  arrowed((-23.5, 0), (24.5, 0), name: "x")
  arrowed((0, -9.5), (0, 35.8), name: "y")
  let dashed = (stroke: (thickness: 1.4pt, dash: (array: (1.8mm, 0.8mm))))
  line(..sample(chain, -reach, x-a, n: 40), ..dashed)
  line(..sample(chain, x-b, reach, n: 40), ..dashed)
  line(..sample(chain, x-a, x-b, n: 120), stroke: heavy-line)
  spot(chain(x-a), radius: 1.2)
  spot(chain(x-b), radius: 1.2)
  spot((0, 0), radius: 0.8)
  content(chain(x-a), $A$, anchor: "south-west", padding: 1.2)
  content(chain(x-b), $B$, anchor: "south-east", padding: 1.2)
  content(chain(0.7 * x-b), $gamma lr((t))$, anchor: "north-west", padding: 1.4)
  content((0, 0), $O$, anchor: "north-east", padding: 1.4)
  content("x.end", $x$, anchor: "north-east", padding: 1.6)
  content("y.end", $y$, anchor: "north-west", padding: 0.8)
})
// Figure 38: the catenoid, the surface swept by the chain of Figure 37
// between A and B turning about the axis Ox: r = a ch(x/a), seen from the
// side of A, so that its rim through A opens black towards the viewer; the
// hidden half of the rim through B and the axis inside dashed. The outline
// runs where the normal (−sh(x/a), cos φ, sin φ) is at a right angle to the
// line of sight. Hand shading by the neck.
#let fig-4-38() = lettered-drawing({
  import cetz.draw: *
  // The chain of Figure 37 at the scale of this figure.
  let scale = 0.64
  let a = chain-ends.a * scale
  let x-a = -catenary-abscissa(a, chain-ends.low * scale)
  let x-b = catenary-abscissa(a, chain-ends.high * scale)
  let azimuth = -17deg
  let at = orthographic(azimuth, 0deg).project
  let point(x, s, inset: 0) = {
    let r = a * calc.cosh(x / a) - inset
    (x, r * calc.cos(s), r * calc.sin(s))
  }
  // The side facing the viewer: cos φ < bound(x).
  let bound(x) = -calc.sinh(x / a) * calc.tan(azimuth)
  let edge(x) = calc.acos(calc.max(-1, calc.min(1, bound(x))))
  let rim(x, from, to, inset: 0) = sample(
    s => at(point(x, s, inset: inset)),
    from,
    to,
    n: 90,
  )
  let (left, right) = (at((x-a, 0, 0)), at((x-b, 0, 0)))
  let half-width = a * calc.cosh(x-a / a) * calc.abs(calc.sin(azimuth))
  line(..rim(x-a, 0deg, 360deg), close: true, fill: black)
  line(..rim(x-a, 0deg, 360deg, inset: 0.8), close: true, stroke: (
    paint: white,
    thickness: 0.9pt,
    dash: "dotted",
  ))
  arrowed((left.at(0) - 9, 0), (left.at(0) - half-width, 0), mark: none)
  line((left.at(0) - half-width, 0), (left.at(0) + half-width, 0), stroke: (
    paint: white,
    thickness: thin-line,
  ))
  line((left.at(0) + half-width, 0), right, ..hidden)
  line(right, (right.at(0) + 7.5, 0))
  // The outline, up to where it passes behind the rim through B.
  let rim-b = (
    a * calc.cosh(x-b / a) * calc.abs(calc.sin(azimuth)),
    a
      * calc.cosh(
        x-b / a,
      ),
  )
  let outside((px, py)) = (
    calc.pow((px - right.at(0)) / rim-b.at(0), 2)
      + calc.pow(py / rim-b.at(1), 2)
      > 1
  )
  let meet = 90deg
  for side in (1, -1) {
    let points = sample(x => at(point(x, side * edge(x))), x-a, x-b, n: 240)
    let seen = runs-where(points, outside).first()
    line(..seen, stroke: thick-line)
    meet = calc.asin(calc.min(1, calc.abs(seen.last().at(1)) / rim-b.at(1)))
  }
  // The rim through B: solid where it bounds the view, dashed where the
  // outline passes in front of its far half.
  line(..rim(x-b, meet, 360deg - meet), stroke: 2.3pt)
  line(..rim(x-b, -meet, meet), ..hidden)
  // The shading strokes by the neck, along the meridians.
  let strokes = 14
  for k in range(strokes) {
    let s = 98deg + k * 10deg
    let length = 2.4 * (1 - k / strokes)
    line(at(point(0.9, s)), at(point(0.9 + length, s)), stroke: 0.9pt)
  }
  let (dot-a, dot-b) = (at(point(x-a, 155deg)), at(point(x-b, 155deg)))
  spot(dot-a, radius: 1.1)
  spot(dot-b, radius: 1.3)
  content(dot-a, $A$, anchor: "north-west", padding: 1)
  content(dot-b, $B$, anchor: "south-west", padding: 1.2)
})
// Figure 39: the other minimal film on the contour of Figure 38, the two
// discs spanning its circles through A and B (black, a light line along the
// near edge), on the axis Ox; in the view of Figure 38.
#let fig-4-39() = lettered-drawing({
  import cetz.draw: *
  let scale = 0.64
  let a = chain-ends.a * scale
  let ends = (
    (-catenary-abscissa(a, chain-ends.low * scale), chain-ends.low * scale),
    (catenary-abscissa(a, chain-ends.high * scale), chain-ends.high * scale),
  )
  let at = orthographic(-17deg, 0deg).project
  let circle-at(x, r, from, to) = sample(
    s => at((x, r * calc.cos(s), r * calc.sin(s))),
    from,
    to,
    n: 90,
  )
  arrowed(
    at((ends.first().at(0) - 13, 0, 0)),
    at((ends.last().at(0) + 14, 0, 0)),
    name: "x",
  )
  for (x, r) in ends {
    line(..circle-at(x, r, 0deg, 360deg), close: true, fill: black)
    line(..circle-at(x, r - 0.7, 100deg, 260deg), stroke: (
      paint: white,
      thickness: 0.8pt,
    ))
  }
  content("x.end", $x$, anchor: "north-east", padding: 1.6)
})
// Figure 40: A and B far apart: no catenoid spans the circles; the film
// breaks into two cones, from the circle through A and from that through B
// to the points P and Q of the axis, and the part between them is gone
// (dashed: the spindle swept by the arc through P, M and Q, its middle
// section stippled). The circles of the chain of Figure 37, the view of
// Figure 38; shading strokes in the cones.
#let fig-4-40() = lettered-drawing({
  import cetz.draw: *
  let scale = 0.674
  let (r-a, r-b) = (chain-ends.low * scale, chain-ends.high * scale)
  // The circles' abscissas, the points P, Q and the height of M.
  let (x-a, x-b, x-p, x-q, height) = (-33.5, 37, -25, 25, 12.7)
  let at = orthographic(-17deg, 0deg).project
  let dashed = (stroke: (thickness: thick-line, dash: hidden.stroke.dash))
  let circle-at(x, r, from, to) = sample(
    s => at((x, r * calc.cos(s), r * calc.sin(s))),
    from,
    to,
    n: 90,
  )
  let (p, q) = (at((x-p, 0, 0)), at((x-q, 0, 0)))
  let top(x, r) = at((x, 0, r))
  let bottom(x, r) = at((x, 0, -r))
  // The spindle: the profile circle through P, M = (0, h), Q.
  let bulge = (x-q * x-q - height * height) / (2 * height)
  let profile(x) = calc.sqrt(calc.pow(height + bulge, 2) - x * x) - bulge
  line(
    ..circle-at(0, height, 0deg, 360deg),
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(
    ..circle-at(x-a, r-a, 0deg, 360deg),
    close: true,
    fill: stipple,
    stroke: none,
  )
  for side in (1, -1) {
    line(
      ..sample(x => at((x, 0, side * profile(x))), x-p, x-q, n: 80),
      ..dashed,
    )
  }
  line(..circle-at(0, height, 0deg, 360deg), close: true, ..dashed)
  arrowed(at((x-a - 6, 0, 0)), at((x-b + 9, 0, 0)), name: "x")
  // The shading strokes: in the lower halves of the cones, from the axis
  // towards the outline, longer towards the circles.
  for (from, to, r, count) in ((x-p, x-a, r-a, 7), (x-q, x-b, r-b, 18)) {
    for k in range(1, count) {
      let x = from + (to - from) * k / count
      let depth = r * (x - from) / (to - from)
      line(at((x, 0, -0.3)), at((x, 0, -0.85 * depth)), stroke: 0.9pt)
    }
  }
  for (x, r) in ((x-a, r-a), (x-b, r-b)) {
    let apex = if x < 0 { p } else { q }
    line(top(x, r), apex, bottom(x, r), stroke: thick-line)
  }
  line(..circle-at(x-a, r-a, 0deg, 360deg), close: true, stroke: 2.3pt)
  line(..circle-at(x-b, r-b, 90deg, 270deg), stroke: 2.8pt)
  line(..circle-at(x-b, r-b, -90deg, 90deg), ..dashed)
  for point in (p, q, at((0, 0, 0))) { spot(point, radius: 0.9) }
  spot(top(x-a, r-a), radius: 0.8)
  spot(top(x-b, r-b), radius: 0.8)
  content(top(x-a, r-a), $A$, anchor: "south", padding: 1.4)
  content(top(x-b, r-b), $B$, anchor: "south-west", padding: 0.8)
  content("x.end", $x$, anchor: "north-east", padding: 1.6)
})
// Figure 41: the ends A, B of the heavy chain drawn apart along a line
// at the height H above the axis Ox: the chain y = y₀ + c(ch(x/c) − 1)
// sags, its lowest point y₀ falls, and at last touches the axis. For each
// span 2L and depth y₀, c solves H − y₀ = c(ch(L/c) − 1), by bisection.
#let fig-4-41() = lettered-drawing({
  import cetz.draw: *
  let height = 18.5
  // Half-spans and depths of the three positions.
  let chains = ((12.3, 5), (21.7, 2), (31.9, 0))
  let parameter(span, depth) = {
    let sag(c) = c * (calc.cosh(span / c) - 1)
    let (low, high) = (1.0, 200.0)
    for _ in range(60) {
      let mid = (low + high) / 2
      if sag(mid) > height - depth { low = mid } else { high = mid }
    }
    (low + high) / 2
  }
  arrowed((-35, 0), (37, 0))
  line(
    (-35, height),
    (36, height),
    stroke: (thickness: thick-line, dash: hidden.stroke.dash),
  )
  for (span, depth) in chains {
    let c = parameter(span, depth)
    line(
      ..sample(x => (x, depth + c * (calc.cosh(x / c) - 1)), -span, span),
      stroke: heavy-line,
    )
    spot((-span, height), radius: 1.3)
    spot((span, height), radius: 1.3)
  }
  let (first, last) = (chains.first().at(0), chains.last().at(0))
  content((-first, height), $A$, anchor: "south", padding: 2.4)
  content((first, height), $B$, anchor: "south", padding: 2.4)
  content((-last, height), $A'$, anchor: "south", padding: 2.4)
  content((last, height), $B'$, anchor: "south", padding: 2.4)
  let lift = height + 3.6
  let arrow = (mark: (end: "stealth", length: 2mm, width: 1.2mm))
  arrowed((-first - 2.2, lift), (-first - 8.6, lift), ..arrow, stroke: 1.6pt)
  arrowed((first + 2.2, lift), (first + 8.6, lift), ..arrow, stroke: 1.6pt)
})

// Figure 42: a contour Γ spanned by two minimal films homeomorphic to each
// other. A drawing.
#let fig-4-42() = lettered-drawing(book-picture(
  "/assets/figures/04-42-two-films.svg",
  93.85,
  labels: (
    ((12.9, 26.3), $Gamma$),
    ((46.2, 26.3), emph[1-е решение]),
    ((79.5, 26.7), emph[2-е решение]),
  ),
  padding: auto,
))
// The depth of the point p of space towards the viewer of `view`.
#let space-depth(view, p) = vec-dot(p, view.toward)

// Pieces of a picture of space, each (depth, drawing), drawn from the far
// to the near: the near ones, filled white or laid on white bands, cover
// the far ones.
#let far-to-near(pieces) = {
  for (depth, body) in pieces.sorted(key: piece => piece.at(0)) { body }
}

// A curve or a line of space as pieces of `size` points for `far-to-near`,
// each on a white band of `gap` that parts the lines it passes in front of.
#let banded-pieces(view, points, size: 6, gap: 1.3mm, ..style) = {
  range(0, points.len() - 1, step: size).map(i => {
    let run = points.slice(i, calc.min(i + size + 1, points.len()))
    let depth = run.map(p => space-depth(view, p)).sum() / run.len()
    (
      depth,
      cetz.draw.group({
        cetz.draw.set-style(..style)
        bridge(run.map(view.project), gap: gap)
      }),
    )
  })
}

// The band swept by a segment of half-length `half` whose centre runs
// round the circle of radius `radius` about the axis z and which turns in
// the plane (e_r, e_z) by `twist` per turn: its point at the angle φ and
// the place s ∈ [−half, half] along the segment, the segment at the angle
// `start` + `twist` · φ / 2π to e_r. A half twist gives the Möbius band,
// three segments at 2π/3 turning by 2π/3 give the triple Möbius film.
#let twisted-band-point(radius, start, twist, turn, s) = {
  let lean = start + twist * (turn / 360deg)
  let r = radius + s * calc.cos(lean)
  (r * calc.cos(turn), r * calc.sin(turn), s * calc.sin(lean))
}

// The axis z from `bottom` to `top` as banded pieces, with the arrow and
// the name z above `top` up to `tip`.
#let z-axis-pieces(view, bottom, top) = banded-pieces(
  view,
  sample(z => (0, 0, z), bottom, top, n: calc.ceil(top - bottom)),
  size: 2,
  gap: 2mm,
)
#let z-axis-arrow(view, top, tip) = {
  arrowed((view.project)((0, 0, top)), (view.project)((0, 0, tip)), name: "z")
  cetz.draw.content("z.end", $z$, anchor: "north-west", padding: 1)
}

// Figure 43. Left, the contour Γ winding twice round the axis z, the
// boundary of the Möbius band: the ends of a segment of half-length w whose
// centre runs round the circle of radius R and which turns by π per turn.
// Right, the Möbius band spanning Γ, drawn by its rulings, each with an
// arrowhead at the centre line; the arrows turn over after a turn.
#let fig-4-43() = lettered-drawing({
  import cetz.draw: *
  let view = orthographic(0deg, 27deg)
  let (radius, half) = (18, 6.2)
  let point(turn, s) = twisted-band-point(radius, -20deg, 180deg, turn, s)
  let (bottom, top, tip) = (-21.7, 14, 24)
  let edge-style = (stroke: (thickness: 1.8pt))
  group({
    translate((1.5, 16))
    far-to-near(
      banded-pieces(
        view,
        sample(t => point(t, half), 0deg, 720deg, n: 360),
        gap: 2.4mm,
        ..edge-style,
      )
        + z-axis-pieces(view, bottom, top),
    )
    z-axis-arrow(view, top, tip)
    content((view.project)(point(-55deg, half)), $Gamma$, anchor: "north-west")
  })
  group({
    translate((48, 16))
    let count = 48
    let step = 360deg / count
    // The arrows point along −(cos(φ/2) e_r + sin(φ/2) e_z), from the
    // edge s = half to the centre line; they turn over at the cut φ = 170°.
    let rulings = range(count).map(k => -190deg + k * step)
    let at = view.project
    let patches = rulings.map(turn => {
      let next = turn + step
      let corners = (
        point(turn, -half),
        point(turn, half),
        point(next, half),
        point(next, -half),
      )
      let depth = corners.map(p => space-depth(view, p)).sum() / 4
      (
        depth,
        {
          line(..corners.map(at), close: true, fill: white, stroke: none)
          line(at(point(turn, half)), at(point(next, half)), ..edge-style)
          line(at(point(turn, -half)), at(point(next, -half)), ..edge-style)
          line(at(point(turn, half)), at(point(turn, 0)), stroke: 0.9pt, mark: (
            end: ">",
            length: 2mm,
            width: 1.5mm,
          ))
          line(at(point(turn, 0)), at(point(turn, -half)), stroke: 0.9pt)
        },
      )
    })
    far-to-near(patches + z-axis-pieces(view, bottom, top))
    z-axis-arrow(view, top, tip)
  })
})

// Figure 44. The triple Möbius film: a tripod of three segments of length
// w at angles 2π/3 whose centre runs round the circle of radius R and which
// turns by 2π/3 per turn. Top left, its boundary Γ, winding three times
// round the axis z; top right, the film near a point of its singular
// circle, a tripod moved a little along it, standing on a disc; right, the
// tripod in its plane and the permutation σ of its ends after a turn;
// bottom, the film, drawn by its rulings, a tripod marked bold.
#let fig-4-44() = lettered-drawing({
  import cetz.draw: *
  let legs = range(3).map(k => k * 120deg)
  let edge-style = (stroke: (thickness: 1.8pt))
  // Γ: the end of one leg, which comes back to the start after three turns.
  group({
    translate((3.5, 40))
    let view = orthographic(0deg, 18deg)
    let (radius, half) = (23.5, 3.2)
    let tip(turn) = twisted-band-point(radius, 90deg, 120deg, turn, half)
    far-to-near(
      banded-pieces(view, sample(tip, 0deg, 1080deg, n: 540), ..edge-style)
        + z-axis-pieces(view, -16, 6),
    )
    z-axis-arrow(view, 6, 15.5)
    content(
      (view.project)((
        (radius + half) * calc.cos(-40deg),
        (radius + half) * calc.sin(-40deg),
        -half,
      )),
      $Gamma$,
      anchor: "north-west",
      padding: 1.2,
    )
  })
  // The tripod in the vertical plane through u, its centre at the height
  // w/2, so that two legs reach the disc, moved by `shift` along v.
  group({
    translate((49.5, 39.5))
    let view = orthographic(0deg, 18deg)
    let at = view.project
    let (half, shift, strokes) = (7, 8, 16)
    let (u, v) = (
      (calc.cos(-60deg), calc.sin(-60deg), 0),
      (
        calc.cos(30deg),
        calc.sin(30deg),
        0,
      ),
    )
    let centre = (0, 0, half / 2)
    let ends = legs.map(a => vec-add(
      centre,
      vec-scale(half * calc.cos(a + 90deg), u),
      (0, 0, half * calc.sin(a + 90deg)),
    ))
    let disc = vec-add(centre, (8, -4, -half / 2))
    line(
      ..sample(
        s => at(vec-add(disc, (17.5 * calc.cos(s), 17.5 * calc.sin(s), 0))),
        0deg,
        360deg,
        n: 90,
      ),
      close: true,
      fill: white,
      stroke: 1.6pt,
    )
    let moved(p, t) = vec-add(p, vec-scale(t * shift, v))
    far-to-near(ends.map(end => {
      let corners = (centre, end, moved(end, 1), moved(centre, 1))
      let depth = corners.map(p => space-depth(view, p)).sum() / 4
      (
        depth,
        {
          line(..corners.map(at), close: true, fill: white, stroke: none)
          for k in range(strokes + 1) {
            let t = k / strokes
            line(at(moved(centre, t)), at(moved(end, t)), stroke: 0.7pt)
          }
          line(at(end), at(moved(end, 1)), stroke: 0.7pt)
          line(at(centre), at(end), stroke: 1.8pt)
        },
      )
    }))
    for end in ends { spot(at(end), radius: 0.9) }
  })
  // The tripod in its plane: its ends 1, 2, 3 on the dashed circle, the
  // arrows from each end to its image under σ.
  group({
    translate((60, 13.5))
    let radius = 13.5
    circle((0, 0), radius: radius, stroke: (thickness: 1pt, dash: "dashed"))
    for (k, a) in legs.enumerate() {
      let end = (a + 90deg, radius)
      line((0, 0), end, stroke: 1pt)
      spot(end, radius: 0.9)
      content(end, $#(k + 1)$, anchor: a + 270deg, padding: 1.2)
      // The arrow along the circle towards the end, from the previous one.
      line(
        ..sample(
          s => (s, radius),
          a + 90deg - 22deg,
          a + 90deg - 6deg,
          n: 8,
        ),
        stroke: 1pt,
        mark: (end: ">", length: 1.6mm, width: 1.2mm),
      )
    }
  })
  // The film by its rulings: the leg at the angle 2πk/3 + φ/3 at φ; one
  // tripod marked bold, its ends dotted.
  group({
    translate((5, -2.5))
    let view = orthographic(0deg, 40deg)
    let at = view.project
    let (radius, half, count) = (19.5, 8, 96)
    let step = 360deg / count
    let marked = (24, 72)
    let pieces = ()
    for start in legs {
      let point(turn, s) = twisted-band-point(radius, start, 120deg, turn, s)
      for i in range(count) {
        let (turn, next) = (i * step, (i + 1) * step)
        let corners = (
          point(turn, 0),
          point(turn, half),
          point(next, half),
          point(next, 0),
        )
        let depth = corners.map(p => space-depth(view, p)).sum() / 4
        let bold = i in marked
        pieces.push((
          depth,
          {
            line(..corners.map(at), close: true, fill: white, stroke: none)
            line(at(point(turn, half)), at(point(next, half)), ..edge-style)
            line(at(point(turn, 0)), at(point(turn, half)), stroke: if bold {
              2.4pt
            } else { 0.7pt })
            if bold { spot(at(point(turn, half)), radius: 0.9) }
          },
        ))
      }
    }
    far-to-near(pieces)
  })
})
// Figure 45: a surface with self-intersections homeomorphic to the
// triple Möbius band, in two views. A drawing.
#let fig-4-45() = image(
  "/assets/figures/04-45-triple-band-model.svg",
  width: 79.93mm,
)
// Figure 46: a singular point of a minimal film, three half-discs glued
// along a common diameter. A drawing.
#let fig-4-46() = image(
  "/assets/figures/04-46-three-half-discs.svg",
  width: 23.62mm,
)
// Figure 47: four half-discs meeting along a diameter (two crossing discs,
// a drawing), their section, the cross of chords AB, AC, AD, AR of a
// circle at right angles, and its decay into two triple points: the
// shortest network joining B, C, D, R, the Steiner tree, whose edges meet
// at A′ and A″ at angles 2π/3. For B at 45° on the circle of radius r,
// A′B makes 60° with the axis: A′ = (−r (1/√2 − 1/√6), 0).
#let fig-4-47() = lettered-drawing({
  import cetz.draw: *
  book-picture(
    "/assets/figures/04-47-crossing-discs.svg",
    30.01,
    corner: (1.6, 2.45),
  )
  let radius = 11.7
  let names = ((45deg, $C$), (135deg, $B$), (225deg, $R$), (315deg, $D$))
  let section(centre, ..body) = group({
    translate(centre)
    circle((0, 0), radius: radius, stroke: 2.2pt)
    body.pos().join()
    for (turn, name) in names {
      spot((turn, radius), radius: 1)
      content((turn, radius), name, anchor: turn + 180deg, padding: 1)
    }
  })
  section((51.7, 17.4), {
    for (turn, name) in names { line((0, 0), (turn, radius), stroke: 1.1pt) }
    spot((0, 0), radius: 1)
    content((0, 0), $A$, anchor: "north", padding: 1.6)
  })
  content((51.7, 31.6), emph[Сечение])
  // The white arrow of the decay.
  line(
    (66.5, 16.9),
    (69.2, 16.9),
    (69.2, 15.9),
    (71.2, 17.5),
    (69.2, 19.1),
    (69.2, 18.1),
    (66.5, 18.1),
    close: true,
    stroke: 1.1pt,
    fill: white,
  )
  section((84.8, 17.4), {
    for turn in (45deg, 135deg) {
      line((turn, radius), (turn + 180deg, radius), stroke: 0.8pt)
    }
    spot((0, 0), radius: 0.8)
    let s = radius * (1 / calc.sqrt(2) - 1 / calc.sqrt(6))
    let (left, right) = ((-s, 0), (s, 0))
    let bold = (stroke: (thickness: 2.6pt, join: "miter"))
    line((135deg, radius), left, (225deg, radius), ..bold)
    line((45deg, radius), right, (315deg, radius), ..bold)
    line(left, right, ..bold)
    content(left, $A'$, anchor: "east", padding: 1.6)
    content(right, $A''$, anchor: "west", padding: 1.6)
  })
  content((85.3, 31.6), emph[Распад особенности $A -> A' union A''$])
})
// Figure 48: a minimal film with boundary whose fourfold singular points
// fill the segment AB. A drawing.
#let fig-4-48() = lettered-drawing(book-picture(
  "/assets/figures/04-48-film-on-contour.svg",
  40.68,
  labels: (((14.9, 25.1), $A$), ((24.85, 19.5), $B$)),
  padding: auto,
))
// Figure 49: the contour of Figure 48 made of wire of finite thickness
// spans another film, with triple singular points along AB. A drawing.
#let fig-4-49() = lettered-drawing(book-picture(
  "/assets/figures/04-49-film-on-thick-wire.svg",
  40.39,
  labels: (
    (
      (35.7, 7.2),
      {
        set par(leading: 0.3em)
        emph[Здесь \ пленки \ нет]
      },
    ),
  ),
  padding: auto,
))
