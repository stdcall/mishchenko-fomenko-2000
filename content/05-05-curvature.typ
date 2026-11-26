#import "main-defs.typ": *
#import "statements.typ": *
#import "diagrams/05-05-curvature.typ": *
#section[Тензор кривизны] <sec:curvature-tensor>

#subsection[Предварительные замечания] <ss:curvature-remarks> Рассмотрим $M^n$
(не обязательно риманово) с симметричной аффинной связностью $nabla$. Выше была
доказана формула: $nabla_(arrow(partial)_alpha) (partial_beta)
= Gamma_(alpha beta)^k arrow(partial)_k$, где $arrow(partial)_alpha$~— базисные
векторные поля. Задание $nabla$ определяет параллельный перенос (на бесконечно
малое расстояние) вдоль координатной линии $x^alpha$. Фиксируем точку $P$ и
рассмотрим следующие параллельные переносы: $nabla_k nabla_l$ и
$nabla_l nabla_k$, где $nabla_alpha = nabla_(arrow(partial)_alpha)$
(рис.~@fig:two-transports). Можно считать, что мы смещаемся вдоль координатных
линий $x^k$ и $x^l$ на малые расстояния $alpha$ и $beta$. Конечные точки $Q$ и
$Q'$ будут, вообще говоря, различны.

#fig(fig-5-33()) <fig:two-transports>

Этот эффект можно обнаружить и при другом способе переноса: Рассмотрим движение,
показанное на рис.~@fig:open-parallelogram. Этот малый «параллелограмм» будет,
вообще говоря, разомкнут~— мы не вернемся в точку $P$ в силу «искривленности»
$M^n$. Условно эту «искривленность» можно попытаться измерить разностью:
$nabla_k nabla_l - nabla_l nabla_k = epsilon$. Если $M^n = RR^n$ и координаты
декартовы, то $nabla_k nabla_l = nabla_l nabla_k$; если $M^n$~— произвольно, то
этот дифференциальный оператор, вообще говоря, отличен от нуля. Наглядный пример
дает $S^2$, отнесенная #source(360)к координатам $(theta, phi)$
(рис.~@fig:sphere-parallelogram). Здесь $plus.minus alpha$~— смещения вдоль
меридианов, а $plus.minus beta$~— смещения вдоль параллелей.

#figures[#fig(fig-5-34()) <fig:open-parallelogram> #fig(
    fig-5-35(),
  ) <fig:sphere-parallelogram>]

#fig(fig-5-36()) <fig:orthogonal-geodesics>

Простые примеры показывают, что характер искривленности может быть различен.
Продемонстрируем это на примере $S^2$ и плоско#source(361)сти Лобачевского
$L_2$. Рассмотрим на $S^2$ и на $L_2$ геодезическую $gamma$ и из каждой точки
некоторого ее отрезка выпустим ортогональные ей геодезические. Проследим за
поведением этого пучка ортогональных к $gamma$ траекторий. На
рис.~@fig:orthogonal-geodesics изображена качественная картина. На $S^2$ пучок
собирается (по обоим направлениям своего распространения) в две точки: северный
и южный полюсы. На $L_2$ пучок «расходится» и расстояние между крайними
геодезическими возрастает до бесконечности. На рис.~@fig:diverging-geodesics
видно, что разбегание геодезических на $L_2$ имеет место в обе стороны от
отрезка $A B$, так как длины дуг $C D$ и $R T$ равны бесконечности. Различное
поведение геодезических на $S^2$ и $L_2$ видно также на примере пучка
геодезических, выпущенных из одной точки (рис.~@fig:geodesics-from-point).
Напомним, что #source(362)$S^2$ и $L_2$ имеют различную гауссову кривизну:
$S^2$~— постоянную положительную, а $L_2$~— постоянную отрицательную. Вскоре мы
покажем, что гауссова кривизна (для $M^2$) тесно связана со свойствами оператора
$nabla_k nabla_l - nabla_l nabla_k$, измеряющего «искривленность» $M^2$.

#fig(fig-5-37()) <fig:diverging-geodesics>

#fig(fig-5-38()) <fig:geodesics-from-point>

#subsection[Координатное определение тензора кривизны] <ss:coordinate-curvature>
Пусть $M^n$ отнесено к локальным координатам $x^1, dots, x^n$ в окрестности
точки $P$; рассмотрим $nabla_k nabla_l - nabla_l nabla_k$ и применим его к полю
$arrow(T) = {T^i}$. Связность $nabla$~— симметрична; подсчет дает:
$
  nabla_l T^i = (partial T^i)/(partial x^l) + T^p Gamma_(p l)^i; \
  nabla_k nabla_l lr((T^i)) = (partial^2 T^i)/(partial x^k partial x^l)
  + (partial T^p)/(partial x^k) Gamma_(p l)^i
  + T^p partial/(partial x^k) grow((Gamma_(p l)^i)) + \
  + nabla_l lr((T^p)) Gamma_(p k)^i - nabla_p lr((T^i)) Gamma_(k l)^p = \
  = (partial^2 T^i)/(partial x^k partial x^l)
  + (partial T^p)/(partial x^k) Gamma_(p l)^i
  + T^p partial/(partial x^k) grow((Gamma_(p l)^i)) + \
  + (partial T^p)/(partial x^l) Gamma_(p k)^i
  + T^q Gamma_(q l)^p Gamma_(p k)^i
  - (partial T^i)/(partial x^p) Gamma_(k l)^p
  - T^q Gamma_(q p)^i Gamma_(k l)^p; \
  (nabla_k nabla_l - nabla_l nabla_k) T^i
  = T^p grow(
    (partial/(partial x^k) Gamma_(p l)^i
      - partial/(partial x^l) Gamma_(p k)^i)
  ) - \
  - grow((Gamma_(k l)^p - Gamma_(l k)^p)) (partial T^i)/(partial x^p)
  + T^q grow(
    [Gamma_(q l)^p Gamma_(p k)^i - Gamma_(q k)^p Gamma_(p l)^i
      - Gamma_(q p)^i Gamma_(k l)^p + Gamma_(q p)^i Gamma_(l k)^p]
  ).
