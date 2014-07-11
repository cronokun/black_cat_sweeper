require 'sweeper/record'
require 'sweeper/filter'
require 'sweeper/duplications'
require 'sweeper/empty'
require 'sweeper/rubbish'
require 'sweeper/suspicious'

module Sweeper
  def write_csv_file(file, data, header = @header)
    CSV.open(file, 'wb') do |csv|
      csv << header
      data.each { |record| csv << record.to_csv }
    end
  end

  def sweep(message, file)
    raise ArgumentError, 'Block must be provided!' unless block_given?
    @logger.info message
    result = yield

    if result[:invalid_records].empty?
      @logger.info "Nothing was found.\n"
    else
      @logger.info "#{result[:invalid_records].size} #{result[:invalid_records].size == 1 ? 'record' : 'records'} was found!\n"
      write_csv_file(file, result[:invalid_records])
    end
  end
end
