
using QEDbase
using StaticArrays
using BenchmarkTools

struct CustomType<:FieldVector{4,Float64}
    t::Float64
    x::Float64
    y::Float64
    z::Float64
end

@inline QEDbase.getT(lv::CustomType) = lv.t
@inline QEDbase.getX(lv::CustomType) = lv.x
@inline QEDbase.getY(lv::CustomType) = lv.y
@inline QEDbase.getZ(lv::CustomType) = lv.z


)


#QEDbase.LorentzVectorStyle(::CustomType) = QEDbase.IsLorentzVectorLike()

QEDbase.register_LorentzVectorLike(CustomType)

#hasmethod(QEDbase.getT,Tuple{CustomType})

a = CustomType(rand(4)...)
b = CustomType(rand(4)...)


getT(a)


mdot(a,b)

@benchmark mdot($a,$b)

m = 1.0
E = 1.2
rho = sqrt(E^2 - m^2)
th = 0.2
ph = 0.1

P = CustomType(E,rho*cos(ph)*sin(th),rho*sin(ph)*sin(th),rho*cos(th))

P

QEDbase.getPhi(P)

@benchmark QEDbase.getPhi($P)

@benchmark QEDbase.getTheta($P)

@benchmark QEDbase.getMass($P)

iP = CustomType(1.0,0,0,2.0)

@benchmark QEDbase.getMass($iP)


@benchmark QEDbase.getGamma($P)

@benchmark QEDbase.getPlus($P)
@benchmark QEDbase.getMinus($P)

@benchmark QEDbase.getRapidity($P)


mutable struct CustomType2
    t::Float64
    x::Float64
    y::Float64
    z::Float64
end



@inline QEDbase.getT(lv::CustomType2) = lv.t
@inline QEDbase.getX(lv::CustomType2) = lv.x
@inline QEDbase.getY(lv::CustomType2) = lv.y
@inline QEDbase.getZ(lv::CustomType2) = lv.z


# needs to be implemented if it shall work together with other LorentzVectorLike 
Base.convert(::Type{CustomType2},x::CustomType) = CustomType2(x.t,x.x,x.y,x.z)
Base.promote_rule(::Type{CustomType2},::Type{CustomType}) = CustomType2

QEDbase.register_LorentzVectorLike(CustomType2)

m = 1.0
E = 1.2
rho = sqrt(E^2 - m^2)
th = 0.2
ph2 = 0.1


mP = CustomType2(E,rho*cos(ph2)*sin(th),rho*sin(ph2)*sin(th),rho*cos(th))

@benchmark QEDbase.getPlus($mP)
@benchmark QEDbase.getRapidity($mP)



@benchmark QEDbase.mdot($mP,$P)

QEDbase.mdot(mP,P)


mutable struct CustomType3 <: FieldVector{4,Float64}
    t::Float64
    x::Float64
    y::Float64
    z::Float64
end

@inline QEDbase.getT(lv::CustomType3) = lv.t
@inline QEDbase.getX(lv::CustomType3) = lv.x
@inline QEDbase.getY(lv::CustomType3) = lv.y
@inline QEDbase.getZ(lv::CustomType3) = lv.z


function QEDbase.setT!(lv::CustomType3,value::Float64)
    lv.t = value
end

function QEDbase.setX!(lv::CustomType3,value::Float64)
    lv.x = value
end

function QEDbase.setY!(lv::CustomType3,value::Float64)
    lv.y = value
end

function QEDbase.setZ!(lv::CustomType3,value::Float64)
    lv.z = value
end


#Base.promote_rule(::Type{CustomType3},::Type{CustomType}) = CustomType3

hasmethod(QEDbase.setX!,Tuple{CustomType3,Union{}})


QEDbase.register_LorentzVectorLike(CustomType3)

m = 1.0
E = 1.2
rho = sqrt(E^2 - m^2)
th = 0.2
ph2 = 0.1


smP = CustomType3(E,rho*cos(ph2)*sin(th),rho*sin(ph2)*sin(th),rho*cos(th))

QEDbase.setE!(smP,1.5)

QEDbase.getE(smP)

new_theta = 0.7
QEDbase.setTheta!(smP,new_theta)

QEDbase.getTheta(smP)

@benchmark QEDbase.setTheta!($smP,$new_theta)


@code_lowered QEDbase.mdot(mP,P)
@code_typed QEDbase.mdot(mP,P)
@code_warntype QEDbase.mdot(mP,P)
@code_llvm QEDbase.mdot(mP,P)
@code_native QEDbase.mdot(P,P)

