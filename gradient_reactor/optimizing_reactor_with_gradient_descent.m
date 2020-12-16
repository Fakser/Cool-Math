options = optimoptions('fmincon', 'Display', 'off');
learning_rate = 0.01;


% vector ( v12,  v23  , v31  ,m11 , m12 , m21, m22 ,m31, m32, l1, l2, l3)
ub = [7,1,1,5,5,7,5,5,3,2,2,1, 1, 1, 1]';
lb = [0,0,0,0,0,0,0,0,0,0,0,0, 1, 1, 1]';
vm = cat(1, rand(12,1), ones(3,1));

f_val=inf;
f_val_prev=0;
i = 0;
while abs(f_val-f_val_prev)>0.01+
    %wyznaczamy v dla danej iteracji
    [x1, f1]= fmincon( @p1, vm, [], [], [], [], lb, ub, [], options);
    v_opt1 = x1(1:2);
    [x2, f2] = fmincon( @p2, vm, [], [], [], [], lb, ub, [], options);
    v_opt2 = x2(3:4);
    [x3, f3] = fmincon( @p3, vm, [], [], [], [], lb, ub, [], options);
    v_opt3 = x3(5:6);

    f_val_prev = f_val;
    f_val = -(f1 + f2 + f3);
    % [vm_opt,f_val]=fmincon(@Q, vm, [], [], [], [], lb_coord,ub_coord, [], options);
    i=i+1;
    v_opt = cat(2, v_opt1, v_opt2, v_opt3);
    % gradient descent
    
    vm(13) = vm(13) - learning_rate*(v_opt(2) - v_opt(3));
    vm(14) = vm(14) - learning_rate*(v_opt(4) - v_opt(5));
    vm(15) = vm(15) - learning_rate*(v_opt(6) - v_opt(1));
    lb(13:15) = vm(13:15);
    ub(13:15) = vm(13:15);
    
    i=i+1
    f_val
    abs(f_val-f_val_prev)
    
end
f_val
i
v_opt


% vector = [v1in, v1out, v2in, v2out, v3in, v3out, m11, m12, m21, m22, m31, m32, l1, l2, l3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function x=Q(vector)
% x= p1(vector)+p2(vector)+p3(vector); %max = -min; p1,p2 and p3 are negative and Q is negative, therefore it gives a plus at the end
% end

function x=p1(vector)
v1in = vector(1);
v1out = vector(2);
m11=vector(7);
m12=vector(8);
lambda12=vector(13);
lambda31=vector(15);
x= -(-(v1in - 2)^2 - 2*(v1out - 3)^2 - v1in*m12 - (m11 - v1out)^2 + m11 + 40 + lambda12*v1out - lambda31*v1in);
end

function x=p2(vector)
v2in=vector(3);
v2out =vector(4);
m21 = vector(9);
m22=vector(10);
lambda23=vector(14);
lambda12=vector(13);
x=-(-3*(v2in - 4)^2 - (v2out - 1)^2 + v2out*m21 - (m22 - v2in)^2 - m22 + 20 + lambda23*v2out - lambda12*v2in);
end


function x=p3(vector)
v3in =vector(5);
v3out = vector(6);
m31 = vector(11);
m32 = vector(12);
lambda31=vector(15);
lambda23=vector(14);
x=-(-2*(v3in - 5)^2 - 4*(v3out - 1)^2 - v3in*m31 - (m32 - v3out)^2 + m32 + 30 + lambda31*v3out - lambda23*v3in);
end
