module Sweeper
  class RubbishFilter < Filter
    private

    def reject?(record)
      record.test_data?
    end
  end
end
