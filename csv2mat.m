function csv2mat(csvInput, csvEndRow)
%CSV2MAT Convert CSV file to MAT file.
%   CSV2MAT(CSVINPUT) Reads data from CSVINPUT file using importfile function
%   and writes to MAT file. Names of both input and output file are the same.
%   CSVENDROW is set to 125004 and this value is passed to IMPORTFILE
%   function as its ENDROW.
%
%   CSV2MAT(CSVINPUT, CSVENDROW) Reads data from CSVINPUT file using
%   importfile function and writes to MAT file. Names of both input and
%   output file are the same. CSVENDROW value is passed to IMPORTFILE
%   function and used as its ENDROW.
%
% Example:
%   csv2mat('ExampleFile.csv');
%   csv2mat('ExampleFile.csv',250004);
%
% See also IMPORTFILE.

% Created by ME on 2018/10/29 11:45:05
if nargin < 1
    error('Ta funkcja wymaga parametru w postaci nazwy pliku.');
else
    if nargin < 2
        endRow = 125004;
    else
        endRow = csvEndRow;
    end
   if ~ischar(csvInput)
       error('Jako parametr musisz podaæ nazwê pliku w formie ''nazwa.csv''.');
   else
       fprintf('Wczytywanie pliku %s...\n',csvInput);
       tic;
       x = importfile(csvInput,5,endRow);
       outputFileName = csvInput(1:end-4);
       outputFileFullName = strcat(outputFileName,'.mat');
       fprintf('Zapisywanie pliku %s...\n',outputFileFullName);
       save(outputFileFullName,'x');
       elapsedTime = toc;
       fprintf('Operacja konwersji trwa³a %.2f s.\n',elapsedTime);
   end
end