#!/usr/bin/env ruby

require 'roo'
require 'gruff'
require 'descriptive_statistics'

# Définir le chemin vers le fichier Excel
file_path = '/home/mikayakouta/joupify/twitter/bin/red.xlsx'

# Définir le dossier de destination des graphiques
output_folder = File.join(File.dirname(file_path), 'graphs')
Dir.mkdir(output_folder) unless Dir.exist?(output_folder)

# Méthode pour extraire les données d'une feuille
def extract_data(sheet, data_column_index, limit = 5)
  data = []
  (2..sheet.last_row).each do |row_number|
    cell_value = sheet.cell(row_number, data_column_index)
    # Vérifier si la valeur est numérique et non nulle
    data << cell_value.to_f if cell_value.is_a?(Numeric)
  end
  data
end

# Méthode pour générer un histogramme
def generate_histogram(title, data1, data2, output_path)
  g = Gruff::Histogram.new
  g.title = title

  # Supprimer les valeurs nil ou NaN des données
  data1 = data1.compact.reject { |x| x.nil? || x.nan? }
  data2 = data2.compact.reject { |x| x.nil? || x.nan? }

  g.data "Location 1", data1
  g.data "Location 2", data2
  g.write(output_path)
end

# Charger le fichier Excel
begin
  xlsx = Roo::Excelx.new(file_path)

  # Définir les paramètres pour chaque feuille
  sheets_config = {
    'velocity' => {
      eastward: { column1: 2, column2: 4, title: 'Eastward Velocity' },
      northward: { column1: 3, column2: 5, title: 'Northward Velocity' }
    },
    'wave height' => {
      height: { column1: 2, column2: 4, title: 'Wave Height' }
    },
    'salinity' => {
      salinity: { column1: 2, column2: 4, title: 'Salinity' }
    },
    'Temperature' => {
      temperature: { column1: 2, column2: 4, title: 'Temperature' }
    }
  }

  # Itérer sur chaque feuille et générer les graphiques
  sheets_config.each do |sheet_name, params|
    sheet = xlsx.sheet(sheet_name)

    params.each do |param_name, config|
      data1 = extract_data(sheet, config[:column1])
      data2 = extract_data(sheet, config[:column2])

      output_path = File.join(output_folder, "#{sheet_name}_#{param_name}.png")
      generate_histogram(config[:title], data1, data2, output_path)

      puts "Histogram generated for #{config[:title]} and saved to #{output_path}"
    end
  end

  puts "Tous les graphiques ont été générés avec succès dans le dossier : #{output_folder}"

rescue => e
  puts "Erreur lors de la génération des graphiques : #{e.message}"
  puts e.backtrace.join("\n")
end
