# 1) 데이터의 요약값을 보고 NA값이 10000개 이상인 열을 제외하고 남은 변수 중 NA값이 있는 행을 제거
#    AUS 데이터의 Date 변수를 Date형으로 변환하고, 전처리가 완료된 weather AUS 데이터를
#    train(70%),test(30%)데이터로 분할

setwd('C:/ADP/data/')

AUS <- read.csv("weatherAUS.csv")
summary(AUS)

# 해석
# 먼저 read.csv 함수를 활용하여 AUS라는 데이터에 데이터를 저장한다.
# 그리고 summary 함수를 통해 NA값을 확인한 결과 Pressure9am,Pressure3pm,Cloud9am,Cloud3pm는
# NA's가 10000개 이상이므로 데이터에서 제외하였다.

AUS_1 <- subset(AUS,select=c(-Pressure9am,-Pressure3pm,-Cloud9am,-Cloud3pm))
summary(AUS_1)

# 해석
# 해당 변수들을 제외한 데이터를 AUS_1에 저장하고 summary를 확인한 결과 NA값이 10000개 이상인 값이
# 없음을 알 수 있다.


# 데이터 타입 변환 및 NA값 처리
AUS_1$Date<-as.Date(AUS_1$Date)
str(AUS_1)

AUS_1<-na.omit(AUS_1)
str(AUS_1)

# 해석
# Date 변수의 형태를 Date로 변경하기 위해 as.Date함수를 사용하여 변경하고
# Na값을 제거하기 위해 na.omit 함수를 사용했다.
# 그 결과 약 20,000개의 데이터가 삭제되었음을 확인할 수 있다.


# 데이터 분할
install.packages("caret")
library(caret)
set.seed(6789)
parts<-createDataPartition(AUS_1$RainTomorrow, p=0.7)
idx<-as.vector(parts[[1]])
train<-AUS_1[idx,]
test<-AUS_1[-idx,]
nrow(train)
nrow(test)

# 해석
# 데이터를 분할하기 위해서 caret패키지의 createDataPartition함수를 사용하여
# 데이터를 각각 70%, 30%씩 train,test로 분할하여 저장했다.


# 2) train 데이터로 종속변수인 RainTomorrow를 예측하는 분류모델을 3개 이상 생성하고,
#    test 데이터에 대한 예측값을 csv 파일로 각각 제출하시오.

# 분류분석을 하기 위해 bagging, boosting, randomforest 실시

install.packages("a(dabag")
library(adabag)
library(randomForest)

# 여러 변수 factor형 변환
# variableNames = c("gender", "bloodType", "religion")
# DF[ , variableNames] = lapply(DF[ , variableNames], factor)


train$RainTomorrow <- as.factor(train$RainTomorrow)


bg.model <- bagging(RainTomorrow~., data=train, mfinal=16, control=rpart.control(maxdepth=5,minsplit=16))
pred_bg<-predict(bg.model,test[,-17],type="prob")
pred_1<-data.frame(pred_bg$prob,RainTomorrow=pred_bg$class)
head(pred_1)
write.csv(pred_1,"bagging predict.csv")

# 해석
# bagging 분석을 adabag 패키지의 bagging 함수를 활용하여 최대 깊이(maxdepth)는 5로,
# 노드에서의 최소 분활 관측치(minsplit)는 15로, 사용할 나무의 개수는 15개로 설정하였다.
# 해당 결과와 test 데이터를 비교하여 예측값을 csv 파일로 출력하였다.

bs.model <- boosting(RainTomorrow~., data=train, boos=FALSE, mfinal=16, control=rpart.control(maxdepth=5,minsplit=16))
pred_bs<-predict(bs.model,test[,-17],typ="prob")
pred_2<-data.frame(pred_bs$prob,RainTomorrow=pred_bs$class)
head(pred_2)
write.csv(pred_2,"boosting predict.csv")

