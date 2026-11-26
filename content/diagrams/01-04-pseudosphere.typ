// Figures of chapter 1, § 4. Each is a function called by the text:
// `#fig(fig-1-23()) <fig:…>`.
#import "common.typ": *
#import "../main-defs.typ": ch, sh

// The inverse hyperbolic functions, absent from `calc`.

// The pseudo-Euclidean square ⟨ξ⃗, ξ⃗⟩₁ of the text.
#let square-one = $chevron.l arrow(xi), arrow(xi) chevron.r_1$

// A sign in a round white cut-out of a stippled area.
#let round-cutout(body) = box(
  fill: white,
  radius: 1.5mm,
  inset: (x: 0.7mm, y: 0.6mm),
  body,
)

// The plane ℝ²₁ in the frame [−w, w] × [−h, h]: the sectors |x²| < |x¹|,
// where ⟨ξ⃗, ξ⃗⟩₁ < 0, stippled, then `over` drawn, then the light cone
// x² = ±x¹ across the frame.
#let light-cone-plane(half-width, half-height, over: none) = {
  import cetz.draw: *
  let (w, h) = (half-width, half-height)
  for side in (1, -1) {
    line(
      (0, 0),
      (side * h, h),
      (side * w, h),
      (side * w, -h),
      (side * h, -h),
      close: true,
      fill: stipple,
      stroke: none,
    )
  }
  over
  line((-h, -h), (h, h))
  line((-h, h), (h, -h))
}

// Figure 23: the light cone x² = ±x¹ parts the plane ℝ²₁ into the sectors
// ⟨ξ⃗, ξ⃗⟩₁ > 0 (+) and ⟨ξ⃗, ξ⃗⟩₁ < 0 (−, stippled); about the origin a white
// disc with black caps in the sectors +.
#let fig-1-23() = drawing({
  import cetz.draw: *
  let (half-width, half-height) = (29.7, 21.6)
  let (disc, cap) = (8.2, 4.2)
  light-cone-plane(half-width, half-height, over: circle(
    (0, 0),
    radius: disc,
    fill: white,
    stroke: none,
  ))
  for start in (-45deg, 135deg) {
    arc((0, 0), start: start, delta: 90deg, radius: disc, anchor: "origin")
  }
  for start in (45deg, 225deg) {
    arc(
      (0, 0),
      start: start,
      delta: 90deg,
      radius: cap,
      anchor: "origin",
      mode: "PIE",
      fill: black,
      stroke: none,
    )
  }
  arrowed((-half-width, 0), (28.3, 0), name: "x1")
  arrowed((0, -half-height), (0, 20.7), name: "x2")
  for side in (1, -1) {
    content((side * 2.8, 14.7), $+$)
    content((side * 2.8, -11.8), $+$)
    for level in (1, -1) {
      content((side * 11.4, level * 4.3), round-cutout($-$))
    }
  }
  content("x1.end", cutout($x^1$), anchor: "north-east")
  content("x2.end", $x^2$, anchor: "north-east")
  content((21, -10.5), cutout($#square-one < 0$))
  content((-9.5, -19), $#square-one > 0$)
})

// Figure 24: pseudospheres of ℝ²₁ of radius α (dashed, ρ² = α²) and iα
// (bold, ρ² = −α²), hyperbolas with the asymptotes ρ = 0, inside the frame.
#let fig-1-24() = drawing({
  import cetz.draw: *
  let (half-width, half-height) = (21.6, 20.6)
  let radius = 9.4
  light-cone-plane(half-width, half-height)
  arrowed((-half-width, 0), (21.7, 0), name: "x1")
  arrowed((0, -half-height), (0, 20.1), name: "x2")
  // The branches t ↦ ±α (ch t, sh t) and ±α (sh t, ch t), up to the frame.
  let reach = calc.min(
    calc.acosh(half-width / radius),
    calc.asinh(half-height / radius),
  )
  let dashed-reach = calc.acosh(19 / radius)
  let dash = (array: (3.9mm, 2.1mm), phase: 1.95mm)
  for side in (1, -1) {
    line(
      ..sample(
        t => (side * radius * calc.cosh(t), radius * calc.sinh(t)),
        -reach,
        reach,
      ),
      stroke: thick-line,
    )
    // Each half of a dashed branch from its vertex, a dash about it.
    for half in (1, -1) {
      line(
        ..sample(
          t => (half * radius * calc.sinh(t), side * radius * calc.cosh(t)),
          0,
          dashed-reach,
        ),
        stroke: (thickness: thick-line, dash: dash),
      )
    }
  }
  content("x1.end", cutout($x^1$), anchor: "north-east")
  content("x2.end", $x^2$, anchor: "north-east")
  content((11.5, 18.8), cutout($rho^2 = alpha^2$))
  content((-6.5, -17.5), $rho^2 = alpha^2$)
  // Between the frame and a bold branch, set close, as printed; its top at
  // the height `top`, where the branch is farthest from the axis.
  let (level, top) = (2.4, 4.0)
  let clear = calc.sqrt(radius * radius + top * top) + 0.6
  let close-label = text(
    size: 9pt,
    $rho^2 class("normal", =) class("unary", -) alpha^2$,
  )
  for side in (1, -1) {
    content(
      (side * clear, level),
      cutout(close-label),
      anchor: if side > 0 { "west" } else { "east" },
    )
    content(
      (side * 5.6, 5.6),
      $rho = 0$,
      angle: side * 45deg,
      anchor: "south",
      padding: 0.4,
    )
  }
})

// The Lorentz product ⟨p, q⟩₁ = −p₁q₁ + p₂q₂ + p₃q₃ of ℝ³₁.
#let lorentz(p, q) = vec-dot(p, q) - 2 * p.at(0) * q.at(0)
// The reflection of the first coordinate: J p is the Euclidean normal of the
// plane Lorentz-orthogonal to p, and J (p × q) is Lorentz-orthogonal to p, q.
#let flip-first(p) = (-p.at(0), p.at(1), p.at(2))

// The unit vector towards the viewer of the parallel projection with the
// images `e1`, `e2`, `e3` of the axes of a right-handed frame: the kernel
// of the projection, the cross product of its rows.
#let viewer-of(e1, e2, e3) = {
  let w = vec-cross(
    (e1.at(0), e2.at(0), e3.at(0)),
    (e1.at(1), e2.at(1), e3.at(1)),
  )
  vec-unit(w)
}

// A surface of revolution about the axis x¹, of radius r = f(x¹) with the
// slope f′, seen from `toward`: `point(x, t)` = (x, f(x) cos t, f(x) sin t).
// Its outline runs where the normal (−f′, cos t, sin t) is at a right angle
// to the line of sight, w₂ cos t + w₃ sin t = f′ w₁: it meets the circle at
// x in the angles `outline(x)` = (t₁, t₂), the arc from t₁ up to t₂ facing
// the viewer.
#let revolution(radius, slope, toward) = {
  let (w1, w2, w3) = toward
  let spread = calc.sqrt(w2 * w2 + w3 * w3)
  let facing = calc.atan2(w2, w3)
  (
    point: (x, t) => (x, radius(x) * calc.cos(t), radius(x) * calc.sin(t)),
    outline: x => {
      let c = calc.clamp(slope(x) * w1 / spread, -1, 1)
      (facing - calc.acos(c), facing + calc.acos(c))
    },
  )
}

