# 서울대 논문 PDF 만들기

1. Quarto와 R을 설치하고 이 프로젝트 폴더를 Positron에서 엽니다.
2. 터미널에서 최초 한 번 `quarto install tinytex`와 `Rscript -e 'install.packages(c("knitr", "rmarkdown", "ggplot2", "showtext"), repos="https://cloud.r-project.org")'`를 실행합니다. 이미 설치했으면 생략합니다.
3. `quarto render`를 실행합니다. 예제 PDF는 `output/pdf/snu-thesis-ko-master.pdf`입니다.
4. `thesis.yml`의 제목·이름·학과·학위·날짜·심사위원을 수정합니다.
5. `abstracts/`의 초록과 `chapters/`의 본문, `references.bib`를 교체합니다.
6. 다시 `quarto render`로 전체 논문을 출력합니다.

박사는 `--profile ko-phd`, 영문 석사는 `--profile en-master`, 영문 박사는 `--profile en-phd`를 사용합니다. 영문 본문은 `chapters/en/`에 작성합니다. 기본 프로필은 `_quarto.yml`의 `profile.default`에서 바꿉니다.

공통 R 코드는 `scripts/analysis.R`에 있습니다. 각 장은 독립된 R 실행 환경을 사용하므로 필요한 장의 처음에 `source("scripts/analysis.R")`를 넣습니다.

서명·날인 있는 인준지는 별도 제출합니다. 초록 파일에는 실행 코드나 문헌 인용을 넣지 마세요. 초록 분량, 학과별 요구사항, 제출일은 실제 심사계획에 맞추어 확인하세요. 이 프로젝트는 서울대학교가 승인한 공식 템플릿이 아닙니다.

전체 사용 설명과 예제 PDF는 [공개 저장소](https://github.com/statisticsplaybook/snu-thesis-quarto)에서 확인할 수 있습니다. 새 프로젝트를 만들 때는 `quarto use template statisticsplaybook/snu-thesis-quarto`를 사용할 수 있습니다.
