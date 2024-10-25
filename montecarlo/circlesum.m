function B = circlesum(Mp)
    dims = size(Mp, 1);
    if dims == 1
        B = sum(Mp .* circshift(Mp, -1));
    else
        shifted_rows = circshift(Mp, [-1, 0]);                                 
        shifted_cols = circshift(Mp, [0, -1]);
        result_rows = Mp .* shifted_rows;
        result_cols = Mp .* shifted_cols;
        B = sum(result_rows(:)) + sum(result_cols(:));
    end
end
