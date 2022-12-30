FDetect  = vision.CascadeObjectDetector; 
%Viola-Jones algoritmasýný kullanarak nesneleri algýlamak için bir dedektör 
%oluþturur.
resim1 = imread('resim3.jpg');
resim = imresize(resim1,[240 320]);
AA = step(FDetect,resim);
figure,
subplot(4,4,1);
%subplot(m,n,p)m = geçerli þekli bir ýzgaraya böler ve 
%n = ile belirtilen konumda eksenler oluþturur 
%p = MATLAB ® alt grafik konumlarýný satýr satýr numaralandýrýr. 
imshow(resim); hold on
for i = 1:size(AA,1)
    rectangle('Position',AA(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
end
title('Yüz algýlama iþlemi tamam');
hold off;
%yüz kýrpýlma iþlemi yapacaðým burada
yuz = imcrop(resim,AA);
subplot(4,4,2);
imshow(yuz);
title('Yüz kýrpma iþlemi baþarýlý');
%yüze gauss ve canny filtresi uyguluyoruz
yuz_gri = rgb2gray(yuz);
h=fspecial('gaussian',[3 3],0.5); %Gauss düþük geçiþ filtresi için
%belirtilenin iki boyytlu bir filtresini oluþturur 
%içindeki satýr ve sütun sayýsýný belirten bir vektör olabilir veya bir
%skaler olabilir, bu durumda bir kare matristir.[3,3]
%için varsayýlan deðer sigma 0,5'tir.
yuz_filtre = filter2(h,yuz_gri)/255;
yuz_canny = edge(yuz_filtre(:,:,1),'canny');
%ilk sayfadaki tüm satýrlarý ve tüm sütunlarý uygula canny filtresi
subplot(4,4,3);
imshow(yuz_canny);
title('Gauss Canny filtresi');

%aðýz belirleyelim
MouthDetect = vision.CascadeObjectDetector('Mouth' , 'MergeThreshold' ,130);
%130 eþik deðerimizdir
AAa= step(MouthDetect,yuz);
subplot(4,4,4);
imshow(yuz),
title('Aðýz belirlendi');
hold on
for i = 1:size(AAa,1)
    rectangle('Position',AAa(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
end
hold off

%aðýz kýrpýlýyor
agiz = imcrop(yuz,AAa);
subplot(4,4,5);
imshow(agiz);
title('Agiz kýrpma iþlemi baþarýlý');

%aðýza gauss ve canny filtreleri uygulama
agiz_gri = rgb2gray(agiz);
h=fspecial('gaussian',[3 3],0.5);
agiz_filtre = filter2(h,agiz_gri)/255;
agiz_canny = edge(agiz_filtre(:,:,1),'canny');
%ilk sayfadaki tüm satýrlarý ve tüm sütunlarý uygula canny filtresi
subplot(4,4,6);
imshow(agiz_canny);
title('canny agiz filtresi');

%göz belirleme iþlemi
EyeDetect =vision.CascadeObjectDetector('EyePairBig');
AAb=step(EyeDetect,yuz);
subplot(4,4,7);
imshow(yuz);
title('Goz belirlendi');
rectangle('Position',AAb,'LineWidth',1,'LineStyle','-','EdgeColor','b');

%göz kýrpýlýyor
goz = imcrop(yuz,AAb);
subplot(4,4,8);
imshow(goz);
title('Göz kýrpýldý');

%göze gauss ve canny filtresi uygulayalým
goz_gri = rgb2gray(goz);
h2=fspecial('gaussian',[3 3],0.5);
goz_filtre = filter2(h2,goz_gri)/255;
goz_canny = edge(goz_filtre(:,:,1),'canny');
%ilk sayfadaki tüm satýrlarý ve tüm sütunlarý uygula canny filtresi
subplot(4,4,9);
imshow(goz_canny);
title('Canny goz');

%göz pixellerinin sayýsý
bw1 = bwareaopen(goz_canny,50);
%bwareaopen(BW,P)P pikselden daha azýna 
%sahip tüm baðlý bileþenleri (nesneleri) 
%ikili görüntüden kaldýrarak BWbaþka bir ikili 
%görüntü oluþturur 
subplot(4,4,10);
imshow(bw1);
title('Göz pixelin sayýmý');
goz_pixelsayisi = bwconncomp(goz_canny,8); %2 boyut için 8 varsayýlandýr 3 boyut için 26
%bwconncomp(BW,conn) ikili görüntüdeki baðlý bileþenleri bulur ve sayar 
goz_deger = bweuler(goz_canny,8);
%ikili görüntü için euler sayýsýný döndürür = 
%aðýz pixellerinin sayým ý
bw2 = bwareaopen(agiz_canny,50);
subplot(4,4,11);
imshow(bw2);
title('Agiz pixelin sayýmý');
agiz_pixelsayisi = bwconncomp(agiz_canny,8);
agiz_deger = bweuler(agiz_canny,8);

%yüz pixellerinin sayimi
bw3 = bwareaopen(yuz_canny,50);
subplot(4,4,12);
imshow(bw3);
title('Yüz pixelin sayýmý');
yuz_pixelsayisi = bwconncomp(yuz_canny,8);
yuz_deger = bweuler(yuz_canny,8);


goz_agiz_toplam = goz_deger + agiz_deger;
%oranlar
goz_yuz_orani = goz_deger/yuz_deger
agiz_yuz_orani = agiz_deger/yuz_deger
goz_agiz_yuz_orani = goz_agiz_toplam/yuz_deger

fark1= goz_agiz_yuz_orani-goz_yuz_orani

%sýnama
if 0.1750<fark1
    figure,imshow(resim);
    title('Mutlu');
    disp('MUTLUSUN');
elseif agiz_yuz_orani==fark1
    figure,imshow(resim);
    title('ÜZGÜN');
    disp('Üzgünüz');
else
    figure,imshow(resim);
    title('Korkmuþ');
    disp('KORKMUÞ');
end





