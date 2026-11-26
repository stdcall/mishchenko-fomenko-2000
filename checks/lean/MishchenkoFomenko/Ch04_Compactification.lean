/-
Book: А. С. Мищенко, А. Т. Фоменко, «Курс дифференциальной геометрии и
топологии», 2-е изд. (Факториал Пресс, 2000), гл. 4, § 6, pp. 286-288:
Theorem 2 (the Riemann surface of w = √(P_n(z)) compactifies in
S² × S² to a smooth manifold), its editorial note (true only for n = 1),
and the curve in ℂP² on p. 288.

Notation.  `a : Fin n → A` are the roots a_1, …, a_n of P_n, over any
commutative ring `A` (the book: ℂ).  In u = 1/z, v = 1/w the closure of
w² = ∏ (z − a_k) near (∞_z, ∞_w) is F(u, v) = v² ∏ (1 − a_k u) − uⁿ = 0
(the note).  On p. 288, in the chart u = x¹/x², v = x³/x² of ℂP², it is
q(u, v) = v^(n−2) − ∏ (u − a_k v) = 0.
A partial derivative of a polynomial expression G at (u₀, v₀) is the
derivative at t = 0 of the one-variable polynomial t ↦ G(u₀ + t, v₀)
(resp. G(u₀, v₀ + t)) (`du`, `dv`; `Polynomial.derivative`); `eval_F`
checks that this polynomial takes the values of F.

What is proved.  F(0, 0) = 0 for n ≥ 1; for n ≥ 2 both partial
derivatives of F vanish at (0, 0), so (∞_z, ∞_w) is a singular point of
the closure and Theorem 2 fails; for n = 1, ∂F/∂u(0, 0) = −1 (and
∂F/∂v(0, 0) = 0), so the closure is smooth there.  For q: at n = 3,
∂q/∂u(0, 0) = 0 and ∂q/∂v(0, 0) = 1, against the printed «for n > 2 the
gradient of q at (0, 0) is zero»; for n ≥ 4 both partial derivatives of q
vanish at (0, 0).

Not covered: the nature of the singular point (two branches for even n,
a cusp for odd n ≥ 3; checked in Sage, checks/sage/chapter-4.py), the
implicit function theorem and the topology of the compactification.
-/
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.Ring

namespace MishchenkoFomenko.Ch04.Compactification

open Polynomial

/-- F(u, v) = v² ∏ (1 − a_k u) − uⁿ. -/
def F {A : Type*} [CommRing A] {n : ℕ} (a : Fin n → A) (u v : A) : A :=
  v ^ 2 * ∏ k, (1 - a k * u) - u ^ n

/-- q(u, v) = v^(n−2) − ∏ (u − a_k v) (p. 288). -/
def q {A : Type*} [CommRing A] {n : ℕ} (a : Fin n → A) (u v : A) : A :=
  v ^ (n - 2) - ∏ k, (u - a k * v)

variable {R : Type*} [CommRing R]

/-- ∂G/∂u (u₀, v₀): the derivative at t = 0 of t ↦ G(u₀ + t, v₀). -/
noncomputable def du (G : R[X] → R[X] → R[X]) (u₀ v₀ : R) : R :=
  (derivative (G (C u₀ + X) (C v₀))).eval 0

/-- ∂G/∂v (u₀, v₀): the derivative at t = 0 of t ↦ G(u₀, v₀ + t). -/
noncomputable def dv (G : R[X] → R[X] → R[X]) (u₀ v₀ : R) : R :=
  (derivative (G (C u₀) (C v₀ + X))).eval 0

/-- The polynomial F with coefficients C a_k takes the values of F. -/
theorem eval_F {n : ℕ} (a : Fin n → R) (t : R) (p r : R[X]) :
    (F (fun k => C (a k)) p r).eval t = F a (p.eval t) (r.eval t) := by
  simp [F, eval_prod]

