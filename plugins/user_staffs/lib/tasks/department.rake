namespace :center do
  desc "import name to center"
  task importdb: :environment do
    centers = []
    (1..10).each do |index|
      centers << ("SU" << index.to_s)
    end
    p centers
    center.destroy_all
    centers.each do |center|
      center.create(name: center)
      p "Create #{center}"
    end
  end
end