// The circle x¹ = x of a surface of revolution from the angle `from` to
// `to`, under the projection `at`.
#let circle-arc(surface, x, from, to, at) = sample(
  t => (surface.point)(x, t),
  from,
  to,
  n: 90,
).map(at)

// The nappes x¹ < 0 and x¹ > 0 of the light cone (x¹)² = (x²)² + (x³)².
#let light-nappes(toward) = (
  revolution(x => -x, x => -1, toward),
  revolution(x => x, x => 1, toward),
)

// Figure 25: the light cone −(x¹)² + (x²)² + (x³)² = 0 of ℝ³₁ with the axis
// x¹ parts space into ⟨ξ⃗, ξ⃗⟩₁ > 0 outside and ⟨ξ⃗, ξ⃗⟩₁ < 0 inside; the
// plane x¹ = 0 black. An oblique view: x¹ along the page, x² receding to
// the upper right, x³ up; the viewer on the side x¹ > 0 looks into the
// right nappe.
#let fig-1-25() = drawing({
  import cetz.draw: *
  let (e1, e2, e3) = ((1.888, 0), (0.119, 0.114), (0, 1))
  let at = projection(e1, e2, e3)
  let (left, right) = light-nappes(viewer-of(e1, e2, e3))
  let (left-end, right-end) = (-13.2, 14.2)
  // The plane x¹ = 0: |x²| ⩽ `plane-width`, −`plane-low` ⩽ x³ ⩽ `plane-high`.
  let (plane-width, plane-low, plane-high) = (39.5, 14.35, 12.75)
  let tip = 29.8
  let outline = (stroke: thick-line)
  let dashes = (stroke: (thickness: thick-line, dash: hidden.stroke.dash))
  // The left nappe: its outer surface, the rim's near arc seen, the far arc
  // and the vertical diameter of the base hidden.
  let (from, to) = (left.outline)(left-end)
  let near-arc = circle-arc(left, left-end, from, to, at)
  line((0, 0), ..near-arc, close: true, fill: stipple, stroke: none)
  line(..near-arc, ..outline)
  line(..circle-arc(left, left-end, to, from + 360deg, at), ..dashes)
  line(at((left-end, 0, left-end)), at((left-end, 0, -left-end)), ..dashes)
  for t in (from, to) { line((0, 0), at((left.point)(left-end, t)), ..outline) }
  // The right nappe, open towards the viewer: the outline runs round the far
  // arc of the rim, and the whole rim is seen.
  let (from, to) = (right.outline)(right-end)
  line(
    (0, 0),
    ..circle-arc(right, right-end, to, from + 360deg, at),
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(..circle-arc(right, right-end, 0deg, 360deg, at), close: true, ..outline)
  for t in (from, to) {
    line((0, 0), at((right.point)(right-end, t)), ..outline)
  }
  // The axis x¹, dashed, its arrowhead past the rim.
  line(at((left-end, 0, 0)), (tip - 2, 0), ..dashes)
  mark((tip - 1, 0), (tip, 0), symbol: "stealth")
  // The plane in front of the left nappe; the axis x¹ > 0 and the apex
  // in front of the plane, white on it.
  line(
    at((0, -plane-width, plane-high)),
    at((0, plane-width, plane-high)),
    at((0, plane-width, -plane-low)),
    at((0, -plane-width, -plane-low)),
    close: true,
    fill: black,
    stroke: none,
  )
  line((0, 0), (at((0, plane-width, 0)).at(0), 0), stroke: (
    paint: white,
    thickness: thick-line,
    dash: hidden.stroke.dash,
  ))
  circle((0, 0), radius: 1, fill: black, stroke: (
    paint: white,
    thickness: 0.35mm,
  ))
  // ⟨ξ⃗, ξ⃗⟩₁ < 0 inside the cone: a leader into the right nappe.
  hobby((29.5, -17.7), (29, -9.8), (27.2, -6.4), mark: (end: "stealth"))
  content((12.9, 14), $#square-one > 0$)
  content((23.5, -20.2), $#square-one < 0$)
  content((3.6, -13.9), $x^2$)
  content((1, -17.6), $x^3$)
})

// A sparser stipple, for a surface seen through another.
#let sparse-stipple = dot-stipple(1mm, offset: 0.4mm)

// Figure 26: the pseudospheres of ℝ³₁ about the axis x¹ = x, cut off at
// |x| = X: the hyperboloid of one sheet ρ² = α², r = √(α² + x²); inside it
// the light cone ρ = 0, r = |x|, dashed; inside the cone the hyperboloid of
// two sheets ρ² = −α², r = √(x² − α²), stippled. Seen nearly across the
// axis from the side x > 0: the right ends open towards the viewer, their
// cut between the hyperboloid and the cone stippled, the inside of the
// sheet black.
#let fig-1-26() = drawing({
  import cetz.draw: *
  // x stretched along the page, x² receding to the right, x³ up.
  let (e1, e2, e3) = ((3.8, 0), (0.31, 0), (0, 1))
  let at = projection(e1, e2, e3)
  let toward = viewer-of(e1, e2, e3)
  let (alpha-size, end) = (8.4, 11.3)
  let neck-radius(x) = calc.sqrt(alpha-size * alpha-size + x * x)
  let one-sheet = revolution(neck-radius, x => x / neck-radius(x), toward)
  let sheet-radius(x) = calc.sqrt(x * x - alpha-size * alpha-size)
  let two-sheets = revolution(sheet-radius, x => x / sheet-radius(x), toward)
  let nappes = light-nappes(toward)
  let dashes = (stroke: (thickness: thick-line, dash: hidden.stroke.dash))
  let whole(surface, x) = circle-arc(surface, x, 0deg, 360deg, at)
  // The cone, sparsely stippled within its generators and the near arcs of
  // its rims.
  for (side, nappe) in ((-1, nappes.at(0)), (1, nappes.at(1))) {
    let (from, to) = (nappe.outline)(side * end)
    line(
      (0, 0),
      ..circle-arc(nappe, side * end, from, to, at),
      close: true,
      fill: sparse-stipple,
      stroke: none,
    )
  }
  // The right cut: the ring between the hyperboloid and the cone.
  line(..whole(one-sheet, end), close: true, fill: stipple, stroke: none)
  line(..whole(nappes.at(1), end), close: true, fill: white, stroke: none)
  // The sheets x = ±α ch s up to the cut, their outline round the vertex
  // from s₀, where the outline leaves the circles, and the outer arc of the
  // rim; the left rim's inner arc hidden, the right sheet black inside.
  let (w1, w2, w3) = toward
  let ratio = calc.sqrt(w2 * w2 + w3 * w3) / calc.abs(w1)
  let first = calc.ln((ratio + 1) / (ratio - 1)) / 2
  let last = calc.acosh(end / alpha-size)
  for side in (-1, 1) {
    let cut = side * end
    let along = sample(
      u => side * alpha-size * calc.cosh(first + (last - first) * u * u),
      0,
      1,
    )
    let (from, to) = (two-sheets.outline)(cut)
    let rim = if side < 0 { (to, from) } else { (to, from + 360deg) }
    line(
      ..along
        .rev()
        .map(x => at((two-sheets.point)(x, (two-sheets.outline)(x).at(0)))),
      ..along.map(x => at((two-sheets.point)(
        x,
        (two-sheets.outline)(x).at(1),
      ))),
      ..circle-arc(two-sheets, cut, ..rim, at),
      close: true,
      fill: stipple,
    )
    if side < 0 {
      line(..circle-arc(two-sheets, cut, from, to - 360deg, at), ..hidden)
    } else {
      line(..whole(two-sheets, cut), close: true, fill: black)
    }
  }
  // The hyperboloid of one sheet: its outline, the rims; the left rim's
  // inner arc hidden.
  for k in (0, 1) {
    line(
      ..sample(
        x => at((one-sheet.point)(x, (one-sheet.outline)(x).at(k))),
        -end,
        end,
      ),
      stroke: thick-line,
    )
  }
  let (from, to) = (one-sheet.outline)(-end)
  line(..circle-arc(one-sheet, -end, from, to, at), stroke: thick-line)
  line(..circle-arc(one-sheet, -end, to, from + 360deg, at), ..dashes)
  line(..whole(one-sheet, end), close: true, stroke: thick-line)
  // The cone: its generators and left rim hidden, the right rim seen.
  for (side, nappe) in ((-1, nappes.at(0)), (1, nappes.at(1))) {
    for (k, t) in (nappe.outline)(side * end).enumerate() {
      line(
        (0, 0),
        at((nappe.point)(side * end, t)),
        ..dashes,
        name: "generator-" + str(side) + "-" + str(k),
      )
    }
  }
  line(..whole(nappes.at(0), -end), close: true, ..dashes)
  line(..whole(nappes.at(1), end), close: true, stroke: thick-line)
  spot((0, 0), radius: 1.1)
  content((0, 0), $O$, anchor: "north", padding: 1.6)
  content("generator-1-0.47%", cutout($rho = 0$))
  content((22, -0.8), cutout($rho^2 = -alpha^2$))
  content((-5.2, -11.7), $rho^2 = alpha^2$)
})

