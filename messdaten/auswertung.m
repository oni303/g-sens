# Prevent Octave from thinking that this
# is a function file:

1;


%berechnet den betrag einer 3dim beschleunigung
function ret = betrag (werte)
	ret = (werte(:,1) .* werte(:,1) + werte(:,2) .* werte(:,2) + werte(:,3) .* werte(:,3) ) .^ (1/2);
endfunction

%berechnet den neigungswinkel zur z achse
function z = neigungZ (werte)
	%winkel zur z-achse 
	z = acos( werte(:,3) ./ ((werte(:,1) .* werte(:,1) + werte(:,2) .* werte(:,2) + werte(:,3) .* werte(:,3) ) .^ (1/2)) ) / pi * 180;
	return;
endfunction

%berechnet den neigungswinkel zur x achse
function x = neigungX (werte)
	%winkel zur x-achse
	x = acos( werte(:,1) ./ ((werte(:,1) .* werte(:,1) + werte(:,3) .* werte(:,3)) .^(1/2)) ) / pi * 180 - 90;
	return;
endfunction

%berechnet den neigungswinkel zur y achse
function y = neigungY (werte)
	%winkel zur y-achse
	y = acos( werte(:,2) ./ ((werte(:,2) .* werte(:,2) + werte(:,3) .* werte(:,3)) .^(1/2)) ) / pi * 180 - 90;
	return;
endfunction

function printOverView()
	load droppen.txt;
	load droppen2.txt;
	load hochwerfen.txt;
	load hochwerfen2.txt;
	load halten1.txt;
	load rauschen1.txt;
	load schleudern.txt;

	figure
	hold on
	subplot(5,1,1)
	plot(betrag([droppen;droppen2]));
	xlabel("Zeit / n")
	ylabel("Beschleunigung / g/225")
	title("droppen")
	
	subplot(5,1,2)
	plot(betrag(schleudern));
	title("schleudern")
	xlabel("Zeit / n")
	ylabel("Beschleunigung / g/225")
	
	subplot(5,1,3)
	plot(betrag([hochwerfen; hochwerfen2]));
	title("hochwerfen")
	xlabel("Zeit / n")
	ylabel("Beschleunigung / g/225")
	
	subplot(5,1,4)
	plot(betrag(rauschen1));
	title("rauschen1")
	xlabel("Zeit / n")
	ylabel("Beschleunigung / g/225")
	
	subplot(5,1,5)
	plot(betrag(halten1));
	title("halten1")
	xlabel("Zeit / n")
	ylabel("Beschleunigung / g/225")
	hold off
	
	pause
endfunction

