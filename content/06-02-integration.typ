#import "main-defs.typ": *
#import "statements.typ": *
#import "diagrams/06-02-integration.typ": *
#section[Интегрирование внешних форм] <sec:integration-of-forms>

Интегрирование внешних дифференциальных форм~— это аналог операции, обратной к
дифференцированию функций. Рассмотрим #source(389)следующий пример. Пусть в
ограниченной области $V$ евклидового пространства $RR^n$ задана внешняя
дифференциальная форма $omega$ степени $n$. Тогда в локальной системе координат
$(x^1, dots, x^n)$ форма $omega$ имеет вид:
$
  omega = f(x^1, dots, x^n) d x^1 and d x^2 and dots and d x^n.
$ <eq:top-form>
Если $(y^1, dots, y^n)$~— другая система координат, то в этой новой системе
форма $omega$ примет согласно тензорному закону преобразования компонент тензора
следующий вид:
$
  omega = f(x^1 lr((y^1, dots, y^n)), dots, x^n lr((y^1, dots, y^n))) det
  grow(((partial x^i)/(partial y^j))) d y^1 and dots and d y^n.
$ <eq:top-form-change>
Теперь вспомним, что в интегральном исчислении функций многих переменных
встречалась похожая формула для преобразования подынтегральной функции при
замене координат. Именно, интеграл функции $f$ по объему $V$ в различных
системах координат связан следующим соотношением:
$
  integral_V f(x^1, dots, x^n) d x^1 dots d x^n = \
  = integral_V f(x^1 lr((y^1, dots, y^n)), dots)
  grow(|det grow(((partial x^i)/(partial y^j)))|) d y^1 dots d y^n.
$ <eq:change-of-variables>
Формула~@eq:change-of-variables показывает, что по сути дела интегрируется по
объему $V$ не функция, а некоторый геометрический объект, компонента которого
меняется при переходе от координат $(x^1, dots, x^n)$ к координатам
$(y^1, dots, y^n)$ путем умножения на модуль якобиана замены координат. Это
наблюдение можно применить к определению интеграла от внешней дифференциальной
формы.

#subsection[Интеграл дифференциальной формы по
  многообразию] <ss:integral-over-manifold> Вернемся теперь к
формуле~@eq:change-of-variables, и обобщим ее на случай произвольного гладкого
многообразия с краем. Рассмотрим произвольное гладкое многообразие с краем $M$.
Скажем, что множество $X subset M$ имеет _меру нуль_, $mu(X) = 0$, если для
любой карты $U_alpha$ и координатного гомеоморфизма
$phi: U_alpha -> V_alpha subset RR_+^n$ множество
$phi(X inter U_alpha) subset RR_+^n$ имеет меру нуль в евклидовом пространстве
$RR^n$. Определение множества меры нуль корректно и не зависит от выбора атласа
карт. Для этого достаточно показать, что если $f: V_1 -> V_2$ гладкий
гомеоморфизм области $V_1 subset RR^n$ на область $V_2 subset RR^n$, то образ
$f(X)$ любого множества $X subset V_1$ меры нуль является множеством меры нуль.
В самом деле, если $X subset V_1$~— множество меры нуль, #source(
  390,
)$mu(X) = 0$, то множество $X$ представимо в виде объединения не более чем
счетного числа компактных подмножеств:
$X = limits(union.big)_(i=1)^infinity X_i$, $mu(X_i) = 0$. Тогда
$mu(f(X)) <= sum_(i=1)^infinity mu(f(X_i))$. Следовательно, достаточно доказать,
что $mu(f(X_i)) = 0$. Отображение $f$ в локальной системе координат
$(x^1, dots, x^n)$ представляется набором гладких функций
$y^i = f^i lr((x^1, dots, x^n))$. Поэтому
$
  mu(f(X_i)) <= integral_(X_i) grow(|det grow(((partial f^k)/(partial x^j)))|)
  d x^1 dots d x^n <= C integral_(X_i) d x^1 dots d x^n = C mu(X_i),
$
где $C$~— такая константа, для которой выполнена оценка
$
  grow(|det grow(((partial f^k)/(partial x^j)))|) <= C
