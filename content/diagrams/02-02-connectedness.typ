// Figures of chapter 2, § 2. Each is a function called by the text:
// `#fig(fig-2-1()) <fig:…>`.
#import "common.typ": *

// Figure 1: the closure of the graph of y = sin(1/x), the bold graph and the
// bolder segment Γ₃ = {x = 0, −1 ≤ y ≤ 1} with its ends marked. The graph is
// drawn by the phase θ = 1/x, which runs evenly through the waves, up to
// θ = 4.9π: further in, its strands merge at this line width.
#let fig-2-1() = slim-drawing(size: 10pt, {
  import cetz.draw: *
  // Millimetres per unit along x (1/π stands at 14.12 mm) and along y.
  let (unit-x, unit-y) = (14.12 * calc.pi, 10.14)
  let last-phase = 4.9 * calc.pi
  // The branch x > 0 (side 1) or x < 0 (side −1) from |x| = reach inwards.
  let branch(side, reach) = line(
    ..sample(
      theta => (side * unit-x / theta, side * unit-y * calc.sin(theta)),
      unit-x / reach,
      last-phase,
      n: 800,
    ),
    stroke: thick-line,
  )
  arrowed((-26.33, 0), (23.07, 0))
  arrowed((0, -17.46), (0, 18.31))
  branch(1, 23.88)
  branch(-1, 26.33)
  line((0, -unit-y), (0, unit-y), stroke: 1.5 * thick-line)
  for end in (-unit-y, unit-y) { spot((0, end), radius: 1.5 * spot-radius) }
  // The zeros ±1/π, marked smaller, as printed.
  let zero = unit-x / calc.pi
  content((-zero, 0), text(size: 8pt, $-1 \/ pi$), anchor: "south-east")
  content((zero, 0), text(size: 8pt, $1 \/ pi$), anchor: "north-west")
  content((23.07, 0), $x$, anchor: "north")
  content((0, 18.31), $y$, anchor: "north-west")
})
