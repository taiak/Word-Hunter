# Word_Hunter

Bu program kelime avcısı ve benzeri programların kelimelerini çözümlemek amaçlı tasarlanmıştır.

Otomat tasarımı Hanne Yazbahar'a ait olup, kalan kısım Taha Yasir Kıroğlu tarafından tasarlanmıştır.

Program kullanılan otomat gereğince sadece türkçe dilinde çalışmak üzere tasarlanmıştır.

./lib/automat_maker.rb içerisindeki otomat değiştirilerek başka otomatlarda kullanılabilmektedir. Ayrıca kullanılan sözlük kontrolü yetersiz kalırsa ./lib/dictionary kısmından yeni bir sözlük ekleyip,
 ./marshalled_files klasörünü silip ./lib/marshal_maker.rb programını çalıştırınız.

Programın başarımı en düşük %60-70 arasıdır. Eklenecek otomat veya mevcut otomatın düzeltilmesiyle daha yüksek başarımlar elde edilebilinmektedir.