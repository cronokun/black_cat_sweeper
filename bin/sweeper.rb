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

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

# Read data from CSV file
input_data = CSV.read(INPUT_FILE)
header = input_data.shift
logger.info "#{input_data.size} lines read."

input_data.map! { |row| Sweeper::Record.create_from_csv(row) }

# Removing empty rows
logger.info "Looking for empty rows..."
empty = Sweeper::Empty.new(input_data).remove!
logger.info "#{empty.size} records found!"

CSV.open(REMOVED_ROWS_FILE, 'wb') do |csv|
  csv << header
  empty.each { |record| csv << record.to_csv }
end

# duplications = Sweeper::Duplications.new(input_data).remove!
