<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckRememberToken
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $token =$request->header('Authorization');
        $user=RegUser::where('remember_token',$token)->first();
        if(!user){
            return response()->json(['message'=>'Unauthoried'],401);
        }
        $request->setUserResolver(function()use($user)
        {
            return $user;
        });
           
        return $next($request);
    }
}
