$:.unshift File.dirname(__FILE__)

desc "Remove old characters"
task :clean do
  require 'character'
  Character.dm_setup
  Character.all(:updated_at.lt => 1.week.ago).each { |c| c.destroy }
end
