require 'json'
require 'csv'
require 'optparse'

def convert(file, options)
  row_count, rows, headers = 0, [], []
  CSV.foreach(file) do |row|
    if options[:use_headers]
      if row_count == 0
        headers = row
        row_count += 1
        next
      end
    end
    rows << row
    row_count += 1
  end
  
  puts "Number of rows: #{rows.length} #{file}"
  
  if options[:use_headers]
    output = []
    rows.each do |row|
      item = {}
      headers.size.times { |i| item[ headers[i] ] = row[i] }
      output << item
    end
    return output.to_json
  else
    return rows.to_json
  end
  
end

options = {:conversions => []}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby csv2json.rb [options]"
  opts.on('-h', '--headers'){|v| options[:use_headers] = v}
end
parser.order(ARGV) do |file|
  options[:conversions] << file.split(':')
end

options[:conversions].each do |from, to|
  puts "Converting #{from} to #{to}"
  json_data = convert(from, options)
  fp = File.open(to, 'w+')
  fp.write(json_data)
  fp.close
end