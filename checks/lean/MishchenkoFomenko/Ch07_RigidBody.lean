/-
Book: А. С. Мищенко, А. Т. Фоменко, «Курс дифференциальной геометрии и
топологии», 2-е изд. (Факториал Пресс, 2000), гл. 7, § 4, pp. 444-445:
the equations of the rigid body with a fixed point for n = 3, their two
integrals P and Q, and the editorial note on P.

Notation.  `l₁ l₂ l₃` are λ₁, λ₂, λ₃ with λᵢ + λⱼ ≠ 0; x = x₁₂, y = x₁₃,
z = x₂₃.  The field is the printed system
  ẋ = (λ₁ − λ₂)/(λ₁ + λ₂) y z,  ẏ = (λ₃ − λ₁)/(λ₃ + λ₁) x z,
  ż = (λ₂ − λ₃)/(λ₂ + λ₃) y x.
Q = (λ₁ + λ₂)x² + (λ₁ + λ₃)y² + (λ₂ + λ₃)z², the corrected
P = (λ₁ + λ₂)²x² + (λ₁ + λ₃)²y² + (λ₂ + λ₃)²z² and the printed
P₀ = x² + y² + z² are written over any commutative ring.  The derivative
Ẋ(G) of G along the field at p = (x, y, z) is the derivative at t = 0 of
the one-variable polynomial t ↦ G(p + t Ẋ(p)) (`along`,
`Polynomial.derivative`); by the chain rule it is the derivative of G
along any trajectory through p.

What is proved, for all real λᵢ with λᵢ + λⱼ ≠ 0 and all x, y, z:
Ẋ(Q) = 2xyz(λ₁ − λ₂ + λ₃ − λ₁ + λ₂ − λ₃) = 0 and
Ẋ(P) = 2xyz(λ₁² − λ₂² + λ₃² − λ₁² + λ₂² − λ₃²) = 0 (the printed lines of
p. 445, which hold for the corrected P); Ẋ(P₀) = 2xyz(λ₁ − λ₂)(λ₁ − λ₃)
(λ₂ − λ₃)/((λ₁ + λ₂)(λ₁ + λ₃)(λ₂ + λ₃)) (the note), and at λ = (1, 2, 3),
x = y = z = 1 it equals −1/15 ≠ 0, so the printed P₀ is not an integral.

Not covered: the derivation of the system from φẊ = [X, φX], solutions of
the system (only the derivative along the field is computed), the
functional independence of P and Q and the Hamiltonian structure on the
level surfaces (checked in Sage, checks/sage/chapter-7.py).
-/
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Basic.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

namespace MishchenkoFomenko.Ch07.RigidBody

open Polynomial

/-- The printed field (ẋ, ẏ, ż). -/
noncomputable def field (l₁ l₂ l₃ x y z : ℝ) : ℝ × ℝ × ℝ :=
  ((l₁ - l₂) / (l₁ + l₂) * y * z, (l₃ - l₁) / (l₃ + l₁) * x * z,
    (l₂ - l₃) / (l₂ + l₃) * y * x)

/-- Q = (λ₁ + λ₂)x² + (λ₁ + λ₃)y² + (λ₂ + λ₃)z². -/
def Q {A : Type*} [CommRing A] (l₁ l₂ l₃ x y z : A) : A :=
  (l₁ + l₂) * x ^ 2 + (l₁ + l₃) * y ^ 2 + (l₂ + l₃) * z ^ 2

/-- The corrected P = (λ₁ + λ₂)²x² + (λ₁ + λ₃)²y² + (λ₂ + λ₃)²z². -/
def P {A : Type*} [CommRing A] (l₁ l₂ l₃ x y z : A) : A :=
  (l₁ + l₂) ^ 2 * x ^ 2 + (l₁ + l₃) ^ 2 * y ^ 2 + (l₂ + l₃) ^ 2 * z ^ 2

/-- The printed P₀ = x² + y² + z². -/
def P₀ {A : Type*} [CommRing A] (_l₁ _l₂ _l₃ x y z : A) : A :=
  x ^ 2 + y ^ 2 + z ^ 2

