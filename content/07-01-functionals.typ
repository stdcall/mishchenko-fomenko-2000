#import "main-defs.typ": *
#import "statements.typ": *
#import "diagrams/07-01-functionals.typ": *
#chapter(short: [Вариационные задачи римановой геометрии])[Простейшие
  вариационные задачи римановой геометрии] <ch:variational-problems>
#source(407)

#section(short: [Понятие функционала. Уравнение Эйлера])[Понятие функционала.
  Экстремальные функции. Уравнение Эйлера] <sec:functionals>

Вариационные задачи являются одним из важнейших классов математических задач,
ведущих свое происхождение от общих физических и механических проблем движения и
устойчивости. Так, например, мы увидим, что геодезические траектории являются
решениями соответствующей вариационной задачи.

Начнем с общего понятия вариации функционала. Предварительно поговорим о самом
понятии функционала. Мы знакомы с понятием функции $y = f(x)$, где $y$~—
вещественное число, а аргумент $x$ может быть записан в виде набора чисел
$(x^1, dots, x^n)$ в некоторой криволинейной системе координат на гладком
многообразии. Однако, далеко не все физические соответствия могут быть записаны
на таком, относительно простом языке. Например, мы знакомы с таким
соответствием: каждому конечному отрезку гладкой кривой $gamma(t)$
сопоставляется его длина $l_a^b lr((gamma)) = integral_a^b abs(dot(gamma)) d t$.
Это соответствие: $gamma(t) -> l_a^b lr((gamma(t)))$ уже не является «функцией»
в прежнем нашем понимании, так как «аргументом» является произвольная гладкая
кривая. Это соответствие: $gamma -> l(gamma)$ является важным примером
нелинейного функционала, определенного на пространстве гладких кривых
$gamma(t)$. Обобщим этот пример; при этом в круг наших рассмотрений попадут
другие важные соответствия.

Рассмотрим в $RR^n$ ограниченную область $D$ с гладкой границей $partial D$;
пусть $x^1, dots, x^n$~— декартовы координаты. Рассмотрим на $D$ всевозможные
гладкие вектор-функции $arrow(f)(x^1, dots, x^n) = arrow(f)(x^alpha)
= (f^1 lr((x^alpha)), dots, f^k lr((x^alpha))) = {f^i lr((x^alpha))}$, где числа
$k$ и $n$ никак друг с другом не связаны. Область $D$ называют областью
изменения параметров $x^1, dots, x^n$. Пусть даны две функции:
${f^i lr((x^alpha))}$ и ${g^i lr((x^alpha))}$, $1 <= i <= k$; тогда для любых
вещественных чисел $a$ и $b$ #source(408)определена новая вектор-функция
$a arrow(f) + b arrow(g) = {a f^i lr((x^alpha)) + b g^i lr((x^alpha))}$, т.~е.
все гладкие вектор-функции на $D$ образуют линейное пространство $F$. Это
пространство бесконечномерно. Различные функционалы мы будем рассматривать
именно на этом пространстве $F$, «точки» которого (т.~е. вектор-функции) и будут
являться «аргументами» функционалов $J[arrow(f)]$, $arrow(f) in F$. Впрочем, в
тех простых примерах, с которыми мы будем иметь дело, наличие линейной структуры
в $F$ не будет существенно: мы не будем существенно пользоваться операцией
сложения вектор-функций.

В работе с функционалами полезно иметь в виду аналогию с обычными функциями.

#definition(numbered: false)[_Функционалом_ $J$, определенным на пространстве
  $F$ (или на каком-либо подмножестве пространства $F$), мы будем называть
  непрерывное отображение $F$ (или его подмножества) в вещественные числа:
  $J: F -> RR^1$; отображение $J$ линейным не предполагается. Если
  $J[a arrow(f) + b arrow(g)] = a J[arrow(f)] + b J[arrow(g)]$ (т.~е. $J$~—
  линейно), то функционал $J$ называется _линейным_.] <def:functional>

