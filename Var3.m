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
    c = GFdivide([zeros(1, r), messages(j,:)], g_x);  % Деление в поле 
    codewords(j,:) = xor([zeros(1, r), messages(j,:)], ... % Склеивание
                         [c, zeros(1, k+r - length(c))]);   
end
w = sum(codewords(2:end, :)');     % Веса кодовых слов
errors = de2bi((0:2^(k+r)-1)');    % Все возможные вектора ошибок
w_errors = sum(errors(1:end, :)'); % Веса векторов ошибок
% d = min(w);                      % Для случая, когда d не известно
disp(codewords);                   % Вывод кодовой книги

Pe_theor = zeros(1, length(p));     % Точное значение
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
end

figure;
plot(p, Pe_up_theor, 'r.-', ...
     p, Pe_theor, 'k.-')
legend('Pe up', 'Pe theor');
xlabel('p_{bit}')


function [dividend] = GFdivide(polynomial, g_x)
    % Если полином состоит из нулей, возвращаем ноль
    if all(1~=polynomial)
        dividend = 0;
        return
    end

    % Делимое - полином. Убираем с конца лишние нули, если они есть
    % (Нули в конце - старшая степень, если равны 0, то неправильно
    % будет определена степень полинома)
    dividend = polynomial;
    while dividend(end) == 0
        dividend = dividend(1:end-1);
    end

    % Определяем степени делимого (полинома) и делителя 
    deg_polynomial = length(dividend) - 1;
    deg_g_x = length(g_x) - 1;

    % Делим, пока степени делимого не меньше степени делителя
    while deg_polynomial >= deg_g_x
        % Добавляем нули в конец делителя, чтобы они были одинаковой длины
        divider = [zeros(1, deg_polynomial - deg_g_x), g_x];
        % Ксорим (вычитаем по модулю два)
        dividend = divider ~= dividend;

        % Если остаток не ноль
        if any(dividend)
            % Снова убираем с конца делимого нули
            while dividend(end) == 0
                dividend = dividend(1:end-1);
            end
            % Меняем степень делимого
            deg_polynomial = length(dividend) - 1;
        % Если остаток ноль, возвращаем ноль
        else
            dividend = 0;
            return
        end
    end
    % Результат - то, что осталось от делимого после всех операций
    % (остаток)
end
