# 장별 R 실행 환경에서 같은 분석 결과를 계산합니다.
# 자료를 바꾸면 이 파일에서 분석 코드를 수정하세요.
x <- cars
model <- lm(dist ~ speed, data = x)
