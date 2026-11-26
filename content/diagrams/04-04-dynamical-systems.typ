// Figures of chapter 4, § 4. Each is a function called by the text:
// `#fig(fig-4-61()) <fig:…>`.
#import "common.typ": *

// The point of the polyline `points` at `at` along it and the direction of
// the polyline there: `at` a ratio of its length, or a length from its
// start (from its end if negative).
#let flow-point-along(points, at) = {
  let lengths = range(1, points.len()).map(i => {
    let ((x0, y0), (x1, y1)) = (points.at(i - 1), points.at(i))
    calc.sqrt(calc.pow(x1 - x0, 2) + calc.pow(y1 - y0, 2))
  })
  let total = lengths.sum()
  let goal = if type(at) == ratio { at / 100% * total } else if at < 0 {
    total + at
  } else { at }
  let travelled = 0
  for (i, d) in lengths.enumerate() {
    if travelled + d >= goal or i == lengths.len() - 1 {
      let s = if d == 0 { 0 } else { calc.min(1, (goal - travelled) / d) }
      let ((x0, y0), (x1, y1)) = (points.at(i), points.at(i + 1))
      return (
        (x0 + s * (x1 - x0), y0 + s * (y1 - y0)),
        calc.atan2(x1 - x0, y1 - y0),
      )
    }
    travelled += d
  }
}

// The arrowhead of the book on the polyline `points`, its tip at `at`
// along it (as in `flow-point-along`), pointing along the polyline.
#let flow-arrow(points, at, ..style) = {
  let (tip, direction) = flow-point-along(points, at)
  cetz.draw.mark(tip, direction, symbol: "stealth", ..style)
}

// A bold path given by its points with the arrowhead of the book, larger to
// match, at `at` along it (figs. 67, 70, 71).
#let flow-bold-path(points, at) = {
  cetz.draw.line(..points, stroke: 1.5 * thick-line)
  flow-arrow(points, at, scale: 1.25)
}

// The parameter where the curve t ↦ f(t) leaves the region `inside`
// between t-in (inside) and t-out (outside), by bisection.
#let flow-boundary(f, inside, t-in, t-out) = {
  for _ in range(40) {
    let middle = (t-in + t-out) / 2
    if inside(f(middle)) { t-in = middle } else { t-out = middle }
  }
  t-in
}

// An integral curve of the plane field `field`, (x, y) ↦ (u, v), from
// `start`: the fixed-step Runge–Kutta method of order 4 for the field
// scaled to unit speed, so that the points are `step` apart along the
// curve. It stops after `steps` steps, where `inside` fails or where the
// field vanishes. A negative step runs the curve backwards.
#let flow-curve(field, start, step, steps, inside: p => true) = {
  let unit((x, y)) = {
    let (u, v) = field((x, y))
    let speed = calc.sqrt(u * u + v * v)
    if speed < 1e-9 { none } else { (u / speed, v / speed) }
  }
  let points = (start,)
  let (x, y) = start
  for _ in range(steps) {
    let k1 = unit((x, y))
    if k1 == none { break }
    let k2 = unit((x + step / 2 * k1.at(0), y + step / 2 * k1.at(1)))
    if k2 == none { break }
    let k3 = unit((x + step / 2 * k2.at(0), y + step / 2 * k2.at(1)))
    if k3 == none { break }
    let k4 = unit((x + step * k3.at(0), y + step * k3.at(1)))
    if k4 == none { break }
    x += step / 6 * (k1.at(0) + 2 * k2.at(0) + 2 * k3.at(0) + k4.at(0))
    y += step / 6 * (k1.at(1) + 2 * k2.at(1) + 2 * k3.at(1) + k4.at(1))
    if not inside((x, y)) { break }
    points.push((x, y))
  }
  points
}

// The rays of the star of figs. 61 and 62: `count` directions evenly
// spaced from the x-axis.
#let flow-star-directions(count) = range(count).map(i => i * 360deg / count)

// Figure 61: the source, the gradient of f = x² + y², grad f = (2x, 2y):
// the integral trajectories are the rays from O, run outwards; the
// arrowhead on each at `head` from O.
#let fig-4-61() = lettered-drawing({
  import cetz.draw: *
  let (reach, head) = (20.2, 19.2)
  set-style(stroke: thick-line)
  for direction in flow-star-directions(16) {
    line((0, 0), (direction, reach))
    mark((direction, head), direction, symbol: "stealth")
  }
})

// Figure 62: the sink, the gradient of f = −x² − y², grad f = (−2x, −2y):
// the rays into O, an arrowhead on each at `head` from O.
#let fig-4-62() = lettered-drawing({
  import cetz.draw: *
  let (reach, head) = (20.2, 14)
  set-style(stroke: thick-line)
  for direction in flow-star-directions(16) {
    line((0, 0), (direction, reach))
    mark((direction, head), direction + 180deg, symbol: "stealth")
  }
})

// Figure 63: the saddle, the gradient of f = −x² + y², grad f = (−2x, 2y):
// the integral trajectories are the hyperbolas xy = c, run from the x-axis
// towards the y-axis, and the half-axes. They fill the rectangle |x| ≤
// `wide`, |y| ≤ `high` with its corners cut off by the circle of radius
// `corner`; the x-axis runs on past it by `overshoot`. The hyperbolas cross
// the diagonals at evenly spaced points. An arrowhead near the start of
// each hyperbola, another at its end; the arrowheads narrower than usual,
// as printed, for the curves crowd.
#let fig-4-63() = lettered-drawing({
  import cetz.draw: *
  let (wide, high, corner, overshoot) = (20.6, 20.7, 23.3, 3)
  let inside((x, y)) = (
    calc.abs(x) <= wide
      and calc.abs(y) <= high
      and x * x + y * y <= corner * corner
  )
  let crossings = range(5).map(k => 7.6 + 3.4 * k)
  set-style(stroke: thick-line, mark: (width: 1.1))
  let trajectory(points, enters: true, leaves: true) = {
    line(..points, mark: (end: if leaves { "stealth" }))
    if enters { flow-arrow(points, 5) }
  }
  for side in (1, -1) {
    let half-axis = ((side * (wide + overshoot), 0), (0, 0))
    line(..half-axis)
    flow-arrow(half-axis, 50%)
    trajectory(((0, 0), (0, side * high)), enters: false)
    for other in (1, -1) {
      for r in crossings {
        // xy = c through the point at r on the diagonal.
        let root = r / calc.sqrt(2)
        let f(s) = (side * root * calc.exp(-s), other * root * calc.exp(s))
        trajectory(sample(
          f,
          flow-boundary(f, inside, 0, -5),
          flow-boundary(f, inside, 0, 5),
          n: 60,
        ))
      }
    }
  }
  spot((0, 0), radius: 0.8)
  content((wide + overshoot, 0), $x$, anchor: "south-east")
  content((0, 0.65 * high), $y$, anchor: "east", padding: 0.4)
})
// The parabolic arc s ↦ (1 − s)² p0 + 2s(1 − s) c + s² p1, s ∈ [0, 1]
// (the quadratic Bézier curve with the control point c).
#let flow-parabola(p0, c, p1) = s => range(2).map(j => (
  (1 - s) * (1 - s) * p0.at(j) + 2 * s * (1 - s) * c.at(j) + s * s * p1.at(j)
))

