# Regex goodness
ip_match = /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/
two_hundred = /\s2\d\d\s\d/
three_hundred = /\s3\d\d\s\d/
four_hundred = /\s4\d\d\s\d/

logs = File.readlines ARGV[0]

# First we check for param
if logs == nil?
  puts 'Pass a log file as argument!'
  exit
elsif logs.last.match?(ip_match) == false
  # Next check for at least one ip address because after all, this is a web log
  puts 'Log file must be a web log!'
  exit
end

# List variables for clarity
success = 0
redirect = 0
failure = 0
fail_uri = nil
failure_code = nil
ip_addresses = []
res_sizes = []

# Since our logs variable is an array, let's dive in!
logs.each do |line|
  res_sizes.push(line.match(/\b(\d*)\b\s"/)[0].to_i)
  line.scan(ip_match).each do |ip| ip_addresses.push(ip) end
  success += 1 if line.match?(two_hundred)
  redirect += 1 if line.match?(three_hundred)
  if line.match?(four_hundred)
    failure += 1
    fail_uri = line.match(/"(.*?)"/)
    failure_code = line.match(four_hundred).to_s.chop
  end
end

puts "Total IPs: #{ip_addresses.size}\n"
puts "Unique IPs: #{ip_addresses.uniq.size}\n"
puts "Success Codes: #{success}\n"
puts "Redirect Codes: #{redirect}\n"
puts "Failure Codes: #{failure}\n"
puts "Largest resource size in bytes: #{res_sizes.max}\n"
puts "Smallest resource size in bytes: #{res_sizes.min}\n"
puts "Average resource size in bytes: #{res_sizes.reduce(:+).to_f / res_sizes.size}\n"
puts "Failure URI: #{fail_uri} - #{failure_code.strip}" if fail_uri != nil?