# 해석
# boosting 분석을 adabag 패키지의 boosting 함수를 활용하여 최대 깊이(maxdepth)는 5로,
# 노드에서의 최소 분할 관측치(minsplit)는 16로, 사용할 나무의 개수를 16개로 설정하였다,
# boos=FALSE는 모든 관측치에 동일한 가중치를 부여한다는 의미이며,
# TRUE는 부트스트래핑한 샘플에만 대해 가중치가 부여된다
# 해당 결과와 test 데이터를 비교하여 예측 값을 write.csv함수를 활용해 csv 파일로 출력하였다.

rf.model <- randomForest(RainTomorrow~., data=train)
print(rf.model)
pred_rf<-predict(rf.model,test[,-17],type="prob")
write.csv(pred_rf,"randomForest predict.csv")

# 해석
# 랜덤포레스트 분석을 randomForest패키지의 randomForest 함수를 활용하여 실시하였다.
# 생성된 모델을 보면 OBB estimate of error rate가 약 14%로 분류모델의 성능이 좋게 나타나진 않고 있으며,
# Confusion matrix의 class.error값이 높게 나타나 있음을 알 수 있다.
# 해당 결과와 test 데이터를 비교하여 예측값을 write.csv함수를 활용해 csv 파일로 출력하였다.


# 3) 생성된 3개의 분류모델에 대해 성과분석을 실시하여 정확도를 비교하여 설명하시오.
#    또, ROC curve를 그리고 AUC값을 산출하시오.

library(caret)
library(ROCR)
pred.bg<-predict(bg.model,test[,-17],type="class")

test$RainTomorrow <- as.factor(test$RainTomorrow)

confusionMatrix(data=as.factor(pred.bg$class), reference=test[,17],positive="No")
(
# 배깅
pred.bg.roc<-prediction(as.numeric(as.factor(pred.bg$class)),as.numeric(test[,17]))
plot(performance(pred.bg.roc,"tpr","fpr"))
abline(a=0,b=1,lty=2,col="black")
performance(pred.bg.roc,"auc")@y.values

# 해석
# bagging 분석 결과의 정확도는 약 83.8%로 나타나 정확도가 높아 성능이 좋아 보이지만,
# Specificity 값이 낮게 나타났다. 그리고 정확도는 좋지만 auc값은 67.2%이 좋게 나타나지 않았다.

# 부스팅
pred.bs <- predict(bs.model,test[,-17],type="class")
confusionMatrix(data=as.factor(pred.bs$class),reference=test[,17],positive="No")
pred.bs.roc<-prediction(as.numeric(as.factor(pred.bs$class)),as.numeric(test[,17]))
plot(performance(pred.bs.roc,"tpr","fpr"))                        
abline(a=0,b=1,lty=2,col="black")
performance(pred.bs.roc,"auc")@y.values

# 해석
# boosting 분석 결과의 정확도는 약 85%론 타나나 bagging보다 정확도가 높게 나타났지만,
# bagging과 동일하게 Specificity 값이 낮게 나타났다. auc값은 약 72%로 모델의 성능이 bagging 보다 좋게 나타났다.

# 랜덤포레스트
pred.rf<-predict(rf.model,test[,-17],type="class")
confusionMatrix(data=pred.rf, reference=test[,17],positive="No")

pred.rf.roc<-prediction(as.numeric(pred.rf),as.numeric(test[,17]))
plot(performance(pred.rf.roc,"tpr","fpr"))
abline(a=0,b=1,lty=2,col="black")
performance(pred.rf.roc,"auc")@y.values

# 해석
# randomforest 분석 결과의 정확도는 약 86%로 나타나 bagging, boosting보다 정확도가 높게 나타났고
# specificity값도 앞의 2가지 방법보다 높게 나타났다. auc값도 약 75%로 모델의 성능이 bagging, boosting
# 보다 좋게 나타났다, 데이터의 특성에 따라 정확도을 제외한 특이도, 민감도 등도 함께 파악하여
# 해당 데이터에 가장 적절한 분석 모형을 선택해야 한다.