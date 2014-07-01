module Sweeper
  class Empty
    attr_reader :records, :empty

    def initialize(records)
      @records = records
      @empty = []
    end

    def remove!
      @records.reject! do |record|
        empty << record if reject?(record)
      end

      @empty
    end

    private

    # TODO: change +nil?+ to +blank?+
    def reject?(record)
        empty_address?(record) &&
          record.email.nil? &&
          record.url.nil? &&
          record.phone.nil?
    end

    def empty_address?(record)
      record.combined_address.join.strip.empty?
    end
  end
end
