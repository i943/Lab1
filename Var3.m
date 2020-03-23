clc
clear
close all

g_x = [1 0 1 1];        % ����������� ���������
k = 4;                  % ����� ���������
r = length(g_x) - 1;    % ����� ����������� �����
d = 3;                  % ����������� ����������� ����
p = 0:0.1:1;            % ����������� ������ � ������ (�� ���)

messages = de2bi((0:2^k-1)');     % ��� ��������� ���������
codewords = zeros(2^k, k + r);    % ��� ������� ����� � ����������� ������
for j=1:2^k
    c = GFdivide([zeros(1, r), messages(j,:)], g_x);  % ������� � ���� 
    codewords(j,:) = xor([zeros(1, r), messages(j,:)], ... % ����������
                         [c, zeros(1, k+r - length(c))]);   
end
w = sum(codewords(2:end, :)');     % ���� ������� ����
errors = de2bi((0:2^(k+r)-1)');    % ��� ��������� ������� ������
w_errors = sum(errors(1:end, :)'); % ���� �������� ������
% d = min(w);                      % ��� ������, ����� d �� ��������
disp(codewords);                   % ����� ������� �����

Pe_theor = zeros(1, length(p));     % ������ ��������
Pe_up_theor = zeros(1, length(p));  % ������� �������
for i=1:length(p)
    % ������ ������� ������� �� �������. ����� ��������� ���������, ���
    % ���������� �������� ������ ������� ���� sum(w_errors == j)
    P = 0;
    for j=0:d-1
        P = P + sum(w_errors == j) * (p(i)^j) * ((1 - p(i))^((k + r)-j));
    end
    Pe_up_theor(i) = 1 - P;
    
    % ������ ������ ����������� ������. sum(w == j) �������� �����
    % ������� ���� ������� ����
    P = 0;
    for j=d:(k + r)
        P = P + sum(w == j) * (p(i)^j) * ((1 - p(i))^((k + r)-j));
    end
    Pe_theor(i) = P;
end

figure;
plot(p, Pe_up_theor, 'r.-', ...
     p, Pe_theor, 'k.-')
legend('Pe up', 'Pe theor');
xlabel('p_{bit}')