#example(numbered: false)[$D$~— отрезок на вещественной прямой: $x^1 = t$,
  $arrow(f)(t) = (f^1 lr((t)), f^2 lr((t)), f^3 lr((t)))$~— вектор-функция на
  $D$, т.~е. $arrow(f)(t) = gamma(t)$ определяет гладкую кривую в $RR^3$; при
  этом $F$ есть линейное пространство всех таких кривых в $RR^3$ (радиус-векторы
  $arrow(f)$ и $arrow(g)$ кривых $arrow(f)(t)$ и $arrow(g)(t)$ можно складывать
  и умножать на числа). В качестве $J$ возьмем интеграл
  $J[arrow(f)] = integral_0^1 abs(dot(gamma)(t)) d t
  = integral_D abs(dot(arrow(f))(t)) d t$, т.~е. длину кривой $arrow(f)(t)$,
  $0 <= t <= 1$. Этот функционал нелинеен, так как
  $J[a arrow(f) + b arrow(g)] != a J[arrow(f)] + b J[arrow(g)]$ (постройте
  пример).] <exm:arc-length-functional>

Пусть задана гладкая функция $L(x^beta; p^i; q_alpha^i)$, зависящая от трех
групп переменных: $x^beta$, $1 <= beta <= n$; $p^i$, $1 <= i <= k$; $q_alpha^i$,
$1 <= alpha <= n$, $1 <= i <= k$. Назовем эту функцию _лагранжианом_. Таким
образом, лагранжианом может служить любая гладкая функция от трех групп
переменных. Пусть $arrow(f) = {f^i lr((x^beta))}$~— гладкая вектор-функция,
определенная на $D subset RR^n$. Построим функционал $J[arrow(f)]$ так:
$
  J[arrow(f)] = integral_D
  L(x^beta; f^i lr((x^beta)); f_(x^alpha)^i lr((x^beta))) d sigma^n,
$
где $integral_D$ обозначает кратный интеграл
$limits(integral dots.c integral)_D$ ($n$ раз) по $n$-мерной области $D$;
$d sigma^n = d x^1 and dots and d x^n$~— $n$-мерный элемент объема в $D$ (т.~е.
декартова внешняя форма евклидова объема)
$f_(x^alpha)^i lr((x^beta)) = (partial f^i lr((x^beta)))/(partial x^alpha)$~—
частные производные. Сокращенно запишем $J[arrow(f)]$ так:
$J[arrow(f)] = integral_D L(x^beta, f^i, f_(x^alpha)^i) d sigma^n$, опуская
аргументы #source(409)у функций $f^i$ и $f_(x^alpha)^i$. Функция $L$
(лагранжиан) фиксирована тем самым для каждого функционала $J$. Определенный
нами класс функционалов включает практически все содержательные примеры
функционалов в механике, физике и их приложениях. Рассмотрим функционал длины
дуги
$
  J[arrow(f)] = integral_0^1 abs(dot(gamma)(t)) d t
  = integral_0^1
  sqrt(g_(i j) lr((gamma(t))) (d y^i lr((t)))/(d t) (d y^j lr((t)))/(d t)) d t,
$
т.~е. $D = I = [0, 1]$, $0 <= t <= 1$, $n = 1$,
$arrow(f)(t) = gamma(t) = (y^1 lr((t)), dots, y^k lr((t)))$; $gamma(t)$~—
гладкая кривая в $k$-мерном пространстве с римановой метрикой
$g_(i j) lr((y^1, dots, y^k))$; лагранжиан имеет вид
$
  L(x^beta, arrow(f), arrow(f)_(x^alpha))
  = L grow((t\; y^1, dots, y^k\; (d y^1)/(d t), dots, (d y^k)/(d t))) = \
  = sqrt(g_(i j) lr((y^1, dots, y^k)) dot(y)^i dot(y)^j).
$
Если кривая $gamma(t)$ на плоскости $RR^2$ задана явно: $y = f(x)$, то
$
  L(x, f, f_x) = L(f_x) = sqrt(1 + f_x^2).