// Shadings of the sheets of fig. 64 on a black ground: thin white lines
// 0.5 mm apart rising at 25°, and white dots 0.6 mm apart.
#let flow-white-hatching = line-hatching(25deg, 0.5mm, stroke: 0.13mm + white)
#let flow-white-stipple = dot-stipple(
  0.6mm,
  radius: 0.09mm,
  offset: 0.2mm,
  paint: white,
)

// Figure 64: an integral trajectory cannot cross a level surface of an
// integral. The level surfaces f = c are a stack of five sheets `gap`
// apart, translates of one curved sheet over the unit square of (u, v),
// z = arch · sin πu + bow · u sin πv (arched along its length, its right
// edge bowed), in an oblique view; shaded from white to black, each hides
// the ones below; their outlines bold. A trajectory pierces the top sheet
// twice (the dots) and runs under it between them (dashed); the field
// vectors on the sheet are tangent to it. The trajectory is a smooth curve
// through a few points of the view, the vectors run between points of the
// sheet.
#let fig-4-64() = lettered-drawing({
  import cetz.draw: *
  // The images of the sheet's length, depth and of the unit vector up.
  let at = projection((35.7, -4.5), (9.5, 16.4), (-0.26, 0.966))
  let (arch, bow, gap) = (2, 1.5, 5.5)
  let on-sheet(k, u, v) = at((
    u,
    v,
    arch * calc.sin(u * 180deg) + bow * u * calc.sin(v * 180deg) - k * gap,
  ))
  let shades = (
    (white,),
    (white, stipple),
    (black, flow-white-hatching),
    (black, flow-white-stipple),
    (black,),
  )
  for k in range(shades.len()).rev() {
    let edge(v) = sample(u => on-sheet(k, u, v), 0, 1, n: 30)
    let outline = (..edge(0), ..edge(1).rev())
    for shade in shades.at(k) {
      line(..outline, close: true, fill: shade, stroke: thick-line)
    }
  }
  // The field on the top sheet: strokes from (u, v) to (u′, v′), the
  // arrowhead short of the end.
  for (u, v, u-end, v-end) in (
    (0.60, 0.17, 0.86, 0.67),
    (0.63, 0.15, 0.91, 0.62),
    (0.66, 0.13, 0.945, 0.55),
    (0.69, 0.11, 0.99, 0.44),
  ) {
    let stroke = (on-sheet(0, u, v), on-sheet(0, u-end, v-end))
    line(..stroke)
    flow-arrow(stroke, 85%)
  }
  // The trajectory: over the sheet to the first piercing point, under it
  // to the second, and over it away; the parts over the sheet part the
  // edges they cross.
  let (enters, leaves) = (2, 4)
  let pieces = spline-pieces(
    (
      (-7.7, 6.6),
      (7.1, 11.6),
      (15.3, 9.0),
      (20.4, 4.9),
      (28.3, 12.7),
      (31.0, 16.1),
      (36.8, 18.8),
      (43.1, 20.1),
    ),
    n: 12,
  )
  let run(from, to) = pieces.slice(from, to).join()
  let (before, under, after) = (
    run(0, enters),
    run(enters, leaves),
    run(leaves, pieces.len()),
  )
  set-style(stroke: thick-line)
  for points in (before, after) {
    line(..points, stroke: (paint: white, thickness: 1.8mm, cap: "butt"))
  }
  line(..before)
  line(..under, ..fine-dash)
  line(..after, mark: (end: "stealth"))
  spot(under.first(), radius: 0.8)
  spot(under.last(), radius: 0.8)
})
// Figure 65: two integrals f and g; a trajectory lies on f = c and on
// g = α. The surface f = c is an arched band with a thin rim, the ruled
// surface between its front and back edges, parabolic arcs s ↦ F(s), B(s)
// in the view (quadratic Bézier curves by their ends and middle control
// points); the surfaces g = α are three vertical planes through its rulings
// F(s)B(s) at s in `planes`, black; the verticals of the view run to the
// vanishing point `vanish` far below. Below the band a plane is hidden:
// where it shows through the band it is stippled, its hidden edge dashed;
// below the front edge it is seen again.
#let fig-4-65() = lettered-drawing({
  import cetz.draw: *
  let front = flow-parabola((0, 0), (25.5, 6.3), (55.8, -6.6))
  let back = flow-parabola((8.2, 14.6), (28.6, 18.5), (56.6, 10.8))
  let planes = (0.27, 0.5, 0.73)
  let (above, below, rim) = (13.5, 16, 0.8)
  let vanish = (31, -200)
  let front-edge = sample(front, 0, 1, n: 60)
  // A point moved down by `depth` along its vertical.
  let lowered(points, depth) = points.map(((x, y)) => {
    let (dx, dy) = (x - vanish.at(0), y - vanish.at(1))
    let d = calc.sqrt(dx * dx + dy * dy)
    (x - depth * dx / d, y - depth * dy / d)
  })
  let raised(points, height) = lowered(points, -height)
  for s in planes {
    let ruling = (front(s), back(s))
    line(..ruling, ..lowered(ruling, below).rev(), fill: black, close: true)
  }
  // The band: its top white, the rim black.
  line(..front-edge, ..sample(back, 1, 0, n: 60), close: true, fill: white)
  line(..front-edge, ..lowered(front-edge, rim).rev(), close: true, fill: black)
  for s in planes {
    let (near, far) = (front(s), back(s))
    // The front edge from `near` to where the vertical under `far` meets it.
    let (fx, fy) = far.zip(vanish).map(((a, b)) => a - b)
    let reach = flow-boundary(
      front,
      ((x, y)) => fx * (y - vanish.at(1)) - fy * (x - vanish.at(0)) > 0,
      s,
      1,
    )
    let along = sample(front, s, reach, n: 12)
    line(far, ..along.rev(), close: true, fill: stipple, stroke: none)
    line(far, along.last(), ..fine-dash)
    let ruling = (near, far)
    line(..ruling, ..raised(ruling, above).rev(), fill: black, close: true)
  }
  let last = planes.last()
  content(
    (raised((back(last),), above).first(), 60%, back(last)),
    $g = alpha$,
    anchor: "west",
  )
  content((front(1), 30%, back(1)), $f = c$, anchor: "east", padding: 2.5)
})

// Figure 66: the rotation of the fluid about the origin, the field
// v(x, y) = (−y, x), not potential. Its integral trajectories are the
// circles about O, evenly spaced; where they cross the axes the field is
// drawn to the scale `scale`, the arrowheads short of the ends and smaller
// on the short vectors.
#let fig-4-66() = lettered-drawing({
  import cetz.draw: *
  let radii = range(6).map(k => 2.5 + 3.1 * k)
  let (scale, wide, high) = (0.54, 20.4, 22.7)
  set-style(stroke: 1pt)
  line((-wide, 0), (wide, 0))
  line((0, -high), (0, high))
  for r in radii {
    circle((0, 0), radius: r)
    let head = calc.min(2.5, 0.6 * scale * r)
    set-style(mark: (length: head, width: 0.4 * head, inset: 0.3 * head))
    for turn in range(4).map(k => k * 90deg) {
      let (x, y) = (r * calc.cos(turn), r * calc.sin(turn))
      let vector = ((x, y), (x - scale * y, y + scale * x))
      line(..vector)
      flow-arrow(vector, 75%)
    }
  }
})

