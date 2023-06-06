# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: ```3.2.0```

* Database creation
``` 
All Models:
* Users: For storing user's Name, Email and Currency Preference
* Doctors: For storing Doctor's Name, Photo, Address and details.
* Appointments: For storing the details of appointments such as user_id, doctor_id, start time, end time and all.

Model Architecture: 
- Doctor has many Appointements
- User has many Appointments
- Appointment belongs to Doctor and User
```

* Database initialization
```
rails db:migrate
rails db:seed
```

* Deployment instructions
```angular2html
bundle install
< Database Initialization >
bin/dev
```