// The line cut on the sheet x¹ > 0 of the pseudosphere ⟨p, p⟩₁ = −α² by
// the plane through O with the Euclidean normal ν, a hyperbola when the
// plane meets the light cone: s ↦ α (ch s · c + sh s · d), c and d its
// Lorentz-orthonormal basis, c timelike towards the sheet. `ends(X)` are the
// two parameters where x¹ = X, `parameter(p)` that of a point p of the cut.
#let sheet-section(normal, radius) = {
  let m = flip-first(normal)
  let axis = (1, 0, 0)
  let c = vec-add(axis, vec-scale(-lorentz(axis, m) / lorentz(m, m), m))
  let c = vec-scale(1 / calc.sqrt(-lorentz(c, c)), c)
  let d = flip-first(vec-cross(c, m))
  let d = vec-scale(1 / calc.sqrt(lorentz(d, d)), d)
  let (a, b) = (c.at(0), d.at(0))
  (
    point: s => vec-scale(radius, vec-add(
      vec-scale(calc.cosh(s), c),
      vec-scale(calc.sinh(s), d),
    )),
    // x¹ = α √(a² − b²) ch(s + s₀) with th s₀ = b / a.
    ends: reach => {
      let shift = calc.atanh(b / a)
      let half = calc.acosh(reach / radius / calc.sqrt(a * a - b * b))
      (-shift - half, -shift + half)
    },
    parameter: p => calc.asinh(lorentz(p, d) / radius),
  )
}