$
на компакте $X_i$. Множества меры нуль на многообразии удовлетворяют стандартным
свойствам, справедливым для множеств евклидового пространства:
#enum(
  numbering: letter-item,
)[$mu grow((limits(union.big)_(i=1)^infinity X_i)) <= sum_(i=1)^infinity mu(X_i)
  = 0$,][образ $f(Y)$ гладкого $(n - 1)$-мерного многообразия $Y$ при гладком
  отображении $f: Y -> M$ имеет меру нуль.]

Определим теперь интеграл от внешней дифференциальной формы $omega$ степени $n$
на $n$-мерном ориентированном многообразии $M$ в случае, когда форма $omega$
имеет компактный носитель. Пусть $U subset M$~— произвольная открытая область.
Если область $U$ целиком лежит в некоторой карте $U_alpha$ с координатами
$(x_alpha^1, dots, x_alpha^n)$, то форма $omega$ в карте $U_alpha$ имеет вид
$omega = f_alpha lr((x_alpha^1, dots, x_alpha^n)) d x_alpha^1 and dots
and d x_alpha^n$. Тогда положим
$
  integral_U omega = limits(integral dots.c integral)_U f_alpha
  lr((x_alpha^1, dots, x_alpha^n)) d x_alpha^1 dots d x_alpha^n.
$ <eq:integral-in-chart>
Правая часть формулы~@eq:integral-in-chart не зависит от выбора локальной
системы координат $(x_alpha^1, dots, x_alpha^n)$. В самом деле, если
$U subset U_alpha inter U_beta$, то по формуле~@eq:top-form-change:
$
  omega = f_alpha
  lr(
    (x_alpha^1 lr((x_beta^1, dots, x_beta^n)), dots,
      x_alpha^n lr((x_beta^1, dots, x_beta^n)))
  ) times \
  nil times det grow(((partial x_alpha^i)/(partial x_beta^j))) d x_beta^1
  and dots and d x_beta^n = f_beta lr((x_beta^1, dots, x_beta^n)) d x_beta^1
  and dots and d x_beta^n.
$
#source(391)Тогда, в силу~@eq:change-of-variables, и учитывая, что для
ориентируемого многообразия
$det grow(((partial x_alpha^i)/(partial x_beta^j))) > 0$, получаем:
$
  limits(integral dots.c integral)_U f_alpha lr((x_alpha^1, dots, x_alpha^n))
  d x_alpha^1 dots d x_alpha^n = limits(integral dots.c integral)_U f_beta
  lr((x_beta^1, dots, x_beta^n)) d x_beta^1 dots d x_beta^n.
$

#definition[Пусть $M$~— $n$-мерное гладкое ориентированное многообразие с краем,
  $omega$~— внешняя дифференциальная форма степени $n$ с компактным носителем.
  Пусть ${U_(alpha_1), dots, U_(alpha_N)}$~— конечный набор карт, покрывающий
  носитель формы $omega$. Положим
  $
    integral_M omega = sum_(i=1)^N
    integral_(U_(alpha_i) without limits(union.big)_(j=1)^(i-1) U_(alpha_j))
    omega.
  $ <eq:integral-by-charts>] <def:integral-of-form>

Определение~@def:integral-of-form не зависит от выбора карт
$U_(alpha_1), dots, U_(alpha_N)$. Для того чтобы показать независимость
определения~@def:integral-of-form от выбора карт, дадим другое определение
интеграла формы $omega$.

#definition(prime: [@def:integral-of-form])[Пусть $M$~— $n$-мерное гладкое
  ориентированное многообразие с краем, $omega$~— внешняя дифференциальная форма
  степени $n$ с компактным носителем, ${phi_alpha}$~— разбиение единицы,
  подчиненное атласу карт ${U_alpha}$. Тогда
  $
    integral_M omega = sum_alpha integral_(U_alpha) phi_alpha omega.
  $ <eq:integral-by-partition>] <def:integral-of-form-prime>

Определение~@def:integral-of-form-prime более удобно с точки зрения
математической строгости, поскольку использует интегрирование только по открытым
областям в евклидовом пространстве, в то время как в
формуле~@eq:integral-by-charts приходится интегрировать по множествам более
сложного вида. С другой стороны, в определении~@def:integral-of-form-prime
необходимо доказать, что правая часть формулы~@eq:integral-by-partition не
зависит от выбора разбиения единицы.

