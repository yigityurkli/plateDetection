close all; clear; clc;

load imgfildata
%%kullaniciya dosya seçtirme islemi
[dosya,dosyaYolu] = uigetfile({'*.jpg; *.bmp; *.png; *.tif'},'Bir goruntu secin');

%dosya uzantisi tam haliyle olusturuldu
dosya = [dosyaYolu,dosya];

goruntu = imread(dosya);

[~,boyut]= size(goruntu);

goruntu = imresize(goruntu,[300 500]);

if size(goruntu,3)==3
    goruntu= rgb2gray(goruntu);
end


%grilik seviyesini tespit ettik 
%Gabor filtresiyle cok daha saglikli sonuclar alabilirsiniz
threshold = graythresh(goruntu);
%goruntuyu siyah beyaz yaptik
goruntu = imbinarize(goruntu,threshold);

%goruntunun terisini almak
goruntuTersi = ~goruntu;
figure,imshow(goruntu),title('Orjinal Görüntü');
figure,imshow(goruntuTersi),title('Görüntünün Tersi');

%goruntuleri temizleme

if boyut >2000
    %nesnenin boyutu 3500 den büyükse kalsýn deðilse silsin
    goruntu1 = bwareaopen(goruntuTersi,3500);
else
    goruntu1 = bwareaopen(goruntuTersi,3000);
end
figure,imshow(goruntu1),title('Temizlenmiþ Görüntü');
goruntu2 = goruntuTersi-goruntu1;

goruntu2=bwareaopen(goruntu2,250);
figure,imshow(goruntu2),title('Çýkarýlmýþ Görüntü');

[etiketler,Nesneler]=bwlabel(goruntu2);
nesneOzellikleri = regionprops(etiketler,'BoundingBox');

hold on 

pause(1)

for n =1 : size(nesneOzellikleri,1)
    
   
    rectangle('Position',nesneOzellikleri(n).BoundingBox,'EdgeColor','g','LineWidth',2);
    
end
hold off

figure

% tüm plaka karakterlerini finalCikis degiskeninde saklayacagim
finalCikis=[]

%her nesnenin max korelasyon degerini tutar
t=[]

for n=1: Nesneler
    %etiketlenmis goruntu de karakter ara    
    [r,c]=find(etiketler==n);
    karakter = goruntuTersi(min(r):max(r),min(c):max(c));
    karakter = imresize(karakter,[42,24]);
    figure,imshow(karakter),title('Karakter');

    pause(0.2);
    x=[];
    %karakter sayisini bulduk
    karakterSayisi = size(goruntuler,2);

    %suan elde ettigimiz nesnenin veritabanindaki tum karakterlerle
    %kiyaslamasini yapiyoruz ve korelasyon degerini elde ediyoruz
    for k=1:karakterSayisi
        y=corr2(goruntuler{1,k},karakter)
        x = [x y]
    end

    t=[t max(x)];
    
    %korelasyon degerleri altinda kalanlari temizle
    if max(x)> 0.4
    enBuyukIndis = find(x==max(x))
    %hangi karakterle eslestiyse max indise bakarak o karakter olacaktir
    cikisKarakter=cell2mat(goruntuler(2,enBuyukIndis))
    finalCikis=[finalCikis cikisKarakter]

    end


end
dosyaAdi='plakaKarakterleri.txt';
dosya = fopen(dosyaAdi,'wt');
fprintf(dosya,'%s\n',finalCikis);
fclose(dosya);
winopen('plakaKarakterleri.txt');
