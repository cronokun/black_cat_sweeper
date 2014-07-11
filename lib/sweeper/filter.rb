require 'ruby-progressbar'

module Sweeper
  class Filter
    attr_reader :records, :invalid_records

    def initialize(records)
      @records = records
      @invalid_records = []
      @progressbar = ProgressBar.create(:total => @records.count)
    end

    def filter!
      @records.reject! do |record|
        invalid_records << record if reject?(record)
        @progressbar.increment
      end

      {:invalid_records => invalid_records, :valid_records => @records - invalid_records}
    end

    private

    def reject?(record)
      raise NotImplementedError, '+#reject?+ method must be implemented in specific filters!'
    end
  end
end
