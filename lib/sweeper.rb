require 'sweeper/record'
require 'sweeper/filter'
require 'sweeper/duplications'
require 'sweeper/empty'
require 'sweeper/rubbish'

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
    invalid_data = yield

    if invalid_data.empty?
      @logger.info "Nothing was found.\n"
    else
      @logger.info "#{invalid_data.size} #{invalid_data.size == 1 ? 'record' : 'records'} was found!\n"
      write_csv_file(file, invalid_data)
    end
  end
end