$
Так как $Gamma_(j k)^i = Gamma_(k j)^i$, то:
$
  (nabla_k nabla_l - nabla_l nabla_k) T^i
  = T^q grow(
    [partial/(partial x^k) Gamma_(q l)^i
      - partial/(partial x^l) Gamma_(q k)^i
      + Gamma_(q l)^p Gamma_(p k)^i - Gamma_(q k)^p Gamma_(p l)^i]
  )
  = T^q R_(q, k l)^i;
$
где
$
  R_(q, k l)^i = (partial Gamma_(q l)^i)/(partial x^k)
  - (partial Gamma_(q k)^i)/(partial x^l)
  + Gamma_(q l)^p Gamma_(p k)^i - Gamma_(q k)^p Gamma_(p l)^i.
$

#lemma[Набор $R_(q, k l)^i$ образует тензор 4-го ранга.] <lem:curvature-tensor>

#proof[Оно очевидно, так как $nabla = {nabla_k}$~— тензорная операция.]

#definition(numbered: false)[Тензор $R_(q, k l)^i$ называется _тензором кривизны
  Римана данной связности $nabla$_.] <def:riemann-tensor>

Если $M^n = RR^n$, то этот тензор равен нулю. В самом деле, он обращается в нуль
в декартовой системе, а потому, в силу тензорности закона преобразования, равен
нулю и в любой другой системе. Существуют $M^n$, где $R_(j, k l)^i$ отличен от
нуля (см. ниже). Напомним, что координаты~— евклидовы для данной связности, если
$Gamma_(j k)^i equiv 0$ в этих координатах. Отсюда следует:

#lemma[Пусть $M^n$ снабжено симметричной аффинной связностью. Если тензор
  кривизны Римана этой связности отличен от нуля (в какой-то системе координат),
  то на $M^n$ нельзя ввести евклидовы координаты (в окрестности
  точки).] <lem:no-euclidean-coordinates>

#source(363)Если бы такие координаты нашлись, то в них аннулировались бы
$Gamma_(j k)^i$, а потому тензор кривизны также обратился бы в нуль. Итак,
тензор кривизны описывает препятствие к введению евклидовых координат (для
данной связности).

#subsection[Инвариантное определение тензора кривизны] <ss:invariant-curvature>
Выше мы построили тензор Римана в конкретной системе координат.

Дадим теперь инвариантное определение. Пусть $arrow(X)$, $arrow(Y)$,
$arrow(Z)$~— произвольные гладкие векторные поля на $M^n$ (с симметричной
аффинной связностью). Построим «_оператор кривизны_» $R$, сопоставляющий тройке
$arrow(X)$, $arrow(Y)$, $arrow(Z)$ новое векторное поле. Удобно трактовать поля
как линейные дифференциальные операторы; это обстоятельство будем указывать так:
вместо $arrow(X)$ напишем просто $X$.

#definition(numbered: false)[Положим:
  $R(X, Y)(Z) = nabla_X nabla_Y (Z) - nabla_Y nabla_X (Z) - nabla_([X, Y]) (Z)$.
  Итак, $R$ переводит $T_x times T_x times T_x$ в $T_x$, где
  $x in M^n$.] <def:curvature-operator>

#theorem[Отображение $R$ трилинейно и потому задает тензор четвертого
  ранга.] <th:curvature-trilinear>

