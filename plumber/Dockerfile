FROM rocker/r-base
MAINTAINER Sixphere <codelovers@sixphere.com>

RUN apt-get update -qq && apt-get install -y \
  git-core libssl-dev libcurl4-gnutls-dev libxml2-dev libpng-dev\
  python-pip python-virtualenv libpython2.7

RUN pip install virtualenv

RUN R -e 'install.packages(c("devtools"))'
RUN R -e 'install.packages(c("caret"))'
RUN R -e 'install.packages(c("klaR"))'
RUN R -e 'install.packages(c("tm"))'
RUN R -e 'install.packages(c("plumber"))'
RUN R -e 'install.packages(c("Rook"))'
RUN R -e 'install.packages(c("devtools"))'
RUN R -e 'devtools::install_github("rstudio/keras")'
RUN R -e "keras::install_keras()"

# add package kerasR
RUN install2.r --error \
    kerasR

EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000, swagger=TRUE)"]
CMD ["/usr/local/lib/R/site-library/plumber/examples/04-mean-sum/plumber.R"]
