TARGET := trombi_acdi.pdf
SOURCE := trombi_acdi.tex
COMPILER := xelatex

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(COMPILER) $(SOURCE)

clean:
	rm -f *.out *.aux *.log
