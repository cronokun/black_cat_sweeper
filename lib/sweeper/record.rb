module Sweeper
  class Record
    ATTRIBUTE_NAMES = %w[id account_id image_id gallery_id promotion_id country_id state_id region_id city_id area_id updated entered renewal_date discount_id title friendly_url email show_email url display_url address_1 address_2 address_3 unknown zip_code post_code2 latitude longitude phone salesphone servicephone salesmob servicemob fax description long_description bnature keywords attachment_file attachment_caption status level worldwide random_number reminder category_search video_snippet import_id hours_work locations claim_disable neworderid is_parent is_duplicate is_dead].freeze

    attr_reader *ATTRIBUTE_NAMES

    def self.create_from_csv(attributes)
      new.tap do |record|
        attributes.each_with_index do |value, index|
          record.instance_variable_set :"@#{ATTRIBUTE_NAMES[index]}", value
        end
      end
    end

    def to_csv
      ATTRIBUTE_NAMES.map { |attribute| instance_variable_get :"@#{attribute}" }
    end

    # title, address and address 2
    def title_and_address
      [title, address_1, address_2]
    end

    def combined_address
      [address_1, address_2, address_3]
    end

    def empty_address?
      combined_address.compact.empty?
    end

    def same_title_and_email?
      title.to_s.downcase == email.to_s.downcase
    end

    def same_title_and_url?
      title.to_s.downcase == friendly_url.to_s.downcase
    end
  end

end
