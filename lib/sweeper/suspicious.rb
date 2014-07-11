module Sweeper
  class SuspiciousFilter < Filter
    # Valid words that includes "test"
    EXCEPTIONS = [].freeze

    private

    def reject?(record)
      test_data?(record) ||
        url_without_numeric_title(record)
    end

    def test_data?(record)
      record.to_csv.any? do |value|
        normalized_value = value.to_s.downcase
        normalized_value.include?('test') && not_an_exception?(normalized_value)
      end
    end

    def not_an_exception?(text)
      EXCEPTIONS.none? { |word| text.include? word }
    end

    def url_without_numeric_title(record)
      /^\d+$/ =~ record.title &&
        !record.url.nil? &&
        !record.url.include?(record.title)
    end
  end
end
