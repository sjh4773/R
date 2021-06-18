setwd("C:/R/Data")

# 데이터 프레임 만들기

english <- c(90, 80, 60, 70)

math <- c(50, 60, 100, 20)

df_midterm <- data.frame(english, math)

df_midterm

class <- c(1, 1, 2, 2)

class

df_midterm <- data.frame(english, math, class)
df_midterm


# 외부 데이터 이용하기

install.packages("readxl")
library(readxl)

df_exam <- read_excel("excel_exam.xlsx")
df_exam

# 분석하기

mean(df_exam$english)

mean(df_exam$science)


# 조건에 맞는 데이터만 추출하기

install.packages("dplyr")
library(dplyr)

exam <- read.csv("csv_exam.csv")
exam

## filter 함수 사용

exam %>% filter(class == 1)

exam %>% filter(class == 2)

exam %>% filter(math > 50)

exam %>% filter(math < 50)

exam %>% filter(english >= 80)

exam %>% filter(english <= 80)

exam %>% filter(class == 1 & math >= 50)

exam %>% filter(class ==2 & english >= 80)

exam %>% filter(math >= 90 | english >= 90)

exam %>% filter(english < 90 | science < 50)

exam %>% filter(class == 1 | class == 3 | class == 5)

## select를 통해 필요한 변수만 추출

exam %>% select(english)

exam %>% select(class, math, english)

exam %>% select(-math)

exam %>% select(-math, -english)

exam %>% filter(class == 1) %>% select(english)

exam %>%
  filter(class == 1) %>%
  select(english)


exam %>%
  select(id, math) %>%
  head

# 순서대로 정렬하기

exam %>% arrange(math)

exam %>% arrange(desc(math))

# 파생변수 만들기

exam %>%
  mutate(total = math + english + science) %>%
  head

exam %>%
  mutate(total = math + english + science,
         mean = (math + english + science)/3) %>%
  head

exam %>%
  mutate(test = ifelse(science >= 60, "pass", "fail")) %>%
  head

exam %>% summarise(mean_math = mean(math))

## 집단별로 요약하기

exam %>%
  group_by(class) %>%
  summarise(mean_math = mean(math))

exam %>%
  group_by(class) %>%
  summarise(mean_math = mean(math),
            sum_math = mean(math),
            median_math = median(math),
            n = n())

install.packages("ggplot2")
library(ggplot2)
library(dplyr)



mpg %>% group_by(manufacturer, drv) %>% summarise(mean_cty = mean(cty)) %>% head(10)


## 산점도 만들기

# x축은 displ, y축은 hwy로 지정해 배경 생성
ggplot(data = mpg, aes(x=displ, y=hwy)) +
  geom_point() +
  xlim(3, 6) +
  ylim(10, 30)


## 막대그래프 만들기

library(dplyr)

df_mpg <- mpg %>%
  group_by(drv) %>%
  summarise(mean_hwy = mean(hwy))

df_mpg


# 막대그래프

ggplot(data = df_mpg, aes(x = drv, y = mean_hwy)) + geom_col()

ggplot(data = df_mpg, aes(x = reorder(drv, -mean_hwy), y = mean_hwy)) + geom_col()

# 빈도 막대 그래프

ggplot(data = mpg, aes(x=drv)) + geom_bar()

ggplot(data = mpg, aes(x=hwy)) + geom_bar()

# 시계열

ggplot(data = economics, aes(x = date, y = unemploy)) + geom_line()

# 상자 그림

ggplot(data = mpg, aes(x=drv, y=hwy)) + geom_boxplot()