function firstAnalysis()
	load droppen.txt;
	load droppen2.txt;
	load hochwerfen.txt;
	load hochwerfen2.txt;
	load halten1.txt;
	load rauschen1.txt;
	load schleudern.txt;

	neigungen = [neigungX([droppen;droppen2])';
		neigungY([droppen;droppen2])';
		neigungZ([droppen;droppen2])']';
	
	figure
	hold on
	subplot(5,1,2)
	plot(betrag([droppen;droppen2]));
	xlabel("Zeit / n")
	ylabel("Beschleunigung / g/225")
	title("Droppen betrag")
	
	subplot(5,1,1)
	plot([droppen;droppen2]);
	title("raw")
	xlabel("Zeit / n")
	ylabel("Beschleunigung / g/225")
	
	subplot(5,1,3)
	plot(neigungen);
	title("winkel")
	xlabel("Zeit / n")
	ylabel("winkel / °")
	
	hold off
endfunction

function test()
	load sample_schleudern.txt;
	load sample_droppen.txt;
	load sample_hochwerfen.txt;
	load demo1.txt;

	demo1 = korrigiereWerte(demo1);
	sample_schleudern = korrigiereWerte(sample_schleudern);
	sample_droppen = korrigiereWerte(sample_droppen);
	sample_hochwerfen = korrigiereWerte(sample_hochwerfen);

	figure
	hold on

	subplot(5,1,1)
	%plot(sample_droppen);
	plot([sample_droppen'; betrag(sample_droppen)']');
	title("sample droppen")
	xlabel("Zeit / n")
	ylabel("raw value")

	subplot(5,1,2)
	%plot(sample_hochwerfen);
	plot([sample_hochwerfen'; betrag(sample_hochwerfen)']');
	title("sample hochwerfen")
	xlabel("Zeit / n")
	ylabel("raw value")

	subplot(5,1,3)
	%plot(sample_schleudern);
	plot([sample_schleudern'; betrag(sample_schleudern)']');
	title("sample schleudern")
	xlabel("Zeit / n")
	ylabel("raw value")

	subplot(5,1,4)
	%plot(demo1);
	plot([demo1'; betrag(demo1)']');
	title("*demo1*")
	xlabel("Zeit / n")
	ylabel("raw value")
	
	%korrellation zwischen schleudern und demo betrags mäßig
	subplot(5,1,5)
	%plot(demo1);
	plot([fftconv(betrag(demo1), betrag(sample_schleudern))']');
		%;fftconv(betrag(demo1), betrag(sample_hochwerfen))'
		%;	fftconv(betrag(demo1), betrag(sample_droppen))']');
	title("korrelation demo schleudern")
	xlabel("Zeit / n")
	ylabel("raw value")

	hold off

	printf( "test\n")
endfunction

function matrix = addBetrag(werte)
	matrix = [werte'; betrag(werte)']';
endfunction

function kalibrieren()
%zZ nur zum plotten - soll mal anhand der werte über den betrag
%   die korrektur geraden ausgeben
	load rauschen_z.txt;
	load rauschen_x.txt;
	load rauschen_y.txt;

	figure
	hold on

	subplot(5,1,1)
	plot(addBetrag(rauschen_x));
	title("rauschen x")
	xlabel("Zeit / n")
	ylabel("raw value")

	subplot(5,1,2)
	plot(addBetrag(rauschen_y));
	title("rauschen y")
	xlabel("Zeit / n")
	ylabel("raw value")

	subplot(5,1,3)
	plot(addBetrag(rauschen_z));
	title("rauschen z")
	xlabel("Zeit / n")
	ylabel("raw value")

	hold off

	printf("kalli\n")
endfunction

function ret = korrigiereWerte(werte)
	%korrectur für z>0
	%200 / 209.03
	%korrectur für z<0
	%-200 / -220.78
	%korrectur für y>0
	%200 / 211.19
	%korrectur für y<0
	%-200 / -207.76
	%korrectur für x>0
	%200 / 223.93
	%korrectur für x<0
	%-200 / -194.28

	ret = [[werte(:,1) .* 400/417.92 - 14.302]';
				[werte(:,2) .* 400/418.95 - 1.637]';
				[werte(:,3) .* 400/429.81 + 5.467]']';

endfunction

function plotKreuzkorrelation()
	load sample_schleudern.txt;
	load sample_droppen.txt;
	load sample_hochwerfen.txt;
	load demo1.txt;

	demo1 = korrigiereWerte(demo1);
	sample_schleudern = korrigiereWerte(sample_schleudern);
	sample_droppen = korrigiereWerte(sample_droppen);
	sample_hochwerfen = korrigiereWerte(sample_hochwerfen);

	figure
	hold on

	subplot(5,1,1)
	%plot(demo1);
	plot([demo1'; betrag(demo1)']');
	title("demo1")
	xlabel("Zeit / n")
	ylabel("raw value")

	subplot(5,1,2)
	%plot(sample_hochwerfen);
	plot([[betrag(sample_droppen); zeros(1,13)']';[betrag(sample_hochwerfen);zeros(10,1)]';[betrag(sample_schleudern)]']');
	title("sample hochwerfen")
	xlabel("Zeit / n")
	ylabel("raw value")


	%korrellation zwischen schleudern und demo betrags mäßig
	subplot(5,1,3)
	%plot(demo1);
	plot([fftconv(betrag(demo1), betrag(sample_droppen))']');
		%;fftconv(betrag(demo1), betrag(sample_hochwerfen))'
		%;	fftconv(betrag(demo1), betrag(sample_droppen))']');
	title("korrelation demo droppen")
	xlabel("Zeit / n")
	ylabel("raw value")

	%korrellation zwischen schleudern und demo betrags mäßig
	subplot(5,1,4)
	%plot(demo1);
	plot([fftconv(betrag(demo1), betrag(sample_hochwerfen))']');
		%;fftconv(betrag(demo1), betrag(sample_hochwerfen))'
		%;	fftconv(betrag(demo1), betrag(sample_droppen))']');
	title("korrelation demo hochwerfen")
	xlabel("Zeit / n")
	ylabel("raw value")
	
	%korrellation zwischen schleudern und demo betrags mäßig
	subplot(5,1,5)
	%plot(demo1);
	plot([fftconv(betrag(demo1), betrag(sample_schleudern))']');
		%;fftconv(betrag(demo1), betrag(sample_hochwerfen))'
		%;	fftconv(betrag(demo1), betrag(sample_droppen))']');
	title("korrelation demo schleudern")
	xlabel("Zeit / n")
	ylabel("raw value")

	hold off

	printf( "kreuzkorrelation\n")

endfunction

%begin of script

%printOverView();
%pause
%firstAnalysis();
printf( "fertig\n")
plotKreuzkorrelation();
%kalibrieren();
%load rauschen1.txt;
%plot(addBetrag(korrigiereWerte(rauschen1)));
