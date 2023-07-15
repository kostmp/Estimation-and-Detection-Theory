load 'parkinson-Training.mat';
load 'parkinson-Test.mat';
trainData = parkinson1(:,1:22);
trainDataLabels = parkinson1(:,23);
testData = parkinson(:,1:22);
testDataWithLabels = parkinson;
testDataLabels = parkinson(:,23);




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

%UPOLOGIZW GIA KATHE STHLH THN APOKLISI KAI TIN MESI TIMH
%TWN DYO PINAKWN
mean_zero = zeros(1,22);
std_zero = zeros(1,22);
mean_ones = zeros(1,22);
std_ones = zeros(1,22);

for i=1:22
  mean_zero(i) = mean(zeros00(:,i));
  std_zero(i) = std(zeros00(:,i));
  mean_ones(i) = mean(ones11(:,i));
  std_ones(i) = std(ones11(:,i));
endfor

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

%EFARMOGH THS GAUSS NAIVE BAYES STA DEDOMENA
for i=1:size(testDataWithLabels,1)
  product_zero(i) = prob_zero;
  product_one(i) = prob_one;
  for j=1:22
    product_one(i) = product_one(i)*normpdf(testDataWithLabels(i,j),mean_ones(j),std_ones(j));
    product_zero(i) = product_zero(i)*normpdf(testDataWithLabels(i,j),mean_zero(j),std_zero(j));
  endfor  
  if (product_one(i) > product_zero(i))
    testDataWithLabels(i,23) = 1;
  endif
  if (product_one(i) < product_zero(i))
    testDataWithLabels(i,23) = 0;
  endif
  if (product_one(i) == product_zero(i))
    testDataWithLabels(i,23) = 1;
  endif
endfor

%POSOSTO EPITUXIAS THS GAUSSIAN NAIVE BAYES
same = 0;
for i=1:39
  if (testDataWithLabels(i,23) == testDataLabels(i))
    same = same + 1;
  endif
endfor
disp("To pososto swstis provlepsis einai:");
(same/39)*100





