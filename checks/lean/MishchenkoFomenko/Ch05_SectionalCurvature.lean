/-
Book: А. С. Мищенко, А. Т. Фоменко, «Курс дифференциальной геометрии и
топологии», 2-е изд. (Факториал Пресс, 2000), гл. 5, § 5, п. 5,
pp. 370-371: the curvature R(σ) in a two-dimensional direction and its
editorial note, Lemma 3 (R(σ) = R_{βj,kl} X^β Y^j X^k Y^l) and Lemma 4
(R(σ) = K(P) on M²).

Notation.  Indices run over `Fin n`; the book's indices 1, 2 of Lemma 4
are `0`, `1`.  `R β j k l` is the book's R_{βj,kl} (index lowered with
g), `X`, `Y` are the coordinates X^α, Y^β of the vectors X⃗, Y⃗, the ring
is any commutative ring.
* `corrected R X Y` = Σ R_{βj,kl} X^β Y^j X^k Y^l, the contraction of
  Lemma 3, i.e. ⟨R(X, Y)Y; X⟩ = g_{αβ} X^β [R(X, Y)Y]^α (the corrected
  definition of R(σ));
* `printed R X Y` = Σ R_{βj,kl} Y^β X^j X^k Y^l, i.e. ⟨R(X, Y)X; Y⟩ =
  g_{αβ} Y^β [R(X, Y)X]^α with [R(X, Y)Z]^α = R^α_{j,kl} Z^j X^k Y^l
  (the printed definition).

What is proved.  For every n and every R skew-symmetric in its first pair
of indices, printed = −corrected.  For n = 2 and R skew-symmetric in each
pair (with R_{ii,kl} = R_{ij,kk} = 0), corrected = R_{12,12}
(X¹Y² − X²Y¹)², the computation in the proof of Lemma 4, and it equals
the printed four-term line R_{12,12}(X²X²Y¹Y¹ − X²X¹Y²Y¹ + X¹X¹Y²Y² −
X¹X²Y¹Y²); so with
R_{12,12} = K and (X¹Y² − X²Y¹)² = 1 (the parallelogram of area 1) the
corrected R(σ) is K and the printed one is −K.  The explicit tensor
R_{12,12} = R_{21,21} = K, R_{12,21} = R_{21,12} = −K, others 0, is the
case `R₂ K`.

Not covered: that R_{12,12} = K(P) in coordinates orthonormal at P, and
the identification of R(X, Y) with the coordinate tensor; the sign
convention of the section is taken as given.
-/
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.Ring
import Mathlib.Tactic.FinCases

namespace MishchenkoFomenko.Ch05.SectionalCurvature

open Finset

variable {A : Type*} [CommRing A]

/-- Σ R_{βj,kl} X^β Y^j X^k Y^l = ⟨R(X, Y)Y; X⟩ (Lemma 3, the corrected R(σ)). -/
def corrected {n : ℕ} (R : Fin n → Fin n → Fin n → Fin n → A) (X Y : Fin n → A) : A :=
  ∑ β, ∑ j, ∑ k, ∑ l, R β j k l * X β * Y j * X k * Y l

/-- Σ R_{βj,kl} Y^β X^j X^k Y^l = ⟨R(X, Y)X; Y⟩ (the printed R(σ)). -/
def printed {n : ℕ} (R : Fin n → Fin n → Fin n → Fin n → A) (X Y : Fin n → A) : A :=
  ∑ β, ∑ j, ∑ k, ∑ l, R β j k l * Y β * X j * X k * Y l

/-- In any dimension, for R skew-symmetric in the first pair of indices the
printed contraction is minus the corrected one. -/
theorem printed_eq_neg_corrected {n : ℕ} (R : Fin n → Fin n → Fin n → Fin n → A)
    (X Y : Fin n → A) (hR : ∀ i j k l, R j i k l = -R i j k l) :
    printed R X Y = -corrected R X Y := by
  unfold printed corrected
  rw [Finset.sum_comm]
  simp only [← Finset.sum_neg_distrib]
  refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ =>
    Finset.sum_congr rfl fun k _ => Finset.sum_congr rfl fun l _ => ?_
  rw [hR]
  ring

/-- Lemma 4, the computation: on M², R(σ) = R_{12,12} (X¹Y² − X²Y¹)². -/
theorem corrected_dim_two (R : Fin 2 → Fin 2 → Fin 2 → Fin 2 → A) (X Y : Fin 2 → A)
    (h₁ : ∀ i j k l, R j i k l = -R i j k l) (h₂ : ∀ i j k l, R i j l k = -R i j k l)
    (h₃ : ∀ i k l, R i i k l = 0) (h₄ : ∀ i j k, R i j k k = 0) :
    corrected R X Y = R 0 1 0 1 * (X 0 * Y 1 - X 1 * Y 0) ^ 2 := by
  have e₁ : R 1 0 1 0 = R 0 1 0 1 := by rw [h₁, h₂, neg_neg]
  have e₂ : R 0 1 1 0 = -R 0 1 0 1 := h₂ 0 1 0 1
  have e₃ : R 1 0 0 1 = -R 0 1 0 1 := h₁ 0 1 0 1
  simp only [corrected, Fin.sum_univ_two, h₃, h₄, e₁, e₂, e₃]
  ring

