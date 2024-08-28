TARGET := trombi_acdi.pdf
SOURCE := trombi_acdi
COMPILER := xelatex
INDEX_ENG := makeindex

all: $(TARGET)

$(TARGET): $(SOURCE).tex
	$(COMPILER) $(SOURCE).tex
	$(INDEX_ENG) $(SOURCE)
	$(COMPILER) $(SOURCE).tex

clean:
	rm -f *.out *.aux *.log
