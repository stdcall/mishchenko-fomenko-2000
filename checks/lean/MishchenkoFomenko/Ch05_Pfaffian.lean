/-
Book: А. С. Мищенко, А. Т. Фоменко, «Курс дифференциальной геометрии и
топологии», 2-е изд. (Факториал Пресс, 2000), гл. 5, § 2, pp. 326-327:
Theorem 1 (a skew scalar product ω is nondegenerate iff Ω = ω ∧ … ∧ ω/n!
is nonzero) and its example n = 2, where Ω = f dx¹ ∧ … ∧ dx⁴ and the
book states f = ±√det(ω_ij).

Notation.  `w : Matrix (Fin 4) (Fin 4) A` is the matrix (ω_ij) at a point,
over any commutative ring `A`; the book's indices 1, …, 4 are `0`, …, `3`.
Skew-symmetry is ω_ji = −ω_ij with zero diagonal (over a ring where 2 may
be a zero divisor the diagonal is required separately).  `pf w` is
ω₁₂ω₃₄ − ω₁₃ω₂₄ + ω₁₄ω₂₃, the coefficient f of Ω = ω ∧ ω/2! for
ω = Σ_{i<j} ω_ij dx^i ∧ dx^j; for the book's ω = ω₁₂ dx¹ ∧ dx² +
ω₃₄ dx³ ∧ dx⁴ it is ω₁₂ω₃₄, as on p. 327.

What is proved: det(ω_ij) = f² for every skew 4 × 4 matrix over a
commutative ring; over ℝ, f = √det or f = −√det; for
ω = −dx¹ ∧ dx² + dx³ ∧ dx⁴ (ω₁₂ = −1, ω₃₄ = 1) f = −1 = −√det, so the
minus sign does occur and f is not always +√det.

Not covered: the exterior algebra (that ω ∧ ω/2! = f dx¹ ∧ … ∧ dx⁴ with
this f), Theorem 1 itself, the reduction of a skew matrix to canonical
form and dimensions other than 4.
-/
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Analysis.Real.Sqrt
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring

namespace MishchenkoFomenko.Ch05.Pfaffian

variable {A : Type*} [CommRing A]

/-- f = ω₁₂ω₃₄ − ω₁₃ω₂₄ + ω₁₄ω₂₃ (the Pfaffian). -/
def pf (w : Matrix (Fin 4) (Fin 4) A) : A :=
  w 0 1 * w 2 3 - w 0 2 * w 1 3 + w 0 3 * w 1 2

theorem det_skew (a b c d e f : A) :
    (!![0, a, b, c; -a, 0, d, e; -b, -d, 0, f; -c, -e, -f, 0] : Matrix (Fin 4) (Fin 4) A).det =
      (a * f - b * e + c * d) ^ 2 := by
  have s12 : Fin.succAbove (1 : Fin 4) (2 : Fin 3) = 3 := rfl
  have s22 : Fin.succAbove (2 : Fin 4) (2 : Fin 3) = 3 := rfl
  have s32 : Fin.succAbove (3 : Fin 4) (2 : Fin 3) = 2 := rfl
  rw [Matrix.det_succ_row_zero]
  simp [Fin.sum_univ_succ, Matrix.det_fin_three, s12, s22, s32]
  ring

theorem skew_eq (w : Matrix (Fin 4) (Fin 4) A) (hskew : ∀ i j, w j i = -w i j)
    (hdiag : ∀ i, w i i = 0) :
    w = !![0, w 0 1, w 0 2, w 0 3; -w 0 1, 0, w 1 2, w 1 3;
      -w 0 2, -w 1 2, 0, w 2 3; -w 0 3, -w 1 3, -w 2 3, 0] := by
  have h10 := hskew 0 1
  have h20 := hskew 0 2
  have h30 := hskew 0 3
  have h21 := hskew 1 2
  have h31 := hskew 1 3
  have h32 := hskew 2 3
  ext i j
  fin_cases i <;> fin_cases j <;> simp [hdiag, h10, h20, h30, h21, h31, h32]

