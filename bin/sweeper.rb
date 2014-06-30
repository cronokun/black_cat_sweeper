#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), '/../lib' )
require 'sweeper'

# TODO:
#
# 1. Get data from input file (it's CSV file for now)
# 2. Remove duplications
# 3. Remove empty/not-valid rows
# 4. Remove rubbish data
#
# All invalid data goes to separate CSV files

INPUT_FILE = 'data/input_data.csv'
VALID_FILE = 'data/valid_data.csv'
DUPLICATIONS_FILE = 'data/duplications_data.csv'
RUBBISH_FILE = 'data/rubbish_data.csv'
REMOVED_ROWS_FILE = 'data/removed_rows.csv'

# Sweeper.remove_duplications!(input_data, duplications)
