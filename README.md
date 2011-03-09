csv2json
========

The name says it all! Converts valid CSV files to JSON quickly and relatively painlessly. It supports both simple row output (as an array of arrays), and object (k=>v) mappings when using headers (-h or --headers) and relational (-r or --relational) options.

Simply run the command with the flags you'd like (headers and relational are the only two for now) and provide as many filenames, from:to conversions, or patterns to convert!

Can also be required, and used for your own nefarious purposes.

Steal it, do whatever you want with it ;)

CLI Usage
---------
To convert an entire directory:
    ruby csv2json.rb /path/to/my/dir

To convert an entire directory of files with names matching a pattern:
    
    ruby csv2json.rb /path/to/dir/test_*.csv /path/to/more/{docs,tables}_*.csv

To convert a single file (outputs to original filename + .json):
    
    ruby csv2json.rb /path/to/my/file.csv

To convert a single file and specify an output file path:
    
    ruby csv2json.rb /path/to/file.csv:/path/to/output_file.json

*Note* that you can mix and match any of those, and specify as many as you want per run.

Library Usage
-------------
    require 'csv2json'
  
    json_data = csv_to_json 'csv,as,string', :use_headers => false, :associative_rows => false