// Figure 67: the infinitely small rectangle with the sides dx, dy at the
// point (x, y), stippled, and the field vector v⃗(x, y) there.
#let fig-4-67() = lettered-drawing({
  import cetz.draw: *
  let (width, height) = (29.0, 17.2)
  let field = (33.4, 25.4)
  rect((0, 0), (width, height), fill: stipple, stroke: 1pt)
  arrowed((-3.5, 0), (38.7, 0), name: "x")
  arrowed((0, -3.7), (0, 25), name: "y")
  line((0, 0), field, stroke: 1pt, name: "v")
  flow-arrow(((0, 0), field), 92%)
  flow-bold-path(((0, 0), (width, 0)), 100%)
  flow-bold-path(((0, 0), (0, height)), 100%)
  hide(line((0, 0), (width, 0), name: "dx"))
  hide(line((0, 0), (0, height), name: "dy"))
  spot((0, 0), radius: 0.9)
  content("x.end", $x$, anchor: "north-east")
  content("y.end", $y$, anchor: "north-west")
  content("dx.mid", $d x$, anchor: "north")
  content("dy.mid", $d y$, anchor: "east")
  content((0, 0), $(x, y)$, anchor: "north-east")
  content("v.88%", $arrow(v)(x, y)$, anchor: "north-west")
})

// Figure 68: the shift f_Δt along the trajectories takes the infinitely
// small parallelogram Γ to the rectangle (dx, dy) at P. Γ is the image of
// the rectangle under the linear map `shift-back` (the differential of
// f₋Δt), its sides the images of dx and dy; both hatched.
#let fig-4-68() = lettered-drawing({
  import cetz.draw: *
  let (width, height) = (28.5, 16.3)
  let shift-back = ((0.97, 0.208), (0.416, 1.177))
  let image((x, y)) = shift-back.map(((a, b)) => a * x + b * y)
  let hatching = line-hatching(-35deg, 0.8mm, stroke: 0.35mm + black)
  let point-p = (39.2, 3.56)
  // A bold edge with the arrowhead short of its end.
  let side(from, to) = {
    line(from, to, stroke: 1.5 * thick-line)
    flow-arrow((from, to), 92%)
  }
  // Γ about the origin.
  let (along-x, along-y) = (image((width, 0)), image((0, height)))
  let far = image((width, height))
  line((0, 0), along-x, far, along-y, close: true, fill: hatching)
  side((0, 0), along-x)
  side((0, 0), along-y)
  spot((0, 0), radius: 0.9)
  content((along-y, 25%, far), $Gamma$, anchor: "south", padding: 2.5)
  // The rectangle at P with the axes through P.
  group({
    translate(point-p)
    line((-1.5, 0), (32.5, 0))
    line((0, -3.6), (0, 23.8))
    rect((0, 0), (width, height), fill: hatching)
    side((0, 0), (width, 0))
    side((0, 0), (0, height))
    spot((0, 0), radius: 0.9)
    content((0, 0), $P$, anchor: "north-east")
    content((0, height), $d y$, anchor: "south-east")
    content((width, 0), $d x$, anchor: "north-east")
  })
  // The shift f_Δt from Γ to the rectangle.
  let shift = sample(
    flow-parabola((21.45, 7.34), (28.1, 6.4), (36.4, 8.75)),
    0,
    1,
    n: 30,
  )
  line(..shift)
  flow-arrow(shift, 92%)
  content(shift.at(6), $f_(Delta t)$, anchor: "north", padding: 1.5)
})
// Figure 69: the circulation of a flow along a contour C. The flow is
// v(x, y) = (1, k y) about the point γ(t) of C at the origin: its
// trajectories y = c e^(kx), at evenly spaced c, fill an oval region (an
// ellipse turned by `tilt`). C is a free-hand closed curve (through a few
// points) with the velocity γ̇(t) upwards at the origin; the angle between
// γ̇(t) and v(γ(t)) stippled.
#let fig-4-69() = lettered-drawing({
  import cetz.draw: *
  let (k, spacing) = (0.03, 6.7)
  let (centre, semi-axes, tilt) = ((-11.4, 4.5), (27, 21.5), 62deg)
  let inside((x, y)) = {
    let (dx, dy) = (x - centre.at(0), y - centre.at(1))
    let along = dx * calc.cos(tilt) + dy * calc.sin(tilt)
    let across = -dx * calc.sin(tilt) + dy * calc.cos(tilt)
    (
      calc.pow(along / semi-axes.at(0), 2)
        + calc.pow(across / semi-axes.at(1), 2)
        <= 1
    )
  }
  for j in range(-9, 10) {
    let f(x) = (x, j * spacing * calc.exp(k * x))
    // The run of the trajectory inside the region, from its first point
    // inside (searched across the width of the region) to where it leaves.
    let xs = range(201).map(i => -45 + 70 * i / 200)
    let first = xs.position(x => inside(f(x)))
    if first == none { continue }
    let x-in = flow-boundary(f, inside, xs.at(first), xs.at(calc.max(
      first - 1,
      0,
    )))
    let x-out = flow-boundary(f, inside, xs.at(first), 30)
    line(..sample(f, x-in, x-out, n: 40), stroke: 1pt)
  }
  let (velocity, field) = ((0, 24), (16.9, 0))
  cetz.angle.angle((0, 0), field, velocity, radius: 5.6, fill: stipple)
  hobby(
    (0, 0),
    (-1.85, 10.85),
    (-6.6, 18.3),
    (-14.0, 22.2),
    (-15.5, 20.0),
    (-14.6, 11.0),
    (-16.9, 1.3),
    (-19.2, -6.6),
    (-17.2, -12.2),
    (-12.4, -13.1),
    (-8.2, -8.5),
    (-2.4, -4.5),
    close: true,
    stroke: 2 * thick-line,
    name: "contour",
  )
  arrowed((0, 0), velocity, stroke: thick-line, name: "velocity")
  arrowed((0, 0), field, stroke: 1.5 * thick-line, name: "field")
  spot((0, 0), radius: 1.1)
  content("velocity.80%", $dot(gamma)(t)$, anchor: "west")
  content("field.65%", $arrow(v)(gamma(t))$, anchor: "north")
  content((-18.8, -9.8), cutout($C$), anchor: "east", padding: 1.5)
})
// Figure 70: two paths from (0, 0) to (x, y) along the sides of the
// rectangle they span, stippled: γ = γ₁ ∪ γ₂ up and across, γ′ = γ′₁ ∪ γ′₂
// across and up.
#let fig-4-70() = lettered-drawing({
  import cetz.draw: *
  let corner = (29.8, 18.1)
  let (x-corner, y-corner) = ((corner.at(0), 0), (0, corner.at(1)))
  rect((0, 0), corner, fill: stipple, stroke: none)
  arrowed((-5.7, 0), (38.3, 0), name: "x")
  arrowed((0, -4), (0, 31.3), name: "y")
  for (name, from, to) in (
    ("gamma-1", (0, 0), y-corner),
    ("gamma-2", y-corner, corner),
    ("gamma-1-prime", (0, 0), x-corner),
    ("gamma-2-prime", x-corner, corner),
  ) {
    flow-bold-path((from, to), 85%)
    hide(line(from, to, name: name))
  }
  spot((0, 0), radius: 1)
  spot(corner, radius: 1)
  content("x.end", $x$, anchor: "north-east")
  content("y.end", $y$, anchor: "north-west")
  content((0, 0), $(0, 0)$, anchor: "north-east")
  content(corner, $(x, y)$, anchor: "south", padding: 2)
  content("gamma-1.mid", $gamma_1$, anchor: "east", padding: 1.5)
  content("gamma-2.60%", $gamma_2$, anchor: "south", padding: 1.5)
  content("gamma-1-prime.90%", $gamma'_1$, anchor: "north", padding: 1.5)
  content("gamma-2-prime.40%", $gamma'_2$, anchor: "west", padding: 1.5)
})

