// Figures of chapter 3, § 2. Each is a function called by the text:
// `#fig(fig-3-6()) <fig:…>`.
#import "common.typ": *

// Figure 6: the level lines x² − y² = c of f = x² − y² in the square
// |x|, |y| ≤ `reach`: the hyperbolas c = a² (solid) and c = −a² (dashed)
// and the pair of lines c = 0. A neighbourhood U₀ of P₀ = (0, 0) is a
// free-hand closed curve, a smooth curve through points taken once from
// the book; it leaves the line y = −x and comes back to it, so that this
// arm meets U₀ twice. The parts of the arms inside U₀ are bold, each an
// arrow to where the arm leaves U₀.
#let fig-3-6() = slim-drawing({
  import cetz.draw: *
  let (a, reach) = (11.94, 19.8)
  // The branches by x = ±a cosh t, y = a sinh t up to the square.
  let last = calc.ln((reach + calc.sqrt(reach * reach - a * a)) / a)
  let branch(side, swap) = sample(
    t => {
      let (u, v) = (side * a * calc.cosh(t), a * calc.sinh(t))
      if swap { (v, u) } else { (u, v) }
    },
    -last,
    last,
    n: 120,
  )
  plane-axes(x-start: -reach, y-start: -reach, reach, reach, origin-name: none)
  for side in (1, -1) {
    line(..branch(side, false))
    line(..branch(side, true), ..hidden)
  }
  line((-reach, -reach), (reach, reach))
  line((-reach, reach), (reach, -reach))
  // Where the arms of the cross leave U₀ (the arm y = −x, x < 0, three
  // times), and U₀ through them.
  let north-east = (45deg, 6.75)
  let (north-west-1, north-west-2, north-west-3) = (
    (135deg, 3.54),
    (135deg, 6.31),
    (135deg, 9.75),
  )
  let south-west = (225deg, 4.98)
  let south-east = (315deg, 7.49)
  let east = (6.60, 2.40)
  hobby(
    (7.24, 0),
    east,
    north-east,
    (0, 7.58),
    (-2.91, 7.99),
    (-5.69, 7.68),
    north-west-3,
    (-7.94, 5.99),
    (-8.15, 5.27),
    (-7.64, 4.51),
    (-6.37, 4.09),
    north-west-2,
    (-3.28, 4.76),
    (-2.22, 4.00),
    north-west-1,
    (-3.37, 1.04),
    (-3.71, -0.66),
    south-west,
    (-2.0, -5.49),
    (0, -6.48),
    south-east,
    (6.95, -2.53),
    close: true,
  )
  for (from, to) in (
    ((0, 0), north-east),
    ((0, 0), north-west-1),
    (north-west-2, north-west-3),
    ((0, 0), south-west),
    ((0, 0), south-east),
  ) {
    arrowed(from, to, stroke: thick-line)
  }
  content(east, $U_0$, anchor: "west")
  content((a, 0), $c > 0$, anchor: "south-west")
  content((-a, 0), $c > 0$, anchor: "north-east")
  // The dashed branches rise away from the axis: the corner of each label
  // stands the gap of the labels (1 mm) right above the branch at
  // |x| = `across`, the label towards the axis.
  let across = 11.5
  let top = calc.sqrt(a * a + across * across)
  content((-across - 1, top), $c < 0$, anchor: "south-west")
  content((across + 1, -top), $c < 0$, anchor: "north-east")
  content((135deg, 13.62), cutout($c = 0$))
  content((225deg, 11.48), cutout($c = 0$))
})
