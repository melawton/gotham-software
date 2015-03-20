xc = [ 1;2;3;4];
xc_coord1 = num2str(xc);
 n=length(xc_coord);
 assignin('base','n',n);
%  assignin('base','xc_coord1',xc_coord1);
 evalin('base',xc_coord1);
 for k = 1:4
     
%      assignin('base','xctest',xc(k));
%      assignin('base','xc_coord',xc_coord(k));
%      assignin('base','yc_coord',yc_coord(k));
%      assignin('base','zc_coord',zc_coord(k));
 end

% assignin('base','xc_coord',1);
% evalin('base', 'yc_coord');
% assignin('base','yc_coord',yc_coord);
% assignin('base','zc_coord',zc_coord);
% assignin('base','current',current);
% 