// Figure 71: two paths γ and γ′ from 0 to (x, y), free-hand smooth curves
// through a few points; γ ∪ (−γ′) bounds the stippled region, −γ′ runs
// back from (x, y) to 0.
#let fig-4-71() = lettered-drawing({
  import cetz.draw: *
  let end = (35.1, 15.0)
  let upper = spline-pieces(
    (
      (0, 0),
      (6.6, 8.0),
      (10.8, 19.5),
      (16.3, 19.9),
      (23.1, 15.2),
      (27.7, 16.7),
      (31.5, 16.5),
      end,
    ),
    n: 12,
  ).join()
  let lower = spline-pieces(
    (
      (0, 0),
      (7.0, 3.0),
      (16.3, 2.8),
      (24.8, 3.0),
      (26.9, 8.0),
      (28.6, 11.5),
      end,
    ),
    n: 12,
  ).join()
  line(..upper, ..lower.rev(), close: true, fill: stipple, stroke: none)
  arrowed((-4, 0), (45.7, 0), name: "x")
  arrowed((0, -3.4), (0, 22.9), name: "y")
  flow-bold-path(upper, 87%)
  flow-bold-path(lower.rev(), 15%)
  spot((0, 0), radius: 1)
  spot(end, radius: 1)
  content("x.end", $x$, anchor: "south-east", padding: 1.5)
  content("y.end", $y$, anchor: "north-east")
  content((0, 0), $0$, anchor: "south-east", padding: 1.5)
  content(end, $(x, y)$, anchor: "west", padding: 1.5)
  content(
    flow-point-along(upper, 85%).first(),
    $gamma$,
    anchor: "south",
    padding: 2.5,
  )
  content(
    flow-point-along(lower, 88%).first(),
    $-gamma'$,
    anchor: "north-west",
    padding: 1.5,
  )
})

// The point at the polar angle `turn` and the distance `r`.
#let flow-polar(turn, r) = (r * calc.cos(turn), r * calc.sin(turn))

// A curve s ↦ p(s) on [a, b], sampled densely at the ends (where the
// curves of figs. 72 and 73 turn fast).
#let flow-sample-ends(p, a, b, n: 48) = sample(
  u => p(a + (b - a) * (1 - calc.cos(u * 180deg)) / 2),
  0,
  1,
  n: n,
)

// Figure 72: the flow grad a of f = z⁴ = a + ib, a = r⁴ cos 4φ. Its
// integral trajectories are the level lines of b = r⁴ sin 4φ: the eight
// rays φ = kπ/4 (b = 0) and in each sector between them the curves
// r⁴ sin 4(φ − kπ/4) = c, all within the disc of `radius` R, at the
// levels whose points nearest to O lie at the fractions `nearest` of R.
// Towards the circle the curves crowd onto the rays. The flow runs out
// along the axes, in along the diagonals. Two arrowheads on each curve,
// where the curves are still apart, and one near the end of each ray.
#let fig-4-72() = lettered-drawing({
  import cetz.draw: *
  let radius = 23.2
  let nearest = (0.42, 0.58, 0.74, 0.9)
  set-style(stroke: thick-line, mark: (width: 1.1))
  let trajectory(points) = {
    line(..points)
    flow-arrow(points, 30%)
    flow-arrow(points, 75%)
  }
  for k in range(8) {
    let side = k * 45deg
    // Out along the axes, in along the diagonals.
    let ray = ((0, 0), flow-polar(side, radius))
    line(..ray)
    if calc.even(k) { flow-arrow(ray, -1) } else { flow-arrow(ray.rev(), 4) }
    for fraction in nearest {
      // s = 4(φ − side), r = R (t / sin s)^(1/4) ≤ R.
      let t = calc.pow(fraction, 4)
      let s-in = calc.asin(t)
      let point(s) = flow-polar(
        side + s / 4,
        radius * calc.pow(t / calc.sin(s), 0.25),
      )
      let points = flow-sample-ends(point, s-in, 180deg - s-in)
      // From the diagonal to the axis.
      trajectory(if calc.even(k) { points.rev() } else { points })
    }
  }
})

// Figure 73: the flow grad a of f = z⁻⁴ = a + ib, a = r⁻⁴ cos 4φ. Its
// integral trajectories are the level lines of b = −r⁻⁴ sin 4φ: the eight
// rays φ = kπ/4 and in each sector between them the petals
// r = ρ (sin 4(φ − kπ/4))^(1/4) through O, ρ at the fractions `reaches` of
// `radius`; within the disc of `radius`, the larger petals cut off by the
// circle. The flow runs in along the axes and out along the diagonals.
#let fig-4-73() = lettered-drawing({
  import cetz.draw: *
  let radius = 23.6
  let reaches = (0.3, 0.48, 0.66, 0.84, 1.08, 1.3)
  set-style(stroke: thick-line)
  for k in range(8) {
    let side = k * 45deg
    let ray = ((0, 0), flow-polar(side, radius))
    line(..ray)
    if calc.even(k) { flow-arrow(ray.rev(), 3.5) } else {
      flow-arrow(ray, -1.5)
    }
    for fraction in reaches {
      let petal(s) = flow-polar(
        side + s / 4,
        fraction * radius * calc.pow(calc.sin(s), 0.25),
      )
      if fraction <= 1 {
        line(..flow-sample-ends(petal, 0deg, 180deg, n: 90))
      } else {
        // The parts inside the circle, from O out to it.
        let s-out = calc.asin(calc.pow(1 / fraction, 4))
        line(..flow-sample-ends(petal, 0deg, s-out))
        line(..flow-sample-ends(petal, 180deg, 180deg - s-out))
      }
    }
  }
})
// Figure 74: the logarithmic singularity, f = ln z = ln r + iφ. The
// integral trajectories of v = grad ln r are the rays from O, those of
// ṽ = grad φ the circles about O: six rays 60° apart, bold, and evenly
// spaced circles.
#let fig-4-74() = lettered-drawing({
  import cetz.draw: *
  let radii = range(6).map(k => 2.5 + 2.66 * k)
  let reach = 19.2
  for r in radii { circle((0, 0), radius: r, stroke: 0.9pt) }
  set-style(stroke: thick-line)
  for turn in (0deg, 60deg, 120deg) {
    line(flow-polar(turn, reach), flow-polar(turn + 180deg, reach))
  }
})