#proof[Если рассмотреть линейные комбинации полей~— аргументов с постоянными
  коэффициентами, то трилинейность очевидна. В доказательстве нуждается тот
  факт, что за знак операции $R$ можно выносить гладкую функцию $f(x)$. Если это
  доказать, то $R$ будет полностью определено действием на базисные поля:
  $arrow(partial)_alpha = grow((arrow(partial)/(partial x^alpha)))$,
  $1 <= alpha <= n$. Рассмотрим отображение
  $(X, Y, Z) -> (X, Y, f(x) dot.op Z)$, где $f(x)$~— гладкая функция. Требуется
  доказать, что $R(X, Y) dot.op (f Z) = f dot.op R(X, Y) dot.op Z$.
  $
    nabla_X nabla_Y (f Z) - nabla_Y nabla_X (f Z) - nabla_([X, Y]) (f Z)
    = \
    = nabla_X ((nabla_Y f) Z) + nabla_X (f nabla_Y Z)
    - nabla_Y ((nabla_X f) Z) - nabla_Y (f nabla_X Z) - \
    - (nabla_([X, Y]) f) Z - f nabla_([X, Y]) Z = \
    = (nabla_X nabla_Y f) Z + (nabla_Y f) nabla_X Z + (nabla_X f) nabla_Y Z
    + f (nabla_X nabla_Y Z) - \
    - (nabla_Y nabla_X f) Z - (nabla_X f) nabla_Y Z - (nabla_Y f) nabla_X Z
    - f (nabla_Y nabla_X Z) - \
    - (nabla_([X, Y]) f) Z - f (nabla_([X, Y]) Z)
    = {X(Y f) - Y(X f) - (X Y - Y X) f} Z + \
    + f {nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_([X, Y]) Z}
    = 0 + f dot.op R(X, Y) Z,
  $
  так как $nabla_X f = X(f)$. Требуется проверить, что:
  $R(f X, Y) Z = f dot.op R(X, Y) Z$. Имеем:
  $
    R(f X, Y) Z = nabla_(f X) nabla_Y Z - nabla_Y nabla_(f X) Z
    - nabla_([f X, Y]) Z.
  $
  Ясно, что $nabla_(f X) = f nabla_X$, так как
  $
    (nabla_(f X)) T = (f X)^k nabla_k T = f {X^k nabla_k T} = f (nabla_X T).
  $
  #source(364)Далее:
  $
    [f X, Y] = f(X Y) - Y(f X) = f(X Y) - (Y f) X - f(Y X) = \
    = f[X, Y] - (Y f) X.
  $
  Отсюда:
  $
    R(f X, Y) Z = f(nabla_X nabla_Y Z) - nabla_Y (f nabla_X Z)
    - nabla_(f[X, Y]) Z + nabla_((Y f) X) Z = \
    = f(nabla_X nabla_Y Z) - (nabla_Y f) nabla_X Z - f(nabla_Y nabla_X Z)
    - f nabla_([X, Y]) Z + (Y f) nabla_X Z = \
    = f dot.op R(X, Y) Z + 0 = f dot.op R(X, Y) Z,
  $
  что и требовалось. Соотношение: $R(X, f Y) Z = f dot.op R(X, Y) Z$ проверяется
  аналогично.]

Свяжем инвариантное определение тензора кривизны с его координатным
определением. Введем базисные поля $partial_i$ (как дифференциальные операторы).
Разложим $X$, $Y$, $Z$ по этим полям: $X = X^i partial_i$; $Y = Y^j partial_j$;
$Z = Z^k partial_k$. Получаем:
$R(X, Y) Z = X^i Y^j Z^k dot.op {R(partial_i, partial_j) partial_k}$; т.~е.
$R(X, Y) Z$ полностью определяется заданием $R(partial_i, partial_j) partial_k$.
Далее,
$
  R(partial_i, partial_j) Z = nabla_(partial_i) nabla_(partial_j) Z
  - nabla_(partial_j) nabla_(partial_i) Z - nabla_([partial_i, partial_j]) Z.
$
Ясно, что $nabla_(partial_i) = nabla_i$ (по определению $nabla_(partial_i)$),
т.~е. $R(partial_i, partial_j) Z = (nabla_i nabla_j - nabla_j nabla_i) Z
- nabla_([partial_i, partial_j]) Z$. Так как $[partial_i, partial_j] = 0$, то
$R(partial_i, partial_j) Z = (nabla_i nabla_j - nabla_j nabla_i) Z$. Итак, мы
получили (в фиксированной системе координат $x^1, dots, x^n$) «координатное»
определение тензора Римана, что и доказывает совпадение определений.

#subsection[Алгебраические свойства тензора кривизны
  Римана] <ss:curvature-symmetries>

#theorem[Для любых трех гладких полей $X$, $Y$, $Z$ на $M^n$ выполняются
  тождества:
  + $R(X, Y) Z + R(Y, X) Z = 0$; $R_(j, k l)^i + R_(j, l k)^i = 0$; т.~е. косая
    симметрия по аргументам $X$, $Y$.
  + $R(X, Y) Z + R(Z, X) Y + R(Y, Z) X = 0$~— тождество Якоби; в координатах:
    $R_(j, k l)^i + R_(l, j k)^i + R_(k, l j)^i = 0$. Здесь в записи
    $R_(j, k l)^i$ имеется такое соответствие между индексами $(j, k, l)$ и
    полями $X$, $Y$, $Z$: $j tilde X$, $k tilde Y$, $l tilde Z$.
  + В том случае, когда связность $nabla$~— риманова, имеем
    $chevron.l R(X, Y) Z, W chevron.r + chevron.l R(X, Y) W, Z chevron.r = 0$
    для любых полей $X$, $Y$, $Z$, $W$; здесь
    $chevron.l thick, thick chevron.r$~— скалярное произведение, порожденное
    метрикой $g_(i j)$; в координатах: $R_(i j, k l) + R_(j i, k l) = 0$, где
    $R_(i j, k l) = g_(i alpha) R_(j, k l)^alpha$.
  + Если связность $nabla$ риманова, то
    $chevron.l R(X, Y) Z, W chevron.r = chevron.l R(Z, W) X, Y chevron.r$, т.~е.
    $R_(i j, k l) = R_(k l, i j)$.
] <th:curvature-symmetries>

