require_relative './modules/DST.rb'
require_relative './modules/DS.rb'

module Hasher
  class ::Array
    def hash_it
      each_with_object(Hash.new(0)) { |val, hsh| hsh[val] = true; }
    end
  end
end
# kutup is abbreviation of kutuphane
# using for processed and stored kutup file
up = File.read('./dictionary/searchable.kutup').split("\n").each_to_sym
up = up.hash_it
open('./marshalled_files/archive.marshalled', 'wb') { |f| f.puts Marshal.dump(up) }
