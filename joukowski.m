%Domain Size
ymin = -1;
ymax = 1;
xmin = -3;
xmax = 3;
%Number of points
Nr = 400;
Nt = 400;

c = -0.5;
U = 1;

% PARAMETERS
R = -1.05*c;        %Radius of Circle i.e. thickness ratio
beta = 0.05;        %Camber angle
alpha = 0.05        % Angle of attach

%make the grid
b =-(R*exp(-i*beta)+c) ;    %Circle Center
r = linspace(R,20,Nr);          
theta = linspace(0,2*pi,Nt);    
[r,theta] = meshgrid(r,theta);
x = r.*cos(theta) + real(b);
y = r.*sin(theta) + imag(b);

z = x+1j*y;

%Circulation for Kutta condition
Gamma = -4.*pi.*U.*R.*sin(alpha+asin(imag(b)./R));

%Streamfunction f
f = (U.*((z-b).*exp(-i.*alpha)+R.^2.*exp(i.*alpha)./(z-b))-i.*Gamma./(2.*pi).*log((z-b)/R));
z = (z+c.^2./z)*exp(-0j*(alpha+asin(imag(b)./R)));

levels= linspace(-1.5,1.5,51);

clf
contourf(real(z),imag(z),imag(f),levels);
hold on
contour(real(z),imag(z),imag(f),[-1e-16,0,1e-16],'k');
hold off
axis([xmin xmax ymin ymax])

%%
clf
z = x+1j*y;
%f3 = U -i V - Velocity
f3 = U.*(1.*exp(-i*alpha)-R.^2.*exp(i*alpha)./((z-b).^2)-i*Gamma.*exp(-i*alpha)./(2.*pi.*(z-b)))./(1-c.^2./z.^2);
%f4 = sqrt(U^2 + V^2) - Velocity Abs
f4 = 2*U*(sin(theta-alpha)+sin(alpha)+beta).*abs(z)./abs(z-c.^2./z).*exp(i*alpha);
z = z+c.^2./z;

figure(1)
contourf(real(z),imag(z),real(f3),levels)
hold on
plot3(real(z(:,1)),imag(z(:,1)),real(z(:,1))./real(z(:,1)),'k','LineWidth',2)
quiver(real(z(1:end,2)),imag(z(:,2)),real(f3(:,2)),-imag(f3(:,2)),1,'k.','LineWidth',2)

hold off

axis([xmin xmax ymin ymax])
figure(2)

%plot(real(z(:,1)),1-abs(f2(:,1)).^2,'r-o')
hold on
%plot(real(z(:,1)),abs(f3(:,1)),'m-o')
plot(real(z(:,1)),1-abs(f4(:,1)).^2,'b-o')
axis([-2*R 2*R -4 4])
xlabel('x')
ylabel('Cp')
%quiver(real(z),imag(z),
