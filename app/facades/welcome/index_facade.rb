module Welcome
  class IndexFacade < ApplicationFacade
    def process_hand
      return 'Invalid Hand' unless validates_uniqueness_and_count

      separate_face_and_suit
      processed_data
    end

    private

    def validates_uniqueness_and_count
      raw_data.count == 5 && raw_data.uniq.count == 5
    end

    def separate_face_and_suit
      raw_data.uniq.each do |data|
        processed_data << (data.length == 2 ? [data.first, data.last] : [data.first(2), data.last])
      end
    end

    def raw_data
      @raw_data ||= (params[:poker_hand][:cards]).upcase.split
    end

    def processed_data
      @processed_data ||= []
    end

    # def validates_face
    #   str = '10C'
    #   str.length == 2 ? str.first : str.first(2)
    # end
    #
    # def validates_suit
    #   'AH'.last
    # end
  end
end
