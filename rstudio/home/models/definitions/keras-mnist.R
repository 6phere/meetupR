library(keras)

args <- commandArgs(trailingOnly = TRUE)
model.name <- if(!is.na(args[1])) args[1] else 'keras-mnist'
model.version <- if(!is.na(args[2])) args[2] else '1.0'

cat(paste0('\n=== Building model ', model.name, '-', model.version))

cat('\n=== Loading MNIST dataset')
mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y

cat('\n=== Reshaping input')
x_train <- array_reshape(x_train, c(nrow(x_train), 784))
x_test <- array_reshape(x_test, c(nrow(x_test), 784))

cat('\n=== Rescale values')
x_train <- x_train / 255
x_test <- x_test / 255

cat('\n=== Categorizing classes')
y_train <- to_categorical(y_train, 10)
y_test <- to_categorical(y_test, 10)

cat('\n=== Defining model')
model <- keras_model_sequential() 
model %>% 
  layer_dense(units = 256, activation = 'relu', input_shape = c(784)) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 10, activation = 'softmax')

cat('\n=== Compiling model')
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_rmsprop(),
  metrics = c('accuracy')
)

cat('\n=== Training model')
history <- model %>% fit(
  x_train, y_train, 
  epochs = 50, batch_size = 128, 
  validation_split = 0.2
)

cat('\n=== Evaluating model\n')
eval <- model %>% evaluate(x_test, y_test)
print(eval)

cat('\n=== Saving model')
save_model_hdf5(model,paste0('models/compiled/',model.name,'-',model.version,'.hdf5'))
save_model_weights_hdf5(model,paste0('models/compiled/',model.name,'-',model.version,'-w.hdf5'))

cat('\n=== Model saved')