theorem eval_q {n : ℕ} (a : Fin n → R) (t : R) (p r : R[X]) :
    (q (fun k => C (a k)) p r).eval t = q a (p.eval t) (r.eval t) := by
  simp [q, eval_prod]

theorem F_zero {n : ℕ} (hn : 1 ≤ n) (a : Fin n → R) : F a 0 0 = 0 := by
  simp [F, zero_pow (by omega : n ≠ 0)]

theorem du_F {n : ℕ} (a : Fin n → R) :
    du (F fun k => C (a k)) 0 0 = -((n : R) * 0 ^ (n - 1)) := by
  simp [du, F, derivative_X_pow]

theorem dv_F {n : ℕ} (a : Fin n → R) : dv (F fun k => C (a k)) 0 0 = 0 := by
  simp [dv, F, derivative_pow]

/-- n ≥ 2: F(0, 0) = 0 and both partial derivatives vanish: a singular point. -/
theorem singular {n : ℕ} (hn : 2 ≤ n) (a : Fin n → R) :
    F a 0 0 = 0 ∧ du (F fun k => C (a k)) 0 0 = 0 ∧ dv (F fun k => C (a k)) 0 0 = 0 := by
  refine ⟨F_zero (by omega) a, ?_, dv_F a⟩
  rw [du_F, zero_pow (by omega : n - 1 ≠ 0)]
  simp

/-- n = 1: ∂F/∂u (0, 0) = −1. -/
theorem smooth_one (a : Fin 1 → R) :
    F a 0 0 = 0 ∧ du (F fun k => C (a k)) 0 0 = -1 ∧ dv (F fun k => C (a k)) 0 0 = 0 := by
  refine ⟨F_zero le_rfl a, ?_, dv_F a⟩
  rw [du_F]
  simp

/-- p. 288, n = 3: the gradient of q at (0, 0) is (0, 1), not zero. -/
theorem q_three (a : Fin 3 → R) :
    q a 0 0 = 0 ∧ du (q fun k => C (a k)) 0 0 = 0 ∧ dv (q fun k => C (a k)) 0 0 = 1 := by
  refine ⟨by simp [q], ?_, ?_⟩
  · simp [du, q]
  · simp [dv, q, Fin.prod_univ_three, derivative_mul]

/-- n ≥ 4: q(0, 0) = 0 and both partial derivatives of q vanish at (0, 0). -/
theorem q_singular {n : ℕ} (hn : 4 ≤ n) (a : Fin n → R) :
    q a 0 0 = 0 ∧ du (q fun k => C (a k)) 0 0 = 0 ∧ dv (q fun k => C (a k)) 0 0 = 0 := by
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 4 := ⟨n - 4, by omega⟩
  have hprod : ∏ k : Fin (m + 4), (0 - C (a k) * (0 + X)) = C (∏ k, -a k) * X ^ (m + 4) := by
    simp only [zero_sub, zero_add, ← neg_mul, Finset.prod_mul_distrib, Finset.prod_const,
      Finset.card_univ, Fintype.card_fin, map_prod, map_neg]
  refine ⟨by simp [q], by simp [du, q], ?_⟩
  simp only [dv, q, map_zero, hprod, show m + 4 - 2 = m + 2 by omega]
  simp [derivative_mul]

end MishchenkoFomenko.Ch04.Compactification

#print axioms MishchenkoFomenko.Ch04.Compactification.eval_F
#print axioms MishchenkoFomenko.Ch04.Compactification.eval_q
#print axioms MishchenkoFomenko.Ch04.Compactification.F_zero
#print axioms MishchenkoFomenko.Ch04.Compactification.du_F
#print axioms MishchenkoFomenko.Ch04.Compactification.dv_F
#print axioms MishchenkoFomenko.Ch04.Compactification.singular
#print axioms MishchenkoFomenko.Ch04.Compactification.smooth_one
#print axioms MishchenkoFomenko.Ch04.Compactification.q_three
#print axioms MishchenkoFomenko.Ch04.Compactification.q_singular
