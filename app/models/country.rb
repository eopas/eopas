require 'iconv'

class Country < Struct.new(:code, :name)

  def self.setup_countries
    data = File.open("#{Rails.root}/data/CountryCodes.tab", "rb").read
    data = Iconv.iconv('UTF8', 'ISO-8859-1', data).first.force_encoding('UTF-8')

    countries = {}
    data.each_line do |line|
      next if line =~ /^CountryID/
      code, name, area = line.split("\t")
      countries[code] = name
    end

    countries
  end

  COUNTRIES = setup_countries

  def self.find(code)
    new(code, "#{COUNTRIES[code]}")
  end

  def self.all
    results = []
    COUNTRIES.each do |code, name|
      results << new(code, name)
    end
    results
  end
end
