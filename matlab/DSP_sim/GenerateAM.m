%����������AM�źţ�ʵ����ģ��ADC�ɼ�AM�źţ��������źŴ���ģ��

%�������
fc=5.01e6;                 %carrier frequency
f_message=5e3;% the real message signal frequency
fs=20e6;            %sample frequency
m_index=0.95;    %modulation index
N=10;						%����λ��

%�����ź�
t=0:1/fs:0.001;
y_c=cos(2*pi*fc*t);                    % carrier signal
y_m=cos(2*pi*f_message*t);    % message signal

y_am=(1+m_index.*y_m).*(y_c); %generate amplitude modulated signal 


y_am=y_am/max(abs(y_am))/2;   %normalize
y_am=y_am+abs(min(y_am));       %bias, to the shift the signal to postive level

y_am=round(y_am*(2^N-1));	%10bit����,����y_am��Ϊ��ֵ��������ֵΪ2^N-1


% 
x=0:1:50;
plot(x,y_am(1:length(x)));

%�����ɵĲ����ź���ʮ�������ݸ�ʽд��txt�ļ���
fid=fopen('E:\F\FPGAcode\SDR-radio-receiver\DE0-nano\SDRrceeiver\simulation\modelsim\GenerateAM_Dec.txt','w');
fprintf(fid,'%8d\r\n',y_am);
fprintf(fid,';'); 
fclose(fid);

%����������Զ�������ʽд���ı��ļ���
fid=fopen('E:\F\FPGAcode\SDR-radio-receiver\DE0-nano\SDRrceeiver\simulation\modelsim\GenerateAM.txt','w');
for k=1:length(y_am)
    B_s=dec2bin(y_am(k),N);
    for j=1:N
       if B_s(j)=='1'
           tb=1;
       else
           tb=0;
       end
       fprintf(fid,'%d',tb);  
    end
    fprintf(fid,'\r\n');
end
fprintf(fid,';'); 
fclose(fid);





















