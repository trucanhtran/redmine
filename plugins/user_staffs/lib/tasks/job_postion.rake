namespace :job_position do
  desc "import name to job_position"
  task importdb: :environment do
    job_positions = ["Nhân viên", "Thực tập sinh", "Quản lý", "Trưởng phòng"]
    JobPosition.destroy_all
    job_positions.each do |job_position|
      JobPosition.create(name: job_position)
      p "Create #{job_position}"
    end
  end
end

