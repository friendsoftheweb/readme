desc "Check that a Redis server is available, or fail."
task :redis_check do
  puts "Checking if Redis is running: PING"
  system("redis-cli ping")
  if $?.to_i != 0
    puts("Redis is not running.")
    exit 1
  end
end
