## How to run

### Step1:

`docker-compose build`

### Step2:

`docker-compose run redmine_web bundle install`

### Step3:

`docker-compose run redmine_web bin/rake db:create`


### Step4:

`docker-compose run redmine_web bin/rake db:migrate`



### Step5:

`docker-compose run redmine_web bin/rails redmine:load_default_data`

### Step6:

`docker-compose up`

### Step7:

`localhost:3000`

