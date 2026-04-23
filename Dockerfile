FROM rocker/tidyverse:4.5.1 AS base

RUN apt-get update && apt-get install -y curl

RUN mkdir /home/rstudio/project 

WORKDIR /home/rstudio/project


RUN mkdir -p renv
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE=renv/.cache

ENV RENV_CONFIG_INSTALL_STAGED=FALSE
RUN Rscript -e "renv::restore(prompt = FALSE)"


###### DO NOT EDIT STAGE 1 BUILD LINES ABOVE ######


FROM rocker/tidyverse:4.5.1

RUN mkdir -p /home/rstudio/project 

RUN mkdir -p /home/rstudio/project/code \
  /home/rstudio/project/output
  
WORKDIR /home/rstudio/project 

COPY --from=base /home/rstudio/project .

COPY data/ data/
COPY code/ code/ 
COPY final_project2.Rmd final_project2.Rmd
COPY Makefile Makefile 

RUN mkdir -p report 
RUN apt-get update && apt-get install -y pandoc 

CMD ["make", "report"]