Без ограничения общности можно считать, что атлас карт $U_alpha$ конечен,
$1 <= alpha <= N$. Пусть ${phi'_alpha}$~— другое разбиение единицы. Тогда,
полагая $psi_alpha = phi_alpha - phi'_alpha$, получаем:
$sum_(alpha=1)^N psi_alpha equiv 0$. Требуется же доказать, что
$
  sum_(alpha=1)^N integral_(U_alpha) psi_alpha omega = 0.
$ <eq:partition-difference>
Имеем $psi_N = -sum_(alpha=1)^(N-1) psi_alpha$; поскольку
$supp psi_N subset U_N$, то найдется другая функция $chi$, равная тождественно
единице на $supp psi_N$, и #source(392)$supp chi subset U_N$. Тогда
$chi(P) psi_N lr((P)) equiv psi_N lr((P))$. Поэтому
$psi_N = -sum_(alpha=1)^(N-1) chi psi_alpha$;
$supp chi psi_alpha subset U_N inter U_alpha$. Тогда
$
  sum_(alpha=1)^N integral_(U_alpha) psi_alpha omega
  = integral_(U_N) psi_N omega + sum_(alpha=1)^(N-1) integral_(U_alpha)
  psi_alpha omega = -sum_(alpha=1)^(N-1) integral_(U_N) chi psi_alpha omega
  + sum_(alpha=1)^(N-1) integral_(U_alpha) psi_alpha omega.
$
Поскольку $supp chi psi_alpha omega subset U_N inter U_alpha$, то
$integral_(U_N) chi psi_alpha omega = integral_(U_alpha) chi psi_alpha omega$.
Следовательно,
$
  sum_(alpha=1)^N integral_(U_alpha) psi_alpha omega
  = sum_(alpha=1)^(N-1) integral_(U_alpha) (psi_alpha - chi psi_alpha) omega.
$ <eq:partition-induction>
В правой части~@eq:partition-induction стоит такое же выражение, как и
в~@eq:partition-difference, состоящее из $(N - 1)$ слагаемого, у которых вместо
функций $psi_alpha$ стоят функции $(psi_alpha - chi psi_alpha)$, причем
$
  sum_(alpha=1)^(N-1) (psi_alpha - chi psi_alpha)
  = sum_(alpha=1)^(N-1) psi_alpha - chi sum_(alpha=1)^(N-1) psi_alpha = \
  = sum_(alpha=1)^(N-1) psi_alpha + chi psi_N
  = sum_(alpha=1)^(N-1) psi_alpha + psi_N = sum_(alpha=1)^N psi_alpha = 0.
$
Поэтому формула~@eq:partition-difference доказана по индукции по числу слагаемых
$N$. Пусть теперь дано два атласа карт ${U_alpha}$ и ${U_beta}$ и подчиненные им
разбиения единицы ${phi_alpha}$ и ${phi'_beta}$. Тогда каждое разбиение единицы
${phi_alpha}$ и ${phi'_beta}$ можно дополнить нулевыми функциями до разбиения
единицы нового атласа карт, равного объединению ${U_alpha} union {U_beta}$.
Нулевые функции не изменят правой части~@eq:integral-by-partition, а по
формуле~@eq:partition-difference следует, что правые
части~@eq:integral-by-partition совпадают для разбиения единицы ${phi_alpha}$ и
${phi'_beta}$.

#proposition[#enum(numbering: letter-item)[Определения интеграла по
  формулам~@eq:integral-by-charts и~@eq:integral-by-partition
  совпадают.][$integral_M (lambda_1 omega_1 + lambda_2 omega_2)
  = lambda_1 integral_M omega_1 + lambda_2 integral_M omega_2,
  quad lambda_1, lambda_2 in RR^1$.][Если $M'$~— противоположная к~$M$
  ориентация, то
  $integral_(M') omega = -integral_M omega$.]] <prop:integral-properties>

#proof[Свойство~б) очевидно как для формулы~@eq:integral-by-charts, так и для
  формулы~@eq:integral-by-partition. Поэтому совпадение
  формул~@eq:integral-by-charts и~@eq:integral-by-partition достаточно доказать
  для таких форм, носитель которых достаточно мал. Если
  $supp omega subset U_(alpha_(i_0))$, то по формуле~@eq:integral-in-chart
  $integral_U omega = integral_(U inter U_(alpha_(i_0))) omega$. Поэтому
  #source(393)в формуле~@eq:integral-by-charts имеем:
  $
    sum_(i=1)^N
    integral_(U_(alpha_i) without limits(union.big)_(j=1)^(i-1) U_(alpha_j))
    omega = sum_(i=1)^N
    integral_(U_(alpha_(i_0)) inter
    (U_(alpha_i) without limits(union.big)_(j=1)^(i-1) U_(alpha_j))) omega.
  $
  Поскольку все множества
  $U_(alpha_(i_0)) inter
  (U_(alpha_i) without limits(union.big)_(j=1)^(i-1) U_(alpha_j))$
  лежат в одной карте и попарно не пересекаются, то сумма интегралов равна
  интегралу по объединению
  $
    limits(union.big)_(i=1)^N
    (U_(alpha_(i_0)) inter
      (U_(alpha_i) without limits(union.big)_(j=1)^(i-1) U_(alpha_j)))
    = U_(alpha_(i_0)) inter
    (limits(union.big)_(i=1)^N U_(alpha_i) without limits(union.big)_(j=1)^(i-1)
      U_(alpha_j)) = \
    = U_(alpha_(i_0)) inter limits(union.big)_(i=1)^N U_(alpha_i)
    = U_(alpha_(i_0)).
  $
  Следовательно, в формуле~@eq:integral-by-charts правая часть равна
  $integral_(U_(alpha_(i_0))) omega$. С другой стороны, поскольку
  $supp omega subset U_(alpha_(i_0))$, то разбиение единицы можно подобрать так,
  чтобы $supp phi_alpha inter supp omega = emptyset$ при $alpha != alpha_(i_0)$.
  Тогда $phi_(alpha_(i_0)) equiv 1$ на $supp omega$ и
  формула~@eq:integral-by-partition приобретает вид:
  $integral_M omega = integral_(U_(alpha_(i_0))) phi_(alpha_(i_0)) omega
  = integral_(U_(alpha_(i_0))) omega$. Таким образом, утверждение~а) доказано.

  Докажем утверждение~в). Противоположную ориентацию на многообразии $M$ можно
  задать не меняя атласа карт, а изменив только систему координат в каждой карте
  $U_alpha$:
  $(y_alpha^1, dots, y_alpha^n) = (-x_alpha^1, x_alpha^2, dots, x_alpha^n)$.
  Тогда по формуле~@eq:integral-in-chart для новой ориентации имеем
  $
    integral_(U') omega = limits(integral dots.c integral)_(U') f'_alpha
    lr((y_alpha^1, dots, y_alpha^n)) d y_alpha^1 dots d y_alpha^n = \
    = limits(integral dots.c integral)_(U') f'_alpha
    lr((y_alpha^1 lr((x_alpha^1, dots, x_alpha^n)), dots))
    grow(|det grow(((partial y_alpha^i)/(partial x_alpha^j)))|) d x_alpha^1 dots
    d x_alpha^n.
  $
  Поскольку $f_alpha lr((x_alpha^1, dots, x_alpha^n))
  = f'_alpha lr((y_alpha^1 lr((x_alpha^1, dots, x_alpha^n)), dots)) det
  grow(((partial y_alpha^i)/(partial x_alpha^j)))$, то
  $
    integral_(U') omega = integral f_alpha lr((x_alpha^1, dots, x_alpha^n))
    op("sgn") det grow(((partial y_alpha^i)/(partial x_alpha^j))) d x_alpha^1
    dots d x_alpha^n = \
    = - integral f_alpha lr((x_alpha^1, dots, x_alpha^n)) d x_alpha^1 dots
    d x_alpha^n = - integral_U omega.
  $
  Следовательно, и в формуле~@eq:integral-by-charts во всех слагаемых изменится
  знак при изменении ориентации многообразия $M$.]

#subsection[Формула Стокса] <ss:stokes-formula> #source(394)Теперь мы докажем
основную формулу, обобщающую многочисленные формулы интегрирования из
математического анализа.

#theorem[Пусть $M$~— $n$-мерное ориентированное многообразие с краем
  $partial M$, $omega$~— внешняя дифференциальная форма степени $(n - 1)$ с
  компактным носителем. Тогда
  $
    (-1)^n integral_M d omega = integral_(partial M) omega.
  $ <eq:stokes>] <th:stokes>

Формула~@eq:stokes носит название _общей формулы Стокса_. Прежде чем доказывать
теорему~@th:stokes, рассмотрим некоторые частные случаи этой формулы.

#example[Рассмотрим в плоскости $RR^2$ гладкую замкнутую кривую $Gamma$ без
  самопересечений, ограничивающую открытую область $V$ в $RR^2$. Будем считать,
  что на кривой $Gamma$ введен параметр $t$, задающий направление обхода и,
  следовательно, ориентацию $Gamma$ как одномерного многообразия. Тогда
  замыкание $overline(V)$ является ориентированным двумерным многообразием с
  краем $partial V = Gamma$. Если ориентация области $overline(V)$ задается
  линейной системой координат $(x^1, x^2)$, то ориентация на границе $Gamma$
  окажется согласованной с ориентацией в области $overline(V)$, если при обходе
  кривой $Gamma$ при увеличении параметра $t$ область $overline(V)$ остается
  слева (см.~рис.~@fig:green-orientation). Пусть $omega$~— произвольная форма
  степени 1 на плоскости $RR^2$. Форма $omega$ в координатах $(x^1, x^2)$ имеет
  вид $omega = P(x^1, x^2) d x^1 + Q(x^1, x^2) d x^2$. Тогда интеграл от формы
  $omega$ по кривой $Gamma$ совпадает с интегралом второго рода:
  $
    integral_Gamma omega = integral_Gamma P d x^1 + Q d x^2 = \
    = integral_(t_0)^(t_1)
    grow(
      (P(x^1 lr((t)), x^2 lr((t))) (d x^1)/(d t)
        + Q(x^1 lr((t)), x^2 lr((t))) (d x^2)/(d t))
    ) d t.
  $
  По формуле~@eq:stokes имеем:
  $
    integral_Gamma omega = integral_V d omega
    = integral_V (d P and d x^1 + d Q and d x^2) = \
    = integral_V grow(((partial Q)/(partial x^1) - (partial P)/(partial x^2)))
    d x^1 and d x^2 = limits(integral.double)_V
    grow(((partial Q)/(partial x^1) - (partial P)/(partial x^2))) d x^1 d x^2.
  $
  #source(395)Таким образом, мы получили известную _формулу Грина_ на плоскости:
  $
    integral_Gamma (P d x^1 + Q d x^2) = limits(integral.double)_V
    grow(((partial Q)/(partial x^1) - (partial P)/(partial x^2))) d x^1 d x^2.
  $] <exm:green-formula>

#fig(fig-6-1()) <fig:green-orientation>

#example[Аналогично, пусть $Gamma$~— гладкая замкнутая кривая без
  самопересечений в трехмерном пространстве $RR^3$, ограничивающая некоторую
  двумерную поверхность $V$. Тогда по формуле~@eq:stokes получаем известную
  _формулу Стокса_. Для этого рассмотрим форму $omega$ степени 1 в трехмерном
  пространстве $RR^3$.
  $
    omega = P(x^1, x^2, x^3) d x^1 + Q(x^1, x^2, x^3) d x^2
    + R(x^1, x^2, x^3) d x^3.
  $
  Тогда интеграл второго рода по кривой $Gamma$ интерпретируется как интеграл от
  формы $omega$:
  $
    integral_Gamma omega = integral_(t_0)^(t_1)
    grow(
      (P(x^1, x^2, x^3) (d x^1)/(d t) + Q(x^1, x^2, x^3) (d x^2)/(d t)
        + R(x^1, x^2, x^3) (d x^3)/(d t))
    ) d t.
  $
  На основании формулы~@eq:stokes имеем:
  $integral_Gamma omega = integral_V d omega$;
  $
    d omega = d P and d x^1 + d Q and d x^2 + d R and d x^3 = \
    = grow(((partial Q)/(partial x^1) - (partial P)/(partial x^2))) d x^1
    and d x^2 + grow(((partial R)/(partial x^2) - (partial Q)/(partial x^3)))
    d x^2 and d x^3 + \
    nil + grow(((partial P)/(partial x^3) - (partial R)/(partial x^1))) d x^3
    and d x^1.
  $
  Таким образом, интеграл по кривой $Gamma$ выражается через интеграл второго
  рода по поверхности $V$:
  $
    integral_Gamma (P d x^1 + Q d x^2 + R d x^3) = \
    = limits(integral.double)_V
    grow(
      \( grow(((partial Q)/(partial x^1) - (partial P)/(partial x^2)))
      d x^1 d x^2
      + grow(((partial R)/(partial x^2) - (partial Q)/(partial x^3)))
      d x^2 d x^3 +
    ) \
    grow(
      nil + grow(((partial P)/(partial x^3) - (partial R)/(partial x^1)))
      d x^3 d x^1 \)
    ).
  $] <exm:stokes-formula>

#example[Последняя формула, _формула Гаусса~— Остроградского_, тоже является
  частным случаем формулы~@eq:stokes. Пусть $Gamma$~— замкнутая поверхность в
  $RR^3$, ограничивающая область $V$. Пусть $omega$~— внешняя дифференциальная
  форма степени 2. Форма $omega$ в координатах $(x^1, x^2, x^3)$ имеет вид:
  $
    omega = P d x^1 and d x^2 + Q d x^2 and d x^3 + R d x^3 and d x^1.
  $
  #source(396)Тогда интеграл второго рода по поверхности $Gamma$
  интерпретируется как интеграл формы $omega$. Применяя формулу~@eq:stokes,
  получаем
  $
    integral_Gamma omega = - integral_V d omega; \
    d omega = d P and d x^1 and d x^2 + d Q and d x^2 and d x^3
    + d R and d x^3 and d x^1 = \
    = grow(
      ((partial P)/(partial x^3) + (partial Q)/(partial x^1)
        + (partial R)/(partial x^2))
    ) d x^1 and d x^2 and d x^3.
  $
  Следовательно,
  $
    limits(integral.double)_Gamma
    (P d x^1 d x^2 + Q d x^2 d x^3 + R d x^3 d x^1) = \
    = - limits(integral.triple)_V
    grow(
      ((partial P)/(partial x^3) + (partial Q)/(partial x^1)
        + (partial R)/(partial x^2))
    ) d x^1 d x^2 d x^3.
  $
  Мы пришли к формуле Гаусса~— Остроградского с обратным знаком. Знак минус
  связан с тем, что в классической формуле Гаусса~— Остроградского ориентация
  поверхности $Gamma$, задаваемая парой векторов $(arrow(e)_1, arrow(e)_2)$ в
  касательном пространстве к поверхности $Gamma$, выбирается так, чтобы третий
  вектор $arrow(e)_3$ указывал направление вне области
  $V$.] <exm:gauss-ostrogradsky>

