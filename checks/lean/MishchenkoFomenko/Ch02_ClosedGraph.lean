/-
Book: А. С. Мищенко, А. Т. Фоменко, «Курс дифференциальной геометрии и
топологии», 2-е изд. (Факториал Пресс, 2000), гл. 2, § 2, p. 83, problem 7
(the graph of a map into a Hausdorff space) and its editorial note.

The printed problem asked to prove that a map into a Hausdorff space is
continuous if and only if its graph Γ_f = {(x, f(x))} ⊂ X × Y is closed;
the corrected problem keeps one direction.

Notation.  `Function.graph f = {(x, y) | f x = y}`.  On ℝ, `x⁻¹` is Lean's
inverse with 0⁻¹ = 0, which is the function of the note: f(x) = 1/x for
x ≠ 0, f(0) = 0.

What is proved: the graph of f(x) = x⁻¹ (with f(0) = 0) is closed in ℝ²
and f is not continuous at 0, so the printed converse fails for Y = ℝ;
the graph of a continuous map into a Hausdorff space is closed (the
corrected problem); for compact Hausdorff Y a map with closed graph is
continuous (the converse quoted in the note, Engelking 3.1.D), both from
mathlib.
-/
import Mathlib.Topology.Algebra.Order.Field
import Mathlib.Topology.MetricSpace.Pseudo.Lemmas
import Mathlib.Topology.Maps.Proper.Basic

namespace MishchenkoFomenko.Ch02.ClosedGraph

open Filter Topology

/-- The graph of x ↦ x⁻¹ is the hyperbola x y = 1 together with the origin. -/
theorem graph_inv_eq :
    Function.graph (fun x : ℝ => x⁻¹) = {p : ℝ × ℝ | p.1 * p.2 = 1} ∪ {(0, 0)} := by
  ext ⟨x, y⟩
  change x⁻¹ = y ↔ x * y = 1 ∨ (x, y) = (0, 0)
  rw [Prod.mk.injEq]
  constructor
  · rintro rfl
    by_cases hx : x = 0
    · right
      simp [hx]
    · left
      exact mul_inv_cancel₀ hx
  · rintro (h | ⟨rfl, rfl⟩)
    · exact (eq_inv_of_mul_eq_one_right h).symm
    · simp

theorem graph_inv_closed : IsClosed (Function.graph (fun x : ℝ => x⁻¹)) := by
  rw [graph_inv_eq]
  exact (isClosed_eq (continuous_fst.mul continuous_snd) continuous_const).union
    isClosed_singleton

theorem inv_not_continuousAt_zero : ¬ContinuousAt (fun x : ℝ => x⁻¹) 0 := by
  intro h
  have hlim : Tendsto (fun x : ℝ => x⁻¹) (𝓝[>] 0) (𝓝 ((0 : ℝ)⁻¹)) :=
    h.tendsto.mono_left nhdsWithin_le_nhds
  exact not_tendsto_nhds_of_tendsto_atTop tendsto_inv_nhdsGT_zero _ hlim

/-- The printed «if and only if» fails for X = Y = ℝ: a closed graph, a
discontinuous map. -/
theorem printed_converse_false :
    ¬∀ f : ℝ → ℝ, IsClosed (Function.graph f) → Continuous f := fun h =>
  inv_not_continuousAt_zero (h _ graph_inv_closed).continuousAt

/-- The corrected problem: the graph of a continuous map into a Hausdorff
space is closed. -/
theorem graph_closed_of_continuous {X Y : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    [T2Space Y] {f : X → Y} (hf : Continuous f) : IsClosed (Function.graph f) :=
  hf.isClosed_graph

/-- The converse for a compact Hausdorff space Y (quoted in the note). -/
theorem continuous_iff_graph_closed_of_compact {X Y : Type*} [TopologicalSpace X]
    [TopologicalSpace Y] [CompactSpace Y] [T2Space Y] {f : X → Y} :
    Continuous f ↔ IsClosed (Function.graph f) :=
  continuous_iff_isClosed_graph

end MishchenkoFomenko.Ch02.ClosedGraph

#print axioms MishchenkoFomenko.Ch02.ClosedGraph.graph_inv_eq
#print axioms MishchenkoFomenko.Ch02.ClosedGraph.graph_inv_closed
#print axioms MishchenkoFomenko.Ch02.ClosedGraph.inv_not_continuousAt_zero
#print axioms MishchenkoFomenko.Ch02.ClosedGraph.printed_converse_false
#print axioms MishchenkoFomenko.Ch02.ClosedGraph.graph_closed_of_continuous
#print axioms MishchenkoFomenko.Ch02.ClosedGraph.continuous_iff_graph_closed_of_compact
