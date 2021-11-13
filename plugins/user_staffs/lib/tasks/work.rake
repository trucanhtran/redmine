namespace :work do
  desc "import name to work"
  task importdb: :environment do
    works = ["Nghỉ tạm - thai sản", "Nghỉ tạm - không lương", "Nghỉ việc - gia đình", "Nghỉ việc - vì học tiếp", "Nghỉ việc - định hướng mới", "Nghỉ việc - do thanh lý"]
    Work.destroy_all
    works.each do |work|
      Work.create(status: work)
      p "Create #{work}"
    end
  end
end

