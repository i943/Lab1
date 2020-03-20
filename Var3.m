clc
clear
close all

g_x = [1 0 1 1];        % Порождающий многочлен
k = 4;                  % Длина сообщения
r = length(g_x) - 1;    % Длина контрольной суммы
d = 3;                  % Минимальное расстрояние кода
p = 0:0.1:1;            % Вероятность ошибки в канале (на бит)
eps = 0.01;             % Точность экспериментов
N = 9/(4*(eps^2));      % Количество экспериментов для достижения точности

messages = de2bi((0:2^k-1)');     % Все возможные сообщения
codewords = zeros(2^k, k + r);    % Все кодовые слова с контрольной суммой
for j=1:2^k
    [~, c] = gfdeconv([zeros(1, r), messages(j,:)], g_x);  % Деление в поле 
    codewords(j,:) = xor([zeros(1, r), messages(j,:)], ... % Склеивание
                         [c, zeros(1, k+r - length(c))]);   
end
w = sum(codewords(2:end, :)');     % Веса кодовых слов
errors = de2bi((0:2^(k+r)-1)');    % Все возможные вектора ошибок
w_errors = sum(errors(1:end, :)'); % Веса векторов ошибок
% d = min(w);                      % Для случая, когда d не известно
disp(codewords);                   % Вывод кодовой книги

Pe = zeros(1,length(p));            % Моделирование
Pe_theor = zeros(1, length(p));     % Теория
Pe_up_theor = zeros(1, length(p));  % Верхняя граница
for i=1:length(p)
    % Расчет верхней границы по формуле. Число сочетаний считается, как
    % количество векторов ошибок данного веса sum(w_errors == j)
    P = 0;
    for j=0:d-1
        P = P + sum(w_errors == j) * (p(i)^j) * ((1 - p(i))^((k + r)-j));
    end
    Pe_up_theor(i) = 1 - P;
    
    % Расчет точной вероятности ошибки. sum(w == j) означает число
    % кодовых слов данного веса
    P = 0;
    for j=d:(k + r)
        P = P + sum(w == j) * (p(i)^j) * ((1 - p(i))^((k + r)-j));
    end
    Pe_theor(i) = P;
    
    nErrDecode = 0; % Количество ошибок декодирования
    for n=1:N
        c = codewords(randi(2^k, 1), :);  % Рандомно генерируем номер
                                          % сообщения и берем из заранее
                                          % сгенерированного массива слово
        v = rand(1, length(c)) < p(i); % Рандомно генерируем вектор ошибок
        [~, S] = gfdeconv(xor(c, v)+0, g_x); % Делим слово+ошибки на
                                             % порождающий многочлен в поле
        if (bi2de(S) == 0) && (nnz(v) > 0)  % S - остаток от деления, если
            nErrDecode = nErrDecode + 1;    % он равен 0, то ошибки не 
        end                                 % обнаружены. Если при этом они
    end                                     % были, значит, ошибка декодера
    Pe(i) = nErrDecode/N;
end

figure;
plot(p, Pe, 'bo', ...
     p, Pe_up_theor, 'r.-', ...
     p, Pe_theor, 'k.-')
legend('Pe', 'Pe up', 'Pe theor');
xlabel('p_{bit}')
