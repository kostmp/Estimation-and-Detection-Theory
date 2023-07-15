load 'parkinson-Training.mat';
load 'parkinson-Test.mat';
trainData = parkinson1(:,1:22);
trainDataLabels = parkinson1(:,23);
testData = parkinson(:,1:22);
testDataWithLabels = parkinson;
testDataLabels = parkinson(:,23);


%diakritopoisi
%probability of zeros and ones
%PITHANOTITES TWN MIDENIKWN KAI ASSWN
sum_zeros = 0;
sum_ones = 0;
for i=1:length(trainDataLabels)
  if (trainDataLabels(i) == 0)
    sum_zeros = sum_zeros +1;
  endif
  if (trainDataLabels(i) == 1)
    sum_ones = sum_ones+1;
  endif
endfor
prob_zero = sum_zeros/length(trainDataLabels);
prob_one = sum_ones/length(trainDataLabels);


%KANW DUO DIAFORETIKOYS PINAKES, STON PRWTO EINAI OLA TA STOIXEIA POU
%EXOYN ASSO KAI STON DEUYTERO OLA TA MHDENIKA STOIXEIA
for i=1:22
  z = 1;
  on = 1;
  for j=1:156
    if (trainDataLabels(j) == 0)
        zeros00(z,i) = trainData(j,i);
        z = z+1;      
    endif
    if (trainDataLabels(j) == 1)
        ones11(on,i) = trainData(j,i);
        on = on+1;
    endif
  endfor
endfor

pith0 = zeros(22,5);
pith1 = zeros(22,5);



%XWRIZOUME KATHE TIMI KATHE STHLHS STA 5 DIASTHMATA POU XWRISAME TO
%DIASTHMA MIN - MAX
for j=1:22
  step = (max(trainData(:,j)) - min(trainData(:,j)))/5;
  for i=1:size(trainData,1)
    base = min(trainData(:,j));
    up = base + step;
    for k=1:5
      if (trainData(i,j) >= base && trainData(i,j) < up)
        if (trainDataLabels(i) == 1)
          pith1(j,k) = pith1(j,k) + 1;
        endif
        if (trainDataLabels(i) == 0)
          pith0(j,k) = pith0(j,k) + 1;     
        endif
      endif
      base = up;
      up = up + step;
    endfor
  endfor
endfor


%BRISKOUME TIN PITHANOTHTA KATHE DIASTIMATOS KAI PROSTHETOUME
%KAI DUO EPIPLEON DIASTHMATA, ENA PRIN TO MIN KAI ENA META TO MAX
pith0 = (pith0 + 2)/64;
pith1 = (pith1 + 2)/136;

%GIA OLA TA DEDOMENA TWN TEST DATA EFARMOZOUME TON NAIVE BAYES
for i=1:size(testDataWithLabels,1)
  %ARXIKOPOIOUME TIS PITHANOTHTES GIA TO MIDEN KAI TO ENA
  product_zero = prob_zero;
  product_one = prob_one;
  
  for j=1:22
    %AN EINAI MIKROTERH APO TO MIN KATHE STHLHS BAZOUME THN PITHANOTHTA
    if (testDataWithLabels(i,j) < min(trainData(:,j)))
      product_one = product_one*(1/136);
      product_zero = product_zero*(1/64);
      continue;
    endif
    %AN EINAI MEGALUTERH APO TO MAX
    if (testDataWithLabels(i,j) > max(trainData(:,j)))
      product_one = product_one*(1/136);
      product_zero = product_zero*(1/64);  
      continue;   
    endif
    step = (max(trainData(:,j)) - min(trainData(:,j)))/5;
    base = min(trainData(:,j));
    up = base + step;
   %ELEGXOUME SE POIO DIASTHMA EINAI 
    for k=1:5
      if (testDataWithLabels(i,j) >= base && testDataWithLabels(i,j) < up)
        product_one = product_one*pith1(j,k);
        product_zero = product_zero*pith0(j,k);
        break;
      endif
      base = up;
      up = up + step;
    endfor
  endfor
  if (product_one >= product_zero)
    testDataWithLabels(i,23) = 1;
  endif
  if (product_zero > product_one)
    testDataWithLabels(i,23) = 0;
  endif
endfor

same = 0;
for i=1:39
  if (testDataWithLabels(i,23) == testDataLabels(i))
    same = same + 1;
  endif
endfor
disp("To pososto swstis provlepsis einai:");
(same/39)*100







 