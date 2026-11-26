// Figures of chapter 6, § 2. Each is a function called by the text:
// `#fig(fig-6-1()) <fig:…>`.
#import "common.typ": *

// Figure 1: a domain V bounded by a closed curve Γ, oriented so that V
// stays on the left: the frame of the outward normal and the tangent at a
// point P of Γ is turned like the frame x¹, x². Γ is a free-hand curve, a
// smooth closed curve through points taken once, starting at P; the normal
// and the tangent at P are those of the curve.
#let fig-6-1() = lettered-drawing({
  import cetz.draw: *
  let small-head = (length: 2.4mm, width: 1.4mm, inset: 0.6mm)
  let turn = (mark: (end: "stealth", length: 2.2mm, width: 1.3mm, inset: 0.6mm))
  arrowed((-19, 0), (21.1, 0))
  arrowed((0, -19.4), (0, 19.6))
  cetz.angle.angle(
    (0, 0),
    (1, 0),
    (0, 1),
    radius: 3.2,
    stroke: 0.45mm,
    ..turn,
  )
  hobby(
    (16.1, 6.6),
    (16.5, 8.8),
    (16.4, 11.8),
    (14.4, 13.7),
    (11.8, 13.1),
    (9.7, 10.5),
    (6.3, 8.4),
    (2.9, 10.4),
    (-2.6, 12.7),
    (-10.2, 10.5),
    (-14.9, 4.2),
    (-15.1, -5.6),
    (-9.8, -12.4),
    (-3.4, -15.1),
    (2.9, -12.4),
    (9.3, -10.9),
    (11.8, -5.6),
    (14.0, 2.9),
    close: true,
    stroke: thick-line,
    name: "gamma",
  )
  // The orientation of Γ: arrowheads along it.
  for at in (21.6%, 43%, 60%, 81%) {
    mark(
      (name: "gamma", anchor: at),
      (name: "gamma", anchor: at + 0.5%),
      symbol: "stealth",
      ..small-head,
    )
  }
  // The outward normal and the tangent at the starting point P of Γ.
  let point = (name: "gamma", anchor: 0%)
  let ahead = (name: "gamma", anchor: 0.3%)
  let normal = (point, 7, -90deg, ahead)
  let tangent = (point, 10, ahead)
  line(point, normal, mark: small-head + (end: "stealth"))
  line(point, tangent, mark: small-head + (end: "stealth"))
  cetz.angle.angle(point, normal, tangent, radius: 3.4, ..turn)
  spot(point, radius: 0.9)
  content((6.3, 8.4), $Gamma$, anchor: "south", padding: 4.2)
  content((-5.4, 1.9), $V$)
  content((21.1, 0), $x^1$, anchor: "north-east", padding: 1.4)
  content((0, 19.6), $x^2$, anchor: "north-east", padding: 1.4)
})
