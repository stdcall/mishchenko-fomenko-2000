// Shared helpers of the figures. Every figure is a function in the file of
// its section, content/diagrams/CC-SS-slug.typ, built with CeTZ from the data
// that define the object drawn; the printed figure gives only the view, the
// scale and the places of the labels. The chapters import the figure files
// with `*`, so the names defined here must not shadow those of Typst's
// mathematics (`thin`, `upright`, `phi`, …).
#import "@preview/cetz:0.5.3"

// A figure not yet drawn: a frame of its size with its number. Only while
// the book is being set; the final build has none.
#let figure-stub(number, width: 40mm, height: 30mm) = box(
  width: width,
  height: height,
  stroke: (dash: "dashed", thickness: 0.4pt),
  align(center + horizon, text(size: 8pt)[рисунок #number]),
)

// The drawing style of the book. Axes, outlines and grids are thin lines;
// the curves a figure stresses are bold. Hidden lines are dashed; the short
// dash marks auxiliary lines in plane figures.
#let thin-line = 0.6pt
#let thick-line = 1.2pt
#let hidden = (stroke: (dash: (array: (1.8mm, 0.8mm))))
#let fine-dash = (stroke: (dash: (array: (0.8mm, 0.45mm))))

// A stipple of dots of `radius` and `paint` on a square lattice of `step`,
// each dot `offset` from the corner of its cell (by default a third of the
// step).
#let dot-stipple(step, radius: 0.1mm, offset: auto, paint: black) = {
  let offset = if offset == auto { step / 3 } else { offset }
  tiling(size: (step, step), place(
    dx: offset,
    dy: offset,
    circle(radius: radius, fill: paint),
  ))
}

// Stipple shading: a square lattice of fine dots, 0.5 mm apart.
#let stipple = dot-stipple(0.5mm, offset: 0.16mm)

// Line hatching: parallel lines `spacing` apart at `angle` to the x-axis
// (counterclockwise; the y-axis of a tiling points down). Each line runs
// on through the neighbouring tiles, so that its caps do not show.
#let line-hatching(angle, spacing, stroke: 0.15mm + black) = {
  let w = spacing / calc.abs(calc.sin(angle))
  let h = w * calc.abs(calc.tan(angle))
  let (from, to) = if angle > 0deg { (h, 0mm) } else { (0mm, h) }
  tiling(size: (w, h), for shift in (-w, 0mm, w) {
    place(line(
      start: (shift - w, 2 * from - to),
      end: (shift + 2 * w, 2 * to - from),
      stroke: stroke,
    ))
  })
}

// A label standing in a white cut-out of a shaded or filled area. The
// cut-out does not move the label; it hides what is drawn before it.
#let cutout(body) = box(fill: white, outset: 0.45mm, body)

// A figure in millimetres of the printed page: thin round-capped lines, the
// long narrow filled arrowhead of the book, labels measured by the real
// bounds of their glyphs with one common gap to the geometry.
#let drawing(body) = cetz.canvas(length: 1mm, {
  import cetz.draw: *
  set-style(
    stroke: (thickness: thin-line, cap: "round", join: "round"),
    mark: (fill: black, length: 3mm, width: 1.5mm, inset: 0.9mm),
    content: (
      padding: 1mm,
      wrap: text.with(top-edge: "bounds", bottom-edge: "bounds"),
    ),
  )
  body
})

// A figure in the style of `drawing` with the slimmer arrowheads of
// chapters 2 and 3 and labels of the given size, by default the 9 pt of
// chapter 3.
#let slim-drawing(body, size: 9pt) = {
  set text(size: size)
  drawing({
    cetz.draw.set-style(mark: (length: 2.5mm, width: 1mm, inset: 0.5mm))
    body
  })
}

// A drawing with the hand-lettered labels of the book from chapter 4 on,
// set in its mathematics at their printed size, smaller than the text.
#let lettered-drawing(body) = {
  set text(size: 8.5pt)
  drawing(body)
}

// A drawing of the book as a vector image: the file `file`, `width` mm
// wide, its corner `anchor` at `corner`, with the labels set over it, each
// `(at, body)` centred at `at` (mm from `corner`) or `(at, body, side)`
// with its side `side` there; `padding` their gap (`auto`: that of the
// figure).
#let book-picture(
  file,
  width,
  labels: (),
  corner: (0, 0),
  anchor: "south-west",
  padding: 0,
) = {
  import cetz.draw: content
  content(
    corner,
    image(file, width: width * 1mm),
    anchor: anchor,
    padding: 0,
  )
  for (at, body, ..side) in labels {
    content(
      (rel: at, to: corner),
      body,
      anchor: side.at(0, default: "center"),
      padding: padding,
    )
  }
}

