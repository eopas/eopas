class Country < Struct.new(:code, :name)

  def self.setup_countries
    countries = {}
    File.open("#{Rails.root}/data/CountryCodes.tab") do |f|
      f.each_line do |line|
        line.force_encoding('ISO-8859-1')
        next if line =~ /^CountryID/
        code, name, area = line.split("\t")
        countries[code] = name
      end
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
