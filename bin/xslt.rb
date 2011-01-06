#! /usr/bin/env ruby

# call this as: 
# rails runner bin/xslt.rb features/test_data/toolbox2.xml public/XSLT/fixToolbox.xsl

require "nokogiri"

# load correct XSLT
xsltname = ARGV[1]
xslt  = Nokogiri::XSLT(File.open(xsltname))
doc = Nokogiri::XML File.read(ARGV[0])
e_doc = xslt.transform(doc)
puts e_doc
