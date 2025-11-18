#!/usr/bin/ruby -wU
require 'fileutils'

dest = "/home/phil/cours/acdi-bureau/trombi"

FileUtils.cp('trombi.rb', dest)
FileUtils.cp('trombi_temp_deb.tex', dest)
FileUtils.cp('trombi_temp_fin.tex', dest)
FileUtils.cp('Makefile', dest)
