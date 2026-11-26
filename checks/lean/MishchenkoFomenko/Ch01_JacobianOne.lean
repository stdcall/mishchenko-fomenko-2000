/-
Book: А. С. Мищенко, А. Т. Фоменко, «Курс дифференциальной геометрии и
топологии», 2-е изд. (Факториал Пресс, 2000), гл. 1, § 1, п. 2, p. 16:
the question whether a smooth map f of euclidean space onto itself with
0 < ε ≤ J(f) ≤ N < ∞ is one-to-one, and the editorial note answering it
in the negative for n = 2.

Notation.  T(u, v) = (T₁, T₂) = (e^u cos(v e^(−2u)), e^u sin(v e^(−2u))),
the map of the note; θ = v e^(−2u).  `HasDeriv f f' x` says that f has the
derivative f' at x: f(x + h) = f(x) + f' h + o(h) as h → 0, written with
`Asymptotics.IsLittleO` (the form of mathlib's `HasDerivAt` in
`hasDerivAt_iff_isLittleO_nhds_zero`; the calculus library itself is not
imported); the rules for sums, products, compositions,
exp, sin and cos are proved below from this definition and the bounds
|e^h − 1 − h| ≤ h², |cos h − (1 − h²/2)| ≤ |h|⁴·5/96,
|sin h − (h − h³/6)| ≤ |h|⁵/100 for |h| ≤ 1 (mathlib).  The partial
derivatives of T are the derivatives of u ↦ T(u, v) and v ↦ T(u, v).

What is proved: the derivative is unique; the four partial derivatives
∂T₁/∂u = e^u (cos θ + 2θ sin θ), ∂T₁/∂v = −e^u e^(−2u) sin θ,
∂T₂/∂u = e^u (sin θ − 2θ cos θ), ∂T₂/∂v = e^u e^(−2u) cos θ; hence
J(T) = ∂T₁/∂u ∂T₂/∂v − ∂T₁/∂v ∂T₂/∂u = 1 at every point (so
ε = N = 1 bound it); T(u, v) = T(u, v + 2π e^(2u)), and T is not
one-to-one: T(0, 0) = T(0, 2π); |T|² = e^(2u) > 0, so T maps the plane
into, not onto, itself (the note says «в себя»).

Not covered: smoothness of T beyond the first partial derivatives,
Hadamard's theorem and the other statements of the note; a map of ℝ²
onto itself with the same properties is not constructed.
-/
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.Asymptotics.Lemmas

namespace MishchenkoFomenko.Ch01.JacobianOne

open Asymptotics Filter Topology Real

