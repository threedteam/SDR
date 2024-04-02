function [Is, bExist, bMat] = FillPoints(n, Is, bMat, colIdx)
%  FILLHOLES  Return the Is that the specific holes are filled
%  bExist表示还可能存在邻近点有n个以上点不空的空洞点
%  colIdx指示要处理的列
%  基数为1
bExist = 0;

%  确定需要填充的点
[h, w] = size(bMat);
row = find(bMat(:, colIdx) == 0);
cnt = size(row);

for j = 1 : cnt
    p = row(j);
    q = colIdx;
    switch p
        case 1
            switch q
                case 1
                    wt = bMat(p + 1, q) + bMat(p, q + 1);
                    if wt >= n
                        Is(p, q, :) = Is(p + 1, q, :) / wt + Is(p, q + 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
                case w
                    wt = bMat(p + 1, q) + bMat(p, q - 1);
                    if wt >= n
                        Is(p, q, :) = Is(p + 1, q, :) / wt + Is(p, q - 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
                otherwise
                    wt = bMat(p, q - 1) + bMat(p + 1, q) + bMat(p, q + 1);
                    if wt >= n
                        Is(p, q, :) = Is(p, q - 1, :) / wt + Is(p + 1, q, :) / wt + Is(p, q + 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
            end
        case h
            switch q
                case 1
                    wt = bMat(p - 1, q) + bMat(p, q + 1);
                    if wt >= n
                        Is(p, q, :) = Is(p - 1, q, :) / wt + Is(p, q + 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
                case w
                    wt = bMat(p - 1, q) + bMat(p, q - 1);
                    if wt >= n
                        Is(p, q, :) = Is(p - 1, q, :) / wt + Is(p, q - 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
                otherwise
                    wt = bMat(p, q - 1) + bMat(p - 1, q) + bMat(p, q + 1);
                    if wt >= n
                        Is(p, q, :) = Is(p, q - 1, :) / wt + Is(p - 1, q, :) / wt + Is(p, q + 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
            end
        otherwise
            switch q
                case 1
                    wt = bMat(p - 1, q) + bMat(p + 1, q) + bMat(p, q + 1);
                    if wt >= n
                        Is(p, q, :) = Is(p - 1, q, :) / wt + Is(p + 1, q, :) / wt + Is(p, q + 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
                case w
                    wt = bMat(p - 1, q) + bMat(p + 1, q) + bMat(p, q - 1);
                    if wt >= n
                        Is(p, q, :) = Is(p - 1, q, :) / wt + Is(p + 1, q, :) / wt+ Is(p, q - 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
                otherwise
                    wt = bMat(p - 1, q) + bMat(p, q - 1) + bMat(p + 1, q) + bMat(p, q + 1);
                    if wt >= n  %  这种情况不要求每个点都为1
                        Is(p, q, :) = Is(p - 1, q, :) / wt + Is(p, q - 1, :) / wt + Is(p + 1, q, :) / wt + Is(p, q + 1, :) / wt;
                        bMat(p, q) = 1;
                        bExist = 1;
                    end
            end
    end
end
end


