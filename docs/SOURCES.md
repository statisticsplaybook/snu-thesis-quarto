# 서식 기준과 원본 비교

확인일: 2026-10-07. 이 프로젝트는 서울대학교의 공식 Quarto 템플릿이 아닙니다.

## 학교 기준

- [중앙도서관 학위논문 제출 안내](https://lib.snu.ac.kr/using/thesis/submission/s-guide/)
- [2026년 7월 양식 ZIP](https://lib.snu.ac.kr/wp-content/uploads/2026/07/%EC%96%91%EC%8B%9Dtemplete.zip)
- [2025학년도 후기 작성 요령 ZIP](https://lib.snu.ac.kr/wp-content/uploads/2026/07/2025%ED%95%99%EB%85%84%EB%8F%84-%ED%9B%84%EA%B8%B0-%ED%95%99%EC%9C%84%EB%85%BC%EB%AC%B8-%EC%9E%91%EC%84%B1-%EC%9A%94%EB%A0%B9.zip)

학교 양식 ZIP을 내려받아 실제 파일 목록을 확인했고, 국문·영문 Word 파일의 본문과 HWP 작성 요령을 추출하여 비교했습니다. 원본 학교 문서는 본 저장소에 재배포하지 않습니다.

양식 ZIP 내용: `(kor.)templet.hwp`, `(kor.)templet.doc`, `(eng.)templet_master.doc`, `(eng.)templet_Ph.D..doc`. ZIP 내부 날짜는 2026-07-02입니다.

| 항목 | 확인한 학교 기준 | 프로젝트 구현 |
|---|---|---|
| 제출 파일 | 원문 PDF와 서명 있는 인준지 PDF 별도 | 원문 안에 서명 없는 인준지 자동 생성 |
| 논문 구성 | 표제지, 인준지, 본문 언어 초록, 목차, 본문, 참고문헌, 부록, 다른 언어 초록, 감사문 | 같은 순서, 감사문 선택 |
| 심사위원 | 석사 3명, 박사 5명 | 프로필별 위원 수 검증 |
| 지도교수 | 위원장 불가, 심사위원 마지막에 배치 | 입력값 검증 |
| 날짜 | 학위수여일, 심사용 제출기한, 종심기한의 연월 구분 | 독립된 YYYY-MM 입력값 세 개 |
| 본문 권장 | 19×26cm, 약 11pt, 명조 계열, 하단 중앙 쪽수 | 19×26cm, 11pt, 나눔명조, 하단 중앙 쪽수 |
| 앞부분 쪽수 | 서식에 로마자 사용 | 초록~목차 로마자, 본문부터 1 |
| 글꼴·크기·여백 | 현재 웹 안내는 권장사항으로 설명 | 설정 변경 가능, 단일 기본값 제공 |
| 주요어 | 작성 요령은 7~8개 이내, Word 예제는 6개 이내로 서로 다름 | 보수적으로 6개 기본값, 최대 8개 설정 가능 |
| 초록 분량 | 작성 요령에 2~7페이지 안내 | 예제는 짧게 작성; 제출용 분량은 학생이 확인 |

여백은 작성 요령의 위쪽·머리말, 아래쪽·꼬리말 값을 고려해 LaTeX 본문 상단 35mm, 하단 30mm로 설정했습니다. HWP 여백·줄간격과 LaTeX 설정은 측정 방식이 다르므로 픽셀 단위 복제는 아닙니다. 학교 최신 웹 안내와 학과별 요구를 함께 확인하세요.

## LaTeX 비교 후보

- [kungmo/SNU_Dissertation_LaTeX_Korean](https://github.com/kungmo/SNU_Dissertation_LaTeX_Korean): 국문 논문 후보. `manuscript.tex`, `title.tex`를 내려받아 구조와 글꼴 설정을 확인했습니다. 확인 당시 저장소 최상위에 LICENSE가 없으며, 운영체제별 글꼴 경로와 참고문헌 코드가 포함되어 있습니다. 코드와 글꼴 압축 묶음을 프로젝트에 복사하지 않았습니다.
- [Sungju Moon의 SNU Dissertation Template](https://www.overleaf.com/latex/templates/snu-dissertation-template/fxvtwvxzdpvp): 영문 작성 후보. 공개 소스의 표지·학위·언어 옵션을 확인했습니다. CC BY 4.0로 표시되지만 특정 연구실에 맞춘 변경과 인쇄본 설정이 포함되어 있어 이번 구현에는 직접 포함하지 않았습니다.

국문·영문 후보는 학교가 공식 배포한 한 쌍이 아닙니다. 본 확장은 학교가 제공한 문서의 구성·필드를 기준으로 **새로 작성한 코드**입니다. 제3자 LaTeX 클래스, 참고문헌 코드, 원본 논문, 로고를 동봉하지 않습니다.

## 글꼴

- [Google Fonts의 Nanum Myeongjo](https://github.com/google/fonts/tree/main/ofl/nanummyeongjo)
- `NanumMyeongjo-Regular.ttf`, `NanumMyeongjo-Bold.ttf`, `OFL.txt`를 동봉.
- SIL Open Font License 1.1. 글꼴은 수정하지 않았으며 원래 이름과 라이선스 파일을 유지.
- 라틴 문자와 수식은 TeX 배포판의 Latin Modern 사용. 운영체제의 글꼴 이름 대신 TeX가 검색할 수 있는 파일명을 지정.

## Quarto 기술 근거

- [Custom Formats](https://quarto.org/docs/extensions/formats.html): PDF 확장과 리소스 배포.
- [Article Templates](https://quarto.org/docs/journals/templates.html): 기본 템플릿을 유지하고 표지·목차·후반부만 partial로 교체.
- [Starter Templates](https://quarto.org/docs/extensions/starter-templates.html): GitHub에서 학생 프로젝트 생성.
- [PDF Engines](https://quarto.org/docs/output-formats/pdf-engine.html): XeLaTeX, TinyTeX와 패키지 관리.

학교 서식이 변경되면 이 파일의 기준일과 비교표를 갱신하고, 네 예제 PDF를 다시 출력하여 표지·인준지·본문 순서를 검증한 후 새 버전을 배포합니다.
