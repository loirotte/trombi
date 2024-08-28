#!/usr/bin/ruby -wU

require 'fileutils'
require 'rubyXL'
require 'rubyXL/convenience_methods'

$tex_deb = 'trombi_temp_deb.tex'
$tex_fin = 'trombi_temp_fin.tex'
$latex_file = 'trombi_acdi.tex'
$images_dir = 'images/'

$president = "Président"
$bureau = "Bureau"
$membres = "Membres"

$latex = ""

# Pour la capitalisation avancée (!)
def cap(str)
  str.gsub(/[\wçùéè]+/, &:capitalize)
end

# Extraction des informations

def extract_info(xlsx_file, onglet)
  workbook = RubyXL::Parser.parse(xlsx_file)
  worksheet = workbook[onglet]                # Choix onglet

  people = []

  # Extraction
  # ligne début = 0 (entête généralement)
  lig = 1
  parse_sheet = true

  while parse_sheet
    row = worksheet[lig]
    if row
      if !row[0]
        parse_sheet = false
      else
        infos = {
          nom: cap(row[0].value.strip),
          prenom: cap(row[1].value.strip),
          iut: cap(row[2].value.strip),
          act: (row[3].value.strip == "non")? false : true,
          mail: row[4].value.strip,
          photo: row[5].value.strip
        }
        people << infos
      end
    else
      parse_sheet = false
    end
    lig += 1
  end
  people
end

# Entête du document LaTeX

def latex_generate_deb
  $latex += IO.read($tex_deb)
end

# Génération de la date

def latex_generate_date(date)
  $latex += "\n\\centerline{\\emph{Version du #{date}}}\n"
  $latex += "\\doublespacing\n"
end

# Génération d'une section Latex

def latex_generate_section(titre, infos)
  $latex += "\n\n\\vspace*{5mm}\n\\section*{#{titre}}\n\n"

  infos.each do |i|
    $latex += "\n\\entry" +
              "{#{i[:prenom]}}" +
              "{#{i[:nom]}}" +
              "{#{i[:iut]}}" +
              "{#{' \protect\finMandat' if !i[:act]}}" +
              "{#{i[:mail]}}" +
              "{#{$images_dir}#{i[:photo]}}"
  end
end

# Footer du document LaTeX

def latex_generate_fin
  $latex += IO.read($tex_fin)
end

# Génération LaTeX

def latex_generate(file, date)
  latex_generate_deb
  latex_generate_date date
  latex_generate_section($president, extract_info(file, 0))
  latex_generate_section($bureau, extract_info(file, 1))
  latex_generate_section($membres, extract_info(file, 2))
  latex_generate_fin
end

# Création du fichier LaTeX et compilation

def dump_and_compile
  File.open($latex_file, "w") { |f| f << $latex }
  puts `make`
end

# #####################################
# P R O G R A M M E   P R I N C I P A L
# #####################################

if ARGV.length != 2
  puts "Usage: #{$0} <liste_xlsx> <date>"
  exit
end

latex_generate ARGV[0], ARGV[1]
dump_and_compile