// The number of a part of a figure, an italic digit as printed; `style`
// for its text, such as its size.
#let part-number(n, ..style) = text(style: "italic", ..style, str(n))

// A label along a line through `at` that rises at `rise`, its foot `gap`
// mm above the line (below it if `gap` is negative). The label stands on
// an invisible copy of itself, so that the line runs through the middle.
#let label-along(at, rise, body, gap: 0.8) = {
  let parts = (body, hide(body))
  cetz.draw.content(
    at,
    std.rotate(-rise, reflow: true, std.grid(
      align: center,
      row-gutter: 2 * calc.abs(gap) * 1mm,
      ..if gap > 0 { parts } else { parts.rev() },
    )),
    padding: 0,
  )
}

// A segment with the arrowhead of the book at its end.
#let arrowed(from, to, ..style) = cetz.draw.line(
  from,
  to,
  mark: (end: "stealth"),
  ..style,
)

// The small arrowhead of a leader from a label.
#let leader-mark = (end: "stealth", length: 1.6mm, width: 0.9mm, inset: 0.5mm)

// An axis from `from` to `to` with its arrowhead `short` of the end, as
// the axes of some figures of chapter 7 are drawn.
#let axis-head-short(from, to, short: 2.2, name: none) = {
  import cetz.draw: *
  line(from, to, name: name)
  mark((to, short, from), to, symbol: "stealth")
}

// Plane axes x, y through the origin, the arrows at `(x-end, y-end)`, the
// opposite ends `(x-start, y-start)` short of the origin; with the labels of
// the book: the axis names beside the arrowheads, O below the origin.
#let plane-axes(
  x-start: -4,
  y-start: -4,
  x-end,
  y-end,
  x-name: $x$,
  y-name: $y$,
  origin-name: $O$,
) = {
  import cetz.draw: *
  arrowed((x-start, 0), (x-end, 0))
  arrowed((0, y-start), (0, y-end))
  content((x-end, 0), x-name, anchor: "north-east")
  content((0, y-end), y-name, anchor: "north-east")
  if origin-name != none {
    content((0, 0), origin-name, anchor: "north-east")
  }
}

// Lines that pass over the lines they cross, each given by its points: a
// white band under them parts the lines drawn before, as printed. The lines
// of one call do not part each other.
#let bridge(..lines, gap: 1.4mm) = {
  for points in lines.pos() {
    cetz.draw.line(..points, stroke: (
      paint: white,
      thickness: gap,
      cap: "butt",
    ))
  }
  for points in lines.pos() { cetz.draw.line(..points) }
}

// A marked point: a filled disc.
#let spot-radius = 0.65mm
#let spot(at, ..style) = cetz.draw.circle(
  at,
  radius: spot-radius,
  fill: black,
  stroke: none,
  ..style,
)

// Points of a curve t ↦ f(t) on [a, b], n steps.
#let sample(f, a, b, n: 200) = range(n + 1).map(i => f(a + (b - a) * i / n))

// The runs of consecutive points of a polyline where `keep` holds.
#let runs-where(points, keep) = {
  let runs = ((),)
  for p in points {
    if keep(p) { runs.last().push(p) } else if runs.last().len() > 0 {
      runs.push(())
    }
  }
  runs.filter(run => run.len() > 1)
}

// Vectors of the plane or of space as arrays of their coordinates: sum,
// multiple, dot and cross products, the unit vector along v.
#let vec-add(..vs) = vs.pos().reduce((u, v) => u.zip(v).map(((a, b)) => a + b))
#let vec-scale(k, v) = v.map(c => k * c)
#let vec-dot(u, v) = u.zip(v).map(((a, b)) => a * b).sum()
#let vec-cross(u, v) = (
  u.at(1) * v.at(2) - u.at(2) * v.at(1),
  u.at(2) * v.at(0) - u.at(0) * v.at(2),
  u.at(0) * v.at(1) - u.at(1) * v.at(0),
)
#let vec-unit(v) = vec-scale(1 / calc.sqrt(vec-dot(v, v)), v)

// Complex numbers as pairs (re, im): the product and the quotient.
#let complex-times((a, b), (c, d)) = (a * c - b * d, a * d + b * c)
#let complex-over((a, b), (c, d)) = {
  let n = c * c + d * d
  ((a * c + b * d) / n, (b * c - a * d) / n)
}

