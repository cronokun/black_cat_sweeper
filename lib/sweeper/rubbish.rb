module Sweeper
  class RubbishFilter < Filter
    private

    def reject?(record)
      record.test_data? ||
        record.same_title_and_url? ||
        record.same_title_and_email?
    end
  end
end