// Figure 27: the sheet x > 0 of the pseudosphere −α² = −x² + y² + z², cut
// off at x = X, and its intersection with a plane ax + by + cz = 0, which
// passes through the two points of the rim where the plane's edge on x = X
// meets it. The sheet is opaque and open at x = X; the plane is stippled.
// The frame is drawn left-handed, as printed: y towards the viewer.
#let fig-1-27() = drawing({
  import cetz.draw: *
  let (e1, e2, e3) = ((1.77, 0), (-0.224, -0.332), (0, 1))
  let at = projection(e1, e2, e3)
  let toward = vec-scale(-1, viewer-of(e1, e2, e3))
  let (alpha-size, end) = (5.657, 16.97)
  let rim-radius = calc.sqrt(end * end - alpha-size * alpha-size)
  let on-rim(t) = (end, rim-radius * calc.cos(t), rim-radius * calc.sin(t))
  // The plane: through O and the rim points at the angles `cuts`.
  let cuts = (160.2deg, -4.9deg)
  let (upper, lower) = cuts.map(on-rim)
  let normal = vec-cross(upper, lower)
  // The plane's corners: on the line x = X beyond the rim, and two more.
  let chord(u) = vec-add(
    lower,
    vec-scale(u, vec-add(upper, vec-scale(-1, lower))),
  )
  let corners = (
    (-5.31, 13.85, -3.70),
    chord(-0.17),
    chord(1.55),
    (2.56, -23.56, 5.48),
  )
  let plane = corners.map(at)
  // The cut, the outline (the sheet's points where the outward normal
  // (−x, y, z) is at a right angle to the line of sight, ⟨p, w⟩₁ = 0) and
  // their common point.
  let cut = sheet-section(normal, alpha-size)
  let outline = sheet-section(flip-first(toward), alpha-size)
  let touch = vec-cross(normal, flip-first(toward))
  let touch = vec-scale(
    alpha-size
      / calc.sqrt(-lorentz(touch, touch))
      * calc.abs(touch.at(0))
      / touch.at(0),
    touch,
  )
  // The point (X, y, z) of the plane of the rim seen at the page point of p;
  // p is seen through the opening if that point is inside the rim.
  let rim-lift(p) = {
    let (u, v) = vec-add(at(p), vec-scale(-1, at((end, 0, 0))))
    let det = e2.at(0) * e3.at(1) - e2.at(1) * e3.at(0)
    (
      end,
      (u * e3.at(1) - v * e3.at(0)) / det,
      (e2.at(0) * v - e2.at(1) * u) / det,
    )
  }
  let rim-angle(p) = calc.atan2(p.at(1), p.at(2))
  let through-opening(p) = {
    let (_, y, z) = rim-lift(p)
    y * y + z * z < rim-radius * rim-radius
  }
  let in-front(p) = vec-dot(normal, p) > 0
  // Parameters of the cut at the upper and lower rim points and at the
  // touching point; of the outline at the top of the rim and at the touch.
  let cut-at(p) = (cut.parameter)(p)
  let tops = (outline.ends)(end).filter(s => (outline.point)(s).at(2) > 0)
  let top = tops.first()
  let top-point = (outline.point)(top)
  // The plane, then the sheet's front above it, white; through the
  // opening the inside of the sheet, white, and the plane in it.
  line(..plane, close: true, fill: stipple, stroke: none)
  let front = (
    ..sample(outline.point, top, (outline.parameter)(touch), n: 100),
    ..sample(cut.point, cut-at(touch), cut-at(lower), n: 100),
    ..sample(on-rim, rim-angle(lower), rim-angle(top-point), n: 60),
  )
  line(..front.map(at), close: true, fill: white, stroke: none)
  line(..sample(on-rim, 0deg, 360deg).map(at), fill: white, stroke: none)
  let hidden-cut = sample(cut.point, cut-at(touch), cut-at(upper), n: 200)
  let seen-cut = hidden-cut.filter(through-opening)
  let entry = rim-angle(rim-lift(seen-cut.first()))
  line(
    ..seen-cut.map(at),
    at(lower),
    ..sample(on-rim, rim-angle(lower), entry, n: 60).map(at),
    close: true,
    fill: stipple,
    stroke: none,
  )
  // The plane's edges: the front one and the one on x = X bold.
  line(plane.at(0), plane.at(1), plane.at(2), stroke: 2 * thick-line)
  line(plane.at(2), plane.at(3), plane.at(0), stroke: thick-line)
  // The outline and the cut, hidden lines dashed.
  let (first, last) = (outline.ends)(end)
  seen-hidden(
    at,
    p => in-front(p) or not inside-convex(at(p), plane),
    sample(outline.point, first, last, n: 300),
  )
  let (first, last) = (cut.ends)(end)
  seen-hidden(
    at,
    p => lorentz(p, toward) > 0 or through-opening(p),
    sample(cut.point, first, last, n: 300),
  )
  line(..sample(on-rim, 0deg, 360deg).map(at), close: true)
  // The axes; x hidden inside the sheet and behind the plane, as far as
  // the plane's edge on x = X.
  let (x-tip, y-tip, z-tip) = ((21.5, 0, 0), (0, 49.4, 0), (0, 0, 19.5))
  let edge-cross = {
    let (p, q) = (at(lower), at(upper))
    let u = -p.at(1) / (q.at(1) - p.at(1))
    p.at(0) + u * (q.at(0) - p.at(0))
  }
  line((0, 0), (edge-cross, 0), ..hidden)
  arrowed((edge-cross, 0), at(x-tip), name: "x")
  arrowed((0, 0), at(y-tip), name: "y")
  arrowed((0, 0), at(z-tip), name: "z")
  for p in ((0, 0, 0), (alpha-size, 0, 0)) { spot(at(p)) }
  for p in (upper, lower) { spot(at(p), radius: 1.1) }
  content("x.end", $x$, anchor: "north-east")
  content("y.end", $y$, anchor: "south-east")
  content("z.end", $z$, anchor: "north-east")
  content((0, 0), $O$, anchor: "north-west")
  content((7.3, -12.3), cutout($a x + b y + c z = 0$))
})
// Figure 28: the section of the pseudosphere −α² = −x² + y² + z² by a
// plane through the axis x: the hyperbola x² − u² = α² with the
// asymptotes; the stereographic projection f from the north pole N =
// (−α, 0, 0) to the plane x = 0 sends the right sheet into the disc
// u² < α² (bold) and the left one outside it. In units α, x stretched
// along the page as in Figure 27.
#let fig-1-28() = drawing({
  import cetz.draw: *
  let at((x, u)) = (17.2 * x, 9.9 * u)
  // The frame |x| ⩽ `reach`; the point P at the parameter `turn`.
  let (reach, turn) = (1.453, 0.745)
  let crest = calc.acosh(reach)
  let branch(side) = sample(
    t => at((side * calc.cosh(t), calc.sinh(t))),
    -crest,
    crest,
  )
  for side in (-1, 1) {
    line(..branch(side), close: true, fill: stipple, stroke: none)
    line(..branch(side), stroke: thick-line)
    line(at((-reach, -side * reach)), at((reach, side * reach)))
    // From N parallel to the asymptotes, through (0, ±α).
    line(at((-1, 0)), at((0.68, side * 1.68)), ..hidden)
  }
  arrowed(at((-reach, 0)), (26.3, 0), name: "x")
  line(at((0, -1.97)), at((0, 1.87)))
  line(at((0, -1)), at((0, 1)), stroke: thick-line)
  let (north, south) = ((-1, 0), (1, 0))
  let point = (calc.cosh(turn), calc.sinh(turn))
  let image = (0, point.at(1) / (point.at(0) + 1))
  line(at(north), at(point), name: "ray")
  mark(
    (at(image), 15%, at(point)),
    (at(image), 11%, at(point)),
    symbol: "stealth",
  )
  for p in (north, south, (0, 1), (0, -1), image, point) {
    spot(at(p), radius: 1.1)
  }
  content(at(north), cutout($N$), anchor: "north-west", padding: 1.5)
  content(at(south), $S$, anchor: "south-east", padding: 1.5)
  // The poles' coordinates beside the branches, smaller, as printed.
  let small(body) = cutout(text(size: 8pt, body))
  content((-18.8, -2), small($(-alpha, 0, 0)$), anchor: "east")
  content((18.8, -2), small($(alpha, 0, 0)$), anchor: "west")
  content("x.end", cutout($x$), anchor: "south-east")
  content(at(point), $P$, anchor: "south", padding: 1.6)
  content(at((0, 0.72)), $f(P)$, anchor: "west")
  content((0, 0), $O$, anchor: "north-east")
})
// An angle reduced to [−180°, 180°).
#let turn-reduced(t) = calc.rem-euclid(t.deg() + 180, 360) * 1deg - 180deg

// The line of the Poincaré disc of radius R about the origin between its
// points at infinity at the angles `a` and `b`: the arc, inside the disc,
// of the circle through them meeting the boundary at right angles, its
// centre on the bisector at R / cos(δ/2), its radius R |tg(δ/2)|; or the
// diameter.
#let disc-geodesic(radius, a, b, n: 60) = {
  let ends = (a, b).map(t => (radius * calc.cos(t), radius * calc.sin(t)))
  let spread = turn-reduced(b - a)
  if calc.abs(spread) > 179.99deg { return ends }
  let middle = a + spread / 2
  let reach = radius / calc.cos(spread / 2)
  let (cx, cy) = (reach * calc.cos(middle), reach * calc.sin(middle))
  let bend = radius * calc.abs(calc.tan(spread / 2))
  let angle(p) = calc.atan2(p.at(0) - cx, p.at(1) - cy)
  let from = angle(ends.first())
  sample(
    t => (cx + bend * calc.cos(t), cy + bend * calc.sin(t)),
    from,
    from + turn-reduced(angle(ends.last()) - from),
    n: n,
  )
}


// Figure 29: the Poincaré disc D² with two of its lines, a diameter and an
// arc meeting the boundary, the circle of infinite radius, at right angles:
// at their ends the tangents to the boundary and the radii.
#let fig-1-29() = drawing({
  import cetz.draw: *
  let radius = 16.1
  let diameter = (236.5deg, 56.5deg)
  let arc-ends = (10.9deg, -80.2deg)
  let at-angle(t, r) = (r * calc.cos(t), r * calc.sin(t))
  circle((0, 0), radius: radius, fill: stipple, stroke: thick-line)
  line(..disc-geodesic(radius, ..diameter), stroke: thick-line)
  line(..disc-geodesic(radius, ..arc-ends), stroke: 1.5 * thick-line)
  // The right angles at the points at infinity.
  let stroke-length = 12
  for t in (..diameter, ..arc-ends) {
    let p = at-angle(t, radius)
    let along = at-angle(t + 90deg, stroke-length / 2)
    line(vec-add(p, along), vec-add(p, vec-scale(-1, along)))
    spot(p, radius: 1)
  }
  for t in arc-ends {
    line(at-angle(t, radius - 7.5), at-angle(t, radius + 3.5))
  }
  spot((0, 0), radius: 1)
  content((0, 0), cutout($O$), anchor: "east", padding: 1.4)
  content((-12.7, 13.8), $D^2$)
  content(
    (-19.4, -18.2),
    text(size: 8.5pt, stack(
      spacing: 0.6mm,
      emph[Окружность],
      emph[бесконечного радиуса],
    )),
    anchor: "north-west",
  )
})

