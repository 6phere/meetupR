FROM 6phr_plumber:1.0.0
MAINTAINER Sixphere <codelovers@sixphere.com>

COPY home/apis/mnist-api.R /app/model.R
COPY home/models/compiled /models/compiled
COPY home/resources /resources

CMD ["/app/model.R"]
