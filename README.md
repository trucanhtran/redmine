## How to run

### Step1:

`docker-compose build` #build docker-compose

### Step2:

`docker-compose run website bundle install` #cài đặt thư viện của Rails

### Step3:

`docker-compose run website bin/rake db:create` #Khởi tạo database


### Step4:

`docker-compose run website bin/rake db:migrate` #Chạy migration để tạo dữ liệu bảng và cột



### Step5:

`docker-compose run wesbite bin/rails redmine:load_default_data` #Tạo các dữ liệu mặc định

### Step6:

`docker-compose up` #Mở các container để khởi chạy website

### Step7:

`localhost:3000`

