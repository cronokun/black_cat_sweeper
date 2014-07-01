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

# Setup logger
@logger = Logger.new(STDOUT)
@logger.level = Logger::INFO

def write_csv_file(file, data)
  CSV.open(file, 'wb') do |csv|
    csv << @header
    data.each { |record| csv << record.to_csv }
  end
end

def sweep(message, file)
  raise ArgumentError, 'Block must be provided!' unless block_given?
  @logger.info message
  invalid_data = yield

  if invalid_data.empty?
    @logger.info 'Nothing found.'
  else
    @logger.info "#{invalid_data.size} #{invalid_data.size == 1 ? 'record' : 'records'} found!"
    write_csv_file(file, invalid_data)
  end
end


if $0 == __FILE__

  # Read data from CSV file
  input_data = CSV.read(INPUT_FILE)
  @logger.info "#{input_data.size} lines read."
  @header = input_data.shift

  input_data.map! { |row| Sweeper::Record.create_from_csv(row) }

  # Removing empty rows
  sweep 'Looking for empty rows', EMPTY_ROWS_FILE do
    Sweeper::EmptyFilter.new(input_data).filter!
  end

  # Remove rubbish/test data
  sweep 'Looking for test/rubbish data', RUBBISH_FILE do
    Sweeper::RubbishFilter.new(input_data).filter!
  end

  # Remove duplicates
  sweep 'Remove duplicating rows', DUPLICATIONS_FILE do
    Sweeper::DuplicationsFilter.new(input_data).filter!
  end
end