На языке компонент $R_(i j, k l)$ (т.~е. после опускания индекса) имеем косую
симметрию внутри каждой пары: $(i, j)$ и $(k, l)$, #source(365)а также~—
симметрию при перестановке пар (когда обе пары меняются местами, но внутри пар
индексы не переставляются).

#proof[1)~Так как
  $R(X, Y) Z = nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_([X, Y]) Z$, то
  косая симметрия $R(X, Y) Z$ по паре $X$, $Y$ очевидна.

  2)~Сначала докажем, что для симметричной связности имеем:
  $nabla_X Y - nabla_Y X = [X, Y]$. В самом деле, в координатах имеем:
  $
    nabla_X Y - nabla_Y X = X^i nabla_i Y - Y^i nabla_i X = \
    = grow(
      {X^i grow(((partial Y^k)/(partial x^i) + Y^p Gamma_(i p)^k))
        - Y^i grow(((partial X^k)/(partial x^i) + X^p Gamma_(i p)^k))}
    )
    partial/(partial x^k) = \
    = grow(
      {X^i (partial Y^k)/(partial x^i) - Y^i (partial X^k)/(partial x^i)
        + X^i Y^p Gamma_(i p)^k - Y^i X^p Gamma_(i p)^k}
    )
    partial/(partial x^k) = \
    = grow(
      {X^i (partial Y^k)/(partial x^i)
        - Y^i (partial X^k)/(partial x^i)}
    ) partial/(partial x^k) = [X, Y],
  $
  так как $Y^i X^p Gamma_(i p)^k = Y^p X^i Gamma_(p i)^k$;
  $Gamma_(p i)^k = Gamma_(i p)^k$. Если $X$ и $Y$ коммутируют, то
  $nabla_X Y = nabla_Y X$. Теперь докажем тождество Якоби. В силу
  теоремы~@th:curvature-trilinear достаточно проверить его только на попарно
  коммутирующих полях: $X$, $Y$, $Z$ (например, на $partial_i$, $partial_j$,
  $partial_k$). Достаточно проверить, что:
  $
    nabla_X nabla_Y Z - nabla_Y nabla_X Z - nabla_([X, Y]) Z
    + nabla_Z nabla_X Y - nabla_X nabla_Z Y - \
    - nabla_([Z, X]) Y + nabla_Y nabla_Z X - nabla_Z nabla_Y X
    - nabla_([Y, Z]) X equiv 0.
  $
  Как было отмечено, $X$, $Y$, $Z$~— коммутируют, а потому требуемое тождество
  следует из соотношений типа: $nabla_X Y = nabla_Y X$. Свойство (2) доказано.

  3)~Требуется доказать, что
  $chevron.l R(X, Y) Z, W chevron.r + chevron.l R(X, Y) W, Z chevron.r = 0$.
  Достаточно проверить, что $chevron.l R(X, Y) Z, Z chevron.r = 0$ (учитывая
  поляризацию квадратичных форм). Снова считаем, что $[X, Y] = 0$. Тогда:
  $chevron.l R(X, Y) Z, Z chevron.r
  = chevron.l (nabla_X nabla_Y - nabla_Y nabla_X) Z, Z chevron.r$. Рассмотрим
  функцию: $chevron.l Z, Z chevron.r = f$ и вычислим
  $X(f) = X chevron.l Z, Z chevron.r = nabla_X chevron.l Z, Z chevron.r
  = 2 chevron.l nabla_X Z, Z chevron.r$. Далее:
  $
    Y X(f) = 2 nabla_Y chevron.l nabla_X Z, Z chevron.r
    = 2 chevron.l nabla_Y nabla_X Z, Z chevron.r
    + 2 chevron.l nabla_X Z, nabla_Y Z chevron.r;
  $
  аналогично получаем: $X Y(f) = 2 chevron.l nabla_X nabla_Y Z, Z chevron.r
  + 2 chevron.l nabla_Y Z, nabla_X Z chevron.r$. В силу симметрии
  $chevron.l thick, thick chevron.r$ имеем:
  $chevron.l nabla_Y nabla_X Z, Z chevron.r
  = chevron.l nabla_X nabla_Y Z, Z chevron.r$, что и требовалось.

  4)~Требуется доказать, что
  $chevron.l R(X, Y) Z, W chevron.r = chevron.l R(Z, W) X, Y chevron.r$.
  Рассмотрим октаэдр, показанный на рис.~@fig:octahedron. Четыре его грани
  заштрихованы, и в каждой его вершине поставлено скалярное произведение. Сумма
  произведений, расположенных в вершинах каждой заштрихованной грани, равна
  нулю. Проверим, например, #source(366)это для грани $a alpha c$. Имеем,
  используя уже доказанные симметрии,
  $
    chevron.l R(X, Y) Z; W chevron.r = -chevron.l R(X, Y) W; Z chevron.r; \
    chevron.l R(Y, W) Z; X chevron.r = -chevron.l R(Y, W) X; Z chevron.r; \
    chevron.l R(X, W) Y; Z chevron.r = -chevron.l R(W, X) Y; Z chevron.r,
  $
  т.~е.
  $
    a + alpha + c = chevron.l R(X, Y) Z; W chevron.r
    + chevron.l R(Y, W) Z; X chevron.r + chevron.l R(X, W) Y; Z chevron.r = \
    = -chevron.l R(X, Y) W; Z chevron.r - chevron.l R(Y, W) X; Z chevron.r
    - chevron.l R(W, X) Y; Z chevron.r = \
    = -chevron.l R(X, Y) W + R(Y, W) X + R(W, X) Y; Z chevron.r = 0
  $
  в силу тождества Якоби. Аналогично проверяется равенство нулю сумм:
  $alpha + b + d$; $c + d + beta$; $a + b + beta$. Напишем тождество:
  $0 + 0 = 0 = 0 + 0$ и распишем каждый из этих нулей так:
  $(a + alpha + c) + (alpha + b + d) = 0 = (a + b + beta) + (c + d + beta)$;
  откуда $2 alpha = 2 beta$, т.~е.
  $chevron.l R(X, Y) Z; W chevron.r = chevron.l R(Z, W) X; Y chevron.r$, что и
  требовалось.]

