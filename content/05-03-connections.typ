#import "main-defs.typ": *
#import "statements.typ": *
#section[Связность и ковариантное дифференцирование] <sec:connections>

#subsection[Определение и свойства аффинной связности] <ss:affine-connection>
До сих пор мы рассматривали только алгебраические операции над тензорами;
операцию дифференцирования мы пока не затрагивали. Это~— не случайность; сейчас
мы объясним причины нашей осторожности.

Необходимость уметь дифференцировать тензорные поля возникает в большом числе
прикладных задач (см., например, определение дивергенции векторного поля).
Первым кандидатом на эту операцию является обычное дифференцирование компонент
тензоров в криволинейных координатах. Рассмотрим, для простоты, ковариантное
поле $T_(i_1, dots, i_k)$. Фиксируем криволинейную систему $x^1, dots, x^n$ и
построим набор функций
$P_(alpha; i_1, dots, i_k) = (partial T_(i_1, dots, i_k))/(partial x^alpha)$,
т.~е. рассмотрим частные производные (в обычном смысле) от компонент тензорного
поля. Выполним эту операцию в каждой системе координат; т.~е. сопоставим в
каждой системе набору компонент $T_(i'_1, dots, i'_k)$ новый набор:
$P_(alpha'; i'_1, dots, i'_k)
= partial/(partial x^(alpha')) T_(i'_1, dots, i'_k)$. Вопрос: образуют ли эти
наборы тензорное поле $P$? Другими словами, будут ли эти наборы
преобразовываться друг в друга при замене координат по тензорному закону?
Проверим это вычисление. При переходе от $(x)$ к $(x')$ возникает
преобразование:
$
  P_(alpha'; i'_1 dots i'_k) = (partial T_(i'_1 dots i'_k))/(partial x^(alpha'))
  = partial/(partial x^(alpha')) grow(
    ((partial x^(i_1))/(partial x^(i'_1))
      dots.c (partial x^(i_k))/(partial x^(i'_k)) T_(i_1 dots i_k))
  ) = \
  = partial/(partial x^alpha) (T_(i_1 dots i_k))
  (partial x^alpha)/(partial x^(alpha'))
  (partial x^(i_1))/(partial x^(i'_1)) dots.c
  (partial x^(i_k))/(partial x^(i'_k)) + T_(i_1 dots i_k)
  partial/(partial x^(alpha')) grow(
    ((partial x^(i_1))/(partial x^(i'_1))
      dots.c (partial x^(i_k))/(partial x^(i'_k)))
  ) = \
  = P_(alpha; i_1 dots i_k) (partial x^alpha)/(partial x^(alpha'))
  (partial x^(i_1))/(partial x^(i'_1)) dots.c
  (partial x^(i_k))/(partial x^(i'_k)) + T_(i_1 dots i_k)
  partial/(partial x^(alpha')) grow(
    ((partial x^(i_1))/(partial x^(i'_1))
      dots.c (partial x^(i_k))/(partial x^(i'_k)))
  ).
$
Итак,
$
  P_(alpha' i'_1 dots i'_k) = P_(alpha i_1 dots i_k)
  (partial x^alpha)/(partial x^(alpha')) (partial x^(i_1))/(partial x^(i'_1))
  dots.c (partial x^(i_k))/(partial x^(i'_k))
  + S_(alpha' i'_1 dots i'_k)(T, x, x'),
$
#source(328)где
$
  S_(alpha' i'_1 dots i'_k) = T_(i_1 dots i_k) partial/(partial x^(alpha'))
  grow(
    ((partial x^(i_1))/(partial x^(i'_1)) dots.c
      (partial x^(i_k))/(partial x^(i'_k)))
  ).
$
При замене $(x) -> (x')$ общего вида выражение $S_(alpha' i'_1 dots i'_k)$,
вообще говоря, отлично от нуля, т.~е. $P_(alpha i_1 dots i_k)$ преобразуются не
по тензорному закону. Итак, операция обычного дифференцирования
$partial/(partial x^i)$ не тензорная операция; она переводит тензорное поле не в
тензорное поле. Из полученной формулы также видно, в каких предположениях
операция $partial/(partial x^i)$ является тензорной: она будет таковой только
относительно линейных замен $(x) -> (x')$; если замена линейна, то
$S_(alpha'; i'_1 dots i'_k) equiv 0$. Для того, чтобы еще больше
«дискредитировать» операцию $partial/(partial x^i)$ с тензорной точки зрения,
рассмотрим векторное поле $T^i$, отнесенное к криволинейной системе $(x)$, и
попытаемся определить для него дивергенцию по формуле:
$div(arrow(T)) = limits(sum)_i (partial T^i)/(partial x^i)$, «списав» ее с
определения дивергенции в евклидовой системе координат. Будет ли это выражение
скаляром, т.~е. будет ли оно сохраняться при произвольной замене $(x) -> (x')$?
Проверим равенство: $div(arrow(T))_((x)) = div(arrow(T))_((x'))$, где $(x)$ и
$(x')$~— произвольные системы. Получаем:
$
  div(arrow(T))_((x')) = sum_(i') (partial T^(i'))/(partial x^(i'))
  = partial/(partial x^(i')) grow(((partial x^(i'))/(partial x^i) T^i)) = \
  = (partial T^i)/(partial x^k) (partial x^k)/(partial x^(i'))
  (partial x^(i'))/(partial x^i) + T^i (partial x^k)/(partial x^(i'))
  (partial^2 x^(i'))/(partial x^k partial x^i) = \
  = sum_i (partial T^i)/(partial x^i) + R(arrow(T), x, x')
  = div(arrow(T))_((x)) + R(arrow(T), x, x'),
$
где $R(arrow(T), x, x') = T^i (partial x^k)/(partial x^(i')) dot.op
(partial^2 x^(i'))/(partial x^k partial x^i)$. При произвольной замене, величина
$R(arrow(T), x, x')$ отлична от нуля, т.~е. предложенное нами определение
дивергенции не инвариантно. Из явной формулы для $R(T, x, x')$ видно, что
$R = 0$, например, при линейных заменах. Итак, по отношению к нелинейным
заменам, операция $partial/(partial x^i)$ не является тензорной операцией.

Наша цель: научиться инвариантно дифференцировать тензорные поля в произвольных
системах координат. Это необходимо уметь делать уже хотя бы потому, что на
гладких многообразиях локальные координаты «почти всегда» криволинейны. Итак,
нужно найти операцию (обозначим ее через $nabla$~— «набла») со следующими
свойствами (будем пока считать, что $M^n = RR^n$);

#enum(numbering: "(1).")[В декартовых координатах в $RR^n$ операция $nabla$
  должна совпадать с обычным дифференцированием
  $grow({partial/(partial x^i)})$.][#source(329)Операция $nabla$ должна быть
  тензорной операцией, т.~е. если $T$~— тензорное поле на $RR^n$ (отнесенное к
  криволинейным координатам), то и $nabla T$ должно быть тензорным полем.]

Начнем с примеров. Рассмотрим в $RR^n$ векторное поле $T^i$; пусть $(x)$~—
декартова система координат, $(x')$~— произвольная система. Рассмотрим $nabla$ и
запишем требования (1) и (2), наложенные на $nabla$. Тогда в системе $(x)$
имеем: $(nabla T)_j^i = (partial T^i)/(partial x^j)$; при переходе к $(x')$
должно быть: $(nabla T)_(j')^(i') = (partial x^(i'))/(partial x^i)
(partial x^j)/(partial x^(j')) (nabla T)_j^i$. Перед нами стоит задача: найти
явный вид $nabla$, т.~е. вычислить компоненты $(nabla T)_(j')^(i')$ в
произвольной системе координат. Имеем:
$
  (nabla T)_(j')^(i') = (partial x^(i'))/(partial x^i)
  (partial x^j)/(partial x^(j')) partial/(partial x^j)
  grow(((partial x^i)/(partial x^(k')) T^(k')))
  = (partial x^(i'))/(partial x^i) (partial x^j)/(partial x^(j'))
  (partial x^i)/(partial x^(k')) (partial T^(k'))/(partial x^(alpha'))
  (partial x^(alpha'))/(partial x^j) + \
  + (partial x^(i'))/(partial x^i) (partial x^j)/(partial x^(j')) T^(k')
  partial/(partial x^j) grow(((partial x^i)/(partial x^(k'))))
  = delta_(k')^(i') delta_(j')^(alpha') (partial T^(k'))/(partial x^(alpha'))
  + T^(k') (partial x^(i'))/(partial x^i)
  (partial^2 x^i)/(partial x^(j') partial x^(k')); \
  (nabla T)_(j')^(i') = (partial T^(i'))/(partial x^(j'))
  + T^(k') Gamma_(j' k')^(i'); quad
  Gamma_(j' k')^(i') = (partial x^(i'))/(partial x^i) dot.op
  (partial^2 x^i)/(partial x^(j') partial x^(k')).
$
Итак, возникли некоторые функции $Gamma_(j' k')^(i')$, измеряющие отклонение
$nabla$ от операции обычного (евклидового) дифференцирования. Мы нашли действие
$nabla$ на векторных полях.

Рассмотрим теперь в $RR^n$ ковекторное поле $T_i$. Для отыскания явного вида
$nabla$ на $T_i$, следует снова решить систему уравнений:
$(nabla T)_(i j) = (partial T_i)/(partial x^j)$;
$(nabla T)_(i' j') = (partial x^i)/(partial x^(i'))
(partial x^j)/(partial x^(j')) (nabla T)_(i j)$. Имеем:
$
  (nabla T)_(i' j') = (partial x^i)/(partial x^(i'))
  (partial x^j)/(partial x^(j')) partial/(partial x^j)
  grow(((partial x^(k'))/(partial x^i) T_(k'))) = \
  = (partial x^i)/(partial x^(i')) (partial x^j)/(partial x^(j'))
  (partial x^(k'))/(partial x^i) (partial T_(k'))/(partial x^(alpha'))
  (partial x^(alpha'))/(partial x^j) + (partial x^i)/(partial x^(i'))
  (partial x^j)/(partial x^(j')) T_(k') partial/(partial x^j)
  grow(((partial x^(k'))/(partial x^i))) = \
  = delta_(i')^(k') delta_(j')^(alpha') (partial T_(k'))/(partial x^(alpha'))
  + T_(k') (partial^2 x^(k'))/(partial x^j partial x^i) dot.op
  (partial x^i)/(partial x^(i')) (partial x^j)/(partial x^(j'))
  = (partial T_(i'))/(partial x^(j')) + T_(k') tilde(Gamma)_(i' j')^(k');
$
где $tilde(Gamma)_(i' j')^(k') = (partial^2 x^(k'))/(partial x^j partial x^i)
dot.op (partial x^i)/(partial x^(i')) dot.op (partial x^j)/(partial x^(j'))$.
Итак, $(nabla T)_(i' j') = (partial T_(i'))/(partial x^(j'))
+ T_(k') tilde(Gamma)_(i' j')^(k')$; где $tilde(Gamma)_(i' j')^(k')$~— функции,
измеряющие отклонение $nabla$ от обычного дифференцирования на ковекторных
полях.

#lemma[Имеет место равенство
  $tilde(Gamma)_(i' j')^(k') = -Gamma_(i' j')^(k')$.] <lem:covector-christoffel>

#proof[Очевидное тождество $(partial x^(i'))/(partial x^(i'')) dot.op
  (partial x^(i''))/(partial x^(k')) = delta_(k')^(i')$. Дифференцируя его по
  $x^(p')$, получаем:
  $
    (partial^2 x^(i''))/(partial x^(p') partial x^(k')) dot.op
    (partial x^(i'))/(partial x^(i'')) + (partial x^(i''))/(partial x^(k'))
    dot.op (partial^2 x^(i'))/(partial x^(p'') partial x^(i'')) dot.op
    (partial x^(p''))/(partial x^(p')) = 0,
  $
  т.~е. $Gamma_(p' k')^(i') + tilde(Gamma)_(p' k')^(i') = 0$. Лемма доказана.]

#source(330)Итак, действие $nabla$ на векторные и ковекторные поля (в
криволинейных координатах в $RR^n$) имеет вид:
$
  (nabla T)_(j')^(i') = (partial T^(i'))/(partial x^(j'))
  + T^(k') Gamma_(k' j')^(i'); quad
  (nabla T)_(i' j') = (partial T_(i'))/(partial x^(j'))
  - T_(k') Gamma_(i' j')^(k').
$

Теперь рассмотрим действие $nabla$ на операторных полях, т.~е. на полях типа
$(1, 1)$. Имеем:
$
  (nabla T)_(j k)^i = partial/(partial x^k) (T_j^i); \
  (nabla T)_(j' k')^(i') = (partial x^(i'))/(partial x^i)
  (partial x^j)/(partial x^(j')) (partial x^k)/(partial x^(k'))
  partial/(partial x^k) grow(
    ((partial x^i)/(partial x^(alpha'))
      (partial x^(p'))/(partial x^j) T_(p')^(alpha'))
  ) = \
  = (partial x^(i'))/(partial x^i) (partial x^j)/(partial x^(j'))
  (partial x^k)/(partial x^(k')) (partial x^i)/(partial x^(alpha'))
  (partial x^(p'))/(partial x^j) (partial T_(p')^(alpha'))/(partial x^(q'))
  (partial x^(q'))/(partial x^k) + \
  + T_(p')^(alpha') (partial x^(i'))/(partial x^i)
  (partial x^j)/(partial x^(j'))
  (partial x^k)/(partial x^(k')) dot.op
  (partial^2 x^i)/(partial x^(q') partial x^(alpha')) dot.op
  (partial x^(q'))/(partial x^k) (partial x^(p'))/(partial x^j) + \
  + T_(p')^(alpha') (partial x^(i'))/(partial x^i)
  (partial x^j)/(partial x^(j')) (partial x^k)/(partial x^(k'))
  (partial x^i)/(partial x^(alpha'))
  (partial^2 x^(p'))/(partial x^k partial x^j)
  = partial/(partial x^(k')) (T_(j')^(i')) + T_(j')^(p') Gamma_(p' k')^(i')
  - T_(p')^(i') Gamma_(j' k')^(p').
$
Итак, мы нашли действие $nabla$ на $T_j^i$.

#theorem[Пусть $M^n = RR^n$, $(x)$~— декартовы координаты, $(x')$~— произвольные
  криволинейные координаты. Тогда в $RR^n$ существует тензорная операция
  $nabla$, задаваемая на произвольном тензорном поле
  $T_(j_1 dots j_p)^(i_1 dots i_k)$ формулой:
  $
    (nabla T)_(j'_1 dots j'_p; alpha')^(i'_1 dots i'_k) = \
    = partial/(partial x^(alpha')) (T_(j'_1 dots j'_p)^(i'_1 dots i'_k))
    + sum_(s = 1)^k T_(j'_1 dots j'_p)^(i'_1 dots i'_s = q' dots i'_k)
    Gamma_(q' alpha')^(i'_s) - sum_(s = 1)^p
    T_(j'_1 dots j'_s = q' dots j'_p)^(i'_1 dots i'_k)
    Gamma_(j'_s alpha')^(q'),
  $
  где функции $Gamma_(j' q')^(i')$ преобразуются при замене $(x') -> (x'')$ так:
  $
    Gamma_(j'' k'')^(i'') = (partial x^(i''))/(partial x^(i'))
    (partial x^(j'))/(partial x^(j'')) (partial x^(k'))/(partial x^(k''))
    Gamma_(j' k')^(i') + (partial x^(i''))/(partial x^(i'))
    (partial^2 x^(i'))/(partial x^(j'') partial x^(k'')).
  $] <th:euclidean-covariant-derivative>

#proof[Явный вид $nabla$ на поле $T_(j_1 dots j_p)^(i_1 dots i_k)$
  устанавливается дословным повторением проделанных выше вычислений для случая
  векторных, ковекторных, и операторных полей, повторенных столько раз, каков
  ранг поля $T_(j_1 dots j_p)^(i_1 dots i_k)$. Выписывание формул оставляется
  читателю, как обязательное упражнение. Изучим закон преобразования
  $Gamma_(j' k')^(i')$. Имеем:
  $
    nabla_(k') T^(i') = (partial T^(i'))/(partial x^(k'))
    + T^(p') Gamma_(p' k')^(i'); \
    nabla_(k'') T^(i'') = (partial T^(i''))/(partial x^(k''))
    + T^(p'') Gamma_(p'' k'')^(i'') = (partial x^(k'))/(partial x^(k''))
    partial/(partial x^(k')) grow(
      ((partial x^(i''))/(partial x^(i'))
        T^(i'))
    ) + (partial x^(p''))/(partial x^(p')) T^(p')
    Gamma_(p'' k'')^(i'') = \
    = (partial x^(k'))/(partial x^(k'')) (partial x^(i''))/(partial x^(i'))
    dot.op (partial T^(i'))/(partial x^(k')) + T^(i')
    (partial x^(k'))/(partial x^(k''))
    (partial^2 x^(i''))/(partial x^(k') partial x^(i')) + T^(p')
    (partial x^(p''))/(partial x^(p')) Gamma_(p'' k'')^(i'') = \
    = nabla_(k'') T^(i'') = (partial x^(k'))/(partial x^(k''))
    (partial x^(i''))/(partial x^(i')) dot.op nabla_(k') T^(i')
    = (partial x^(k'))/(partial x^(k'')) (partial x^(i''))/(partial x^(i'))
    grow(((partial T^(i'))/(partial x^(k')) + T^(p') Gamma_(p' k')^(i'))).
  $
  #source(331)Сравнивая, получаем:
  $
    T^(p') (partial x^(k'))/(partial x^(k'')) (partial x^(i''))/(partial x^(i'))
    Gamma_(p' k')^(i') = T^(p') (partial x^(k'))/(partial x^(k''))
    (partial^2 x^(i''))/(partial x^(k') partial x^(p')) + T^(p')
    (partial x^(p''))/(partial x^(p')) Gamma_(p'' k'')^(i'').
  $
  Так как это тождество должно иметь место для любого поля $T^i$, то
  $
    Gamma_(p'' k'')^(i'') = Gamma_(p' k')^(i')
    (partial x^(p'))/(partial x^(p'')) (partial x^(k'))/(partial x^(k''))
    (partial x^(i''))/(partial x^(i')) - (partial x^(p'))/(partial x^(p''))
    (partial x^(k'))/(partial x^(k''))
    (partial^2 x^(i''))/(partial x^(k') partial x^(p')).
  $
  В силу леммы~@lem:covector-christoffel
  $
    (partial^2 x^(i''))/(partial x^(k') partial x^(p')) dot.op
    (partial x^(p'))/(partial x^(p'')) dot.op (partial x^(k'))/(partial x^(k''))
    = -(partial^2 x^(k'))/(partial x^(p'') partial x^(k'')) dot.op
    (partial x^(i''))/(partial x^(k'))
    = -(partial^2 x^(i'))/(partial x^(p'') partial x^(k'')) dot.op
    (partial x^(i''))/(partial x^(i')).
  $
  Теорема доказана.]

Мы доказали теорему существования «тензорного дифференцирования», правда,
сделали это только для случая, когда $M^n = RR^n$, т.~е. снабжено декартовыми
координатами. Это позволило нам в явном виде вычислить $Gamma_(j' k')^(i')$,
измеряющие отклонение $nabla$ от евклидового дифференцирования
$partial/(partial x^i)$, а именно:
$
  Gamma_(j' k')^(i') = (partial x^(i'))/(partial x^i)
  (partial^2 x^i)/(partial x^(j') partial x^(k'))
  = -(partial^2 x^(i'))/(partial x^j partial x^i) dot.op
  (partial x^i)/(partial x^(j')) (partial x^j)/(partial x^(k')).
$
Мы существенно использовали то, что в $RR^n$ существуют выделенные,
привилегированные координаты~— декартовы, в которых операция $nabla$ совпала с
обычным дифференцированием. Перейдем теперь к рассмотрению произвольных гладких
многообразий. Новую операцию $nabla$ зададим аксиоматически, положив в основу
определения вычисленные выше свойства $nabla$ на $RR^n$.

#definition(numbered: false)[Будем говорить, что на гладком многообразии $M^n$
  задана операция ковариантного дифференцирования $nabla$, если для каждого
  гладкого атласа в каждой карте задан набор гладких функций $Gamma_(j k)^i$,
  преобразующихся при замене координат по закону:
  $
    Gamma_(j' k')^(i') = (partial x^(i'))/(partial x^i)
    (partial x^j)/(partial x^(j')) (partial x^k)/(partial x^(k'))
    Gamma_(j k)^i + (partial x^(i'))/(partial x^i) dot.op
    (partial^2 x^i)/(partial x^(j') partial x^(k')).
  $] <def:covariant-derivative>

Тогда $nabla$ задается формулой:
$
  (nabla T)_(j_1 dots j_p; alpha)^(i_1 dots i_k)
  = partial/(partial x^alpha) (T_(j_1 dots j_p)^(i_1 dots i_k))
  + sum_(s = 1)^k T_(j_1 dots j_p)^(i_1 dots; i_s = q; dots i_k)
  Gamma_(q alpha)^(i_s) - sum_(s = 1)^p
  T_(j_1 dots; j_s = q; dots j_p)^(i_1 dots i_k) Gamma_(j_s alpha)^q.
$

Существование таких $M^n$, на которых можно ввести $nabla$, доказано нами выше:
можно положить $M^n = RR^n$; тогда $Gamma_(j k)^i$ задаются полученными нами
выше формулами. Важно, что набор $Gamma_(j k)^i$ не образует #source(
  332,
)тензора! Эти функции называются символами Кристоффеля. Их закон преобразования
становится тензорным, например, в том случае, когда замена $(x) -> (x')$
линейна. В определении $nabla$ система $(x)$ (не штрихованная) уже не является
декартовой системой, так как события развиваются уже на произвольном $M^n$.
Иногда говорят, что символы Кристоффеля (или $nabla$) задают на $M^n$ аффинную
связность.

#definition(numbered: false)[_Тензором кручения аффинной связности_
  $Gamma_(j k)^i$ называется тензор, задаваемый в каждой системе координат
  равенством: $Omega_(j k)^i = Gamma_(j k)^i - Gamma_(k j)^i$.] <def:torsion>

#lemma[Набор функций $Omega_(j k)^i$ действительно образует
  тензор.] <lem:torsion-tensor>

#proof[Так как при замене координат $Gamma_(j k)^i$ преобразуются по закону:
  $
    Gamma_(j' k')^(i') = (partial x^(i'))/(partial x^i)
    (partial x^j)/(partial x^(j')) (partial x^k)/(partial x^(k'))
    Gamma_(j k)^i + (partial x^(i'))/(partial x^i)
    (partial^2 x^i)/(partial x^(j') partial x^(k')),
  $
  то альтернируя $Gamma_(j' k')^(i')$ по нижним индексам, получаем, в силу
  симметрии «нетензорного добавка» по $j'$ и $k'$ формулу
  $
    Omega_(j' k')^(i') = (partial x^(i'))/(partial x^i)
    (partial x^j)/(partial x^(j')) dot.op (partial x^k)/(partial x^(k'))
    Omega_(j k)^i.
  $]

#definition(numbered: false)[Связность (или ковариантное дифференцирование)
  $nabla$ называется _симметричной_, если тензор кручения равен
  нулю.] <def:symmetric-connection>

Связность, введенная нами в $RR^n$, была симметричной; это следует из формул,
задающих $nabla$ в терминах частных производных. На произвольном $M^n$ символы
Кристоффеля уже не обязаны иметь вид вторых частных производных от координат~—
такая формула возникает только тогда, когда на $M^n$ существуют локально
евклидовы координаты. Если фиксирована система координат, то $nabla$
представляется в виде совокупности операций $nabla_k$~— ковариантных
дифференцирований по отдельным координатам (аналоги частных дифференцирований
$partial/(partial x^k)$).

#proposition[Ковариантное дифференцирование (связность) $nabla$ удовлетворяет
  соотношениям:
  #enum(numbering: "(1)")[операция $nabla = {nabla_k}$~— линейна;][для
    произвольного тензорного поля $T_((j))^((i))$ набор функций
    $nabla_k T_((j))^((i)) = (nabla T)_(k; (j))^((i))$ образует тензорное
    поле;][#source(333)если тензорное поле~— скалярное (т.~е. гладкая функция
    $f$ на $M^n$), то:
    $
      nabla f = {nabla_k f} = grow({(partial f)/(partial x^k)}) = grad f;
    $][операция $nabla$ на векторных полях $T^i$ имеет вид:
    $
      nabla_k T^i = (partial T^i)/(partial x^k) + T^alpha Gamma_(alpha k)^i.
    $
    Операция $nabla$ на ковекторных полях $T_i$ имеет вид:
    $
      nabla_k T_i = (partial T_i)/(partial x^k) - T_alpha Gamma_(i k)^alpha;
    $][операция $nabla$ удовлетворяет формуле Лейбница:
    $
      nabla_k {T_((j))^((i)) dot.op P_((beta))^((alpha))}
      = (nabla_k T_((j))^((i))) dot.op P_((beta))^((alpha))
      + T_((j))^((i)) dot.op (nabla_k P_((beta))^((alpha))),
    $
    где $T_((j))^((i))$ и $P_((beta))^((alpha))$~— произвольные тензорные
    поля.]] <prop:connection-properties>

#proof[Свойства (1)–(4) сразу следуют из определения $nabla$. Осталось доказать
  (5). Рассмотрим простейший случай: одно из полей $T_((j))^((i))$,
  $P_((beta))^((alpha))$~— скалярное. Тогда (5) вытекает из формулы Лейбница для
  скалярных функций. Пусть теперь поля $T$ и $P$~— векторные поля $T^i$, $P^j$.
  Имеем:
  $
    nabla_k (T^i dot.op P^j) = partial/(partial x^k) (T^i dot.op P^j)
    + T^alpha P^j Gamma_(alpha k)^i + T^i P^alpha Gamma_(alpha k)^j = \
    = grow((partial/(partial x^k) T^i)) P^j + T^i partial/(partial x^k) (P^j)
    + T^alpha P^j Gamma_(alpha k)^i + T^i P^alpha Gamma_(alpha k)^j = \
    = grow(((partial T^i)/(partial x^k) + T^alpha Gamma_(alpha k)^i)) P^j
    + T^i grow(((partial P^j)/(partial x^k) + P^alpha Gamma_(alpha k)^j))
    = (nabla_k T^i) P^j + T^i (nabla_k P^j).
  $
  Доказательство для произвольных полей $P$ и $T$ является повторением
  предыдущего рассуждения после замены индексов $i, j$ на мультииндексы $(i),
  (j)$ и применением формулы, определяющей $nabla$. Выписывание формул оставляем
  читателю как обязательное упражнение.]

#theorem[Пусть на $M^n$ задана операция $nabla = {nabla_k}$, удовлетворяющая
  (1)–(5) (см. Предложение~@prop:connection-properties). Тогда для произвольного
  тензорного поля $T_((j))^((i))$ имеет место тождество:
  $
    nabla_k T_((j))^((i)) = nabla_k T_(j_1 dots j_p)^(i_1 dots i_alpha) = \
    = partial/(partial x^k) (T_(j_1 dots j_p)^(i_1 dots i_alpha))
    + sum_(q = 1)^alpha T_(j_1 dots j_p)^(i_1 dots; i_q = r; dots i_alpha)
    Gamma_(r k)^(i_q) - sum_(s = 1)^p
    T_(j_1 dots; j_s = omega; dots j_p)^(i_1 dots i_alpha)
    Gamma_(j_s k)^omega,
  $
  #source(334)т.~е. $nabla$~— ковариантное дифференцирование в смысле нашего
  определения (см. выше). Алгебраические свойства (1)–(5) однозначно задают
  операцию $nabla$, т.~е. ее можно вводить аксиоматически с помощью свойств
  (1)–(5).] <th:connection-axioms>

#proof[Действие $nabla$ на скалярных функциях и на тензорах ранга 1 задано
  согласно (1)–(4). Осталось найти $nabla_k$ на тензорах произвольного типа.
  Докажем лемму: любое тензорное поле разлагается в линейную комбинацию (с
  гладкими коэффициентами) произведений полей первого ранга. В самом деле, любое
  тензорное поле есть полилинейное отображение.
  $
    T = a_(j_1 dots j_q)^(i_1 dots i_k) arrow(e)_(i_1) times.o dots times.o
    arrow(e)_(i_k) times.o e^(j_1) times.o dots times.o e^(j_q):
    (T_*)^q times (T^*)^k -> RR,
  $
  где $arrow(e)_(i_alpha)$, $e^(i_alpha)$~— поля 1-го ранга. Это определение
  инвариантно, и разложение возникает при фиксировании произвольной координатной
  системы (в другой системе разложение изменится). Здесь
  $a_(j_1 dots j_q)^(i_1 dots i_k)$~— гладкие функции. Фиксируем какую-либо
  систему $x^1, dots, x^n$ и пусть ${T_(i_s)^alpha}$ (где $i_s$~— фиксировано)~—
  набор компонент тензора $arrow(e)_(i_s)$; соответственно $T_beta^(j_s)$ (где
  $j_s$ фиксировано)~— набор компонент $e^(j_s)$. Записав $T$ в этой системе,
  получаем:
  $
    T = a_(j_1 dots j_q)^(i_1 dots i_k) T_(i_1)^(alpha_1) dots
    T_(i_k)^(alpha_k) T_(beta_1)^(j_1) dots T_(beta_q)^(j_q) times \
    times grow(((arrow(partial))/(partial x^(alpha_1)))) times.o dots times.o
    grow(((arrow(partial))/(partial x^(alpha_k)))) times.o
    grow((partial/(partial x)))^(beta_1) times.o dots times.o
    grow((partial/(partial x)))^(beta_q);
  $
  т.~е.
  $
    T = T_(beta_1 dots beta_q)^(alpha_1 dots alpha_k)
    grow(((arrow(partial))/(partial x^(alpha_1)))) times.o dots times.o
    grow(((arrow(partial))/(partial x^(alpha_k)))) times.o
    grow((partial/(partial x)))^(beta_1) times.o dots times.o
    grow((partial/(partial x)))^(beta_q),
  $
  где
  $
    T_(beta_1 dots beta_q)^(alpha_1 dots alpha_k)
    = a_(j_1 dots j_q)^(i_1 dots i_k) T_(i_1)^(alpha_1) dots
    T_(beta_1)^(j_1) dots T_(beta_q)^(j_q).
  $
  Любое полилинейное отображение полностью определяется коэффициентами
  относительно базиса. Вернемся к доказательству формулы действия $nabla$ на
  $T_((j))^((i))$. Для простоты рассмотрим случай 2-го ранга (для произвольного
  поля выкладки аналогичны). В силу линейности $nabla$ формулу (5) достаточно
  проверить на мономах $T_(i j) = alpha(x) T_i P_j$, где $alpha(x)$~— гладкая
  функция. Вычислим $nabla_k (T_(i j))$ в предположении, что $nabla_k (T_i)$ уже
  известны (см. (4)). По формуле Лейбница (5) имеем:
  $
    nabla_k (T_(i j)) = nabla_k (alpha(x) T_i P_j) = \
    = (partial alpha)/(partial x^k) T_i P_j + alpha
    grow(((partial T_i)/(partial x^k) - T_p Gamma_(i k)^p)) P_j + alpha T_i
    grow(((partial P_j)/(partial x^k) - P_q Gamma_(j k)^q)) = \
    #source(335) = partial/(partial x^k) (alpha T_i P_j)
    - alpha Gamma_(i k)^p T_p P_j - alpha Gamma_(j k)^q T_i P_q = \
    = partial/(partial x^k) (T_(i j)) - Gamma_(i k)^p T_(p j)
    - Gamma_(j k)^q T_(i q),
  $
  что и требовалось.]

#definition(numbered: false)[Пусть $nabla$~— аффинная связность на $M^n$.
  Локальные координаты $x^1, dots, x^n$ называются _евклидовыми_ для $nabla$,
  если в них
  $Gamma_(j k)^i lr((x)) = 0$.] <def:connection-euclidean-coordinates>

Такие координаты могут и не существовать, например, если $nabla$ не симметрична.
В самом деле, если $nabla$ несимметрична, то $Omega_(j k)^i$ отличен от нуля.
Если бы существовали координаты, в которых $Gamma_(j k)^i equiv 0$, то в этой же
системе обратился бы в нуль и $Omega_(j k)^i$, а тогда он был бы тождественным
нулем в любой системе в силу тензорности.

Важно, что понятие ковариантного дифференцирования (т.~е. аффинной связности) не
использует понятия римановой метрики, мы пользовались только наличием гладкой
структуры на $M^n$. Поэтому, риманова метрика и связность~— это две различные
структуры на $M^n$. В частности, евклидовы координаты для аффинной связности и
евклидовы координаты для метрики $g_(i j)$ (т.~е. такие, в которых
$g_(i j) = delta_(i j)$), это~— разные понятия. Итак, в общем случае риманова
метрика и ковариантное дифференцирование не определяют друг друга.

Пусть на $M^n$ фиксирована метрика $g_(i j)$. Тогда из множества всех аффинных
симметричных связностей можно выделить одну (и только одну!) связность,
«согласованную» с этой метрикой и полностью определяемую ею. Это~— важный класс
связностей, называемых римановыми связностями.

#subsection[Римановы связности] <ss:riemannian-connections> Пусть $g_(i j)$~—
метрика, а $nabla = {Gamma_(j k)^i}$~— аффинная связность на $M^n$.

#definition(numbered: false)[Аффинная симметричная связность
  $nabla = {Gamma_(j k)^i}$ называется _согласованной с метрикой_ $g_(i j)$ (или
  называется _римановой связностью_), если
  $nabla(g_(i j)) equiv 0$.] <def:riemannian-connection>

В силу тензорности $nabla$ тождество ${nabla_k (g_(i j)) = 0}$, оказавшись
выполненным в одной системе координат, будет выполнено и во всех других
системах. Итак, относительно римановой связности, тензор $g_(i j)$~— «постоянен»
в том смысле, что его ковариантная производная равна нулю. Отсюда следует, что
для любого тензорного поля $T_((q))^((p))$ имеем
$nabla_k (g_(i j) T_((q))^((p))) equiv g_(i j) nabla_k (T_((q))^((p)))$, см.
формулу Лейбница (5). В частности, $nabla$ коммутирует с операцией поднятия и
опускания индексов. Докажем существование и единственность римановой связности.

#theorem[#source(336)Пусть $g_(i j)$~— метрика на $M^n$. Тогда существует и
  единственная симметричная аффинная связность, согласованная с $g_(i j)$,
  причем:
  $
    Gamma_(j k)^i = 1/2 g^(i alpha) grow(
      ((partial g_(k alpha))/(partial x^j)
        + (partial g_(j alpha))/(partial x^k)
        - (partial g_(j k))/(partial x^alpha))
    ).
  $] <th:riemannian-connection>

#proof[Предположим, что существование доказано. Покажем единственность
  связности. Согласно определению: $nabla_k (g_(i j)) = 0$. Так как $nabla$
  задается $Gamma_(j k)^i$, то достаточно доказать, что из этой системы
  однозначно находятся $Gamma_(j k)^i$ как функции $g_(i j)$ и
  $(partial g_(i j))/(partial x^alpha)$. Имеем: $nabla_k g_(i j) = 0$,
  $(partial g_(i j))/(partial x^k) = g_(alpha j) Gamma_(i k)^alpha
  + g_(alpha i) Gamma_(j k)^alpha$. Циклически переставляя индексы, получаем:
  $
    mat(
      delim: #("{", none),
      augment: #(vline: 2),
      align: #left,
      +, (partial g_(i j))/(partial x^k) = Gamma_(j; i k) + Gamma_(i; j k),
      (i j k);
      +, (partial g_(k i))/(partial x^j) = Gamma_(i; k j) + Gamma_(k; i j),
      (k i j);
      -, (partial g_(j k))/(partial x^i) = Gamma_(k; j i) + Gamma_(j; k i),
      (j k i);
    )
  $
  где $Gamma_(i; k j) = g_(i alpha) Gamma_(k j)^alpha$. Складывая первые два
  тождества и вычитая из суммы третье, получаем:
  $
    (partial g_(i j))/(partial x^k) + (partial g_(k i))/(partial x^j)
    - (partial g_(j k))/(partial x^i) = 2 Gamma_(i; j k)
    = 2 g_(i alpha) Gamma_(j k)^alpha.
  $
  (Напомним: $Gamma_(j k)^i = Gamma_(k j)^i$.) Далее,
  $
    Gamma_(j k)^alpha = 1/2 g^(i alpha)
    grow(
      ((partial g_(i j))/(partial x^k) + (partial g_(k i))/(partial x^j)
        - (partial g_(j k))/(partial x^i))
    ).
  $
  Мы воспользовались правилом решения системы: $g_(alpha beta) T^alpha
  = Q_beta$. Так как $g_(alpha beta)$~— невырожденный тензор, то существует
  обратный тензор $g^(alpha beta)$, такой, что $g_(alpha beta) g^(beta gamma)
  = delta_alpha^gamma$, отсюда:
  $
    g^(beta gamma) g_(alpha beta) T^alpha = g^(beta gamma) Q_beta; quad
    delta_alpha^gamma T^alpha = g^(beta gamma) Q_beta; quad
    T^alpha = g^(beta alpha) Q_beta.
  $
  Мы получили формулы, выражающие $Gamma_(j k)^alpha$ через $g_(i j)$ и его
  производные. Тем самым если решение исходной системы существует, то оно
  единственно. Для доказательства существования достаточно определить
  $Gamma_(j k)^i$ с помощью полученных выше формул. Повторяя выкладки в обратном
  порядке, получаем: $nabla_k (g_(i j)) equiv 0$. Теорема доказана.]

#remark[Пусть на $M^n$ существует система координат $x^1, dots, x^n$, в которой
  $g_(i j) = delta_(i j)$. Существование такой системы эквивалентно
  существованию системы, в которой $(g_(i j))$ становится #source(337)постоянной
  матрицей (не зависящей от точки внутри некоторой окрестности). Тогда путем
  линейной замены можно привести эту матрицу (во всех точках окрестности
  одновременно) к виду $delta_(i j)$. Итак, систему координат можно называть
  евклидовой, если в ней матрица метрического тензора постоянна. Учитывая это
  замечание, вернемся к анализу римановой связности. Локальная система координат
  евклидова с точки зрения связности тогда и только тогда, когда в этой системе
  ${Gamma_(j k)^i equiv 0}$ (в некоторой окрестности).]

#assertion(numbered: false)[Система координат евклидова с точки зрения римановой
  связности, согласованной с $g_(i j)$, тогда и только тогда, когда эта система
  евклидова с точки зрения $g_(i j)$ (т.~е. $g_(i j)$ локально
  постоянен).] <stmt:euclidean-coordinates>

#proof[В самом деле, если $g_(i j)$ локально постоянен, то, в силу
  теоремы~@th:riemannian-connection: $Gamma_(j k)^i equiv 0$, т.~е. эта
  система~— евклидова и для римановой связности $nabla$. Обратно: если
  $Gamma_(j k)^i = 0$, то в силу теоремы~@th:riemannian-connection:
  $(partial g_(i j))/(partial x^k) = g_(alpha j) Gamma_(i k)^alpha
  + g_(alpha i) Gamma_(j k)^alpha = 0$, т.~е. $g_(i j)$ постоянен в этой системе
  координат, что и требовалось.]

Рассмотрим гладкую гиперповерхность $V^(n-1) subset RR^n$, заданную графиком:
$x^n = f(x^1, dots, x^(n-1))$; Пусть $P_0 in V^(n-1)$~— произвольная точка.
Пусть $T_(P_0)(V^(n-1))$ параллельна плоскости $RR^(n-1)(x^1, dots, x^(n-1))$,
т.~е. $(partial f(P_0))/(partial x^i) = 0$, $1 <= i <= n - 1$. Мы уже вычисляли
вид $g_(i j)$ в точке $P_0$ относительно такой специальной системы координат.
Имеем: $g_(i j) = delta_(i j) + f_(x^i) f_(x^j)$. Отсюда:
$grow((partial g_(i j))/(partial x^k) |)_(P_0) = 0$, т.~е.
$Gamma_(j k)^i lr((P_0)) = 0$, где $nabla$~— риманова связность, согласованная с
$g_(i j)$. Равенство нулю $Gamma_(j k)^i$ обеспечивается, вообще говоря, только
в точке $P_0$, в окрестности $P_0$ $Gamma_(j k)^i$ уже не обязаны быть нулевыми.

Мы уже указали на то, что попытка определить дивергенцию векторного поля с
помощью «евклидовой формулы»:
$limits(sum)_(i = 1)^n partial/(partial x^i) (T^i)$ не приводит к успеху в общем
случае, так как это выражение не скаляр. Покажем, что наличие римановой
связности позволяет корректно определить дивергенцию потока. Отметим, что само
понятие дивергенции (изменения бесконечно малого объема) предполагает наличие на
$M^n$ метрики, иначе понятие объема содержательно не определено.

Итак, пусть $arrow(T)$~— векторное поле на $M^n$, снабженном римановой
связностью. Положим: $div(arrow(T)) = nabla_i T^i$, где $arrow(T)$~— поле. В
силу свойств $nabla$ получаем, что $div(arrow(T))$~— скалярная функция на $M^n$.
Найдем явный вид $div(arrow(T))$ в терминах $g_(i j)$ и компонент поля.

#assertion[#source(338)Имеет место формула:
  $
    div(arrow(T)) = (partial T^i)/(partial x^i)
    + T^alpha partial/(partial x^alpha) (ln sqrt(g)),
  $
  где $g$~— определитель матрицы $(g_(i j))$.] <stmt:divergence>

#proof[В силу теоремы~@th:riemannian-connection имеем:
  $
    div arrow(T) = nabla_i T^i = (partial T^i)/(partial x^i)
    + T^alpha Gamma_(alpha i)^i = (partial T^i)/(partial x^i) + T^alpha dot.op
    1/2 g^(i p) grow(
      ((partial g_(p alpha))/(partial x^i)
        + (partial g_(p i))/(partial x^alpha)
        - (partial g_(alpha i))/(partial x^p))
    ),
  $
  так как
  $
    Gamma_(alpha k)^i = 1/2 g^(i p) grow(
      ((partial g_(p alpha))/(partial x^k)
        + (partial g_(p k))/(partial x^alpha)
        - (partial g_(k alpha))/(partial x^p))
    ).
  $
  Далее:
  $
    div arrow(T) = (partial T^i)/(partial x^i) + 1/2 T^alpha
    grow(
      (g^(i p) (partial g_(p alpha))/(partial x^i)
        + g^(i p) (partial g_(p i))/(partial x^alpha)
        - g^(i p) (partial g_(alpha i))/(partial x^p))
    ) = \
    = (partial T^i)/(partial x^i) + 1/2 T^alpha g^(i p)
    (partial g_(i p))/(partial x^alpha),
  $
  так как
  $
    g^(i p) (partial g_(p alpha))/(partial x^i)
    - g^(i p) (partial g_(alpha i))/(partial x^p) = 0.
  $
  Надо найти $g^(i p) (partial g_(i p))/(partial x^alpha)$. Мы утверждаем, что
  $
    g^(i p) (partial g_(i p))/(partial x^alpha)
    = 2 partial/(partial x^alpha) (ln sqrt(g)).
  $
  Напомним, что $g^(i p) = (Delta_(i p))/g$, $Delta_(i p)$~— минор (со знаком),
  дополнительный к $g_(i p)$ в матрице $(g_(i j))$. Отсюда следует, что
  достаточно проверить соотношение:
  $
    1/g sum_((i, p)) Delta_(i p) (partial g_(i p))/(partial x^alpha)
    = 1/sqrt(g) 1/sqrt(g) (partial g)/(partial x^alpha),
  $
  т.~е. доказать, что
  $
    sum_((i, p)) Delta_(i p) (partial g_(i p))/(partial x^alpha)
    = (partial g)/(partial x^alpha).
  $
  Определитель $g = det(g_(i j))$ есть сумма однородных мономов степени $n$, где
  $n = dim M^n$. Фиксируем $g_(i p)$ в $g$ и соберем все члены в сумме $g$,
  содержащие $g_(i p)$ (как множитель). Тогда:
  $g = dots + g_(i p) R_(i p) + dots$, где $R_(i p)$~— полином степени $n - 1$,
  уже не содержащий $g_(i p)$. Здесь пара индексов $(i, p)$ может быть
  произвольной, но для того, чтобы теперь найти коэффициент перед другим
  элементом $g_(alpha beta)$, следует «рассыпать» предыдущее приведение подобных
  членов и организовать из определителя $g$ новое выражение, имея в виду
  множитель $g_(alpha beta)$: $g = dots + g_(alpha beta) R_(alpha beta)
  + dots$ Пусть пара $(i, p)$ фиксирована; тогда $R_(i p) = Delta_(i p)$.
  #source(339)В самом деле, рассмотрим стандартное разложение $g$ по столбцу
  (или по строке) $g = limits(sum)_(alpha = 1)^n g_(i alpha) Delta_(i alpha)$
  (это верно при любом $i$), где $i$ фиксировано. Так как $g_(i p)$ входит
  только в слагаемое $g_(i p) Delta_(i p)$ (в сумме
  $limits(sum)_(alpha = 1)^n g_(i alpha) Delta_(i alpha)$), то
  $R_(i p) = Delta_(i p)$. Вычисляя $(partial g)/(partial x^alpha)$ видим, что
  $(partial g_(i p))/(partial x^alpha)$ войдет в ответ с множителем
  $Delta_(i p)$; в другие слагаемые этой суммы, т.~е. в $(A_(i p))$, где
  $(A_(i p)) = g - g_(i p) Delta_(i p)$, функция $g_(i p)$ не входит.
  Следовательно, $(partial g)/(partial x^alpha) = limits(sum)_((i, p))
  (partial g_(i p))/(partial x^alpha) Delta_(i p)$, что и требовалось.]

Итак:
$
  div arrow(T) = (partial T^i)/(partial x^i)
  + T^alpha partial/(partial x^alpha) (ln sqrt(g)).
$
