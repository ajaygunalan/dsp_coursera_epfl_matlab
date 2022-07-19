function out=myConv(a,h,zero)

temp=zeros(length(a),length(h));

for i=1:length(h)
    if i<=zero
        temp(:,i)=h(i)*[a(zero-i+1:end);zeros(zero-i,1)];
    else
        temp(:,i)=h(i)*[zeros(i-zero,1);a(1:end-(i-zero))];
    end
end
out=sum(temp,2);