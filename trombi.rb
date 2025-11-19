#!/usr/bin/ruby -wU

require 'fileutils'
require 'yaml'

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
              "{#{'\protect\finMandat' if !i[:actif]}}" +
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
  data = YAML.safe_load_file(file, symbolize_names: true)

  latex_generate_deb
  latex_generate_date date
  latex_generate_section($president, data[:president])
  latex_generate_section($bureau, data[:bureau])
  latex_generate_section($membres, data[:membres])
  latex_generate_fin
end

# Création du fichier LaTeX et compilation

def dump
  File.open($latex_file, "w") { |f| f << $latex }
end

# #####################################
# P R O G R A M M E   P R I N C I P A L
# #####################################

if ARGV.length != 2
  puts "Usage: #{$0} <liste_xlsx> <date>"
  exit
end

latex_generate ARGV[0], ARGV[1]
dump

