library(readxl)
library(flextable)
library(officer)
library(gmodels)

freq <- function(data, cols){
  index <- which(colnames(data) %in% cols)
  f <- data %>%
    dplyr::group_by_at(index) %>%
    dplyr::summarise(COUNT = n()) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(PERCENT = COUNT/sum(COUNT)) %>%
    dplyr::mutate(MEAN = dplyr::mean(COUNT)) %>%
    dplyr::arrange(desc(COUNT)) %>%
    dplyr::bind_rows(dplyr::bind_cols(dplyr::summarize_if(., is.numeric, sum)))

  as.data.frame(f)
}

# Lectura de los datos
data <- read_excel("dani/Datos.xlsx", sheet="Datos")
data <- data[data$Nombre != 'Porto Torrâo',]
#data <- data[data$Nombre != 'Leceia',]
set.seed(1234)

# Cálculo de las frecuencias
fNombre <- freq(data, c("Nombre"))
fPosicion <- freq(data, c("Posición"))
fTipo <- freq(data, c("Tipo"))
fDecoracion <- freq(data, c("Decoración"))
fContexto <- freq(data, c("Contexto"))

# Chí-cuadrado Posición
fPosicionChi <- fPosicion[-nrow(fPosicion),]
fPosicionChi$EXPECTED = 1/nrow(fPosicionChi)
chisq.test(x = fPosicionChi$COUNT, p = fPosicionChi$EXPECTED)

# Chí-cuadrado Tipo
fTipoChi <- fTipo[-nrow(fTipo),]
fTipoChi$EXPECTED = 1/nrow(fTipoChi)
chisq.test(x = fTipoChi$COUNT, p = fTipoChi$EXPECTED)

# Chí-cuadrado Decoración
fDecoracionChi <- fDecoracion[-nrow(fDecoracion),]
fDecoracionChi$EXPECTED = 1/nrow(fDecoracionChi)
chisq.test(x = fDecoracionChi$COUNT, p = fDecoracionChi$EXPECTED)

# Chí-cuadrado Contexto
fContextoChi <- fContexto[-nrow(fContexto),]
fContextoChi$EXPECTED = 1/nrow(fContextoChi)
chisq.test(x = fContextoChi$COUNT, p = fContextoChi$EXPECTED)

# Dependencia entre variables Posición y Tipo
boxplot(Posición ~ Tipo, data = data, ylab = "Posición del Registro")
xtabs(~Tipo+Posición,data)
corData <- mlr::createDummyFeatures(data$Tipo)
corData$Posición = data$Posición
Hmisc::rcorr(as.matrix(corData),type='spearman')

# Dependencia entre variables Posición y Decoración
boxplot(Posición ~ Decoración, data = data, ylab = "Posición del Registro")
xtabs(~Decoración+Posición,data)
corData <- mlr::createDummyFeatures(data$Decoración)
corData$Posición = data$Posición
Hmisc::rcorr(as.matrix(corData),type='spearman')

# Dependencia entre variables Posición y Contexto
boxplot(Posición ~ Contexto, data = data, ylab = "Posición del Registro")
xtabs(~Contexto+Posición,data)
corData <- mlr::createDummyFeatures(data$Contexto)
corData$Posición = data$Posición
Hmisc::rcorr(as.matrix(corData),type='spearman')

# ANALISIS TENIENDO EN CUENTA EL NÚMERO DE RECINTOS COMO PESO
# En este caso multiplicamos el valor de la variable por el número de recintos que tiene
# Así tomará más peso aquella pieza encontrada en el centro de un yacimiento con muchos recintos respecto a uno que tiene menos recintos
# Posición respecto del tipo
wData <- mlr::createDummyFeatures(data$Tipo) * data$Recintos
apply(as.matrix(wData),2,sum)
wData$Posición = data$Posición
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# Posición respecto del Decoración
wData <- mlr::createDummyFeatures(data$Decoración) * data$Recintos
apply(as.matrix(wData),2,sum)
wData$Posición = data$Posición
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# Posición respecto del Contexto
wData <- mlr::createDummyFeatures(data$Contexto) * data$Recintos
apply(as.matrix(wData),2,sum)
wData$Posición = data$Posición
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

#REPETIMOS EL ANÁLISIS PERO NORMALIZANDO RESPECTO AL NÚMERO DE REGISTROS
#En este caso dividimos la posicion del registro entre el númeor total de recintos de su yacimiento
#Así obtenemos para todos los registros un número entre 0 y 1.
#Posición respecto Tipo
wData <- mlr::createDummyFeatures(data$Tipo)
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

#Posición respecto Decoración
wData <- mlr::createDummyFeatures(data$Decoración)
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

#Posición respecto Contexto
wData <- mlr::createDummyFeatures(data$Contexto)
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

