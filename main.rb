# Regex goodness
ip_match = /[^:\s]\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/
imposter_ip = %r/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/
resource_size = /\b(\d*)\b\s"/
two_hundred = /\s2\d\d\s\d/
three_hundred = /\s3\d\d\s\d/
four_hundred = /\s4\d\d\s\d/
fail__uri = /"(.*?)"/

# First we check for args
abort('Pass a log file as argument!') if ARGV.first.nil?
logs = File.readlines(ARGV.first)

# Next check for at least one ip address because after all, this is a web log
abort('Log file must be a web log!') unless logs.last.match?(ip_match)

# List variables for clarity
success = 0
redirect = 0
failure = 0
failure_code = nil
failure_uri = []
ip_addresses = []
res_sizes = []


# Since our logs variable is an array, let's dive in!
logs.each do |line|
  line.scan(ip_match).each do |ip|
    # Some values look like ips so we'll skip those
    next if ip.match?(imposter_ip)
    ip_addresses.push(ip)
  end

  res_sizes.push(line.match(resource_size)[0].to_i)
  success += 1 if line.match?(two_hundred)
  redirect += 1 if line.match?(three_hundred)

  next unless line.match?(four_hundred)
  failure_uri.push(line.match(fail__uri))
  failure_code = line.match(four_hundred).to_s.chop
  failure += 1
end

puts "Total IPs: #{ip_addresses.size}\n"
puts "Unique IPs: #{ip_addresses.uniq.size}\n"
puts "Success Codes: #{success}\n"
puts "Redirect Codes: #{redirect}\n"
puts "Failure Codes: #{failure}\n"
puts "Largest resource size in bytes: #{res_sizes.max}\n"
puts "Smallest resource size in bytes: #{res_sizes.min}\n"
puts "Average resource size in bytes: #{res_sizes.reduce(:+).to_f / res_sizes.size}\n"
puts "Failure URI: #{failure_uri.first} - #{failure_code.strip}" if failure_uri.empty? == false
