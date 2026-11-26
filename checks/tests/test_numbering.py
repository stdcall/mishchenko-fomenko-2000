"""Compile the shared styles and inspect the actual numbered records."""
import json
from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[2]


class Numbering(unittest.TestCase):
    def test_book_scheme(self):
        # Every kind of statement counts apart and restarts in every section
        # and at the head of a chapter, whose introduction counts apart; the
        # formulas restart with the statements, a primed formula reads the
        # number of its base; the figures count through the chapter, the
        # problems through their list. A reference prints the own number.
        source = '''#import "/content/book-style.typ": book-style
#import "/content/main-defs.typ": *
#import "/content/statements.typ": *
#show: book-style
#chapter[Первая] <ch:first>
#example(numbered: true)[Пример введения.] <exm:intro>
#section[Первый] <sec:first>
#theorem[Теорема.] <th:first>
#lemma(numbered: true)[Лемма.] <lem:first>
#theorem[Теорема.] <th:second>
#example(numbered: true)[Пример.] <exm:first>
$ a = b $ <eq:first>
$ c = d $ <eq:second>
$ c = e $ <eq:second-prime>
#fig(rect(width: 1cm, height: 1cm)) <fig:first>
#problems
#problem[Задача.] <pr:first>
#problem[Задача.] <pr:second>
#section[Второй] <sec:second>
#theorem[Теорема.] <th:third>
$ e = f $ <eq:third>
#fig(rect(width: 1cm, height: 1cm)) <fig:second>
#problems
#problem[Задача.] <pr:third>
Ссылки: @th:second, @lem:first, @exm:intro, @exm:first, #[@eq:second],
#[@eq:second-prime], @fig:second, @pr:second, @pr:third, §~@sec:second,
гл.~@ch:first.
#chapter[Вторая] <ch:second>
#section[Третий] <sec:third>
#theorem[Теорема.] <th:fourth>
#fig(rect(width: 1cm, height: 1cm)) <fig:third>
Ссылки: @th:third, @th:fourth, @fig:third, теорему~@th:first §~@sec:first.
'''
        result = subprocess.run([
            'typst', 'eval', '--root', str(ROOT),
            '--font-path', str(ROOT / 'assets/fonts'),
            '--ignore-system-fonts',
            'query(metadata).map(it => it.value)',
            '--in', '-', '--format', 'json',
        ], input=source, capture_output=True, text=True, cwd=ROOT)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, '')
        records = json.loads(result.stdout)
        numbered = [(r['family'], r['number']) for r in records
                    if isinstance(r, dict) and r.get('kind') == 'numbered']

        def of(family):
            return [n for f, n in numbered if f == family]

        self.assertEqual(of('th'), [[1], [2], [1], [1]])
        self.assertEqual(of('lem'), [[1]])
        self.assertEqual(of('exm'), [[1], [1]])
        self.assertEqual(of('eq'), [[1], [2], ['2′'], [1]])
        self.assertEqual(of('fig'), [[1], [2], [1]])
        self.assertEqual(of('pr'), [[1], [2], [1]])
        refs = [r for r in records if isinstance(r, dict)
                and r.get('kind') == 'cross-reference']
        self.assertEqual([r['printed'] for r in refs], [
            '2', '1', '1', '1', '2', '2′', '2', '2', '1', '2', '1',
            '1', '1', '1', '1', '1',
        ])
        self.assertTrue(all(r['resolved'] for r in refs))


if __name__ == '__main__':
    unittest.main()
