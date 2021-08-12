function n_index = node_index(OPEN,xval,yval,zval)
%这个函数返回一个节点在列表中的位置索引
    i=1;
    while(OPEN(i,2) ~= xval || OPEN(i,3) ~= yval || OPEN(i,4) ~= zval )
        i=i+1;
    end
    n_index=i;
end