FDetect  = vision.CascadeObjectDetector; 
%Viola-Jones algoritmas�n� kullanarak nesneleri alg�lamak i�in bir dedekt�r 
%olu�turur.
resim1 = imread('resim3.jpg');
resim = imresize(resim1,[240 320]);
AA = step(FDetect,resim);
figure,
subplot(4,4,1);
%subplot(m,n,p)m = ge�erli �ekli bir �zgaraya b�ler ve 
%n = ile belirtilen konumda eksenler olu�turur 
%p = MATLAB � alt grafik konumlar�n� sat�r sat�r numaraland�r�r. 
imshow(resim); hold on
for i = 1:size(AA,1)
    rectangle('Position',AA(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
end
title('Y�z alg�lama i�lemi tamam');
hold off;
%y�z k�rp�lma i�lemi yapaca��m burada
yuz = imcrop(resim,AA);
subplot(4,4,2);
imshow(yuz);
title('Y�z k�rpma i�lemi ba�ar�l�');
%y�ze gauss ve canny filtresi uyguluyoruz
yuz_gri = rgb2gray(yuz);
h=fspecial('gaussian',[3 3],0.5); %Gauss d���k ge�i� filtresi i�in
%belirtilenin iki boyytlu bir filtresini olu�turur 
%i�indeki sat�r ve s�tun say�s�n� belirten bir vekt�r olabilir veya bir
%skaler olabilir, bu durumda bir kare matristir.[3,3]
%i�in varsay�lan de�er sigma 0,5'tir.
yuz_filtre = filter2(h,yuz_gri)/255;
yuz_canny = edge(yuz_filtre(:,:,1),'canny');
%ilk sayfadaki t�m sat�rlar� ve t�m s�tunlar� uygula canny filtresi
subplot(4,4,3);
imshow(yuz_canny);
title('Gauss Canny filtresi');

%a��z belirleyelim
MouthDetect = vision.CascadeObjectDetector('Mouth' , 'MergeThreshold' ,130);
%130 e�ik de�erimizdir
AAa= step(MouthDetect,yuz);
subplot(4,4,4);
imshow(yuz),
title('A��z belirlendi');
hold on
for i = 1:size(AAa,1)
    rectangle('Position',AAa(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
end
hold off

%a��z k�rp�l�yor
agiz = imcrop(yuz,AAa);
subplot(4,4,5);
imshow(agiz);
title('Agiz k�rpma i�lemi ba�ar�l�');

%a��za gauss ve canny filtreleri uygulama
agiz_gri = rgb2gray(agiz);
h=fspecial('gaussian',[3 3],0.5);
agiz_filtre = filter2(h,agiz_gri)/255;
agiz_canny = edge(agiz_filtre(:,:,1),'canny');
%ilk sayfadaki t�m sat�rlar� ve t�m s�tunlar� uygula canny filtresi
subplot(4,4,6);
imshow(agiz_canny);
title('canny agiz filtresi');

%g�z belirleme i�lemi
EyeDetect =vision.CascadeObjectDetector('EyePairBig');
AAb=step(EyeDetect,yuz);
subplot(4,4,7);
imshow(yuz);
title('Goz belirlendi');
rectangle('Position',AAb,'LineWidth',1,'LineStyle','-','EdgeColor','b');

%g�z k�rp�l�yor
goz = imcrop(yuz,AAb);
subplot(4,4,8);
imshow(goz);
title('G�z k�rp�ld�');

%g�ze gauss ve canny filtresi uygulayal�m
goz_gri = rgb2gray(goz);
h2=fspecial('gaussian',[3 3],0.5);
goz_filtre = filter2(h2,goz_gri)/255;
goz_canny = edge(goz_filtre(:,:,1),'canny');
%ilk sayfadaki t�m sat�rlar� ve t�m s�tunlar� uygula canny filtresi
subplot(4,4,9);
imshow(goz_canny);
title('Canny goz');

%g�z pixellerinin say�s�
bw1 = bwareaopen(goz_canny,50);
%bwareaopen(BW,P)P pikselden daha az�na 
%sahip t�m ba�l� bile�enleri (nesneleri) 
%ikili g�r�nt�den kald�rarak BWba�ka bir ikili 
%g�r�nt� olu�turur 
subplot(4,4,10);
imshow(bw1);
title('G�z pixelin say�m�');
goz_pixelsayisi = bwconncomp(goz_canny,8); %2 boyut i�in 8 varsay�land�r 3 boyut i�in 26
%bwconncomp(BW,conn) ikili g�r�nt�deki ba�l� bile�enleri bulur ve sayar 
goz_deger = bweuler(goz_canny,8);
%ikili g�r�nt� i�in euler say�s�n� d�nd�r�r = 
%a��z pixellerinin say�m �
bw2 = bwareaopen(agiz_canny,50);
subplot(4,4,11);
imshow(bw2);
title('Agiz pixelin say�m�');
agiz_pixelsayisi = bwconncomp(agiz_canny,8);
agiz_deger = bweuler(agiz_canny,8);

%y�z pixellerinin sayimi
bw3 = bwareaopen(yuz_canny,50);
subplot(4,4,12);
imshow(bw3);
title('Y�z pixelin say�m�');
yuz_pixelsayisi = bwconncomp(yuz_canny,8);
yuz_deger = bweuler(yuz_canny,8);


goz_agiz_toplam = goz_deger + agiz_deger;
%oranlar
goz_yuz_orani = goz_deger/yuz_deger
agiz_yuz_orani = agiz_deger/yuz_deger
goz_agiz_yuz_orani = goz_agiz_toplam/yuz_deger

fark1= goz_agiz_yuz_orani-goz_yuz_orani

%s�nama
if 0.1750<fark1
    figure,imshow(resim);
    title('Mutlu');
    disp('MUTLUSUN');
elseif agiz_yuz_orani==fark1
    figure,imshow(resim);
    title('�ZG�N');
    disp('�zg�n�z');
else
    figure,imshow(resim);
    title('Korkmu�');
    disp('KORKMU�');
end





