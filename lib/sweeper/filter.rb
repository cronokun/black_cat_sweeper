module Sweeper
  class Filter
    attr_reader :records, :invalid_records

    def initialize(records)
      @records = records
      @invalid_records = []
    end

    def filter!
      @records.reject! do |record|
        invalid_records << record if reject?(record)
      end

      invalid_records
    end

    private

    def reject?(record)
      raise NotImplementedError, '+#reject?+ method must be implemented in specific filters!'
    end
  end
end
