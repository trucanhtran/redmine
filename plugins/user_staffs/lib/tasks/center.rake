namespace :center do
  desc "import name to center"
  task importdb: :environment do
    centers = ["ISC", "FOXPAY", "FTQ", "INF", "NOC", "PAYTV", "SCC"]
    Center.destroy_all
    centers.each do |center|
      Center.create(name: center)
      p "Create #{center}"
    end
    locations = Province.where(code: ["1", "79"])
    locations.each do |location|
      p location
      Location.create(province_id: location.id)
    end
  end
end

