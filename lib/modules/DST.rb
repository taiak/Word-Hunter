# DictionarySearcherTools
module DST
  class ::String
    BIG_CHARS =   /[AÂBCCDEFGGHIÎIJKLMNOOPQRSSTUÛUVWYZ]/
    SMALL_CHARS = /[aâbccdefgghiîijklmnoopqrsstuûuvwyz]/

    # buyuk harfle basliyarsa true doner
    def start_with_big?
      BIG_CHARS =~ self[0] ? true : false
    end

    # kucuk harfle basliyorsa true doner
    def start_with_small?
      SMALL_CHARS =~ self[0] ? true : false
    end
  end
  class ::Array
    # kelimelerin basindaki ve sonundaki bosluklari siler
    # false olan degerleri doner
    def false?
      select { |word| word == false }
    end

    # nil olan degerleri doner
    def nil?
      select(&:nil?)
    end

    # FIXME: Turkceye uyarla
    # upcase islemini saglar
    def upcase
      dup.upcase!
    end

    def upcase!
      collect!(&:upcase)
    end

    # FIXME: Turkceye uyarla
    # downcase islemini saglar
    def downcase
      dup.downcase!
    end

    def downcase!
      collect!(&:downcase)
    end

    # buyuk harfle baslayan kelimeleri sec
    def start_big?
      select(&:start_with_big?)
    end

    # kucuk harfle baslayan kelimeleri sec
    def start_small?
      select(&:start_with_small?)
    end

    # herbir elemani sembole cevirir
    def each_to_sym
      dup.each_to_sym!
    end

    def each_to_sym!
      collect!(&:to_sym)
    end
  end
end
