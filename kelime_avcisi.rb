require_relative './lib/modules/matris_searcher.rb'
include MS

start = Time.new

system "ruby ./lib/marshal_maker.rb" if Dir.glob("./lib/marshalled_files/*").empty?
# pull otomat from file marshalled file
# it's not necessary
otomat = Marshal.load( File.read('./lib/marshalled_files/automat.marshalled') )
# pull dictionary from marshalled file
dict = Marshal.load( File.read('./lib/marshalled_files/archive.marshalled') )


# make new Container with matrix index
oto = Container.new 'leöpneeymmptçuhl'

# add automat
oto.add_automat(otomat)
# add dictionary
oto.add_archive(dict)

# find ways with 10 max length
# ways will be stored in @result
oto.search_all(9)

puts "Sorted elements: "
# search selected word in dictionary
#p oto.result
p oto.sort_archive
# p oto.result

finish = Time.new


puts "Total run time: #{finish-start} sec"
