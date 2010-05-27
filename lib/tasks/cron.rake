task :cron => :environment do
  Artist.post_random_snippets if Time.now.hour % 4 == 0 # run every four hours
end

