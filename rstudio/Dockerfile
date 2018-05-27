FROM rocker/rstudio:latest
MAINTAINER Sixphere <codelovers@sixphere.com>

# install required packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install -y --no-install-recommends --no-install-suggests \
    curl unzip sudo netcat zlib1g-dev \
    python-pip python-virtualenv libpython2.7 libxml2-dev libpng-dev

RUN pip install virtualenv

# install additional packages
RUN R -e 'install.packages(c("gmodels"))'
RUN R -e 'install.packages(c("caret"))'
RUN R -e 'install.packages(c("e1071"))'
RUN R -e 'install.packages(c("plumber"))'
RUN R -e 'install.packages(c("class"))'
RUN R -e 'install.packages(c("xml2"))'
RUN R -e 'install.packages(c("tm"))'
RUN R -e 'install.packages(c("pdftools"))'
RUN R -e 'install.packages(c("SnowballC"))'
RUN R -e 'install.packages(c("wordcloud"))'
RUN R -e 'install.packages(c("klaR"))'
RUN R -e 'install.packages(c("pROC"))'
RUN R -e 'install.packages(c("tidyverse"))'
RUN R -e 'install.packages(c("Rook"))'
RUN R -e 'install.packages(c("devtools"))'
RUN R -e 'devtools::install_github("rstudio/keras")'
RUN R -e "keras::install_keras()"

# add package kerasR
RUN install2.r --error \
    kerasR

CMD ["/init"]
