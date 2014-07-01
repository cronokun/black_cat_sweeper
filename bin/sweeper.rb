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
REMOVED_ROWS_FILE = 'data/removed_rows.csv'

def write_csv_file(file, data)
  CSV.open(file, 'wb') do |csv|
    csv << HEADER
    data.each { |record| csv << record.to_csv }
  end
end

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

# Read data from CSV file
input_data = CSV.read(INPUT_FILE)
logger.info "#{input_data.size} lines read."
HEADER = input_data.shift

input_data.map! { |row| Sweeper::Record.create_from_csv(row) }

# Removing empty rows
logger.info "Looking for empty rows..."
empty = Sweeper::Empty.new(input_data).remove!
logger.info "#{empty.size} records found!"
write_csv_file(REMOVED_ROWS_FILE, empty)

# Remove rubbish/test data
logger.info "\nLooking for rubbish data..."
rubbish = Sweeper::Rubbish.new(input_data).remove!
logger.info "#{rubbish.size} records found!"
write_csv_file(RUBBISH_FILE, rubbish)