#example[Наконец, частным случаем формулы~@eq:stokes можно считать и _формулу
  Ньютона~— Лейбница_: $integral_a^b (d f)/(d x) (x) d x = f(b) - f(a)$. Левую
  часть формулы Ньютона~— Лейбница интерпретируем как интеграл формы
  $d f = (d f)/(d x) d x$ по отрезку $[a, b]$ вещественных чисел, который
  является одномерным ориентированным многообразием с краем. Краем отрезка
  $[a, b]$ является совокупность двух точек ${a, b}$, которые мы будем считать
  нульмерным многообразием. Однако для нульмерных многообразий мы не определяли
  понятие ориентации, поскольку у них отсутствуют касательные векторы. Поэтому
  можно поступить следующим образом. Будем считать, что точка края одномерного
  многообразия $M$ имеет положительную ориентацию, если вектор, указывающий
  направление внутрь $M$, дает исходную ориентацию многообразия $M$, и,
  наоборот, имеет отрицательную, если вектор, указывающий направление внутрь
  $M$, дает противоположную ориентацию многообразия $M$. Нульмерная форма на
  многообразии является просто функцией. Поэтому интеграл функции по нульмерному
  многообразию будем считать суммой значений функции в точках, взятых со знаком,
  равным ориентации #source(397)точек на многообразии. В нашем случае, правая
  часть формулы Ньютона~— Лейбница будет истолкована как интеграл функции $f$ по
  краю, состоящему из двух точек ${a, b}$. При этом точка $a$ имеет
  положительную ориентацию, а точка $b$~— отрицательную. Поэтому
  $integral_(partial [a, b]) f = f(a) - f(b)$. Формула же~@eq:stokes имеет вид:
  $integral_([a, b]) d f = (-1)^n integral_(partial [a, b])
  f$.] <exm:newton-leibniz>

