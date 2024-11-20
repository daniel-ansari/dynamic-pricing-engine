namespace :import do
  desc "Import Inventory"
  task inventory_csv: :environment do
    file = Rails.root.join("spec", "fixtures", "files", "inventory.csv")

    if File.exist?(file)
      total_records = ImportInventory.import(file)

      puts "[#{total_records[:total]}/#{total_records[:succeeded]}] records successfully imported."
    else
      puts "CSV file not found at #{file}."
    end
  end
end
