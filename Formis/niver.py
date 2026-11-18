
r = 54.9
c = 1.1
b = 25.9



print((r*4+b)*c)
print("real: "+str((r*4+b)*c-r*2))
print("previsto: "+str((r*4+b)*c-r*2*1.1))
tot = [
	b/4*c*2,(r+b/4)*c*2,0.1*r*2
]

print("recalculado: "+str(s := sum(tot)))
# print(s/2)