#proof(of: [теоремы~@th:stokes])[Левая и правая часть формулы~@eq:stokes линейна
  относительно формы $omega$. Поэтому, разлагая форму $omega$ в сумму
  $omega = omega_1 + dots + omega_N$, достаточно доказывать формулу~@eq:stokes
  для случая, когда носитель формы $omega$ компактен и лежит в одной карте.
  Более того, достаточно доказать формулу~@eq:stokes для случая формы $omega$
  вида:
  $
    omega = f(x^1, dots, x^n) d x^1 and dots and d x^(k-1) and d x^(k+1)
    and dots and d x^n,
  $
  где $f$~— функция с компактным носителем, определенная в $RR_+^n$. Тогда
  $d omega = (-1)^(k-1) (partial f)/(partial x^k) d x^1 and dots and d x^n$.
  Рассмотрим два случая. Пусть $k < n$. Тогда ограничение формы $omega$ на край
  $RR_0^(n-1) subset RR_+^n$ равно нулю, поскольку $d x^n = 0$. Поэтому
  $integral_(RR_0^(n-1)) omega = 0$. С другой стороны,
  $integral_(RR_+^n) d omega = limits(integral dots.c integral)_(RR_+^n)
  (-1)^(k-1) (partial f)/(partial x^k) d x^1 dots d x^n$. Переходя к повторному
  интегралу, сначала по переменной $x^k$, а потом по всем остальным переменным
  получаем
  $
    integral_(RR_+^n) d omega = limits(integral dots.c integral)_(RR_+^(n-1))
    d x^1 dots d x^(k-1) d x^(k+1) dots d x^n integral_(-infinity)^infinity
    (-1)^(k-1) (partial f)/(partial x^k) d x^k.
  $
  Внутренний интеграл равен нулю в силу следующих очевидных соотношений:
  $integral_(-infinity)^infinity (partial f)/(partial x^k) d x^k
  = f(x^1, dots, x^n)|_(x^k = -infinity)^(x^k = +infinity)$. Поэтому
  $integral_(RR_+^n) d omega = 0$. Пусть теперь $k = n$. Тогда
  $omega = f(x^1, dots, x^n) d x^1 and dots and d x^(n-1)$,
  $
    d omega = (-1)^(n-1) (partial f)/(partial x^n) (x^1, dots, x^n) d x^1
    and dots and d x^(n-1) and d x^n.
  $
  Имеем:
  $
    integral_(RR_0^(n-1)) omega = limits(integral dots.c integral)_(RR_0^(n-1))
    f(x^1, dots, x^(n-1), 0) d x^1 dots d x^(n-1); \
    integral_(RR_+^n) d omega = limits(integral dots.c integral)_(RR_+^n)
    (-1)^(n-1) (partial f)/(partial x^n) d x^1 dots d x^(n-1) d x^n = \
    #source(398)= limits(integral dots.c integral)_(RR_0^(n-1)) d x^1 dots
    d x^(n-1) integral_0^infinity (-1)^(n-1) (partial f)/(partial x^n) d x^n = \
    = limits(integral dots.c integral)_(RR_0^(n-1)) d x^1 dots d x^(n-1)
    ((-1)^(n-1) f(x^1, dots, x^n)|_(x^n = 0)^(x^n = +infinity)) = \
    = (-1)^n limits(integral dots.c integral)_(RR_0^(n-1))
    f(x^1, dots, x^(n-1), 0) d x^1 dots d x^(n-1).
  $

  Следовательно,
  $integral_(RR_0^(n-1)) omega = (-1)^n integral_(RR_+^n) d omega$. Таким
  образом, для завершения доказательства, достаточно разложить форму $omega$ в
  сумму $omega = omega_1 + dots + omega_N$ так, чтобы носитель каждого
  слагаемого лежал в одной карте многообразия $M$. Рассмотрим атлас карт
  ${U_alpha}$ и разбиение единицы ${phi_alpha}$, подчиненное атласу ${U_alpha}$.
  Тогда $1 equiv sum phi_alpha$, $omega = sum phi_alpha omega$,
  $supp phi_alpha omega subset U_alpha$.]

