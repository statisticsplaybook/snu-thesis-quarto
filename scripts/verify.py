"""Verify the shipped thesis examples after a full Quarto render (maintainers)."""
import argparse
import re
import unicodedata
from pathlib import Path
from pypdf import PdfReader
import yaml

parser = argparse.ArgumentParser()
parser.add_argument('pdf', type=Path)
parser.add_argument('--profile', required=True, choices=['ko-master', 'ko-phd', 'en-master', 'en-phd'])
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
t = yaml.safe_load((root / 'thesis.yml').read_text(encoding='utf-8'))['thesis']
language, degree = args.profile.split('-')
reader = PdfReader(args.pdf)
pages = [unicodedata.normalize('NFKC', page.extract_text() or '') for page in reader.pages]
compact = [re.sub(r'\s+', '', page) for page in pages]
text = '\n'.join(pages)

def check(condition, message):
    if not condition:
        raise SystemExit('FAIL: ' + message)

check(len(pages) >= 10, 'Missing document sections')
for index, page in enumerate(reader.pages):
    mm = [float(page.mediabox.width) * 25.4 / 72, float(page.mediabox.height) * 25.4 / 72]
    check(abs(mm[0] - 190) < 0.2 and abs(mm[1] - 260) < 0.2, f'Unexpected page size on page {index+1}')
check(re.sub(r'\s+', '', t[f'title-{language}']) in compact[0], 'Title missing or cover spills over')
check(re.sub(r'\s+', '', t[f'name-{language}']) in compact[0], 'Author missing on cover')
count = 3 if degree == 'master' else 5
seal = '(인)' if language == 'ko' else '(Seal)'
check(compact[1].count(seal) == count, 'Approval must fit on one page with all committee members')
for member in t[f'committee-{degree}']:
    check(re.sub(r'\s+', '', member[f'name-{language}']) in compact[1], 'Committee member missing')
check(compact[2].startswith('초록' if language == 'ko' else 'Abstract'), 'Primary abstract must follow approval')
check(compact[3].startswith('목차' if language == 'ko' else 'TableofContents'), 'Contents must follow the primary abstract')
check('??' not in text and '@fig-' not in text and '@tbl-' not in text, 'Unresolved cross-reference')
check('15.4' in text and '42.98' in text and '3.932' in text, 'R results missing or stale')
check('Speed (mph)' in text and 'Stopping distance (ft)' in text, 'Figure/table not rendered')
check('R Core Team' in text and 'https://quarto.org/' in text, 'Bibliography missing')
check('2027년2월' in compact[0] if language == 'ko' else 'February2027' in compact[0], 'Graduation date missing')
check('2026년12월' in compact[1] if language == 'ko' else 'December2026' in compact[1], 'Submission date missing')
check('2027년1월' in compact[1] if language == 'ko' else 'January2027' in compact[1], 'Final review date missing')
intro = next((i for i, p in enumerate(compact[6:], 6) if '연구의배경' in p or 'Background' in p), -1)
check(intro == 6, 'Blank chapter/page before introduction')
check(compact[intro].startswith('제1장' if language == 'ko' else 'Chapter1'), 'Introduction must be Chapter 1')
check(pages[intro].strip().endswith('1'), 'Main text page numbering must start at 1')
bib_label = '참고문헌' if language == 'ko' else 'Bibliography'
bib = next((i for i, p in enumerate(pages[7:], 7) if re.sub(r'\s+', '', p).startswith(bib_label)), -1)
appendix = next((i for i, p in enumerate(pages[7:], 7) if '회귀모형의 계수' in p or 'Regression coefficients' in p), -1)
secondary_label = 'Abstract' if language == 'ko' else '국문초록'
secondary = next((i for i, p in enumerate(pages[bib+1:], bib+1) if re.sub(r'\s+', '', p).startswith(secondary_label)), -1)
check(6 < bib < appendix < secondary, 'Bibliography/appendix/secondary abstract order incorrect')
check('2025-00000' in pages[2] and '2025-00000' in '\n'.join(pages[secondary:]), 'Student number missing in abstracts')
check(reader.metadata.author == t[f'name-{language}'], 'PDF author metadata differs from thesis.yml')
print(f'PASS: {args.profile}, {len(pages)} pages, cover/approval/abstracts/numbering/R/crossrefs verified')