$
Этот функционал определен также на кривых, лежащих в гладком многообразии $M^k$.
Мы будем обычно рассматривать малую окрестность конкретной кривой; в этой
окрестности будем предполагать введенными локальные координаты $y^1, dots, y^k$,
и тем самым события переносятся в некоторую область в $k$-мерном евклидовом
пространстве, снабженном римановой (вообще говоря, неевклидовой) метрикой. При
этом сложение вектор-функций, задающих кривые, можно выполнять только в
некоторой окрестности фиксированной кривой.

Другой пример: функционал площади
$J[arrow(f)] = limits(integral.double)_D sqrt(E G - F^2) d x d y$. Здесь
$D(x, y)$~— область изменения параметров $(x, y)$,
$arrow(f) = (u^1 lr((x, y)); u^2 lr((x, y)); u^3 lr((x, y)))$~— двумерная
поверхность в $RR^3$ с индуцированной метрикой
$d s^2 = E d x^2 + 2 F d x d y + G d y^2$;
$
  L = L(arrow(f)_x, arrow(f)_y) = sqrt(E G - F^2)
  = sqrt(
    (arrow(f)_x, arrow(f)_x)(arrow(f)_y, arrow(f)_y)
    - (arrow(f)_x, arrow(f)_y)^2
  ).
$

Здесь пространство $F$~— это линейное пространство всех вектор-функций
$(u^1 lr((x, y)), u^2 lr((x, y)), u^3 lr((x, y)))$, определенных на $D$. Можно
было бы рассмотреть функционал площади в ином виде:
$J[arrow(f)] = limits(integral.double)_D sqrt(1 + f_x^2 + f_y^2) d x d y$, где
$D$~— область в $RR^2 lr((x, y))$; #source(
  410,
)$arrow(f)(x, y) = (x, y, z(x, y))$, т.~е. вектор-функция $arrow(f)$ задана в
явном виде графиком $z = f(x, y)$ над областью $D$ в $RR^2 subset RR^3$;
$L = L(z_x, z_y) = sqrt(1 + z_x^2 + z_y^2)$. Сложение таких вектор-функций
означает сложение графиков этих функций в $RR^3$ над $D$. Но далеко не каждая
поверхность в $RR^3$ может быть задана графиком однозначной функции.

