function [rotatetImage,diff] = rotateImageWithSIFT( a,b)
%TESTSIFT Summary of this function goes here
%   a bekanntes Bild
%   b Vergleichsbild
%clear
%a='coin/euro/2euro/AT_2002.jpg'% originales Bild
%b='coin/euro/2euro/AT_2004_1.jpg'% vergleichsbild


addpath('tools/sift')

%for angle = 0:36*3:360
        
        I1=a;%imread(a);
        % I1=imrotate(I1,4,'crop');
        I1=whitepatch(cropCircle(I1,1));
        I1orig=I1;
        I1=rgb2gray(I1);
        %

        I1=cropCircle(I1,0.6);% Nur inneren 60 % Bereich beachten, weil Aussen Sterene sein koennen

        I2=b;%imread(b) ;
        I2 = imresize(I2,size(I1),'nearest'); 
        %I2=imrotate(I2,angle,'crop');
        I2=whitepatch(cropCircle(I2,1));
        I2orig=I2;

        I2=rgb2gray(I2);


        I2=cropCircle(I2,0.6);

        I1=I1-min(I1(:)) ;
        I1=I1/max(I1(:)) ;
        I2=I2-min(I2(:)) ;
        I2=I2/max(I2(:)) ;

        %fprintf('Computing frames and descriptors.\n') ;

        [frames1,descr1,gss1,dogss1] = sift( I1, 'Verbosity', 1 ) ;
        [frames2,descr2,gss2,dogss2] = sift( I2, 'Verbosity', 1 ) ;
        %figure(11) ; clf ; plotss(dogss1) ; colormap gray ;
        %figure(12) ; clf ; plotss(dogss2) ; colormap gray ;
        %drawnow ;

        matches=siftmatch( descr1, descr2 ) ;
        %fprintf('Matched in %.3f s\n', toc) ;
        %figure(3) ; clf ;
        %plotmatches(I1,I2,frames1(1:2,:),frames2(1:2,:),matches) ;
        %drawnow ;


        rotation=siftgetRotation(matches,frames1,frames2,size(I1)./2);


       % figure(5)

       % fig5 = imshow(I2,[]); 

       % axis off; 

        rotatetImage =imrotate(I2orig,-rotation,'crop');
        
        %I3=cropCircle(I3,1);

        %set(a,'AlphaData',0.9); 
        subplot(2,3,1)
        imshow(I1orig,[])
        title('Originales Bild'); 

        subplot(2,3,2)
        imshow(rotatetImage,[])
        title('vergleichs Bild'); 


        subplot(2,3,3)
        imshow(rotatetImage-I1orig,[])
        title('differenz Bild'); 


         diff=mean(mean(mean(   ((rotatetImage-I1orig).^2)         )))/256^2
%         
%         
       %dd(1,angle+1)=diff;

        

%end


end

