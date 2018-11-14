function [] = appendCsvHeader(csvPath, varargin)

    fulltext = fileread(csvPath);
    header = sprintf('%% %s\n', varargin{:});
    fulltext = sprintf('%s\n%s', header, fulltext);
    fid = fopen(csvPath,'w+');
    fprintf(fid, '%s',fulltext);
    fclose(fid);

end