Какие вопросы будут нас в первую очередь интересовать при изучении
$J[arrow(f)]$? Обратимся к аналогии с обычными функциями; например, рассмотрим
функции от одного или от двух переменных: $alpha(t)$ и $alpha(u, v)$. Как нам
известно, в большой степени поведение функции $alpha(t)$ или $alpha(u, v)$
определяется количеством и расположением тех точек $t_0$ (или $(u_0, v_0)$), в
которых $alpha'(t_0) = 0$ (или
$alpha_u lr((u_0, v_0)) = alpha_v lr((u_0, v_0)) = 0$), т.~е. $grad(alpha) = 0$.
Такие точки, в которых $grad(alpha) = 0$, называются _критическими_ или
_стационарными точками_ функции $alpha$. Иногда употребляется название:
_экстремальные_ точки. Например, для функции $alpha = alpha(t)$ стационарными
точками являются точки максимума, минимума и точки перегиба
(рис.~@fig:critical-points-of-function). Если $alpha = alpha(u, v)$, то среди
точек, для которых $grad(alpha) = 0$, содержатся, например, точки максимума,
минимума и седловые точки (седла) порядка два; кроме того, здесь возможны седла
более высоких порядков (рис.~@fig:critical-points-of-surface). Так, например, в
механике знание тех точек, в которых гладкая функция~— потенциал достигает
максимума (т.~е. потенциальная #source(411)энергия~— минимума), имеет
первостепенное значение для нахождения устойчивого положения равновесия системы.

#fig(fig-7-1()) <fig:critical-points-of-function>

#fig(fig-7-2()) <fig:critical-points-of-surface>

Аналогично, при изучении $J[arrow(f)]$ большое внимание уделяется нахождению тех
стационарных вектор-функций $arrow(f)_0$, в которых функционал $J$ достигает
минимума, максимума или имеет «седло». Однако мы должны сформулировать эту
геометрическую аналогию на дифференциальном языке; грубо говоря, нужно правильно
понять, что такое «производная по направлению» от функционала $J$ в некоторой
точке $arrow(f) in F$. Как было отмечено, для функций $alpha(t)$ и $alpha(u, v)$
все интересующие нас критические точки являются решениями уравнения
$grad(alpha) = 0$. Нужно получить аналог этого уравнения в функциональном
случае. Вернемся к уравнению $grad(alpha) = 0$. Как мы знаем, если в точке
$(u, v) in G$ задано некоторое направление (вектор) $arrow(a) = (a^1, a^2)$, то
производная функции $alpha(u, v)$ по направлению $arrow(a)$ имеет вид:
$
  d/(d arrow(a)) alpha(u, v) = a^1 (partial alpha)/(partial u)
  + a^2 (partial alpha)/(partial v) = chevron.l arrow(a), grad alpha chevron.r
$
(рис.~@fig:graph-directional-derivative). Отсюда следует, что
$grad alpha(u_0, v_0) = 0$ тогда и только тогда, когда
$d/(d arrow(a)) alpha(u_0, v_0) = 0$ для любого направления $arrow(a)$ в точке
$(u_0, v_0)$. Если $alpha = alpha(t)$, то это означает, что
$alpha'_t lr((t_0)) = 0$. Производная от $alpha(u, v)$ по направлению $arrow(a)$
может быть вычислена так:
$
  (d alpha)/(d arrow(a)) = lim_(epsilon -> 0) frac(1, epsilon)
  [alpha(u + epsilon a^1, v + epsilon a^2) - alpha(u, v)],
$
где $arrow(a) = (a^1, a^2)$, $epsilon$~— параметр, т.~е.
$
  (d alpha)/(d arrow(a)) = lim_(epsilon -> 0) frac(1, epsilon)
  [alpha(arrow(x) + epsilon arrow(a)) - alpha(arrow(x))],
$
где $arrow(x) = (u, v)$~— радиус-вектор точки из области $G$. Именно в такой
форме мы и обобщим понятие производной по направлению на случай функционалов
$J[arrow(f)]$.

#fig(fig-7-3()) <fig:graph-directional-derivative>

Рассмотрим «точку» $arrow(f) in F$ и рассмотрим функцию $arrow(eta) in F$,
достаточно малую и такую, что $arrow(eta)|_(partial D) equiv 0$. Такие функции
$arrow(eta)$ будем называть _возмущениями_ функции $arrow(f)$. Сместимся из
точки $arrow(f)$ в точку $arrow(f) + epsilon arrow(eta)$
(рис.~@fig:functional-graph). Функция $arrow(eta)$ (напомним, что
$arrow(eta)|_(partial D) equiv 0$) задает «направление смещения» из «точки»
$arrow(f)$, точно так же, как вектор $arrow(a)$ #source(412)задавал направление
смещения из точки $(u_0, v_0) in G$; отличие от случая обычной функции в том,
что теперь этих «направлений» бесконечно много.

Далее, в точном соответствии с операцией для обычных функций строим следующее
выражение: $frac(1, epsilon) (J[arrow(f) + epsilon arrow(eta)] - J[arrow(f)])$
и, переходя к пределу по $epsilon$, получаем число, которое обозначим через
$
  d/(d arrow(eta)) J[arrow(f)] = lim_(epsilon -> 0) frac(1, epsilon)
  (J[arrow(f) + epsilon arrow(eta)] - J[arrow(f)])
$
и которое естественно назвать _производной функционала $J$ в точке $arrow(f)$ по
направлению $arrow(eta)$_. Развивая эту аналогию с обычными функциями, дадим еще
одно естественное

#definition(numbered: false)[Функцию $arrow(f)_0 in F$ назовем _стационарной
  (экстремальной, критической)_ функцией для функционала $J[arrow(f)]$, если
  $d/(d arrow(eta)) J[arrow(f)_0] = 0$ для любого возмущения $arrow(eta)$
  такого, что $arrow(eta)|_(partial D) = 0$.] <def:stationary-function>

#figures[#fig(fig-7-4()) <fig:functional-graph> #fig(
    fig-7-5(),
  ) <fig:functional-restriction>]

