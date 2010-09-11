class CountryLanguage < Struct.new(:code, :name)

  @@country_languages = {}

  def self.country_languages
    @@country_languages
  end

  def self.setup_languages
    File.open("#{Rails.root}/data/LanguageIndex.tab") do |f|
      f.each_line do |line|
        line.force_encoding('ISO-8859-1')
        next if line =~ /^LangID/
        code, country_code, name_type, name = line.strip.split("\t")
        @@country_languages[country_code] ||= {}
        @@country_languages[country_code][code] = name
      end
    end
  end

  setup_languages

  def self.find_by_country_code_and_code(country_code, code)
    new(code, "#{@@country_languages[country_code][code]} (#{code})")
  end

  def self.find_all_by_country_code(country_code)
    results = []
    return results unless @@country_languages[country_code]
    @@country_languages[country_code].keys.each do |code|
      results << find_by_country_code_and_code(country_code, code)
    end
    results
  end

end
