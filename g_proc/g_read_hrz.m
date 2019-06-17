function m = g_read_hrz(hParent,N)
handles = guidata(hParent);
fid = fopen([handles.r_path handles.r_file],'r');

ind = ~strcmp(handles.col_names,'~');

if strcmp(handles.delimiter,'Space')
    delim = ' ';
elseif strcmp(handles.delimiter,'Tab')
    delim = sprintf('\t');
elseif strcmp(handles.delimiter,'Comma')
    delim = ',';
elseif strcmp(handles.delimiter,'Dot')
    delim = '.';
end

if isempty(N)
    m = matfile([handles.s_path handles.s_file '.mat'],'Writable',true);
    m.hrz = [];
end

hrz = zeros(10^4,1);
k = 1;
while ~feof(fid) % ���� �� ���������� ����
    s = fgetl(fid); % ��������� ��������� ������
    s(s == delim) = ' '; % ������ ������� ������ ������������
    s = str2num(s); % ��������� � �����
    if ~isempty(s)
        hrz(k,1:sum(ind)) = s(ind);
        k = k+1;
    end
    if isempty(N) && k == 10^4+1 % ����������� �������� �������, ����� ������� ������ ���������
        m.hrz = single([m.hrz; hrz]);
        hrz = zeros(10^4,1);
        k = 1;
    end
    if k == N % ���� N �� ������, �� ��� � ������ VIEW ��������
        break
    end
end

ind = any(hrz,2);
hrz = hrz(ind,:);
if isempty(N)
    m.hrz = single([m.hrz; hrz]); % ���� �� ������, �� ������ �� ������� matfile
elseif ~isempty(N)
    m = hrz; % ���� �� �� ������, �� ������ �� ������� ��������
end

fclose all;