Если в качестве $F$ рассмотреть пространство вектор-функций $arrow(f)$ с
постоянными координатами (т.~е. $f^i lr((x^alpha)) = ("const")^i$), то эти
определения превращаются в обычные определения производной по направлению и
стационарной точки.

Удобно представлять функционал $J$ в виде «графика» над $F$
(рис.~@fig:functional-restriction). Если $arrow(f) in F$, то совокупность
функций $arrow(f) + epsilon arrow(eta)$, где $arrow(eta)|_(partial D) = 0$,
образует, очевидно, линейное пространство $T$ (если принять $arrow(f)$ за «нуль»
пространства $T$), на которое мы и ограничиваем наш функционал $J$. С этой
наглядной точки зрения те «точки» $arrow(f)_0$, #source(413)где
$d/(d arrow(eta)) J[arrow(f)_0] = 0$ (для любого $arrow(eta)$), являются точками
минимума, максимума или «седловыми точками» графика $J[arrow(f)]$, ограниченного
на подпространство $T subset F$. Смысл операции ограничения $J$ на $T$ ясен: мы
хотим изучить поведение $J$ при таких возмущениях $arrow(eta)$, которые не
меняют $arrow(f)$ на границе $partial D$, т.~е. изучаются локальные,
дифференциальные свойства функции $arrow(f)_0$, такой, что
$d/(d arrow(eta)) J[arrow(f)_0] = 0$ (для любого $arrow(eta)$). На
рис.~@fig:curve-perturbation концы кривой фиксированы в точках $A$ и $B$:
$arrow(eta)(A) = arrow(eta)(B) = 0$. Выведем теперь явную формулу для
производной $d/(d arrow(eta)) J[arrow(f)_0]$. (Выражение
$d/(d arrow(eta)) J[arrow(f)_0]$ называется иногда _первой вариацией_
$J[arrow(f)]$.) Имеем
$
  d/(d arrow(eta)) J[arrow(f)] = lim_(epsilon -> 0) frac(1, epsilon)
  (J[arrow(f) + epsilon arrow(eta)] - J[arrow(f)]).
$

#fig(fig-7-6()) <fig:curve-perturbation>

Положим $delta J = J[arrow(f) + epsilon arrow(eta)] - J[arrow(f)]$; тогда
$
  delta J = integral_D
  [L(x^beta; f^i + epsilon eta^i; f_(x^alpha)^i + epsilon eta_(x^alpha)^i)
    - L(x^beta; f^i; f_(x^alpha)^i)] d sigma^n.
$
Разлагая подынтегральное выражение в ряд Тейлора, получаем
$
  delta J = integral_D
  grow(
    [sum_(i=1)^k (partial L)/(partial f^i) epsilon eta^i
      + sum_(i=1)^k sum_(alpha=1)^n (partial L)/(partial f_(x^alpha)^i) epsilon
      eta_(x^alpha)^i + o(epsilon)]
  ) d sigma^n = \
  = epsilon integral_D
  grow(
    {sum_(i=1)^k
      grow(
        [(partial L)/(partial f^i) eta^i + sum_(alpha=1)^n
          (partial L)/(partial f_(x^alpha)^i) eta_(x^alpha)^i]
      ) + (o(epsilon))/epsilon}
  )
  d sigma^n.
$
Выполним интегрирование по частям. Рассмотрим
$
  partial/(partial x^alpha) grow(((partial L)/(partial f_(x^alpha)^i) eta^i))
  = partial/(partial x^alpha) grow(((partial L)/(partial f_(x^alpha)^i))) eta^i
  + (partial L)/(partial f_(x^alpha)^i) eta_(x^alpha)^i;
$
отсюда
$
  delta J = epsilon integral_D sum_(alpha=1)^n partial/(partial x^alpha)
  grow(((partial L)/(partial f_(x^alpha)^i) eta^i)) d sigma^n + \
  nil + epsilon integral_D sum_(i=1)^k
  grow(
    ((partial L)/(partial f^i) - sum_(alpha=1)^n partial/(partial x^alpha)
      grow(((partial L)/(partial f_(x^alpha)^i))))
  ) eta^i d sigma^n
  + integral_D o(epsilon) d sigma^n.
