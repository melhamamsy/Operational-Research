#import Pkg 
#Pkg.add("JuMP") 
#Pkg.add("GLPK") 
#Pkg.add("Flux")

using JuMP
using GLPK


model = Model(with_optimizer(GLPK.Optimizer))

#
#Decision Variables: The contribution of each rack in each period
@variable(model,state[i=1:6,j=1:6],Bin)



#
# Cost per GB per rack
cost=[29.475, 29.475, 14.3, 50.2, 57, 106.2]
power =[7500,7500,5000,10000,10000,15000]
demand=[30000,30000,40000,40000,35000,35000]


# Constraints on the supply = demand 
for s=1:6
	@constraint(model,sum(state[s,i]*power[i] for i in 1:6) == demand[s])
end




# Constraints on max periods per Rack per day
for s=1:6
	@constraint(model,sum(state[:,s]) <= 4)
end



# Objective Function
@objective(model,Min, sum(sum(state[s,i]*cost[i] for i in 1:6) for s in 1:6) )

optimize!(model) 

println("\n Schedule: \n")
for s=1:6
	println(value.(state[s,:]))
end

println("\n-> What is the minimum cost?")
println(objective_value(model))





	


 