#REPETIMOS EL ANÁLISIS UNIENDO LOS DOS MÉTODOS ANTERIORES, ES DECIR, PESO Y NORMALIZACIÓN
#Posición respecto Tipo
wData <- mlr::createDummyFeatures(data$Tipo) * data$Recintos
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

#Posición respecto Decoración
wData <- mlr::createDummyFeatures(data$Decoración) * data$Recintos
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

#Posición respecto Contexto
wData <- mlr::createDummyFeatures(data$Contexto) * data$Recintos
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# ANALISIS TENIENDO EN CUENTA EL TAMAÑO DE CADA RECINTO COMO PESO INVERSO
# En este caso multiplicamos el valor de la variable por el tamaño del recinto al que pertenece
# Así tomará más peso aquella pieza encontrada en recintos grandes, frente a aquellas encontradas en recintos pequeños
# Posición respecto del tipo
wData <- mlr::createDummyFeatures(data$Tipo) * (1 / data$TamañoRecinto)
apply(as.matrix(wData),2,sum)
wData$Posición = data$Posición
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# Posición respecto del Decoración
wData <- mlr::createDummyFeatures(data$Decoración) * (1 / data$TamañoRecinto)
apply(as.matrix(wData),2,sum)
wData$Posición = data$Posición
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# Posición respecto del Contexto
wData <- mlr::createDummyFeatures(data$Contexto) * (1 / data$TamañoRecinto)
apply(as.matrix(wData),2,sum)
wData$Posición = data$Posición
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# ANALISIS TENIENDO EN CUENTA EL TAMAÑO DE CADA RECINTO COMO PESO Y LA NORMALIZACIÓN DE LA POSICIÓN
# Posición respecto del tipo
wData <- mlr::createDummyFeatures(data$Tipo) * (1 / data$TamañoRecinto)
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# Posición respecto del Decoración
wData <- mlr::createDummyFeatures(data$Decoración) * (1 / data$TamañoRecinto)
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# Posición respecto del Contexto
wData <- mlr::createDummyFeatures(data$Contexto) * (1 / data$TamañoRecinto)
wData$Posición = data$Posición / data$Recintos
wData$Recintos = data$Recintos
Hmisc::rcorr(as.matrix(wData),type='spearman')

# CORRELACIÓN ENTRE CAMPANIFORME Y TAMAÑO DEL RECINTO
data <- read_excel("dani/Datos.xlsx", sheet="Recintos")
wdata <- as.data.frame(data$TamañoRel)
wdata$TamañoRecinto <- data$TamañoRecinto
wdata$Campaniforme <- data$NCampaniforme
Hmisc::rcorr(as.matrix(wdata),type='spearman')








summary(table(data$Nombre,data$Tipo))
xtabs(~Nombre+Tipo+Contexto,data)
CrossTable(data$Nombre,data$Tipo)


datos_estudio = datos_originales[, -which(names(datos_originales) %in% c("Campaniforme dudoso", "En Estudio"))]
row.has.na = apply(datos_estudio, 1, function(x){any(is.na(x))})
datos_estudio_na = datos_estudio[row.has.na,]

mydata <- na.omit(datos_estudio)

fit = kmodes(mydata, 5)
plot(fit$cluster)
mydata = cbind(mydata, cluster = fit$cluster)

plot(as.factor(mydata$`Nombre`), mydata$cluster.category, col = mydata$cluster)
plot(as.factor(mydata$`Posición registro`), mydata$cluster.category, col = mydata$cluster)
plot(as.factor(mydata$`Complejo Decorativo`), mydata$cluster.category, col = mydata$cluster)
plot(as.factor(mydata$`Tipo recipiente`), mydata$cluster.category, col = mydata$cluster)
plot(as.factor(mydata$`Contexto hallazgo`), mydata$cluster.category, col = mydata$cluster)
plot(mydata$`Nº recintos campaniformes`, mydata$cluster.category, col = mydata$cluster)

mydata2 = datos_originales[datos_originales$`En Estudio` == 1, -which(names(datos_originales) %in% c("Campaniforme dudoso", "En Estudio"))]

fit2 = kmodes(mydata2, 3)
plot(fit2$cluster)
mydata2 = cbind(mydata2, cluster = fit2$cluster)
table(mydata2$cluster)

