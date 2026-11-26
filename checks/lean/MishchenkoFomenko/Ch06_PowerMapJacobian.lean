/-
Book: А. С. Мищенко, А. Т. Фоменко, «Курс дифференциальной геометрии и
топологии», 2-е изд. (Факториал Пресс, 2000), гл. 6, § 3, п. 3, p. 403:
the fundamental theorem of algebra, the map w = zⁿ in the local
coordinates z = x + iy, w = u + iv and its Jacobian
det ∂(u, v)/∂(x, y) = n² |z^(n−1)|² > 0 for z ≠ 0.

Notation.  ℂ is a real vector space with the basis 1, i
(`Complex.basisOneI`); `LinearMap.mulLeft ℝ c` is the ℝ-linear map
h ↦ c h of ℂ.  `HasRealDeriv f L z` says that the ℝ-linear map `L` is the
differential of f at z: f(z + h) = f(z) + L h + o(h) as h → 0 (mathlib's
definition of the Fréchet derivative, written with `Asymptotics.IsLittleO`).

What is proved: the matrix of h ↦ c h in the basis 1, i is
(Re c, −Im c; Im c, Re c), and its determinant `LinearMap.det` equals
`Algebra.norm ℝ c` = |c|²; the differential is unique, and that of z ↦ zⁿ
at z is h ↦ n z^(n−1) h; hence the Jacobian of z ↦ zⁿ at z is
n² |z^(n−1)|² = n² |z|^(2(n−1)), positive for n ≥ 1 and z ≠ 0.

Not covered: the degree of the map and the count of the n roots of
zⁿ = 1 (pp. 403-404), the extension to ℂP¹ and the homotopy.
-/
import Mathlib.LinearAlgebra.Complex.Module
import Mathlib.LinearAlgebra.Determinant
import Mathlib.RingTheory.Norm.Defs
import Mathlib.Analysis.Asymptotics.Lemmas
import Mathlib.Analysis.Complex.Basic

namespace MishchenkoFomenko.Ch06.PowerMapJacobian

open Complex Asymptotics Filter Topology

/-- The matrix of h ↦ c h in the basis 1, i (as `Algebra.leftMulMatrix_complex`). -/
theorem leftMulMatrix_eq (c : ℂ) :
    Algebra.leftMulMatrix Complex.basisOneI c = !![c.re, -c.im; c.im, c.re] := by
  ext i j
  rw [Algebra.leftMulMatrix_eq_repr_mul, Complex.coe_basisOneI_repr, Complex.coe_basisOneI, mul_re,
    mul_im, Matrix.of_apply]
  fin_cases j <;> fin_cases i <;> simp

theorem toMatrix_mulLeft (c : ℂ) :
    LinearMap.toMatrix Complex.basisOneI Complex.basisOneI (LinearMap.mulLeft ℝ c) =
      !![c.re, -c.im; c.im, c.re] := by
  rw [← leftMulMatrix_eq, Algebra.leftMulMatrix_apply, Algebra.coe_lmul_eq_mul]
  rfl

/-- The real determinant of h ↦ c h is Algebra.norm ℝ c = |c|². -/
theorem det_mulLeft (c : ℂ) :
    LinearMap.det (LinearMap.mulLeft ℝ c) = Algebra.norm ℝ c ∧
      LinearMap.det (LinearMap.mulLeft ℝ c) = Complex.normSq c := by
  have h : LinearMap.det (LinearMap.mulLeft ℝ c) = Algebra.norm ℝ c := by
    rw [Algebra.norm_apply, Algebra.coe_lmul_eq_mul]
    rfl
  refine ⟨h, ?_⟩
  rw [← LinearMap.det_toMatrix Complex.basisOneI, toMatrix_mulLeft, Matrix.det_fin_two_of,
    normSq_apply]
  ring

/-- `L` is the differential of `f` at `z`. -/
def HasRealDeriv (f : ℂ → ℂ) (L : ℂ →ₗ[ℝ] ℂ) (z : ℂ) : Prop :=
  (fun h => f (z + h) - f z - L h) =o[𝓝 0] fun h => h