// Figure 30: a line of the disc model, the arc AB of a circle (dashed
// outside the disc) meeting the boundary of the stippled disc at right
// angles, at A and B: the radii to A and B are at a right angle, the
// centres √(R² + r²) apart.
#let fig-1-30() = drawing({
  import cetz.draw: *
  let (radius, arc-radius) = (12.5, 8.85)
  let apart = calc.sqrt(radius * radius + arc-radius * arc-radius)
  let centre = (-apart, 0)
  let opening = calc.atan2(radius, arc-radius)
  let a-point = (-radius * calc.cos(opening), radius * calc.sin(opening))
  let b-point = (a-point.at(0), -a-point.at(1))
  circle((0, 0), radius: radius, fill: stipple, stroke: thick-line)
  // The circle: dashed outside the disc, bold inside it.
  let on-circle(t) = (
    -apart + arc-radius * calc.cos(t),
    arc-radius * calc.sin(t),
  )
  let meet = 90deg - opening
  line(..sample(on-circle, meet, 360deg - meet), stroke: (
    thickness: thick-line,
    dash: hidden.stroke.dash,
  ))
  line(..sample(on-circle, -meet, meet), stroke: 2 * thick-line)
  line(centre, (0, 0))
  spot(centre, radius: 0.8)
  spot((0, 0), radius: 1.1)
  spot(a-point, radius: 1)
  spot(b-point, radius: 1)
  content(a-point, $A$, anchor: "south", padding: 1.6)
  content(b-point, $B$, anchor: "north", padding: 1.6)
})
// The other point at infinity of the line of the disc of radius R about
// the origin through the inner point p and the point at infinity at the
// angle e. The circle of the line meets the boundary at right angles at q,
// so its centre c has c · q = R², and is as far from p as from q, so
// c · p = (|p|² + R²) / 2; the two ends are mirror images in the line Oc.
#let disc-far-end(radius, p, e) = {
  let q = (radius * calc.cos(e), radius * calc.sin(e))
  let det = q.at(0) * p.at(1) - q.at(1) * p.at(0)
  if calc.abs(det) < 1e-9 { return e + 180deg }
  let (r2, s) = (radius * radius, (vec-dot(p, p) + radius * radius) / 2)
  let centre = (
    (r2 * p.at(1) - s * q.at(1)) / det,
    (s * q.at(0) - r2 * p.at(0)) / det,
  )
  2 * calc.atan2(..centre) - e
}

// Figure 31: in the Poincaré disc, the lines through a point P that do not
// meet a given line (bold): the fan of lines between the two lines through
// P parallel to it, which meet it at its points at infinity a and b.
#let fig-1-31() = drawing({
  import cetz.draw: *
  let radius = 13.6
  let point = (3.6, 0.1)
  let (a, b) = (4.6deg, -54.7deg)
  let beyond = disc-far-end(radius, point, b)
  for e in sample(e => e, a, beyond, n: 24) {
    line(
      ..disc-geodesic(radius, e, disc-far-end(radius, point, e)),
      stroke: 0.5pt,
    )
  }
  line(..disc-geodesic(radius, a, b), stroke: 1.5 * thick-line)
  circle((0, 0), radius: radius, stroke: 1.5 * thick-line)
  spot((0, 0), radius: 0.6)
})
// Figure 32: the section of the pseudosphere by the plane XOZ, the
// hyperbola x² − z² = 1, x = ch θ′, z = sh θ′, with the asymptotes; the
// inside of the left branch black, of the right one stippled; the point P
// of the right branch, its projection from N to the axis z and its
// perpendicular to the axis x. In units α = 1, x stretched along the page
// as in Figure 28.
#let fig-1-32() = drawing({
  import cetz.draw: *
  let at((x, z)) = (20.5 * x, 11.9 * z)
  let (reach, turn) = (1.463, 0.76)
  let crest = calc.acosh(reach)
  let branch(side) = sample(
    t => at((side * calc.cosh(t), calc.sinh(t))),
    -crest,
    crest,
  )
  line(..branch(-1), close: true, fill: black, stroke: none)
  line(..branch(1), close: true, fill: stipple, stroke: none)
  // The left branch parted from the black by a white band.
  bridge(branch(-1), gap: 1.6mm)
  line(..branch(1))
  for side in (-1, 1) {
    line(at((-reach, -side * reach)), at((reach, side * reach)))
  }
  let (north, south) = ((-1, 0), (1, 0))
  let point = (calc.cosh(turn), calc.sinh(turn))
  let image = (0, point.at(1) / (point.at(0) + 1))
  let foot = (point.at(0), 0)
  arrowed(at(north), (31.1, 0), name: "x")
  arrowed((0, -18.6), (0, 18.1), name: "z")
  line(at(north), at(point))
  line((0, 0), at(point))
  line(at(point), at(foot))
  circle(at(north), radius: 1.9, fill: white, stroke: none)
  for p in (north, south, (0, 0), image, point) { spot(at(p), radius: 1.3) }
  spot(at(foot), radius: 0.4)
  content(at(north), $N$, anchor: "north-west", padding: 1.6)
  content((0, 0), $O$, anchor: "north-east", padding: 1.6)
  content(at(south), $S$, anchor: "north-east", padding: 1.6)
  content(at(point), $P$, anchor: "south", padding: 1.6)
  content("x.end", cutout($x$), anchor: "north", padding: 1.6)
  content("z.end", $z$, anchor: "north-east")
  content(
    (30.5, -3),
    cutout(text(size: 8.5pt, stack(
      spacing: 0.8mm,
      $x = ch theta'$,
      $z = sh theta'$,
    ))),
    anchor: "north-east",
  )
})
// A stippled sector at the origin of space from the unit vector `a` towards
// the unit vector `b` at a right angle to it, of `angle` and `radius`,
// under the projection `at` (`draw`); and the point at `reach` times the
// radius on its bisector (`label`).
#let space-sector(at, a, b, angle, radius, reach: 1.35) = {
  let arm(t, r) = at(vec-add(
    vec-scale(r * calc.cos(t), a),
    vec-scale(r * calc.sin(t), b),
  ))
  (
    draw: cetz.draw.line(
      (0, 0),
      ..sample(t => arm(t, radius), 0deg, angle, n: 30),
      close: true,
      fill: stipple,
    ),
    label: arm(angle / 2, reach * radius),
  )
}

