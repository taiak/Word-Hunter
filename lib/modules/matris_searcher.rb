require_relative 'DS.rb'
require_relative 'DST.rb'
require_relative 'DFA.rb'
# matris searcher module
module MS
  class Unit
    attr_reader :tie_count, :content, :ties

    def initialize(content)
      @content = content[0]
      @ties = []
      @tie_count = 0
    end

    # add companion
    def add_comp(element)
      if element.class == self.class
        @ties << element.object_id
        @tie_count += 1
      end
    end
  end

  class Container
    DS # bit cevirileri ve hecelemeleri icin
    DST # each_to_sym icin
    DFA
    # matris kare olacagi icin @edge_size max_row_size ve max_col_size'dir

    attr_reader :edge_size, :size, :comps, :automat, :result
    def initialize(matrix)
      # nil verile ihtimaline karsilik
      unless matrix
        puts 'Error: Container must contain string element!!!'
        exit 2
      end
      @size = matrix.size.freeze
      @edge_size = Math.sqrt(@size).to_i.freeze
      @comps = []
      # matris kare degilse hata ver ve cik
      unless @edge_size.abs2 == matrix.size
        puts 'Error: Container object must be square!!!'
        exit 1
      end
      # her harf icin bir eleman uret ve component'in icine at
      matrix.each_char do |chr|
        @comps << Unit.new(chr.to_sym)
      end
      # comps'u korumak icin
      @comps.freeze
      # componentler arasindaki baglantiyi saglamak icin
      make_relation
      # FIXME: adres ve icerik bir arada tutulabilir!
      # adres stack'i ve icerik stack'i
      @addr_stack = []
      @result = []
      @archive = {}
      @content_stack = ''
      @bit_content = ''
      # on tanimli en uzun yol icerigin uzunlugu
      @max_limit = @size
    end

    protected

    # satirlar arasindaki iliskiyi kurar
    def make_relation
      # matris boyutu kadar tekrar et
      @size.times do |current|
        row, col = current.divmod(@edge_size)
        element = @comps[current]
        if row > 0
          element.add_comp(@comps[current - @edge_size - 1]) if col > 0
          element.add_comp(@comps[current - @edge_size])
          element.add_comp(@comps[current - @edge_size + 1]) if col < @edge_size - 1
        end
        element.add_comp(@comps[current + 1]) if col < (@edge_size - 1)
        if row < @edge_size - 1
          element.add_comp(@comps[current + @edge_size + 1]) if col < @edge_size - 1
          element.add_comp(@comps[current + @edge_size])
          element.add_comp(@comps[current + @edge_size - 1]) if col > 0
        end
        element.add_comp(@comps[current - 1]) if col > 0
      end
    end

    # verilen eleman stackte varmi diye kontrol eder
    def in_stack?(element)
      @addr_stack.include? element.object_id
    end

    def push(element)
      @stack_size += 1
      @addr_stack.push(element.object_id)
      @content_stack << element.content
      @bit_content << element.content.to_alpha
    end

    def pop
      @stack_size -= 1
      @addr_stack.pop
      @content_stack.chop!
      @bit_content.chop!
    end

    def search_way(element)
      push(element)

      if automat_state?
        @result << to_sym if @archive[to_sym] == true
      end

      element.tie_count.times do |i|
        next_element = ObjectSpace._id2ref(element.ties[i])
        break if @stack_size > @max_limit
        next if in_stack? next_element
        search_way next_element
        pop
      end
    end

    def bit_sym_arr
      @bit_content.bit_spell.split('-').each_to_sym
    end

    public

    # if automate work, return true
    def automat_state?
      automat.run(bit_sym_arr)
    end

    def to_sym
      @content_stack.to_sym
    end

    # clear stacks and stacks counter
    def clear_stacks
      @stack_size = 0
      @addr_stack.clear
      @content_stack.clear
      @bit_content.clear
    end

    # search given archive for founded word. then sort them
    def sort_archive
      @result.sort! { |a, b| b.length <=> a.length }.uniq!
    end

    def add_automat(automat)
      @automat = automat
    end

    # archive must be hash, keys must be symbol
    def add_archive(hash_archive)
      @archive = hash_archive
    end

    def search_new_way(limit, max_depth = @max_limit, opt = true)
      @max_limit = max_depth
      # azaltma optimizasyonu saglansin mi?
      @max_limit -= 1 if opt

      if (limit < 0) || (limit > size)
        puts 'Element not in comps limit! Searching canceling!!!'
        return limit
      end
      element = comps[limit]
      clear_stacks
      search_way(element)
    end

    def search_all(max_depth = @max_limit, opt = true)
      @size.times do |num|
        search_new_way(num, max_depth, opt)
      end
    end
  end
end