// Whether the point p lies inside the polygon `corners` (the even–odd
// rule).
#let inside-polygon(p, corners) = {
  let (x, y) = p
  let inside = false
  for (i, (ax, ay)) in corners.enumerate() {
    let (bx, by) = corners.at(i - 1)
    if (ay > y) != (by > y) and x < ax + (y - ay) * (bx - ax) / (by - ay) {
      inside = not inside
    }
  }
  inside
}

// Whether the point p lies inside the convex polygon `corners`, taken in
// order round it either way.
#let inside-convex(p, corners) = {
  let count = corners.len()
  let sides = range(count).map(i => {
    let (a, b) = (corners.at(i), corners.at(calc.rem(i + 1, count)))
    let cross = (
      (b.at(0) - a.at(0)) * (p.at(1) - a.at(1))
        - (b.at(1) - a.at(1)) * (p.at(0) - a.at(0))
    )
    cross > 0
  })
  sides.all(s => s) or sides.all(s => not s)
}

// The part of the polygon `points` where the linear function f is not
// negative (Sutherland–Hodgman clipping by the line f = 0). The cut along
// the line is sampled in `steps` pieces, so that its image under a curved
// map stays smooth.
#let polygon-part-where(points, f, steps: 40) = {
  let between(a, b) = range(1, steps).map(j => a
    .zip(b)
    .map(((x, y)) => x + (y - x) * j / steps))
  let (kept, leaving) = ((), none)
  let count = points.len()
  for i in range(count) {
    let (p, q) = (points.at(i), points.at(calc.rem(i + 1, count)))
    let (fp, fq) = (f(p), f(q))
    if fp >= 0 { kept.push(p) }
    if (fp >= 0) != (fq >= 0) {
      let s = fp / (fp - fq)
      let crossing = p.zip(q).map(((a, b)) => a + s * (b - a))
      if fp >= 0 { leaving = crossing } else if leaving != none {
        kept += between(leaving, crossing)
        leaving = none
      }
      kept.push(crossing)
    }
  }
  if leaving != none { kept += between(leaving, kept.first()) }
  kept
}

// The Catmull–Rom spline through `points`, the smooth curve of a free-hand
// outline: its pieces between consecutive points, each sampled `n` times
// from its start to its end; a closed curve if `close`.
#let spline-pieces(points, n: 16, close: false) = {
  let m = points.len()
  let at(i) = points.at(if close { calc.rem-euclid(i, m) } else {
    calc.clamp(i, 0, m - 1)
  })
  range(if close { m } else { m - 1 }).map(i => {
    let (p0, p1, p2, p3) = (at(i - 1), at(i), at(i + 1), at(i + 2))
    range(n + 1).map(k => {
      let t = k / n
      range(2).map(j => {
        let (a, b, c, d) = (p0.at(j), p1.at(j), p2.at(j), p3.at(j))
        let square = (2 * a - 5 * b + 4 * c - d) * t * t
        let cube = (3 * b - a - 3 * c + d) * t * t * t
        (2 * b + (c - a) * t + square + cube) / 2
      })
    })
  })
}

// Points of the Catmull–Rom spline through `points`, `n` a piece, the
// sample n·i being the point i; a closed curve if `close`.
#let spline-through(points, n: 16, close: false) = (
  (points.first(),)
    + spline-pieces(points, n: n, close: close)
      .map(piece => piece.slice(1))
      .join()
)

// A curve drawn as a brush stroke, as the book draws some curves: the
// polyline `points` widened to a black band `width` mm wide, a number or a
// function of u running from 0 at its first point to 1 at its last; with a
// `taper`, the band narrows to a point over that length at either end.
#let brush-stroke(points, width, taper: none) = {
  let last = points.len() - 1
  let lengths = (0,)
  for i in range(1, points.len()) {
    let ((x0, y0), (x1, y1)) = (points.at(i - 1), points.at(i))
    lengths.push(
      lengths.last() + calc.sqrt(calc.pow(x1 - x0, 2) + calc.pow(y1 - y0, 2)),
    )
  }
  let total = lengths.last()
  let (left, right) = ((), ())
  for (i, (x, y)) in points.enumerate() {
    let (ax, ay) = points.at(calc.max(i - 1, 0))
    let (bx, by) = points.at(calc.min(i + 1, last))
    let length = calc.sqrt(calc.pow(bx - ax, 2) + calc.pow(by - ay, 2))
    let half = if type(width) == function { width(i / last) } else { width }
    half /= 2
    if taper != none {
      // s and total − s: the lengths along the polyline from its ends.
      let s = lengths.at(i)
      half *= calc.sqrt(calc.min(1, s / taper, (total - s) / taper))
    }
    let (nx, ny) = (-half * (by - ay) / length, half * (bx - ax) / length)
    left.push((x + nx, y + ny))
    right.push((x - nx, y - ny))
  }
  cetz.draw.line(..left, ..right.rev(), close: true, fill: black, stroke: none)
}

