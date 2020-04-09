% 函数1：kk即为倾斜角，传入参数出力时机、出力大小
function[kk] = w2_20190816(F, t)
	N = length(F);
	B = 0;
	B_s = 180;
	B_x = 0;
	[sum1, sum2] = jjjj(F, B);
	if sum1 == sum2, BB = 0; end
	if sum1~= sum2
		B = 90;
		for i = 1:10
		[sum1, sum2] = jjjj(F, B);
		if sum1 > sum2, B_x = B; end
		if sum1 < sum2, B_s = B; end
		if sum1 == sum2, BB = B; end
			B = (B_s + B_x) / 2;
		end
	end
	x = zeros(8, 1); d = zeros(8, 1);
	m = 3.6; g = 9.8; r = 0.2;
	A_f = zeros(8, 1); A_z = zeros(8, 1);
	sum_fd = 0; sum_zd = 0;
	sum_fx = 0; sum_zx = 0;
	num_f = 0; num_z = 0;
	k = (pi / 180) * 3.7096;
	for i = 1:8
		t(i) = t(i) - 0.1;
	end
	abs(t);
	for i = 1:8
		x(i) = 0.5 * (t(i) ^ 2) * ((F(i) * sin(k) - (m * g / 8)) / (m / 8));
		d(i) = r * cos(((360 * (i - 1) / 8) - BB) * pi / 180);
		if abs(x(i)) < 0.000000001, x(i) = 0; end
			if abs(d(i)) < 0.000000001, d(i) = 0; end
	end
	for i = 1:8
		if d(i) < 0
			sum_fd = sum_fd + d(i);
			sum_fx = sum_fx + x(i);
			A_f(i) = i;
		end
		if d(i) > 0
			sum_zd = sum_zd + d(i);
			sum_zx = sum_zx + x(i);
			A_z(i) = i;
		end
		if d(i) == 0,
			A_f(i) = 0;
			A_z(i) = 0;
		end
	end
	for i = 1:8
		if A_f(i)~= 0
			num_f = num_f + 1;
		end
		if A_z(i)~= 0
			num_z = num_z + 1;
		end
	end
	xl = sum_fx / num_f;
	xr = sum_zx / num_z;
	dl = sum_fd / num_f;
	dr = sum_zd / num_z;
	if xl < xr, c_x = xr - xl; end
	if xl > xr, c_x = xl - xr; end
	if dl < dr, c_d = dr - dl; end
	if dl > dr, c_d = dr - dl; end
	kk = (180 / pi) * atan(c_x / c_d);
end



% 函数2
function[sum1, sum2] = jjjj(F, B)
	N = length(F);
	sum1 = 0; sum2 = 0;
	num1 = 0; num2 = 0;
	a = 360 / N;
	jiao = ones(8, 1);
	n_1 = zeros(8, 1); n_2 = zeros(8, 1);
	for i = 1:8
		jiao(i) = a * (i - 1);
	end
	r1 = 180 + B; r2 = 0 + B; r3 = 180 + B; r4 = 360 + B;
	if r1 > 360, r1 = r1 - 360; end
	if r2 > 360, r2 = r2 - 360; end
	if r3 > 360, r3 = r3 - 360; end
	if r4 > 360, r4 = r4 - 360; end
	for i = 1:8
		if (jiao(i) < r1) && (jiao(i) >= r2)
			n_1(i) = i;
		else
			n_2(i) = i;
		end
	end
	for i = 1:8
		if n_1(i)~= 0, num1 = num1 + 1; end
		if n_2(i)~= 0, num2 = num2 + 1; end
	end
	b1 = zeros(8, 1); c1 = zeros(num1, 1);
	b2 = zeros(8, 1); c2 = zeros(num2, 1);
	m = 0;
	for i = 1:8
		if n_1(i)~= 0, b1(i) = i; end
	end
	for i = 1:8
		for j = i + 1 : 8
			if b1(i) > b1(j)
				tmp = b1(i);
				b1(i) = b1(j);
				b1(j) = tmp;
			end
		end
	end
	for i = 1:8
		if b1(i) == 0, m = m + 1; end
		if b1(i) ~= 0, c1(i - m) = n_1(b1(i)); end
	end
	m = 0;
	for i = 1:8
		if n_2(i)~= 0, b2(i) = i; end
	end
	for i = 1:8
		for j = i + 1 : 8
			if b2(i) > b2(j)
				tmp = b2(i);
				b2(i) = b2(j);
				b2(j) = tmp;
			end
		end
	end
	for i = 1:8
		if b2(i) == 0, m = m + 1; end
		if b2(i) ~= 0, c2(i - m) = n_2(b2(i)); end
	end
	if B == jiao(1) || B == jiao(2) || B == jiao(3) || B == jiao(4) || B == jiao(5) || B == jiao(6) || B == jiao(7) || B == jiao(8)
		t = 0;
		tt = 0;
	else
		t = F(c2(1));
		tt = F(c1(num1));
	end
	for i = 1:8
		flag1 = 0;
		flag2 = 0;
		if i == c2(1)
			sum1 = sum1 + t * (1 - (B / a));
			sum2 = sum2 + t * (B / a);
			flag1 = 1;
		end
		if i == c1(num1)
			sum1 = sum1 + tt * (B / a);
			sum2 = sum2 + tt * (1 - (B / a));
			flag2 = 1;
		end
		if n_1(i)~= 0
			sum1 = sum1 + F(i);
		end
		if n_2(i)~= 0
			sum2 = sum2 + F(i);
		end
		sum1 = sum1 - flag1 * tt;
		sum2 = sum2 - flag2 * t;
	end
end