$

#fig(fig-7-7()) <fig:integration-by-parts>

#source(414)Так как все функции предполагались гладкими, то в первом интеграле
интегрирование по $x^alpha$ можно отделить от интегрирования по остальным
переменным $x^i$ ($1 <= i <= n$; $i != alpha$) в силу теоремы о перемене порядка
интегрирования, что дает:
$
  integral_D partial/(partial x^alpha)
  grow(((partial L)/(partial f_(x^alpha)^i) eta^i)) d sigma^n
  = limits(integral dots.c integral)_(x^1 dots hat(x^alpha) dots x^n)
  grow(
    (integral_P^Q partial/(partial x^alpha)
      grow(((partial L)/(partial f_(x^alpha)^i) eta^i)) d x^alpha)
  ) d sigma^(n-1)
$
(рис.~@fig:integration-by-parts). Так как в $integral_P^Q$ на переменные
$x^1, dots, hat(x^alpha), dots, x^n$ (переменная $x^alpha$ пропущена) можно
смотреть как на параметры, то интегрирование полностью выполняется, т.~е.
$
  integral_D partial/(partial x^alpha)
  grow(((partial L)/(partial f_(x^alpha)^i) eta^i)) d sigma^n = \
  = limits(integral dots.c integral)_(x^1 dots hat(x^alpha) dots x^n)
  grow(
    [(partial L)/(partial f_(x^alpha)^i) (Q) eta^i lr((Q))
      - (partial L)/(partial f_(x^alpha)^i) (P) eta^i lr((P))]
  ) d sigma^(n-1)
  equiv 0,
$
так как $eta^i lr((P)) = eta^i lr((Q)) = 0$; $P, Q in partial D$. Итак,
$
  delta J = epsilon integral_D sum_(i=1)^k
  grow(
    [(partial L)/(partial f^i) - sum_(alpha=1)^n partial/(partial x^alpha)
      grow(((partial L)/(partial f_(x^alpha)^i)))]
  ) eta^i d sigma^n
  + integral_D o(epsilon) d sigma^n.
$
Отсюда
$
  d/(d arrow(eta)) J[arrow(f)] = integral_D sum_(i=1)^k
  grow(
    [(partial L)/(partial f^i) - sum_(alpha=1)^n partial/(partial x^alpha)
      grow(((partial L)/(partial f_(x^alpha)^i)))]
  ) eta^i d sigma^n,
$
так как
$limits(lim)_(epsilon -> 0) frac(1, epsilon) integral_D o(epsilon) d sigma^n
= 0$. Пусть $arrow(f)_0$~— стационарная функция для $J$. Тогда для любой функции
$arrow(eta)$ ($arrow(eta)|_(partial D) = 0$) должно быть выполнено #source(
  415,
)равенство
$
  integral_D sum_(i=1)^k eta^i
  grow(
    [(partial L)/(partial f^i) - sum_(alpha=1)^n partial/(partial x^alpha)
      grow(((partial L)/(partial f_(x^alpha)^i)))]
  ) d sigma^n equiv 0.
$
Как известно из курса анализа, это означает, что #symbolic-display(
  "А",
  $
    (partial L)/(partial f^i) - sum_(alpha=1)^n partial/(partial x^alpha)
    grow(((partial L)/(partial f_(x^alpha)^i))) = 0, wide i = 1, dots, k.
  $,
) <eq:euler-equations>

Система дифференциальных уравнений~@eq:euler-equations называется _системой
уравнений Эйлера для функционала $J[arrow(f)]$_. Тем самым доказана важная

#theorem[Функция $arrow(f)_0 in F$ является экстремальной (стационарной)
  функцией для функционала $J[arrow(f)]$ тогда и только тогда, когда она
  удовлетворяет системе уравнений
  Эйлера~@eq:euler-equations.] <th:euler-equations>

Если функционал является обычной функцией на области $G$, то условие
экстремальности точки $x_0 in G$ означает, что $(partial L)/(partial x^i) = 0$,
т.~е. $grad L = 0$, что и следовало ожидать. Здесь $J = c L$, где $c = "const"$.
