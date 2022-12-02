clc; clear; close all;
load('imgfildata.mat');
%dizini matlab ortamina import ettik
dizin = dir('EgitimGoruntuleri');

%dosyanin adlarini alalim
dosyaAdlari = {dizin.name};

%goruntuleri aliyoruz fakat 3'ten baslamamiz gerekiyor
dosyaAdlari = dosyaAdlari(3:end);

%2 satir 62 sutunluk (kac dosya varsa) bir cell veri tipi olusturacak
goruntuler = cell(2,length(dosyaAdlari));

for i=1:length(dosyaAdlari)
   
    %ortomatik olarak her seferinde i degeri artacagi icin bir sonraki
    %ismi gelecek ve goruntuler cell degerine aktarýlacak
   goruntuler(1,i) = {imread(['EgitimGoruntuleri','\',cell2mat(dosyaAdlari(i))])};
   
   gecici = cell2mat(dosyaAdlari(i));
   goruntuler(2,i)={gecici(1)};
end

save('imgfildata.mat','goruntuler')
clear;