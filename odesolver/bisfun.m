clear all
close all

f=@(x) (x-2.1)*(x-2.11)*(x-2.12);
aq=-5;
bq=10;
u=bisect(aq,bq,f)
