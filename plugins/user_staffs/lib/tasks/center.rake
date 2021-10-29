namespace :center do
  desc "import name to center"
  task importdb: :environment do
    centers = ["ISC", "FOXPAY", "FTQ", "INF", "NOC", "PAYTV", "SCC"]
    Center.destroy_all
    centers.each do |center|
      Center.create(name: center)
      p "Create #{center}"
    end
  end
end

