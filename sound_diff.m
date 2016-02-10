clear

pkg load signal

Fs = 4000;
time = 80;
chunk = 5;

recorder1 = audiorecorder(Fs, 16, 1, 12);
recorder2 = audiorecorder(Fs, 16, 1, 10);
s1 = zeros(1, Fs * time);
s2 = zeros(1, Fs * time);
len1 = length(s1);
len2 = length(s2);

t1 = (0:length(s1)-1)/Fs;
t2 = (0:length(s2)-1)/Fs;

while (true) 
  record(recorder1, chunk);
  record(recorder2, chunk);
  pause(chunk + .06);
  t_s1 = (getaudiodata(recorder1)');
  t_s2 = (getaudiodata(recorder2)');
  s1 = [s1(chunk*Fs:(len1-1)),t_s1];
  s2 = [s2(chunk*Fs:(len2-1)),t_s2];
  s1_norm = s1/max(abs(s1));
  s2_norm = s2/max(abs(s2));
  [acor,lag] = xcorr(s2,s1);
  [c,I] = max(abs(acor));
  lagDiff = lag(I);
  timeDiff = lagDiff/Fs;
  
  subplot(2,1,1)
  plot(t1,s1)
  hold on
  plot ([10; 10], [-.5; .5], 'r')
  hold off
  title('s_1')
  subplot(2,1,2)
  plot(t2,s2)
  hold on
  plot ([10+timeDiff; 10 + timeDiff], [-.4; .4], 'r')
  hold off
  title('s_2')
  xlabel('Time (s)')
  
  disp(timeDiff);
  disp(c);
  disp('------');
  refresh;
  fflush(stdout);
endwhile