library(keras)

model.name <- 'keras-mnist-TEST'
model.version <- '1.0'

cat('\n=== Testing model building')
commandArgs <- function(trailingOnly) c(model.name,model.version)
source('models/definitions/keras-mnist.R')

cat('\n=== Testing model loading')
mnist <- dataset_mnist()
x_test <- mnist$test$x
y_test <- to_categorical(mnist$test$y, 10)

# reshape
x_test <- array_reshape(x_test, c(nrow(x_test), 784))
# rescale
x_test <- x_test / 255

model <- load_model_hdf5(paste0('models/compiled/',model.name,'-',model.version,'.hdf5'))
load_model_weights_hdf5(model,paste0('models/compiled/',model.name,'-',model.version,'-w.hdf5'))

cat('\n=== Plotting results')
library('tibble')
library('ggplot2')
acc = (model %>% evaluate(x_test, y_test))$acc %>% round(3)*100
y_pred = model %>% predict_classes(x_test)
y_real = y_test %>% apply(1,function(x){ return( which(x==1) - 1) })
results = tibble(y_real = y_real %>% factor, y_pred = y_pred %>% factor,Correct = ifelse(y_real == y_pred,"yes","no") %>% factor)
print(results %>%
  ggplot(aes(x = y_pred, y = y_real, colour = Correct)) +
  geom_point() +
  ggtitle(label = 'MNIST CNN', subtitle = paste0("Accuracy = ", acc,"%")) +
  xlab('Measured') +
  ylab('Predicted') +
  scale_color_manual(labels = c('No', 'Yes'),
                     values = c('tomato','cornflowerblue')) +
  geom_jitter() +
  theme_bw())

cat('\n=== Everything is OK')

library("stringr")
filter(as.data.frame(results),str_detect("Correct", "no"))

summary(results)

jander <- as.data.frame(results)

jander[jander$Correct == 'no',]

#583 708 116
mnist$test$y[116]
y_pred[116]
im <- mnist$test$x[116,,]
im <- t(apply(im, 2, rev))
image(1:28, 1:28, im, col=gray((0:255)/255))


png::writePNG(mnist$test$x[116,,]/255,target = '116.png')
img <- png::readPNG('116.png', native = FALSE, info = FALSE)
dim(im)