// Figure 33: the pseudospherical coordinates of a point P of the sheet
// α = const: x = α ch θ′, y = α sh θ′ cos φ, z = α sh θ′ sin φ; r =
// α sh θ′ is the distance of its projection to the plane YOZ from O. The
// sheet, cut off at x = X, is drawn transparent, its outline dashed. The
// frame is drawn left-handed, as printed, x stretched as in Figure 27.
#let fig-1-33() = drawing({
  import cetz.draw: *
  let (e1, e2, e3) = ((1.69, 0), (-0.3126, -0.3237), (0, 1))
  let at = projection(e1, e2, e3)
  let toward = vec-scale(-1, viewer-of(e1, e2, e3))
  let (alpha-size, end) = (8.7, 21.8)
  let (hyperbolic, turn) = (1.4, 45deg)
  let sheet-radius(x) = calc.sqrt(x * x - alpha-size * alpha-size)
  let sheet = revolution(sheet-radius, x => x / sheet-radius(x), toward)
  let spoke = (0, calc.cos(turn), calc.sin(turn))
  let radial = alpha-size * calc.sinh(hyperbolic)
  let foot = vec-scale(radial, spoke)
  let point = vec-add((alpha-size * calc.cosh(hyperbolic), 0, 0), foot)
  // The outline of the sheet round its vertex, from s₀ where it leaves the
  // circles x = α ch s, and its rim, stippled.
  let (w1, w2, w3) = toward
  let ratio = calc.sqrt(w2 * w2 + w3 * w3) / calc.abs(w1)
  let first = calc.ln((ratio + 1) / (ratio - 1)) / 2
  let last = calc.acosh(end / alpha-size)
  let along = sample(
    u => alpha-size * calc.cosh(first + (last - first) * u * u),
    0,
    1,
  )
  let rim = circle-arc(sheet, end, 0deg, 360deg, at)
  line(..rim, close: true, fill: stipple, ..hidden)
  line(
    ..along.rev().map(x => at((sheet.point)(x, (sheet.outline)(x).at(0)))),
    ..along.map(x => at((sheet.point)(x, (sheet.outline)(x).at(1)))),
    ..hidden,
    name: "outline",
  )
  // The angles θ′ (in the plane of the axis x and P) and φ (in YOZ).
  let polar-sector = space-sector(
    at,
    (1, 0, 0),
    spoke,
    calc.atan2(point.at(0), radial),
    6.3,
    reach: 1.3,
  )
  let turn-sector = space-sector(at, (0, 1, 0), (0, 0, 1), turn, 5, reach: 2.6)
  polar-sector.draw
  turn-sector.draw
  arrowed((0, 0), (48.8, 0), name: "x")
  arrowed((0, 0), at((0, 0, 22.5)), name: "z")
  arrowed((0, 0), at((0, 33.8, 0)), name: "y")
  line((0, 0), at(foot), name: "r")
  line(at(foot), at(point), ..hidden)
  line((0, 0), at(point), stroke: thick-line, name: "radius")
  spot(at(point), radius: 1.3)
  spot(at(foot), radius: 1.3)
  content(polar-sector.label, $theta'$)
  content(turn-sector.label, $phi$)
  content("r.55%", $r$, anchor: "east", padding: 1.6)
  content("radius.mid", $alpha$, anchor: "south-east")
  content(at(point), $P$, anchor: "north-west", padding: 1.6)
  content("x.end", $x$, anchor: "north", padding: 1.6)
  content("z.end", $z$, anchor: "north-east")
  content("y.end", $y$, anchor: "north-west")
  content(
    "outline.30%",
    $alpha = "const"$,
    angle: "outline.24%",
    anchor: "north",
    padding: 0.8,
  )
})
// Figure 34: the hyperbola x² − z² = 1 of the plane XOZ of ℝ³₁ and its
// velocity ξ⃗ = (sh t, ch t) at P = (ch t, sh t): ξ⃗ lies outside the light
// cone at P, the translate of that at O; the insides of the cones towards x
// stippled. In units α = 1, x stretched along the page as in Figure 32.
#let fig-1-34() = drawing({
  import cetz.draw: *
  let at((x, z)) = (21.3 * x, 12.3 * z)
  let (turn, crest) = (0.46, 0.95)
  let point = (calc.cosh(turn), calc.sinh(turn))
  let shifted((x, z)) = at((point.at(0) + x, point.at(1) + z))
  // The cone at O as far as x = `near`, the one at P as far as x = `far`.
  let (near, far) = (0.93, 0.69)
  line(
    (0, 0),
    at((near, near)),
    at((near, -near)),
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(
    at(point),
    shifted((far, far)),
    shifted((far, -far)),
    close: true,
    fill: stipple,
    stroke: none,
  )
  line(at((-0.39, -0.39)), at((0.95, 0.95)))
  line(at((-0.39, 0.39)), at((1.49, -1.49)))
  for side in (1, -1) { line(at(point), shifted((far, side * far))) }
  line(at(point), shifted((far, 0)))
  line(at(point), (at(point).at(0), 17.8))
  line(at((-0.35, 0)), at((1.75, 0)))
  arrowed((0, -20), (0, 18.5), name: "z")
  line(
    ..sample(t => at((calc.cosh(t), calc.sinh(t))), -crest, crest),
    stroke: thick-line,
  )
  let velocity = (calc.sinh(turn), calc.cosh(turn))
  arrowed(at(point), shifted(vec-scale(0.6, velocity)), name: "xi")
  spot((0, 0), radius: 1.2)
  spot(at(point), radius: 1.2)
  content("z.end", $z$, anchor: "north-east")
  content((0, 0), $O$, anchor: "north-east", padding: 1.6)
  content(at(point), $P$, anchor: "east", padding: 1.8)
  content("xi.end", $arrow(xi)$, anchor: "south-west", padding: 0.6)
})
// A drawing of the table of Figure 35: the chart of a metric in polar
// coordinates (ρ, φ), stippled where it is defined, a disc of radius
// `size` or the whole plane (a square of half-side `size`), with its axes;
// the bold radius-vector of a point at the angle φ, the angle white.
#let chart-drawing(
  size,
  length-label,
  disc: true,
  origin-label: none,
) = drawing({
  import cetz.draw: *
  let turn = 60deg
  let (sector, overhang) = (6, if disc { 3 } else { 0 })
  let point = (turn, 0.85 * size)
  if disc {
    circle((0, 0), radius: size, fill: stipple, stroke: 1.5 * thin-line)
  } else {
    rect((-size, -size), (size, size), fill: stipple)
  }
  arc(
    (0, 0),
    start: 0deg,
    stop: turn,
    radius: sector,
    anchor: "origin",
    mode: "PIE",
    fill: white,
    stroke: none,
  )
  arc((0, 0), start: 0deg, stop: turn, radius: sector, anchor: "origin")
  let reach = size + overhang
  line((-reach, 0), (reach, 0))
  line((0, -reach), (0, reach))
  line((0, 0), point, stroke: thick-line, name: "radius")
  spot((0, 0))
  spot(point)
  content("radius.62%", cutout(length-label), anchor: "south-east")
  content((turn / 2, sector * 0.62), $phi$)
  if origin-label != none {
    content(
      (0, 0),
      cutout(text(size: 9pt, origin-label)),
      anchor: "north-east",
      padding: 0.6,
    )
  }
})

