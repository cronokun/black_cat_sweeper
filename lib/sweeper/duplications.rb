module Sweeper
  # Get rows with the same tilte, address_1 and address_2
  # and keep first rows only.
  #
  class DuplicationsFilter < Filter
    private

    def reject?(record)
      has_duplicates_by_title_and_address?(record) ||
        has_duplicates_by_title_and_empty_address?(record)
    end

    def possible_duplicates
      @possible_duplicates ||= \
      records.group_by(&:title)
      .select { |title, records| records.size > 1 }
    end

    def has_duplicates_by_title_and_address?(current_record)
      return false unless possible_duplicates[current_record.title]

      possible_duplicates[current_record.title].group_by(&:combined_address)
                         .select { |_, records| records.size > 1 }
                         .each { |_, records| records.shift }
                         .values
                         .flatten
                         .include?(current_record)
    end

    def has_duplicates_by_title_and_empty_address?(current_record)
      return false unless possible_duplicates[current_record.title]

      if current_record.empty_address? &&
        records.collect(&:title).include?(current_record.title)
        return true
      end
    end
  end
end
