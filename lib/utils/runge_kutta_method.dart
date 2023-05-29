void main () {
  double x0 = 0;
  double xn = 5;
  double y0 =1;
  int n = 5;
  double yn = y0;
  double k1, k2, k3, k4;

  double h = (xn-x0)/n;

  double f1(double x, double y){
    return y;
  }

  double f2(double x, double y){
    return 2*y*y*(1-4*x*x*y);
  }

  for(int i = 0; i < n; i++){
    k1 = f1(x0, y0);
    k2 = f1(x0 + h/3, y0 + h/3*k1);
    k3 = f1(x0 + h*2/3, y0 - h/3*k1 + h*k2);
    k4 = f1(x0 + h, y0 + h*k1 - h*k2+h*k3);
    yn = y0 + h*(k1+3*k2+3*k3+k4)/8;
    print('yn: $yn');

    k1 = f2(x0, yn);
    k2 = f2(x0 + h/3, yn + h/3*k1);
    k3 = f2(x0 + h*2/3, yn - h/3*k1 + h*k2);
    k4 = f2(x0 + h, yn + h*k1 - h*k2+h*k3);
    double yn1 = yn + h*(k1+3*k2+3*k3+k4)/8;

    print('yn1: $yn1');

    print('Начальные y1:${1/(1+x0*x0)}');
    print('Начальные y2:${-2*x0/((1+x0*x0)*(1+x0*x0))}');
    x0 = x0+h;
    y0 = yn;


  }


}