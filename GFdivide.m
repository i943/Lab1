function [dividend] = GFdivide(polynomial, g_x)
    % ≈сли полином состоит из нулей, возвращаем ноль
    if all(1~=polynomial)
        dividend = 0;
        return
    end

    % ƒелимое - полином. ”бираем с конца лишние нули, если они есть
    % (Ќули в конце - старша€ степень, если равны 0, то неправильно
    % будет определена степень полинома)
    dividend = polynomial;
    while dividend(end) == 0
        dividend = dividend(1:end-1);
    end

    % ќпредел€ем степени делимого (полинома) и делител€ 
    deg_polynomial = length(dividend) - 1;
    deg_g_x = length(g_x) - 1;

    % ƒелим, пока степени делимого не меньше степени делител€
    while deg_polynomial >= deg_g_x
        % ƒобавл€ем нули в конец делител€, чтобы они были одинаковой длины
        divider = [zeros(1, deg_polynomial - deg_g_x), g_x];
        %  сорим (вычитаем по модулю два)
        dividend = divider ~= dividend;

        % ≈сли остаток не ноль
        if any(dividend)
            % —нова убираем с конца делимого нули
            while dividend(end) == 0
                dividend = dividend(1:end-1);
            end
            % ћен€ем степень делимого
            deg_polynomial = length(dividend) - 1;
        % ≈сли остаток ноль, возвращаем ноль
        else
            dividend = 0;
            return
        end
    end
    % –езультат - то, что осталось от делимого после всех операций
    % (остаток)
end