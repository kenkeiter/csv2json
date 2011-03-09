#!/usr/bin/env ruby

require 'json'
require 'csv'

def csv_to_json(csv_data, options)
  row_count, rows, headers = 0, [], []
  
  CSV.parse(csv_data) do |row|
    if row_count == 0 and options[:use_headers]
      row.delete_if{|field| field.nil? } # remove empty columns
      headers = row
      row_count += 1
      next # skip adding the row as data
    end
    rows << row
    row_count += 1
  end
  
  # Return a simple array of arrays (rows) if not using headers/associateive.
  return rows.to_json unless options[:use_headers] and options[:associative_rows]
  
  output = []
  rows.each do |row|
    item = {}
    headers.size.times { |i| item[ headers[i] ] = row[i] }
    output << item
  end
  output.to_json # output objects with k=>v association
 
end


if $0 == __FILE__
  require 'optparse'
  
  options = {}
  parser = OptionParser.new do |opts|
    opts.banner = "Usage: ruby csv2json.rb [options]"
    opts.on('-h', '--headers'){|v| options[:use_headers] = v}
    opts.on('-r', '--relational'){|v| options[:associative_rows] = v}
  end
  
  # Parse unmarked options (files to convert)
  conversions = []
  parser.order(ARGV) do |filename|
    if File.exists? filename
      conversions << [filename, "#{filename}.json"]
    elsif filename.include? ':'
      conversions << filename.split(':')
    elsif matches = Dir.glob(filename)
      conversions.concat matches.map do |match|
        [match, "#{match}.json"]
      end
    end
  end
  
  conversions.each do |from, to|
    puts "Converting #{from} -> #{to}"
    begin
      File.open(from, 'r') do |source_fp|
        json_data = csv_to_json(source_fp.read, options)
        File.open(to, 'w+') do |dest_fp|
          dest_fp.write(json_data)
        end
      end
    rescue => e
      puts "Encountered an error processing #{from}:\n\t#{e.to_s}"
    end
  end
  
end