/-- f has the derivative f' at x: f(x + h) − f(x) − f' h = o(h). -/
def HasDeriv (f : ℝ → ℝ) (f' x : ℝ) : Prop :=
  (fun h => f (x + h) - f x - f' * h) =o[𝓝 0] fun h => h

variable {f g : ℝ → ℝ} {f' g' x : ℝ}

theorem HasDeriv.congr_deriv {a b : ℝ} (h : HasDeriv f a x) (e : a = b) : HasDeriv f b x :=
  e ▸ h

/-- The derivative is unique. -/
theorem HasDeriv.unique {a b : ℝ} (ha : HasDeriv f a x) (hb : HasDeriv f b x) : a = b := by
  have h : (fun h => (a - b) * h) =o[𝓝 0] fun h => h :=
    (IsLittleO.sub hb ha).congr_left fun h => by ring
  by_contra hab
  have hpos : 0 < |a - b| := abs_pos.mpr (sub_ne_zero.mpr hab)
  have hev := isLittleO_iff.mp h (half_pos hpos)
  obtain ⟨ε, hε, hball⟩ := Metric.eventually_nhds_iff.mp hev
  have hε2 : dist (ε / 2) 0 < ε := by
    rw [Real.dist_eq, sub_zero, abs_of_pos (half_pos hε)]
    linarith
  have key := hball hε2
  simp only [Real.norm_eq_abs, abs_mul, abs_of_pos (half_pos hε)] at key
  nlinarith

theorem HasDeriv.isBigO (hf : HasDeriv f f' x) :
    (fun h => f (x + h) - f x) =O[𝓝 0] fun h => h :=
  ((IsLittleO.isBigO hf).add (isBigO_const_mul_self f' (fun h : ℝ => h) _)).congr_left
    fun h => by ring

theorem HasDeriv.tendsto (hf : HasDeriv f f' x) :
    Tendsto (fun h => f (x + h) - f x) (𝓝 0) (𝓝 0) :=
  hf.isBigO.trans_tendsto tendsto_id

theorem hasDeriv_const (c x : ℝ) : HasDeriv (fun _ => c) 0 x := by
  simp only [HasDeriv, sub_self, zero_mul]
  exact isLittleO_zero _ _

theorem hasDeriv_id (x : ℝ) : HasDeriv (fun y => y) 1 x := by
  simp only [HasDeriv, add_sub_cancel_left, one_mul, sub_self]
  exact isLittleO_zero _ _

theorem HasDeriv.add (hf : HasDeriv f f' x) (hg : HasDeriv g g' x) :
    HasDeriv (fun y => f y + g y) (f' + g') x :=
  (IsLittleO.add hf hg).congr_left fun h => by ring

theorem HasDeriv.const_mul (c : ℝ) (hf : HasDeriv f f' x) :
    HasDeriv (fun y => c * f y) (c * f') x :=
  (hf.const_mul_left c).congr_left fun h => by ring

theorem HasDeriv.mul (hf : HasDeriv f f' x) (hg : HasDeriv g g' x) :
    HasDeriv (fun y => f y * g y) (f' * g x + f x * g') x := by
  have hgb : (fun h => g (x + h)) =O[𝓝 0] fun _ => (1 : ℝ) := by
    have : Tendsto (fun h => g (x + h)) (𝓝 0) (𝓝 (g x)) := by
      simpa using hg.tendsto.add_const (g x)
    exact this.isBigO_one ℝ
  have t₁ : (fun h => (f (x + h) - f x - f' * h) * g (x + h)) =o[𝓝 0] fun h => h := by
    simpa using hf.mul_isBigO hgb
  have t₂ := hg.const_mul_left (f x)
  have t₃ : (fun h => f' * h * (g (x + h) - g x)) =o[𝓝 0] fun h => h := by
    simpa using (isBigO_const_mul_self f' (fun h : ℝ => h) _).mul_isLittleO
      (isLittleO_one_iff ℝ |>.mpr hg.tendsto)
  exact ((t₁.add t₂).add t₃).congr_left fun h => by ring

theorem HasDeriv.comp (hf : HasDeriv f f' (g x)) (hg : HasDeriv g g' x) :
    HasDeriv (fun y => f (g y)) (f' * g') x := by
  have t₁ : (fun h => f (g x + (g (x + h) - g x)) - f (g x) - f' * (g (x + h) - g x))
      =o[𝓝 0] fun h => h :=
    (hf.comp_tendsto hg.tendsto).trans_isBigO hg.isBigO
  have t₂ := hg.const_mul_left f'
  refine (t₁.add t₂).congr_left fun h => ?_
  simp only [add_sub_cancel]
  ring

/-- Eventually |h| ≤ 1 near 0. -/
theorem eventually_abs_le_one : ∀ᶠ h : ℝ in 𝓝 0, |h| ≤ 1 := by
  filter_upwards [Ioo_mem_nhds (by norm_num : (-1 : ℝ) < 0) (by norm_num : (0 : ℝ) < 1)] with h hh
  exact abs_le.mpr ⟨hh.1.le, hh.2.le⟩

/-- A function bounded by h² near 0 is o(h). -/
theorem isLittleO_of_sq_bound {φ : ℝ → ℝ} (hφ : ∀ h : ℝ, |h| ≤ 1 → |φ h| ≤ h ^ 2) :
    φ =o[𝓝 0] fun h => h := by
  have : φ =O[𝓝 0] fun h => h ^ 2 := by
    refine IsBigO.of_bound 1 ?_
    filter_upwards [eventually_abs_le_one] with h hh
    simpa [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg h)] using hφ h hh
  exact this.trans_isLittleO (isLittleO_pow_id (by norm_num))

theorem hasDeriv_exp (x : ℝ) : HasDeriv exp (exp x) x := by
  have h := (isLittleO_of_sq_bound fun h hh => abs_exp_sub_one_sub_id_le hh).const_mul_left
    (exp x)
  refine h.congr_left fun h => ?_
  rw [exp_add]
  ring

theorem abs_cos_sub_one_le {h : ℝ} (hh : |h| ≤ 1) : |cos h - 1| ≤ h ^ 2 := by
  have hb := cos_bound hh
  have h4 : |h| ^ 4 ≤ h ^ 2 := by
    have : |h| ^ 4 = h ^ 2 * |h| ^ 2 := by rw [show (4 : ℕ) = 2 + 2 from rfl, pow_add, sq_abs]
    rw [this]
    exact mul_le_of_le_one_right (sq_nonneg h) (by nlinarith [abs_nonneg h])
  have := abs_sub_le (cos h) (1 - h ^ 2 / 2) 1
  rw [show |1 - h ^ 2 / 2 - 1| = h ^ 2 / 2 by
    rw [show 1 - h ^ 2 / 2 - 1 = -(h ^ 2 / 2) by ring, abs_neg, abs_of_nonneg (by positivity)]]
    at this
  nlinarith

theorem abs_sin_sub_self_le {h : ℝ} (hh : |h| ≤ 1) : |sin h - h| ≤ h ^ 2 := by
  have hb := sin_bound hh
  have ha := abs_nonneg h
  have h3 : |h| ^ 3 ≤ h ^ 2 := by
    rw [← sq_abs h, pow_succ]
    exact mul_le_of_le_one_right (sq_nonneg _) hh
  have h5 : |h| ^ 5 ≤ h ^ 2 := by
    rw [← sq_abs h, show (5 : ℕ) = 2 + 3 from rfl, pow_add]
    exact mul_le_of_le_one_right (sq_nonneg _) (pow_le_one₀ ha hh)
  have := abs_sub_le (sin h) (h - h ^ 3 / 6) h
  rw [show |h - h ^ 3 / 6 - h| = |h| ^ 3 / 6 by
    rw [show h - h ^ 3 / 6 - h = -(h ^ 3 / 6) by ring, abs_neg, abs_div, abs_pow]
    norm_num] at this
  nlinarith

theorem hasDeriv_sin (x : ℝ) : HasDeriv sin (cos x) x := by
  have h₁ := (isLittleO_of_sq_bound fun h hh => abs_cos_sub_one_le hh).const_mul_left (sin x)
  have h₂ := (isLittleO_of_sq_bound fun h hh => abs_sin_sub_self_le hh).const_mul_left (cos x)
  refine (h₁.add h₂).congr_left fun h => ?_
  rw [sin_add]
  ring

theorem hasDeriv_cos (x : ℝ) : HasDeriv cos (-sin x) x := by
  have h₁ := (isLittleO_of_sq_bound fun h hh => abs_cos_sub_one_le hh).const_mul_left (cos x)
  have h₂ := (isLittleO_of_sq_bound fun h hh => abs_sin_sub_self_le hh).const_mul_left (sin x)
  refine (h₁.sub h₂).congr_left fun h => ?_
  rw [cos_add]
  ring

/-! The map of the note. -/

/-- T₁(u, v) = e^u cos(v e^(−2u)). -/
noncomputable def T₁ (u v : ℝ) : ℝ := exp u * cos (v * exp (-2 * u))

/-- T₂(u, v) = e^u sin(v e^(−2u)). -/
noncomputable def T₂ (u v : ℝ) : ℝ := exp u * sin (v * exp (-2 * u))

/-- d/du (v e^(−2u)) = −2 v e^(−2u). -/
theorem hasDeriv_theta_u (u v : ℝ) :
    HasDeriv (fun u => v * exp (-2 * u)) (-2 * (v * exp (-2 * u))) u := by
  have hlin : HasDeriv (fun u => -2 * u) (-2 * 1) u := (hasDeriv_id u).const_mul (-2)
  have he := (hasDeriv_exp (-2 * u)).comp hlin
  exact (he.const_mul v).congr_deriv (by ring)

theorem hasDeriv_theta_v (u v : ℝ) :
    HasDeriv (fun v => v * exp (-2 * u)) (exp (-2 * u)) v :=
  ((hasDeriv_id v).mul (hasDeriv_const (exp (-2 * u)) v)).congr_deriv (by ring)

theorem dT₁_du (u v : ℝ) :
    HasDeriv (fun u => T₁ u v)
      (exp u * (cos (v * exp (-2 * u)) + 2 * (v * exp (-2 * u)) * sin (v * exp (-2 * u)))) u :=
  ((hasDeriv_exp u).mul ((hasDeriv_cos _).comp (hasDeriv_theta_u u v))).congr_deriv (by ring)

theorem dT₁_dv (u v : ℝ) :
    HasDeriv (fun v => T₁ u v) (-(exp u * exp (-2 * u) * sin (v * exp (-2 * u)))) v :=
  (((hasDeriv_cos _).comp (hasDeriv_theta_v u v)).const_mul (exp u)).congr_deriv (by ring)

theorem dT₂_du (u v : ℝ) :
    HasDeriv (fun u => T₂ u v)
      (exp u * (sin (v * exp (-2 * u)) - 2 * (v * exp (-2 * u)) * cos (v * exp (-2 * u)))) u :=
  ((hasDeriv_exp u).mul ((hasDeriv_sin _).comp (hasDeriv_theta_u u v))).congr_deriv (by ring)

theorem dT₂_dv (u v : ℝ) :
    HasDeriv (fun v => T₂ u v) (exp u * exp (-2 * u) * cos (v * exp (-2 * u))) v :=
  (((hasDeriv_sin _).comp (hasDeriv_theta_v u v)).const_mul (exp u)).congr_deriv (by ring)

/-- J(T) = 1 at every point: for any partial derivatives of T at (u, v),
∂T₁/∂u ∂T₂/∂v − ∂T₁/∂v ∂T₂/∂u = 1. -/
theorem jacobian_eq_one (u v a b c d : ℝ) (ha : HasDeriv (fun u => T₁ u v) a u)
    (hb : HasDeriv (fun v => T₁ u v) b v) (hc : HasDeriv (fun u => T₂ u v) c u)
    (hd : HasDeriv (fun v => T₂ u v) d v) : a * d - b * c = 1 := by
  rw [ha.unique (dT₁_du u v), hb.unique (dT₁_dv u v), hc.unique (dT₂_du u v),
    hd.unique (dT₂_dv u v)]
  have he : exp u * (exp u * exp (-2 * u)) = 1 := by
    rw [← exp_add, ← exp_add, show u + (u + -2 * u) = 0 by ring, exp_zero]
  set θ := v * exp (-2 * u)
  have hs := sin_sq_add_cos_sq θ
  linear_combination (exp u * (exp u * exp (-2 * u))) * hs + he

/-- T(u, v) = T(u, v + 2π e^(2u)). -/
theorem periodic (u v : ℝ) :
    T₁ u (v + 2 * π * exp (2 * u)) = T₁ u v ∧ T₂ u (v + 2 * π * exp (2 * u)) = T₂ u v := by
  have h : (v + 2 * π * exp (2 * u)) * exp (-2 * u) = v * exp (-2 * u) + 2 * π := by
    rw [add_mul, mul_assoc, ← exp_add, show 2 * u + -2 * u = 0 by ring, exp_zero, mul_one]
  refine ⟨?_, ?_⟩ <;> simp only [T₁, T₂, h, cos_add_two_pi, sin_add_two_pi]

/-- T is not one-to-one: T(0, 0) = T(0, 2π). -/
theorem not_injective : ¬Function.Injective fun p : ℝ × ℝ => (T₁ p.1 p.2, T₂ p.1 p.2) := by
  intro hT
  have h := periodic 0 0
  simp only [mul_zero, exp_zero, mul_one, zero_add] at h
  have := @hT (0, 2 * π) (0, 0) (by simp only [h.1, h.2])
  simp only [Prod.mk.injEq, true_and] at this
  linarith [pi_pos]

/-- |T(u, v)|² = e^(2u) > 0: the image of T misses the origin. -/
theorem norm_sq (u v : ℝ) :
    T₁ u v ^ 2 + T₂ u v ^ 2 = exp (2 * u) ∧ 0 < T₁ u v ^ 2 + T₂ u v ^ 2 := by
  have h : T₁ u v ^ 2 + T₂ u v ^ 2 = exp (2 * u) := by
    have hs := sin_sq_add_cos_sq (v * exp (-2 * u))
    rw [show 2 * u = u + u by ring, exp_add]
    simp only [T₁, T₂]
    linear_combination exp u * exp u * hs
  exact ⟨h, h ▸ exp_pos _⟩

end MishchenkoFomenko.Ch01.JacobianOne

#print axioms MishchenkoFomenko.Ch01.JacobianOne.HasDeriv.unique
#print axioms MishchenkoFomenko.Ch01.JacobianOne.HasDeriv.mul
#print axioms MishchenkoFomenko.Ch01.JacobianOne.HasDeriv.comp
#print axioms MishchenkoFomenko.Ch01.JacobianOne.hasDeriv_exp
#print axioms MishchenkoFomenko.Ch01.JacobianOne.hasDeriv_sin
#print axioms MishchenkoFomenko.Ch01.JacobianOne.hasDeriv_cos
#print axioms MishchenkoFomenko.Ch01.JacobianOne.dT₁_du
#print axioms MishchenkoFomenko.Ch01.JacobianOne.dT₁_dv
#print axioms MishchenkoFomenko.Ch01.JacobianOne.dT₂_du
#print axioms MishchenkoFomenko.Ch01.JacobianOne.dT₂_dv
#print axioms MishchenkoFomenko.Ch01.JacobianOne.jacobian_eq_one
#print axioms MishchenkoFomenko.Ch01.JacobianOne.periodic
#print axioms MishchenkoFomenko.Ch01.JacobianOne.not_injective
#print axioms MishchenkoFomenko.Ch01.JacobianOne.norm_sq
