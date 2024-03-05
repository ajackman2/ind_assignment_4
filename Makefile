# author: Jordan Bourak & Tiffany Timbers
# date: 2021-11-22

all: report/count_report.html

results: results/horse_pop_plot_largest_sd.png \
	results/horse_pops_plot.png \
	results/horses_spread.csv \
	reports/qmd_example.html \
	reports/qmd_example.pdf \
	results/isles.dat \
	results/abyss.dat \
	results/last.dat \
	results/sierra.dat

dats: results/isles.dat \
	results/abyss.dat \
	results/last.dat \
	results/sierra.dat

figs: results/figure/isles.png \
	results/figure/abyss.png \
	results/figure/last.png \
	results/figure/sierra.png


# generate figures and objects for report
results/horse_pop_plot_largest_sd.png results/horse_pops_plot.png results/horses_spread.csv: source/generate_figures.R
	Rscript source/generate_figures.R --input_dir="data/00030067-eng.csv" \
		--out_dir="results"

# render quarto report in HTML and PDF
reports/qmd_example.html: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to html

reports/qmd_example.pdf: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to pdf

scripts/wordcount.py:

results/isles.dat: scripts/wordcount.py data/isles.txt
	python scripts/wordcount.py --input_file=data/isles.txt --output_file

results/abyss.dat: scripts/wordcount.py data/abyss.txt
	python scripts/wordcount.py --input_file=data/abyss.txt --output_file

results/last.dat: scripts/wordcount.py data/last.txt
	python scripts/wordcount.py --input_file=data/last.txt --output_file

results/sierra.dat: scripts/wordcount.py data/sierra.txt
	python scripts/wordcount.py --input_file=data/sierra.txt --output_file

results/isles.png: scripts/plotcount.py data/isles.dat
	python scripts/plotcount.py --input_file=data/isles.dat --output_file

# write the report
report/count_report.html: report/count_report.qmd figs

quarto render report/count_report.qmd
# clean
clean-dats :
	rm -rf results
	rm -rf reports/qmd_example.html \
		reports/qmd_example.pdf \
		reports/qmd_example_files

clean-figs :
	rm -f results/isles.dat
	rm -f results/figures/isles.png
	rm -f results/abyss.dat
	rm -f results/last.dat
	rm -f results/sierra.dat

clean-all : clean-dats clean-figs \
	rm -f reports/count_report.html
	rm -rf report/count_report.html
	rm -rf report/count_report_files
