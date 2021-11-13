namespace :contract do
  desc "import name to contract"
  task importdb: :environment do
    contracts = ["HD Thử việc", "HĐLĐ xác định thời hạn 12 tháng", "HĐLĐ XĐTH trên 12T đến 36T", "HĐLĐ Không xác định thời hạn", "HĐ Thực tập"]
    Contract.destroy_all
    contracts.each do |contract|
      Contract.create(name: contract)
      p "Create #{contract}"
    end
  end
end

