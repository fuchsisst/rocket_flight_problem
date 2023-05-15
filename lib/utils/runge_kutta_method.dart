// Версия №1 метода для 1 диф. уравнения

void rkmethod () {
  double x0 = 0;
  double xn = 0.4;
  double y0 = 1;
  int n = 2;
  double yn = y0;
  double k1, k2, k3, k4;

  double h = (xn-x0)/n;

  double f(double x, double y){
    return (y*y-x*x)/(y*y+x*x);
  }

  for(int i = 0; i < n; i++){
    k1 = f(x0, y0);
    k2 = f(x0 + h/3, y0 + h/3*k1);
    k3 = f(x0 + h*2/3, y0 - h/3*k1 + h/k2);
    k4 = f(x0 + h, y0 + h*k1 - h*k2+h*k3);
    yn = y0 + h*(k1+3*k2+3*k3+k4)/8;
    print('yn: $yn');
    x0 = x0+h;
    y0 = yn;

  }
}