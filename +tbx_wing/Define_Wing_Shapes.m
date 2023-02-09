function Shapes = Define_Wing_Shapes(Numb, Numt)

syms x real

s(1) = x^2;
s(2) = x^3;
s(3) = x^4;

t(1) = x;
t(2) = x^2;

for i = 1:Numb
    Shapes.(['s',num2str(i)]) = s(i);
end

for i = 1:Numt
    Shapes.(['t',num2str(i)]) = t(i);
end


end