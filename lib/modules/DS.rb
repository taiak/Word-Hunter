# Dictionary Searcher
module DS
  class ::Symbol
    def size?(size, comp_op = :==)
      # string olarak girilmiş değerleri sembole çevirir
      comp_op = comp_op.to_sym if comp_op.class == String
      stat = nil # karşılaştırma koşullarına uymama durumu
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
      return stat
    end
  end
  class ::String
    private
    VOWELS =  /[aâeıîioöuûüAÂEIİÎOÖUÜÛ]/.freeze
    CONSONANT = /[bcçdfgğhjklmnprsştvwxyzBCÇDEFGHJKLMNPRSŞTVWXYZ]/.freeze
    # VOWELS_STR = "aâeıîioöuûüAÂEIİÎOÖUÜÛ".freeze
    # CONSONANT_STR = "bcçdfgğhjklmnprsştvyzBCÇDEFGHJKLMNPRSŞTVYZ".freeze
    #BIG_CHARS =   /[AÂBCÇDEFGĞHIÎİJKLMNOÖPQRSŞTUÛÜVWYZ]/.freeze
    #SMALL_CHARS = /[aâbcçdefgğhıîijklmnoöpqrsştuûüvwyz]/.freeze
    #CHARS = "AÂBCÇDEFGĞHIÎİJKLMNOÖPQRSŞTUÛÜVWXYZaâbcçdefgğhıîijklmnoöpqrsştuûüvxwyz".freeze

    # sonu mak veya mekle bitiyorsa true döner
    def verb?
      self.end_with?('mak', 'mek')
    end
    public
    def bit_start_word?(str)
      self.start_with?(str.to_bit)
    end
    def bit_start_bit?(bitty)
      self.start_with?(bitty)
    end
    # verilen stringin bite çevrilmiş haliyle mi başlıyor?
    def start_this_pattern?(str)
      self.start_pattern?(str.to_bit)
    end
    # verilen patternle mi başlıyor
    def start_pattern?(pattern)
      self.to_bit.start_with?(pattern)
    end
    # sesli mi diye bakar.
    def vowel?(n = 0)
      return false unless self[n] # nil veya false olma ihtimaline karşı
      (VOWELS =~ self[n])?true:false
    end
    def to_alpha(n = 0)
      return "1" unless self[n]
      return (VOWELS =~ self[n])? "0" : "1"
    end
    # sessiz mi diye bakar. var sayılan 0.indis
    def const?(n = 0)
      return false unless self[n] # nil veya false olma ihtimaline karşı
      (CONSONANT =~ self[n])?true:false
    end
    # kontrol işlemi gerçekleştirerek gsub'ın daha hızlı gerçekleşmesini sağlar
    def fast_gsub(exp, change)
      self.dup.fast_gsub!(exp, change)
    end
    def fast_gsub!(exp, change)
      (self.index exp) ? self.gsub!(exp,change) : self
    end
    # verilen ifadeleri yenisiyle değiştirir
    def gsub_all!(new, *old)
      old.each { |exp| fast_gsub!(exp, "#{new}") }
      return self
    end
    def gsub_all(new, *old)
      self.dup.gsub_all!(new, *old)
    end
    # türkçe alfabedeki harfleri bit şekline çevirir
    # sesli harfleri 0'a sessizleri 1'e çevir
    # seslilerin varsayılanı 0 dır ve istisna tutulacak
    # karakterlerin girilmesi gerekilmektedir
    def to_bit(vow = 0)
      self.dup.to_bit!(vow)
    end
    def to_bit!( vow = 0 )
      self.fast_gsub!(VOWELS, vow.to_s)
      self.fast_gsub!(CONSONANT, (1-(vow.to_i)).to_s)
    end
    # verilen parametreye göre karşılaştırma yapar.
    def size?(size, comp_op = :==)
      # string olarak girilmiş değerleri sembole çevirir
      comp_op = comp_op.to_sym if comp_op.class == String
      stat = nil # karşılaştırma koşullarına uymama durumu
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
      return stat
    end
    # verilen stringdeki bit koşullarına uyan elemanları (0 ve 1)
    # comp_op a göre karşılaştırır. varsayılan `==` 'dir
    def bit_size?(size, comp_op = :==)
      # string olarak girilmiş değerleri sembole çevirir
      comp_op = comp_op.to_sym if comp_op.class == String
      # toplam bit içeriğini bul
      bit_count = self.count('0') + self.count('1')
      stat = nil # karşılaştırma koşullarına uymama durumu
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
      return stat
    end
    # string boyutlarına göre true veya false döner
    def limit? (low_limit, up_limit)
      self.size < up_limit and self.size > low_limit
    end
    # türkçe kurallara göre hecelemeyi sağlar
    def spell
      syllabled = self.downcase
      limit = self.size
      i = 1
      while i < limit
        if vowel?(-i)
          if vowel?(-(i+1))
            syllabled.insert(limit-i, "-")
          else
            i += 1
            if (limit-i > 2) || vowel?(-(i+1)) 
              syllabled.insert(limit-i, "-")
            elsif vowel? # ilk harf sesliyse
              syllabled.insert(2, "-") 
            end
          end
        end
        i += 1
      end
      return syllabled
    end
    def bit_spell(vowel = '0')
      syllabled = self.downcase
      limit = self.size
      i = 1
      while i < limit
        if self[-i] == vowel
          if self[-(i+1)] == vowel
            syllabled.insert(limit-i, "-")
          else
            i += 1
            if (limit-i > 2) || self[-(i+1)] == vowel 
              syllabled.insert(limit-i, "-")
            elsif self[0] == vowel # ilk harf sesliyse
              syllabled.insert(2, "-") 
            end
          end
        end
        i += 1
      end
      return syllabled
    end
    def bit_spell!(vowel = '0')
      self.replace(self.bit_spell(vowel))
    end
    def spell!
      self.replace( self.spell )
    end
  end
  class ::Array
    protected
    # [[symbole, number],[symbole, number]] şeklindeki diziden sembolleri seçer
    def catch_class(clss)
      self.flatten.class? clss
    end
    public
    # herbir elemanı sringe dönüştürür
    def to_str
      self.dup.to_str!
    end
    def to_str!
      self.collect! { |word| word.to_s }
    end
    # gsub işlemini diziye uyarla
    def gsub!(before, after)
      self.collect! { |word| (word.index before) ? word.gsub(/#{before}/, after): word }
    end
    def gsub(before, after)
      self.dup.gsub!(before, after)
    end
    # verilen eski harf vey kelimeleri yenisiyle değiştirir
    def gsub_all!(new, *old)
      self.collect! { |element| element.gsub_all!(new, *old) }
    end
    def gsub_all(new, *old)
      self.dup.gsub_all!(new, *old)
    end
    # dizideki stringleri heceler ve heceleri döner. uniq değildir 
    def spell_split(bracket = '-')
      return self.map { |word| word.spell.split(bracket) }.flatten
    end
    # herbir stringin tekrar sayısını verir. her eleman [isim, sayi] şeklinde döner
    def syll_count
      self.spell_split.rep_count
    end
    # verilen dizideki elemanları sayar ve [adı, sayısı] şeklinde uniq bir liste verir
    def rep_count
      self.each_with_object(Hash.new(0)){ |key,hash| hash[key] += 1 }.sort {|sym, rep| rep[1].to_i <=> sym[1].to_i }
    end
    # heceleri(syllables) verir. sembol olarak dönüş yapar
    def syll
      self.syll_count.catch_class(String)
    end
    # verilen patternle başlayan kelimeleri döner
    def start_pattern?(pattern)
      self.select { |word| word.start_pattern?(pattern) }
    end
    # verilen pattern
    def start_this_pattern?(str) 
      self.select { |word| word.start_this_pattern?(str) }
    end
    # wordy ile başlayan kelime var mı diye bakar 
    def any_start?(*wordys)
      self.any? { |word| word.start_with?(*wordys)}
    end
    # wordy ile biten kelime var mı diye bakar
    def any_end?( wordy )
      self.any? { |word| word.end_with? wordy}
    end
    # verilen patterni kelimelerde arar ve geçerli kelimeleri döner
    def index_pattern?(pattern)
      self.select { |word| word.to_bit.index(pattern) }
    end
    # verilen dizinin elemanlarını bit bazında türkçe heceler
    def bit_spell
      self.dup.bit_spell!
    end
    def bit_spell!
      self.collect! { |word| word.bit_spell! }
    end
    # verilen dizideki elemanları türkçeye göre heceler
    def spell
      self.dup.spell!
    end
    def spell!
      self.collect! { |word| word.spell }
    end
    # kelimeleri bit şeklinde 0 ve 1'e çevirir
    def to_bit(vow = 0)
      self.dup.to_bit!(vow)
    end
    def to_bit!(vow = 0)
      self.collect! { |word| word.to_bit!(vow) }
    end
    # verilen dizinin içindeki 0 ve 1 lerin toplamını comp_op'a göre
    # karşılaştırır
    def bit_size?(size, comp_op = :==)
      self.select { |word| word.bit_size?(size, comp_op) }
    end
    # verilen sınıftaki nesneleri döner
    def class?(clss)
      self.select { |word| word.class == clss }
    end
    # wordy kelimesini içeren kelimeleri seçer 
    def search?(wordy)
      self.select { |word| word.include? wordy}
    end
    # wordy kelimesini içermeyen kelimeleri seçer
    def search_not?(wordy)
      self.select { |word| !word.include? wordy}
    end
    # prefix'le başlayan kelimeleri seçer
    def start_with? (*prefix)
      self.select { |word| word.start_with?(*prefix) }
    end
    # sonu suffix ile biten kelimeleri seç    
    def end_with? (suffix)
      self.select { |word| word.end_with? (suffix) }
    end
    # içinde ' '(boşluk) karakteri olmayan kelimeleri seç
    def non_space?
      self.select { |word| !word.index(' ') }
    end
    # içinde ' '(boşluk) karakteri olan kelimeleri seç
    def with_space?
      self.select { |word| word.index(' ') }    
    end
    # fiil kelimeleri seç
    def verb?
      self.select { |word| word.verb? }.collect { |word| word[0...-3] }
    end
    # boyutu size'a göre, verilen işaretle işleme sok ve koşula uyanları seç
    # ön tanımlı işlem parametre verilmezse == işlemi öntanımlı
    def size? (size, comp_op = :==)
      self.select { |word| word.size?(size, comp_op) }
    end
    # boyutu size? koşullarına uymayan sonuçları getir
    def not_size? (size, comp_op = :==)
      self.select { |word| !word.size?(size, comp_op) }
    end
    # uzunluğu low_limit ve up_limit arasında olan kelimeleri seç
    def limit? (low_limit, up_limit)
      self.select { |word| word.limit?(low_limit, up_limit) }
    end
    # verilen dizideki boşlukları siler 
    def unspace
      self.dup.unspace!
    end
    def unspace!
      self.collect! { |word| (word.index ' ')? word.gsub(' ', ''): word }
    end
    # kelimelerin başındaki ve sonundaki boşlukları siler
    def strip
      self.dup.strip!
    end
    def strip!
      self.collect! { |word| word.strip }
    end
    # nil veya false olan kelimeleri seçer
    def not?
      self.select { |word| !word }
    end
    # nil veya false olmayan kelimeleri seçer
    def true?
      self.select { |word| word }
    end
  end
end