#example[Теорему~@th:stokes можно применять для определения класса когомологий,
  определяемого замкнутой формой $omega$ на многообразии. Прежде всего заметим,
  что _если $omega$~— точная форма,_ т.~е. определяет нулевой класс когомологий
  $[omega] = 0 in H^k (M)$, то _интеграл формы $omega$ по любому замкнутому
  ориентированному подмногообразию $W subset M$, $dim W = k$, равен нулю:_
  $integral_W omega = 0$. В самом деле, поскольку $omega = d Omega$, а
  $partial W = emptyset$, то по формуле Стокса имеем:
  $integral_W omega = (-1)^k integral_(partial W) Omega = 0$. Верно и обратное
  утверждение: _если интеграл от замкнутой формы $f^* omega$ степени $k$ по
  любому замкнутому ориентированному многообразию $W$, $dim W = k$,
  отображенному в $M$, $f: W -> M$, равен нулю, то $omega$ является точной
  формой._

  Мы проверим это утверждение в частном случае, когда $k = 1$. Тогда условие,
  что $integral_gamma omega = 0$ по любой замкнутой кривой $gamma$, означает,
  что интеграл $integral_gamma omega$ по незамкнутой кривой зависит только от
  начальной и конечной точки кривой $gamma$. Тогда функцию $f$, такую, что
  $d f = omega$, будем искать в виде $f(P) = integral_gamma omega$, где
  $gamma$~— некоторая кривая, соединяющая фиксированную точку $P_0$ с
  «переменной» точкой $P$. Для доказательства равенства $d f = omega$ достаточно
  выбрать локальную систему координат в окрестности точки $P$, скажем
  $(x^1, dots, x^n)$. Тогда в качестве кривой $gamma$ всегда можно выбрать
  кривую, составленную из следующих кривых: фиксированная $gamma_0$~— соединяет
  #source(399)точку $P_0$ с началом координат $(0, dots, 0)$, последовательность
  отрезков, соединяющих точки: $(0, dots, 0)$, $(x^1, dots, 0)$;
  $(x^1, x^2, dots, 0)$; $dots$; $(x^1, dots, x^(n-1), 0)$,
  $(x^1, dots, x^(n-1), x^n)$. Тогда, полагая $omega = sum g_i d x^i$, имеем:
  $
    f(x^1, dots, x^n) = integral_(gamma_0) omega
    + integral_0^(x^1) g_1 lr((x^1, dots, 0)) d x^1 + \
    nil + integral_0^(x^2) g_2 lr((x^1, x^2, dots, 0)) d x^2 + dots
    + integral_0^(x^n) g_n lr((x^1, dots, x^n)) d x^n.
  $
  Следовательно,
  $
    (partial f)/(partial x^k) = g_k lr((x^1, dots, x^k, dots, 0))
    + integral_0^(x^(k+1)) partial/(partial x^k) g_(k+1)
    lr((x^1, dots, x^(k+1), dots, 0)) d x^(k+1) + dots \
    dots + integral_0^(x^n) partial/(partial x^k) g_n lr((x^1, dots, x^n)) d x^n
    = g_k lr((x^1, dots, x^k, dots, 0)) + \
    nil + integral_0^(x^(k+1)) partial/(partial x^(k+1)) g_k
    lr((x^1, dots, x^(k+1), dots, 0)) d x^(k+1) + dots \
    dots + integral_0^(x^n) partial/(partial x^n) g_k lr((x^1, dots, x^n)) d x^n
    = g_k lr((x^1, dots, x^k, dots, 0)) + \
    nil + [g_k lr((x^1, dots, x^(k+1), dots, 0))
      - g_k lr((x^1, dots, x^k, dots, 0))] + dots \
    dots + [g_k lr((x^1, dots, x^n)) - g_k lr((x^1, dots, x^(n-1), 0))]
    = g_k lr((x^1, dots, x^n)).
  $] <exm:closed-form-periods>
