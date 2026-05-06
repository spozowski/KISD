function xd = dane1(t,x)
global omega FM A

ff = FM*sin(omega*t);
xd = zeros(4,1);
B = [0;ff;0;0];

xd = A*x+B;

end