/-- The four-term line of the proof of Lemma 4 (p. 371). -/
theorem corrected_four_terms (R : Fin 2 → Fin 2 → Fin 2 → Fin 2 → A) (X Y : Fin 2 → A)
    (h₁ : ∀ i j k l, R j i k l = -R i j k l) (h₂ : ∀ i j k l, R i j l k = -R i j k l)
    (h₃ : ∀ i k l, R i i k l = 0) (h₄ : ∀ i j k, R i j k k = 0) :
    corrected R X Y = R 0 1 0 1 * (X 1 * X 1 * Y 0 * Y 0 - X 1 * X 0 * Y 1 * Y 0 +
      X 0 * X 0 * Y 1 * Y 1 - X 0 * X 1 * Y 0 * Y 1) := by
  rw [corrected_dim_two R X Y h₁ h₂ h₃ h₄]
  ring

/-- The same tensor, printed contraction: −R_{12,12} (X¹Y² − X²Y¹)². -/
theorem printed_dim_two (R : Fin 2 → Fin 2 → Fin 2 → Fin 2 → A) (X Y : Fin 2 → A)
    (h₁ : ∀ i j k l, R j i k l = -R i j k l) (h₂ : ∀ i j k l, R i j l k = -R i j k l)
    (h₃ : ∀ i k l, R i i k l = 0) (h₄ : ∀ i j k, R i j k k = 0) :
    printed R X Y = -(R 0 1 0 1 * (X 0 * Y 1 - X 1 * Y 0) ^ 2) := by
  rw [printed_eq_neg_corrected R X Y h₁, corrected_dim_two R X Y h₁ h₂ h₃ h₄]

/-- R_{12,12} = R_{21,21} = K, R_{12,21} = R_{21,12} = −K, the other components 0. -/
def R₂ (K : A) : Fin 2 → Fin 2 → Fin 2 → Fin 2 → A := fun i j k l =>
  if i = j ∨ k = l then 0 else if i = k then K else -K

theorem R₂_values (K : A) :
    R₂ K 0 1 0 1 = K ∧ R₂ K 1 0 1 0 = K ∧ R₂ K 0 1 1 0 = -K ∧ R₂ K 1 0 0 1 = -K ∧
      ∀ i j k l, (i = j ∨ k = l) → R₂ K i j k l = 0 := by
  refine ⟨by simp [R₂], by simp [R₂], by simp [R₂], by simp [R₂], ?_⟩
  intro i j k l h
  simp [R₂, h]

theorem corrected_R₂ (K : A) (X Y : Fin 2 → A) :
    corrected (R₂ K) X Y = K * (X 0 * Y 1 - X 1 * Y 0) ^ 2 := by
  simp only [corrected, Fin.sum_univ_two, R₂]
  simp
  ring

theorem printed_R₂ (K : A) (X Y : Fin 2 → A) :
    printed (R₂ K) X Y = -(K * (X 0 * Y 1 - X 1 * Y 0) ^ 2) := by
  simp only [printed, Fin.sum_univ_two, R₂]
  simp
  ring

/-- With the parallelogram of area 1, (X¹Y² − X²Y¹)² = 1: the corrected R(σ) is
R_{12,12} = K, the printed one is −K. -/
theorem area_one (R : Fin 2 → Fin 2 → Fin 2 → Fin 2 → A) (X Y : Fin 2 → A)
    (h₁ : ∀ i j k l, R j i k l = -R i j k l) (h₂ : ∀ i j k l, R i j l k = -R i j k l)
    (h₃ : ∀ i k l, R i i k l = 0) (h₄ : ∀ i j k, R i j k k = 0)
    (harea : (X 0 * Y 1 - X 1 * Y 0) ^ 2 = 1) :
    corrected R X Y = R 0 1 0 1 ∧ printed R X Y = -R 0 1 0 1 := by
  rw [printed_dim_two R X Y h₁ h₂ h₃ h₄, corrected_dim_two R X Y h₁ h₂ h₃ h₄, harea, mul_one]
  exact ⟨rfl, rfl⟩

end MishchenkoFomenko.Ch05.SectionalCurvature

#print axioms MishchenkoFomenko.Ch05.SectionalCurvature.printed_eq_neg_corrected
#print axioms MishchenkoFomenko.Ch05.SectionalCurvature.corrected_dim_two
#print axioms MishchenkoFomenko.Ch05.SectionalCurvature.corrected_four_terms
#print axioms MishchenkoFomenko.Ch05.SectionalCurvature.printed_dim_two
#print axioms MishchenkoFomenko.Ch05.SectionalCurvature.R₂_values
#print axioms MishchenkoFomenko.Ch05.SectionalCurvature.corrected_R₂
#print axioms MishchenkoFomenko.Ch05.SectionalCurvature.printed_R₂
#print axioms MishchenkoFomenko.Ch05.SectionalCurvature.area_one
