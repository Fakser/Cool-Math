
learning_rate = 0.01;
A = [1 -1 0 0 0 0; 0 0 1 -1 0 0; 0 0 0 0 1 -1];
lagrange = rand(3,1)';

A1 = A(1:3,1:2);
A2 = A(1:3,3:4);
A3 = A(1:3,5:6);

% vector ( v12,  v23  , v31  ,m11 , m12 , m21, m22 ,m31, m32)
ub = [7,1,1,5,5,7,5,5,3,2,2,1]';
lb = [0,0,0,0,0,0,0,0,0,0,0,0]';
vm = rand(12,1);

f_val=inf;
f_val_prev=0;
i = 0;
while abs(f_val-f_val_prev)>0.001
    %wyznaczamy m, v dla danej iteracji
    f_val_prev=f_val;
    m_opt=zeros(6,1);
    v_opt = zeros(6,1);
    x1= fmincon( @p1, vm, [], [], [], [], lb, ub) + lagrange*A1*vm(1:2);
    m_opt(1:2) = x1(7:8);
    v_opt(1:2) = x1(1:2);
    x2 = fmincon( @p2, vm, [], [], [], [], lb, ub ) + lagrange*A2*vm(3:4);
    m_opt(3:4) = x2(9:10);
    v_opt(3:4) = x1(3:4);
    x3 = fmincon( @p3, vm, [], [], [], [], lb, ub ) + lagrange*A3*vm(5:6);
    m_opt(5:6) = x3(11:12);
    v_opt(5:6) = x1(5:6);
    
    % liczymy performence index iteracji
    lb_coord = lb;
    lb_coord(1:6) = v_opt;
    lb_coord(7:12) = m_opt;
    ub_coord = ub;
    ub_coord(1:6) = v_opt;
    ub_coord(7:12) = m_opt;
    
    [vm_opt,f_val]=fmincon(@Q, vm, [], [], [], [], lb_coord,ub_coord);
    i=i+1;
    
    % gradient descent
    
    lagrange(1) = lagrange(1) - learning_rate*(vm(2) - vm(1));
    lagrange(2) = lagrange(2) - learning_rate*(vm(4) - vm(3));
    lagrange(3) = lagrange(3) - learning_rate*(vm(6) - vm(5));
    i=i+1;
end
f_val
i
vm_opt


% vector = [v1in, v1out, v2in, v2out, v3in, v3out, m11, m12, m21, m22, m31, m32];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x=Q(vector)
x= p1(vector)+p2(vector)+p3(vector); %max = -min; p1,p2 and p3 are negative and Q is negative, therefore it gives a plus at the end
end

function x=p1(vector)
v1in = vector(1);
v1out = vector(2);
m11=vector(7);
m12=vector(8);
x= -(-(v1in - 2)^2 - 2*(v1out - 3)^2 - v1in*m12 - (m11 - v1out)^2 + m11 + 40);
end

function x=p2(vector)
v2in=vector(3);
v2out =vector(4);
m21 = vector(9);
m22=vector(10);
x=-(-3*(v2in - 4)^2 - (v2out - 1)^2 + v2out*m21 - (m22 - v2in)^2 - m22 + 20);
end


function x=p3(vector)
v3in =vector(5);
v3out = vector(6);
m31 = vector(11);
m32 = vector(12);
x=-(-2*(v3in - 5)^2 - 4*(v3out - 1)^2 - v3in*m31 - (m32 - v3out)^2 + m32 + 30);
end