#fig(fig-5-39()) <fig:octahedron>

#definition(numbered: false)[_Тензором Риччи_ римановой связности называется
  тензор $R_(j l) = R_(j, i l)^i$, т.~е. тензор, полученный сверткой (по паре
  индексов) тензора Римана. Тензор Риччи симметричен
  (проверьте!).] <def:ricci-tensor>

#definition(numbered: false)[_Скалярной кривизной_ $R$ риманова многообразия
  называется функция $R(x) = g^(k l) R_(k l)$, т.~е. полная свертка тензора
  Риччи с тензором, обратным к метрическому.] <def:scalar-curvature>

Ясно, что $R_(k l)$~— тензор 2-го ранга, а $R(x)$~— скалярная функция. Для
многих конкретных задач полезно знать явное выражение тензора Римана через
$g_(i j)$ и производные от $g_(i j)$.

#theorem[#source(367)На римановом многообразии имеет место тождество:
  $
    R_(i q, k l) = g_(i alpha) R_(q, k l)^alpha = \
    = 1/2 grow(
      ((partial^2 g_(i l))/(partial x^q partial x^k)
        + (partial^2 g_(q k))/(partial x^i partial x^l)
        - (partial^2 g_(i k))/(partial x^q partial x^l)
        - (partial^2 g_(q l))/(partial x^i partial x^k))
    )
    + g_(m p) (Gamma_(q k)^m Gamma_(i l)^p - Gamma_(q l)^m Gamma_(i k)^p).
  $] <th:curvature-via-metric>

#proof[Из координатной записи тензора Римана имеем:
  $
    R_(q, k l)^i = (partial Gamma_(q l)^i)/(partial x^k)
    - (partial Gamma_(q k)^i)/(partial x^l)
    + Gamma_(q l)^p Gamma_(p k)^i - Gamma_(q k)^p Gamma_(p l)^i
    = grow(
      ((partial Gamma_(q l)^i)/(partial x^k)
        + Gamma_(q l)^p Gamma_(p k)^i)
    ) [k, l],
  $
  где знаком $[k, l]$ обозначена альтернация по индексам $k$ и $l$ без деления
  на 2. Далее,
  $
    theta = g_(s i) R_(q, k l)^i = R_(s q, k l)
    = g_(s i) grow(
      ((partial Gamma_(q l)^i)/(partial x^k)
        + Gamma_(q l)^p Gamma_(p k)^i)
    ) [k, l] = \
    = g_(s i) grow(
      ((partial Gamma_*^i)/(partial x^k)
        + Gamma_(p k)^i Gamma_*^p)
    ) [k, l],
  $
  где знаком $*$ обозначена пара индексов $(q l)$. Выражение в круглых скобках
  можно формально понимать как результат ковариантного дифференцирования
  $nabla_k$ набора $Gamma_*^i$, где на знак $*$ пока не обращаем внимания. Набор
  $Gamma_*^i$ не образует тензора, однако, в каждой данной системе координат
  можно рассмотреть и тензор с такими компонентами: $Gamma_*^i$ (в других
  системах этот тензор будет иметь уже какие-то другие компоненты, отличные от
  $Gamma_*^(i')$, но для дифференцирования в данной системе это обстоятельство
  несущественно). Так как $g_(s i)$ порождает опускание индекса у «тензора»
  $Gamma_*^i$, то это можно выполнить и под знаком ковариантного
  дифференцирования, так как тензор $g_(i j)$ ковариантно постоянен. Отсюда:
  $
    theta = g_(s i) nabla_k (Gamma_*^i) [k, l]
    = nabla_k (g_(s i) Gamma_*^i) [k, l] = nabla_k (Gamma_(s, *)) [k, l],
  $
  где
  $
    Gamma_(s, *) = Gamma_(s, q l)
    = 1/2 g_(s i) g^(i alpha) grow(
      ((partial g_(alpha l))/(partial x^q)
        + (partial g_(alpha q))/(partial x^l)
        - (partial g_(q l))/(partial x^alpha))
    )
    = 1/2 grow(
      ((partial g_(s l))/(partial x^q)
        + (partial g_(s q))/(partial x^l) - (partial g_(q l))/(partial x^s))
    ).
  $
  Подставляя это выражение в исходную формулу для $R_(s q, k l)$, получаем:
  $
    R_(s q, k l) = nabla_k (Gamma_(s *)) [k, l]
    = grow(
      ((partial Gamma_(s *))/(partial x^k)
        - Gamma_(alpha, *) Gamma_(k s)^alpha)
    ) [k, l] = \
    = grow(
      ((partial Gamma_(s, q l))/(partial x^k)
        - Gamma_(alpha, q l) Gamma_(k s)^alpha)
    ) [k, l] = \
    = 1/2 grow(
      ((partial^2 g_(s l))/(partial x^k partial x^q)
        + (partial^2 g_(s q))/(partial x^k partial x^l)
        - (partial^2 g_(q l))/(partial x^k partial x^s))
    ) [k, l]
    - g_(alpha p) Gamma_(q l)^p Gamma_(k s)^alpha [k, l] = \
    = 1/2 grow(
      ((partial^2 g_(s l))/(partial x^k partial x^q)
        + (partial^2 g_(q k))/(partial x^l partial x^s)
        - (partial^2 g_(s k))/(partial x^l partial x^q)
        - (partial^2 g_(q l))/(partial x^k partial x^s))
    ) + \
    + g_(alpha p) (Gamma_(q k)^p Gamma_(l s)^alpha
      - Gamma_(q l)^p Gamma_(k s)^alpha).
  $]

