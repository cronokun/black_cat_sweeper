module Sweeper
  class EmptyFilter < Filter
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