// Figure 35: the table comparing the metrics of the sphere and the
// pseudosphere, in the coordinates (θ, φ) and (χ, φ) and in the polar
// coordinates (r, φ) of the stereographic projection, with the domains of
// the charts.
#let fig-1-35() = {
  let cell(formula, picture, ranges, note: none) = {
    align(right, formula)
    v(2.5mm)
    grid(
      columns: 2,
      column-gutter: 2.5mm,
      picture, pad(top: 6mm, stack(spacing: 2.6mm, ..ranges, note)),
    )
  }
  let size = 15.7
  table(
    columns: (54mm, 55mm),
    stroke: 0.8pt,
    inset: (x: 1.5mm, top: 2.5mm, bottom: 3mm),
    table.header(
      table.cell(align: center, emph[Сфера]),
      table.cell(align: center, emph[Псевдосфера]),
    ),
    cell(
      $d s^2 = d theta^2 + sin^2 theta thin d phi^2$,
      chart-drawing(12.5, $theta$, origin-label: $N = O$),
      ($0 < theta < pi$, $0 <= phi < 2 pi$),
      note: pad(top: 4mm, align(left, emph[Развертка \ сферы $S^2 without S$])),
    ),
    cell(
      $d s^2 = d chi^2 + sh^2 chi thin d phi^2$,
      chart-drawing(size, $chi$, disc: false),
      ($0 <= chi < oo$, $0 <= phi < 2 pi$),
    ),
    cell(
      $d s^2 = 4 display((d r^2 + r^2 thin d phi^2) / (1 + r^2)^2)$,
      chart-drawing(size, $r$, disc: false, origin-label: $N = O$),
      ($0 <= r < oo$, $0 <= phi < 2 pi$),
    ),
    cell(
      $d s^2 = 4 display((d r^2 + r^2 thin d phi^2) / (1 - r^2)^2)$,
      chart-drawing(12.5, $r$),
      ($0 <= r < 1$, $0 <= phi < 2 pi$),
    ),
  )
}
// Figure 36: the unit disc |z| < 1 and the upper half-plane v > 0 of
// w = u + iv, both stippled, with the points 0, i, 1 at the same unit; the
// fractional linear map z = (aw + b) / (cw + d) of the half-plane onto the
// disc.
#let fig-1-36() = drawing({
  import cetz.draw: *
  let unit = 12.5
  circle((0, 0), radius: unit, fill: stipple, stroke: thick-line)
  arrowed((-16.9, 0), (18.5, 0), name: "x")
  arrowed((0, -18.5), (0, 18.7), name: "y")
  for p in ((0, 0), (0, unit), (unit, 0)) { spot(p, radius: 1) }
  content("x.end", $x$, anchor: "north", padding: 1.6)
  content("y.end", $y$, anchor: "north-east")
  content((0, 0), cutout($O$), anchor: "north-east", padding: 1.6)
  content((0, unit), $i$, anchor: "south-west", padding: 1.2)
  content((unit, 0), $1$, anchor: "north-west", padding: 1.2)
  // The half-plane about its origin `corner`.
  group({
    let corner = (41.9, -11.6)
    translate(corner)
    rect((-18.4, 0), (18.6, 30.9), fill: stipple, stroke: none)
    arrowed((-18.4, 0), (18.9, 0), name: "u")
    arrowed((0, -5.6), (0, 29.8), name: "v")
    for p in ((0, 0), (0, unit), (unit, 0)) { spot(p, radius: 1) }
    content("u.end", $u$, anchor: "north", padding: 1.6)
    content("v.end", cutout($v$), anchor: "north-east")
    content((0, unit), cutout($i$), anchor: "west", padding: 1.6)
    content((-9.4, -2), $w = u + i v$)
  })
  arrowed((29.6, 14.7), (11.2, 14.7), name: "map")
  content((13.9, 19.6), text(size: 8.5pt, $z = display((a w + b) / (c w + d))$))
})
// Figure 37: the stereographic projection of the unit sphere from its north
// pole N to the plane z = 0, in the section by the plane through the axis z
// and the point P: P(x, y, z) goes to (x′, y′), and the similar stippled
// triangles give x′ = x / (1 − z), y′ = y / (1 − z).
#let fig-1-37() = drawing({
  import cetz.draw: *
  let radius = 19.2
  let point = (41.4deg, radius)
  let (px, pz) = (
    radius * calc.cos(41.4deg),
    radius * calc.sin(41.4deg),
  )
  let north = (0, radius)
  let image = (radius * px / (radius - pz), 0)
  let height = (0, pz)
  let foot = (px, 0)
  line(north, height, point, close: true, fill: stipple)
  line(point, foot, image, close: true, fill: stipple)
  circle((0, 0), radius: radius, stroke: thick-line)
  arrowed((-19.5, 0), (48, 0))
  arrowed((0, -24.5), (0, 27.8), name: "z")
  for p in (north, height, (0, 0), (0, -radius), point, (radius, 0), image) {
    spot(p, radius: 1.1)
  }
  cetz.decorations.flat-brace(
    (-1.8, pz + 0.8),
    (-1.8, radius - 0.8),
    amplitude: 1.2,
    name: "gap",
  )
  content("z.end", $z$, anchor: "north-east")
  content(point, $P(x, y, z)$, anchor: "south-west", padding: 1.2)
  content((0, 0), $O$, anchor: "north-east", padding: 1.6)
  content((0, -radius), $S$, anchor: "north-west", padding: 1.4)
  content(height, $z$, anchor: "east", padding: 1.6)
  content("gap.content", text(size: 9pt, $1 - z$), anchor: "east", padding: 0.4)
  content(foot, $(x, y)$, anchor: "north", padding: 1.6)
  content(image, $(x', y')$, anchor: "north", padding: 2.2)
})
// Figure 38: the lines of the Poincaré disc, diameters and arcs meeting the
// boundary at right angles, and those of the upper half-plane W, lines and
// half-circles meeting the axis u at right angles; the arrowheads mark their
// points at infinity. The map of the half-plane onto the disc is shown by
// the arrow; the lines drawn are examples, not images of each other.
#let fig-1-38() = drawing({
  import cetz.draw: *
  let heads = (start: "stealth", end: "stealth")
  group({
    let radius = 11.2
    translate((-28.4, 10.3))
    circle((0, 0), radius: radius, fill: stipple, stroke: thick-line)
    for ends in ((240.8deg, 60.8deg), (-79.6deg, 16.4deg)) {
      line(..disc-geodesic(radius, ..ends), stroke: thick-line, mark: heads)
    }
  })
  arrowed((-16.3, 23.7), (-25.5, 23.7))
  rect((-11.5, 0), (27.5, 35), fill: stipple, stroke: none)
  arrowed((-11.5, 0), (27.5, 0), name: "u")
  arrowed((0, -7.5), (0, 35), name: "v")
  line((-8, 34.5), (-8, 0), stroke: thick-line, mark: (end: "stealth"))
  spot((-5.7, 0), radius: 0.5)
  let (centre, radius) = (12.9, 9.3)
  line(
    ..sample(
      t => (centre + radius * calc.cos(t), radius * calc.sin(t)),
      180deg,
      0deg,
    ),
    stroke: thick-line,
    mark: heads,
  )
  content("u.end", $u$, anchor: "north", padding: 1.6)
  content("v.end", cutout($v$), anchor: "north-west", padding: 0.6)
  content((0, 0), $O$, anchor: "north-east", padding: 1.6)
})
// Figure 39: the map w = (z − 1) / (i(z + 1)) of the unit disc onto the
// upper half-plane: −1 goes to ∞, 1 to 0, the boundary point e^(iθ) to
// tg(θ/2). The lines of the half-plane, half-circles about the axis u and
// lines parallel to v, and the lines of the disc they come from: those
// through −1 become the lines parallel to v. Half-plane unit `unit` mm.
#let fig-1-39() = drawing({
  import cetz.draw: *
  let (radius, unit) = (15.9, 15.5)
  // The lines of the half-plane: half-circles by their ends, the lines
  // u = const by their feet.
  let circles = (
    (-16.5, 16.5),
    (-22.7, -4.4),
    (-13.6, -6.5),
    (4.4, 22.7),
    (
      6.5,
      13.6,
    ),
  )
  let verticals = (-2.35, 2.35)
  let angle-of(u) = 2 * calc.atan(u / unit)
  circle((0, 0), radius: radius, fill: stipple, stroke: thick-line)
  arrowed((-23, 0), (23.5, 0), name: "x")
  arrowed((0, -20.3), (0, 25), name: "y")
  let ends = ()
  for (a, b) in circles {
    line(..disc-geodesic(radius, angle-of(a), angle-of(b)), stroke: thick-line)
    ends += (angle-of(a), angle-of(b))
  }
  for c in verticals {
    line(..disc-geodesic(radius, angle-of(c), 180deg), stroke: thick-line)
    ends.push(angle-of(c))
  }
  line((-radius, 0), (radius, 0), stroke: thick-line)
  for t in (..ends, 0deg, 180deg) { spot((t, radius), radius: 0.9) }
  content("x.end", $x$, anchor: "north-west", padding: 0.8)
  content("y.end", $y$, anchor: "north-east")
  for (side, number, image) in ((-1, $-1$, $oo$), (1, $1$, $0$)) {
    let at = side * (radius + 2.6)
    content((at, 0), number, anchor: "north", padding: 1)
    arrowed((at, -4), (at, -10.5))
    content((at, -10.5), image, anchor: "north", padding: 1)
  }
  arrowed((14.8, 13.6), (23.9, 13.6))
  // The half-plane about its origin.
  group({
    translate((52.8, -5.5))
    rect((-26, 0), (25.5, 28), fill: stipple, stroke: none)
    arrowed((-26, 0), (29.1, 0), name: "u")
    arrowed((0, -6.4), (0, 27.5), name: "v")
    let feet = (0,)
    for (a, b) in circles {
      let (centre, size) = ((a + b) / 2, (b - a) / 2)
      line(
        ..sample(
          t => (centre + size * calc.cos(t), size * calc.sin(t)),
          0deg,
          180deg,
        ),
        stroke: thick-line,
      )
      feet += (a, b)
    }
    for c in verticals {
      line((c, 0), (c, 24.8), stroke: thick-line)
      content(
        (c, 24.8),
        cutout($oo$),
        anchor: if c < 0 { "south-east" } else { "south-west" },
        padding: 0.3,
      )
      feet.push(c)
    }
    for u in feet { spot((u, 0), radius: 0.9) }
    content("u.end", $u$, anchor: "north", padding: 1.6)
    content("v.end", cutout($v$), anchor: "south", padding: 0.5)
    content((0, 0), $O$, anchor: "north-east", padding: 1.6)
  })
})
// Figure 40: the line of the upper half-plane through two points P₁, P₂:
// the half-circle about the point C of the axis where the perpendicular
// bisector of P₁P₂ meets it; the arc P₁P₂ bold. Two points on a line
// at a right angle to the axis lie on that line.
#let fig-1-40() = drawing({
  import cetz.draw: *
  let (first, second) = ((-16.7, 4.6), (0, 17.6))
  let (x1, y1, x2, y2) = (..first, ..second)
  let centre = (
    (x2 * x2 + y2 * y2 - x1 * x1 - y1 * y1) / (2 * (x2 - x1)),
    0,
  )
  let radius = calc.norm(..vec-add(second, vec-scale(-1, centre)))
  let angle(p) = calc.atan2(..vec-add(p, vec-scale(-1, centre)))
  let on-circle(t) = vec-add(centre, (
    radius * calc.cos(t),
    radius * calc.sin(t),
  ))
  rect((-21.4, 0), (33.5, 29.8), fill: stipple, stroke: none)
  arrowed((-21.4, 0), (36.1, 0))
  line(..sample(on-circle, 180deg, 0deg), mark: (
    start: "stealth",
    end: "stealth",
  ))
  line(..sample(on-circle, angle(first), angle(second)), stroke: thick-line)
  line(first, second)
  line(centre, on-circle((angle(first) + angle(second)) / 2))
  for p in (first, second, centre) { spot(p, radius: 0.9) }
  content(first, cutout($P_1$), anchor: "east", padding: 1.6)
  content(second, cutout($P_2$), anchor: "south", padding: 1.6)
  // Two points on a line at a right angle to the axis.
  let foot = 26.5
  line((foot, -6.6), (foot, 0))
  arrowed((foot, 0), (foot, 29.8), stroke: thick-line)
  for (height, name) in ((20.9, $P_1$), (7, $P_2$)) {
    spot((foot, height), radius: 0.9)
    content((foot, height), cutout(name), anchor: "east", padding: 1.6)
  }
})
// Figure 41: a broken line of segments of lines P…A, A B, B C, C Q is
// shortened by replacing the two links A B, B C by A C (dashed); the
// triangle ABC stippled. A schematic: each segment is drawn as the arc of
// a circle through its ends and a point between them.
#let fig-1-41() = drawing({
  import cetz.draw: *
  let (p, bend, a, b, c, q) = (
    (-17.6, -22.4),
    (-10, -6.5),
    (-0.3, 3.8),
    (13.2, 10.2),
    (12.7, -24),
    (25.4, -25),
  )
  // The points between the ends of the segments.
  let via = (
    pb: (-11.6, -13.8),
    ba: (-4, -2),
    ab: (7.3, 6.2),
    bc: (15.9, -8.2),
    ca: (6.2, -6.5),
    cq: (19.4, -23),
  )
  merge-path(fill: stipple, stroke: none, {
    arc-through(a, via.ab, b)
    arc-through(b, via.bc, c)
    arc-through(c, via.ca, a)
  })
  arc-through(p, via.pb, bend, stroke: 0.8 * thick-line)
  arc-through(bend, via.ba, a, stroke: 0.8 * thick-line)
  arc-through(c, via.cq, q, stroke: 0.8 * thick-line)
  arc-through(a, via.ab, b, stroke: thick-line)
  arc-through(b, via.bc, c, stroke: 1.6 * thick-line)
  arc-through(c, via.ca, a, stroke: (
    thickness: 0.8 * thick-line,
    dash: hidden.stroke.dash,
  ))
  for point in (p, bend, a, b, c, q) { spot(point, radius: 1.1) }
  content(a, $A$, anchor: "south-east", padding: 1.4)
  content(b, $B$, anchor: "south", padding: 1.6)
  content(c, $C$, anchor: "north", padding: 1.6)
  content(q, $Q$, anchor: "south-west", padding: 1)
  content(p, $P$, anchor: "north", padding: 1.6)
})
