# https://github.com/andrewytliu/automata/blob/master/dfa.rb
# DFA sınıfı yukarıdaki adresten üzerinde ufak değişiklikler yapılarak alınmıştır
class DFA
  attr_accessor :start, :end, :transition

  def initialize(options = {})
    @start = options[:start]
    @end = options[:end]
    @transition = options[:transition]
  end

  def run(input)
    current_state = @start
	    for i in input
	    	return false unless @transition[current_state]
	      current_state = @transition[current_state][i]
	    end
    return (@end.include? current_state)? true: false
  end
end