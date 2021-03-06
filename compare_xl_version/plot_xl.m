% 'yellow'	'y'	[1 1 0]
% 'magenta'	'm'	[1 0 1]
% 'cyan'	'c'	[0 1 1]
% 'red'	'r'	[1 0 0]
% 'green'	'g'	[0 1 0]
% 'blue'	'b'	[0 0 1]
% 'white'	'w'	[1 1 1]
% 'black'	'k'	[0 0 0]

datatype_idx=1;
datatype_cell = {'w_sparse_W_block','w_sparse_W_lowrank_asym','w_sparse_W_lowrank_sym','w_sparse_W_sparse'};
datatype=datatype_cell{datatype_idx};

color={'y','r','k','b','g'}
pp=[10,100,500,1000];
ii=1;
p=pp(ii);

hold on
for i=1:5
	% i=2
	ff=dlmread(['../results/', datatype, '_p', num2str(p),'_', num2str(i),'_ff']);
	ff=log(ff);
	plot(ff,color{2});
	% legend();
end
datatype2_cell = {'w sparse W block','w sparse W lowrank asym','w sparse W lowrank sym','w sparse W sparse'};
title(datatype2_cell{datatype_idx});
xlabel('iteration');
ylabel('log(f)');
hold off
%save figure
print(['../results/', datatype, '_p', num2str(p),'_figure'],'-dpng');