/-- det(ω_ij) = f² for a skew 4 × 4 matrix over any commutative ring. -/
theorem det_eq_pf_sq (w : Matrix (Fin 4) (Fin 4) A) (hskew : ∀ i j, w j i = -w i j)
    (hdiag : ∀ i, w i i = 0) : w.det = pf w ^ 2 := by
  conv_lhs => rw [skew_eq w hskew hdiag]
  rw [det_skew, pf]

/-- The book's case ω = ω₁₂ dx¹ ∧ dx² + ω₃₄ dx³ ∧ dx⁴: f = ω₁₂ω₃₄, det = (ω₁₂ω₃₄)². -/
theorem book_example (a b : A) :
    pf (!![0, a, 0, 0; -a, 0, 0, 0; 0, 0, 0, b; 0, 0, -b, 0] : Matrix (Fin 4) (Fin 4) A) =
        a * b ∧
      (!![0, a, 0, 0; -a, 0, 0, 0; 0, 0, 0, b; 0, 0, -b, 0] : Matrix (Fin 4) (Fin 4) A).det =
        (a * b) ^ 2 := by
  refine ⟨by simp [pf], ?_⟩
  have h := det_skew a 0 0 0 0 b
  simp only [neg_zero, mul_zero, sub_zero, add_zero] at h
  rw [h]

/-- Over ℝ: f = √det(ω_ij) or f = −√det(ω_ij). -/
theorem pf_eq_pm_sqrt_det (w : Matrix (Fin 4) (Fin 4) ℝ) (hskew : ∀ i j, w j i = -w i j)
    (hdiag : ∀ i, w i i = 0) :
    pf w = Real.sqrt w.det ∨ pf w = -Real.sqrt w.det := by
  rw [det_eq_pf_sq w hskew hdiag, Real.sqrt_sq_eq_abs]
  rcases le_or_gt 0 (pf w) with h | h
  · exact Or.inl (abs_of_nonneg h).symm
  · right
    rw [abs_of_neg h, neg_neg]

/-- ω = −dx¹ ∧ dx² + dx³ ∧ dx⁴. -/
def ωneg : Matrix (Fin 4) (Fin 4) ℝ := !![0, -1, 0, 0; 1, 0, 0, 0; 0, 0, 0, 1; 0, 0, -1, 0]

/-- For ωneg the coefficient f is −1 while det = 1: f = −√det ≠ √det. -/
theorem minus_sign_needed :
    pf ωneg = -1 ∧ ωneg.det = 1 ∧ pf ωneg = -Real.sqrt ωneg.det ∧ pf ωneg ≠ Real.sqrt ωneg.det := by
  have hpf : pf ωneg = -1 := by norm_num [pf, ωneg]
  have hdet : ωneg.det = 1 := by
    have h := det_skew (-1 : ℝ) 0 0 0 0 1
    simp only [neg_neg, neg_zero, mul_zero, sub_zero, add_zero, mul_one] at h
    rw [ωneg, h]
    norm_num
  refine ⟨hpf, hdet, ?_, ?_⟩
  · rw [hpf, hdet, Real.sqrt_one]
  · rw [hpf, hdet, Real.sqrt_one]
    norm_num

end MishchenkoFomenko.Ch05.Pfaffian

#print axioms MishchenkoFomenko.Ch05.Pfaffian.det_skew
#print axioms MishchenkoFomenko.Ch05.Pfaffian.skew_eq
#print axioms MishchenkoFomenko.Ch05.Pfaffian.det_eq_pf_sq
#print axioms MishchenkoFomenko.Ch05.Pfaffian.book_example
#print axioms MishchenkoFomenko.Ch05.Pfaffian.pf_eq_pm_sqrt_det
#print axioms MishchenkoFomenko.Ch05.Pfaffian.minus_sign_needed
