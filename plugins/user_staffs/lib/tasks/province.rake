require 'net/http'
namespace :province do
  desc "import db to province"
  task importdb: :environment do
    url = "https://provinces.open-api.vn/api/?depth=3"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    result = JSON.parse(data)
    result.each do |province|
      begin
        Province.find_or_create_by(
            name: province["name"],
            code: province["code"],
            code_name: province["codename"],
            phone_code: province["phone_code"],
          )
        puts "#{province["name"]}"
        province["districts"].each do |district|       
          District.find_or_create_by(
            name: district["name"],
            code: district["code"],
            code_name: district["codename"],
            phone_code: district["phone_code"],
          )
          puts "#{district["name"]}"

          district["wards"].each do |ward|       
            Ward.find_or_create_by(
              name: ward["name"],
              code: ward["code"],
              code_name: ward["codename"],
              phone_code: ward["phone_code"],
            )
            puts "#{ward["name"]}"
          end
        end
      rescue
        byebug
      end
    end
  end
end

