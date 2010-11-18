function [ rgb ] = coindetection( image,kreis )
%COINDETECTION Summary of this function goes here
%   Detailed explanation goes here

rgb=zeros(size(kreis,1),6);
relationship=zeros(0,3);
for i=1:size(kreis,1)
 
    % 50Cent
    r=kreis(i,3);%49;  % rel=-0.13
    y=kreis(i,1);
    x=kreis(i,2);
    
    coin=image(x-r:x+r,y-r:y+r,:);
    % r_gross =  123.0543
    % g_gross =  107.2787
    % b_gross =   67.0601
    % 
    % r_klein =  139.0016
    % g_klein =  125.0536
    % b_klein =   84.7873


    %1Euro
    % r=50; % rel= 0.2411
    % coin=image(316-r:316+r,131-r:131+r,:);
    % r_gross =  141.6383
    % g_gross =  126.2125
    % b_gross =   92.2179
    % 
    % r_klein =  107.6117
    % g_klein =  103.9666
    % b_klein = 96.4292

    %2Euro 
    %r=54;  %rel= -0.59
    %coin=image(225-r:225+r,452-r:452+r,:);
    % r_gross =   95.7114
    % g_gross =   93.6355
    % b_gross =   85.9891
    % 
    % r_klein =  151.3284
    % g_klein =  141.7866
    % b_klein =  113.0519

    [u v]= meshgrid(0:2*r,0:2*r);
    p=zeros(1,1,3);

    matrix=(round(sqrt(  (r-u).^2+ (r-v).^2))<r*0.95);
    p(1:size(matrix,2),1:size(matrix,2),1)=matrix;
    p(1:size(matrix,2),1:size(matrix,2),2)=matrix;
    p(1:size(matrix,2),1:size(matrix,2),3)=matrix;
    lll=times(double(coin),double(p));

    matrix=(round(sqrt(  (r-u).^2+ (r-v).^2))<r*0.8);
    p(1:size(matrix,2),1:size(matrix,2),1)=matrix;
    p(1:size(matrix,2),1:size(matrix,2),2)=matrix;
    p(1:size(matrix,2),1:size(matrix,2),3)=matrix;
    ll=times(double(coin),double(p));

    ringgross=lll-ll;
    r_gross=mean(ringgross(find(ringgross(:,:,1)>0)));
    g_gross=mean(ringgross(size(ringgross,1)*size(ringgross,1)+find(ringgross(:,:,2)>0)));
    b_gross=mean(ringgross(size(ringgross,1)*size(ringgross,1)*2+find(ringgross(:,:,3)>0)));

    matrix=(round(sqrt(  (r-u).^2+ (r-v).^2))<r*0.5);
    p(1:size(matrix,2),1:size(matrix,2),1)=matrix;
    p(1:size(matrix,2),1:size(matrix,2),2)=matrix;
    p(1:size(matrix,2),1:size(matrix,2),3)=matrix;

    ringklein=times(double(coin),double(p));
    r_klein=mean(ringklein(find(ringklein(:,:,1)>0)));
    g_klein=mean(ringklein(size(ringklein,1)*size(ringklein,1)+find(ringklein(:,:,2)>0)));
    b_klein=mean(ringklein(size(ringklein,1)*size(ringklein,1)*2+find(ringklein(:,:,3)>0)));

disp(['------Kreis------ r=',num2str(r),' ----']);
rgb(i,:)=[r_gross,g_gross,b_gross,r_klein,g_klein,b_klein];
disp(['--innen: r=',num2str(round(r_klein)),' g=',num2str(round(g_klein)),' b=',num2str(round(b_klein)),    '   auﬂen: r=',num2str(round(r_gross)),' g=',num2str(round(g_gross)),' b=',num2str(round(b_gross))]);
    m_gross=mean([r_gross,g_gross,b_gross]);
    m_klein=mean([r_klein,g_klein,b_klein]);

    d=sqrt(((r_klein - r_gross )^2  + ( g_klein - g_gross )^2   + ( b_klein - b_gross )^2 ))/256;
    %d=sqrt(((r_klein - r_gross )^2 ))/256*3;
    newrel=[(r_klein-r_gross) , (g_klein-g_gross) , (g_klein-b_gross)];
    %newrel=newrel./sum(newrel);
    relationship=[relationship;newrel];
    %relationship=[relationship;[(r_gross-r_klein), (g_gross-g_klein) , (b_gross-g_klein),d]]

text(kreis(i,1),kreis(i,2)+10,['(',num2str(i),')'],'Color','black','BackgroundColor','yellow')
end
% if((r_gross-r_klein)/r_gross)
%     disp('2Euro');
% else
%     disp('1Euro');
% end
% 
% 
% imshow( ringgross./256);
% 


end

