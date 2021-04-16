
# R Ladies 
# 25 Mart 2021
# (.)Apply Fonksiyonları ve Kullanım Şekilleri

# Veri Linki: https://dataverse.harvard.edu/file.xhtml?persistentId=doi:10.7910/DVN/HG7NV7/EIR0RA&version=1.0

library(dplyr)
mydata <- read.csv("2008.csv")
head(mydata)
dim(mydata)

# Numerik olan değişkenleri alalım,
# dplyr kullanarak da yapabiliriz: 
datanow2 <-mydata %>% dplyr::select(where(is.numeric))
dim(datanow2)

# Aynı işlemi apply ile yapmaya kalkarsanız, tüm kolonları aynı tip değişkene yani karaktere çevirecektir:
apply(mydata, 2, is.numeric)

# sapply deneyelim:
sapply(mydata, is.numeric)
sapply(mydata, is.numeric, simplify = FALSE)

datanow <- mydata[,sapply(mydata, is.numeric)]

# dplyr ve sapply sonuçları aynı mı:
all.equal(datanow, datanow2)

# Tüm numerik değişkenlerin ortalama değerini alalım: 
apply(datanow, 2, mean, na.rm=TRUE)

# Aynı işlemi for loop ile yapalım: 
for (i in 1:dim(datanow)[2]) {
  result[i] <- mean(datanow[,i], na.rm = TRUE)
}

# Çalışmadı, result ı tanımlayalım: 
result <- NULL
for (i in 1:dim(datanow)[2]) {
  result[i] <- mean(datanow[,i], na.rm = TRUE)
}
result

# İsimleri ekleyelim: 
names(result) <- colnames(datanow)
result

# İşlemi değiştirelim, ortalama yerine yüzdelikleri hesaplatmak isteyelim:
apply(datanow, 2, quantile, na.rm = TRUE)

# Bu sefer biliyoruz ki for loop için önceden bir result tanımlamalıyız:
result2 <- NULL
for (i in 1:dim(datanow)[2]) {
  result2[i] <- quantile(datanow[,i], na.rm = TRUE)
}
result2

# İstediğimiz sonuç değil, çünkü boyutlar eşleşmedi. Artık sonuç bir vektör değil. 

# result3 tanımlayalım:
result3 <- matrix(NA, 5, dim(datanow)[2])

for (i in 1:dim(datanow)[2]) {
  result3[,i] <- quantile(datanow[,i], na.rm = TRUE)
}
result3
colnames(result3) <- colnames(datanow)
result3

# Tek satır olmasını tercih ederim:

sapply(datanow,quantile, na.rm = TRUE)

system.time(apply(datanow,2, quantile, na.rm = TRUE))
system.time(sapply(datanow,quantile, na.rm = TRUE))

# lapply

exL <- lapply(mydata, is.numeric)
exL
simplify2array(exL)
class(exL)

sapply(mylist, mean)

sapply(mylist, mean, simplify = F)

lapply(mylist, mean)

# Biraz çemberin dışına çıkalım:

sapply(1:10, function(x) x^2)
lapply(1:10, function(x) x^2)

mylist <- list()
mylist[[1]] <- 1:30
mylist[[2]] <- 1000:1050
mylist

# Kendinize dosyalar oluşturun:

files <- lapply(1:10, function(x){paste0("Dosyam", x, ".csv")}) 
unlist(files)

# Her biri farklı bir bağımsız değişkenle bir işlevi birden çok kez değerlendirmek 
# için lapply () öğesini kullanabilirsiniz:

x <- 1:4 
lapply(x, runif)

# tapply()

# Kalkış noktalarını görelim: 

table(mydata$Origin) %>% 
  as.data.frame() %>% 
  arrange(desc(Freq))

# Kalkış noktasına ve kuyruk numarasına göre ortalama rötarı hesaplayalım:

delaymean <- tapply(mydata$DepDelay, mydata$Origin, mean, na.rm=T) 
head(delaymean, 20)

delaymean2 <- tapply(mydata$DepDelay, mydata$TailNum, mean, na.rm=T) 
head(delaymean2, 20)

# Bunları birden fazla değişken için hesaplayabiliyoruz. 
# Örneğin, hem kalkış hem de varış noktası için kalkış 
# gecikmesini hesaplayalım.

results <- tapply(mydata$DepDelay, list(mydata$Origin,mydata$Dest), mean, na.rm=T)

# Sonucu İndiana'dan Chicago'ya giden uçuş için görelim:

results["IND","ORD"] 

results[c("IND","ORD","CVG","MDW"),c("IND","ORD","CVG","MDW")]

# Mapply()

v1 <- c(10, 20, 30, 40)
v2 <- c(1000, 2000, 4000, 7000) 
myfunc <- function(x,y) { x + y } 
mapply(myfunc, v1, v2)
mapply(quantile, v1, v2)

# Her bir v1 elemanını her bir v2 elemanı ile toplamak isterseniz:
sapply(v1, myfunc, v2)

M <- mapply(rep, 1:8, 4) 
M

sapply(1:8, rep, 4)
lapply(1:8, rep, 4)

M2 <- mapply(rep,1:8,4, SIMPLIFY = F)
M2

mapply(rep, 1:4, 4:1)

mapply(rep, times = 1:4, MoreArgs = list(x = "RLadies"))

# Farklı ortalama ve stadard sapma değerleri için
# standard normal dağılımdan rassal değişkenler üretelim:

hitme <- function(n, mean, sd) {rnorm(n, mean, sd)}

# Önce 1, sonra 2,... en son 5 tane değişken üretmek istiyorum:

hitme(1:5, 1:5, 2)

mapply(hitme, 1:5, 1:5, 2)

# FGY


