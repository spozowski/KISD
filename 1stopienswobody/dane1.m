function xd = dane1(t,x)
global omega FM A

ff = FM*sin(omega*t);
xd = zeros(6,1);
B = [0;ff];

xd = A*x+B;

end