// The level line b = c of b = Im(z + 1/z) = (r − 1/r) sin φ (figs. 75,
// 81) as φ ↦ z: r = (k + √(k² + 4))/2, k = c/sin φ, inside the unit
// circle (k < 0) in the form that stays exact as r → 0.
#let flow-joukowski-level(c) = turn => {
  let s = calc.sin(turn)
  let r = if c * s <= 0 {
    2 * calc.abs(s) / (calc.abs(c) + calc.sqrt(c * c + 4 * s * s))
  } else { (c / s + calc.sqrt(c * c / (s * s) + 4)) / 2 }
  flow-polar(turn, r)
}

// Figure 75: Zhukovsky's function f = z + 1/z, a = (r + 1/r) cos φ. The
// integral trajectories of grad a are the level lines of
// b = (r − 1/r) sin φ: the real axis and the unit circle (b = 0), bold,
// with the stagnation points ±1 where f′ = 0; outside the circle the flow
// past it, inside the loops of the dipole at 0; the unit is `unit`. Outside,
// evenly spaced levels within the rectangle `left` ≤ x ≤ `right`,
// |y| ≤ `high`; inside, the loops whose tops on the y-axis are evenly
// spaced.
#let fig-4-75() = lettered-drawing({
  import cetz.draw: *
  let unit = 13.3
  let (left, right, high) = (-24.4, 28.3, 22.5)
  let (outer-step, outer-count, inner-count) = (0.128, 9, 10)
  let level-line(c) = turn => flow-joukowski-level(c)(turn).map(v => unit * v)
  let in-frame((x, y)) = left <= x and x <= right
  set-style(stroke: thick-line, mark: (width: 1.1))
  for side in (1, -1) {
    // Outside: from the left edge to the right edge, φ from π to 0.
    for j in range(1, outer-count + 1) {
      let curve = level-line(side * j * outer-step)
      let streamline(t) = curve(side * t)
      let from = flow-boundary(streamline, in-frame, 90deg, 179.9deg)
      let to = flow-boundary(streamline, in-frame, 90deg, 0.1deg)
      line(..sample(streamline, from, to, n: 80), mark: (end: "stealth"))
    }
    // Inside: the loop through 0 whose top is at y = side · h.
    for j in range(1, inner-count + 1) {
      let h = j / (inner-count + 1)
      let curve = level-line(side * (h - 1 / h))
      let points = flow-sample-ends(t => curve(side * t), 180deg, 0deg, n: 60)
      line(..points, stroke: 1pt)
      flow-arrow(points, 50%, scale: 0.6)
    }
  }
  // The real axis: in to −1 and out from +1 outside the circle, from +1
  // through 0 to −1 inside.
  for (ray, at) in (
    (((left, 0), (-unit, 0)), 40%),
    (((unit, 0), (0, 0)), 40%),
    (((0, 0), (-unit, 0)), 65%),
  ) {
    line(..ray)
    flow-arrow(ray, at)
  }
  line((unit, 0), (right, 0), mark: (end: "stealth"))
  // The circle: from −1 over the top and under the bottom to +1.
  circle((0, 0), radius: unit, stroke: 2 * thick-line)
  for side in (1, -1) {
    let arc = sample(t => flow-polar(side * t, unit), 180deg, 0deg, n: 60)
    flow-arrow(arc, 12%, scale: 1.3)
    flow-arrow(arc, 92%, scale: 1.3)
  }
  content((-unit, 0), $-1$, anchor: "north-east", padding: 1.6)
  content((unit, 0), $+1$, anchor: "north-west", padding: 1.6)
})
// Figure 76: the dipole f = (1/α)(ln(z + α) − ln(z − α)). The integral
// trajectories of grad Re f are the level lines of
// Im f = (arg(z + α) − arg(z − α))/α: the circles through ±α and the real
// axis. Evenly spaced levels: the circles that meet the y-axis at
// α tan(kπ/2n), within the ellipse of semi-axes `wide` and `high`.
#let fig-4-76() = lettered-drawing({
  import cetz.draw: *
  let (alpha, wide, high, count) = (9.6, 16.6, 17.6, 22)
  set-style(stroke: thick-line)
  cetz.draw.clip(circle((0, 0), radius: (wide, high)), {
    line((-wide, 0), (wide, 0))
    for k in range(1, count) {
      // The circle through ±α and (0, y), its centre on the y-axis.
      let y = alpha * calc.tan(k * 90deg / count)
      let centre = (0, (y * y - alpha * alpha) / (2 * y))
      circle(centre, radius: (y * y + alpha * alpha) / (2 * y))
      circle((0, -centre.at(1)), radius: (y * y + alpha * alpha) / (2 * y))
    }
  })
})

// Figure 77: the pole of the first order, f = 1/z. The integral
// trajectories of grad Re f are the level lines of Im f = −sin φ/r: the
// circles tangent to the real axis at 0 and the axis itself; the diameters
// in geometric progression, within the rectangle |x| ≤ `wide`, |y| ≤
// `high` with rounded corners.
#let fig-4-77() = lettered-drawing({
  import cetz.draw: *
  let (wide, high, corner) = (13.6, 19.4, 8)
  let (largest, ratio) = (19.2, 1.2)
  set-style(stroke: 1pt)
  cetz.draw.clip(rect((-wide, -high), (wide, high), radius: corner), {
    line((-wide, 0), (wide, 0))
    for k in range(-9, 17) {
      let diameter = largest / calc.pow(ratio, k)
      for side in (1, -1) {
        circle((0, side * diameter / 2), radius: diameter / 2)
      }
    }
  })
})
// The coefficients, constant term first, of the monic polynomial with the
// real roots `roots`.
#let flow-polynomial(roots) = {
  let coefficients = (1,)
  for root in roots {
    let shifted = (0, ..coefficients)
    for (i, c) in coefficients.enumerate() { shifted.at(i) -= root * c }
    coefficients = shifted
  }
  coefficients
}

// The value at the complex point z of the polynomial with the real
// coefficients `coefficients` (constant term first), by Horner's rule.
#let flow-polynomial-value(coefficients, z) = {
  let value = (0, 0)
  for c in coefficients.rev() {
    value = complex-times(value, z)
    value.at(0) += c
  }
  value
}

