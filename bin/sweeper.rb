#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), '/../lib' )
require 'sweeper'
require 'csv'
require 'logger'

# Workflow:
#
# 1. Get data from input file (it's CSV file for now)
# 2. Remove duplications
# 3. Remove empty/not-valid rows
# 4. Remove rubbish data
#
# All invalid data goes to separate CSV files

INPUT_FILE = 'data/Revised Listing_25k.csv'
VALID_FILE = 'data/valid_data.csv'
DUPLICATIONS_FILE = 'data/duplications_data.csv'
RUBBISH_FILE = 'data/rubbish_data.csv'
SUSPICIOUS_FILE = 'data/suspicious_data.csv'
EMPTY_ROWS_FILE = 'data/empty_rows.csv'

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
    result = EmptyFilter.new(input_data).filter!
    input_data = result[:valid_records]
    result
  end

  # Remove rubbish data
  sweep 'Looking for rubbish data', RUBBISH_FILE do
    result = RubbishFilter.new(input_data).filter!
    input_data = result[:valid_records]
    result
  end

  # Remove duplicates
  sweep 'Looking for duplicating rows', DUPLICATIONS_FILE do
    result = DuplicationsFilter.new(input_data).filter!
    input_data = result[:valid_records]
    result
  end

  # Remove suspicious data
  sweep 'Looking for suspicious data', SUSPICIOUS_FILE do
    result = SuspiciousFilter.new(input_data).filter!
    input_data = result[:valid_records]
    result
  end

  @logger.info "#{input_data.size} records remain."
  write_csv_file(VALID_FILE, input_data)
end
