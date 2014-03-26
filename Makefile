week = 1
build/week$(WEEK).pdf: week$(WEEK).tex
	latexmk -pdf -outdir=build week1

cont:
	latexmk -pdf -outdir=build -pvc -view=none -interaction=nonstopmode week$(WEEK)
