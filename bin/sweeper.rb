#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), '/../lib' )
require 'sweeper'
require 'csv'
require 'logger'

# TODO:
#
# 1. Get data from input file (it's CSV file for now)
# 2. Remove duplications
# 3. Remove empty/not-valid rows
# 4. Remove rubbish data
#
# All invalid data goes to separate CSV files

INPUT_FILE = 'data/Revised Listing_25k.csv' # 'data/input_data.csv'
VALID_FILE = 'data/valid_data.csv'
DUPLICATIONS_FILE = 'data/duplications_data.csv'
RUBBISH_FILE = 'data/rubbish_data.csv'
EMPTY_ROWS_FILE = 'data/removed_rows.csv'

include Sweeper

# Setup logger
@logger = Logger.new(STDOUT)
@logger.level = Logger::INFO
@logger.formatter = proc do |severity, datetime, progname, msg|
  "Sweeper (#{datetime}): #{msg}\n"
end

if $0 == __FILE__

  # Read data from CSV file
  input_data = CSV.read(INPUT_FILE)
  @logger.info "#{input_data.size} lines read.\n"
  @header = input_data.shift

  input_data.map! { |row| Record.create_from_csv(row) }

  # Removing empty rows
  sweep 'Looking for empty rows', EMPTY_ROWS_FILE do
    EmptyFilter.new(input_data).filter!
  end

  # Remove rubbish/test data
  sweep 'Looking for test/rubbish data', RUBBISH_FILE do
    RubbishFilter.new(input_data).filter!
  end

  # Remove duplicates
  sweep 'Remove duplicating rows', DUPLICATIONS_FILE do
    DuplicationsFilter.new(input_data).filter!
  end

  @logger.info "#{input_data.size} records remain."
  write_csv_file(VALID_FILE, input_data)
end
