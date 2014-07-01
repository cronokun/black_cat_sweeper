module Sweeper
  # Get rows with the same tilte, address_1 and address_2
  # and keep first rows only.
  #
  class DuplicationsFilter < Filter
    private

    def reject?(record)
      duplicates.include? record
    end

    def duplicates
      @duplicates ||= \
      records.group_by(&:title_and_address)
             .select { |_, records| records.size > 1 }
             .each { |_, records| records.shift }
             .values.flatten
    end

    def grouped_duplicates
    end
  end
end
