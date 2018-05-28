library(plumber)

serve_model <- plumb("apis/keras-mnist-api.R")
serve_model$run(port = 8000, host='0.0.0.0')

