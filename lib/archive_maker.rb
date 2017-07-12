require_relative './modules/DST.rb'
require_relative './modules/DS.rb'

module Hasher
  class ::Array
   def hash_it
     self.inject(Hash.new(0)) { |hsh,val| hsh[val] = true ; hsh }
   end
  end
end
# kutup is abbreviation of kütüphane
# using for processed and stored kütüp file
up = File.read('./dictionary/searchable.kutup').split("\n").each_to_sym
up = up.hash_it
open('./marshalled_files/archive.marshalled', 'wb') { |f| f.puts Marshal.dump(up) }
