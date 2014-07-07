module Sweeper
  class EmptyFilter < Filter
    private

    def reject?(record)
      puts record.inspect if only_title_and_phone?(record)
        only_title_and_phone?(record) ||
        (empty_address?(record) &&
          record.email.nil? &&
          record.url.nil? &&
          record.phone.nil?)
    end

    def empty_address?(record)
      record.combined_address.join.strip.empty?
    end

    def only_title_and_phone?(record)
      !record.title.nil? &&
        !record.phone.nil? &&
        record.url.nil? &&
        record.email.nil? &&
        empty_address?(record)
    end
  end
end
