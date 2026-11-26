/-
Book: А. С. Мищенко, А. Т. Фоменко, «Курс дифференциальной геометрии и
топологии», 2-е изд. (Факториал Пресс, 2000), гл. 1, § 4, p. 50: the
remark proposing to prove that the geometry of the pseudosphere of real
radius in ℝ³₁ (the one-sheeted hyperboloid) is the Lobachevsky geometry,
and the editorial note refuting it.

Notation.  The hyperboloid is −x² + y² + z² = α² with α > 0 in ℝ³; as on
the sphere and on the pseudosphere of imaginary radius, the «lines» are its
sections by planes through 0.  A plane through 0 is a x + b y + c z = 0
with (a, b, c) ≠ 0; the plane x = 0 cuts the «line» x = 0, y² + z² = α²
(a circle).

What is proved: every plane through 0 other than x = 0, that is with
(b, c) ≠ (0, 0), contains a point (0, y, z) with y² + z² = α², which lies
on the hyperboloid and on the «line» x = 0; hence every «line» through a
point of the hyperboloid with x ≠ 0 meets the «line» x = 0: this geometry
has no «line» through a point off x = 0 that does not meet x = 0, while
in the Lobachevsky plane (p. 50) there are infinitely many such lines.

Not covered: the Lobachevsky geometry itself (its parallel axiom is the
book's statement on p. 50) and the induced indefinite metric (checked in
Sage, checks/sage/chapter-1.py).
-/
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Positivity

namespace MishchenkoFomenko.Ch01.Hyperboloid

/-- The one-sheeted hyperboloid −x² + y² + z² = α². -/
def OnHyperboloid (α x y z : ℝ) : Prop := -x ^ 2 + y ^ 2 + z ^ 2 = α ^ 2

/-- A plane through 0 other than x = 0 meets the «line» x = 0, y² + z² = α². -/
theorem plane_meets_line (α a b c : ℝ) (hbc : b ≠ 0 ∨ c ≠ 0) :
    ∃ y z : ℝ, a * 0 + b * y + c * z = 0 ∧ y ^ 2 + z ^ 2 = α ^ 2 ∧ OnHyperboloid α 0 y z := by
  have hpos : 0 < b ^ 2 + c ^ 2 := by
    rcases hbc with h | h <;> positivity
  set s := Real.sqrt (b ^ 2 + c ^ 2)
  have hs0 : 0 < s := Real.sqrt_pos.mpr hpos
  have hss : s ^ 2 = b ^ 2 + c ^ 2 := Real.sq_sqrt hpos.le
  have hcirc : (α * c / s) ^ 2 + (-(α * b) / s) ^ 2 = α ^ 2 := by
    field_simp
    rw [hss]
    ring
  refine ⟨α * c / s, -(α * b) / s, ?_, hcirc, ?_⟩
  · field_simp
    ring
  · unfold OnHyperboloid
    rw [← hcirc]
    ring

/-- No parallels to the «line» x = 0: a plane through 0 and through a point
(x₀, y₀, z₀) of the hyperboloid with x₀ ≠ 0 meets the «line» x = 0. -/
theorem no_parallels (α x₀ y₀ z₀ a b c : ℝ) (_hP : OnHyperboloid α x₀ y₀ z₀) (hx₀ : x₀ ≠ 0)
    (habc : a ≠ 0 ∨ b ≠ 0 ∨ c ≠ 0) (hplane : a * x₀ + b * y₀ + c * z₀ = 0) :
    ∃ y z : ℝ, a * 0 + b * y + c * z = 0 ∧ y ^ 2 + z ^ 2 = α ^ 2 ∧ OnHyperboloid α 0 y z := by
  apply plane_meets_line
  by_contra h
  simp only [not_or, not_not] at h
  obtain ⟨hb, hc⟩ := h
  rw [hb, hc] at hplane
  have ha : a ≠ 0 := by
    rcases habc with h | h | h
    · exact h
    · exact absurd hb h
    · exact absurd hc h
  have : a * x₀ = 0 := by linarith
  exact (mul_ne_zero ha hx₀) this

end MishchenkoFomenko.Ch01.Hyperboloid

#print axioms MishchenkoFomenko.Ch01.Hyperboloid.plane_meets_line
#print axioms MishchenkoFomenko.Ch01.Hyperboloid.no_parallels