/-- The differential is unique. -/
theorem HasRealDeriv.unique {f : ℂ → ℂ} {L L' : ℂ →ₗ[ℝ] ℂ} {z : ℂ} (h₁ : HasRealDeriv f L z)
    (h₂ : HasRealDeriv f L' z) : L = L' := by
  have hD : (fun h : ℂ => L' h - L h) =o[𝓝 0] fun h => h :=
    (IsLittleO.sub h₁ h₂).congr_left fun h => by ring
  ext v
  by_contra hne
  have hv : v ≠ 0 := by
    rintro rfl
    simp at hne
  have hw : 0 < ‖L' v - L v‖ := norm_pos_iff.mpr (sub_ne_zero.mpr (Ne.symm hne))
  have hvpos : 0 < ‖v‖ := norm_pos_iff.mpr hv
  obtain ⟨ε, hε, hball⟩ := Metric.eventually_nhds_iff.mp
    (isLittleO_iff.mp hD (c := ‖L' v - L v‖ / (2 * ‖v‖)) (by positivity))
  set t : ℝ := ε / (2 * ‖v‖) with ht_def
  have ht : 0 < t := by positivity
  have htv : t * ‖v‖ = ε / 2 := by
    rw [ht_def]
    field_simp
  have hsmul : ((t : ℂ) * v) = t • v := (Complex.real_smul).symm
  have hdist : dist ((t : ℂ) * v) 0 < ε := by
    rw [dist_zero_right, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht, htv]
    linarith
  have key := hball hdist
  rw [hsmul, map_smul, map_smul, ← smul_sub, norm_smul, norm_smul, Real.norm_eq_abs,
    abs_of_pos ht] at key
  have : t * ‖L' v - L v‖ ≤ t * ‖L' v - L v‖ / 2 := by
    calc t * ‖L' v - L v‖ ≤ ‖L' v - L v‖ / (2 * ‖v‖) * (t * ‖v‖) := key
      _ = t * ‖L' v - L v‖ / 2 := by field_simp
  nlinarith [mul_pos ht hw]

/-- The differential of z ↦ zⁿ at z is h ↦ n z^(n−1) h. -/
theorem hasRealDeriv_pow (n : ℕ) (z : ℂ) :
    HasRealDeriv (fun z => z ^ n) (LinearMap.mulLeft ℝ ((n : ℂ) * z ^ (n - 1))) z := by
  unfold HasRealDeriv
  induction n with
  | zero => simp
  | succ n ih =>
    have hb : (fun h : ℂ => z + h) =O[𝓝 0] (fun _ => (1 : ℂ)) :=
      ((continuous_const.add continuous_id).tendsto' 0 z (by simp)).isBigO_one ℂ
    have h1 : (fun h : ℂ => (z + h) * ((z + h) ^ n - z ^ n - (n : ℂ) * (z ^ (n - 1) * h))) =o[𝓝 0]
        fun h => h := by
      simpa using hb.mul_isLittleO ih
    have h2 : (fun h : ℂ => (n : ℂ) * z ^ (n - 1) * h ^ 2) =o[𝓝 0] fun h => h :=
      (isLittleO_pow_id (by norm_num : 1 < 2)).const_mul_left _
    refine (h1.add h2).congr' ?_ (by simp)
    filter_upwards with h
    simp only [LinearMap.mulLeft_apply]
    rcases n with _ | m
    · simp
    · simp only [Nat.add_sub_cancel, Nat.cast_add, Nat.cast_one, pow_succ]
      ring

/-- The Jacobian of z ↦ zⁿ: for the differential L of z ↦ zⁿ at z,
det L = det ∂(u, v)/∂(x, y) = n² |z|^(2(n−1)), positive for n ≥ 1, z ≠ 0. -/
theorem jacobian_pow (n : ℕ) (hn : 1 ≤ n) (z : ℂ) (hz : z ≠ 0) (L : ℂ →ₗ[ℝ] ℂ)
    (hL : HasRealDeriv (fun z => z ^ n) L z) :
    LinearMap.det L = (n : ℝ) ^ 2 * Complex.normSq z ^ (n - 1) ∧ 0 < LinearMap.det L := by
  have h : LinearMap.det L = (n : ℝ) ^ 2 * Complex.normSq z ^ (n - 1) := by
    rw [← hL.unique (hasRealDeriv_pow n z) |>.symm, (det_mulLeft _).2, map_mul, map_pow,
      normSq_natCast]
    ring
  refine ⟨h, ?_⟩
  rw [h]
  have : (0 : ℝ) < n := by exact_mod_cast hn
  have : 0 < Complex.normSq z := Complex.normSq_pos.mpr hz
  positivity

end MishchenkoFomenko.Ch06.PowerMapJacobian

#print axioms MishchenkoFomenko.Ch06.PowerMapJacobian.leftMulMatrix_eq
#print axioms MishchenkoFomenko.Ch06.PowerMapJacobian.toMatrix_mulLeft
#print axioms MishchenkoFomenko.Ch06.PowerMapJacobian.det_mulLeft
#print axioms MishchenkoFomenko.Ch06.PowerMapJacobian.HasRealDeriv.unique
#print axioms MishchenkoFomenko.Ch06.PowerMapJacobian.hasRealDeriv_pow
#print axioms MishchenkoFomenko.Ch06.PowerMapJacobian.jacobian_pow
