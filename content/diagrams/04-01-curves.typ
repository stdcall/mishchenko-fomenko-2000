// Figures of chapter 4, § 1. Each is a function called by the text:
// `#fig(fig-4-1()) <fig:…>`.
#import "common.typ": *

// Figure 1: the frames ω(s) = (v⃗(s), n⃗(s)) and ω(s + Δs) of a curve, an
// arc of the circle of radius `radius` about the origin run clockwise, at
// two points `turn` apart; the frame ω(s + Δs) carried to the point s
// (dashed) is ω(s) turned by Δφ = `turn`, the angles stippled.
#let fig-4-1() = drawing({
  import cetz.draw: *
  let (radius, turn, unit) = (28.9, 60deg, 17)
  // The ends of the drawn arc and the polar angles of the points s, s + Δs.
  let (first, last) = (106deg, -7deg)
  let (here, there) = (90deg, 90deg - turn)
  // The frame at the polar angle t: the tangent of the clockwise run and
  // the normal towards the centre.
  let frame(t) = (t - 90deg, t + 180deg)
  arc(
    (0, 0),
    start: last,
    stop: first,
    radius: radius,
    anchor: "origin",
    stroke: 3 * thick-line,
  )
  let (p, q) = ((here, radius), (there, radius))
  let (v-p, n-p) = frame(here)
  let (v-q, n-q) = frame(there)
  for (from, to) in ((v-p, v-q), (n-p, n-q)) {
    cetz.angle.angle(
      p,
      (rel: (from, 1), to: p),
      (rel: (to, 1), to: p),
      direction: "cw",
      radius: 9.3,
      fill: stipple,
      mark: (end: "stealth", length: 2, width: 1.1, inset: 0.6),
    )
  }
  arrowed(p, (rel: (v-p, unit)), name: "v")
  arrowed(p, (rel: (n-p, unit)), name: "n")
  arrowed(p, (rel: (v-q, unit)), ..hidden)
  arrowed(p, (rel: (n-q, unit)), ..hidden)
  arrowed(q, (rel: (v-q, unit)), name: "v-next")
  arrowed(q, (rel: (n-q, unit)), name: "n-next")
  spot(p, radius: 1)
  spot(q, radius: 1)
  content(p, $arrow(r)(s)$, anchor: "south", padding: 1.6)
  content("v.75%", $arrow(v)(s)$, anchor: "south")
  content("n.90%", $arrow(n)(s)$, anchor: "east")
  content(q, $arrow(r)(s + Delta s)$, anchor: "south-west", padding: 1.6)
  content("n-next.end", $arrow(n)(s + Delta s)$, anchor: "north-east")
  content((last, radius), $arrow(v)(s + Delta s)$, anchor: "south-east")
})

// Figure 2: two curves of the same constant curvature 1/`radius` (bold):
// r⃗₁, a half of the circle about O, and r⃗₂, a quarter of a circle of the
// same radius followed at P by a quarter of the tangent circle beyond it.
// Their normals (dashed) point to the centres, every `step` of turn.
#let fig-4-2() = drawing({
  import cetz.draw: *
  let (radius, apart, step) = (12.7, 3.2, 22.5deg)
  // How far the normals start inside the arc and stop short of the centre.
  let (inside, short) = (0.9, 3)
  let head = (end: "stealth", length: 2.2, width: 1.2, inset: 0.6)
  // The circle about `centre`, bold from `bold.at(0)` to `bold.at(1)`,
  // dashed elsewhere, with the normals at the angles from `normals.at(0)`
  // to `normals.at(1)` and spots at the ends of the bold arc.
  let wheel(centre, bold, normals) = {
    let (from, to) = bold
    let ring = (radius: radius, anchor: "origin")
    arc(centre, start: to, stop: from + 360deg, ..ring, ..hidden)
    arc(centre, start: from, stop: to, ..ring, stroke: 2 * thick-line)
    let (first, last) = normals
    for k in range(int(calc.round((last - first) / step)) + 1) {
      let angle = first + k * step
      arrowed(
        (rel: (angle, radius - inside), to: centre),
        (rel: (angle, short), to: centre),
        mark: head,
        ..hidden,
      )
    }
    for angle in bold {
      spot((rel: (angle, radius), to: centre), radius: 0.8)
    }
    spot(centre, radius: 0.8)
  }
  let o = (0, 0)
  let lower = (2 * radius + apart, 0)
  let upper = (rel: (0, 2 * radius), to: lower)
  let p = (rel: (0, radius), to: lower)
  wheel(o, (0deg, 180deg), (0deg, 180deg))
  // The lower right circle is bold over its top; r⃗₂ runs over the quarter
  // before P only.
  wheel(lower, (0deg, 180deg), (90deg, 180deg))
  wheel(upper, (270deg, 360deg), (270deg, 360deg))
  content((0, radius), $arrow(r)_1 lr((s))$, anchor: "south")
  content(o, $O$, anchor: "north-west")
  content(((-radius, 0), 50%, o), $arrow(n)_1 lr((s))$, anchor: "north")
  content(p, $P$, anchor: "south-east")
  content(
    (rel: (315deg, radius), to: upper),
    $arrow(r)_2 lr((s))$,
    anchor: "north-west",
  )
})

// Figure 3: two smooth curves with the same curvature that are not
// congruent. A branch from s₀ has the curvature k(s) = κ exp(−(σ/s)²),
// which vanishes at s = s₀ = 0 with all its derivatives; it is built from
// k by φ(s) = ∫k, r⃗(s) = ∫(cos φ, sin φ). One curve joins it with its
// mirror image under the tangent line, the other with its image under the
// point s₀; both bend away from the line by the same k(s). The branches are
// brush strokes, widening from s₀.
#let fig-4-3() = drawing({
  import cetz.draw: *
  let (kappa, sigma, length, steps) = (0.075, 2, 22, 200)
  let step = length / steps
  let branch = {
    let (x, y, turn) = (0, 0, 0)
    let points = ((0, 0),)
    for i in range(steps) {
      let s = (i + 0.5) * step
      turn += kappa * calc.exp(-calc.pow(sigma / s, 2)) * step
      x += calc.cos(turn) * step
      y += calc.sin(turn) * step
      points.push((x, y))
    }
    points
  }
  let reach = 18
  line((-reach, 0), (reach, 0))
  for (sx, sy) in ((-1, -1), (1, -1), (1, 1)) {
    brush-stroke(branch.map(((x, y)) => (sx * x, sy * y)), u => 0.4 + 0.6 * u)
  }
  spot((0, 0), radius: 0.8)
  let end = branch.last()
  content((0, 0), $s_0$, anchor: "south", padding: 1.6)
  // The labels stand inside the arch beside the lower ends.
  content((-end.at(0), -end.at(1)), $s <= s_0$, anchor: "west", padding: 2)
  content((end.at(0), -end.at(1)), $s >= s_0$, anchor: "east", padding: 2)
})
// Figure 4: a curve gets its torsion ϰ: a man twists a ribbon off the
// plane with pliers. A drawing; ϰ over it.
#let fig-4-4() = drawing({
  import cetz.draw: *
  let width = 96.27
  book-picture(
    "/assets/figures/04-04-torsion.svg",
    width,
    anchor: "north-west",
  )
  content((46.95, 1.31), $kappa.alt$)
})
// Figure 5: a triangle, a closed plane curve with three corners (bold).
#let fig-4-5() = drawing({
  import cetz.draw: *
  line((0, 0), (27.4, 0), (18, 20.8), close: true, stroke: (
    thickness: 3 * thick-line,
    join: "miter",
  ))
})
