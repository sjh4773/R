# 파생변수 생성

# 1. $:data.frame에서의 변수추가
# $ 기호를 이용하면 데이터프레임에서 원하는 이름으로 새로운 변수를 즉시 생성할 수 있으며, 사용법은 아래와 같다.
# 데이터프레임$변수명 <- 추가할 변수의 데이터 벡터

# 예제
# Q.R의 내장 데이터 iris에 행번호를 담고 있는 'ID'라는 변수를 새로 생성해보자.

#iris 데이터 구조 확인 : 150개의 행과 5개의 변수를 가지고 있다.
str(iris)

# 'data.frame':	150 obs. of  5 variables:
#   $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
# $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
# $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
# $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
# $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

# 150개의 개체들의 고유번호에 해당하는 'ID' 변수를 새로 생성
iris$ID<-1:150

# iris 데이터의 상위 6개의 행을 출력한 결과, ID 변수가 추가된 것을 확인할 수 있다.
head(iris)


# Sepal.Length Sepal.Width Petal.Length Petal.Width Species ID
# 1          5.1         3.5          1.4         0.2  setosa  1
# 2          4.9         3.0          1.4         0.2  setosa  2
# 3          4.7         3.2          1.3         0.2  setosa  3
# 4          4.6         3.1          1.5         0.2  setosa  4
# 5          5.0         3.6          1.4         0.2  setosa  5
# 6          5.4         3.9          1.7         0.4  setosa  6


# 2. [] : 대괄호를 활용한 변수추가
# $ 기호와 마찬가지로 []를 활요해도 우너하는 이름으로 새로운 변수를 즉시 생성할 수 있다.
# 주의할 점은 새롭게 생성하고자 하는 변수의 이름을 큰따옴표(" ")안에 기입해야 한다는 것이다.
# 데이터프레임["변수명"]<-추가할 변수의 데이터 벡터

# 예제
# Q.$를 이용하여 생성했던 ID 변수의 값이 짝수이면 A, 홀수이면 B로 분류하는 새로운 변수(변수명:Group)를 []를 활용하여 생성해보자.

# ifelse 함수를 이용하여 ID가 짝수이면 A, 홀수이면 B를 부여
iris["Group"]<-ifelse(iris$ID %% 2 == 0, "A", "B")

# iris 데이터의 상위 6개의 행을 출력: Group 변수가 추가된 것을 확인할 수 있다.
head(iris)

# Sepal.Length Sepal.Width Petal.Length Petal.Width Species ID Group
# 1          5.1         3.5          1.4         0.2  setosa  1     B
# 2          4.9         3.0          1.4         0.2  setosa  2     A
# 3          4.7         3.2          1.3         0.2  setosa  3     B
# 4          4.6         3.1          1.5         0.2  setosa  4     A
# 5          5.0         3.6          1.4         0.2  setosa  5     B
# 6          5.4         3.9          1.7         0.4  setosa  6     A


# 3.transform
# transform 함수를 이용하여 데이터 프레임에 새로운 변수를 추가할 수 있으며, 문법은 아래와 같다.

# 함수 사용법

# transform(데이터프레임, val1=data1, var2=data2,...)
# 데이터프레임 : 변수를 추가하고자 하는 데이터명
# var          : 새로 생성할 변수의 이름
# data          : 데이터프레임에 열로 추가할 데이터 벡터

# 함수 사용 예제
# Q. iris 데이터에서 Sepal.Length 변수와 Petal.Length 변수의 값을 더하여
# 'Sum.Length'라는 변수를 생성해보자.

transform(iris, Sum.Length = Sepal.Length + Petal.Length)

# Sepal.Length Sepal.Width Petal.Length Petal.Width    Species  ID Group Sum.Length
# 1            5.1         3.5          1.4         0.2     setosa   1     B        6.5
# 2            4.9         3.0          1.4         0.2     setosa   2     A        6.3
# 3            4.7         3.2          1.3         0.2     setosa   3     B        6.0
# 4            4.6         3.1          1.5         0.2     setosa   4     A        6.1
# 5            5.0         3.6          1.4         0.2     setosa   5     B        6.4
# 6            5.4         3.9          1.7         0.4     setosa   6     A        7.1
# 7            4.6         3.4          1.4         0.3     setosa   7     B        6.0
# 8            5.0         3.4          1.5         0.2     setosa   8     A        6.5
# 9            4.4         2.9          1.4         0.2     setosa   9     B        5.8
# 10           4.9         3.1          1.5         0.1     setosa  10     A        6.4
# 생략...
# [ reached 'max' / getOption("max.print") -- omitted 25 rows ]


# 4.within
# within 함수는 데이터 프레임 또는 리스트 내 필드에 접근하고 수정할 수 있는 기능을 제공한다.

# 함수 사용법

# within(데이터,표현식)
# 데이터 : 수정하고자 하는 데이터명
# 표현식 : 데이터에 적용할 코드

# 함수 사용 예제
# Q. 학생의 id(s1, s2, s3, s4, s5, s6)를 담은 student_id 변수와 시험점수(55, 90, 85, 71, 63, 99)를
# 담은 score 변수로 구성도니 데이터프레임을 생성하자. 그 후 시험 점수가 90점 이상이면 수,
# 80점 이상 90점 미만이면 우, 70점 이상 80점 미만이면 미, 60점 이상 70점 미만이면 양,
# 60점 이하이면 가로 분류하는 'grade'라는 변수를 새롭게 생성해보자.

# 학생id(student_id 변수)와 시험점수(score 변수)로 이루어진 데이터 프레임 생성
student_id <- c("s1", "s2", "s3", "s4", "s5", "s6") # 학생id가 담긴 벡터
score <- c(55, 90, 85, 71, 63, 99)                  # 시험점수가 담긴 벡터
score_df <- data.frame(student_id, score)           # 데이터 프레임 생성
score_df

# student_id score
# 1         s1    55
# 2         s2    90
# 3         s3    85
# 4         s4    71
# 5         s5    63
# 6         s6    99


# 학생의 점수(score변수)를 수, 우, 미, 양, 가로 분류하여 'grade'라는 새로운 변수 생성
score_df <- within(score_df, {
  grade = character(0)            # 새로운 변수의 데이터 타입 지정(생략 가능)
  grade[ score < 60 ] ='가'
  grade[ score >= 60 & score < 70 ] = '양'
  grade[ score >= 70 & score < 80 ] = '미'
  grade[ score >= 80 & score < 90 ] = '우'
  grade[ score >= 90 ] = '수'
  
  # grade 변수를 "수", "우", "미", "양", "가"의 범주로 이루어진 팩터로 변환
  grade = factor(grade, level=c("수", "우", "미", "양", "가"))
})

# score_df 출력 : grade 변수가 추가된 것을 확인할 수 있다.
score_df


# student_id score grade
# 1         s1    55    가
# 2         s2    90    수
# 3         s3    85    우
# 4         s4    71    미
# 5         s5    63    양
# 6         s6    99    수