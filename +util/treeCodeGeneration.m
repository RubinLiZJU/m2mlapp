function treeTable = treeCodeGeneration(matlabCode)

    parser     = util.MTreeCodeParser();
    treeStruct = parser.parseWithMTree(matlabCode);
    
    if numel(treeStruct) < 3
        error(['An app must have at least three blocks:\n' ...
               '(a) PUBLIC PROPERTIES (components);\n'     ...
               '(b) PRIVATE METHODS (createComponents);\n' ...
               '(c) PUBLIC METHODS (construct/delete).'])
    end
    
    % treeStruct >> treeTable
    templateStruct = struct('Access',    {}, ...
                        'Static',    {}, ... % Only for METHODS blocks
                        'Type',      {}, ...
                        'Items',     {}, ...
                        'Line',      {}, ...
                        'Column',    {}, ...
                        'EndLine',   {}, ...
                        'EndColumn', {});
    
    % Compatibility: standardize each struct to the template
    tableCell = cell(1, numel(treeStruct));
    for ii = 1:numel(treeStruct)
        thisStruct = treeStruct{ii};
        if ~isstruct(thisStruct)
            error('The %d-th result of mtree parsing is not a struct, actual type is %s.', ii, class(thisStruct));
        end
        standardizedStruct = templateStruct;
        fieldList = fieldnames(templateStruct);
        for jj = 1:numel(fieldList)
            if isfield(thisStruct, fieldList{jj})
                standardizedStruct.(fieldList{jj}) = thisStruct.(fieldList{jj});
            end
        end
        tableCell{ii} = standardizedStruct;
    end
    treeTable = struct2table([tableCell{:}]);

end