// The level lines Re P = t, t in `levels`, of the polynomial P with the
// real coefficients `coefficients` within the rectangle with the corners
// `low` and `high`. Re P is harmonic and has no closed level lines, so
// each one meets the boundary of the rectangle: it is traced from a point
// where it enters, along grad Im P = (Im P′, Re P′), which is tangent to
// it, until it leaves; its other end is not traced again.
#let flow-level-lines(
  coefficients,
  levels,
  low,
  high,
  step: 0.05,
  samples: 600,
) = {
  let ((x0, y0), (x1, y1)) = (low, high)
  let derivative = range(1, coefficients.len()).map(i => (
    i * coefficients.at(i)
  ))
  let real-part(p) = flow-polynomial-value(coefficients, p).at(0)
  let tangent(p) = {
    let (u, v) = flow-polynomial-value(derivative, p)
    (v, u)
  }
  let inside((x, y)) = x0 <= x and x <= x1 and y0 <= y and y <= y1
  // The boundary counterclockwise from `low`, by the length along it.
  let (w, h) = (x1 - x0, y1 - y0)
  let perimeter = 2 * (w + h)
  let boundary(s) = {
    let s = calc.rem-euclid(s, perimeter)
    if s <= w { (x0 + s, y0) } else if s <= w + h {
      (x1, y0 + s - w)
    } else if s <= 2 * w + h { (x1 - (s - w - h), y1) } else {
      (x0, y1 - (s - 2 * w - h))
    }
  }
  let curves = ()
  for t in levels {
    let crossings = ()
    for i in range(samples) {
      let (a, b) = (i, i + 1).map(k => k / samples * perimeter)
      let (fa, fb) = (a, b).map(s => real-part(boundary(s)) - t)
      if fa * fb < 0 {
        for _ in range(30) {
          let middle = (a + b) / 2
          if (real-part(boundary(middle)) - t) * fa > 0 { a = middle } else {
            b = middle
          }
        }
        crossings.push(boundary(a))
      }
    }
    let used = crossings.map(_ => false)
    for (i, start) in crossings.enumerate() {
      if used.at(i) { continue }
      let (tx, ty) = tangent(start)
      let probe = (start.at(0) + 1e-6 * tx, start.at(1) + 1e-6 * ty)
      let sign = if inside(probe) { 1 } else { -1 }
      let points = flow-curve(
        p => tangent(p).map(c => sign * c),
        start,
        step,
        calc.ceil(4 * perimeter / step),
        inside: inside,
      )
      let (ex, ey) = points.last()
      for (j, (cx, cy)) in crossings.enumerate() {
        if calc.abs(cx - ex) + calc.abs(cy - ey) < 3 * step {
          used.at(j) = true
        }
      }
      curves.push(points)
    }
  }
  curves
}

// Figure 78: the flow of the polynomial P(z) = (z² − 1)(z² − 9)(z² − 25)
// with six simple real roots, k = 6, in units of `unit`: the level lines of
// Re P, the trajectories of grad Im P. Re P = 0 runs through the roots;
// the levels ±`levels` beyond the extreme values of P between the roots
// give the arches over and under each interval between them and the curves
// beyond the extreme roots. The real axis and the roots are marked.
#let fig-4-78() = lettered-drawing({
  import cetz.draw: *
  let unit = 3.725
  let roots = (-5, -3, -1, 1, 3, 5)
  let levels = (1200, 4800, 19200)
  let (wide, high) = (7.33, 6.44)
  let coefficients = flow-polynomial(roots)
  let at(points) = points.map(((x, y)) => (unit * x, unit * y))
  let zero-lines = flow-level-lines(
    coefficients,
    (0,),
    (-wide, -high),
    (
      wide,
      high,
    ),
  )
  let arches = flow-level-lines(
    coefficients,
    (..levels, ..levels.map(t => -t)),
    (-wide, -high),
    (wide, high),
  )
  line(..at(((-wide, 0), (wide, 0))))
  for points in zero-lines { line(..at(points)) }
  for points in arches { line(..at(points), stroke: 1pt) }
  for root in roots { spot((unit * root, 0), radius: 0.85) }
})
// Figure 79: the roots of P merge, P → z⁵. Left, the level lines of Re P
// for P(z) = z(z² − a²)(z² − b²) (lengths in millimetres): Re P = 0
// through the five roots and the levels ±`levels`, within a rectangle.
// Right, the same for z⁵: the five lines Re z⁵ = 0, at 18° + 36°k, and in
// each sector between them the curves r⁵ |cos 5φ| = c, whose points
// nearest to O lie at the fractions `nearest` of `tip`; cut off by a star
// with its tips on the lines. Between them, the arrow of the deformation.
#let fig-4-79() = lettered-drawing({
  import cetz.draw: *
  let (a, b) = (3.85, 9)
  let roots = (-b, -a, 0, a, b)
  let levels = (1.5e4, 1e5, 6e5, 3e6)
  let (wide, high) = (27.5, 24)
  let coefficients = flow-polynomial(roots)
  let corners = ((-wide, -high), (wide, high))
  set-style(stroke: 1pt)
  line((-wide, 0), (wide, 0))
  for points in flow-level-lines(coefficients, (0,), ..corners, step: 0.2) {
    line(..points)
  }
  for points in flow-level-lines(
    coefficients,
    (..levels, ..levels.map(t => -t)),
    ..corners,
    step: 0.2,
  ) {
    line(..points)
  }
  for root in roots { spot((root, 0), radius: 0.75) }
  // The deformation.
  mark((35.5, 0), 0deg, symbol: "stealth", length: 7, width: 3.6, inset: 1.6)
  // z⁵ about its centre.
  group({
    translate((55.9, 0))
    let (tip, notch) = (24, 18.5)
    let nearest = (0.33, 0.5, 0.65)
    let star = range(20).map(k => flow-polar(
      18deg + k * 18deg,
      if calc.even(k) { tip } else { notch },
    ))
    line((-tip, 0), (tip, 0))
    cetz.draw.clip(line(..star, close: true), {
      for k in range(10) {
        let side = 18deg + k * 36deg
        line((0, 0), flow-polar(side, tip))
        for fraction in nearest {
          // s = 5(φ − side), r = r-min / (sin s)^(1/5).
          let s-in = calc.asin(calc.pow(fraction, 5))
          let point(s) = flow-polar(
            side + s / 5,
            fraction * tip / calc.pow(calc.sin(s), 0.2),
          )
          line(..flow-sample-ends(point, s-in, 180deg - s-in))
        }
      }
    })
  })
})
// The stereographic projection from the north pole N = (0, 0, 1) of the
// unit sphere, inverted: the point of the sphere over z = (x, y).
#let flow-sphere-point((x, y)) = {
  let q = x * x + y * y
  (2 * x / (q + 1), 2 * y / (q + 1), (q - 1) / (q + 1))
}

// The image on the sphere of the line y = c of the plane, a circle through
// N: the point over x = tan u, u ∈ [0°, 180°], N at u = 90°.
#let flow-sphere-line(c) = u => {
  let (s, k) = (calc.sin(u), calc.cos(u))
  let d = s * s + (c * c + 1) * k * k
  (2 * s * k / d, 2 * c * k * k / d, (s * s + (c * c - 1) * k * k) / d)
}

