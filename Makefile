TARGET := trombi_acdi.pdf
SOURCE := trombi_acdi.tex
COMPILET := xelatex

all: $(TARGET)

$(TARGET): $(SOURCE)
	$(COMPILER) $(SOURCE)