#corollary[#source(368)Если тензор кривизны Римана не обращается в нуль в
  какой-то системе координат, то на $M^n$ нельзя ввести локальные евклидовы
  координаты, т.~е. такие, в которых $g_(i j)$~— постоянная матрица (или, что то
  же: $Gamma_(j k)^i equiv 0$).] <cor:no-euclidean-coordinates>

#proof(head: none)[#spaced[Доказательство] следует из
  леммы~@lem:no-euclidean-coordinates.]

Связь между равенством нулю тензора кривизны и возможностью введения евклидовых
координат усматривается еще из следующих соображений. Рассмотрим закон
преобразования: $Gamma_(j' k')^(i')
= (partial x^(i'))/(partial x^i)
grow(
  ((partial x^k)/(partial x^(k')) (partial x^j)/(partial x^(j'))
    Gamma_(j k)^i + (partial^2 x^i)/(partial x^(j') partial x^(k')))
)$. Для того, чтобы существовали координаты, в которых
$Gamma_(j' k')^(i') equiv 0$, необходимо выполнение соотношений (т.~е. уравнений
на координаты $x^(i')$): $(partial^2 x^i)/(partial x^(j') partial x^(k'))
= -(partial x^j partial x^k)/(partial x^(j') partial x^(k')) Gamma_(j k)^i$.
Необходимым условием разрешимости этой системы являются тождества:
$partial/(partial x^(alpha'))
grow(((partial^2 x^i)/(partial x^(j') partial x^(k'))))
= partial/(partial x^(k'))
grow(((partial^2 x^i)/(partial x^(j') partial x^(alpha'))))$. Это накладывает
условия на правые части системы. Можно проверить, что выполнение этих требований
эквивалентно обращению в нуль тензора кривизны. (Проверьте!).

#subsection[Некоторые приложения тензора кривизны
  Римана] <ss:curvature-applications> Рассмотрим двумерное риманово
многообразие. Здесь тензор кривизны устроен особенно просто (задача: какой смысл
имеет тензор кривизны для одномерного многообразия?). Рассмотрим скалярную
кривизну $R(x)$~— функцию на $M^2$. Так как эта функция измеряет
«искривленность» $M^2$, то есть основания считать, что она связана с гауссовой
кривизной, которая, как мы знаем, также отвечает за «искривленность» $M^2$.

#theorem[На двумерном гладком римановом многообразии имеет место тождество:
  $R = 2 K$, где $R(P)$, $P in M^2$,~— скалярная кривизна, $K(P)$~— гауссова
  кривизна.] <th:scalar-gauss-curvature>

#corollary[Так как $R(P)$ полностью определяется заданием $g_(j i)$, то $K(P)$
  также полностью определяется только $g_(i j)$, в частности, не меняется при
  изометриях $M^2$ в $RR^3$ (при изгибаниях
  поверхности).] <cor:gauss-curvature-intrinsic>

Нетривиальность этого следствия видна из того, что в исходном определении $K(P)$
участвовала вторая квадратичная форма, описывающая вложение $M^2$ в $RR^3$.
Непосредственная проверка инвариантности $K(P)$ при изгибаниях также
затруднительна и наиболее естественно производится только после изучения тензора
Римана.

#proof(of: [теоремы])[В силу теоремы~@th:curvature-via-metric:
  $
    R_(i q, k l) = 1/2 grow(
      ((partial^2 g_(i l))/(partial x^q partial x^k)
        + (partial^2 g_(q k))/(partial x^i partial x^l)
        - (partial^2 g_(i k))/(partial x^q partial x^l)
        - (partial^2 g_(q l))/(partial x^i partial x^k))
    ) + \
    + g_(m p) (Gamma_(q k)^m Gamma_(i l)^p - Gamma_(q l)^m Gamma_(i k)^p).
  $
  #source(369)Введем в $RR^3$ специальную декартову систему координат; выберем
  на $M^2$ точку $P$ и зададим $M^2$ в окрестности $P$ в виде графика
  $z = f(x, y)$, где $(x, y)$~— декартовы координаты в $T_P M^2$. Так как
  $T_P M^2 = RR^2 (x, y)$~— касательная плоскость, то $grad f(P) = 0$, т.~е.
  $g_(i j) lr((P)) = (delta_(i j) + f_(x^i) f_(x^j))(P) = delta_(i j)$ или
  $Gamma_(j k)^i lr((P)) = 0$, так как
  $grow(grow(((partial g_(i j))/(partial x^k))) |)_P = 0$ (проверьте!). В силу
  алгебраических симметрий $R_(i q, k l)$ у него сейчас имеется только одна
  существенная компонента: $R_(12, 12)$. Остальные~— либо равны нулю, либо
  отличаются от $R_(12, 12)$ только знаком, или совпадают с $R_(12, 12)$.
  Запишем тензор Римана в системе координат $(x, y)$. Имеем:
  $
    R_(12, 12) = 1/2 grow(
      (2 dot.op (partial^2 g_(12))/(partial x partial y)
        - (partial^2 g_(22))/(partial x^2) - (partial^2 g_(11))/(partial y^2))
    ) = \
    = 1/2 [2 (f_x f_y)_(x y) - (f_y^2)_(x x) - (f_x^2)_(y y)] = \
    = (f_(x x) f_y + f_x f_(x y))_y - (f_y f_(x y))_x - (f_x f_(x y))_y = \
    = f_(x x y) f_y + f_(x x) f_(y y) + f_(x y) f_(x y) + f_x f_(x y y) - \
    - f_(x y) f_(x y) - f_y f_(x x y) - f_(x y) f_(x y) - f_x f_(x y y) = \
    = mat(delim: "|", f_(x x), f_(x y); f_(x y), f_(y y)) = K.
  $
  Отсюда: $R_(12, 12) = K$. Вычислим $R$.
  $
    R = g^(k l) R_(k l) = g^(k l) R_(k, alpha l)^alpha
    = g^(k l) g^(alpha q) R_(q k, alpha l)
    = R_(12, 12) (Sigma_plus.minus g^(k l) dot.op g^(alpha q)),
  $
  где
  $
    Sigma_plus.minus g^(k l) g^(alpha q)
    = g^22 g^11 - g^21 g^21 + g^11 g^22 - g^12 g^12 = \
    = 2 (g^22 g^11 - (g^12)^2) = 2 det(g_(i j))^(-1) = 2/g,
    wide "где" wide g = det(g_(i j)).
  $
  Итак: $R = 2/g R_(12, 12)$. Отсюда: $R = 2 K$, так как
  $g_(i j) lr((P)) = delta_(i j)$. Но так как $R$ и $K$~— скаляры, то их
  значения не зависят от выбора координат и потому в любой системе получаем:
  $R = 2 K$.]

Таким образом, по характеру своего поведения относительно изгибаний, $K(P)$
отличается от средней кривизны, поэтому гауссова кривизна~— «внутренний
инвариант» поверхности. Рассмотрим

#caps-word("Примеры").
#enum(numbering: "(1)")[для евклидовой метрики $d x^2 + d y^2$:
  $R = 2 K = 0$;][для сферической метрики $d r^2 + grow((sin^2 r/r_0)) d phi^2$:
  $R = 2 K = 2/r_0^2$, т.~е. скалярная кривизна постоянна и положительна;][для
  метрики плоскости Лобачевского $d r^2 + grow((sh^2 r/r_0)) d phi^2$ имеем:
  $R = 2 K = (-2)/r_0^2$, т.~е. кривизна постоянна и отрицательна;][#source(
    370,
  )для конформно-евклидовой метрики $lambda(x, y)(d x^2 + d y^2)$, где
  $lambda(x, y)$~— положительная функция, имеем:
  $R = 2 K = -1/lambda Delta ln lambda$, где $Delta$~— оператор Лапласа.
  Доказательство: прямое вычисление.]

Структура тензора Римана в трехмерном случае уже более сложна. Больше число
существенных компонент: $R_(12, 13)$; $R_(21, 23)$; $R_(31, 32)$; $R_(12, 12)$;
$R_(13, 13)$; $R_(23, 23)$; остальные $R_(i j, k l)$ либо равны нулю, либо
совпадают с указанными, либо отличаются знаком.

«Сложность» $R_(i j, k l)$ определяется числом существенных компонент. Для $M^2$
такая компонента~— одна, для $M^3$~— шесть. Можно подсчитать, что для $M^n$:
$N = (n^2 (n^2 - 1))/12$, где $N$~— число существенных компонент; когда
$n -> infinity$, отношение $N$ к общему числу компонент (т.~е. к $n^4$)
стремится к $1 \/ 12$. (#caps-word("Задача"): вычислите $N$).

В геометрии большое значение имеет «_кривизна по двумерному направлению_».
Рассмотрим риманово $M^n$; пусть $arrow(X), arrow(Y) in T_P M^n$. Пусть они
выбраны так, что площадь параллелограмма $Pi(arrow(X), arrow(Y))$, построенного
на этих векторах, равна 1 в метрике $g_(i j)$. Тогда _кривизной $M^n$ в
двумерном направлении $sigma$_, определяемом $arrow(X)$, $arrow(Y)$, называется
число $R(sigma) = chevron.l R(X, Y) Y; X chevron.r$#ed-note[В книге было
  $R(sigma) = chevron.l R(X, Y) X; Y chevron.r$. При знаке тензора кривизны,
  принятом в этом параграфе, это число равно $-K$, и сфера получила бы
  отрицательную кривизну по всем направлениям; формула книги отвечает
  противоположному выбору знака $R$ (Ту~@bib:Tu2017[§~12.4, формула~(12.11)]).],
где $X$, $Y$~— произвольные векторные поля в окрестности $P$, такие, что
$X(P) = arrow(X)$, $Y(P) = arrow(Y)$, т.~е. совпадающие в $P$ с выбранными
векторами $arrow(X)$, $arrow(Y)$. Следует доказать, что $R(sigma)$ не зависит от
способа включения векторов $arrow(X)$, $arrow(Y)$ в векторные поля $X$, $Y$.

#lemma[Имеет место формула $R(sigma) = R_(beta j, k l) X^beta Y^j X^k Y^l$, где
  $X^alpha$ и $Y^beta$~— координаты векторов $arrow(X)$ и $arrow(Y)$. Здесь
  $R_(i j, k l)$~— тензор и $R(sigma)$ не зависит от способа включения
  $arrow(X)$, $arrow(Y)$ в $X$, $Y$.] <lem:sectional-curvature-formula>

#proof[Имеем:
  $
    [R(X, Y) Z]^k = R_(j, p q)^k X^p Y^q Z^j; \
    R(sigma) = g_(alpha beta) X^beta [R(X, Y) Y]^alpha
    = g_(alpha beta) X^beta R_(j, k l)^alpha Y^j X^k Y^l
    = R_(beta j, k l) X^beta Y^j X^k Y^l,
  $
  что и требовалось, так как $X^i = X^i lr((P))$, $Y^i = Y^i lr((P))$.]

#definition(numbered: false)[Риманово многообразие $M^n$ называется
  _многообразием положительной (постоянной, отрицательной, нулевой и т.~д.)_
  кривизны, если его кривизны по всем двумерным направлениям положительны
  (постоянны, отрицательны, нулевые и т.~д.).] <def:sectional-curvature-sign>

