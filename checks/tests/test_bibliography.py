"""The literature of the editorial notes through the actual compiler: the
descriptions come from editorial.bib only, mentions in the text and in
footnotes give the page list of a work, the list's own text does not, and
the works are numbered in the order of the list, «[1]», «[2]»; a reference
prints the number with its place, «[2, гл. 3]»."""
from pathlib import Path
import json
import re
import shutil
import subprocess
import tempfile
import unittest

import pymupdf

ROOT = Path(__file__).resolve().parents[2]

FIXTURE = '''@book{Probe2001,
  author = {Original, A. and Second, B. B.},
  title = {Original Title of a Book},
  edition = {2nd ed.},
  series = {Probe Series},
  number = {37},
  publisher = {Probe Press},
  location = {Probetown},
  year = {2001},
  language = {english},
  doi = {10.1234/original-probe},
  annotation = {{title}. {edition} {series}, vol. {number}. {location}:
    {publisher}, {year}.},
}

@book{Other1986,
  author = {Другой, Д. Д.},
  title = {Другая книга},
  publisher = {Мир},
  location = {М.},
  year = {1986},
  language = {russian},
  annotation = {{title}. {location}: {publisher}, {year}.},
}
'''

HEAD = ('#import "content/book-style.typ": book-style\n'
        '#import "content/bibliography-style.typ": bib-item, bib-preface\n'
        '#show: book-style\n'
        '#set page(header: none, footer: none)\n')


class Fixture:
    def __init__(self, tmp, sample, data=FIXTURE):
        self.root = Path(tmp)
        shutil.copytree(ROOT/'content', self.root/'content')
        shutil.copytree(ROOT/'assets/fonts', self.root/'assets/fonts')
        self.write(data)
        (self.root/'sample.typ').write_text(HEAD + sample)
        self.args = ['--root', str(self.root), '--ignore-system-fonts',
                     '--font-path', str(self.root/'assets/fonts')]

    def write(self, data):
        (self.root/'editorial.bib').write_text(data)

    def compile(self, test, name='sample.pdf'):
        result = subprocess.run(
            ['typst', 'compile', *self.args, str(self.root/'sample.typ'),
             str(self.root/name)], capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        test.assertEqual(result.stderr, '', result.stderr)
        return pymupdf.open(self.root/name)

    def query(self, test, expression):
        result = subprocess.run(
            ['typst', 'eval', *self.args, expression, '--in',
             str(self.root/'sample.typ'), '--format', 'json'],
            capture_output=True, text=True)
        test.assertEqual(result.returncode, 0, result.stderr)
        return json.loads(result.stdout)


def page_text(doc):
    text = ' '.join(' '.join(page.get_text().split()) for page in doc)
    # Soft hyphens and word joiners are invisible.
    return re.sub(r'­\s*', '', text).replace('⁠', '')


def squeezed(text):
    """The text without spaces, also the no-break ones of the initials."""
    return re.sub(r'\s+', '', text)


class BibliographySource(unittest.TestCase):
    def test_data_changes_reach_text_and_links(self):
        sample = '#bib-item("Probe2001") <bib:Probe2001>\n'
        with tempfile.TemporaryDirectory(prefix='mf-bib-', dir='/tmp') as tmp:
            fixture = Fixture(tmp, sample)

            def build(name):
                with fixture.compile(self, name) as doc:
                    links = {link['uri'] for page in doc
                             for link in page.get_links() if 'uri' in link}
                    return page_text(doc), links

            before, old_links = build('before.pdf')
            for phrase in ('Original Title of a Book', '2nd ed.',
                           'Probe Series, vol. 37', 'Probetown: Probe Press, 2001',
                           'DOI: 10.1234/original'):
                self.assertIn(phrase, before)
            self.assertIn('OriginalA.,SecondB.B.', squeezed(before))
            self.assertIn('https://doi.org/10.1234/original-probe', old_links)

            changed = (FIXTURE
                       .replace('Original Title', 'Changed Title')
                       .replace('year = {2001}', 'year = {2003}')
                       .replace('Probe Press', 'Other Press')
                       .replace('original-probe', 'changed-probe')
                       .replace('Original, A.', 'Renamed, A.'))
            fixture.write(changed)
            after, new_links = build('after.pdf')
            for phrase in ('Changed Title of a Book',
                           'Probetown: Other Press, 2003',
                           'DOI: 10.1234/changed'):
                self.assertIn(phrase, after)
            for phrase in ('Original Title', 'Probe Press', '2001',
                           '10.1234/original'):
                self.assertNotIn(phrase, after)
            self.assertIn('RenamedA.,SecondB.B.', squeezed(after))
            self.assertIn('https://doi.org/10.1234/changed-probe', new_links)
            self.assertNotIn('https://doi.org/10.1234/original-probe',
                             new_links)

    def test_mentions_in_text_and_footnotes_only(self):
        sample = ('Mention in the text: @bib:Probe2001[гл.~3].\n'
                  '#pagebreak()\n'
                  'A page with a footnote.#footnote[Mention in a footnote: '
                  '@bib:Probe2001.]\n'
                  '#pagebreak()\n'
                  'Two mentions on one page: @bib:Probe2001 and '
                  '@bib:Probe2001.\n'
                  '#pagebreak()\n'
                  '#heading(level: 1, numbering: none)[Литература]\n'
                  '#bib-preface[The list cites itself: @bib:Probe2001, '
                  '@bib:Other1986.]\n'
                  '#bib-item("Other1986") <bib:Other1986>\n'
                  '#bib-item("Probe2001") <bib:Probe2001>\n')
        with tempfile.TemporaryDirectory(prefix='mf-bib-mentions-',
                                         dir='/tmp') as tmp:
            fixture = Fixture(tmp, sample)
            with fixture.compile(self) as doc:
                first = page_text(doc[0:1])
                text = page_text(doc[3:])
                targets = [link['page'] for link in doc[3].get_links()
                           if link.get('kind') == pymupdf.LINK_GOTO]
            mentions = fixture.query(
                self, 'query(metadata).map(it => it.value).filter(it => '
                'type(it) == dictionary and '
                'it.at("kind", default: none) == "page-reference")')
            pages = {}
            for mention in mentions:
                pages.setdefault(mention['target'], []).append(
                    mention['target-position']['page'])
            # Pages 1, 2 (the footnote) and 3 (once), not the list itself.
            self.assertEqual(pages, {'bib-mention:bib:Probe2001': [1, 2, 3]})
            self.assertIn('[с. 1, 2, 3]', text)
            # The works are numbered in the order of the list.
            self.assertIn('[2, гл. 3]', first)
            self.assertIn('[1] Другой Д. Д.', text.replace('\xa0', ' '))
            self.assertIn('[2] Original A.', text.replace('\xa0', ' '))
            numbers = fixture.query(
                self, 'query(<numbered>).map(it => it.value).filter(it => '
                'it.at("family", default: none) == "bib")'
                '.map(it => it.number)')
            self.assertEqual(numbers, [['1'], ['2']])
            for page in (0, 1, 2):
                self.assertIn(page, targets)


if __name__ == '__main__':
    unittest.main()
