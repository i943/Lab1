function [dividend] = GFdivide(polynomial, g_x)
    % ���� ������� ������� �� �����, ���������� ����
    if all(1~=polynomial)
        dividend = 0;
        return
    end

    % ������� - �������. ������� � ����� ������ ����, ���� ��� ����
    % (���� � ����� - ������� �������, ���� ����� 0, �� �����������
    % ����� ���������� ������� ��������)
    dividend = polynomial;
    while dividend(end) == 0
        dividend = dividend(1:end-1);
    end

    % ���������� ������� �������� (��������) � �������� 
    deg_polynomial = length(dividend) - 1;
    deg_g_x = length(g_x) - 1;

    % �����, ���� ������� �������� �� ������ ������� ��������
    while deg_polynomial >= deg_g_x
        % ��������� ���� � ����� ��������, ����� ��� ���� ���������� �����
        divider = [zeros(1, deg_polynomial - deg_g_x), g_x];
        % ������ (�������� �� ������ ���)
        dividend = divider ~= dividend;

        % ���� ������� �� ����
        if any(dividend)
            % ����� ������� � ����� �������� ����
            while dividend(end) == 0
                dividend = dividend(1:end-1);
            end
            % ������ ������� ��������
            deg_polynomial = length(dividend) - 1;
        % ���� ������� ����, ���������� ����
        else
            dividend = 0;
            return
        end
    end
    % ��������� - ��, ��� �������� �� �������� ����� ���� ��������
    % (�������)
end