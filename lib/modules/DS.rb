# Dictionary Searcher
module DS
  class ::Symbol
    def size?(size, comp_op = :==)
      # string olarak girilmis degerleri sembole cevirir
      comp_op = comp_op.to_sym if comp_op.class == String
      stat = nil # karsilastirma kosullarina uymama durumu
      case comp_op
      when :==
        stat = (self.size == size)
      when :>
        stat = (self.size > size)
      when :<
        stat = (self.size < size)
      when :>=
        stat = (self.size >= size)
      when :<=
        stat = (self.size <= size)
      end
      stat
    end
  end
  class ::String
    private

    VOWELS =  /[aâeiîioouûuAÂEIIÎOOUUÛ]/
    CONSONANT = /[bccdfgghjklmnprsstvwxyzBCCDEFGHJKLMNPRSSTVWXYZ]/
    # VOWELS_STR = "aâeiîioouûuAÂEIIÎOOUUÛ".freeze
    # CONSONANT_STR = "bccdfgghjklmnprsstvyzBCCDEFGHJKLMNPRSSTVYZ".freeze
    # BIG_CHARS =   /[AÂBCCDEFGGHIÎIJKLMNOOPQRSSTUÛUVWYZ]/.freeze
    # SMALL_CHARS = /[aâbccdefgghiîijklmnoopqrsstuûuvwyz]/.freeze
    # CHARS = "AÂBCCDEFGGHIÎIJKLMNOOPQRSSTUÛUVWXYZaâbccdefgghiîijklmnoopqrsstuûuvxwyz".freeze

    # sonu mak veya mekle bitiyorsa true doner
    def verb?
      end_with?('mak', 'mek')
    end

    public

    def bit_start_word?(str)
      start_with?(str.to_bit)
    end

    def bit_start_bit?(bitty)
      start_with?(bitty)
    end

    # verilen stringin bite cevrilmis haliyle mi basliyor?
    def start_this_pattern?(str)
      start_pattern?(str.to_bit)
    end

    # verilen patternle mi basliyor
    def start_pattern?(pattern)
      to_bit.start_with?(pattern)
    end

    # sesli mi diye bakar.
    def vowel?(n = 0)
      return false unless self[n] # nil veya false olma ihtimaline karsi
      VOWELS =~ self[n] ? true : false
    end

    def to_alpha(n = 0)
      return '1' unless self[n]
      VOWELS =~ self[n] ? '0' : '1'
    end

    # sessiz mi diye bakar. var sayilan 0.indis
    def const?(n = 0)
      return false unless self[n] # nil veya false olma ihtimaline karsi
      CONSONANT =~ self[n] ? true : false
    end

    # kontrol islemi gerceklestirerek gsub'in daha hizli gerceklesmesini saglar
    def fast_gsub(exp, change)
      dup.fast_gsub!(exp, change)
    end

    def fast_gsub!(exp, change)
      index exp ? gsub!(exp, change) : self
    end

    # verilen ifadeleri yenisiyle degistirir
    def gsub_all!(new, *old)
      old.each { |exp| fast_gsub!(exp, new.to_s) }
      self
    end

    def gsub_all(new, *old)
      dup.gsub_all!(new, *old)
    end

    # turkce alfabedeki harfleri bit sekline cevirir
    # sesli harfleri 0'a sessizleri 1'e cevir
    # seslilerin varsayilani 0 dir ve istisna tutulacak
    # karakterlerin girilmesi gerekilmektedir
    def to_bit(vow = 0)
      dup.to_bit!(vow)
    end

    def to_bit!(vow = 0)
      fast_gsub!(VOWELS, vow.to_s)
      fast_gsub!(CONSONANT, (1 - vow.to_i).to_s)
    end

    # verilen parametreye gore karsilastirma yapar.
    def size?(size, comp_op = :==)
      # string olarak girilmis degerleri sembole cevirir
      comp_op = comp_op.to_sym if comp_op.class == String
      stat = nil # karsilastirma kosullarina uymama durumu
      case comp_op
      when :==
        stat = (self.size == size)
      when :>
        stat = (self.size > size)
      when :<
        stat = (self.size < size)
      when :>=
        stat = (self.size >= size)
      when :<=
        stat = (self.size <= size)
      end
      stat
    end

    # verilen stringdeki bit kosullarina uyan elemanlari (0 ve 1)
    # comp_op a gore karsilastirir. varsayilan `==` 'dir
    def bit_size?(size, comp_op = :==)
      # string olarak girilmis degerleri sembole cevirir
      comp_op = comp_op.to_sym if comp_op.class == String
      # toplam bit icerigini bul
      bit_count = count('0') + count('1')
      stat = nil # karsilastirma kosullarina uymama durumu
      case comp_op
      when :==
        stat = (bit_count == size)
      when :>
        stat = (bit_count > size)
      when :<
        stat = (bit_count < size)
      when :>=
        stat = (bit_count >= size)
      when :<=
        stat = (bit_count <= size)
      end
      stat
    end

    # string boyutlarina gore true veya false doner
    def limit?(low_limit, up_limit)
      (size < up_limit) && (size > low_limit)
    end

    # turkce kurallara gore hecelemeyi saglar
    def spell
      syllabled = downcase
      limit = size
      i = 1
      while i < limit
        if vowel?(-i)
          if vowel?(-(i + 1))
            syllabled.insert(limit - i, '-')
          else
            i += 1
            if (limit - i > 2) || vowel?(-(i + 1))
              syllabled.insert(limit - i, '-')
            elsif vowel? # ilk harf sesliyse
              syllabled.insert(2, '-')
            end
          end
        end
        i += 1
      end
      syllabled
    end

    def bit_spell(vowel = '0')
      syllabled = downcase
      limit = size
      i = 1
      while i < limit
        if self[-i] == vowel
          if self[-(i + 1)] == vowel
            syllabled.insert(limit - i, '-')
          else
            i += 1
            if (limit - i > 2) || self[-(i + 1)] == vowel
              syllabled.insert(limit - i, '-')
            elsif self[0] == vowel # ilk harf sesliyse
              syllabled.insert(2, '-')
            end
          end
        end
        i += 1
      end
      syllabled
    end

    def bit_spell!(vowel = '0')
      replace(bit_spell(vowel))
    end

    def spell!
      replace(spell)
    end
  end
  class ::Array
    protected

    # [[symbole, number],[symbole, number]] seklindeki diziden sembolleri secer
    def catch_class(clss)
      flatten.class? clss
    end

    public

    # herbir elemani sringe donusturur
    def to_str
      dup.to_str!
    end

    def to_str!
      collect!(&:to_s)
    end

    # gsub islemini diziye uyarla
    def gsub!(before, after)
      collect! { |word| word.index before ? word.gsub(/#{before}/, after) : word }
    end

    def gsub(before, after)
      dup.gsub!(before, after)
    end

    # verilen eski harf vey kelimeleri yenisiyle degistirir
    def gsub_all!(new, *old)
      collect! { |element| element.gsub_all!(new, *old) }
    end

    def gsub_all(new, *old)
      dup.gsub_all!(new, *old)
    end

    # dizideki stringleri heceler ve heceleri doner. uniq degildir
    def spell_split(bracket = '-')
      map { |word| word.spell.split(bracket) }.flatten
    end

    # herbir stringin tekrar sayisini verir. her eleman [isim, sayi] seklinde doner
    def syll_count
      spell_split.rep_count
    end

    # verilen dizideki elemanlari sayar ve [adi, sayisi] seklinde uniq bir liste verir
    def rep_count
      each_with_object(Hash.new(0)) { |key, hash| hash[key] += 1 }.sort { |sym, rep| rep[1].to_i <=> sym[1].to_i }
    end

    # heceleri(syllables) verir. sembol olarak donus yapar
    def syll
      syll_count.catch_class(String)
    end

    # verilen patternle baslayan kelimeleri doner
    def start_pattern?(pattern)
      select { |word| word.start_pattern?(pattern) }
    end

    # verilen pattern
    def start_this_pattern?(str)
      select { |word| word.start_this_pattern?(str) }
    end

    # wordy ile baslayan kelime var mi diye bakar
    def any_start?(*wordys)
      any? { |word| word.start_with?(*wordys) }
    end

    # wordy ile biten kelime var mi diye bakar
    def any_end?(wordy)
      any? { |word| word.end_with? wordy }
    end

    # verilen patterni kelimelerde arar ve gecerli kelimeleri doner
    def index_pattern?(pattern)
      select { |word| word.to_bit.index(pattern) }
    end

    # verilen dizinin elemanlarini bit bazinda turkce heceler
    def bit_spell
      dup.bit_spell!
    end

    def bit_spell!
      collect!(&:bit_spell!)
    end

    # verilen dizideki elemanlari turkceye gore heceler
    def spell
      dup.spell!
    end

    def spell!
      collect!(&:spell)
    end

    # kelimeleri bit seklinde 0 ve 1'e cevirir
    def to_bit(vow = 0)
      dup.to_bit!(vow)
    end

    def to_bit!(vow = 0)
      collect! { |word| word.to_bit!(vow) }
    end

    # verilen dizinin icindeki 0 ve 1 lerin toplamini comp_op'a gore
    # karsilastirir
    def bit_size?(size, comp_op = :==)
      select { |word| word.bit_size?(size, comp_op) }
    end

    # verilen siniftaki nesneleri doner
    def class?(clss)
      select { |word| word.class == clss }
    end

    # wordy kelimesini iceren kelimeleri secer
    def search?(wordy)
      select { |word| word.include? wordy }
    end

    # wordy kelimesini icermeyen kelimeleri secer
    def search_not?(wordy)
      reject { |word| word.include? wordy }
    end

    # prefix'le baslayan kelimeleri secer
    def start_with?(*prefix)
      select { |word| word.start_with?(*prefix) }
    end

    # sonu suffix ile biten kelimeleri sec
    def end_with?(suffix)
      select { |word| word.end_with? suffix }
    end

    # icinde ' '(bosluk) karakteri olmayan kelimeleri sec
    def non_space?
      reject { |word| word.index(' ') }
    end

    # icinde ' '(bosluk) karakteri olan kelimeleri sec
    def with_space?
      select { |word| word.index(' ') }
    end

    # fiil kelimeleri sec
    def verb?
      select(&:verb?).collect { |word| word[0...-3] }
    end

    # boyutu size'a gore, verilen isaretle isleme sok ve kosula uyanlari sec
    # on tanimli islem parametre verilmezse == islemi ontanimli
    def size?(size, comp_op = :==)
      select { |word| word.size?(size, comp_op) }
    end

    # boyutu size? kosullarina uymayan sonuclari getir
    def not_size?(size, comp_op = :==)
      reject { |word| word.size?(size, comp_op) }
    end

    # uzunlugu low_limit ve up_limit arasinda olan kelimeleri sec
    def limit?(low_limit, up_limit)
      select { |word| word.limit?(low_limit, up_limit) }
    end

    # verilen dizideki bosluklari siler
    def unspace
      dup.unspace!
    end

    def unspace!
      collect! { |word| word.index ' ' ? word.delete(' ') : word }
    end

    # kelimelerin basindaki ve sonundaki bosluklari siler
    def strip
      dup.strip!
    end

    def strip!
      collect!(&:strip)
    end

    # nil veya false olan kelimeleri secer
    def not?
      reject { |word| word }
    end

    # nil veya false olmayan kelimeleri secer
    def true?
      select { |word| word }
    end
  end
end