// Figure 80: the flow grad Re z on the sphere S² = ℂ ∪ {∞}. Its
// trajectories, the lines y = c, become circles through N = ∞, tangent
// there: the pole of the first order, at the fractions `ratio`^k of the
// size `largest`, drawn within the angle `cap` of N; near 0, the south
// pole, they are almost parallel, a few drawn on the hidden side. The real
// axis is the great circle through N, S and ±1, its hidden half dashed; N
// is tilted towards the viewer.
#let fig-4-80() = lettered-drawing({
  import cetz.draw: *
  let radius = 17.15
  let view = orthographic(0deg, 52.3deg)
  let at(p) = (view.project)(p.map(c => radius * c))
  let seen(p) = facing(view, p)
  let cap = 28deg
  let near-north(p) = p.at(2) >= calc.cos(cap)
  set-style(stroke: (thickness: thick-line))
  circle((0, 0), radius: radius)
  seen-hidden(
    at,
    seen,
    sample(t => (calc.cos(t), 0, calc.sin(t)), 0deg, 360deg, n: 120),
  )
  set-style(stroke: (thickness: 0.9pt))
  for k in range(-3, 7) {
    for side in (1, -1) {
      let c = side * 4.2 * calc.pow(1.25, k)
      let circle-of = flow-sphere-line(c)
      // The arc about N, u ∈ [90° − w, 90° + w], within the cap.
      let (from, to) = if near-north(circle-of(0deg)) { (0deg, 180deg) } else {
        (
          flow-boundary(circle-of, near-north, 90deg, 0deg),
          flow-boundary(circle-of, near-north, 90deg, 180deg),
        )
      }
      line(..sample(circle-of, from, to, n: 90).map(at))
    }
  }
  // About the south pole (hidden): short stretches of the lines y = c.
  for j in range(6) {
    let c = (j - 2.5) * 0.037
    line(
      ..sample(x => flow-sphere-point((x, c)), -0.2, 0.2, n: 12).map(at),
      ..fine-dash,
    )
  }
})
// A view of the unit sphere: its pole (0, 0, 1) at `pole` and its point
// (1, 0, 0) towards `first`, both given in the frame of the page (x right,
// y up, z towards the viewer). Gives the projection of a point of the
// sphere to the page, at the scale `radius`, and its depth.
#let flow-sphere-view(pole, first, radius) = {
  let unit(u) = u.map(c => c / calc.sqrt(vec-dot(u, u)))
  let n = unit(pole)
  let e1 = unit(first.zip(n).map(((a, b)) => a - vec-dot(first, n) * b))
  let e2 = vec-cross(n, e1)
  let page(point) = range(3).map(i => (
    point.at(0) * e1.at(i) + point.at(1) * e2.at(i) + point.at(2) * n.at(i)
  ))
  (
    project: point => page(point).slice(0, 2).map(v => radius * v),
    depth: point => page(point).at(2),
  )
}

// A curve on the sphere by its `points` drawn in runs: each point gets a
// style by `style-of` (none: not drawn); consecutive runs share a point.
#let flow-styled-runs(at, points, style-of) = {
  let runs = ()
  let previous = none
  for p in points {
    let style = style-of(p)
    if runs.len() == 0 or style != runs.last().at(0) {
      let start = if previous == none { () } else { (previous,) }
      runs.push((style, start))
    }
    runs.last().at(1).push(p)
    previous = p
  }
  for (style, run) in runs {
    if style != none and run.len() > 1 {
      cetz.draw.line(..run.map(at), ..style)
    }
  }
}

// Figure 81: flows on the sphere S² = ℂ ∪ {∞} by the stereographic
// projection. Left, grad Re(z + 1/z): the level lines of
// b = (r − 1/r) sin φ (see fig. 75); each level c ≠ 0 gives a loop through
// ∞ and a loop through 0, the dipoles at the poles; b = 0 gives the great
// circles of the real axis and of the unit circle, crossing at the
// saddles ±1. A qualitative picture, as printed: the loops through the
// visible pole ∞ are drawn where seen and, dashed, near the hidden saddle;
// the loops through the hidden pole 0 only near 0, dashed, and near the
// visible saddle; the great circles in full, dashed where hidden. Right,
// grad Re ln z and grad Im ln z: the meridians through 0 and ∞, 10° apart,
// and the parallels |z| = const 10° apart in ln |z|, a square net, short
// of the poles, where the meridians merge. The
// views are taken from the places of the poles and saddles in the drawing.
#let fig-4-81() = lettered-drawing({
  import cetz.draw: *
  let radius = 20.6
  let north = (0, 0, 1)
  let angle-between(u, v) = calc.acos(calc.clamp(
    vec-dot(u, v),
    -1,
    1,
  ))
  group({
    let view = flow-sphere-view(
      (-0.196, 0.806, 0.559),
      (-0.413, -0.585, 0.697),
      radius,
    )
    let at = view.project
    let seen(p) = (view.depth)(p) > 0
    let south = (0, 0, -1)
    let (shown, hidden-saddle) = if seen((1, 0, 0)) {
      ((1, 0, 0), (-1, 0, 0))
    } else { ((-1, 0, 0), (1, 0, 0)) }
    let near(p, q, angle) = angle-between(p, q) < angle
    let solid = (stroke: 1pt)
    let dashed = (stroke: (thickness: 1pt, dash: (array: (1.3mm, 0.7mm))))
    // The loops of each level ±c, from pole to pole: through ∞ where
    // c sin φ > 0, outside the unit circle, through 0 where it is inside.
    // The loop of the level c through the pole ∞ (`through-north`) or 0,
    // drawn in the style `style-of`. In the plane it is the half of the
    // level line in the half-plane of the sign of c (through ∞) or of −c.
    let loop(c, through-north, style-of) = {
      let upper = (c > 0) == through-north
      let (from, to) = if upper { (0.2deg, 179.8deg) } else {
        (180.2deg, 359.8deg)
      }
      let pole = if through-north { north } else { south }
      let curve = flow-joukowski-level(c)
      let points = (
        pole,
        ..flow-sample-ends(t => flow-sphere-point(curve(t)), from, to, n: 160),
        pole,
      )
      flow-styled-runs(at, points, style-of)
    }
    // The levels chosen as printed: near the separatrices, more of them on
    // the side of ∞ that turns behind the sphere (through the hidden one of
    // ±i), and near the poles.
    let front = if seen((0, 1, 0)) { 1 } else { -1 }
    let near-separatrices = (0.04, 0.1, 0.2)
    let behind = (..near-separatrices, 0.35, 0.55, 0.8, 1.2)
    let near-poles = (5, 7.5, 11, 16, 24)
    let seen-or-near-saddle(p) = if seen(p) { solid } else if near(
      p,
      hidden-saddle,
      30deg,
    ) { dashed }
    for c in (..near-separatrices, ..near-poles) {
      loop(front * c, true, seen-or-near-saddle)
    }
    for c in (..behind, ..near-poles) {
      loop(-front * c, true, seen-or-near-saddle)
    }
    for c in near-poles {
      for side in (1, -1) {
        loop(side * c, false, p => if seen(p) { solid } else { dashed })
      }
    }
    for c in near-separatrices {
      for side in (1, -1) {
        loop(side * c, false, p => if seen(p) and near(p, shown, 25deg) {
          solid
        })
      }
    }
    // The great circles of b = 0.
    for circle-of in (
      t => (calc.cos(t), 0, calc.sin(t)),
      t => (calc.cos(t), calc.sin(t), 0),
    ) {
      flow-styled-runs(
        at,
        sample(circle-of, 0deg, 360deg, n: 180),
        p => if seen(p) { (stroke: thick-line) } else { dashed },
      )
    }
    for p in ((1, 0, 0), (-1, 0, 0)) { spot(at(p), radius: 0.9) }
    circle((0, 0), radius: radius, stroke: 2 * thick-line)
  })
  group({
    translate((49.6, 0))
    let view = flow-sphere-view((-0.143, 0.58, 0.8), (1, 0, 0), radius)
    let at = view.project
    let seen(p) = (view.depth)(p) > 0
    set-style(stroke: thick-line)
    for k in range(36) {
      let meridian = sample(
        t => (
          calc.sin(t) * calc.cos(k * 10deg),
          calc.sin(t) * calc.sin(k * 10deg),
          calc.cos(t),
        ),
        0deg,
        180deg,
        n: 90,
      )
      flow-styled-runs(at, meridian, p => if seen(p) { () })
    }
    for k in range(-18, 19) {
      // The polar angle of |z| = e^(k · 10°) from the pole ∞.
      let polar = 2 * calc.atan(calc.exp(k * calc.pi / 18))
      if polar < 10deg or polar > 170deg { continue }
      let parallel = sample(
        t => (
          calc.sin(polar) * calc.cos(t),
          calc.sin(polar) * calc.sin(t),
          calc.cos(polar),
        ),
        0deg,
        360deg,
        n: 120,
      )
      flow-styled-runs(at, parallel, p => if seen(p) { () })
    }
    circle((0, 0), radius: radius, stroke: 2 * thick-line)
  })
})

