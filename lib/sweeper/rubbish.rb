module Sweeper
  class Rubbish
    attr_reader :records, :rubbish

    def initialize(records)
      @records = records
      @rubbish = []
    end

    def remove!
      @records.reject! do |record|
        rubbish << record if reject?(record)
      end

      @rubbish
    end

    private

    def reject?(record)
      record.test_data?
    end
  end
end
