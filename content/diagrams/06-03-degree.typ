// Figures of chapter 6, § 3. Each is a function called by the text:
// `#fig(fig-6-2()) <fig:…>`.
#import "common.typ": *

// The small filled arrowhead on the curves of these figures.
#let degree-head = (
  symbol: "stealth",
  length: 1.9mm,
  width: 1.2mm,
  inset: 0.5mm,
)

// Figure 2: the map f(φ) = nφ of the circle onto a circle, n = 6: the
// roots of unity cut S¹ into n arcs I_k, each of which f takes onto the
// circle without one point. The arrows mark the ends of one arc I_k and
// their common image.
#let fig-6-2() = lettered-drawing({
  import cetz.draw: *
  let n = 6
  let (big, small) = (13.2, 5.7)
  let target = (big + 6 + small, 0)
  // An arrowhead on the circle about `centre` of `radius` at the angle
  // `from`, pointing along the circle towards the angle `to`.
  let head-on(centre, radius, from, to) = {
    let at(a) = (rel: (a, radius), to: centre)
    mark(at(from), at(from + (to - from) / 100), ..degree-head)
  }
  circle((0, 0), radius: big, stroke: thick-line)
  for k in range(n) { spot((k * 360deg / n, big), radius: 0.6) }
  let arc = 360deg / n
  head-on((0, 0), big, arc - 8deg, arc)
  head-on((0, 0), big, 10deg, 0deg)
  circle(target, radius: small, stroke: thick-line)
  spot((rel: (small, 0), to: target), radius: 0.6)
  head-on(target, small, 18deg, 0deg)
  head-on(target, small, -18deg, 0deg)
  line(
    (big + 0.5, 0),
    (rel: (-small - 0.8, 0), to: target),
    name: "f",
    mark: (
      end: "stealth",
      length: 2.2mm,
      width: 1.2mm,
      inset: 0.6mm,
    ),
  )
  content("f.mid", $f$, anchor: "south", padding: 1.3)
})

// Figure 3: the preimage F⁻¹(P) in M₁ × I: arcs I₁, …, I₄ with their ends
// on the boundary M₁ × {0, 1} and circles S¹₁, S¹₂ inside. The curves are
// free-hand, smooth curves through points taken once.
#let fig-6-3() = lettered-drawing({
  import cetz.draw: *
  let (width, height) = (30.3, 23.9)
  // The arcs as (points, label, the point of the label, its anchor).
  let arcs = (
    (
      (
        (4.05, 23.9),
        (4.3, 21.5),
        (4.5, 19.7),
        (5.9, 18.4),
        (7.1, 19.1),
        (7.6, 21.5),
        (8.1, 23.9),
      ),
      $I_1$,
      (7.6, 21.5),
      "west",
    ),
    (
      (
        (23.5, 23.9),
        (23.8, 21.5),
        (25.2, 19.5),
        (25.6, 17.5),
        (26.2, 16.2),
        (27.1, 17.1),
        (27.7, 20.0),
        (27.95, 23.9),
      ),
      $I_2$,
      (27.3, 18.3),
      "west",
    ),
    (
      (
        (17.15, 23.9),
        (17.1, 21.0),
        (17.9, 18.2),
        (19.9, 17.1),
        (22.0, 17.4),
        (23.6, 15.5),
        (22.9, 12.5),
        (21.5, 10.3),
        (21.3, 8.0),
        (22.4, 5.0),
        (23.5, 2.5),
        (23.5, 0),
      ),
      $I_3$,
      (21.5, 10.3),
      "west",
    ),
    (
      (
        (6.05, 0),
        (6.2, 2.5),
        (7.1, 4.8),
        (8.8, 5.9),
        (10.5, 5.4),
        (11.1, 4.0),
        (10.3, 2.3),
        (10.7, 1.1),
        (10.8, 0),
      ),
      $I_4$,
      (6.2, 2.5),
      "east",
    ),
  )
  // The circles as (points, label, the point of the label), drawn 1.15
  // times larger about that point than printed to hold the labels in type.
  let circles = (
    (
      (
        (7.9, 15.4),
        (9.2, 14.1),
        (9.2, 12.6),
        (7.9, 10.7),
        (6.2, 9.25),
        (5.15, 7.8),
        (3.7, 7.1),
        (2.2, 8.0),
        (2.2, 9.7),
        (3.5, 11.8),
        (5.4, 12.7),
        (6.85, 14.5),
      ),
      $S_1^1$,
      (5.6, 10.6),
    ),
    (
      (
        (14.5, 11.95),
        (16.4, 10.95),
        (16.9, 8.8),
        (17.2, 7.1),
        (17.6, 5.65),
        (16.15, 4.05),
        (14.9, 5.0),
        (14.9, 6.5),
        (13.6, 8.2),
        (13.1, 10.1),
        (13.5, 11.4),
      ),
      $S_2^1$,
      (15.1, 9.3),
    ),
  )
  rect((0, 0), (width, height), stroke: thick-line)
  for (points, name, place, side) in arcs {
    hobby(..points, stroke: thick-line)
    spot(points.first(), radius: 0.75)
    spot(points.last(), radius: 0.75)
    content(place, name, anchor: side, padding: 1.0)
  }
  for (points, name, place) in circles {
    let grown = points.map(p => p
      .zip(place)
      .map(((a, c)) => c + 1.15 * (a - c)))
    hobby(..grown, close: true, stroke: thick-line)
    content(place, name)
  }
  content((0, 0.57 * height), $I$, anchor: "east", padding: 1.6)
  content((width, 0), $M_1$, anchor: "north", padding: 1.2)
})
