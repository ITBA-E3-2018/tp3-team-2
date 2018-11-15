##################################################################
# Makefile for LaTeX
##################################################################

REPORT_FILE = ReportAssignment3
OTHER = *~ *.aux *.dvi *.toc *.bbl *.blg *.gz *.out *.thm *.ps *.idx *.ilg *.ind *.log *.fdb_latexmk *.fls

informe: $(REPORT_FILE).tex
	pdflatex $(REPORT_FILE).tex
	pdflatex $(REPORT_FILE).tex
	#latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf $(REPORT_FILE).tex
	rm -rf $(OTHER)
	clear
	echo Finished Compiling
