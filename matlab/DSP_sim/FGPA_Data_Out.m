
Fs=20e6; %����Ƶ��
Fs_o=50e3; %��ȡ��Ĳ�����
L=2^13;  %���ݳ���8192,Ƶ�ʷֱ���20e6/8192=2.44KHz
N=2^5; %������ݷ������ȣ�2^6=64,Ƶ�ʷֱ���50e3/64=0.78Khz
%���ı��ļ��ж�ȡ����
%��ȡ�������ݡ���ԭʼ�����źţ��൱��ADC�����õ����ź�
fid=fopen('E:\F\FPGAcode\SDR-radio-receiver\DE0-nano\SDRrceeiver\simulation\modelsim\GenerateAM_Dec.txt','r');
[S_in,S_n]=fscanf(fid,'%lu',inf);
fclose(fid);

S_in_ac=double(S_in)-mean(S_in);

%��ȡI·�������
fid=fopen('E:\F\FPGAcode\SDR-radio-receiver\DE0-nano\SDRrceeiver\simulation\modelsim\i_out_FPGA.txt','r');
[i_out,i_count]=fscanf(fid,'%d',inf);
fclose(fid);

%��ȡq·�������
fid=fopen('E:\F\FPGAcode\SDR-radio-receiver\DE0-nano\SDRrceeiver\simulation\modelsim\q_out_FPGA.txt','r');
[q_out,q_count]=fscanf(fid,'%d',inf);
fclose(fid);

%ȡ��һ�����ݽ��м���
S_in_ac=S_in_ac(1:L)';
i_out=i_out(1:N)';
q_out=q_out(1:N)';
% i_out=i_out((length(i_out)-N+1):length(i_out))';
% q_out=q_out((length(q_out)-N+1):length(q_out))';

iq_out=i_out-1i*q_out;

F_S_in=abs(fft(S_in_ac,L));
F_i_out=abs(fft(i_out,N));
F_q_out=abs(fft(q_out,N));

F_iq_out=abs(fft(iq_out,N));

%��һ������
F_S_in=F_S_in/max(abs(F_S_in));
F_i_out=F_i_out/max(abs(F_i_out));
F_q_out=F_q_out/max(abs(F_q_out));

F_iq_out=F_iq_out/max(abs(F_iq_out));

%ת��Ϊ�����ԭ��ԳƵ��ź�
F_S_in=[F_S_in(L/2+1:L),F_S_in(1:L/2)]; 
F_i_out=[F_i_out(N/2+1:N),F_i_out(1:N/2)]; 
F_q_out=[F_q_out(N/2+1:N),F_q_out(1:N/2)]; 

F_iq_out=[F_iq_out(N/2+1:N),F_iq_out(1:N/2)]; 

%����Ƶ��������
m=[-L/2:1:(L/2-1)]*Fs/L*(10^(-6));%����Ƶ��������,��λΪMHz

m_o=[-N/2:1:(N/2-1)]*Fs_o/N*(10^(-3));%����Ƶ��������,��λΪKHz

%��ͼ
subplot(221);plot(m,F_S_in);
xlabel('Ƶ��(MHz)');ylabel('����');title('�����ź�Ƶ��');

subplot(222);plot(m_o,F_i_out);
xlabel('Ƶ��(KHz)');ylabel('����');title('I·����ź�Ƶ��');

subplot(224);plot(m_o,F_q_out);
xlabel('Ƶ��(KHz)');ylabel('����');title('Q·����ź�Ƶ��');

subplot(223);plot(m_o,F_iq_out);
xlabel('Ƶ��(KHz)');ylabel('����');title('������ź�Ƶ��');

