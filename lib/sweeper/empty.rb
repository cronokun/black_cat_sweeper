module Sweeper
  class EmptyFilter < Filter
    private

    def reject?(record)
      only_title_and_phone?(record) ||
        without_address_email_url_phone?(record) ||
        without_title_url_address?(record) ||
        title_is_number_and_empty_url?(record)
    end

    def only_title_and_phone?(record)
      !record.title.nil? &&
        !record.phone.nil? &&
        record.url.nil? &&
        record.email.nil? &&
        record.empty_address?
    end

    def without_address_email_url_phone?(record)
      record.empty_address? &&
        record.email.nil? &&
        record.url.nil? &&
        record.phone.nil?
    end

    def without_title_url_address?(record)
      record.title.nil? &&
        record.url.nil? &&
        record.empty_address?
    end

    def title_is_number_and_empty_url?(record)
      /^\d+$/ =~ record.title &&
        record.url.nil?
    end
  end
end