// The points of an edge of a curved sheet moved `by` its `thickness`, a
// shift of the page: `by: 1` gives the edge of the bottom face.
#let sheet-shifted(points, thickness, by: 1) = points.map(((x, y)) => (
  x + by * thickness.at(0),
  y + by * thickness.at(1),
))

// A side face of a curved sheet: the band between its `edge`, a smooth
// curve through the points given, and the same edge of the bottom face.
#let sheet-side(edge, thickness, ..style) = cetz.draw.merge-path(
  close: true,
  ..style,
  {
    cetz.draw.hobby(..edge)
    cetz.draw.hobby(..sheet-shifted(edge, thickness).rev())
  },
)

// A curved sheet seen from above, a thin slab: its top face is bounded by
// four edges in turn, far, right, near and left, each a smooth curve
// through a few points from corner to corner; its bottom face lies at the
// shift `thickness`. The top is stippled, the near side black, the right
// side black with white strokes.
#let curved-sheet(far, right, near, left, thickness) = {
  import cetz.draw: *
  sheet-side(near, thickness, fill: black)
  sheet-side(right, thickness, fill: black)
  hobby(..sheet-shifted(right, thickness, by: 0.5), stroke: (
    paint: white,
    thickness: 0.15mm,
    dash: (array: (0.45mm, 0.55mm)),
  ))
  merge-path(close: true, fill: stipple, {
    hobby(..far)
    hobby(..right)
    hobby(..near)
    hobby(..left)
  })
}

// Parallel projections of space onto the page. `projection(ex, ey, ez)`
// maps a point (x, y, z) by the images of the unit vectors of the axes.
#let projection(ex, ey, ez) = p => {
  let (x, y, z) = p
  (
    x * ex.at(0) + y * ey.at(0) + z * ez.at(0),
    x * ex.at(1) + y * ey.at(1) + z * ez.at(1),
  )
}

// The orthographic view of space with z up: the plane (x, y) turned by
// `azimuth` and tilted towards the viewer by `elevation`. Besides the
// projection it gives the unit vector towards the viewer, which parts the
// visible from the hidden.
#let orthographic(azimuth, elevation) = {
  let (ca, sa) = (calc.cos(azimuth), calc.sin(azimuth))
  let (cb, sb) = (calc.cos(elevation), calc.sin(elevation))
  (
    project: projection((ca, -sb * sa), (sa, sb * ca), (0, cb)),
    toward: (sa * cb, -ca * cb, sb),
  )
}

// The perspective of the book's pictures over a plane. A point (x, v, w)
// of space, x where it would stand on the front edge of the plane w = 0
// (at the height `front` of the page), v its depth behind that edge and w
// its height, is drawn towards the vanishing point `vanish` of the lines
// going back, at the scale distance / (distance + v): the view of an eye
// at the height of `vanish` and `distance` in front of the plane.
#let plane-perspective(vanish, front, distance) = ((x, v, w)) => {
  let q = distance / (distance + v)
  (
    vanish.at(0) + (x - vanish.at(0)) * q,
    vanish.at(1) + (front + w - vanish.at(1)) * q,
  )
}

// Whether the point p of a sphere about the origin faces the viewer of
// `view`.
#let facing(view, p) = vec-dot(p, view.toward) > 0

// A curve in space by its `points` under the projection `at`: solid where
// `seen(p)` holds, dashed where it is hidden.
#let seen-hidden(at, seen, points, ..style) = {
  let runs = ()
  for p in points {
    let s = seen(p)
    if runs.len() == 0 or runs.last().at(0) != s {
      let start = if runs.len() == 0 { () } else { (runs.last().at(1).last(),) }
      runs.push((s, start))
    }
    runs.last().at(1).push(at(p))
  }
  for (s, run) in runs.filter(run => run.at(1).len() > 1) {
    if s { cetz.draw.line(..run, ..style) } else {
      cetz.draw.line(..run, ..hidden)
    }
  }
}