Для оправдания определения следует сопоставить его с двумерным случаем, в
котором понятия положительной и т.~д. кривизн уже определены нами при помощи
гауссовой кривизны.

#lemma[#source(371)Рассмотрим риманово $M^2$, и пусть $K(P)$~— гауссова
  кривизна, $R(sigma)$~— кривизна по двумерному направлению,
  $(arrow(X), arrow(Y)) = sigma$ в точке $P in M^2$. Тогда
  $R(sigma) = K(P) = 1/2 R(P)$.] <lem:sectional-gauss-curvature>

#proof[Рассмотрим координаты $(x, y)$, координатные линии которых ортогональны в
  точке $P$; скалярное произведение, индуцированное метрикой на $T_P M^2$, можно
  считать евклидовым. Тогда:
  $
    R(sigma) = R_(beta j, k l) X^beta Y^j X^k Y^l = \
    = R_(12, 12) (X^2 X^2 Y^1 Y^1 - X^2 X^1 Y^2 Y^1 + X^1 X^1 Y^2 Y^2
      - X^1 X^2 Y^1 Y^2) = \
    = R_(12, 12) (X^2 Y^1 - Y^2 X^1)^2 = R_(12, 12) dot.op 1 = R_(12, 12),
  $
  так как $X^2 Y^1 - Y^2 X^1 = [$площадь параллелограмма
  $Pi(arrow(X), arrow(Y))$, натянутого на $arrow(X)$, $arrow(Y)$ в декартовых
  координатах $(x, y)$ в $T_P (M^2)]$. Так как $R_(12, 12) = K(P)$, то
  $R(sigma) = K(P)$, что и требовалось.]

Итак, предложенное нами определение кривизны по двумерному направлению
естественно обобщает понятие гауссовой (скалярной) двумерной кривизны римановой
метрики. Ясно, что кривизны по любому двумерному направлению в $RR^n$ равны
нулю, т.~е. $RR^n$~— многообразие нулевой кривизны.

Для кривизны по двумерному направлению $sigma = (arrow(X), arrow(Y))$ существует
наглядное истолкование, которое мы приведем без доказательства. Рассмотрим в
точке $P in M^n$ двумерную плоскость $H$, натянутую на $arrow(X)$, $arrow(Y)$, и
выпустим из $P$ в направлении каждого вектора $arrow(Z) in H$ геодезическую
$gamma_(arrow(Z)) lr((t))$. Ясно, что эти геодезические (локально) образуют
двумерную поверхность $M^2 subset M^n$, касательная плоскость к которой
совпадает с $H$ (рис.~@fig:geodesic-surface). Эта поверхность называется
_геодезической поверхностью._ На ней возникает индуцированная метрика, у которой
можно вычислить гауссову кривизну. Оказывается, что $R(sigma)$ совпадает с этой
гауссовой кривизной.

#fig(fig-5-40()) <fig:geodesic-surface>
