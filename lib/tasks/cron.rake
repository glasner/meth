task :cron => :environment do
  Artist.post_random_snippets
end