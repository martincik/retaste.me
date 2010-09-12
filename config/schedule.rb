# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.hour do
  command 'bundle exec ar_sendmail --max-age 0 -o --batch-size 200 -c "/mnt/app/retaste.me/current" -e "production"'
end

every :sunday, :at => '7am' do # Use any day of the week or :weekend, :weekday
  runner "Report.generate_reports_for_current_week"
end
