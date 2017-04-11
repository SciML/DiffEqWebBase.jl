__precompile__()

module DiffEqWebBase
  using OrdinaryDiffEq, DiffEqBase

  import DiffEqBase: build_solution

  immutable QuickODEProblem{uType,tType,isinplace} <: AbstractODEProblem{uType,tType,isinplace}
    f::Function
    u0::uType
    tspan::Tuple{tType,tType}
    callback::C
  end

  function QuickODEProblem(f,u0,tspan)
    callback = CallbackSet()
    QuickODEProblem{typeof(u0),eltype(tspan),true,typeof(callback)}(f,u0,tspan,callback)
  end

  immutable QuickODESolution{uType,tType,rateType,P,A} <: AbstractODESolution
    u::uType
    t::tType
    k::rateType
    prob::P
    alg::A
    interp::OrdinaryDiffEq.InterpolationData
    dense::Bool
    tslocation::Int
  end
  (sol::QuickODESolution)(t) = sol.interp(t)

  function build_solution{uType,tType,isinplace}(
          prob::QuickODEProblem{uType,tType,isinplace},
          alg,t,u;dense=false,
          k=[],interp = (tvals) -> nothing,kwargs...)
    QuickODESolution(u,t,k,prob,alg,interp,dense,0)
  end


  type QuickSDEProblem{uType,tType,isinplace,NoiseClass,F3,C,ND} <: AbstractSDEProblem{uType,tType,isinplace,NoiseClass,ND}
    f::Function
    g::Function
    u0::uType
    tspan::Tuple{tType,tType}
    noise::DiffEqBase.NoiseProcess{NoiseClass,F3}
    callback::C
    noise_rate_prototype::ND
  end

  function QuickSDEProblem(f,g,u0,tspan)
    noise = INPLACE_WHITE_NOISE
    callback = CallbackSet()
    noise_rate_prototype = nothing
    QuickSDEProblem{typeof(u0),eltype(tspan),true,true,:White,typeof(noise.noise_func),typeof(callback),typeof(noise_rate_prototype)}(f,g,u0,tspan,noise,callback,noise_rate_prototype)
  end

  export QuickODEProblem, QuickODESolution,QuickSDEProblem
end
