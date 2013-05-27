$:.unshift File.dirname(__FILE__)

desc "Remove old characters"
task :clean do
  require 'character'
  Character.dm_setup

  puts "Cleaning up old characters"
  Character.all(:updated_at.lt => 1.week.ago).each do |c|
  	puts c.char_path
  	c.destroy
  end
end
