__precompile__()

module DiffEqWebBase
  using OrdinaryDiffEq, DiffEqBase

  import DiffEqBase: build_solution

  immutable QuickODEProblem{uType,tType,isinplace} <: AbstractODEProblem{uType,tType,isinplace,Function}
    f::Function
    u0::uType
    tspan::Tuple{tType,tType}
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


  type QuickSDEProblem{uType,tType,isinplace,NoiseClass,F3} <: AbstractSDEProblem{uType,tType,isinplace,NoiseClass,Function,Function,F3}
    f::Function
    g::Function
    u0::uType
    tspan::Tuple{tType,tType}
    noise::DiffEqBase.NoiseProcess{NoiseClass,F3}
  end

  export QuickODEProblem, QuickODESolution,QuickSDEProblem
end
