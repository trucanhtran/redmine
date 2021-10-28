require 'net/http'
namespace :province do
  desc "import db to province"
  task importdb: :environment do
    url = "https://provinces.open-api.vn/api/?depth=3"
    resp = Net::HTTP.get_response(URI.parse(url))
    data = resp.body
    result = JSON.parse(data)
    result.each do |province|
        Province.create(
            name: province["name"],
            code: province["code"],
            code_name: province["codename"],
            phone_code: province["phone_code"],
          )
        puts "#{province["name"]}"
    end
    end
  end

