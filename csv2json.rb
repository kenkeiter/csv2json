require 'json'
require 'csv'
require 'optparse'
require 'pathname'

def convert(file, options)
  row_count, rows, headers = 0, [], []
  CSV.foreach(file) do |row|
    if row_count == 0 and options[:use_headers]
      row.delete_if{|field| field.nil? }
      headers = row
      row_count += 1
      next # skip adding the row as data
    end
    rows << row
    row_count += 1
  end
  
  if options[:use_headers] and options[:associative_rows]
    output = []
    rows.each do |row|
      item = {}
      headers.size.times { |i| item[ headers[i] ] = row[i] }
      output << item
    end
    return output.to_json # output objects with k=>v association
  else
    return rows.to_json # output an array of arrays (rows)
  end
  
end

options = {:conversions => []}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby csv2json.rb [options]"
  opts.on('-h', '--headers'){|v| options[:use_headers] = v}
  opts.on('-r', '--relational'){|v| options[:associative_rows] = v}
end
parser.order(ARGV) do |file|
  if File.directory?(file)
    file_set = Dir.glob(File.join(file, '*.csv'))
    dests = file_set.map do |path|
      "#{path}.json"
    end
    options[:conversions].concat file_set.zip(dests)
  else
    options[:conversions] << file.split(':')
  end
end

options[:conversions].each do |from, to|
  puts "Converting #{from} -> #{to}"
  json_data = convert(from, options)
  fp = File.open(to, 'w+')
  fp.write(json_data)
  fp.close
end