plot(as.factor(mydata2$cluster), col = c(1,2,3), xlab="Clusters", ylab="Nº Registros")
plot(as.factor(mydata2$`Nombre`), mydata2$cluster.category, col = mydata2$cluster)
legend("topright", inset=.02, title="Clusters", c("1","2","3"), fill=c("1","2","3"), horiz=TRUE)
plot(as.factor(mydata2$`Posición registro`), mydata2$cluster.category, col = mydata2$cluster)
legend("topleft", inset=.02, title="Clusters", c("1","2","3"), fill=c("1","2","3"), horiz=TRUE)
plot(as.factor(mydata2$`Complejo Decorativo`), mydata2$cluster.category, col = mydata2$cluster)
plot(as.factor(mydata2$`Tipo recipiente`), mydata2$cluster.category, col = mydata2$cluster)
plot(as.factor(mydata2$`Contexto hallazgo`), mydata2$cluster.category, col = mydata2$cluster)
plot(mydata2$`Nº recintos campaniformes`, mydata2$cluster.category, col = mydata2$cluster)

library("gmodels")
CrossTable(as.factor(mydata2$`Posición registro`), mydata2$cluster)
# Para 3 clusteres parece que la distribución de la clusterización es:
# Cluster 1 ==> Posición 1 con un 99,2
# Cluster 2 ==> Posiciones centrales, preferiblemente la 2 con un 56,8% y un 43,2% en la 1, pero nunca en la 3
# Cluster 3 ==> Tiene algunas posiciones en la 1 pero es sobre todo en la posición 3, con un 69,1%
# Encontes se podrían codificar como:
# Cluster 1 ==> Variable Posicion ==> 'Central'
# Cluster 2 ==> Variable Posicion ==> 'Media'
# Cluster 3 ==> Variable Posicion ==> 'Fuera'

mydata2$Posicion = NA
mydata2[mydata2$cluster == 1,]$Posicion = 'Central'
mydata2[mydata2$cluster == 2,]$Posicion = 'Media'
mydata2[mydata2$cluster == 3,]$Posicion = 'Fuera'

mydataCentral = mydata2[mydata2$Posicion == 'Central',]
mydataMedia = mydata2[mydata2$Posicion == 'Media',]
mydataFuera = mydata2[mydata2$Posicion == 'Fuera',]

library("ggplot2")
# Complejo Decorativo
ggplot(mydata2, aes(x=as.factor(`Complejo Decorativo`), group=Posicion, fill=Posicion)) +
#  geom_density(position="identity", alpha=0.5) +
  geom_histogram(stat="count") +
  scale_fill_discrete(name="Posición") +
  theme_bw() +
  xlab("Complejo Decorativo") +
  ylab("Densidad")

ggplot(mydata2, aes(x=as.factor(`Complejo Decorativo`), y=Posicion, group=Posicion, fill=Posicion)) +
  geom_count(aes(col=Posicion, size = stat(prop))) +
  scale_size_area(max_size = 25) +
  theme_bw() +
  xlab("Complejo Decorativo") +
  ylab("Densidad")

# Tipo Recipiente
ggplot(mydata2, aes(x=as.factor(`Tipo recipiente`), group=Posicion, fill=Posicion)) +
  #  geom_density(position="identity", alpha=0.5) +
  geom_histogram(stat="count") +
  scale_fill_discrete(name="Posición") +
  theme_bw() +
  xlab("Tipo recipiente") +
  ylab("Densidad")

ggplot(mydata2, aes(x=as.factor(`Tipo recipiente`), y=Posicion, group=Posicion, fill=Posicion)) +
  geom_count(aes(col=Posicion, size = stat(prop))) +
  scale_size_area(max_size = 25) +
  theme_bw() +
  xlab("Tipo recipiente") +
  ylab("Densidad")

#Contexto hallazgo
ggplot(mydata2, aes(x=as.factor(`Contexto hallazgo`), group=Posicion, fill=Posicion)) +
  #  geom_density(position="identity", alpha=0.5) +
  geom_histogram(stat="count") +
  scale_fill_discrete(name="Posición") +
  theme_bw() +
  xlab("Contexto hallazgo") +
  ylab("Densidad")

ggplot(mydata2, aes(x=as.factor(`Contexto hallazgo`), y=Posicion, group=Posicion, fill=Posicion)) +
  geom_count(aes(col=Posicion, size = stat(prop))) +
  scale_size_area(max_size = 25) +
  theme_bw() +
  xlab("Contexto hallazgo") +
  ylab("Densidad")

#Posición del registro
ggplot(mydata2, aes(x=as.factor(`Posición registro`), group=Posicion, fill=Posicion)) +
  #  geom_density(position="identity", alpha=0.5) +
  geom_histogram(stat="count") +
  scale_fill_discrete(name="Posición") +
  theme_bw() +
  xlab("Posición del Registro") +
  ylab("Densidad")

ggplot(mydata2, aes(x=as.factor(`Posición registro`), y=Posicion, group=Posicion, fill=Posicion)) +
  geom_count(aes(col=Posicion, size = stat(prop))) +
  scale_size_area(max_size = 25) +
  theme_bw() +
  xlab("Posición del Registro") +
  ylab("Densidad")
