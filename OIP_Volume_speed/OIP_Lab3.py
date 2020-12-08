import sympy as sym

v, gamma, mu, x_air, x_CO2 = sym.symbols('v gamma mu x_air x_CO2')
T = 22.4 + 273.14
vFW = 0.018
R = 8.314

v = 344.6428571428572
x_air = 1 - vFW - x_CO2
gamma = (28.97*1.0036*x_air + 18.01*1.863*vFW + 44.01*0.838*x_CO2)/(28.97*0.7166*x_air + 18.01*1.403*vFW + 44.01*0.649*x_CO2)
mu = 28.97*x_air + 18.01*vFW + 44.01*x_CO2

print(sym.solve(v**2 - (1000 * gamma * R * T / mu), x_CO2))
