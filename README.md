# 서울대학교 학위논문 Quarto 템플릿

국문·영문, 석사·박사 논문을 QMD로 작성하고 PDF로 출력하는 **비공식** 템플릿입니다. 서울대학교 중앙도서관의 2026년 7월 배포 서식과 작성 요령을 참고했습니다. 학교가 승인하거나 배포한 Quarto 템플릿은 아닙니다.

## 템플릿 가져오기

공개 저장소: [statisticsplaybook/snu-thesis-quarto](https://github.com/statisticsplaybook/snu-thesis-quarto)

- GitHub의 **Use this template → Create a new repository**로 내 저장소를 만듭니다.
- Git을 쓰지 않으면 **Code → Download ZIP**으로 받고 압축을 풉니다.
- Quarto가 설치되어 있으면 빈 폴더에서 다음 명령을 실행할 수도 있습니다.

```bash
quarto use template statisticsplaybook/snu-thesis-quarto
```

이름을 묻는 단계에서 내 논문 폴더 이름을 정한 뒤, 생성된 폴더를 Positron에서 엽니다. 예제 PDF 네 종류는 [output/pdf/](output/pdf/)에서 먼저 확인할 수 있습니다.

## 처음 사용하기

1. [Quarto](https://quarto.org/docs/get-started/)와 [R](https://cran.r-project.org/)을 설치합니다.
2. Positron에서 이 폴더를 열고 터미널에서 아래 명령을 실행합니다.

```bash
quarto install tinytex
Rscript -e 'install.packages(c("knitr", "ggplot2", "showtext"), repos="https://cloud.r-project.org")'
quarto render
```

이미 TeX Live/MacTeX와 knitr·ggplot2·showtext가 설치되어 있으면 해당 설치는 생략할 수 있습니다. 첫 출력에서는 인터넷 연결이 필요할 수 있습니다. Quarto는 TinyTeX/TeX Live의 누락된 LaTeX 패키지를 자동 설치합니다.

기본 출력은 `output/pdf/snu-thesis-ko-master.pdf`입니다. **프로젝트 전체를 출력**해야 하므로, 터미널의 `quarto render`를 권합니다. 장 하나만 출력하면 다른 장의 교차참조가 포함되지 않을 수 있습니다.

## 국문·영문, 석사·박사 선택

| 논문 종류 | 명령 | 출력 파일 |
|---|---|---|
| 국문 석사(기본) | `quarto render --profile ko-master` | `snu-thesis-ko-master.pdf` |
| 국문 박사 | `quarto render --profile ko-phd` | `snu-thesis-ko-phd.pdf` |
| 영문 석사 | `quarto render --profile en-master` | `snu-thesis-en-master.pdf` |
| 영문 박사 | `quarto render --profile en-phd` | `snu-thesis-en-phd.pdf` |

파일은 모두 `output/pdf/`에 생성됩니다. 프로필은 표지·인준지·초록·목차의 언어와 학위명, 심사위원 수를 바꿉니다. **본문 번역 기능이 아닙니다.** 영문 프로필은 `chapters/en/`의 영문 예제를 사용합니다.

기본 종류를 바꾸려면 `_quarto.yml`의 `profile.default`를 수정합니다. 박사라고 해서 학과의 학위 명칭이 자동으로 확인되는 것은 아니므로 `degree-field-ko`, `degree-field-en`을 본인의 수여 학위에 맞춰 작성하세요.

## 학생이 수정할 파일

- `thesis.yml`: 국문·영문 제목과 부제, 이름, 학번, 학과, 지도교수, 날짜, 심사위원, 주요어.
- `abstracts/ko.qmd`, `abstracts/en.qmd`: 국문·영문 초록. 제목·이름·주요어는 자동 출력되므로 파일에는 초록 본문만 작성합니다.
- `chapters/*.qmd` 또는 `chapters/en/*.qmd`: 장별 본문.
- `scripts/analysis.R`: 예제의 공통 R 분석 코드. 각 장은 별도 R 환경에서 실행하므로 필요한 장에서 이 파일을 읽습니다.
- `references.bib`: 참고문헌. 본문에서 `[@문헌키]`로 인용합니다.
- `_quarto-ko-master.yml` 등 사용하는 프로필: 장을 추가·삭제할 때 파일 목록을 수정합니다.

공통 서식은 `_extensions/snu-thesis/`에 있습니다. 일반적인 논문 작성에는 LaTeX 파일을 수정할 필요가 없습니다.

### 날짜와 심사위원

날짜는 `YYYY-MM`으로 입력합니다. `graduation-date`는 학위수여 연월, `submission-date`는 심사용 논문 제출기한 연월, `approval-date`는 종심기한 연월입니다. 예제 날짜는 실제 제출 일정이 아닙니다.

`committee-master`에는 3명, `committee-phd`에는 5명을 입력합니다. 순서는 위원장, 부위원장, 나머지 위원이며, 지도교수는 학교 작성 요령에 따라 마지막에 배치합니다. 지도교수가 위원장으로 입력되거나 위원 수가 맞지 않으면 이유를 표시하고 출력을 중단합니다.

### 초록·참고문헌·부록·감사의 글

출력 순서는 표제지 → 서명 없는 인준지 → 본문 언어 초록 → 목차·표 목차·그림 목차 → 본문 → 참고문헌 → 부록 → 다른 언어 초록 → 선택적 감사문입니다. 초록은 일반 Markdown 문단, 강조, 수식을 지원합니다. 실행 청크와 문헌 인용은 초록 파일에서 지원하지 않습니다.

감사문을 사용하려면 QMD 파일을 작성한 다음 `thesis.yml`의 `acknowledgements`에 경로를 입력합니다. 부록이 없으면 사용하는 프로필의 `book.appendices`를 삭제합니다. 표·그림이 없으면 `format.snu-thesis-pdf` 아래에 `lot: false`, `lof: false`를 설정하여 빈 목록을 생략할 수 있습니다.

인용 형식의 기본값은 Pandoc의 기본 저자-연도 스타일입니다. 학과가 지정한 CSL 파일이 있으면 `csl: 파일명.csl`을 `_quarto.yml`에 추가하세요. 대학 공통 양식에서 특정 학술지의 인용 규칙까지 정하는 것은 아닙니다.

### 용지와 글꼴

기본 용지는 작성 요령의 19 × 26cm입니다. 본문은 11pt, 명조 계열 나눔명조, 중앙 하단 페이지 번호를 사용합니다. 앞부분은 로마자, 본문부터는 아라비아 숫자로 표시합니다. `linestretch: 1.7`은 LaTeX의 줄간격 배율이며 HWP의 170%와 정확히 같은 측정값은 아닙니다.

중앙도서관 웹 안내는 글꼴·크기·여백을 권장사항으로 설명합니다. A4 출력이 필요하면 PDF 형식의 `geometry`에서 `paperwidth=210mm`, `paperheight=297mm`로 바꾸세요. 학과 별도 지침이 있으면 그것을 우선 확인합니다. 기본 글꼴은 저장소에 동봉되어 운영체제에 따로 설치하지 않아도 됩니다.

## 기존 프로젝트에 서식 추가

새 논문을 시작할 때는 위의 템플릿 전체를 가져오는 방법을 권합니다. 기존 Quarto 논문에는 다음 명령으로 서식 확장을 추가할 수 있습니다.

```bash
quarto add statisticsplaybook/snu-thesis-quarto
```

이 경우 `thesis.yml`, 언어·학위 프로필과 book 구성을 별도로 갖춰야 합니다.

Quarto 템플릿 복사는 `README.md`, `LICENSE`, 숨김 파일 등을 제외하므로 사용자 안내를 `START-HERE.md`에도 제공합니다. `.quartoignore`는 배포용 문서·검증 스크립트·예제 출력물을 학생 프로젝트에 복사하지 않도록 지정합니다. ZIP 다운로드와 GitHub의 Use this template는 전체 저장소를 가져옵니다.

## 검증과 유지보수

`.github/workflows/render.yml`은 Windows, macOS, Linux에서 네 프로필의 출력을 검증하도록 준비되어 있습니다. [GitHub Actions](https://github.com/statisticsplaybook/snu-thesis-quarto/actions)에서 실행 결과를 확인할 수 있습니다. 로컬 검증 내용은 `docs/VALIDATION.md`, 서식 비교와 출처는 `docs/SOURCES.md`를 보세요.

검증 스크립트는 PDF의 페이지 크기, 표지·인준지 수, 심사위원 수, 초록·참고문헌·부록 순서, 실제 R 결과, 교차참조 등을 확인합니다. 자동 검증과 별도로 제목이 긴 경우 표지와 인준지가 한 페이지에 들어가는지 시각적으로 확인해야 합니다. 예제 초록은 사용법 설명을 위한 짧은 문서이며 제출용 초록 분량 요건의 검증 대상은 아닙니다.

## 제출 시 확인할 사항

학교는 논문 원문과 서명·날인이 있는 인준지 스캔본을 각각 PDF로 제출하도록 안내합니다. 이 프로젝트가 생성하는 본문 PDF에는 **서명 없는 인준지**가 포함됩니다. 서명본 업로드와 실제 심사·학과 확인은 별도 절차입니다.

이 템플릿은 PDF 생성을 돕습니다. 학위논문의 내용, 학과별 서식 및 제출 승인까지 보장하지는 않습니다. [중앙도서관의 최신 제출 안내](https://lib.snu.ac.kr/using/thesis/submission/s-guide/)를 함께 확인하세요.

## 라이선스

새로 작성한 코드와 예제 문서는 MIT 라이선스입니다. 동봉한 나눔명조는 SIL Open Font License 1.1이며 글꼴 폴더의 `OFL.txt`를 따릅니다. 기존 국문·영문 LaTeX 후보는 구조 비교 자료로만 사용했고 원본 코드·글꼴 묶음은 배포하지 않습니다. 상세 출처는 `docs/SOURCES.md`에 기록했습니다.
