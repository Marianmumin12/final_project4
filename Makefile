# Rule to build the final report	
final_project2.html: final_project2.Rmd output/table1.rds output/Figure1.rds \
output/Figure2.rds
	Rscript -e 'rmarkdown::render("final_project2.Rmd")'
	
	
# Rule to create the table
output/table1.rds: code/table1.R
	Rscript code/table1.R

# Rule to create the figure1 
output/Figure1.rds: code/Figure1.R
	Rscript code/Figure1.R

# Rule to create the figure1 
output/Figure2.rds: code/Figure2.R
	Rscript code/Figure2.R
	
.PHONY: clean

clean:
	rm -f output/*.rds && rm -rf report/
	
#docker 
IMAGE = marianmumin12/final_project2-image

run:	
	mkdir -p report 
	docker run --rm \
	-v "$$(pwd)/report:/home/rstudio/project/report" \
	$(IMAGE)
	
install:
	Rscript -e "renv::restore(prompt = FALSE)"