// A disc of the sphere in its chart (figs. 82, 83): stippled, of `radius`,
// with its name `name` in a white cut-out at `name-at` (in radii), the
// coordinates `chart` beside it at the lower left, the points A, B, C, D at
// the left, top, right and bottom of its rim and the field `field` at them:
// a vector (x, y) ↦ (u, v) in millimetres. The names of the points stand
// on the sides `anchors` of them.
#let flow-chart-disc(radius, field, name, name-at, chart, anchors) = {
  import cetz.draw: *
  circle((0, 0), radius: radius, fill: stipple, stroke: 1pt)
  content(name-at.map(c => c * radius), cutout(name))
  content(flow-polar(235deg, radius), chart, anchor: "north-east")
  for (label, turn) in (
    ($A$, 180deg),
    ($B$, 90deg),
    ($C$, 0deg),
    ($D$, 270deg),
  ) {
    let p = flow-polar(turn, radius)
    let (u, v) = field(p)
    arrowed(p, (p.at(0) + u, p.at(1) + v), stroke: thick-line)
    spot(p, radius: 0.95)
    content(p, label, anchor: anchors.at(repr(turn)), padding: 1.4)
  }
}

// Figure 82: a field without singular points on S² would be constant on a
// small disc D₁ about the north pole N; D₂ is the rest of the sphere. Left,
// the sphere: D₁ the cap of angular radius `cap` about N, hatched, with the
// points A, B, C, D where the two great circles through N, 90° apart,
// cross its rim; the field at them, one vector of the tangent plane at N
// along the great circle A N C, short of N from A; about the south pole a
// small cap,
// stippled, hidden. Hidden lines dashed. The view is fixed by the places of
// N and C in the drawing. Right, D₁ in its chart (x¹, y¹): the constant
// field.
#let fig-4-82() = lettered-drawing({
  import cetz.draw: *
  let radius = 21.3
  let (cap, south-cap, field-length) = (24deg, 18deg, 7.4)
  let view = flow-sphere-view((-0.04, 0.49, 0.87), (0.42, 0.68, 0.6), radius)
  let at = view.project
  let seen(p) = (view.depth)(p) > 0
  let on-sphere(polar, turn) = (
    calc.sin(polar) * calc.cos(turn),
    calc.sin(polar) * calc.sin(turn),
    calc.cos(polar),
  )
  let dashed = hidden
  // The small caps: their rims at the polar angles `cap` and 180° −
  // `south-cap`.
  let rim(polar) = sample(t => on-sphere(polar, t), 0deg, 360deg, n: 90)
  line(
    ..rim(180deg - south-cap).map(at),
    close: true,
    fill: stipple,
    ..dashed,
  )
  line(
    ..rim(cap).map(at),
    close: true,
    fill: line-hatching(22deg, 0.55mm, stroke: 0.25mm + black),
    stroke: thick-line,
  )
  // The great circles through the poles at the longitudes 0° (A N C) and
  // 90° (B N D); the first not drawn across D₁.
  for (turn, across) in ((0deg, false), (90deg, true)) {
    let points = sample(t => on-sphere(t, turn), -180deg, 180deg, n: 180)
    flow-styled-runs(at, points, p => if not seen(p) { dashed } else if (
      across or p.at(2) < calc.cos(cap)
    ) { (stroke: 0.9pt) })
  }
  // A, B, C, D on the rim of D₁; B the one of the longitudes ±90° drawn
  // higher.
  let (b-turn, d-turn) = if (
    at(on-sphere(cap, 90deg)).at(1)
      > at(on-sphere(
        cap,
        -90deg,
      )).at(1)
  ) { (90deg, -90deg) } else { (-90deg, 90deg) }
  let points = (
    (180deg, $A$, "north-east"),
    (b-turn, $B$, "south"),
    (0deg, $C$, "south"),
    (d-turn, $D$, "north"),
  )
  // The field: the tangent vector at N towards C, the same at every point.
  let (u, v) = at((1, 0, 0)).map(c => c / radius)
  let along = calc.sqrt(u * u + v * v)
  let field = (u, v).map(c => c / along * field-length)
  for (turn, label, side) in points {
    let p = at(on-sphere(cap, turn))
    arrowed(
      p,
      (p.at(0) + field.at(0), p.at(1) + field.at(1)),
      stroke: thick-line,
    )
    spot(p, radius: 0.95)
    content(p, label, anchor: side, padding: 1.2)
  }
  spot(at((0, 0, 1)), radius: 0.95)
  content(at((0, 0, 1)), cutout($N$), anchor: "south-west", padding: 1.4)
  spot(at((0, 0, -1)), radius: 0.7)
  circle((0, 0), radius: radius, stroke: 2.2 * thick-line)
  // The names of D₁ and D₂ with curved arrows to them, free-hand.
  for (from, bend, to, label, side) in (
    ((-1.05, 0.38), (-0.75, 0.48), (-0.45, 0.45), $D_1$, "east"),
    ((-1.09, -0.33), (-1.0, -0.1), (-0.74, -0.08), $D_2$, "north-east"),
  ) {
    let curve = sample(
      flow-parabola(..(from, bend, to).map(p => p.map(c => c * radius))),
      0,
      1,
      n: 24,
    )
    line(..curve)
    flow-arrow(curve, 100%)
    content(curve.first(), label, anchor: side)
  }
  // D₁ in its chart.
  group({
    translate((46.2, 0))
    let disc = 15.2
    flow-chart-disc(
      disc,
      p => (disc, 0),
      $D_1$,
      (0.25, -0.53),
      $(x^1, y^1)$,
      (
        "180deg": "north-east",
        "90deg": "south",
        "0deg": "north-west",
        "270deg": "north",
      ),
    )
  })
})

// Figure 83: the same field on the disc D₂ about the south pole in its
// chart (x², y²): the coordinates of the two discs are related by
// w = 1/z, and the constant field ∂/∂x¹ becomes dw/dt = −w². On the rim
// |w| = ρ it is drawn as −w²/ρ: out of the disc at A, into it at C, along
// it at B and D.
#let fig-4-83() = lettered-drawing({
  import cetz.draw: *
  let disc = 14.2
  let field((x, y)) = (-(x * x - y * y) / disc, -2 * x * y / disc)
  flow-chart-disc(disc, field, $D_2$, (-0.28, -0.54), $(x^2, y^2)$, (
    "180deg": "north-east",
    "90deg": "south",
    "0deg": "west",
    "270deg": "north",
  ))
})
