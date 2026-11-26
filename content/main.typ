#set document(
  title: "Курс дифференциальной геометрии и топологии",
  author: ("А. С. Мищенко", "А. Т. Фоменко"),
  date: none,
)
#import "book-style.typ": book-contents, book-style
#import "main-defs.typ": unnumbered-chapter
#import "frontmatter/cover.typ": cover
#import "frontmatter/title.typ": imprint-page, title-page
#cover()
#show: book-style
// The cover stands outside the count: the title page is page 1.
#counter(page).update(1)
#title-page()
#imprint-page()
#unnumbered-chapter(outlined: false)[ОГЛАВЛЕНИЕ]
#book-contents
#include "00-00-preface.typ"
#include "01-01-coordinates.typ"
#include "01-02-curve-length.typ"
#include "01-03-sphere-plane.typ"
#include "01-04-pseudosphere.typ"
#include "02-01-topological-spaces.typ"
#include "02-02-connectedness.typ"
#include "02-03-compactness.typ"
#include "02-04-partition-unity.typ"
#include "03-01-manifolds.typ"
#include "03-02-equations.typ"
#include "03-03-tangent-vectors.typ"
#include "03-04-submanifolds.typ"
#include "04-01-curves.typ"
#include "04-02-surfaces.typ"
#include "04-03-transformation-groups.typ"
#include "04-04-dynamical-systems.typ"
#include "04-05-surface-classification.typ"
#include "04-06-riemann-surfaces.typ"
#include "05-01-tensor-fields.typ"
#include "05-02-tensor-examples.typ"
#include "05-03-connections.typ"
#include "05-04-parallel-transport.typ"
#include "05-05-curvature.typ"
#include "06-01-forms.typ"
#include "06-02-integration.typ"
#include "06-03-degree.typ"
#include "07-01-functionals.typ"
#include "07-02-geodesics.typ"
#include "07-03-minimal-surfaces.typ"
#include "07-04-symplectic.typ"
#include "80-bibliography.typ"