/-- Ẋ(G) at (x, y, z): the derivative at t = 0 of t ↦ G((x, y, z) + t Ẋ(x, y, z)). -/
noncomputable def along (G : ℝ[X] → ℝ[X] → ℝ[X] → ℝ[X] → ℝ[X] → ℝ[X] → ℝ[X])
    (l₁ l₂ l₃ x y z : ℝ) : ℝ :=
  let v := field l₁ l₂ l₃ x y z
  (derivative (G (C l₁) (C l₂) (C l₃) (C x + C v.1 * X) (C y + C v.2.1 * X)
    (C z + C v.2.2 * X))).eval 0

theorem along_Q (l₁ l₂ l₃ x y z : ℝ) (h₁₂ : l₁ + l₂ ≠ 0) (h₁₃ : l₁ + l₃ ≠ 0)
    (h₂₃ : l₂ + l₃ ≠ 0) :
    along Q l₁ l₂ l₃ x y z = 2 * x * y * z * (l₁ - l₂ + l₃ - l₁ + l₂ - l₃) ∧
      along Q l₁ l₂ l₃ x y z = 0 := by
  have h₃₁ : l₃ + l₁ ≠ 0 := by rwa [add_comm]
  have h : along Q l₁ l₂ l₃ x y z = 2 * x * y * z * (l₁ - l₂ + l₃ - l₁ + l₂ - l₃) := by
    simp [along, field, Q, derivative_pow]
    field_simp
    ring
  exact ⟨h, by rw [h]; ring⟩

theorem along_P (l₁ l₂ l₃ x y z : ℝ) (_h₁₂ : l₁ + l₂ ≠ 0) (h₁₃ : l₁ + l₃ ≠ 0)
    (_h₂₃ : l₂ + l₃ ≠ 0) :
    along P l₁ l₂ l₃ x y z =
        2 * x * y * z * (l₁ ^ 2 - l₂ ^ 2 + l₃ ^ 2 - l₁ ^ 2 + l₂ ^ 2 - l₃ ^ 2) ∧
      along P l₁ l₂ l₃ x y z = 0 := by
  have h₃₁ : l₃ + l₁ ≠ 0 := by rwa [add_comm]
  have h : along P l₁ l₂ l₃ x y z =
      2 * x * y * z * (l₁ ^ 2 - l₂ ^ 2 + l₃ ^ 2 - l₁ ^ 2 + l₂ ^ 2 - l₃ ^ 2) := by
    simp [along, field, P, derivative_pow]
    field_simp
    ring
  exact ⟨h, by rw [h]; ring⟩

theorem along_P₀ (l₁ l₂ l₃ x y z : ℝ) (h₁₂ : l₁ + l₂ ≠ 0) (h₁₃ : l₁ + l₃ ≠ 0)
    (h₂₃ : l₂ + l₃ ≠ 0) :
    along P₀ l₁ l₂ l₃ x y z = 2 * x * y * z * (l₁ - l₂) * (l₁ - l₃) * (l₂ - l₃) /
      ((l₁ + l₂) * (l₁ + l₃) * (l₂ + l₃)) := by
  have h₃₁ : l₃ + l₁ ≠ 0 := by rwa [add_comm]
  simp [along, field, P₀, derivative_pow]
  field_simp
  ring

/-- At λ = (1, 2, 3), (x, y, z) = (1, 1, 1): Ẋ(P₀) = −1/15. -/
theorem printed_P_not_conserved : along P₀ 1 2 3 1 1 1 = -1 / 15 ∧ along P₀ 1 2 3 1 1 1 ≠ 0 := by
  have h := along_P₀ 1 2 3 1 1 1 (by norm_num) (by norm_num) (by norm_num)
  norm_num at h
  exact ⟨by rw [h]; norm_num, by rw [h]; norm_num⟩

end MishchenkoFomenko.Ch07.RigidBody

#print axioms MishchenkoFomenko.Ch07.RigidBody.along_Q
#print axioms MishchenkoFomenko.Ch07.RigidBody.along_P
#print axioms MishchenkoFomenko.Ch07.RigidBody.along_P₀
#print axioms MishchenkoFomenko.Ch07.RigidBody.printed_P_not_conserved
