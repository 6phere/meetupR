library(plumber)
library(readr)
library(keras)

model.name <- 'keras-mnist'
model.version <- '1.0'

#* @apiTitle keras-mnist-TEST
#* @apiDescription
#* @apiVersion model.version

#* @assets resources /static
list()

#* @get /healthcheck
health_check <- function() {

  result <- data.frame(
    "input" = "",
    "status" = 200,
    "model_version" = model.name
  )

  return(result)

}

#* @get /
#* @html
home <- function() {

  return(gsub('model.version',model.version,gsub('model.name',model.name,read_file('resources/index.html'))))

}

#* Number detection
#* @post /number
#* @response
#* @json
function(req){

  # Loading the model
  model <- load_model_hdf5(paste0('models/compiled/',model.name,'-',model.version,'.hdf5'))
  load_model_weights_hdf5(model,paste0('models/compiled/',model.name,'-',model.version,'-w.hdf5'))

  # Loading the image from request
  formContents <- Rook::Multipart$parse(req)
  fileName <- formContents$files$tempfile[1]
  img <- image_load(fileName, grayscale = TRUE, target_size = c(28,28))
  img <- image_to_array(img)

  # Preparing the image
  img <- array_reshape(img, c(1, 784))

  # Returning the prediction
  list(predictions = model %>% predict_classes(img))

}
