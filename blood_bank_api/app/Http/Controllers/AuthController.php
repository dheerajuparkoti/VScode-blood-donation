<?php

namespace App\Http\Controllers;
use App\Models\Auth;
use App\Models\User;
use App\Models\RegDonor;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Laravel\Passport\Client;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;


class AuthController extends Controller
{

    /*
    public function login(Request $request)
{
    $validator = Validator::make($request->all(), [
        'identifier' => 'required',
        'password' => 'required',
    ]);

    if ($validator->fails()) {
        return response()->json(['error' => $validator->errors()], 401);
    }

    $user = User::where(function ($query) use ($request) {
        $query->where('username', $request->input('identifier'))
              ->orWhere('email', $request->input('identifier'));
    })
    ->first();

    // $user = User::where('username', request('username'))->first(); // use only username to login

    if (!$user || !Hash::check(request('password'), $user->password)) {
        return response()->json(['error' => 'Invalid credentials'], 401);
    }

      // Set the remember_token
      $user->remember_token = Str::random(60); // Or use any logic to generate a token
      $user->save();

    $token = $user->createToken('MyApp')->accessToken;
 
   // return response()->json(['token' => $token, 'user' => $user], 200);
    return response()->json(['token' => $token, 'user_id' => $user->id], 200);

}

*/


// retrieve both userId and donorId during login for using donorId across app


public function login(Request $request)
{

    $request->validate([
        'identifier'=>'required',
        'password'=>'required',
    ]);

    // $validator = Validator::make($request->all(), [
    //     'identifier' => 'required',
    //     'password' => 'required',
    // ]);

    // if ($validator->fails()) {
    //     return response()->json(['error' => $validator->errors()], 401);
    // }

    $user = User::where('username', $request->input('identifier'))
                ->orWhere('email', $request->input('identifier'))
                ->first();

    if (!$user) {
        return response()->json(['error' => 'User not found'], 404);
    }

    // Check if the user exists in reg_donor table
    $donor = RegDonor::where('email', $user->email)->first();
   

    if (!$donor) {
        return response()->json(['error' => 'You are not authorized to log in'], 401);
    }

    if (!Hash::check(request('password'), $user->password)) {
        return response()->json(['error' => 'Invalid credentials'], 401);
    }

    // Set the remember_token
    $rememberToken = Str::random(60); // Create a random token
    $user->remember_token = $rememberToken; // Assign the generated token to the user
    $user->save();

    $token = $user->createToken('MyApp')->accessToken;

    return response()->json(['token' => $token, 'userId' => $user->id, 'donorId' => $donor->donorId,'accountType'=>$user->accountType,'remember_token'=>$rememberToken], 200);
}


public function user(Request $request)
    {
        // Authenticated user information can be returned here
        return response()->json($request->user());
    }


public function logout(Request $request) {
    // Revoke the user's token
    $request->user()->token()->revoke();

    // Clear the remember_token
    $request->user()->update(['remember_token' => null]);

    // Log the user's logout information
    Log::info('User logged out', [
        'user_id' => $request->user()->id,
        'email' => $request->user()->email,
        'logout_time' => now()
    ]);

    return response()->json(['message' => 'Successfully logged out']);
}
}

