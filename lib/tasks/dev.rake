namespace(:dev) do
  desc "Hydrate the database with some dummy data to look at so that developing is easier"
  task({ :prime => :environment}) do
      starting = Time.now

      if Rails.env.production?
        ActiveRecord::Base.connection.tables.each do |t|
          ActiveRecord::Base.connection.reset_pk_sequence!(t)
        end
      end

      User.delete_all
      Course.delete_all
      Schedule.delete_all
      FollowRequest.delete_all

      users = [
        {id: 81, email: "galen@example.com", username: "galen", private: false, created_at: "2015-01-19 09:24:34", updated_at: "2019-10-08 10:25:00"},
        {id: 82, email: "trina@example.com", username: "trina", private: false, created_at: "2014-09-02 06:05:56", updated_at: "2019-10-08 10:25:00"},
        {id: 83, email: "tyree@example.com", username: "tyree", private: true, created_at: "2017-06-23 22:31:32", updated_at: "2019-10-08 10:25:00"},
        {id: 84, email: "sharilyn@example.com", username: "sharilyn", private: true, created_at: "2014-09-23 01:03:23", updated_at: "2019-10-08 10:25:00"},
        {id: 85, email: "dustin@example.com", username: "dustin", private: true, created_at: "2014-09-23 01:03:23", updated_at: "2019-10-08 10:25:00"},
      ]
      User.insert_all!(users)

      if User.method_defined?(:password) || User.has_attribute?(:password_digest)
        User.all.each do |user|
          user.password = "password"
          user.save
        end
        # puts "Found a password column. Added passwords."
      else
        # puts "No password column found. Didn't add passwords."
      end

      follow_requests = [
        {id: 1608, sender_id: 83, recipient_id: 81, status: "accepted", created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 1609, sender_id: 81, recipient_id: 83, status: "pending", created_at: "2018-03-20 11:34:16", updated_at: "2019-10-08 10:25:00"},
        {id: 1610, sender_id: 82, recipient_id: 83, status: "accepted", created_at: "2018-01-28 00:37:26", updated_at: "2019-10-08 10:25:00"},
        {id: 1611, sender_id: 81, recipient_id: 84, status: "accepted", created_at: "2016-06-22 02:42:45", updated_at: "2019-10-08 10:25:00"},
      ]
      FollowRequest.insert_all!(follow_requests)

      courses = [
        {id: 1, currentcount: 4, description: "Calculus", maxcapacity: 4, name: "MATH 15200", professor:"Josh Shea", created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 2, currentcount: 4, description: "Philosophical Perspectives", maxcapacity: 5, name: "HUMA 12100", professor:"Raul Neto", created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 3, currentcount: 3, description: "Chemistry II", maxcapacity: 4, name: "CHEM 13100", professor:"Joe Goldberg", created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 4, currentcount: 3, description: "Machine Learning", maxcapacity: 5, name: "TTIC 31020", professor:"Kevin Gimpel", created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 5, currentcount: 1, description: "Text and Performance", maxcapacity: 5, name: "TAPS 10100", professor:"Shade Murray", created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 6, currentcount: 0, description: "App Development", maxcapacity: 7, name: "BUSN 13500", professor:"Raghu Betina", created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"}      
      ]
      Course.insert_all!(courses)

      schedules = [
        {id: 1, owner_id: 81, course1: 1, course2: 2, course3: 3, course4: 4, created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 2, owner_id: 82, course1: 1, course2: 2, course3: 3, course4: 4, created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 3, owner_id: 83, course1: 1, course2: 2, course3: 3, course4: nil, created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 4, owner_id: 84, course1: 1, course2: 2, course3: nil, course4: 4, created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
        {id: 5, owner_id: 85, course1: 5, course2: nil, course3: nil, course4: nil, created_at: "2015-04-24 01:26:47", updated_at: "2019-10-08 10:25:00"},
      ]
      Schedule.insert_all!(schedules)

      ending = Time.now
      elapsed = ending - starting

      puts "#{elapsed.to_i} seconds elapsed."
      puts "Generated Dummy Data"
  end
end
